#!/usr/bin/env bash

STATE=$(bluetooth | awk -F'= ' '{print $2}')

if [ "$STATE" = "on" ]; then
    bluetooth off
else
    bluetooth on
fi

