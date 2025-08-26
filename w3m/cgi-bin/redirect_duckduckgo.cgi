#!/bin/awk -f
# vim: filetype=awk
# inspired from
# github.com/gotbletu/shownotes/blob/master/w3m_plugins/cgi-bin/redirect_duckduckgo.cgi
# but rely only on AWK to be faster

# DDG's redirector encodes the destination URL on the GET "uddg" parameter
#
# example:
# https://duckduckgo.com/l/?uddg=https%3A%2F%2Ffast.com%2F&rut=superlongtrackingnum
#       ->
# https://fast.com/

BEGIN {
    len = split(ENVIRON["W3M_CURRENT_LINK"], fullurl, /[&\?]/)
    for (i = 2; i <= len; i++)
        if(fullurl[i] ~ /^uddg=/)
            break
    if (i > len)
        exit(1)
    # remove "udgg="
    url = substr(fullurl[i], 6)
    # replace %xx with its value
    for (byte = 0x20; byte <= 0x40; byte++) {
        asciiencoded = sprintf("%%%02X", byte)
        repl = sprintf("%c", byte)
        gsub(asciiencoded, repl, url)
    }

    printf("W3m-control: GOTO %s\r\n", url)
    printf("W3m-control: DELETE_PREVBUF\r\n")
    exit
}
