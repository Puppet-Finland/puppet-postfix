#
# == Class: postfix::monit
#
# Setups monit rules for postfix
#
class postfix::monit {
    monit::fragment { 'postfix-postfix.monit':
        modulename => 'postfix',
    }
}
