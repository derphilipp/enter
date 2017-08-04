#!/bin/bash

enter() {
   containers=`docker ps --filter name=$1 --filter status=running --format "table {{.ID}}" | awk 'NR > 1 { print }'`
   container_amount=`echo "$containers" | wc -l`
   if [ -z "$containers" ]; then
       echo No container found with "$1"
   fi
   if [[ "$container_amount" -eq 1 ]]; then
       echo entering "$containers"...
       echo "    ========================="
       docker ps --filter id="$containers" | awk 'NR > 1 { print "    " $0}'
       echo "    ========================="
       docker exec -it "$containers" zsh || docker exec -it "$containers" bash || docker exec -it "$containers" sh

   else
       echo Too many containers found with "$1":
       docker ps --filter name=$1 --filter status=running --format "table {{.Image}}" | awk 'NR > 1 { print "     " $0}'
   fi
}
