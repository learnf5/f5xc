variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# owner id is account, peer_vpc_id vpc is acceptor, vpc_id is requestor
resource "aws_vpc_peering_connection" "my_pc" {
  peer_owner_id = "851725505258"
  peer_vpc_id   = "vpc-076a98a9e62587cb6"
  vpc_id        = "vpc-00d32d13dc2ddabaf"
}
