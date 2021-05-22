#!/bin/sh

# run entrypoint
echo ""
echo "## RUN DEFAULT ENTRYPOINT"
docker-php-entrypoint apache2-foreground "$@"


