#!/bin/bash

docker-compose up --build --force-recreate --detach

while true; do

    echo 'Requesting nginx'

    code=$(curl --write-out '%{http_code}' --output /dev/stderr http://0.0.0.0:9292/healthcheck)

    if [[ "$code" == "200" ]]; then

        echo 'Got correct http status'

        exit 0

    fi

    sleep 5

done

docker-compose down
