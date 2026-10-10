-- Run only against a disposable PostgreSQL database after applying 0001_domain_schema.sql.
-- Example: psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/tests/0001_domain_schema_invariants.sql
BEGIN;

DO $$
DECLARE
  contributor_id uuid;
  reviewer_id uuid;
  location_id uuid;
  item_id uuid;
  report_id uuid;
  methodology_id uuid;
  estimate_id uuid;
  published_id uuid;
BEGIN
  IF (SELECT count(*) FROM price_categories) <> 5 THEN
    RAISE EXCEPTION 'Expected five seeded price categories';
  END IF;

  IF (SELECT count(*) FROM locations WHERE is_pilot_location) <> 2 THEN
    RAISE EXCEPTION 'Expected Freetown and Kenema as pilot locations';
  END IF;

  INSERT INTO profiles (auth_subject, display_name)
  VALUES ('test:contributor', 'Test contributor')
  RETURNING id INTO contributor_id;

  INSERT INTO profiles (auth_subject, display_name)
  VALUES ('test:reviewer', 'Test reviewer')
  RETURNING id INTO reviewer_id;

  INSERT INTO locations (code, name, location_type, is_pilot_location)
  VALUES ('test-location', 'Test location', 'city', true)
  RETURNING id INTO location_id;

  INSERT INTO price_items (category_code, code, name, standard_unit_code)
  VALUES ('food', 'test-rice', 'Test rice', 'kg')
  RETURNING id INTO item_id;

  INSERT INTO price_reports (
    contributor_profile_id, location_id, item_id, observed_at,
    price_amount, currency_code, quantity, unit_code, source_type, context
  ) VALUES (
    contributor_id, location_id, item_id, now(),
    100.00, 'SLE', 1, 'kg', 'community_report', '{"market":"test"}'::jsonb
  ) RETURNING id INTO report_id;

  -- Non-positive prices must fail at the database boundary.
  BEGIN
    INSERT INTO price_reports (
      contributor_profile_id, location_id, item_id, observed_at,
      price_amount, currency_code, quantity, unit_code, source_type
    ) VALUES (
      contributor_id, location_id, item_id, now(),
      0, 'SLE', 1, 'kg', 'community_report'
    );
    RAISE EXCEPTION 'Expected price_amount check constraint to reject zero';
  EXCEPTION WHEN check_violation THEN
    NULL;
  END;

  -- Unknown contributor references must fail.
  BEGIN
    INSERT INTO price_reports (
      contributor_profile_id, location_id, item_id, observed_at,
      price_amount, currency_code, quantity, unit_code, source_type
    ) VALUES (
      '00000000-0000-0000-0000-000000000001', location_id, item_id, now(),
      100, 'SLE', 1, 'kg', 'community_report'
    );
    RAISE EXCEPTION 'Expected invalid contributor foreign key to fail';
  EXCEPTION WHEN foreign_key_violation THEN
    NULL;
  END;

  -- Approval alone is not publication; pending reports cannot be published.
  BEGIN
    INSERT INTO published_observations (report_id, published_by_profile_id)
    VALUES (report_id, reviewer_id);
    RAISE EXCEPTION 'Expected publication trigger to reject a pending report';
  EXCEPTION WHEN raise_exception THEN
    IF SQLERRM = 'Expected publication trigger to reject a pending report' THEN
      RAISE;
    END IF;
  END;

  UPDATE price_reports SET status = 'under_review' WHERE id = report_id;
  INSERT INTO report_review_events (
    report_id, actor_profile_id, from_status, to_status, reason_code
  ) VALUES (report_id, reviewer_id, 'received', 'under_review', 'test_review_started');

  UPDATE price_reports SET status = 'approved' WHERE id = report_id;
  INSERT INTO report_review_events (
    report_id, actor_profile_id, from_status, to_status, reason_code
  ) VALUES (report_id, reviewer_id, 'under_review', 'approved', 'test_approval');

  INSERT INTO published_observations (report_id, published_by_profile_id)
  VALUES (report_id, reviewer_id)
  RETURNING id INTO published_id;

  -- A published report must be explicitly unpublished before status changes.
  BEGIN
    UPDATE price_reports SET status = 'rejected' WHERE id = report_id;
    RAISE EXCEPTION 'Expected published report status guard to reject status change';
  EXCEPTION WHEN raise_exception THEN
    IF SQLERRM = 'Expected published report status guard to reject status change' THEN
      RAISE;
    END IF;
  END;

  INSERT INTO methodology_versions (version, title, description, rules, effective_from)
  VALUES ('test-v1', 'Test methodology', 'Schema invariant test', '{}'::jsonb, now())
  RETURNING id INTO methodology_id;

  INSERT INTO estimate_runs (
    methodology_version_id, category_code, location_id, period_start, period_end,
    status, evidence_tier, observation_count
  ) VALUES (
    methodology_id, 'food', location_id, current_date, current_date,
    'draft', 'limited', 1
  ) RETURNING id INTO estimate_id;

  INSERT INTO estimate_run_observations (estimate_run_id, published_observation_id)
  VALUES (estimate_id, published_id);

  IF NOT EXISTS (
    SELECT 1 FROM estimate_run_observations
    WHERE estimate_run_id = estimate_id AND published_observation_id = published_id
  ) THEN
    RAISE EXCEPTION 'Estimate source lineage was not persisted';
  END IF;
END;
$$;

ROLLBACK;
