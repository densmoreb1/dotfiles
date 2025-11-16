#!/usr/bin/env bash

STATE=$(nmcli networking)

if [ "$STATE" = "enabled" ]; then
    nmcli networking off
else
    nmcli networking on
fi
