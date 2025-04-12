module "bigQuery" {
    source = "./bigQuery"
    project_id = var.project_id
    for_each   = var.datasets
    dataset_id = each.value.dataset_id
    dataset_name = each.value.dataset_name
    description = each.value.description
    location = each.value.location
}

resource "google_storage_bucket" "main" {
    for_each = var.buckets
    project =var.project_id
    name = each.value.bucket_name
    location = each.value.region
    uniform_bucket_level_access = true
    logging {
        log_bucket = "access_logs"
    }
} 