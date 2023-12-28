#
# @summary install postfix package
#
class postfix::install inherits postfix::params {
    package { 'postfix':
        ensure => installed,
        name   => 'postfix',
    }
}
