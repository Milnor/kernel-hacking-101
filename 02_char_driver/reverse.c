#include <linux/module.h>
MODULE_LICENSE("GPL");

static int __init load_driver(void)
{
	pr_info("Loading reverse module...\n");
	return 0;
}

static void __exit unload_driver(void)
{
	pr_info("Unloading reverse module...\n");
}

module_init(load_driver);
module_exit(unload_driver);
