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
	- included a `tar` example in previous step above
3. Configuration
	- e.g. `make menuconfig`
	- Three Common Approaches
		1. small embedded systems
			* working example configs included in `arch/<arch>/configs/`
			* start with a known good and fine tune it
			* FYI, Rasp. Pi is `arch/arm/configs/bcm2835_defconfig` 
		2. emulate the distro's configuration
			* e.g. `cp /boot/config-$(uname -r) ${K_SRC_DIR}/.config`
		3. localmodconfig approach
			* `lsmod > /tmp/lsmod.now`
			* `cd ${K_SRC_DIR}`
			* `make LSMOD=/tmp/lsmod.now localmodconfig`
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
* Use **localmodconfig** approach for now
* `lsmod > /tmp/lsmod.now` it is 50 lines long, according to *wc*
* `cd ~/kernels/linux-5.4.130`
* `make LSMOD=/tmp/lsmod.now localmodconfig`
	- it failed because it couldn't find flex
	- `sudo apt-get update ; sudo apt-get upgrade ; sudo apt-get install flex bison`
	- THEN I ran the *make* command again... and hit ENTER a few times
* `make mrproper` or `make distclean` is supposed to work too
* Next fine-tune the localmodconfig .config with **make menuconfig**
* `make menuconfig`
	- it failed because it couldn't find ncurses
	- `sudo apt-get install lib64ncurses5-dev`
	- after that, make menuconfig worked
	- selected options in TUI and exited
* `wc -l .config` 10335 is a lot of options!
* `grep IKCONFIG .config` to see how specific options were set
* `scripts/diffconfig .config.old .config` slick way to see the changes
* Brief Detour into review quetions
	- `make tags` and `make cscope` both failed out-of-the-box
		* cloned universal-ctags, but it failed to build since it needed additional deps
		* `apt-cache search cscope` `sudo apt-get install cscope` `man cscope`
		* TODO: circle back to this, I want to build the kernel!
* Back to actually building the kernel...
* `nproc` and `lscpu` both agree that I have two cores
* use `-j n`, where n = num-CPU-cores * factor
	- factor is 2 (or 1.5 on a high-end system)
	- on my box, n = 2 * 2 = 4
* `time make -j 4`
	- it failed after 7 seconds, warning of needing libelf-dev and erroring out on not finding openssl
	- `sudo apt-get install libelf-dev`
	- `sudo apt-get install libssl-dev`
	- No rule to make target 'debian/canonical-certs.pem', needed by 'certs/x509\_certificate\_list' ... well this is getting annoying.
	- modified .config
		* CONFIG\_SYSTEM\_TRUSTED\_KEYS=""
* it finally seemed like it was working
* to speed things up, I'll try `init 3` and then `time make -j4` from there...
	- it froze; can't change runlevel with `init 3` in Ubuntu 18?
* Installed more deps
	- `sudo apt install linux-tools-common`
	- `sudo apt-get install linux-tools-5.4.0-77-generic linux-tools-generic`
	- `sudo perf stat make -j4` **finally** built it in 4660.98 seconds
	- I don't have scores to spare, but I'll up RAM from 4 to 16GB
* The build generated some noteworthy files:
	- **vmlinux** // used for debugging
	- **System.map** // symbol-address mappings
	- **bzImage** // compressed bootable kernel image
## Licensing
* loadable modules using the kernel source tree fall under GNU GPL-2.0

## kbuild
* each symbol **FOO** has a **CONFIG\_FOO** macro
	- three options it can be set to
		* **y(es)** it goes into the kernel itself
		* **m(odule)** it goes into a module
		* **n(o)** don't build it
* How do we get a working **.config** file?
	- start with a default configuration and tweak it

