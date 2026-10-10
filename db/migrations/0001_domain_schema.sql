-- New Youth provider-neutral PostgreSQL domain schema.
-- Requires PostgreSQL 13+ (gen_random_uuid is built in).
-- Deliberately excludes provider-specific auth, RLS, storage, and deployment wiring.
BEGIN;

CREATE TABLE profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_subject text NOT NULL UNIQUE,
  display_name text,
  account_status text NOT NULL DEFAULT 'active'
    CHECK (account_status IN ('active', 'disabled', 'deletion_pending', 'anonymized')),
  last_meaningful_activity_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE roles (
  code text PRIMARY KEY CHECK (code IN ('contributor', 'reviewer', 'core_admin')),
  description text NOT NULL
);

INSERT INTO roles (code, description) VALUES
  ('contributor', 'May submit and manage own price reports'),
  ('reviewer', 'May review eligible assigned reports subject to conflict checks'),
  ('core_admin', 'Authorized core-team administrative access');

CREATE TABLE profile_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  role_code text NOT NULL REFERENCES roles(code) ON DELETE RESTRICT,
  granted_by_profile_id uuid REFERENCES profiles(id) ON DELETE RESTRICT,
  granted_at timestamptz NOT NULL DEFAULT now(),
  revoked_at timestamptz,
  CHECK (revoked_at IS NULL OR revoked_at >= granted_at)
);
CREATE UNIQUE INDEX profile_roles_one_active_idx
  ON profile_roles(profile_id, role_code) WHERE revoked_at IS NULL;

CREATE TABLE locations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  location_type text NOT NULL CHECK (location_type IN ('city', 'district', 'neighborhood', 'market', 'route_area')),
  parent_location_id uuid REFERENCES locations(id) ON DELETE RESTRICT,
  is_pilot_location boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (parent_location_id IS NULL OR parent_location_id <> id)
);

CREATE TABLE price_categories (
  code text PRIMARY KEY CHECK (code IN ('food', 'transport', 'housing', 'utilities', 'cooking_fuel')),
  name text NOT NULL,
  freshness_days integer NOT NULL CHECK (freshness_days > 0),
  collection_cadence text NOT NULL CHECK (collection_cadence IN ('weekly', 'monthly', 'targeted')),
  is_active boolean NOT NULL DEFAULT true
);

INSERT INTO price_categories (code, name, freshness_days, collection_cadence) VALUES
  ('food', 'Food', 14, 'weekly'),
  ('transport', 'Transport', 14, 'weekly'),
  ('housing', 'Housing', 45, 'monthly'),
  ('utilities', 'Utilities', 45, 'monthly'),
  ('cooking_fuel', 'Cooking fuel', 14, 'weekly');

CREATE TABLE units (
  code text PRIMARY KEY,
  name text NOT NULL,
  dimension text NOT NULL CHECK (dimension IN ('mass', 'volume', 'count', 'distance', 'time', 'fare', 'area', 'energy', 'other')),
  is_active boolean NOT NULL DEFAULT true
);

INSERT INTO units (code, name, dimension) VALUES
  ('kg', 'kilogram', 'mass'),
  ('g', 'gram', 'mass'),
  ('l', 'litre', 'volume'),
  ('ml', 'millilitre', 'volume'),
  ('each', 'each / item', 'count'),
  ('trip', 'trip', 'fare'),
  ('month', 'month', 'time'),
  ('week', 'week', 'time'),
  ('day', 'day', 'time');

CREATE TABLE price_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_code text NOT NULL REFERENCES price_categories(code) ON DELETE RESTRICT,
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  variant_description text,
  standard_unit_code text NOT NULL REFERENCES units(code) ON DELETE RESTRICT,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX price_items_category_idx ON price_items(category_code, is_active);

CREATE TABLE price_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  contributor_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE RESTRICT,
  item_id uuid NOT NULL REFERENCES price_items(id) ON DELETE RESTRICT,
  observed_at timestamptz NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  price_amount numeric(14,2) NOT NULL CHECK (price_amount > 0),
  currency_code char(3) NOT NULL DEFAULT 'SLE' CHECK (currency_code ~ '^[A-Z]{3}$'),
  quantity numeric(14,4) NOT NULL CHECK (quantity > 0),
  unit_code text NOT NULL REFERENCES units(code) ON DELETE RESTRICT,
  source_type text NOT NULL CHECK (source_type IN ('community_report', 'core_team_collection', 'documented_source')),
  status text NOT NULL DEFAULT 'received'
    CHECK (status IN ('received', 'under_review', 'awaiting_clarification', 'approved', 'rejected')),
  context jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(context) = 'object'),
  evidence_reference text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CHECK (observed_at <= submitted_at + interval '5 minutes')
);
CREATE INDEX price_reports_contributor_idx ON price_reports(contributor_profile_id, submitted_at DESC);
CREATE INDEX price_reports_review_queue_idx ON price_reports(status, submitted_at);
CREATE INDEX price_reports_item_location_time_idx ON price_reports(item_id, location_id, observed_at DESC);
CREATE INDEX price_reports_context_gin_idx ON price_reports USING gin(context);

