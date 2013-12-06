#
# == Class: postfix::params
#
# Defines some variables based on the operating system
class postfix::params {

    case $::osfamily {
        'RedHat': {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/libexec/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $service_command = "/sbin/service $service_name"
        }
        'Suse': {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $service_command = "/sbin/service $service_name"
        }
        'Debian': {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $service_command = "/usr/sbin/service $service_name"
        }
        'FreeBSD': {
            $package_name = 'mail/postfix'
            $main_cf = '/usr/local/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/local/libexec/postfix'
            $command_directory = '/usr/local/sbin'
            $service_name = 'postfix'
            $service_command = "/usr/local/etc/rc.d/$service_name"
        }
        default: {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $service_command = "/usr/sbin/service $service_name"
        }
    }
}
