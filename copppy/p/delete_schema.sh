#!/bin/bash
#Script to delete schemas for occupancy planning
execute=$1
if [[ $execuet != "delete" ]]
then
	echo "<<<<<<<<<<<<   This is dry run. No deletion of actual schema >>>>>>>>>>>>>>>>>>>>"
fi
schemas=`curl -k https://schemaregistry-0.sr.default.svc.cluster.local:443/subjects`
schemas=`echo $schemas| tr -d '[]"' | tr ',' ' '`
for schema in $schemas
do
  if [[ $schema = jll-occupancy-fms* || $schema = dp-OccupancyPlanning* || $schema = OccupancyPlanningOut* ]] 
  then
     echo $schema  
     if [[ $execute = "delete" ]] 
     then
        curl -k -X DELETE https://schemaregistry-0.sr.default.svc.cluster.local/subjects/$schema
     else
        echo curl -k -X DELETE https://schemaregistry-0.sr.default.svc.cluster.local/subjects/$schema
     fi
  fi
done