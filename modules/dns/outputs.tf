output "zone_id" {
  value = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "Paste these into GoDaddy's Nameservers settings for this domain"
  value       = aws_route53_zone.this.name_servers
}