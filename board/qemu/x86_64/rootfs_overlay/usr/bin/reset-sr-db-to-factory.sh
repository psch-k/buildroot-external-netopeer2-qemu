#!/bin/sh

################################ Configuration #############
INSTALL_NETOP2_SRV_MODULES=1
INSTALL_SR_PLUGIN_MOD_VERS_MODULES=1
INSTALL_SR_PLUGIN_IF_MODULES=1
INSTALL_SR_PLUGIN_TSN_MODULES=0
ENABLE_TLS_ACCESS=1

LOGLEVEL=3

############################################################
ENABLE_TLS_RC=0
INSTALL_SSH_KEYS_RC=0

MODDIR=~/modules
OWNER=${3:-`id -un`}
GROUP=$(id -gn $OWNER)
ROOT_PERMS="-o ${OWNER} -g ${GROUP} -p 600"

if [ ! -d "${MODDIR}" ]; then
    echo "###"
    echo "### YANG srcdir \"${MODDIR}\" doesn't exist."
    echo "### Nothing done."
    echo "###"
    exit 1
fi

############################################################
#                      HELPER FUNCTIONS                    #
############################################################
checkex() {
    eval ${@}
    if [ ${?} -ne 0 ]; then
        echo "#### Error: \"${@}\""
        echo "#### pwd: \"$(pwd)\""
        exit 1
    else
        echo "#### Good: \"${@}\""
        return 0
    fi
}

checkcont() {
    eval ${@}
    if [ ${?} -ne 0 ]; then
        echo "#### Error: \"${@}\""
        return 1
    else
        echo "#### Good: \"${@}\""
        return 0
    fi
}

############################################################
#                      main                                #
############################################################

