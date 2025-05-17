resource "google_compute_network" "tiiva_service_vpc_network" {
  name                    = "${var.tenant_name}-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tiiva_service_private_subnet" {
  name                     = "${var.tenant_name}-private-subnet"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = var.gcp_region
  network                  = google_compute_network.tiiva_service_vpc_network.id
  private_ip_google_access = true # Enable Private Google Access
}

resource "google_vpc_access_connector" "tiiva_service_private_connector" {
  name          = var.tenant_name
  region        = var.gcp_region
  network       = google_compute_network.tiiva_service_vpc_network.name
  ip_cidr_range = "10.8.0.0/28" # Adjust CIDR range as needed

  max_instances = 3 # Number of instances (adjust as needed)
  min_instances = 2

  depends_on = [google_compute_firewall.allow_cloud_run_access]
}

resource "google_compute_router" "tiiva_service_nat_router" {
  name    = "${var.tenant_name}-nat-router"
  region  = var.gcp_region
  network = google_compute_network.tiiva_service_vpc_network.id
}

resource "google_compute_router_nat" "tiiva_service_nat_gateway" {
  name                               = "${var.tenant_name}-nat-gateway"
  region                             = var.gcp_region
  router                             = google_compute_router.tiiva_service_nat_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"                     # Automatically allocate external IPs
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" # Allow all subnets
}

resource "null_resource" "fetch_public_ip" {
  provisioner "local-exec" {
    command = "curl -s https://ipinfo.io/ip > public_ip.txt"
  }
}

locals {
  machine_public_ip = fileexists("public_ip.txt") ? trim(file("public_ip.txt"), " \t\n\r") : "0.0.0.0/0"
}

# Determine the source range
locals {
  effective_source_range = var.tenant_authorized_ip_cidr != "" ? var.tenant_authorized_ip_cidr : "${local.machine_public_ip}/32"
}

resource "google_compute_firewall" "allow_cloud_run_access" {
  name    = "${var.tenant_name}-allow-cloud-run-access"
  network = google_compute_network.tiiva_service_vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["443"] # Allow HTTPS traffic
  }

  source_ranges = [local.effective_source_range] # Use the effective source range

  depends_on = [null_resource.fetch_public_ip] # Ensure the IP is fetched before applying the rule
}
