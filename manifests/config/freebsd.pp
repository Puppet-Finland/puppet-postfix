#
# == Class: postfix::config::freebsd
#
# FreeBSD-specific postfix configuration. Currently used to disable sendmail and 
# to make postfix the default MTA.
#
class postfix::config::freebsd {

    include postfix::params

    file { 'postfix-mailer.conf':
        name => '/etc/mail/mailer.conf',
        ensure => present,
        content => template('postfix/mailer.conf.erb'),
        owner => root,
        group => "${::postfix::params::admingroup}",
        mode => 644,
    }

    # Disable sendmail service
    service { 'postfix-sendmail':
        name => 'sendmail',
        enable => false,
    }
}