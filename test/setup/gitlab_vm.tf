module "gitlab_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"


  name                     = "eab-gitlab-self-hosted"
  random_project_id        = "true"
  random_project_id_length = 4
  org_id                   = var.org_id
  folder_id                = var.folder_id
  billing_account          = var.billing_account
  deletion_policy          = "DELETE"
  default_service_account  = "KEEP"

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbilling.googleapis.com"
  ]

  activate_api_identities = [
    {
      api   = "compute.googleapis.com",
      roles = []
    },
  ]
}

resource "google_service_account" "gitlab_vm" {
  account_id   = "gitlab-vm-sa"
  project      = module.gitlab_project.project_id
  display_name = "Custom SA for VM Instance"
}

resource "google_project_iam_member" "secret_manager_admin" {
  project = module.gitlab_project.project_id
  role    = "roles/secretmanager.admin"
  member  = google_service_account.gitlab_vm.member
}

resource "google_compute_instance" "default" {
  name         = "gitlab"
  project      = module.gitlab_project.project_id
  machine_type = "n2-standard-4"
  zone         = "us-central1-a"

  tags = ["git-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("./scripts/gitlab_self_hosted.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.gitlab_vm.email
    scopes = ["cloud-platform"]
  }
}


resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"
  project = module.gitlab_project.project_id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["git-vm"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"
  project = module.gitlab_project.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["git-vm"]
}

resource "google_secret_manager_secret" "gitlab_webhook" {
  project   = module.gitlab_project.project_id
  secret_id = "gitlab-webhook"
  replication {
    auto {}
  }
}

resource "random_uuid" "random_webhook_secret" {
}

resource "google_secret_manager_secret_version" "gitlab_webhook" {
  secret      = google_secret_manager_secret.gitlab_webhook.id
  secret_data = random_uuid.random_webhook_secret.result
}

output "gitlab_webhook_secret_id" {
  value = google_secret_manager_secret.gitlab_webhook.secret_id
}

output "gitlab_pat_secret_name" {
  value = "gitlab-pat-from-vm"
}

output "gitlab_project_number" {
  value = module.gitlab_project.project_number
}

output "gitlab_url" {
  value = "https://${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}.nip.io"
}

output "gitlab_secret_project" {
  value = module.gitlab_project.project_id
}