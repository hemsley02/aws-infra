resource "aws_acm_certificate" "vpn_cert" {
  domain_name = "hemsnet.us"
  validation_method = "DNS"

  tags = {
    Name = "VPN_Certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ec2_client_vpn_endpoint" "private" {
  count = local.enable

  description = ""
  server_certificate_arn = aws_acm_certificate.vpn_cert.arn
  client_cidr_block = "172.168.0.0/22"
  vpc_id = aws_vpc.main.id
  split_tunnel = true

  authentication_options {
    type = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:us-east-1:456459937768:certificate/fbbcf16e-47a2-4f63-bf73-3aa577b56f2d"
  }

  connection_log_options {
    enabled = false
  }
}

resource "aws_ec2_client_vpn_network_association" "private" {
  count = local.enable

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.private[0].id
  subnet_id = aws_subnet.private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "allow_all" {
  count = local.enable

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.private[0].id
  target_network_cidr = aws_subnet.private.cidr_block
  authorize_all_groups = true
}