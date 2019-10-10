#include <linux/module.h>
#include <linux/kdev_t.h>   // dev_t type
#include <linux/fs.h>       // chrdev registration

#define MAJ_NUM     242       // MAJ, MIN device number
#define MIN_NUM     1337
#define BUFF_SIZE   2048

static ssize_t reverse_read(struct file *, char __user *,size_t, loff_t *);
static ssize_t reverse_write(struct file *, const char __ user *, size_t, loff_t *);

static dev_t device_number;

typedef struct buffer
{
    char data[BUFF_SIZE],
    int index;
} buffer_t;

static buffer_t char_buffer;

static struct file_operations reverse_ops =
{
    .owner = THIS_MODULE,
    .read = reverse_read,
    .write = reverse_write,
};

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
MODULE_LICENSE("GPL");
