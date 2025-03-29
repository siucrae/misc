#!/usr/bin/env bash

# product ID in the form "vendor_id:product_id"
PRODUCTID='1038:1280'

# Split the PRODUCTID into vendor and product IDs
VENDOR_ID=$(echo $PRODUCTID | cut -d':' -f1)
PRODUCT_ID=$(echo $PRODUCTID | cut -d':' -f2)

# find the device path by checking each device's idVendor and idProduct
DEVICE_PATH=""
for DEVICE in /sys/bus/usb/devices/*; do
    if [ -f "$DEVICE/idVendor" ] && [ -f "$DEVICE/idProduct" ]; then
        VENDOR=$(cat $DEVICE/idVendor)
        PRODUCT=$(cat $DEVICE/idProduct)

        if [ "$VENDOR" == "$VENDOR_ID" ] && [ "$PRODUCT" == "$PRODUCT_ID" ]; then
            DEVICE_PATH=$DEVICE
            break
        fi
    fi
done

echo "Device path for $PRODUCTID: $DEVICE_PATH"

if [ -z "$DEVICE_PATH" ]; then
    echo "No device found for product ID $PRODUCTID"
    exit 1
fi

# extract the port ID from the device path (the full path, like 1-6.3)
PORTID=$(basename $DEVICE_PATH)
echo "Port: $PORTID"

# unbind and rebind the device
echo $PORTID | sudo tee /sys/bus/usb/drivers/usb/unbind
echo $PORTID | sudo tee /sys/bus/usb/drivers/usb/bind
