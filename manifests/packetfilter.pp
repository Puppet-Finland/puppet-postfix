#
# == Class: postfix::packetfilter
#
# Configures packet filtering rules for postfix
#
class postfix::packetfilter
(
    $ipv4_address = '127.0.0.1',
    $ipv6_address = '::1'

) inherits postfix::params
{

    # IPv4 rules
    firewall { '014 ipv4 accept smtp port':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        port     => 25,
        source   => $ipv4_address,
        action   => 'accept',
    }

    # IPv6 rules
    firewall { '014 ipv6 accept smtp port':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        port     => 25,
        source   => $ipv6_address,
        action   => 'accept',
    }

}
