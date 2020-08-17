#!/bin/sh
SERVICE='delayed_job'
 
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, everything is fine"
else
    echo "$SERVICE is not running"
    cd /home/meetingup/Projetos/meeting-up
    RAILS_ENV=production bin/delayed_job start &
fi
