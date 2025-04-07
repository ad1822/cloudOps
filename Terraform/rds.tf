resource "aws_secretsmanager_secret" "db_secret" {
  name = "${local.env}-${local.eks_name}-gin-db-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = var.db_password
  })
}


resource "aws_db_instance" "gindb" {
  identifier             = "${local.env}-${local.eks_name}-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  username               = "admin"
  password               = var.db_password
  publicly_accessible    = false
  multi_az               = false
  db_name                = "${local.env}${local.eks_name}db"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${local.env}-${local.eks_name}-subnet-sg"
  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]

  tags = {
    Environment = "${local.env}"
    Project     = "${local.env}-${local.eks_name}-gin-db"
    Terraform   = "true"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${local.env}-${local.eks_name}-mysql-sg"
  description = "Allow MySQL access from EKS cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL access from EKS"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.env}-${local.eks_name}-db"
  }
}

data "aws_caller_identity" "current" {}
