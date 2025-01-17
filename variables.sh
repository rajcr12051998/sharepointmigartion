# Azure Pipeline Variables
SP_SITE_URL: 'https://yoursharepointsite.sharepoint.com/sites/yoursite'  # URL of your SharePoint site
DOCUMENT_LIBRARY: 'Documents'  # Name of the document library where templates will be migrated
LOCAL_TEMPLATES_PATH: '$(Build.SourcesDirectory)/templates'  # Path to the templates in the repository
SP_CLIENT_ID: $(SP_CLIENT_ID)  # SharePoint Client ID for OAuth authentication
SP_CLIENT_SECRET: $(SP_CLIENT_SECRET)  # SharePoint Client Secret for OAuth authentication
SP_TENANT_ID: $(SP_TENANT_ID)  # Tenant ID for Azure AD
SMTP_SERVER: 'smtp.yourdomain.com'  # SMTP server to send emails (e.g., Office365 or Gmail)
SMTP_PORT: '587'  # SMTP server port
SMTP_USERNAME: $(SMTP_USERNAME)  # SMTP username (email address)
SMTP_PASSWORD: $(SMTP_PASSWORD)  # SMTP password (stored as a secret in Azure DevOps)
EMAIL_SENDER: 'youremail@example.com'  # Sender email address
EMAIL_RECIPIENTS: 'recipient1@example.com,recipient2@example.com'  # Comma-separated list of email recipients
