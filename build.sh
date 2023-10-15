#!/usr/bin/env bash
set -e

# Copy static files
rm -rf _site
cp -r site _site

# Download short url list
url="repos/tippy3/tippy.jp-short-url/contents/data.csv?ref=main"
header="Accept: application/vnd.github.raw"
gh api "$url" -H "$header" > _data.csv

# Create HTML files
while read row; do

  short_url="$(echo "$row" | cut -d , -f 1)"
  url="$(echo "$row" | cut -d , -f 2)"

  mkdir -p "_site/$short_url"

  echo "<!DOCTYPE html>
<html>
<head>
  <meta http-equiv=\"refresh\" content=\"0; url=$url\">
  <meta name=\"robots\" content=\"none\">
  <title>Redirecting...</title>
</head>
<body>
  <p>Redirecting to <a rel=\"noreferrer\" href=\"$url\">$url</a></p>
</body>
</html>" > "_site/$short_url/index.html"

done < _data.csv
