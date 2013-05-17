#!/bin/sh

if [ "x$1" == 'x' ]; then
    echo "Please specify a maintainer, as in $0 'Your name <email>'"
    exit 1
fi

fpm -s dir \
    -t rpm \
    -n bunktate \
    -v '1.0.2' \
    --iteration '1.el6' \
    --category 'System Environment/Utilities' \
    -a 'x86_64' \
    --description 'Bunktate is used to rotate the daily Logstash indices in Elasticsearch' \
    --url 'https://github.com/phrawzty/bunktate' \
    --maintainer "$1" \
    -d 'ruby' -d 'rubygems' \
    --rpm-defattrfile 644 \
    --rpm-defattrdir 755 \
    -C bunktate-build .
