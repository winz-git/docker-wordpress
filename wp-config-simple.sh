#!/bin/sh

set -e

# Replace DB config
sed -i src/wp-config.php \
    -e "s/database_name_here/$DB_NAME/" \
    -e "s/username_here/$DB_USER/" \
    -e "s/password_here/$DB_PASS/" \
    -e "s/localhost/$DB_HOST:$DB_PORT/" \
    -e "s/wp_/$DB_PREFIX/"


