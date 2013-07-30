#!/bin/bash

function run
{
    REQUEST=$1
    WSDL=`cat ../wsdls/$1`

    if [ -f ../stats/$1 ]
    then
        rm ../stats/$1;
    fi

    for i in {1..2}; do (

    echo -------------- $1 --- && date \
    && curl --silent H "Content-Type: text/xml; charset=utf-8" -H \
    "SOAPAction:" -w "Connect: %{time_connect} TTFB: %{time_starttransfer} \
    Total time: %{time_total}" -d @$REQUEST -X POST -L -D - \
    $WSDL | awk '/Total time:/' | cut -d ' ' -f4 | tail -n 1 >> ../stats/$1 && sleep 2) ; done
}

function runFull
{
    REQUEST=$1
    WSDL=`cat ../wsdls/$1`

    for i in {1..2}; do ( echo -------------- $1 --- && date \
    && curl --silent H "Content-Type: text/xml; charset=utf-8" -H \
    "SOAPAction:" -w "Connect: %{time_connect} TTFB: %{time_starttransfer} \
    Total time: %{time_total}" -d @$REQUEST -X POST -L -D - \
    $WSDL | awk '/Connect:|HTTP\/|HA \ |X-Front-Cache|X-Cacheable/' && sleep 2) ; done
}
cd envelopes;
for i in *; do
    if [ -f ../wsdls/$i ]
    then
        run $i;
    else
        echo "Pas d'url pour "$i
    fi

done
exit 0;





