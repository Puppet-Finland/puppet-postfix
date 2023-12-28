#
# @summary sets up monit rules for postfix
#
# @param monitor_email
#   Email address to which monit sends emails
class postfix::monit (
  $monitor_email
) inherits postfix::params {
  @monit::fragment { 'postfix-postfix.monit':
    basename   => 'postfix',
    modulename => 'postfix',
    tag        => 'default',
  }
}
