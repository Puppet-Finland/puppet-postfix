# postfix

A general-purpose postfix module for Puppet

# Module usage

Example 1: configure postfix with reasonable defaults for many environments

    classes:
        - postfix

Example 2: configure postfix without direct Internet connection to use an 
internal relayhost which does not require authentication:

    classes:
        - postfix
    
    postfix::relayhost: 'proxy.mydomain.com'

Example 3: configure postfix to act as a relayhost for the internal network:

    classes:
        - postfix
    
    postfix::allow_ipv4_address: '10.71.14.0/24'
    postfix::inet_interfaces: '127.0.0.1 [::1] 10.71.14.150' 

Example 4: configure postfix to send email using a real SMTP account and also 
rewrite MAIL FROM in the envelope and the message header for certain users with 
the SMTP username. This is suitable for use with very strict SMTP servers:

    classes:
        - postfix
    
    postfix::generic_mappings:
        root: {}
        monit: {}
    
    postfix::relayhost: 'myisp.domain.com:587'
    postfix::smtp_username: 'status@mydomain.com'
    postfix::smtp_password: 'password'

Example 5: add additional mailaliases:

    postfix::mailaliases:
        john:
            recipient: 'johndoe@otherdomain.com'

For details see these classes/defines:

* [Class: postfix](manifests/init.pp)
* [Define: postfix::generic_mapping](manifests/generic_mapping.pp)
# [Define: postfix::mailalias](manifests/mailalias.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 6 and 7
* Ubuntu 10.04 - 14.04
* FreeBSD 10
* CentOS 6 and 7

Support for most Linux/BSD operating systems (SLES/OpenSuSE being an exception) 
should be easy to add.

For details see [params.pp](manifests/params.pp).
