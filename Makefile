INSTALL_FW_PATH = $(INSTALL_MOD_PATH)/lib/firmware
FW_DIR	:= $(INSTALL_FW_PATH)/rtl_bt
MODDESTDIR := kernel/drivers/net/wireless/

DEPMOD  = /sbin/depmod

ccflags-y += $(USER_EXTRA_CFLAGS)
ccflags-y += -O1
#EXTRA_CFLAGS += -O3
#EXTRA_CFLAGS += -Wall
#EXTRA_CFLAGS += -Wextra
#EXTRA_CFLAGS += -Werror
#EXTRA_CFLAGS += -pedantic
#EXTRA_CFLAGS += -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes

ccflags-y += -Wno-unused-variable
ccflags-y += -Wno-unused-value
ccflags-y += -Wno-unused-label
ccflags-y += -Wno-unused-parameter
ccflags-y += -Wno-unused-function
ccflags-y += -Wno-unused
ccflags-y += -DCONFIG_CONCURRENT_MODE

ccflags-y += -D__CHECK_ENDIAN__

#ccflags-y += -Wno-uninitialized

ccflags-y += -g -I$(src)/include

#EXTRA_LDFLAGS += --strip-debug

CONFIG_AUTOCFG_CP = n

########################## WIFI IC ############################
CONFIG_RTL8723B = y
########################## Features ###########################
CONFIG_POWER_SAVING = y
CONFIG_USB_AUTOSUSPEND = n
CONFIG_HW_PWRP_DETECTION = n
CONFIG_WIFI_TEST = n
CONFIG_BT_COEXIST = y
CONFIG_INTEL_WIDI = n
CONFIG_WAPI_SUPPORT = n
CONFIG_EFUSE_CONFIG_FILE = n
CONFIG_EXT_CLK = n
CONFIG_TRAFFIC_PROTECT = y
CONFIG_LOAD_PHY_PARA_FROM_FILE = y
CONFIG_CALIBRATE_TX_POWER_BY_REGULATORY = n
CONFIG_CALIBRATE_TX_POWER_TO_MAX = n
CONFIG_RTW_ADAPTIVITY_EN = auto
CONFIG_RTW_ADAPTIVITY_MODE = normal
CONFIG_SKIP_SIGNAL_SCALE_MAPPING = n
######################## Wake On Lan ##########################
CONFIG_WOWLAN = n
CONFIG_GPIO_WAKEUP = n
CONFIG_PNO_SUPPORT = n
CONFIG_PNO_SET_DEBUG = n
CONFIG_AP_WOWLAN = n
###################### Platform Related #######################
CONFIG_PLATFORM_I386_PC = y
CONFIG_PLATFORM_FS_MX61 = n
###############################################################

CONFIG_DRVEXT_MODULE = n

export TopDIR ?= $(shell pwd)

########### COMMON  #################################
HCI_NAME = usb

_OS_INTFS_FILES :=	os_dep/osdep_service.o \
			os_dep/os_intfs.o \
			os_dep/usb_intf.o \
			os_dep/usb_ops_linux.o \
			os_dep/ioctl_linux.o \
			os_dep/xmit_linux.o \
			os_dep/mlme_linux.o \
			os_dep/recv_linux.o \
			os_dep/ioctl_cfg80211.o \
			os_dep/wifi_regd.o \
			os_dep/rtw_android.o \
			os_dep/rtw_proc.o

_HAL_INTFS_FILES :=	hal/hal_intf.o \
			hal/hal_com.o \
			hal/hal_com_phycfg.o \
			hal/hal_phy.o \
			hal/hal_btcoex.o \
			hal/hal_usb.o \
			hal/hal_usb_led.o
			
_OUTSRC_FILES := hal/odm_debug.o	\
		hal/odm_AntDiv.o\
		hal/odm_interface.o\
		hal/odm_HWConfig.o\
		hal/odm.o\
		hal/HalPhyRf.o\
		hal/odm_EdcaTurboCheck.o\
		hal/odm_DIG.o\
		hal/odm_PathDiv.o\
		hal/odm_RaInfo.o\
		hal/odm_DynamicBBPowerSaving.o\
		hal/odm_DynamicTxPower.o\
		hal/odm_CfoTracking.o\
		hal/odm_NoiseMonitor.o
		
ccflags-y += -I$(src)/platform
_PLATFORM_FILES := platform/platform_ops.o

ifeq ($(CONFIG_BT_COEXIST), y)
ccflags-y += -I$(src)/hal
_OUTSRC_FILES += hal/HalBtc8723b1Ant.o \
		 hal/HalBtc8723b2Ant.o
endif


########### HAL_RTL8723B #################################

RTL871X = rtl8723b
MODULE_NAME = 8723bu

_HAL_INTFS_FILES += hal/HalPwrSeqCmd.o \
					hal/Hal8723BPwrSeq.o\
					hal/$(RTL871X)_sreset.o

