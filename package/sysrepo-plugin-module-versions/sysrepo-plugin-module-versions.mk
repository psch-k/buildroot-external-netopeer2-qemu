################################################################################
#
# sysrepo-plugin-module-versions
#
################################################################################

SYSREPO_PLUGIN_MODULE_VERSIONS_VERSION = f74d98e077d8a6c259c23509964f08f8bad27ab9
SYSREPO_PLUGIN_MODULE_VERSIONS_SITE = git://git.sab.local/sl28/sysrepo-plugin-module-versions.git
SYSREPO_PLUGIN_MODULE_VERSIONS_LICENSE = PROPRIETARY
SYSREPO_PLUGIN_MODULE_VERSIONS_REDISTRIBUTE = NO
SYSREPO_PLUGIN_MODULE_VERSIONS_DEPENDENCIES = host-sysrepo sysrepo

SYSREPO_PLUGIN_MODULE_VERSIONS_CONF_OPTS = \
	-DSYSREPOCTL_EXECUTABLE=$(HOST_DIR)/bin/sysrepoctl \
	-DSYSREPOCFG_EXECUTABLE=$(HOST_DIR)/bin/sysrepocfg \
	-DYANG_SET:String=IpSolutionRef_2_1_0

$(eval $(cmake-package))
