#!/bin/sh

RELATION_NAME=$1
GRAPH_NAME=$2

isql-vt -H kg-open-street-map-virtuoso-1 -P admin <<EOF
        SPARQL CREATE GRAPH <$GRAPH_NAME>;
        SPARQL CLEAR GRAPH <$GRAPH_NAME>;
        ld_dir('$RELATION_NAME', '*.n3', '$GRAPH_NAME');
        rdf_loader_run();
        exit;
EOF