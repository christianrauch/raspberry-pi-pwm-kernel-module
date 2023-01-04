name = servoblaster

obj-m = $(name).o

KDIR ?= /lib/modules/$(shell uname -r)/build

EXTRA_CFLAGS := -I/usr/src/linux-headers-$(shell uname -r)/arch/arm/mach-ixp4xx/include/ -I/usr/src/linux-headers-$(shell uname -r)/arch/arm/include/asm

.PHONY: module install_module install_udev install_autostart uninstall

module: $(name).ko

$(name).ko:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install_module: $(name).ko
	@sudo -E $(MAKE) -C $(KDIR) M=$(PWD) modules_install
	@sudo depmod -A

install_udev:
	@sudo cp $(PWD)/udev_scripts/servoblaster /lib/udev
	@sudo cp $(PWD)/udev_scripts/20-servoblaster.rules /etc/udev/rules.d
	@sudo chmod +x /lib/udev/servoblaster
	@echo "ServoBlaster udev rules complete."

install_autostart: install
	@echo "Enabling ServoBlaster autostart on boot."
	@if ! grep servoblaster /etc/modules > /dev/null 2>&1; then sudo sed -i '$$a\servoblaster' /etc/modules; fi
	@echo "ServoBlaster will now auto start on next boot."
	@echo "The following commands will start and stop the driver:"
#	@echo "	modprobe servoblaster"
#	@echo "	modprobe -r servoblaster"

uninstall:
	@modprobe -r servoblaster
	@sudo rm -f /lib/udev/servoblaster
	@sudo rm -f /etc/udev/rules.d/20-servoblaster.rules
	@sudo rm -f /lib/modules/$(shell uname -r)/extra/$(name).ko.xz
	@sudo depmod -a

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
