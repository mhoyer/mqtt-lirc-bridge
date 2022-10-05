from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import paho.mqtt.client as mqtt
import lirc

mqtt_host = "ha.tatooine"
mqtt_queue_name = "squeezy_kitchen/hifi_power_toggle"

lirc_client = lirc.Client()
mqtt_client = mqtt.Client()

def main():
    mqtt_client.on_connect = on_connect
    mqtt_client.on_message = on_message
    mqtt_client.connect(mqtt_host, 1883, 60)
    mqtt_client.loop_forever()

def on_connect(client, userdata, flags, rc):
    print(f"Connected to {mqtt_host} with result code {str(rc)}. Subscribing to '{mqtt_queue_name}'.")
    client.subscribe(mqtt_queue_name)

def on_message(client, userdata, msg):
    lirc_client.send_once('JVC_RM-RXUT200R', 'KEY_POWER', 5)

main()
