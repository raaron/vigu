#!/usr/bin/env bash

cd $VI
gnome-terminal --tab -e "bash -c \"subl . &; guard; exec bash\"" --tab -e "bash -c \"rails c; exec bash\""