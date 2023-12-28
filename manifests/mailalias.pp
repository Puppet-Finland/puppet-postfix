#
# @summary add a mailalias to postfix
#
# @param recipient
#   List of emails to use as recipient
define postfix::mailalias (
  Variant[String,Array[String]] $recipient
) {
  include postfix::params

  mailalias { $title:
    recipient => $recipient,
    tag       => 'postfix-mailalias',
  }
}
