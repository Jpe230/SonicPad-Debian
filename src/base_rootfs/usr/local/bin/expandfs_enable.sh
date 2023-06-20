#!/bin/bash

resize2fs /dev/mmcblk0p5

systemctl disable expandfs