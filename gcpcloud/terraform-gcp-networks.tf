###########  Vuecalc   #############
resource "google_compute_firewall" "frontend_vuecalc_rules" {
  name    = "frontend-vuecalc"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2000"]  # Allow custom port for vuecalc instances
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vuecalc"]  # Apply to all vuecalc instances
}

###########  LoadBalancer (Port 80 for Vuecalc) #############
resource "google_compute_firewall" "frontend_80_rules" {
  name    = "frontend-80"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"] 
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["balancer"]
}

###########  LoadBalancer (Port 8080 for Monitoring) #############
resource "google_compute_firewall" "frontend_8080_rules" {
  name    = "frontend-8080"
  network = "default"

  # Allow public access for port 8080 (monitoring) [username/password protected]
  allow {
      protocol = "tcp"
      ports = ["8080"]
    }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["balancer"]
}

###########  Expressed   #############
resource "google_compute_firewall" "backend_expressed_rules" {
  name    = "backend-expressed"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]  # Allow custom port for expressed instances
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["expressed"] # Apply to all expressed instances
}

###########  Happy   #############
resource "google_compute_firewall" "backend_happy_rules" {
  name    = "backend-happy"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["4000"]  # Allow custom port for happy instances
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["happy"]  # Apply to all happy instances
}

###########  Bootstorage   #############
resource "google_compute_firewall" "backend_bootstorage_rules" {
  name    = "backend-bootstorage"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]  # Allow custom port for bootstorage instance
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bootstorage"]  # Apply to all bootstorage instances
}

###########  MongoDB   #############
resource "google_compute_firewall" "mongodb_rules" {
  name    = "mongodb-access"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]  # MongoDB default port
  }

  # Only allow traffic from bootstorage instance to MongoDB instance
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["mongodb"]
}

###########  Prometheus   #############
resource "google_compute_firewall" "prometheus_rules" {
  name    = "prometheus-access"
  network = "default"

  # Allow traffic for Prometheus on port 9090 (Prometheus default port)
  allow {
    protocol = "tcp"
    ports    = ["9090"]  # Prometheus web UI and metrics port
  }

  source_ranges = ["0.0.0.0/0"]  # Allow access from anywhere
  target_tags   = ["prometheus"]  # Apply to Prometheus instance
}