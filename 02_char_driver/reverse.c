#include <linux/module.h>
#include <linux/kdev_t.h>   // dev_t type
#include <linux/fs.h>       // chrdev registration
#define MAJ_NUM   242       // MAJ, MIN device number
#define MIN_NUM   1337

MODULE_LICENSE("GPL");

static dev_t device_number;

static int __init load_driver(void)
{
    int rc;
	pr_info("Loading reverse module...\n");

    device_number = MKDEV(MAJ_NUM, MIN_NUM);
    /* register device region */
    rc = register_chrdev_region(device_number, 1, "reverse");


	return 0;
}

static void __exit unload_driver(void)
{
	pr_info("Unloading reverse module...\n");
    unregister_chrdev_region(device_number, 1);
}

module_init(load_driver);
module_exit(unload_driver);
