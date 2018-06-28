#!/usr/bin/env bash
nginx -v
php -v
supervisord -n -c /etc/supervisord.conf