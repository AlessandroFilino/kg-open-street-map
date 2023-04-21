#!/bin/sh

RELATION_NAME=$1

isql-vt -H kg-open-street-map-virtuoso-1 -P admin <<EOF
        ld_dir('$RELATION_NAME', '*.n3', 'http://example.org/load');
        rdf_loader_run();
        exit;
EOF