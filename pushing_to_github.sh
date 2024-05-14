# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Zip the Templates folder into Documentation/docs/Files before uploading to Github
mkdir -p Documentation/docs/Files

# Specify the path to the directory where Templates.zip should be located
directory="Documentation/docs/Files"
file="Templates.zip"
file_path="$directory/$file"

# Check if Templates.zip exists in the specified directory
if [ -f "$file_path" ]; then
    echo "Found $file in $directory. Removing..."

    # Remove Templates.zip
    rm "$file_path"

    # Check if removal was successful
    if [ $? -eq 0 ]; then
        echo "Successfully removed $file."
    else
        echo "Failed to remove $file."
        exit 1
    fi
else
    echo "$file not found in $directory."
fi
echo "Creating $file in $directory"
zip -rq Documentation/docs/Files/Templates.zip Templates
echo "Created $file in $directory"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Convert all permission to read/write/edit for all users
chmod -R 777 *
# For commiting to github for the first time
rm -rf .git
git init
# upload to github
git add .
git commit -m 'updated repository for the ORCA Mechanism Procedure'
# For commiting to github for the first time
git branch -M main
git remote add origin git@github.com:geoffreyweal/ORCA_Mechanism_Procedure.git
git push -uf origin main
# push your new commit:
git push -u origin main
# Remove .git folder
rm -rf .git