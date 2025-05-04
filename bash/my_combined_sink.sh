#!/bin/bash

sleep 8

# create main virtual sinks
pactl load-module module-null-sink media.class=Audio/Sink sink_name=discord-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Sink sink_name=game-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Sink sink_name=browser-sink channel_map=stereo

# create delayed sinks with descriptions for qtwgraph
pactl load-module module-null-sink \
  sink_name=delayed_sink \
  sink_properties=device.description="delayed_input"

pactl load-module module-null-sink \
  sink_name=delayed-sink-output \
  sink_properties=device.description="delayed_output"

# create loopback with 4.5s delay
pactl load-module module-loopback \
  source=delayed_sink.monitor \
  sink=delayed-sink-output \
  latency_msec=4500 \
  sink_dont_move=true \
  source_dont_move=true \
  source_output_properties='node.description=DelayedLoopback media.name=DelayedLoopback'
