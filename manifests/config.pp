#
# == Class: postfix::config
#
# Configures Postfix mail transfer agent
#
class postfix::config(
    $serveradmin = 'none',
    $domain_mail_server,
    $inet_interfaces,
    $allow_ipv4_address,
    $allow_ipv6_address,
    $allow_ipv6_netmask
)
{

    include postfix::params

    file { 'postfix-main.cf':
        name => "${::postfix::params::main_cf}",
        content => template('postfix/main.cf.erb'),
        ensure => present,
        owner => root,
        group => "${::postfix::params::admingroup}",
        mode  => 644,
        require => Class['postfix::install'],
        notify => Class['postfix::service'],
    }

    # Set default values on all mailalias-resources and
    # define newaliases-command
    Mailalias <| |> {
        target  => '/etc/aliases',
        require => Class['postfix::install'],
        notify  => Exec['postfix-newaliases'],
    }
    exec { 'postfix-newaliases':
        command => 'newaliases',
        cwd => '/tmp',
        path => '/usr/bin',
        refreshonly => true,
    }

    # set some default aliases
    mailalias {'postmaster':
        recipient => 'root',
    }
    mailalias {'webmaster':
        recipient => 'root',
    }
    # Set root email addess, if given
    if ($serveradmin != 'none') {
        mailalias {"root to ${serveradmin}":
            name      => 'root',
            recipient => $serveradmin,
            ensure    => present,
        }
    }
}
