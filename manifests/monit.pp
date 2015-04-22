#
# == Class: postfix::monit
#
# Setups monit rules for postfix
#
class postfix::monit
(
    $monitor_email

) inherits postfix::params
{
    monit::fragment { 'postfix-postfix.monit':
        modulename => 'postfix',
    }
}
