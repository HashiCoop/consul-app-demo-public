provider "google" {
  project     = "cmelgreen-consul-mesh-test"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = "consul-autopilot"
  location = "us-central1"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )

  alias = "gcp"
}