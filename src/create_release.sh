#!/bin/bash

OUT_DIR=./out
BASE_NAME=debian_r818_sonic_lcd_uart0
ZIP_NAME=$OUT_DIR/$BASE_NAME.zip
FINAL_IMG=.$OUT_DIR/$BASE_NAME.img
MB_BLOCK=500m

zip -s $MB_BLOCK $ZIP_NAME $FINAL_IMG
