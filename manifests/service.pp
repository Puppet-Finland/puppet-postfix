#
# == Class: postfix::service
#
# Configures postfix to start on boot
class postfix::service {
    service { 'postfix':
        name => 'postfix',
        enable => true,
        require => Class['postfix::install'],
    }
}
