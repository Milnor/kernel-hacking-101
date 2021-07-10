# Kernel workspace setup

I'm using Bionic Beaver 18.04.5 LTS

## First few deps
* `sudo apt update`
* `sudo apt install gcc make perl`

## VirtualBox Guest Additions
* https://www.tecmint.com/install-virtualbox-guest-additions-in-ubuntu/
* `sudo apt update`
* `sudo apt upgrade`
* `sudo apt install build-essential dkms linux-headers-$(uname -r)`

## VirtualBox GUI
### Steps with VM still running
* Devices ==> Insert Guest Additions CD
* Run
* (shutdown the VM)
### Steps with VM off
* General ==> Advanced
* I set "Shared Clipboard" and Drag'n'Drop both to "Bidirectional"
* (turn VM back on)
### Back inside running VM
* Because I was curious
	- `cat /proc/sys/kernel/tainted`
	- 12288
	- The kernel was **already** tainted
* More required software
	- `sudo apt update`
	- `sudo apt install git fakeroot build-essential tar ncurses-dev tar xz-utils libssl-dev bc stress python3-distutils libelf-dev linux-headers-$(uname -r) bison flex libncurses5-dev util-linux net-tools linux-tools-$(uname -r) exuberant-ctags cscope sysfsutils gnome-system-monitor curl perf-tools-unstable gnuplot rt-tests indent tree pstree smem libnuma-dev numactl hwloc bpfcc-tools sparse flawfinder cppcheck tuna hexdump openjdk-14-jre trace-cmd virt-what`
	- Some things failed:
```
Note, selecting 'libncurses5-dev' instead of 'ncurses-dev'
E: Unable to locate package pstree
E: Unable to locate package tuna
E: Unable to locate package hexdump
E: Unable to locate package openjdk-14-jre
```
* To run emulated ARM stuff
	- `sudo apt install qemu-system-arm`
* To cross-compile for ARM
	- `sudo apt install crossbuild-essential-armhf`

## More notes from chapter
TODO: add Markdown formatting...
sudo apt install tldr

section 9 mentioned in man man is a lie; no man pages for kernel APIs
	https://www.kernel.org/doc/html/latest/
	or build docs yourself within source tree with Sphinx, etc.

Static analysis tools for Linux kernel
	Sparse, Coccinelle, Smatch, Flawfinder, Cppcheck

LTTng // Linux Trace Toolkit next generation
* tracing and profiling
* lttng.org/docs
* Trace Compass GUI www.eclipse.org/tracecompass
	- sudo apt install openjdk-14-jre // JRE dependency for Trace Compass

He also puts in a plug for procmap
* https://github.com/kaiwan/procmap

Use BCC for eBPF

LDV - Linux Driver Verification
* linuxtesting.org/ldv/online?action=rules

