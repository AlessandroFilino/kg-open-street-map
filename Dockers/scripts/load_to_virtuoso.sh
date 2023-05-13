#!/bin/sh

RELATION_NAME=$1
GRAPH_NAME=$2

# Controlliamo se il grafo contiene già delle triple
GRAPH_EXISTS=$(echo "SPARQL ASK { GRAPH <$GRAPH_NAME> { ?s ?p ?o } };" | isql-vt -H kg-open-street-map-virtuoso-1 -P admin) 
GRAPH_EXISTS=$(echo $GRAPH_EXISTS | grep -oP 'ask_retval INTEGER _*?\K ([10])')


if [ "$GRAPH_EXISTS" -eq 1 ];
    then
        # Il grafo contiene già delle triple,le eliminiamo 
        echo "\nELIMINAZIONE TRIPLE DA VECCHIO GRAFO $GRAPH_NAME.n3\n"
        echo "SPARQL CLEAR GRAPH <$GRAPH_NAME>;" | isql-vt isql-vt -H kg-open-street-map-virtuoso-1 -P admin
    fi

# Rimuoviamo il file dalla load list per ricaricarlo
echo "DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file='$RELATION_NAME/$RELATION_NAME.n3';" | isql-vt isql-vt -H kg-open-street-map-virtuoso-1 -P admin

echo "\n\nCARICAMENTO TRIPLE DA FILE : $RELATION_NAME.n3 NEL GRAFO : $GRAPH_NAME\n"
# echo "SPARQL CREATE GRAPH <$GRAPH_NAME>;" | isql-vt isql-vt -H kg-open-street-map-virtuoso-1 -P admin
echo "ld_dir('$RELATION_NAME', '$RELATION_NAME.n3', '$GRAPH_NAME');" | isql-vt isql-vt -H kg-open-street-map-virtuoso-1 -P admin
echo "rdf_loader_run();" | isql-vt isql-vt -H kg-open-street-map-virtuoso-1 -P admin


