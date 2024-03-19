provider "aws" {
  region = "af-south-1"
}
terraform {
  backend "s3" {
    bucket         = "okelani-eks-migration-terraform-state"
    key            = "rds-rabbitmq/terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "okelani-eks-migration-terraform-state-lock"
  }
}

resource "aws_ssm_parameter" "sidekick_creds_db_username" {
  name  = "/okelani/app/creds/db/username"
  type  = "String"
  value = "okelani_admin"

  tags = {
    Name        = "okelani_app_creds_db_username"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }
}

resource "aws_ssm_parameter" "sidekick_creds_db_password" {
  name  = "/okelani/app/creds/db/password"
  type  = "SecureString"
  value = "xOe43a121!"

  tags = {
    Name        = "okelani_app_creds_db_password"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }

}

resource "aws_ssm_parameter" "okelani_infra_username" {
  name  = "/okelani/infra/creds/db/username"
  type  = "String"
  value = "okelani_admin"

  tags = {
    Name        = "okelani_infra_db_creds_username"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }

}

resource "aws_ssm_parameter" "okelani_infra_password" {
  name  = "/okelani/infra/creds/db/password"
  type  = "SecureString"
  value = "57!reVAedf6"
}

resource "aws_ssm_parameter" "rabbitmq-broker-username" {
  name  = "/okelani/rabbitmq/username"
  type  = "String"
  value = "okelani_broker"

  tags = {
    Name        = "rabbitmq-broker-username"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }

}

resource "aws_ssm_parameter" "rabbitmq-broker-password" {
  name  = "/okelani/rabbitmq/password"
  type  = "SecureString"
  value = "vaBOe!98121x"

  tags = {
    Name        = "rabbitmq-broker-password"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }

}


data "aws_ssm_parameters_by_path" "username" {
  path = "/sidekick/creds/db/username"
}

data "aws_ssm_parameters_by_path" "password" {
  path = "/sidekick/creds/db/password"
}


resource "aws_db_instance" "okelani_sidekick_rds" {
  identifier              = "okelani-app-rds"
  engine                  = "postgres"
  instance_class          = "db.t3.small"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "okelani_admin"
  password                = "xOe43a121!"
  publicly_accessible     = false
  multi_az                = true
  vpc_security_group_ids  = ["sg-033a45fb0f438db59"]
  db_subnet_group_name    = aws_db_subnet_group.sideckick_db_subnet_group.name
  parameter_group_name    = aws_db_parameter_group.okelani_db_pg.name
  backup_retention_period = 5
  backup_window           = "05:00-06:00"

    tags = {
        Name        = "okelani-app-rds"
        owner       = "disraptor"
        environment = "prod"
        automation  = "terraform"
    
    }
}

resource "aws_db_instance" "okelani_infra_rds" {
  identifier              = "okelani-infra-rds"
  engine                  = "postgres"
  instance_class          = "db.t3.small"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "okelani_admin"
  password                = "57!reVAedf6"
  publicly_accessible     = false
  multi_az                = true
  vpc_security_group_ids  = ["sg-033a45fb0f438db59"]
  db_subnet_group_name    = aws_db_subnet_group.sideckick_db_subnet_group.name
  parameter_group_name    = aws_db_parameter_group.okelani_infra_db_pg.name
  backup_retention_period = 5
  backup_window           = "05:00-06:00"

  tags = {
    Name        = "okelani-infra-rds"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  
  }

}

resource "aws_db_snapshot" "sidekick_snapshot" {
  db_instance_identifier = aws_db_instance.okelani_sidekick_rds.identifier
  db_snapshot_identifier = "okelani-app-db-snapshot"
  tags = {
    Name        = "oeklani-app-db-snapshot"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }

}

resource "aws_db_parameter_group" "okelani_db_pg" {
  name        = "okelani-app-db-pg"
  family      = "postgres16"
  description = "Custom parameter group for okelani app RDS"
  tags = {
    Name        = "okelani-app-rds"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }
}

resource "aws_db_parameter_group" "okelani_infra_db_pg" {
  name        = "okelani-infra-db-pg"
  family      = "postgres16"
  description = "Custom parameter group for okelani infra RDS"
  tags = {
    Name        = "okelani-infra-rds"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }
}

resource "aws_mq_configuration" "rabbitmq" {
  description    = "Rabbit MQ Configuration for Sidekick"
  name           = "sidekick-rabbitmq"
  engine_type    = "RabbitMQ"
  engine_version = "3.11.28"

  data = <<DATA
# Default RabbitMQ delivery acknowledgement timeout is 30 minutes in milliseconds
consumer_timeout = 1800000
DATA

  tags = {
    Name        = "sidekick-rabbitmq"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }
}

resource "aws_db_subnet_group" "sideckick_db_subnet_group" {
  name        = "okelani-app-db-subnet-group"
  description = "Application RDS Subnet Group"
  subnet_ids  = ["subnet-02834e345ae825e82", "subnet-0d6e1bdfed2ca8b15", "subnet-0a76b5e2ef6d90340"]
  tags = {
    Name        = "okelani-app-db-subnet-group"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }
  
}

resource "aws_mq_broker" "rabbitmq-broker" {
  broker_name         = "sidekick-rabbitmq"
  engine_type         = "RabbitMQ"
  engine_version      = "3.8.11"
  host_instance_type  = "mq.t3.micro"
  publicly_accessible = false
  deployment_mode     = "SINGLE_INSTANCE"
  subnet_ids          = ["subnet-02834e345ae825e82"]
  security_groups     = ["sg-071cb6698c778702c"]

  tags = {
    Name        = "sidekick-rabbitmq"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }

  user {
    username = "okelani_broker"
    password = "vaBOe!98121x"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name        = "okelani-redis-subnet-group"
  description = "Redis Subnet Group"
  subnet_ids  = ["subnet-02834e345ae825e82", "subnet-0d6e1bdfed2ca8b15", "subnet-0a76b5e2ef6d90340"]
  tags = {
    Name        = "okelani-redis-subnet-group"
    owner       = "disraptor"
    environment = "prod"
    automation  = "terraform"
  }
  
}

resource "aws_elasticache_parameter_group" "redis_pg" {
    name        = "okelani-redis-pg"
    family      = "redis5.0"
    description = "Custom parameter group for okelani redis"
    tags = {
        Name        = "okelani-redis-pg"
        owner       = "disraptor"
        environment = "prod"
        automation  = "terraform"
    }
}

resource "aws_elasticache_cluster" "okelani_redis" {
    cluster_id           = "okelani-redis"
    engine               = "redis"
    engine_version       = "5.0.6"
    node_type            = "cache.t3.small"
    num_cache_nodes      = 1
    parameter_group_name = "default.redis5.0"
    port                 = 6379
    subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
    security_group_ids   = ["sg-0778d084d9cd07358"]
    tags = {
        Name        = "okelani-redis"
        owner       = "disraptor"
        environment = "prod"
        automation  = "terraform"
    }
}

output "DB_URL" {
  description = "DB URL for Sidekick RDS"
  value       = aws_db_instance.okelani_sidekick_rds.endpoint
}

output "RabbitMQ_ID" {
  description = "RabbitMQ ID"
  value       = aws_mq_broker.rabbitmq-broker.id
}