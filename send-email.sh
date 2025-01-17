#!/bin/bash

# Parameters passed from the Azure Pipeline
EMAIL_SUBJECT=$1
EMAIL_BODY=$2
EMAIL_STATUS=$3

# Use 'curl' to send email via SMTP (for example, Gmail or Office365)
curl --url "smtp://$(SMTP_SERVER):$(SMTP_PORT)" --ssl-reqd \
    --mail-from "$(EMAIL_SENDER)" \
    --mail-rcpt "$(EMAIL_RECIPIENTS)" \
    --upload-file <(echo -e "Subject: $EMAIL_SUBJECT\n\n$EMAIL_BODY\n\nMigration Status: $EMAIL_STATUS") \
    --user "$(SMTP_USERNAME):$(SMTP_PASSWORD)"  # Use credentials from Azure DevOps secrets

echo "Email sent to $EMAIL_RECIPIENTS with status: $EMAIL_STATUS."
