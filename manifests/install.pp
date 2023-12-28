#
# == Class: postfix::install
#
# Installs postfix package
#
class postfix::install inherits postfix::params {
    package { 'postfix':
        ensure => installed,
        name   => 'postfix',
    }
}
