url="$1"
curl "$url" -H 'Cache-Purge: true' | md5sum 
