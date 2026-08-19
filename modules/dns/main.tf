# modules/dns/main.tf
#
# A Route53 hosted zone for a domain registered elsewhere (GoDaddy).
# Creating this zone does NOT make it "live" — it only becomes real
# once the domain's nameservers at GoDaddy are changed to point at
# the four nameservers this zone generates. Until then, this zone
# exists in AWS but nothing on the internet is looking at it.

resource "aws_route53_zone" "this" {
  name = var.domain_name
  tags = var.tags
}

# Root domain (pulseops-app.online) -> the EC2 instance's public IP
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [var.elastic_ip]
}

# www subdomain -> same IP, so both work
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.elastic_ip]
}