# I don't know why we don't have to tell it make a .ko
# I don't know why we don't have to give it the name of the .c source file

obj-m := hello_world.o

# We want to be able to compile outside of the kernel source directory

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

# A handy reference: http://www.tldp.org/LDP/lkmpg/2.6/html/x181.html

