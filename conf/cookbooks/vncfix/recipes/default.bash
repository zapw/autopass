#!/bin/bash

sed -i "s/$username/<USER>/" /usr/lib/systemd/system/vncserver@.service || exit 1
