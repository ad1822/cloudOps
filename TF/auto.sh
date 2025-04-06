#!/bin/bash

set -e

echo "Formatting Terraform files..."
terraform fmt -diff

echo "Validating Terraform configuration..."
terraform validate

echo "Planning Terraform changes..."
terraform plan -out=tfplan

echo "Applying Terraform changes..."
terraform apply tfplan

rm -r tfplan