_HAL_INTFS_FILES +=	hal/$(RTL871X)_hal_init.o \
			hal/$(RTL871X)_phycfg.o \
			hal/$(RTL871X)_rf6052.o \
			hal/$(RTL871X)_dm.o \
			hal/$(RTL871X)_rxdesc.o \
			hal/$(RTL871X)_cmd.o \
			

_HAL_INTFS_FILES +=	\
			hal/usb_halinit.o \
			hal/rtl$(MODULE_NAME)_led.o \
			hal/rtl$(MODULE_NAME)_xmit.o \
			hal/rtl$(MODULE_NAME)_recv.o

_HAL_INTFS_FILES += hal/usb_ops.o

_OUTSRC_FILES += hal/HalHWImg8723B_BB.o\
			hal/HalHWImg8723B_MAC.o\
			hal/HalHWImg8723B_RF.o\
			hal/HalHWImg8723B_FW.o\
			hal/odm_RegConfig8723B.o\
			hal/HalPhyRf_8723B.o\
			hal/odm_RTL8723B.o


########### AUTO_CFG  #################################	
		
ifeq ($(CONFIG_AUTOCFG_CP), y)
$(shell cp $(TopDIR)/autoconf_$(RTL871X)_usb_linux.h $(TopDIR)/include/autoconf.h)
endif

########### END OF PATH  #################################


ifeq ($(CONFIG_USB_AUTOSUSPEND), y)
ccflags-y += -DCONFIG_USB_AUTOSUSPEND
endif

ifeq ($(CONFIG_POWER_SAVING), y)
ccflags-y += -DCONFIG_POWER_SAVING
endif

ifeq ($(CONFIG_HW_PWRP_DETECTION), y)
ccflags-y += -DCONFIG_HW_PWRP_DETECTION
endif

ifeq ($(CONFIG_WIFI_TEST), y)
ccflags-y += -DCONFIG_WIFI_TEST
endif

ifeq ($(CONFIG_BT_COEXIST), y)
ccflags-y += -DCONFIG_BT_COEXIST
endif

ifeq ($(CONFIG_INTEL_WIDI), y)
ccflags-y += -DCONFIG_INTEL_WIDI
endif

ifeq ($(CONFIG_WAPI_SUPPORT), y)
ccflags-y += -DCONFIG_WAPI_SUPPORT
endif


ifeq ($(CONFIG_EFUSE_CONFIG_FILE), y)
ccflags-y += -DCONFIG_EFUSE_CONFIG_FILE
ifeq ($(MODULE_NAME), 8189es)
ccflags-y += -DEFUSE_MAP_PATH=\"/system/etc/wifi/wifi_efuse_8189e.map\"
else
ccflags-y += -DEFUSE_MAP_PATH=\"/system/etc/wifi/wifi_efuse_$(MODULE_NAME).map\"
endif
ccflags-y += -DWIFIMAC_PATH=\"/data/wifimac.txt\"
endif

ifeq ($(CONFIG_EXT_CLK), y)
ccflags-y += -DCONFIG_EXT_CLK
endif

ifeq ($(CONFIG_TRAFFIC_PROTECT), y)
ccflags-y += -DCONFIG_TRAFFIC_PROTECT
endif

ifeq ($(CONFIG_LOAD_PHY_PARA_FROM_FILE), y)
ccflags-y += -DCONFIG_LOAD_PHY_PARA_FROM_FILE
endif

ifeq ($(CONFIG_CALIBRATE_TX_POWER_BY_REGULATORY), y)
ccflags-y += -DCONFIG_CALIBRATE_TX_POWER_BY_REGULATORY
endif

ifeq ($(CONFIG_CALIBRATE_TX_POWER_TO_MAX), y)
ccflags-y += -DCONFIG_CALIBRATE_TX_POWER_TO_MAX
endif

ifeq ($(CONFIG_RTW_ADAPTIVITY_EN), disable)
ccflags-y += -DCONFIG_RTW_ADAPTIVITY_EN=0
else ifeq ($(CONFIG_RTW_ADAPTIVITY_EN), enable)
ccflags-y += -DCONFIG_RTW_ADAPTIVITY_EN=1
else ifeq ($(CONFIG_RTW_ADAPTIVITY_EN), auto)
ccflags-y += -DCONFIG_RTW_ADAPTIVITY_EN=2
endif

ifeq ($(CONFIG_RTW_ADAPTIVITY_MODE), normal)
ccflags-y += -DCONFIG_RTW_ADAPTIVITY_MODE=0
else ifeq ($(CONFIG_RTW_ADAPTIVITY_MODE), carrier_sense)
ccflags-y += -DCONFIG_RTW_ADAPTIVITY_MODE=1
endif

ifeq ($(CONFIG_SKIP_SIGNAL_SCALE_MAPPING), y)
ccflags-y += -DCONFIG_SKIP_SIGNAL_SCALE_MAPPING
endif

ifeq ($(CONFIG_WOWLAN), y)
ccflags-y += -DCONFIG_WOWLAN
endif

