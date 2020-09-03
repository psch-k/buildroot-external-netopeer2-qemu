################################################################################
#
# sysrepo-tsn
#
################################################################################

SYSREPO_TSN_VERSION = 652048a10257b4ac900a41ebe3bd263f0ccfcee3
SYSREPO_TSN_SITE = git://git.sab.local/sl28/sysrepo-tsn.git
SYSREPO_TSN_LICENSE = Apache-2.0
SYSREPO_TSN_REDISTRIBUTE = NO
SYSREPO_TSN_DEPENDENCIES = host-sysrepo sysrepo cjson tsntool

SYSREPO_TSN_CONF_OPTS = \
	-DSYSREPOCTL_ROOT_PERMS:STRING=" " \
	-DSYSREPOCTL_EXECUTABLE=$(HOST_DIR)/bin/sysrepoctl \
	-DSYSREPOCFG_EXECUTABLE=$(HOST_DIR)/bin/sysrepocfg \

$(eval $(cmake-package))

