# Base

Starting with hpierce/docker-kali-base

Added:  
splunk 6.6.1 

Started with splunk/splunk:latest, but it was overcomplicated and ran as root.  

Kept getting:  

homePath='/opt/splunk/var/lib/splunk/audit/db' of index=audit on unusable filesystem.  
Validating databases (splunkd validatedb) failed with code '1'.  

Solution is:

Add the following to $SPLUNK_HOME/etc/splunk-launch.conf:

OPTIMISTIC_ABOUT_FILE_LOCKING = 1


