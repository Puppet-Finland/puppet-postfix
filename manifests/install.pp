#
# == Class: postfix::install
#
# Installs postfix package
#
class postfix::install {
    package { 'postfix':
        name => 'postfix',
        ensure => installed,
    }
}
