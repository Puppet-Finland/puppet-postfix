#
# @summary configure postfix to start on boot
#
# @param ensure
#
class postfix::service (
  Optional[Enum['running']] $ensure
) inherits postfix::params {
    service { 'postfix':
        ensure  => $ensure,
        enable  => true,
        name    => 'postfix',
        require => Class['postfix::install'],
    }
}
