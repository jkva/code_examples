#!/bin/sh

cd order_report
plackup -E production -p 9000 ./bin/app.psgi