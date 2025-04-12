locals {
  # Collect all SQL files in subdirectories under 'bq'
  sql_files = fileset("${path.module}", "**/*.sql")
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id  = var.dataset_id
  friendly_name = var.dataset_name
  description = var.description
  location = var.location
  project = var.project_id
}
