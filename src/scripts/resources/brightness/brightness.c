#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <getopt.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/mman.h>
#include <pthread.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include "sunxi_display_v2.h"

#define DISP_PATH "/dev/disp"
#define SCREEN_ID 0

//用户可设置亮度范围
#define MIN_LEVEL 37
#define MAX_LEVEL 255

static unsigned int brightness_value = 170;
static bool dev_mode = false;
static bool sw_flag = false;
static unsigned int sw = 0;

static void parse_args(int argc, char *argv[])
{

    int r;
    static struct option longOptions[] =
        {
            {"value", required_argument, NULL, 'v'},
            {"dev", required_argument, NULL, 'd'},
            {"switch", required_argument, NULL, 's'},
            {"help", no_argument, NULL, 'h'},
            {0, 0, 0, 0}};
    for (;;)
    {
        int optidx = 0;
        int c;

        c = getopt_long(argc, argv, "hd:s:v:", longOptions, &optidx);
        if (-1 == c)
            break;
        switch (c)
        {
        case 'v':
            brightness_value = strtol(optarg, NULL, 0);
            break;
        case 'd':
            dev_mode = true;
            brightness_value = strtol(optarg, NULL, 0);
            break;
        case 's':
            sw_flag = true;
            sw = strtol(optarg, NULL, 0);
            break;
        case 'h':
            printf("\nUSAGE: brightness [OPTIONS] [value]\n \
                    -s	backlight switch [0|1]\n \
                    -d	dev mode range [0-255]\n \
                    -v	range default [0-100]\n");
        default:
            exit(EXIT_FAILURE);
        }
    }
}

/* ----Set the brightness---- */
int set_brightness(int fd, unsigned int screenId, unsigned int value)
{

    unsigned long param[4] = {0};
    param[0] = (unsigned long)screenId;
    param[1] = (unsigned long)value;

    return ioctl(fd, DISP_LCD_SET_BRIGHTNESS, (void *)param);
}

int get_brightness(int fd, unsigned int screenId)
{
    unsigned long param[4] = {0};
    param[0] = (unsigned long)screenId;

    return ioctl(fd, DISP_LCD_GET_BRIGHTNESS, (void *)param);
}

int set_backlight_enable(int fd, unsigned int screenId, unsigned int enable)
{

    unsigned long param[4] = {0};
    param[0] = (unsigned long)screenId;
    int ret = 0;

    if (enable == 1)
        ret = ioctl(fd, DISP_LCD_BACKLIGHT_ENABLE, (void *)param);
    else
        ret = ioctl(fd, DISP_LCD_BACKLIGHT_DISABLE, (void *)param);

    return ret;
}

int main(int argc, char **argv)
{

    int disp_fd = -1;

    parse_args(argc, argv);

    disp_fd = open(DISP_PATH, O_RDWR);
    if (disp_fd == -1)
    {
        printf("open display device faild ( %s )\n", strerror(errno));
        goto err;
    }

    if (sw_flag) {
        if (set_backlight_enable(disp_fd, SCREEN_ID, sw) < 0)
            goto err;
        else
            goto exit;
    }

    //用户模式下，将用户输入的百分制转化为对应的MIN_LEVEL~MAX_LEVEL内对应数值
    if (!dev_mode)
    {
        brightness_value = brightness_value * (MAX_LEVEL - MIN_LEVEL) / 100 + MIN_LEVEL;
    }

    if (set_brightness(disp_fd, SCREEN_ID, brightness_value) < 0)
    {
        printf("fail to set brightness. \n");
        goto err;
    }

    int brightness = 0;
    if (brightness_value != (brightness = get_brightness(disp_fd, SCREEN_ID)))
    {
        printf("brightness value is error. brightness=%d\n", brightness);
        goto err;
    }

    printf("success to set brightness. current brightness is %d\n", brightness_value);

exit:
    close(disp_fd);
    return 0;

err:
    close(disp_fd);
    return -1;
}
