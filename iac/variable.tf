variable "project_id" {
    type = string
    description = "project_id"
}

variable "cred_file_path" {
  type = string
  description = "Service Account JSON Key file path"
}

variable "datasets" {
  type = map(object({
    dataset_id = string
    dataset_name = string
    description = string
    location = string
  }))
  description = "List of all datasets in the project"
  default = {
    "staging" = {
        dataset_id = "staging"
        dataset_name = "staging"
        description  = "BigQuery Staging Layer"
        location = "US"
    },
    "transformed" = {
        dataset_id = "transformed"
        dataset_name = "transformed"
        description  = "BigQuery Transformed Layer"
        location = "US"
    },
    "consumption" = {
        dataset_id = "consumption"
        dataset_name = "consumption"
        description  = "BigQuery Consumption Layer"
        location = "US"
    }
  }
}


variable "buckets" {
  type = map(object({
    bucket_name = string
    region = string
  }))
  default = {
    "dw_analytics_bucket" = {
      bucket_name = "dw_analytics_bucket"
      region = "US"
    }
  }
}