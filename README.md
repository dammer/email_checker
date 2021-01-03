!!! Email checker

Checks the possibility of sending an email to the specified address.
Sometimes it is necessary to check the address specified by the user to avoid unnecessary loads and block the sending of messages to invalid addresses.

Performance depends on the IP address of the system on which you run the email check. It is better to use the server that you use to send your email messages.

This version required dig for get address of MX server

* Sample with invalid email
```
crystal run email_checker.cr -- -e example@gmail.com
Checking address: <example@gmail.com>
MX is: gmail-smtp-in.l.google.com.
Start checking.
220 mx.google.com ESMTP o12si36431842ljc.263 - gsmtp
HELO example.com
250 mx.google.com at your service
MAIL FROM: <mailvalid@example.com>
250 2.1.0 OK o12si36431842ljc.263 - gsmtp
RCPT TO: <example@gmail.com>
550-5.1.1 The email account that you tried to reach does not exist. Please try
Email <example@gmail.com> is invalid.
Done.
```
* Sample with valid email
```
crystal run email_checker.cr -- -e press@google.com
Checking address: <press@google.com>
MX is: aspmx.l.google.com.
Start checking.
220 mx.google.com ESMTP m15si28862652lfc.164 - gsmtp
HELO example.com
250 mx.google.com at your service
MAIL FROM: <mailvalid@example.com>
250 2.1.0 OK m15si28862652lfc.164 - gsmtp
RCPT TO: <press@google.com>
250 2.1.5 OK m15si28862652lfc.164 - gsmtp
Email <press@google.com> is valid.
Done.
```

_ Todo:

* Write get mx from DNS directly
* Make multiple emails checking from file
