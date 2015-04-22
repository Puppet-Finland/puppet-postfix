#
# == Class: postfix::config
#
# Configures Postfix mail transfer agent
#
class postfix::config
(
    $serveradmin = 'none',
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

    # Set default values on all mailalias-resources and
    # define newaliases-command
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

    # set some default aliases
    mailalias {'postmaster':
        recipient => 'root',
        tag       => 'postfix-mailalias',
    }
    mailalias {'webmaster':
        recipient => 'root',
        tag       => 'postfix-mailalias',
    }
    # Set root email addess, if given
    if ($serveradmin != 'none') {
        mailalias {"root to ${serveradmin}":
            ensure    => present,
            name      => 'root',
            recipient => $serveradmin,
            tag       => 'postfix-mailalias',
        }
    }
}
