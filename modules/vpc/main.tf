# modules/vpc/main.tf
#
# Layout:
#   Public subnets  (2, one per AZ) — Internet Gateway route.
#                    The EC2 instance with its Elastic IP lives here today.
#                    A second AZ exists now so an ALB can be dropped in
#                    later (Phase 2) without redesigning the network.
#   Private subnets (2, one per AZ) — no route to the internet at all.
#                    RDS and ElastiCache live here. They never need
#                    outbound internet access, so there is no NAT
#                    Gateway — that's the deliberate cost decision for
#                    this deployment, documented in the root README.

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# --- Public subnets: EC2 + Elastic IP live here today ---

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.name}-public-${var.azs[count.index]}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# --- Private subnets: RDS + ElastiCache, no internet route at all ---

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, { Name = "${var.name}-private-${var.azs[count.index]}" })
}

# Explicit private route table with only the implicit local route.
# Created deliberately rather than relying on the VPC's default main
# route table, so it's obvious in the console that these subnets have
# no path to the internet.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