-- Publication is a separate, explicit decision; approved reports are not public by default.
CREATE TABLE published_observations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES price_reports(id) ON DELETE RESTRICT,
  published_by_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  published_at timestamptz NOT NULL DEFAULT now(),
  unpublished_at timestamptz,
  publication_note text,
  CHECK (unpublished_at IS NULL OR unpublished_at >= published_at)
);
CREATE UNIQUE INDEX published_observations_one_current_idx
  ON published_observations(report_id) WHERE unpublished_at IS NULL;
CREATE INDEX published_observations_published_at_idx ON published_observations(published_at DESC);

CREATE FUNCTION enforce_publish_only_approved_report() RETURNS trigger
LANGUAGE plpgsql AS $
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM price_reports
    WHERE id = NEW.report_id AND status = 'approved'
  ) THEN
    RAISE EXCEPTION 'Only approved reports may be published';
  END IF;
  RETURN NEW;
END;
$;
CREATE TRIGGER published_observations_approved_guard
  BEFORE INSERT OR UPDATE OF report_id ON published_observations
  FOR EACH ROW EXECUTE FUNCTION enforce_publish_only_approved_report();

CREATE FUNCTION prevent_unapproving_published_report() RETURNS trigger
LANGUAGE plpgsql AS $
BEGIN
  IF NEW.status <> 'approved' AND EXISTS (
    SELECT 1 FROM published_observations
    WHERE report_id = OLD.id AND unpublished_at IS NULL
  ) THEN
    RAISE EXCEPTION 'Unpublish report before changing its status from approved';
  END IF;
  RETURN NEW;
END;
$;
CREATE TRIGGER price_reports_published_status_guard
  BEFORE UPDATE OF status ON price_reports
  FOR EACH ROW EXECUTE FUNCTION prevent_unapproving_published_report();

CREATE TABLE report_review_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES price_reports(id) ON DELETE RESTRICT,
  actor_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  from_status text CHECK (from_status IS NULL OR from_status IN ('received', 'under_review', 'awaiting_clarification', 'approved', 'rejected')),
  to_status text NOT NULL CHECK (to_status IN ('received', 'under_review', 'awaiting_clarification', 'approved', 'rejected')),
  reason_code text,
  note text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX report_review_events_report_idx ON report_review_events(report_id, created_at);

CREATE TABLE report_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES price_reports(id) ON DELETE RESTRICT,
  reviewer_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  assigned_by_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  assigned_at timestamptz NOT NULL DEFAULT now(),
  unassigned_at timestamptz,
  conflict_declared boolean NOT NULL DEFAULT false,
  conflict_note text,
  CHECK (unassigned_at IS NULL OR unassigned_at >= assigned_at)
);
CREATE UNIQUE INDEX report_assignments_one_active_idx ON report_assignments(report_id) WHERE unassigned_at IS NULL;
CREATE INDEX report_assignments_reviewer_idx ON report_assignments(reviewer_profile_id, assigned_at DESC);

CREATE TABLE report_corrections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES price_reports(id) ON DELETE RESTRICT,
  corrected_by_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  reason text NOT NULL CHECK (length(trim(reason)) > 0),
  previous_values jsonb NOT NULL CHECK (jsonb_typeof(previous_values) = 'object'),
  corrected_values jsonb NOT NULL CHECK (jsonb_typeof(corrected_values) = 'object'),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX report_corrections_report_idx ON report_corrections(report_id, created_at);

CREATE TABLE appeals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  appellant_profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  report_id uuid REFERENCES price_reports(id) ON DELETE RESTRICT,
  related_decision_event_id uuid REFERENCES report_review_events(id) ON DELETE RESTRICT,
  appeal_type text NOT NULL CHECK (appeal_type IN ('report_decision', 'account_restriction', 'suspension', 'other')),
  status text NOT NULL DEFAULT 'received'
    CHECK (status IN ('received', 'under_review', 'awaiting_clarification', 'upheld', 'partially_upheld', 'overturned', 'withdrawn')),
  reason text NOT NULL CHECK (length(trim(reason)) > 0),
  outcome_reason text,
  decided_by_profile_id uuid REFERENCES profiles(id) ON DELETE RESTRICT,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  decided_at timestamptz,
  CHECK (decided_at IS NULL OR decided_at >= submitted_at),
  CHECK (decided_by_profile_id IS NULL OR decided_by_profile_id <> appellant_profile_id)
);
CREATE INDEX appeals_status_idx ON appeals(status, submitted_at);

