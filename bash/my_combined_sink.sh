#!/bin/bash

sleep 8

# create main virtual sinks
pactl load-module module-null-sink media.class=Audio/Sink sink_name=discord-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Sink sink_name=game-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Sink sink_name=browser-sink channel_map=stereo

# create delayed sinks with descriptions for qpwgraph
pactl load-module module-null-sink sink_name=delayed-sink-mic sink_properties=device.description="delayed_output_mic"
pactl load-module module-null-sink sink_name=delayed-sink-game sink_properties=device.description="delayed_output_game"
pactl load-module module-null-sink sink_name=delayed-sink-discord sink_properties=device.description="delayed_output_discord"

# create loopbacks with 4.5s delay
pactl load-module module-loopback \
  source=alsa_output.usb-Focusrite_Scarlett_Solo_4th_Gen_S13Z4KC378F3B1-00.pro-output-0 \
  sink=delayed-sink-mic \
  latency_msec=4500 \
  sink_dont_move=true \
  source_dont_move=true \
  source_output_properties='node.description=delayed_mic media.name=delayed_mic'

pactl load-module module-loopback \
  source=game-sink.monitor \
  sink=delayed-sink-game \
  latency_msec=4500 \
  sink_dont_move=true \
  source_dont_move=true \
  source_output_properties='node.description=delayed_game media.name=delayed_game'

pactl load-module module-loopback \
  source=discord-sink.monitor \
  sink=delayed-sink-discord \
  latency_msec=4500 \
  sink_dont_move=true \
  source_dont_move=true \
  source_output_properties='node.description=delayed_discord media.name=delayed_discord'
