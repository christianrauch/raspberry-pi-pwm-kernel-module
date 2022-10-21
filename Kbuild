obj-m = servoblaster.o

KERNEL_TREE := /lib/modules/$(shell uname -r)/build
EXTRA_CFLAGS := -I/usr/src/linux-headers-$(shell uname -r)/arch/arm/mach-ixp4xx/include/ -I/usr/src/linux-headers-$(shell uname -r)/arch/arm/include/asm

module:
	make -C ${KERNEL_TREE} ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- M=$(PWD) modules

clean:
	make -C ${KERNEL_TREE} ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- M=$(PWD) clean
