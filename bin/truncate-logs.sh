#!/bin/sh

echo "truncating all logs…"
/usr/bin/truncate -s 0 /logs/all.log
/usr/bin/truncate -s 0 /var/log/*.log
/usr/bin/truncate -s 0 /var/log/**/*.log
