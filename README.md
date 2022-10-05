# Setting up LIRC on Raspberry Pi 4 for sending IR signals


## Install `lircd`

```bash
sudo apt update
sudo apt install lirc
```

Edit the `/etc/lirc/lirc_options.conf` and change

```diff
[lircd]
nodaemon        = False
-driver          = devinput
+driver          = default
-device          = auto
+device          = /dev/lirc0 # when sending IR signals
+#device          = /dev/lirc1 # when receiving IR signals
output          = /var/run/lirc/lircd
pidfile         = /var/run/lirc/lircd.pid
```

> See also: [SO: LIRC driver option - default vs devinput](https://stackoverflow.com/q/62646773)

A single `lircd` instance can only listen to a single device. Search in [LIRC Configuration guide](https://www.lirc.org/html/configuration-guide.html#setup-instance) for "Connecting several input capture devices." to see how multiple instances might be connected together.

### Enable GPIO overlays for IR in- and outputs

```bash
sudo nano /boot/config.txt
```

Add (or enable) with correct GPIO pins:

```
dtoverlay=gpio-ir,gpio_pin=18
dtoverlay=gpio-ir-tx,gpio_pin=17
```

> ❗ Don't use the `dtoverlay=lirc-rpi` which is mentioned in older blog posts and tutorials, this is not working with latest RPI kernels.
> See: [[Bullseye/Buster/Stretch] Using LIRC on gpio-ir with kernel 4.19 or later](https://forums.raspberrypi.com/viewtopic.php?t=235256&sid=fa0ba9ffdfaafbfb05b4ec8d74b92ef9)

```bash
sudo reboot now
```

## Install LIRC remote config

Download proper LIRC remote config file using `irdb-get`:

```bash
irdb-get list # to search for available remotes
irdb-get download jvc/RM-RXUT200R.lircd.conf
sudo cp RM-RXUT200R.lircd.conf /etc/lirc/lircd.conf.d/RM-RXUT200R.lircd.conf
sudo systemctl restart lircd.service
```

You should now be able to see available IR commands:

```bash
irsend LIST JVC_RM-RXUT200R ""
```

## Setup the MQTT-LIRC bridge

```bash
./run.sh
```

## My setup while doing the install

```bash
$ uname -r
5.15.61-v7l+

$ cat /etc/os-release  | head -n1
PRETTY_NAME="Raspbian GNU/Linux 11 (bullseye)"

$ lircd -v
lircd 0.10.1
```

## Other (maybe) helpful resources

- https://github.com/AnaviTechnology/anavi-docs/blob/master/anavi-infrared-phat/anavi-infrared-phat.md#setting-up-lirc
