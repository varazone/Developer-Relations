#!/bin/bash

# Create the markdown file and write the header
echo "# Document Index" > index.md
echo "" >> index.md
echo "## Table of Contents" >> index.md
echo "" >> index.md
echo "- [Images](#images)" >> index.md
echo "- [PDFs](#pdfs)" >> index.md
echo "" >> index.md

# Function to URL-encode filenames
urlencode() {
    printf '%s' "$1" | jq -sRr @uri
}

# Images section
echo "## Images" >> index.md
echo "" >> index.md

for file in *.png; do
    # Check if file exists (to handle the case when no PNG files are found)
    [ -e "$file" ] || continue
    
    # Remove the .png extension and create a link-friendly title
    title="${file%.png}"
    link=$(echo "$title" | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]')
    
    # Append the ToC entry
    echo "- [${title}](#${link})" >> index.md
done

echo "" >> index.md

# Add image sections
for file in *.png; do
    [ -e "$file" ] || continue
    
    title="${file%.png}"
    encoded_file=$(urlencode "$file")
    
    echo "### ${title}" >> index.md
    echo "" >> index.md
    echo "![${title}](./${encoded_file})" >> index.md
    echo "" >> index.md
done

# PDFs section
echo "## PDFs" >> index.md
echo "" >> index.md

for file in *.pdf; do
    # Check if file exists (to handle the case when no PDF files are found)
    [ -e "$file" ] || continue
    
    # Remove the .pdf extension
    title="${file%.pdf}"
    encoded_file=$(urlencode "$file")
    
    # Append the PDF entry
    echo "- [${title}](./${encoded_file})" >> index.md
done

echo "" >> index.md

echo "Document index has been generated as 'index.md'"