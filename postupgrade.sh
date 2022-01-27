#!/bin/bash

# Bash script which is executed in case of an update (if this plugin is already
# installed on the system). This script is executed as very last step (*AFTER*
# postinstall) and can be for example used to save back or convert saved
# userfiles from /tmp back to the system. Use with caution and remember, that
# all systems may be different!
#
# Exit code must be 0 if executed successfull.
# Exit code 1 gives a warning but continues installation.
# Exit code 2 cancels installation.
#
# Will be executed as user "loxberry".
#
# You can use all vars from /etc/environment in this script.
#
# We add 5 additional arguments when executing this script:
# command <TEMPFOLDER> <NAME> <FOLDER> <VERSION> <BASEFOLDER>
#
# For logging, print to STDOUT. You can use the following tags for showing
# different colorized information during plugin installation:
#
# <OK> This was ok!"
# <INFO> This is just for your information."
# <WARNING> This is a warning!"
# <ERROR> This is an error!"
# <FAIL> This is a fail!"

# To use important variables from command line use the following code:
COMMAND=$0    # Zero argument is shell command
PTEMPDIR=$1   # First argument is temp folder during install
PSHNAME=$2    # Second argument is Plugin-Name for scipts etc.
PDIR=$3       # Third argument is Plugin installation folder
PVERSION=$4   # Forth argument is Plugin version
#LBHOMEDIR=$5 # Comes from /etc/environment now. Fifth argument is
              # Base folder of LoxBerry
PTEMPPATH=$6  # Sixth argument is full temp path during install (see also $1)

# Combine them with /etc/environment
PCGI=$LBPCGI/$PDIR
PHTML=$LBPHTML/$PDIR
PTEMPL=$LBPTEMPL/$PDIR
PDATA=$LBPDATA/$PDIR
PLOG=$LBPLOG/$PDIR # Note! This is stored on a Ramdisk now!
PCONFIG=$LBPCONFIG/$PDIR
PSBIN=$LBPSBIN/$PDIR
PBIN=$LBPBIN/$PDIR

#echo -n "<INFO> Current working folder is: "
#pwd
#echo "<INFO> Command is: $COMMAND"
#echo "<INFO> Temporary folder is: $PTEMPDIR"
#echo "<INFO> (Short) Name is: $PSHNAME"
#echo "<INFO> Installation folder is: $PDIR"
#echo "<INFO> Plugin version is: $PVERSION"
#echo "<INFO> Plugin CGI folder is: $PCGI"
#echo "<INFO> Plugin HTML folder is: $PHTML"
#echo "<INFO> Plugin Template folder is: $PTEMPL"
#echo "<INFO> Plugin Data folder is: $PDATA"
#echo "<INFO> Plugin Log folder (on RAMDISK!) is: $PLOG"
#echo "<INFO> Plugin CONFIG folder is: $PCONFIG"

echo "<INFO> Copy back existing config files"
cp -v /tmp/$PTEMPDIR/_upgrade/config/p1decrypter.cfg $PCONFIG/p1decrypter.cfg

echo "<INFO> Adding new config parameters"
grep -q -F "SEND_MQTT=" $PCONFIG/p1decrypter.cfg || echo "SEND_MQTT=0" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_USE_GATEWAY=" $PCONFIG/p1decrypter.cfg || echo "MQTT_USE_GATEWAY=0" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_BROKER=" $PCONFIG/p1decrypter.cfg || echo "MQTT_BROKER=" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_BROKER_USERNAME=" $PCONFIG/p1decrypter.cfg || echo "MQTT_BROKER_USERNAME=" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_BROKER_PASSWORD=" $PCONFIG/p1decrypter.cfg || echo "MQTT_BROKER_PASSWORD=" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_BROKER_PORT=" $PCONFIG/p1decrypter.cfg || echo "MQTT_BROKER_PORT=1883" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_TOPIC_PREFIX=" $PCONFIG/p1decrypter.cfg || echo "MQTT_TOPIC_PREFIX=p1decrypter" >> $PCONFIG/p1decrypter.cfg
grep -q -F "MQTT_TOPIC_QOS=" $PCONFIG/p1decrypter.cfg || echo "MQTT_TOPIC_QOS=1" >> $PCONFIG/p1decrypter.cfg

echo "<INFO> Remove temporary folders"
rm -rf /tmp/$PTEMPDIR/_upgrade

exit 0
