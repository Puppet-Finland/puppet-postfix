#
# == Class: postfix::config
#
# Configures Postfix mail transfer agent
#
class postfix::config
(
    $serveradmin = 'none',
    $mailaliases,
    $generic_mappings,
    $relayhost,
    $smtp_username,
    $smtp_password,
    $domain_mail_server,
    $inet_interfaces,
    $smtp_host_lookup,
    $allow_ipv4_address,
    $allow_ipv6_address,
    $allow_ipv6_netmask

) inherits postfix::params
{

    # Configure SMTP authentication, if requested.
    if $smtp_username {
        validate_string($smtp_username)
        validate_string($smtp_password)

        file { 'postfix-sasl_passwd':
            ensure => file,
            name   => $::postfix::params::sasl_passwd,
            owner  => $::os::params::adminuser,
            group  => $::os::params::admingroup,
            mode   => '0600',
        }

        file_line { "postfix-${relayhost}-${smtp_username}":
            ensure  => present,
            path    => $::postfix::params::sasl_passwd,
            line    => "${relayhost} ${smtp_username}:${smtp_password}",
            require => File['postfix-sasl_passwd'],
            notify  => Exec['postfix-update-sasl_passwd'],
        }

        exec { 'postfix-update-sasl_passwd':
            command     => "postmap ${::postfix::params::sasl_passwd}",
            path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin' ],
            refreshonly => true,
            user        => $::os::params::adminuser,
            require     => File_line["postfix-${relayhost}-${smtp_username}"],
        }
    }

    if ! empty($generic_mappings) {

        $smtp_generic_maps_line = "smtp_generic_maps = ${::postfix::params::smtp_generic_maps}"

        file { 'postfix-generic':
            ensure => file,
            name   => $::postfix::params::smtp_generic_maps_file,
            owner  => $::os::params::adminuser,
            group  => $::os::params::admingroup,
            mode   => '0644',
        }

        exec { 'postfix-postmap-generic':
            command     => "postmap ${::postfix::params::smtp_generic_maps}",
            cwd         => '/tmp',
            path        => ['/usr/sbin', '/usr/local/sbin'],
            refreshonly => true,
        }

        create_resources('postfix::generic_mapping', $generic_mappings)
    }
    $options = hiera('postfix::options')
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
