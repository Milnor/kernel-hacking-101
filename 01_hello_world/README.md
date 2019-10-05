# Hello World loadable kernel module that accepts an optional string parameter @my_name

## Example build and usage:
`make`
`sudo insmod hello_world.ko`
`sudo rmmod hello_world`
`sudo insmod hello_world.ko my_name="CoolModule"`
`sudo rmmod hello_world`

## To view printk output:
`dmesg`
or
`journalctl -f`
