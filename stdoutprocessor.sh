#!/bin/bash
echo "Start processing"

while IFS= read -r line
do
    #echo line so that docker can gather its logs from stdout
    echo $line

    #message when a player is connected is like: [5a8bf70c][server]: player has entered the game. ClientID=1 addr=172.17.0.1:57587
    x=$(echo $line | grep 'ClientBegin:' | wc -l)
    toAdd=0
    if [ $x -eq 1 ]
    then
       toAdd=1
    fi
    
    #message when a player leaves is like [5a8bf70c][server]: '(1)nameless tee' has left the game
    y=$(echo $line | grep 'ClientDisconnect:' | wc -l)
    if [ $y -eq 1 ]
    then
        toAdd=-1
    fi
    
    if [ $x -eq 1 ] || [ $y -eq 1 ]
    then
        #get current connected count from the file
        connected=$(</tmp/connected)
        #((..)) is the way for integer arithmetics on bash
        connected=$(($connected+$toAdd))
        echo $connected > /tmp/connected

        #following are specified on Docker image creation
        #SET_SESSIONS_URL=https://teeworlds.azurewebsites.net/api/ACISetSessions?code=<KEY>
        #RESOURCE_GROUP='teeworlds'
        #CONTAINER_GROUP_NAME='teeserver1'

        #we're using wget in the Dockerfile as this results in a smaller Docker image
        #curl -d "[{\"resourceGroup\":\"$RESOURCE_GROUP\", \"containerGroupName\":\"$CONTAINER_GROUP_NAME\", \"activeSessions\":$connected}]" -H "Content-Type: application/json" -X POST $SET_SESSIONS_URL &
        wget -O- --post-data="[{\"resourceGroup\":\"$RESOURCE_GROUP\", \"containerGroupName\":\"$CONTAINER_GROUP_NAME\", \"activeSessions\":$connected}]" --header=Content-Type:application/json "$SET_SESSIONS_URL"

    fi 
done

echo "Finished processing"
