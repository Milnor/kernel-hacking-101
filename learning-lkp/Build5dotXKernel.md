# Building the 5.x Linux Kernel from Source

## Release nomenclature
* `uname -r`
* mine is **5.4.0-77-generic**
### Format: major#.minor#[.patchlevel][-EXTRAVERSION]
* Current LTS (Long Term Support) version is 5.4

## Building from source (Overview)
1. Get the source tree
	- compressed download
		* www.kernel.org
		* e.g. `wget --https-only -O ~/Downloads/linux-5.4.0.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.4.0.tar.xz`
		* `mkdir -p ~/kernels` 
		* `tar xf ~/Downloads/linux-5.4.tar.xz --directory=${HOME}/kernels/`
	- clone a kernel Git tree
		* if you want to **upstream**
		* e.g. `git clone --depth=3 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git`
			- limiting depth makes it less massive
2. Extract tree (if applicable)
3. Configuration
	- e.g. `make menuconfig`
4. Build loadable modules and DTBs (Device Tree Blobs)
5. Install
	- `sudo make modules_install`
6. Setup bootloader
7. Customize GRUB bootloader (optional)

## Building from source (Me actually doing it)
* Poking around www.kernel.org and copied link to the one I wanted
* `mkdir -p ~/kernels`
* `cd ~/kernels`
* `wget --https-only https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.130.tar.xz`
	- Dang, that sucker is 105MB
* `tar xf linux-5.4.130.tar.xz`
* `cd linux-5.4.130/`
* `head Makefile`
	- **Kleptomaniac Octopus** is a pretty awesome name
* also went back and deleted the .tar.xz

## Licensing
* loadable modules using the kernel source tree fall under GNU GPL-2.0

## kbuild
* each symbol **FOO** has a **CONFIG\_FOO** macro
* three options it can be set to
	- y(es) it goes into the kernel itself
	- m(odule) it goes into a module
	- n(o) don't build it
* How do we get a working **.config** file?
	- start with a default configuration and tweak it

