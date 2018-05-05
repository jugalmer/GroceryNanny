# automated script to generate required indices on elastic search
export ESUNAME=elastic
export ESPASS=Rz7ttlR5OK4JDAg0hyl92wwc
export ESHOST=efb9d029b5e853c7154e661385276da6.us-central1.gcp.cloud.es.io
export ESPORT=9243

echo "running indexgenerator.js"
node indexgenerator.js
echo "finished"

