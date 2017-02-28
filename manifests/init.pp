#
# == Class: postfix
#
# Postfix class installs and configures postfix mail transfer agent for basic mail sending.
#
# == Parameters
#
# [*manage*]
#  Whether to manage postfix with Puppet or not. Valid values are true
#  (default) and false.
# [*serveradmin*]
#   An email address where mail for root should be sent to. Defaults to the 
#   top-scope variable $::serveradmin.
# [*relayhost*]
#   The host used for relaying mail. Defaults to undef which means that Postfix 
#   will try to send mail directly. An optional port can be added after the 
#   hostname. Example: mail.domain.com:587
# [*smtp_username*]
#   Username to use for authenticating with the relayhost. Undef by default. 
#   This should be given if the receiving SMTP server(s) block unauthenticated 
#   SMTP connections. Encrypted connections are assumed. Note that this should 
#   only be set if using a relayhost - local postfix instances as configured by 
#   this module do not support or need SMTP authentication.
# [*smtp_password*]
#   Password for the SMTP user.
# [*domain_mail_server*]
#   Selects whether to configure this postfix instance to receive mail for the
#   entire domain, or only for itself. Defaults to 'no'.
# [*inet_interfaces*]
#   Interfaces and/or IPv4/IPv6 addresses on which postfix will listen on. 
#   Special values are 'all' and 'loopback-only'. Defaults to 'loopback-only'.
# [*smtp_host_lookup*]
#   Value of smtp_host_lookup parameter in main.cf. Defaults to 'dns, native', 
#   which typically seems to work best. In some cases reversing this lookup 
#   order helps.
# [*allow_ipv4_address*]
#   Allow SNMP connections from this IPv4 address/subnet. Defaults to 127.0.0.1.
# [*allow_ipv6_address*]
#   The IP-address part of an IPv6 subnet from which to allow connections.
#   Defaults to ::1.
# [*allow_ipv6_netmask*]
#   The netmask of the IPv6 subnet from which to allow connections. Defaults to
#   128. This is required because postfix needs IPv6 addresses in [::1]/128
#   format, which conflicts with puppet's array definitions.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to.
#   Defaults to top scope variable $::servermonitor.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# Mikko Vilpponen <vilpponen@protecomp.fi>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class postfix
(
    Boolean $manage = true,
    $serveradmin = $::serveradmin,
    $mailaliases = {},
    $generic_mappings = {},
    $relayhost = undef,
    $smtp_username = undef,
    $smtp_password = undef,
    $domain_mail_server = 'no',
    $inet_interfaces = 'loopback-only',
    $smtp_host_lookup = 'dns, native',
    $allow_ipv4_address = '127.0.0.1',
    $allow_ipv6_address = '::1',
    $allow_ipv6_netmask = '128',
    $monitor_email = $::servermonitor
)
{

if $manage {

    include ::postfix::install

    class {'::postfix::config':
        serveradmin        => $serveradmin,
        mailaliases        => $mailaliases,
        generic_mappings   => $generic_mappings,
        relayhost          => $relayhost,
        smtp_username      => $smtp_username,
        smtp_password      => $smtp_password,
        domain_mail_server => $domain_mail_server,
        inet_interfaces    => $inet_interfaces,
        smtp_host_lookup   => $smtp_host_lookup,
        allow_ipv4_address => $allow_ipv4_address,
        allow_ipv6_address => $allow_ipv6_address,
        allow_ipv6_netmask => $allow_ipv6_netmask,
    }

    include ::postfix::service

    # FreeBSD requires additional configuration
    if $::operatingsystem == 'FreeBSD' {
        include ::postfix::config::freebsd
    }

    if tagged('packetfilter') {
        class {'::postfix::packetfilter':
            ipv4_address => $allow_ipv4_address,
            ipv6_address => "${allow_ipv6_address}/${allow_ipv6_netmask}",
        }
    }

    if tagged('monit') {
        class { '::postfix::monit':
            monitor_email => $monitor_email,
        }
    }
}
}
