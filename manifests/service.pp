#
# == Class: postfix::service
#
# Configures postfix to start on boot
#
class postfix::service inherits postfix::params {

    service { 'postfix':
        name    => 'postfix',
        enable  => true,
        require => Class['::postfix::install'],
    }
}
