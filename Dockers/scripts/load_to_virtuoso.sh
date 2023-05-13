#!/bin/sh

RELATION_NAME=$1
GRAPH_NAME=$2

# isql-vt -H kg-open-street-map-virtuoso-1 -P admin <<EOF
#         SPARQL CREATE GRAPH <$GRAPH_NAME>;
#         SPARQL CLEAR GRAPH <$GRAPH_NAME>;
#         ld_dir('$RELATION_NAME', '*.n3', '$GRAPH_NAME');
#         rdf_loader_run();
#         exit;
# EOF

# isql-vt -H kg-open-street-map-virtuoso-1 -P admin <<EOF
#         ld_dir('$RELATION_NAME', '*.n3', 'http://example.org/load');
#         rdf_loader_run();
#         exit;
# EOF

# isql-vt -H kg-open-street-map-virtuoso-1 -P admin <<EOF
#         SPARQL ASK WHERE { GRAPH <http://example.org/load> { ?s ?p ?o } };
# EOF

GRAPH_EXISTS=$(echo "SPARQL ASK { GRAPH <http://example.org/load> { ?s ?p ?o } };" | isql-vt -H kg-open-street-map-virtuoso-1 -P admin)
echo $GRAPH_EXISTS | grep -oP '(?<=INTEGER _+)\d'

