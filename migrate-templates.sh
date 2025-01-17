#!/bin/bash

# Parameters passed from the Azure Pipeline
LOCAL_TEMPLATES_PATH=$1
SHAREPOINT_SITE_URL=$2
DOCUMENT_LIBRARY=$3
ACCESS_TOKEN=$4

# Loop through the local template files and upload them to SharePoint
echo "Starting migration of templates from '$LOCAL_TEMPLATES_PATH' to '$SHAREPOINT_SITE_URL/$DOCUMENT_LIBRARY'."

find $LOCAL_TEMPLATES_PATH -type f | while read template_file; do
    # Get the local folder structure
    folder_path=$(dirname "$template_file")
    sharepoint_folder_path=$(echo $folder_path | sed "s|$LOCAL_TEMPLATES_PATH/||" | sed "s|/|\\|g")  # Convert to SharePoint path format

    # Upload the file to SharePoint
    echo "Uploading $template_file to SharePoint folder '$sharepoint_folder_path'."
    curl -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" \
        -F "file=@$template_file" \
        "https://$SHAREPOINT_SITE_URL/_api/web/GetFolderByServerRelativeUrl('/sites/yoursite/$DOCUMENT_LIBRARY/$sharepoint_folder_path')/Files/add(url='$(basename $template_file)', overwrite=true)"
done

echo "Template migration completed successfully."
