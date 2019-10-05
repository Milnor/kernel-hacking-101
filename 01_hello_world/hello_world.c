/* A simple kernel module that accepts an optional parameter */
#include <linux/module.h>

static char * my_name = "Simple K. Module";

static int __init hello(void)
{
	printk(KERN_INFO "Hello, World! I am %s.\n", my_name);
	// Note: No comma between KERN_INFO and format string

	return 0;
}

static void __exit goodbye(void)
{
	printk(KERN_WARNING "Goodbye, cruel world!\n");
	// Note: KERN_WARNING displays differently than KERN_INFO

	return;
}

/* Module will likely be rejected without GPL */
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Name of smart person goes here");
MODULE_DESCRIPTION("Hello World LKM");

/* Tell the kernel which functions to use for init and exit */
module_init(hello);
module_exit(goodbye);