/etc/init.d/S52netopeer2 stop
killall netopeer2-server
/etc/init.d/S51sysrepo-plugind stop
killall sysrepo-plugind
killall sysrepo-plugin-interfaces
killall sysrepo-tsn
rm -rf /etc/sysrepo/*
rm -rf /dev/shm/sr_*

if [ "${INSTALL_NETOP2_SRV_MODULES}" -ne 0 ]; then
#####################
### netopeer2_server:
#####################

# ietf-netconf-acm
    checkex sysrepoctl -i ${MODDIR}/ietf-netconf-acm@2018-02-14.yang -v ${LOGLEVEL}

# ietf-netconf
    checkex sysrepoctl -U ${MODDIR}/ietf-netconf@2013-09-29.yang -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-netconf -e writable-running -e candidate -e rollback-on-error -e validate -e startup -e url -e xpath -o $OWNER -g $GROUP -p 600 -v ${LOGLEVEL}

# ietf-netconf-monitoring
    checkex sysrepoctl -i ${MODDIR}/ietf-netconf-monitoring@2010-10-04.yang -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-netconf-monitoring -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ietf-datastores
    checkex sysrepoctl -i ${MODDIR}/ietf-datastores@2017-08-17.yang -v ${LOGLEVEL}

# ietf-netconf-nmda
    checkex sysrepoctl -i ${MODDIR}/ietf-netconf-nmda@2019-01-07.yang -e origin -e with-defaults -s ${MODDIR} -v ${LOGLEVEL}

# notification modules 
    checkex sysrepoctl -i ${MODDIR}/nc-notifications@2008-07-14.yang -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -c nc-notifications -o $OWNER -g $GROUP -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/notifications@2008-07-14.yang -v ${LOGLEVEL}
    checkex sysrepoctl -c notifications -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ietf-netconf-server modules 
    checkex sysrepoctl -i ${MODDIR}/ietf-x509-cert-to-name@2014-12-10.yang -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-crypto-types@2019-07-02.yang -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-keystore@2019-07-02.yang -e keystore-supported -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-truststore@2019-07-02.yang -e truststore-supported -e x509-certificates -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-tcp-common@2019-07-02.yang -e keepalives-supported -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-ssh-server@2019-07-02.yang -e local-client-auth-supported -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-tls-server@2019-07-02.yang -e local-client-auth-supported -s ${MODDIR} -v ${LOGLEVEL}
    checkex sysrepoctl -i ${MODDIR}/ietf-netconf-server@2019-07-02.yang -e ssh-listen -e tls-listen -e ssh-call-home -e tls-call-home -s ${MODDIR} -v ${LOGLEVEL}
fi

if [ "${INSTALL_SR_PLUGIN_MOD_VERS_MODULES}" -ne 0 ]; then
#####################
## sysrepo-plugin-module-versions:
#####################

# module-versions
    checkex sysrepoctl -i ${MODDIR}/sysrepo-module-versions@2019-12-23.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c sysrepo-module-versions -o $OWNER -g $GROUP -v ${LOGLEVEL}
fi

if [ "${INSTALL_SR_PLUGIN_IF_MODULES}" -ne 0 ]; then
#####################
## sysrepo-plugin-ietf-interfaces:
#####################

# iana-if-type@2017-01-19
    checkex sysrepoctl -i ${MODDIR}/iana-if-type@2017-01-19.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c iana-if-type -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ietf-ip@2018-02-22
    checkex sysrepoctl -i ${MODDIR}/ietf-ip@2018-02-22.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-ip -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ietf-interfaces@2018-02-20
    checkex sysrepoctl -i ${MODDIR}/ietf-interfaces@2018-02-22.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-interfaces -e if-mib -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ieee802-dot1q-bridge@2018-03-07
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-bridge@2018-03-07.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-bridge -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ieee802-dot1q-sched@2018-09-10
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-sched@2018-09-10.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-sched -e scheduled-traffic -o $OWNER -g $GROUP -v ${LOGLEVEL}

# ieee802-ethernet-interface@2019-06-21
    checkex sysrepoctl -i ${MODDIR}/ieee802-ethernet-interface@2019-06-21.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-ethernet-interface -o $OWNER -g $GROUP -v ${LOGLEVEL}
fi

if [ "${INSTALL_SR_PLUGIN_TSN_MODULES}" -ne 0 ]; then
#####################
## sysrepo-tsn:
#####################

#install_yang_module iana-if-type@2017-01-19
    checkex sysrepoctl -i ${MODDIR}/iana-if-type@2017-01-19.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c iana-if-type ${ROOT_PERMS}

#install_yang_module ietf-interfaces@2014-05-08
    checkex sysrepoctl -i ${MODDIR}/ietf-interfaces@2014-05-08.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-interfaces ${ROOT_PERMS}
#install_yang_module ieee802-dot1q-types
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-types.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-types ${ROOT_PERMS}

#install_yang_module ieee802-dot1q-preemption
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-preemption.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-preemption ${ROOT_PERMS}
#enable_yang_module_feature ieee802-dot1q-preemption frame-preemption
    checkex sysrepoctl -c ieee802-dot1q-preemption -e frame-preemption

#install_yang_module ieee802-dot1q-sched
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-sched.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-sched ${ROOT_PERMS}
#enable_yang_module_feature ieee802-dot1q-sched scheduled-traffic
    checkex sysrepoctl -c ieee802-dot1q-sched -e scheduled-traffic

#install_yang_module ieee802-dot1q-bridge
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-bridge.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-bridge ${ROOT_PERMS}
#install_yang_module ietf-yang-types@2013-07-15
    checkex sysrepoctl -i ${MODDIR}/ietf-yang-types@2013-07-15.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-yang-types ${ROOT_PERMS}
#install_yang_module ieee802-types
    checkex sysrepoctl -i ${MODDIR}/ieee802-types.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-types ${ROOT_PERMS}
#install_yang_module ietf-inet-types@2013-07-15
    checkex sysrepoctl -i ${MODDIR}/ietf-inet-types@2013-07-15.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ietf-inet-types ${ROOT_PERMS}
#install_yang_module ieee802-dot1q-stream-filters-gates
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-stream-filters-gates.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-stream-filters-gates ${ROOT_PERMS}
#enable_yang_module_feature ieee802-dot1q-stream-filters-gates closed-gate-state
    checkex sysrepoctl -c ieee802-dot1q-stream-filters-gates -e closed-gate-state
#install_yang_module ieee802-dot1q-psfp
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-psfp.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-psfp ${ROOT_PERMS}
#install_yang_module ieee802-dot1q-cb-stream-identification
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-cb-stream-identification.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-cb-stream-identification ${ROOT_PERMS}
#install_yang_module ieee802-dot1q-qci-augment
    checkex sysrepoctl -i ${MODDIR}/ieee802-dot1q-qci-augment.yang -s "${MODDIR}" -v ${LOGLEVEL}
    checkex sysrepoctl -c ieee802-dot1q-qci-augment ${ROOT_PERMS}
fi

if [ "${ENABLE_TLS_ACCESS}" -ne 0 ]; then
#####################
## Enable TLS access:
#####################
    if [ ! -r ${MODDIR}/tls_keystore.xml  -o \
         ! -r ${MODDIR}/tls_truststore.xml  -o \
         ! -r ${MODDIR}/tls_listen.xml ]; then
        echo "## ERROR: tls xmls not found, couldn't enable TLS access."
        ENABLE_TLS_RC=1
    else
        checkex sysrepocfg --datastore startup --edit=${MODDIR}/tls_keystore.xml --module ietf-keystore --verbosity ${LOGLEVEL}
        checkex sysrepocfg --datastore startup --edit=${MODDIR}/tls_truststore.xml --module ietf-truststore --verbosity ${LOGLEVEL}
        checkex sysrepocfg --datastore startup --edit=${MODDIR}/tls_listen.xml --module ietf-netconf-server --verbosity ${LOGLEVEL}
    fi

    id tls-test > /dev/null 2>&1
    [ "${?}" -ne 0 ] && adduser -DH tls-test
fi

#####################
## Restore SSH keys:
#####################

    checkex sysrepocfg --datastore startup --edit=${MODDIR}/ssh-keys.xml --module ietf-keystore --verbosity ${LOGLEVEL}
    [ "${?}" -ne 0 ] && INSTALL_SSH_KEYS_RC=1
    checkex sysrepocfg --datastore startup --edit=${MODDIR}/ssh-enable.xml --module ietf-netconf-server --verbosity ${LOGLEVEL}
    [ "${?}" -ne 0 ] && INSTALL_SSH_KEYS_RC=1

##### Finally, clean the running datastore:
rm -f /dev/shm/sr_* /dev/shm/srsub_*

echo "#####"
if [ "${ENABLE_TLS_RC}" -ne 0  -o  "${INSTALL_SSH_KEYS_RC}" -ne 0 ]; then
    [ "${ENABLE_TLS_RC}" -ne 0 ] && echo "##### NOT installed: TLS access"
    [ "${INSTALL_SSH_KEYS_RC}" -ne 0 ] && echo "##### NOT installed: SSH access"
    echo "#####"
    echo "##### Rest installed."
else
    echo "##### All done."
fi
echo "#####" 

