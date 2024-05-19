echo "Deleting files in site"
rm -rf site
echo "Building local site using mkdocs"
#mkdocs build --clean --no-directory-urls
mkdocs serve --clean --no-directory-urls
