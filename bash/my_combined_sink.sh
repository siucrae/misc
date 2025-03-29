#!/bin/bash

sleep 8
# wait 8 seconds so that it doesnt get consumed by my audio restart & then make the sink

pactl load-module module-null-sink media.class=Audio/Sink sink_name=discord-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Sink sink_name=game-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Sink sink_name=browser-sink channel_map=stereo
