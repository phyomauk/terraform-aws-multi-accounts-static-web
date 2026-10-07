output "record_fqdns" {
  value = {
    for k, v in aws_route53_record.this : k => v.fqdn
  }
}