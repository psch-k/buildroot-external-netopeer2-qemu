################################################################################
#
# sysrepo-tsn
#
################################################################################

SYSREPO_TSN_VERSION = v0.2
SYSREPO_TSN_SITE = $(call github,openil,sysrepo-tsn,$(SYSREPO_TSN_VERSION))
SYSREPO_TSN_LICENSE = Apache-2.0
SYSREPO_TSN_REDISTRIBUTE = NO
#SYSREPO_TSN_DEPENDENCIES = host-sysrepo sysrepo cjson libnl gen-nl libtsn
SYSREPO_TSN_DEPENDENCIES = host-sysrepo sysrepo cjson tsntool

SYSREPO_TSN_CONF_OPTS = \
	-DSYSREPOCTL_ROOT_PERMS:STRING=" " \
	-DSYSREPOCTL_EXECUTABLE=$(HOST_DIR)/bin/sysrepoctl \
	-DSYSREPOCFG_EXECUTABLE=$(HOST_DIR)/bin/sysrepocfg \

$(eval $(cmake-package))
