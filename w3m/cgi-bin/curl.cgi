#!/bin/sh

# Circumvent Websites not respecting our HTTP/1.0 request by using curl
# without this you'd see a webpage with this content:
# gzip: error: stdin not in gzip format
#
# see also https://github.com/tats/w3m/issues/307

case "$SERVER_PROTOCOL" in
    HTTP/*) proto="--http${SERVER_PROTOCOL#HTTP/}" ;;
esac

# $PATH_INFO may start with a "/"
# sanitize rx data by stripping out `w3m-control:` headers to avoid RCE
# Assume the site supports HTTPS even if original request could be plain HTTP
curl $proto -X "$REQUEST_METHOD" -sSD - "https://${PATH_INFO#/}/${QUERY_STRING#/}" | awk ' \
    $0 ~ /^\r?$/{content = 1} \
    content == 0{if (tolower($1) !~ /^w3m-control:/) print} \
    content != 0{print}'

# use -G if doing a GET request
# use --http11
# -x request_type
