On first boot, SonicPad-Debian will not know what timezone you are in and will assume UTC+0.

Run ```timedatectl list-timezones | more``` to see available timezones

To select your timezone:

```bash
timedatectl set-timezone 'America/Chicago'
```

Reboot the system.

>⚠️ It should be noted that the SonicPad-Debian firmware, unlike the stock firmware, uses a read/write filesystem. This means that, just like your computer at home, removing the power unexpectedly can damage your files. Do not use the button on the side of the SonicPad to turn it off. You must gracefully shutdown using a GUI or by issuing the `shutdown` or `restart` commands ⚠️