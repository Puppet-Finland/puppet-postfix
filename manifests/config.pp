#
# == Class: postfix::config
#
# Configures Postfix mail transfer agent
#
class postfix::config
(
    $serveradmin = 'none',
    $mailaliases,
    $relayhost,
    $domain_mail_server,
    $inet_interfaces,
    $smtp_host_lookup,
    $allow_ipv4_address,
    $allow_ipv6_address,
    $allow_ipv6_netmask

) inherits postfix::params
{

    file { 'postfix-main.cf':
        ensure  => present,
        name    => $::postfix::params::main_cf,
        content => template('postfix/main.cf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['::postfix::install'],
        notify  => Class['::postfix::service'],
    }

    # Set default values on postfix-mailalias resources and define 
    # newaliases-command
    Mailalias <| tag == 'postfix-mailalias' |> {
        target  => '/etc/aliases',
        require => Class['postfix::install'],
        notify  => Exec['postfix-newaliases'],
    }
    exec { 'postfix-newaliases':
        command     => 'newaliases',
        cwd         => '/tmp',
        path        => '/usr/bin',
        refreshonly => true,
    }

    # Create standard mailaliases
    postfix::mailalias { 'postmaster':             recipient => $::os::params::adminuser, }
    postfix::mailalias { 'webmaster':              recipient => $::os::params::adminuser, }
    postfix::mailalias { $::os::params::adminuser: recipient => $serveradmin, }

    # Create additional mailaliases
    create_resources('postfix::mailalias', $mailaliases)
}
