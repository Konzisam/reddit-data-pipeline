#!/bin/bash

# Repo
REPO="Konzisam/reddit-data-pipeline"

# does secret key exist in github secrets
secret_exists() {
    gh secret list --repo "$REPO" | grep -q "$1"
}

# Read the .env file and set secrets
while IFS='=' read -r key value; do

    if secret_exists "$key"; then
        echo "Secret $key already exists. Skipping...."
    else
        echo "Setting secret: $key"
        gh secret set "$key" --repo "$REPO" --body "$value"
    fi
done < .env

echo "All set!"