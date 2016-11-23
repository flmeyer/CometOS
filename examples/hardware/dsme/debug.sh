C0=/dev/ttyUSB1
C1=/dev/ttyUSB3
BAUDRATE=500000

stty -F $C0 $BAUDRATE -parenb -parodd cs8 hupcl -cstopb cread clocal -crtscts -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke
stty -F $C1 $BAUDRATE -parenb -parodd cs8 hupcl -cstopb cread clocal -crtscts -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke

cat >gdbscriptA << EOL
target remote localhost:3456
symbol-file bin/M3OpenNode/Device.elf
load bin/M3OpenNode/Device.elf
continue
EOL

cat >gdbscriptB << EOL
target remote localhost:3457
symbol-file bin/M3OpenNode/Device.elf
load bin/M3OpenNode/Device.elf
continue
EOL

tmux new-session "cat $C0 | tee a.log" \; split-window -v -p 20 'arm-none-eabi-gdb -x gdbscriptA' \; split-window -h -p 50 'arm-none-eabi-gdb -x gdbscriptB' \; select-pane -t:.0 \; split-window -h -p 50 "cat $C1 | tee b.log" \; select-pane -t:.3 \; bind C-n "kill-session" \; set -g mode-mouse on \; set -g mouse-select-pane on \; set -g mouse-select-window on
