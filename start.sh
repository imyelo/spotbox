## Setup PulseAudio
rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse
usermod -aG pulse,pulse-access root
pulseaudio -D --system --exit-idle-time=1 --disallow-exit
#pactl unload-module 0
pactl load-module module-null-sink sink_name=MySink
pactl update-sink-proplist MySink device.description=MySink

## librespot
./librespot/target/release/librespot -u $USERNAME -p $PASSWORD -n $DEVICE_NAME --backend pulseaudio > librespot.log 2>&1 < /dev/null &

## ffmpeg
ffmpeg -re -loop 1 -r 1/5 -i ./logo.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p -f pulse -f flv "$OUTPUT" > ffmpeg.log 2>&1 < /dev/null &

## log
tail -f ./librespot.log ./ffmpeg.log

