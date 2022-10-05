#!/bin/bash

if [ ! -d ./env ]; then
    virtualenv env
    . ./env/bin/activate
    pip install -r requirements.txt
else
    . ./env/bin/activate
fi

python ./server.py
