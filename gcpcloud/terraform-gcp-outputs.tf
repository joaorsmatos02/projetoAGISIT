# Terraform GCP
# To output variables, follow pattern:
# value = TYPE.NAME.ATTR

output "balancer" {
    value = join(" ", google_compute_instance.balancer.*.network_interface.0.access_config.0.nat_ip)
}

output "balancer_ssh" {
 value = google_compute_instance.balancer.self_link
}

###########  Vuecalc   #############
# example for a set of identical instances created with "count"
output "vuecalc_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.vuecalc[*].name, google_compute_instance.vuecalc[*].network_interface.0.access_config.0.nat_ip)
}


###########  Expressed   #############
# example for a set of identical instances created with "count"
output "expressed_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.expressed[*].name, google_compute_instance.expressed[*].network_interface.0.access_config.0.nat_ip)
}


###########  Happy   #############
# example for a set of identical instances created with "count"
output "happy_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.happy[*].name, google_compute_instance.happy[*].network_interface.0.access_config.0.nat_ip)
}

###########  Bootstorage   #############
# Output for Bootstorage instances
output "bootstorage_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.bootstorage[*].name, google_compute_instance.bootstorage[*].network_interface.0.access_config.0.nat_ip)
}

###########  MongoDB   #############
# Output for MongoDB instances
output "mongodb_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.mongodb[*].name, google_compute_instance.mongodb[*].network_interface.0.access_config.0.nat_ip)
}

###########  Prometheus   #############
# Output for Prometheus instances
output "prometheus_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.prometheus[*].name, google_compute_instance.prometheus[*].network_interface.0.access_config.0.nat_ip)
}