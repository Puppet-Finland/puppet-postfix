#
# == Define: postfix::generic_mapping
#
# Add a generic mapping to postfix:
#
# <http://www.postfix.org/ADDRESS_REWRITING_README.html#generic>
# <http://www.postfix.org/generic.5.html>
#
# This allows rewriting the message envelopes and headers for outgoing mail. 
#
# This is useful for example when the an relayhost is very strict regarding 
# valid sender addresses.
#
# == Parameters
#
# [*ensure*]
#   The status of this generic mapping. Valid values are 'present' (default) and 
#   'absent'.
# [*pattern*]
#   The pattern to match. For example 'root' or '@mydomain.com' or 
#  'user@mydomain.com'. Defaults to resource $title.
# [*result*]
#   Resulting FROM address for outgoing mail matching the pattern. Defaults to
#   $::postfix::config::smtp_username.
#
define postfix::generic_mapping
(
    String                   $pattern = $title,
    String                   $result = $::postfix::config::smtp_username,
    Enum['present','absent'] $ensure = 'present'
)
{
    include ::postfix::params

    file_line { "postfix-${title}":
        ensure  => $ensure,
        path    => $::postfix::params::smtp_generic_maps_file,
        line    => "${pattern} ${result}",
        notify  => Exec['postfix-postmap-generic'],
        require => File['postfix-generic'],
    }
}
