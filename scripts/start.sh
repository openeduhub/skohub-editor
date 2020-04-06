#!/bin/bash
#
###
# Provides:       skohub-editor
# Description:    Script to start the skohub-editor server.
#                 Use as standalone or in combination with
#                 /etc/init.d/skohub-editor.sh.
####

# config
PORT=9005 # the port skohub runs at
NAME=skohub-editor
NODE_VERSION="v12.16.1"

# install and use proper node version
export NVM_DIR="$HOME/.nvm"
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # loads nvm
nvm install $NODE_VERSION # makes also sure to use the proper version

cd $HOME/git/$NAME/scripts

###
# nothing to change from here
###

# start skohub-pubsub
PORT=$PORT npm run serve >> ../logs/$NAME.log 2>&1 &

# getting the process id of the skohub server and create a pidfile
PID=$(echo $!)
sleep 10 # crucial: wait before all processes are started. Should be improved.
PID_OF_SKOHUB_EDITOR="$(pgrep -P $(pgrep -P $PID))"
if [ $PID_OF_SKOHUB_EDITOR ]; then
      echo $PID_OF_SKOHUB_EDITOR > $NAME.pid
   else
      echo "Couldn' start $NAME"
      exit 1
   fi
exit 0
