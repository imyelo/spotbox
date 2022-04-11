## Setup PulseAudio
rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse
usermod -aG pulse,pulse-access root
pulseaudio -D --system \
  --disallow-exit --exit-idle-time=-1
pactl unload-module 0
pactl load-module module-null-sink sink_name=SpotSink

## Setup Background Image
curl -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" "$BG_IMG_URI" > background.jpg

## librespot
setsid ./librespot/target/release/librespot \
  -u "$USERNAME" -p "$PASSWORD" -n "$DEVICE_NAME" \
  --verbose --disable-audio-cache \
  --backend pulseaudio > librespot.log 2>&1 < /dev/null &

## ffmpeg
setsid ffmpeg \
  -loop 1 -r 15 -f image2 -s 1280x720 -i ./background.jpg \
  -f pulse -i "SpotSink.monitor" \
  -c:a aac -c:v libx264 -preset ultrafast -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720,fps=30,format=yuv420p" \
  -f flv \
  "$OUTPUT" > ffmpeg.log 2>&1 < /dev/null &

## log
tail -f ./librespot.log ./ffmpeg.log