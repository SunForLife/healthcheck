#!/bin/bash

docker-compose up --build --force-recreate --detach

while true; do

    echo 'Requesting nginx'

    HTTP_CODE=$(curl --write-out '%{http_code}' --output /dev/stderr http://0.0.0.0:9292/healthcheck)

    if [[ "$HTTP_CODE" == "200" ]]; then

        echo 'Got correct http status'

        exit 0

    fi

    sleep 10

done

docker-compose down
