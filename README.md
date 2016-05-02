# docker_openarena
OpenArena server - docker image

This is a docker image with an OpenArena server. This image utilizing OpenArena 0.8.8's features. This can be both good and bad.

This image is good if:
 * You want to host an OpenArena 0.8.8 server
 * You want an image that works out of the box
 * You want an image that is easy to configure.
 
This image is not good if:
 * You want to host a server with a mod not based of OpenArena 0.8.8
 
To run do something like:
```
docker run -it -e "OA_STARTMAP=dm4ish" -e "OA_PORT=27960" --rm -p 27960:27960/udp -v openarena_data:/data sago007/openarena
```

Be warned that all three port numbers must be changed if you want to run on another port and have the game appear in the server list.

To change the config you can start a bash instance with:
```
docker run -it --rm -v openarena_data:/data --user 0 sago007/openarena bash
```
And then do:
```
apt-get install -y vim
vim /data/openarena/baseoa/server_config_sample.cfg
```

On server start the following files will be created in "/data/openarena/baseoa" if they do not exist:
```
maps_ctf.cfg
maps_dd.cfg  
maps_dm.cfg  
maps_dom.cfg  
maps_elimination.cfg  
maps_harvester.cfg  
maps_lms.cfg  
maps_obelisk.cfg  
maps_oneflag.cfg  
maps_tdm.cfg  
maps_tourney.cfg  
server_config_sample.cfg
```
You can edit them to suit your need... or keep them
