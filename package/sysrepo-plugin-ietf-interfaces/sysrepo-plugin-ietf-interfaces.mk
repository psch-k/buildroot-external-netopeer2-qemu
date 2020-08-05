################################################################################
#
# sysrepo-plugin-ietf-interfaces
#
################################################################################

SYSREPO_PLUGIN_IETF_INTERFACES_VERSION = 366b564392d0401d96f5db9cd98898d0d0f9db1b
SYSREPO_PLUGIN_IETF_INTERFACES_SITE = git://git.sab.local/sl28/sysrepo-plugin-ietf-interfaces.git
SYSREPO_PLUGIN_IETF_INTERFACES_LICENSE = PROPRIETARY
SYSREPO_PLUGIN_IETF_INTERFACES_REDISTRIBUTE = NO
SYSREPO_PLUGIN_IETF_INTERFACES_DEPENDENCIES = host-sysrepo sysrepo libglib2 libnl

SYSREPO_PLUGIN_IETF_INTERFACES_CONF_OPTS = \
	-DSYSREPOCTL_EXECUTABLE=$(HOST_DIR)/bin/sysrepoctl \
	-DSYSREPOCFG_EXECUTABLE=$(HOST_DIR)/bin/sysrepocfg \
	$(if $(BR2_PACKAGE_SYSREPO_PLUGIN_IETF_INTERFACES_DEBUG),-DCMAKE_BUILD_TYPE=debug)

$(eval $(cmake-package))
