#
# == Define: postfix::mailalias
#
# Add a mail alias to postfix.
#
# This define is required because the resource collector only collects 
# mailaliases with the "postfix-mailalias" tag, and requiring each entry in the 
# $mailaliases hash to contain
#
#   tag => 'postfix-mailalias'
#
# would be just silly.
#
define postfix::mailalias
(
    $recipient
)
{
    include ::postfix::params

    mailalias { $title:
        recipient => $recipient,
        tag       => 'postfix-mailalias',
    }
}
