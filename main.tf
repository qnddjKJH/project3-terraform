terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
  profile = "admin"
}

resource "null_resource" "execute_script" {
  provisioner "local-exec" {
    command = "bash ./scripts/compress_files.sh"
  }
}

module "sales_api" {
  source = "./modules/sales-api"

  role_name = "salesApiLambdaRole"

  db_host_name = var.db_host_name
  db_database = var.db_database
  db_user_name = var.db_user_name
  db_password = var.db_password
}

module "stock_increase_lambda" {
  source = "./modules/stock-increase-lambda"

  role_name = "stockIncreaseLambdaRole"

  db_host_name = var.db_host_name
  db_database = var.db_database
  db_user_name = var.db_user_name
  db_password = var.db_password
}

module "stock_lambda" {
  source = "./modules/stock-lambda"

  role_name = "stockLambdaRole"

  callback_Url = module.stock_increase_lambda.stock_increase_url
  sales_api_queue_arn = module.sales_api.sales_api_queue_arn
}
