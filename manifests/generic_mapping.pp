#
# @summary add a generic mapping to postfix:
#
# @see http://www.postfix.org/ADDRESS_REWRITING_README.html#generic
# @see http://www.postfix.org/generic.5.html
#
# @param pattern
#   Original email address pattern to match (e.g. "root")
# @param result
#   Replace original email addresses matching patter with this (e.g. "status@example.com")
# @param ensure
#   Status of this generic mapping
#
define postfix::generic_mapping (
    String                   $pattern = $title,
    String                   $result = $postfix::config::smtp_username,
    Enum['present','absent'] $ensure = 'present'
) {
    include postfix::params

    file_line { "postfix-${title}":
        ensure  => $ensure,
        path    => $postfix::params::smtp_generic_maps_file,
        line    => "${pattern} ${result}",
        notify  => Exec['postfix-postmap-generic'],
        require => File['postfix-generic'],
    }
}
