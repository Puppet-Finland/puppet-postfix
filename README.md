# postfix

A general-purpose postfix module for Puppet. Includes support for monit
monitoring and iptables/ip6tables management.

# Module usage

Example 1: configure postfix with reasonable defaults for many environments

    include ::postfix

Example 2: configure postfix without direct Internet connection to use an 
internal relayhost which does not require authentication:

    class { '::postfix':
      relayhost => 'proxy.example.org',
    }

Example 3: configure postfix to act as a relayhost for the internal network:

    class { '::postfix':
      allow_ipv4_address => '10.71.14.0/24',
      inet_interfaces:   => '127.0.0.1 [::1] 10.71.14.150',
    }

Example 4: configure postfix to send email using a real SMTP account and also 
rewrite MAIL FROM in the envelope and the message header for certain users with 
the SMTP username. This is suitable for use with very strict SMTP servers:

    class { '::postfix':
      relayhost     => 'myisp.domain.com:587',
      smtp_username => 'status@example.org',
      smtp_password => 'password',
    }

    ::postfix::generic_mapping { 'root':
      pattern => 'root',
      result  => 'status@example.org',
    }

    ::postfix::generic_mapping { 'monit':
      pattern => 'monit',
      result  => 'status@example.org',
    }

Example 5: add additional mailaliases:

    ::postfix::mailalias { 'john':
        recipient => 'john.doe@example.org',
    }

For details see these classes/defines:

* [Class: postfix](manifests/init.pp)
* [Define: postfix::generic_mapping](manifests/generic_mapping.pp)
* [Define: postfix::mailalias](manifests/mailalias.pp)
