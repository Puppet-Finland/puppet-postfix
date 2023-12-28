#
# @summary install and configures postfix MTA for basic mail sending
#
# @param manage
#   Whether to manage postfix with Puppet or not.
# @param manage_packetfilter
#   Manage packet filtering rules for postfix.
# @param manage_monit
#   Monitor postfix with monit.
# @param serveradmin
#   An email address where mail for root should be sent to.
# @param relayhost
#   The host used for relaying mail. Defaults to undef which means that Postfix 
#   will try to send mail directly. An optional port can be added after the 
#   hostname. Example: mail.domain.com:587
# @param smtp_username
#   Username to use for authenticating with the relayhost. Undef by default. 
#   This should be given if the receiving SMTP server(s) block unauthenticated 
#   SMTP connections. Encrypted connections are assumed. Note that this should 
#   only be set if using a relayhost - local postfix instances as configured by 
#   this module do not support or need SMTP authentication.
# @param smtp_password
#   Password for the SMTP user.
# @param domain_mail_server
#   Selects whether to configure this postfix instance to receive mail for the
#   entire domain, or only for itself.
# @param inet_interfaces
#   Interfaces and/or IPv4/IPv6 addresses on which postfix will listen on. 
#   Special values are 'all' and 'loopback-only'.
# @param smtp_host_lookup
#   Value of smtp_host_lookup parameter in main.cf. Defaults to 'dns, native', 
#   which typically seems to work best. In some cases reversing this lookup 
#   order helps.
# @param non_smtpd_milters
#   Passed as the non_smtpd_milters option to main.cf.
# @param allow_ipv4_address
#   Allow SNMP connections from this IPv4 address/subnet.
# @param allow_ipv6_address
#   The IP-address part of an IPv6 subnet from which to allow connections.
# @param allow_ipv6_netmask
#   The netmask of the IPv6 subnet from which to allow connections. This is
#   required because postfix needs IPv6 addresses in [::1]/128 format, which
#   conflicts with puppet's array definitions.
# @param monitor_email
#   Email address where local service monitoring software sends it's reports to.
# @param origin
#   The domain name that locally-posted mail appears to come from, and that
#   locally posted mail is delivered to. The default, $::fqdn, is adequate for small sites.
# @param root_email_to
#   Where to send root email
# @param mailaliases
#   A hash of mailaliases to realize
# @param generic_mappings
#   A hash of generic mappings to realize
# @param service_ensure
#   Status of the postfix service
class postfix (
  Boolean          $manage = true,
  Boolean          $manage_packetfilter = true,
  Boolean          $manage_monit = true,
  String           $serveradmin = $facts['serveradmin'],
  Optional[Variant[String,Array[String]]] $root_email_to = undef,
  Hash             $mailaliases = {},
  Hash             $generic_mappings = {},
  Optional[String] $relayhost = undef,
  Optional[String] $smtp_username = undef,
  Optional[String] $smtp_password = undef,
  Optional[String] $non_smtpd_milters = undef,
  Optional[Enum['running']] $service_ensure = undef,
  Enum['yes','no'] $domain_mail_server = 'no',
  String           $inet_interfaces = 'loopback-only',
  String           $smtp_host_lookup = 'dns, native',
  String           $allow_ipv4_address = '127.0.0.1',
  String           $allow_ipv6_address = '::1',
  String           $allow_ipv6_netmask = '128',
  String           $monitor_email = $facts['servermonitor'],
  String           $origin = $facts['networking']['fqdn'],
) {
  if $manage {
    include postfix::install

    class { 'postfix::config':
      serveradmin        => $serveradmin,
      root_email_to      => $root_email_to,
      mailaliases        => $mailaliases,
      generic_mappings   => $generic_mappings,
      relayhost          => $relayhost,
      smtp_username      => $smtp_username,
      smtp_password      => $smtp_password,
      domain_mail_server => $domain_mail_server,
      inet_interfaces    => $inet_interfaces,
      smtp_host_lookup   => $smtp_host_lookup,
      non_smtpd_milters  => $non_smtpd_milters,
      allow_ipv4_address => $allow_ipv4_address,
      allow_ipv6_address => $allow_ipv6_address,
      allow_ipv6_netmask => $allow_ipv6_netmask,
      origin             => $origin,
    }

    class { 'postfix::service':
      ensure => $service_ensure,
    }

    # FreeBSD requires additional configuration
    if $facts['os']['name'] == 'FreeBSD' {
      include postfix::config::freebsd
    }

    if $manage_packetfilter {
      class { 'postfix::packetfilter':
        ipv4_address => $allow_ipv4_address,
        ipv6_address => "${allow_ipv6_address}/${allow_ipv6_netmask}",
      }
    }

    if $manage_monit {
      class { 'postfix::monit':
        monitor_email => $monitor_email,
      }
    }
  }
}
