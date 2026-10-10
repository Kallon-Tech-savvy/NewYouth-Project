-- Roll back db/migrations/0001_domain_schema.sql.
-- Destructive: this removes all schema data created by that migration.
BEGIN;

DROP TABLE IF EXISTS audit_events;
DROP TABLE IF EXISTS simulator_scenarios;
DROP TABLE IF EXISTS standard_basket_items;
DROP TABLE IF EXISTS standard_baskets;
DROP TABLE IF EXISTS estimate_values;
DROP TABLE IF EXISTS estimate_run_observations;
DROP TABLE IF EXISTS estimate_runs;
DROP TABLE IF EXISTS methodology_versions;
DROP TABLE IF EXISTS appeals;
DROP TABLE IF EXISTS report_corrections;
DROP TABLE IF EXISTS report_assignments;
DROP TABLE IF EXISTS report_review_events;
DROP TABLE IF EXISTS published_observations;
DROP TABLE IF EXISTS price_reports;
DROP FUNCTION IF EXISTS prevent_unapproving_published_report();
DROP FUNCTION IF EXISTS enforce_publish_only_approved_report();
DROP TABLE IF EXISTS price_items;
DROP TABLE IF EXISTS units;
DROP TABLE IF EXISTS price_categories;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS profile_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS profiles;

COMMIT;
