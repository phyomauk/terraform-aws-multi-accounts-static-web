resource "aws_route53_record" "this" {
  for_each = var.records

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type

  # Alias records (CloudFront, ALB, etc.)
  dynamic "alias" {
    for_each = try(each.value.alias, null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  # Non-alias records only
  ttl     = try(each.value.alias, null) == null ? try(each.value.ttl, null) : null
  records = try(each.value.alias, null) == null ? try(each.value.records, null) : null
}