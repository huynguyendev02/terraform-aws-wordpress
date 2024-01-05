output "access_url" {
    value = "http://${module.route53.record.name}"
    description = "Access URL to Wordpress"
}
output "access_url_tls" {
    value = "https://${module.route53.record.name}"
    description = "Access URL with TLS to Wordpress"
}
output "alert_email" {
    value = var.email
    description = "Email to receive alert from Alarm"
}