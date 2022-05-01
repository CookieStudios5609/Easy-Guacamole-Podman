#Totally not just copy/pasting my `history | grep` into here until I start actually making the script

echo "This repo is public but you should not pull or use anything in it. Don't." 
exit


#insert some warning about needing the dockerhub registry already set in config
read -p "Enter Pod name: " PODNAME
read -p "Enter desired frontend port: " PORT
podman pod create -n "$PODNAME" -p "$PORT":8080

podman run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql

podman run --name guac_mysql -d --pod "$PODNAME" mysql/mysql-server
podman cp initdb.sql guac_mysql:/guac_db.sql
podman exec -it guacsql bash #add all the important stuff that goes on inside the container here,


podman run --name guacd -d --pod "$PODNAME" guacamole/guacd


podman run --name guacamole -e MYSQL_DATABASE= -e MYSQL_USER= -e MYSQL_PASSWORD= -e GUACD_HOSTNAME=guacd -e MYSQL_HOSTNAME=guac_mysql -e useSSL=false -d --pod "$PODNAME" guacamole/guacamole
