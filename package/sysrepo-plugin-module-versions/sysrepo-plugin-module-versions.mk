################################################################################
#
# sysrepo-plugin-module-versions
#
################################################################################

#SYSREPO_PLUGIN_MODULE_VERSIONS_VERSION = 1e2e84f5bf88be0552717a7cf674f05f74e84ec5
SYSREPO_PLUGIN_MODULE_VERSIONS_VERSION = 59929a005a01f813d80fb44b5371e5ba421828bc
SYSREPO_PLUGIN_MODULE_VERSIONS_SITE = git://git.sab.local/sl28/sysrepo-plugin-module-versions.git
SYSREPO_PLUGIN_MODULE_VERSIONS_LICENSE = PROPRIETARY
SYSREPO_PLUGIN_MODULE_VERSIONS_REDISTRIBUTE = NO
SYSREPO_PLUGIN_MODULE_VERSIONS_DEPENDENCIES = host-sysrepo sysrepo

SYSREPO_PLUGIN_MODULE_VERSIONS_CONF_OPTS = \
	-DSYSREPOCTL_ROOT_PERMS:STRING=" " \
	-DSYSREPOCTL_EXECUTABLE=$(HOST_DIR)/bin/sysrepoctl \
	-DSYSREPOCFG_EXECUTABLE=$(HOST_DIR)/bin/sysrepocfg \

$(eval $(cmake-package))
