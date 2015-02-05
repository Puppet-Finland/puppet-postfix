#
# == Class: postfix::install
#
# Installs postfix package
#
class postfix::install inherits postfix::params {

    package { 'postfix':
        name => 'postfix',
        ensure => installed,
    }
}
