#!/bin/bash

if [ ! -d ./env ]; then
    virtualenv -p /usr/bin/python3 env
    . ./env/bin/activate
    pip install -r requirements.txt
else
    . ./env/bin/activate
fi

python ./server.py
