#
# == Class: postfix::config::freebsd
#
# FreeBSD-specific postfix configuration. Currently used to disable sendmail and 
# to make postfix the default MTA.
#
class postfix::config::freebsd inherits postfix::params
{

    file { 'postfix-mailer.conf':
        ensure  => present,
        name    => '/etc/mail/mailer.conf',
        content => template('postfix/mailer.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
    }

    # Disable sendmail service
    service { 'postfix-sendmail':
        name   => 'sendmail',
        enable => false,
    }
}
