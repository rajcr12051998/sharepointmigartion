#!/bin/bash

# Load variables
source ./variables.sh

# Function to authenticate to SharePoint and get access token
get_access_token() {
  token=$(curl -X POST \
    -d "client_id=$CLIENT_ID" \
    -d "scope=https://graph.microsoft.com/.default" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "grant_type=client_credentials" \
    "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" | jq -r .access_token)
  echo "$token"
}

# Function to upload files to SharePoint
upload_file() {
  local file_path=$1
  local relative_path=$2
  local folder_path=$3

  # Get the SharePoint folder ID (create folder if not exists)
  folder_id=$(curl -X GET \
    -H "Authorization: Bearer $1" \
    "https://graph.microsoft.com/v1.0/sites/$(basename $SHAREPOINT_SITE_URL)/drives/$(get_drive_id)/root:/$DOCUMENT_LIBRARY/$folder_path:/children" | jq -r '.value[0].id')

  if [[ "$folder_id" == "null" || "$folder_id" == "" ]]; then
    # Create folder if it doesn't exist
    create_folder $folder_path
  fi

  # Upload file to SharePoint
  curl -X PUT \
    -H "Authorization: Bearer $token" \
    -T "$file_path" \
    "https://graph.microsoft.com/v1.0/sites/$(basename $SHAREPOINT_SITE_URL)/drives/$(get_drive_id)/items/$folder_id:/$(basename $file_path):/content"
}

# Function to get the SharePoint drive ID
get_drive_id() {
  curl -X GET \
    -H "Authorization: Bearer $token" \
    "https://graph.microsoft.com/v1.0/sites/$(basename $SHAREPOINT_SITE_URL)/drives" | jq -r '.value[0].id'
}

# Function to create folder in SharePoint
create_folder() {
  local folder_path=$1

  curl -X POST \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -d '{"parentReference": {"id": "/root"}, "name": "'$folder_path'"}' \
    "https://graph.microsoft.com/v1.0/sites/$(basename $SHAREPOINT_SITE_URL)/drives/$(get_drive_id())/root/children"
}

# Loop through the local templates folder and upload files
upload_templates() {
  for file_path in $(find $LOCAL_TEMPLATES_PATH -type f); do
    relative_path=$(echo $file_path | sed "s|$LOCAL_TEMPLATES_PATH/||g")
    folder_path=$(dirname "$relative_path")
    upload_file "$file_path" "$relative_path" "$folder_path"
  done
}

# Get access token and upload the files
token=$(get_access_token)
upload_templates