CREATE TABLE methodology_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL UNIQUE,
  title text NOT NULL,
  description text NOT NULL,
  rules jsonb NOT NULL CHECK (jsonb_typeof(rules) = 'object'),
  effective_from timestamptz NOT NULL,
  effective_to timestamptz,
  created_by_profile_id uuid REFERENCES profiles(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (effective_to IS NULL OR effective_to > effective_from)
);

CREATE TABLE estimate_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  methodology_version_id uuid NOT NULL REFERENCES methodology_versions(id) ON DELETE RESTRICT,
  category_code text REFERENCES price_categories(code) ON DELETE RESTRICT,
  location_id uuid REFERENCES locations(id) ON DELETE RESTRICT,
  period_start date NOT NULL,
  period_end date NOT NULL,
  generated_at timestamptz NOT NULL DEFAULT now(),
  status text NOT NULL CHECK (status IN ('draft', 'published', 'suppressed', 'corrected', 'withdrawn')),
  evidence_tier text NOT NULL CHECK (evidence_tier IN ('strong', 'limited', 'insufficient')),
  observation_count integer NOT NULL DEFAULT 0 CHECK (observation_count >= 0),
  coverage jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(coverage) = 'object'),
  limitations jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_typeof(limitations) = 'array'),
  CHECK (period_end >= period_start)
);
CREATE INDEX estimate_runs_lookup_idx ON estimate_runs(category_code, location_id, period_end DESC, generated_at DESC);

-- Every published estimate run can retain exactly which publication records supported it.
CREATE TABLE estimate_run_observations (
  estimate_run_id uuid NOT NULL REFERENCES estimate_runs(id) ON DELETE RESTRICT,
  published_observation_id uuid NOT NULL REFERENCES published_observations(id) ON DELETE RESTRICT,
  PRIMARY KEY (estimate_run_id, published_observation_id)
);
CREATE INDEX estimate_run_observations_source_idx ON estimate_run_observations(published_observation_id);

CREATE TABLE estimate_values (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estimate_run_id uuid NOT NULL REFERENCES estimate_runs(id) ON DELETE RESTRICT,
  metric_code text NOT NULL,
  item_id uuid REFERENCES price_items(id) ON DELETE RESTRICT,
  value_numeric numeric(18,4) NOT NULL,
  currency_code char(3) CHECK (currency_code IS NULL OR currency_code ~ '^[A-Z]{3}$'),
  unit_code text REFERENCES units(code) ON DELETE RESTRICT,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(metadata) = 'object'),
  UNIQUE (estimate_run_id, metric_code, item_id)
);
CREATE INDEX estimate_values_run_idx ON estimate_values(estimate_run_id);

CREATE TABLE standard_baskets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL,
  version text NOT NULL,
  name text NOT NULL,
  description text,
  effective_from date NOT NULL,
  effective_to date,
  status text NOT NULL CHECK (status IN ('draft', 'active', 'retired')),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (code, version),
  CHECK (effective_to IS NULL OR effective_to > effective_from)
);

CREATE TABLE standard_basket_items (
  basket_id uuid NOT NULL REFERENCES standard_baskets(id) ON DELETE RESTRICT,
  item_id uuid NOT NULL REFERENCES price_items(id) ON DELETE RESTRICT,
  quantity numeric(14,4) NOT NULL CHECK (quantity > 0),
  unit_code text NOT NULL REFERENCES units(code) ON DELETE RESTRICT,
  PRIMARY KEY (basket_id, item_id)
);

CREATE TABLE simulator_scenarios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_profile_id uuid REFERENCES profiles(id) ON DELETE RESTRICT,
  scenario_kind text NOT NULL CHECK (scenario_kind IN ('affordability', 'savings', 'purchasing_power')),
  title text NOT NULL,
  inputs jsonb NOT NULL CHECK (jsonb_typeof(inputs) = 'object'),
  assumptions jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(assumptions) = 'object'),
  methodology_version_id uuid REFERENCES methodology_versions(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
CREATE INDEX simulator_scenarios_owner_idx ON simulator_scenarios(owner_profile_id, updated_at DESC) WHERE deleted_at IS NULL;

CREATE TABLE audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_profile_id uuid REFERENCES profiles(id) ON DELETE RESTRICT,
  event_type text NOT NULL,
  subject_type text NOT NULL,
  subject_id uuid,
  outcome text NOT NULL CHECK (outcome IN ('success', 'denied', 'failure')),
  details jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(details) = 'object'),
  occurred_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX audit_events_subject_idx ON audit_events(subject_type, subject_id, occurred_at DESC);
CREATE INDEX audit_events_actor_idx ON audit_events(actor_profile_id, occurred_at DESC);

COMMIT;
