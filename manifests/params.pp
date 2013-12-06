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
 
            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
            } else {
                $service_start = "/sbin/service $service_name start"
                $service_stop = "/sbin/service $service_name stop"
            }
        }
        'Debian': {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
        'FreeBSD': {
            $package_name = 'mail/postfix'
            $main_cf = '/usr/local/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/local/libexec/postfix'
            $command_directory = '/usr/local/sbin'
            $service_name = 'postfix'
            $service_start = "/usr/local/etc/rc.d/$service_name start"
            $service_stop = "/usr/local/etc/rc.d/$service_name stop"
        }
        default: {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $daemon_directory = '/usr/lib/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
    }
}
