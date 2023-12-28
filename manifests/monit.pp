#
# @summary sets up monit rules for postfix
#
class postfix::monit (
    $monitor_email
) inherits postfix::params {
    @monit::fragment { 'postfix-postfix.monit':
        basename   => 'postfix',
        modulename => 'postfix',
        tag        => 'default',
    }
}
