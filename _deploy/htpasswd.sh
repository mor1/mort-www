#!/bin/sh

F="webpasswd"
C="htpasswd"
O=""
[ ! -r "${F}" ] && O="-c" 

${C} ${O} ${F} $1

