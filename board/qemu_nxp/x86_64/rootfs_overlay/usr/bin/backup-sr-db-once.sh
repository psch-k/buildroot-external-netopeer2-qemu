#!/bin/sh

MODDIR=~/modules
LOGLEVEL=4

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
    fi
}

checkcont() {
    eval ${@}
    if [ ${?} -ne 0 ]; then
        echo "#### Error: \"${@}\""
    else
        echo "#### Good: \"${@}\""
    fi
}

############################################################
#                      main                                #
############################################################

mkdir -p "${MODDIR}"
cp /etc/sysrepo/yang/*.yang "${MODDIR}"

#####################
## Backup SSH keys:
#####################
checkex sysrepocfg --export="${MODDIR}/ssh-keys.xml" --xpath /ietf-keystore:keystore//* -v ${LOGLEVEL}
checkex sysrepocfg --export="${MODDIR}/ssh-enable.xml" --xpath /ietf-netconf-server:netconf-server/listen/endpoint -v ${LOGLEVEL}

echo "#####"
echo "##### All done."
echo "#####" 

