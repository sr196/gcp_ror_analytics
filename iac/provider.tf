provider "google" {
    credentials = file(var.cred_file_path)
}