ifeq ($(CONFIG_AP_WOWLAN), y)
ccflags-y += -DCONFIG_AP_WOWLAN
endif

ifeq ($(CONFIG_PNO_SUPPORT), y)
ccflags-y += -DCONFIG_PNO_SUPPORT
ifeq ($(CONFIG_PNO_SET_DEBUG), y)
ccflags-y += -DCONFIG_PNO_SET_DEBUG
endif
endif

ifeq ($(CONFIG_GPIO_WAKEUP), y)
ccflags-y += -DCONFIG_GPIO_WAKEUP
endif


ifeq ($(CONFIG_PLATFORM_I386_PC), y)
ccflags-y += -DCONFIG_IOCTL_CFG80211
ccflags-y += -DRTW_USE_CFG80211_STA_EVENT # only enable when kernel >= 3.2
ccflags-y += -DCONFIG_P2P_IPS
SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ | sed -e s/ppc/powerpc/ | sed -e s/armv.l/arm/)
ARCH ?= $(SUBARCH)
CROSS_COMPILE ?=
KVER  := $(shell uname -r)
KSRC := /lib/modules/$(KVER)/build
INSTALL_PREFIX :=
endif

ifeq ($(CONFIG_PLATFORM_FS_MX61), y)
ccflags-y += -DCONFIG_IOCTL_CFG80211
ccflags-y += -DRTW_USE_CFG80211_STA_EVENT # only enable when kernel >= 3.2
ccflags-y += -DCONFIG_P2P_IPS
ccflags-y += -DCONFIG_LITTLE_ENDIAN -Wno-error=date-time
ARCH := arm
KSRC ?= $(KERNEL_SRC)
LICENSE = "GPLv2"
endif

ifneq ($(USER_MODULE_NAME),)
MODULE_NAME := $(USER_MODULE_NAME)
endif


ifneq ($(KERNELRELEASE),)

rtk_core :=	core/rtw_cmd.o \
		core/rtw_security.o \
		core/rtw_debug.o \
		core/rtw_io.o \
		core/rtw_ioctl_query.o \
		core/rtw_ioctl_set.o \
		core/rtw_ieee80211.o \
		core/rtw_mlme.o \
		core/rtw_mlme_ext.o \
		core/rtw_wlan_util.o \
		core/rtw_vht.o \
		core/rtw_pwrctrl.o \
		core/rtw_rf.o \
		core/rtw_recv.o \
		core/rtw_sta_mgt.o \
		core/rtw_ap.o \
		core/rtw_xmit.o	\
		core/rtw_p2p.o \
		core/rtw_tdls.o \
		core/rtw_br_ext.o \
		core/rtw_iol.o \
		core/rtw_sreset.o \
		core/rtw_btcoex.o \
		core/rtw_beamforming.o \
		core/rtw_odm.o \
		core/rtw_efuse.o

$(MODULE_NAME)-y += $(rtk_core)

$(MODULE_NAME)-$(CONFIG_INTEL_WIDI) += core/rtw_intel_widi.o

$(MODULE_NAME)-$(CONFIG_WAPI_SUPPORT) += core/rtw_wapi.o	\
					core/rtw_wapi_sms4.o
					
$(MODULE_NAME)-y += $(_OS_INTFS_FILES)
$(MODULE_NAME)-y += $(_HAL_INTFS_FILES)
$(MODULE_NAME)-y += $(_OUTSRC_FILES)
$(MODULE_NAME)-y += $(_PLATFORM_FILES)

obj-m := $(MODULE_NAME).o

else

all: modules

modules:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KSRC) M=$(shell pwd)  modules

strip:
	$(CROSS_COMPILE)strip $(MODULE_NAME).ko --strip-unneeded

install: modules_install
ifeq ($(INSTALL_MOD_PATH),)
	$(DEPMOD) -a ${KVER}
else
	$(DEPMOD) -b "$(INSTALL_MOD_PATH)" -a ${KVER}
endif
	install rtl8723b_fw.bin -D $(FW_DIR)/rtl8723b_fw.bin

modules_install:
	$(MAKE) INSTALL_MOD_DIR=$(MODDESTDIR) -C $(KSRC) M=$(shell pwd) modules_install

uninstall:
	rm -f /lib/modules/$(KVER)/$(MODDESTDIR)$(MODULE_NAME).ko
	$(DEPMOD) -a ${KVER}
	rm -f $(FW_DIR)/rtl8723b_fw.bin

config_r:
	@echo "make config"
	/bin/bash script/Configure script/config.in


.PHONY: modules clean

clean:
	cd hal ; rm -fr *.mod.c *.mod *.o .*.cmd */*.ko
	cd core ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
	cd os_dep ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
	cd platform ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
	rm -fr Module.symvers ; rm -fr Module.markers ; rm -fr modules.order
	rm -fr *.mod.c *.mod *.o .*.cmd *.ko *~
	rm -fr .tmp_versions .cache.mk
endif

