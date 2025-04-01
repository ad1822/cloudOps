#!/bin/bash

terraform fmt -diff
terraform validate

terraform apply --auto-approve
