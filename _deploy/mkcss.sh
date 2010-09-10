#!/bin/sh -e

CONFIG=../_config.yml
URL_ROOT=$(grep "^url_root: " ${CONFIG} | cut -f 2 -d ":" | tr -d " ")
sed s!@SITE_ROOT@!${URL_ROOT}!g screen.css >| ../css/screen.css

