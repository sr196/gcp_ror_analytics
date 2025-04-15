locals {
  project_id            = var.project_id
  region                = "us-central1"
  service_account_email = var.service_account_email
#   all_entries = fileset(path.module, "*")
#   folders     = [for entry in local.all_entries: entry if can(regex("^.*/$", entry))]
}

# module "project-services" {
#   source  = "terraform-google-modules/project-factory/google//modules/project_services"
#   version = "~> 14.4"

#   project_id = local.project_id
#   activate_apis = [
#     "cloudfunctions.googleapis.com",
#     "pubsub.googleapis.com",
#     "eventarc.googleapis.com",
#     "run.googleapis.com",
#     "cloudbuild.googleapis.com",
#     "storage.googleapis.com"
#   ]
#   disable_services_on_destroy = false
# }

resource "google_storage_bucket" "cloud_function_source_bucket" {
  name                        = "cloud-functions-${local.project_id}"
  location                    = local.region
  force_destroy               = true
  uniform_bucket_level_access = true
  project = local.project_id
}

data "archive_file" "source" {
    # for_each = toset(local.folders)
    # type        = "zip"
    # output_path = "${path.module}/${each.value}_archive.zip"
    # source_dir  = "${path.module}/${each.value}"

    type = "zip"
    output_path = "${path.module}/cf_gcs_to_bq_archive.zip"
    source_dir = "${path.module}/cf_gcs_to_bq/"
}

resource "google_storage_bucket_object" "zip" {
    # for_each     = data.archive_file.source
    # source       = each.value.output_path
    # content_type = "application/zip"
    # name         = basename(each.value.output_path)
    # bucket       = google_storage_bucket.cloud_function_source_bucket.name
    # depends_on   = [
    #     google_storage_bucket.cloud_function_source_bucket,
    #     data.archive_file.source
    # ]

    source = data.archive_file.source.output_path
    content_type = "application/zip"
    name = basename(data.archive_file.source.output_path)
    bucket = google_storage_bucket.cloud_function_source_bucket.name
    depends_on = [ google_storage_bucket.cloud_function_source_bucket, data.archive_file.source ]
}

resource "google_cloudfunctions2_function" "cf_gcs_to_bq" {
  name        = "cf_gcs_to_bq"
  location    = local.region
  project     = local.project_id
  description = "Cloud function to load JSON file from GCS bucket to BigQuery Staging table"

  build_config {
    runtime     = "python312"
    entry_point = "hello_http"

    source {
      storage_source {
        bucket = google_storage_bucket.cloud_function_source_bucket.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    min_instance_count = 0
    available_memory   = "256M"
    timeout_seconds    = 60
    ingress_settings    = "ALLOW_ALL"
    all_traffic_on_latest_revision = true
    service_account_email          = local.service_account_email
  }
  depends_on = [
    google_storage_bucket.cloud_function_source_bucket,
    google_storage_bucket_object.zip
  ]

}

resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = google_cloudfunctions2_function.cf_gcs_to_bq.project
  location       = google_cloudfunctions2_function.cf_gcs_to_bq.location
  cloud_function = google_cloudfunctions2_function.cf_gcs_to_bq.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}


resource "google_cloudfunctions2_function_iam_binding" "main" {
    cloud_function = google_cloudfunctions2_function.cf_gcs_to_bq.name
    role = "roles/cloudfunctions.invoker"
    members = ["allUsers"]
    project = local.project_id
    location = local.region
    depends_on = [
        google_cloudfunctions2_function.cf_gcs_to_bq
  ]
}
