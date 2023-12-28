#
# @summary configures packet filtering rules for postfix
#
# @param ipv4_address
#   Allow this IPv4 address to connect to SNMP port (25)
# @param ipv6_address
#   Allow this IPv6 address to connect to SNMP port (25)
class postfix::packetfilter (
    $ipv4_address = '127.0.0.1',
    $ipv6_address = '::1'
) inherits postfix::params {
    # IPv4 rules
    @firewall { '014 ipv4 accept smtp port':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => 25,
        source   => $ipv4_address,
        action   => 'accept',
        tag      => 'default',
    }

    # IPv6 rules
    @firewall { '014 ipv6 accept smtp port':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => 25,
        source   => $ipv6_address,
        action   => 'accept',
        tag      => 'default',
    }
}
