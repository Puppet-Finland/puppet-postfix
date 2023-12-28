#
# @summary FreeBSD-specific postfix configuration.
#
class postfix::config::freebsd inherits postfix::params {
  file { 'postfix-mailer.conf':
    ensure  => file,
    name    => '/etc/mail/mailer.conf',
    content => template('postfix/mailer.conf.erb'),
    owner   => $os::params::adminuser,
    group   => $os::params::admingroup,
    mode    => '0644',
  }

  # Disable sendmail service
  service { 'postfix-sendmail':
    name   => 'sendmail',
    enable => false,
  }
}
