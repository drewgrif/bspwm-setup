#!/bin/sh
bspc subscribe node_add node_remove | while read -r _; do
    bspc query -N -d | xargs -I % bspc node % -B
done
