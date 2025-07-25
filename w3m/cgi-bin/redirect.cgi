#!/bin/sh

# Redirect to URL passed as parameter

echo 'Content-Type: text/plain'
# remove "/" prefix from query_string
printf 'W3m-control: GOTO %s\n\n' "${QUERY_STRING#/}"
