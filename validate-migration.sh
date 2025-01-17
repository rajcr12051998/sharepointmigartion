#!/bin/bash

# Load variables
source ./variables.sh

# Function to validate the files in SharePoint
validate_migration() {
  for file_path in $(find $LOCAL_TEMPLATES_PATH -type f); do
    relative_path=$(echo $file_path | sed "s|$LOCAL_TEMPLATES_PATH/||g")
    folder_path=$(dirname "$relative_path")

    # Check if the file exists in SharePoint
    file_exists=$(curl -X GET \
      -H "Authorization: Bearer $token" \
      "https://graph.microsoft.com/v1.0/sites/$(basename $SHAREPOINT_SITE_URL)/drives/$(get_drive_id)/root:/$DOCUMENT_LIBRARY/$folder_path/$relative_path:/content" \
      -o /dev/null -w "%{http_code}" -s)

    if [ "$file_exists" != "200" ]; then
      echo "Error: $relative_path not found in SharePoint."
      exit 1
    fi
  done

  echo "Validation successful: All files migrated successfully."
}

# Validate the migration
validate_migration
