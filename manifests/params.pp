#
# == Class: postfix::params
#
# Defines some variables based on the operating system
class postfix::params {

    case $::osfamily {
        'RedHat': {
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/libexec/postfix'
            $command_directory = '/usr/sbin'
        }
        'Suse': {
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
        }
        'Debian': {
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
        }
        default: {
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
        }
    }
}
