#
# @summary defines some variables based on the operating system
#
class postfix::params {
    include os::params

    case $osfamily {
        'RedHat': {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $sasl_passwd = '/etc/postfix/sasl_passwd'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $smtp_generic_maps_file = '/etc/postfix/generic'
            $smtp_generic_maps = "hash:${smtp_generic_maps_file}"
            $daemon_directory = '/usr/libexec/postfix'
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
        }
        'Debian': {
            $package_name = 'postfix'
            $main_cf = '/etc/postfix/main.cf'
            $sasl_passwd = '/etc/postfix/sasl_passwd'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $smtp_generic_maps_file = '/etc/postfix/generic'
            $smtp_generic_maps = "hash:${smtp_generic_maps_file}"
            $command_directory = '/usr/sbin'
            $service_name = 'postfix'
            $daemon_directory = '/usr/lib/postfix/sbin'
        }
        'FreeBSD': {
            $package_name = 'mail/postfix'
            $main_cf = '/usr/local/etc/postfix/main.cf'
            $sasl_passwd = '/usr/local/etc/postfix/sasl_passwd'
            $alias_maps = 'hash:/etc/aliases'
            $alias_database = 'hash:/etc/aliases'
            $smtp_generic_maps_file = '/usr/local/etc/postfix/generic'
            $smtp_generic_maps = "hash:${smtp_generic_maps_file}"
            $daemon_directory = '/usr/local/libexec/postfix'
            $command_directory = '/usr/local/sbin'
            $service_name = 'postfix'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }

    if $systemd {
        $service_start = "${os::params::systemctl} start ${service_name}"
        $service_stop = "${os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${os::params::service_cmd} ${service_name} start"
        $service_stop = "${os::params::service_cmd} ${service_name} stop"
    }
}
