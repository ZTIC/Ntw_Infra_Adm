#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}

echo "=== Destroying Azure Infrastructure for $ENVIRONMENT ==="

cd environments/$ENVIRONMENT

read -p "Are you sure you want to destroy all infrastructure? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    echo "Destroying infrastructure..."
    terraform destroy -auto-approve
    echo "Infrastructure destroyed!"
else
    echo "Destruction cancelled."
fi