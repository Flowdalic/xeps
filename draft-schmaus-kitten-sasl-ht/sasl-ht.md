Introducing SASL-HT
===================

This SASL mechanism is designed to be used as quick, yet secure,
mechanism to resume a session. For example an XMPP session may be
initially authenticated using a strong mechanism like SCRAM, but at
resumption-time we want a single round trip mechanism. The basic idea
is the client requests a short-lived, exclusively ephemeral token
after being authenticated, which can be used to authenticate the
resumption in an efficient manner.

A typical sequence of actions using SASL-HT:

A) Client initial authenticates using a strong mechanism (e.g., SCRAM)
B) Client requests secret token
   <normal client-server interaction here>
C) Connection between client and server gets interrupted (e.g., WiFi ↔
   GSM switch)
D) Client resumes previous session using the secret token from B
E) Client requests secret token
   <normal client-server interaction here>
   [goto C]
   
The XMPP community is working on a complement XMPP Extension Protocol
(XEP) which can be found at

http://geekplace.eu/xeps/xep-isr-sasl2/xep-isr-sasl2.html

Since SASL-HT is meant to be protocol agnostic, other communities
(SMTP, IMAP, SIP, …) could build such a mechanism based on SASL-HT too
(if applicable).

The current version of SASL-HT in the draft is Version1. Version2 HT-*
tries to mitigate effects of token theft on the server.

Version1 HT-*
============

Prelude
-------

Server creates random token and sends it to client upon request.

SASL Exchange
-------------

client → server: HMAC(token, "Initiator" || cb-data)

Server checks if it matches his view, if so, then auth success and
channel binding established.

server → client: HMAC(token, "Responder" || cb-data)

Client check if it matches his view, if so, then mutual auth success.

Version2 HT-*
========

Prelude
-------

Server creates random key (token), random message and
server-verifier. Then calculates "magic = HMAC(key, messages)".

Upon client request server sends key, magic and server-verifier to the
client, and deletes key.

Now
server knows: message, magic, server-verifier
client knows: key,     magic, server-verifier

SASL Exchange
-------------

client → server: key XOR H(magic), HMAC(magic, cb-data)

Server calculates client-magic = HMAC(key, message), and if
client-magic == magic, and if HMAC(magic, cb-data)
matches his view of the TLS connection, then auth success and channel
binding established.

server → client: message XOR H(server-verifier), HMAC(server-verifier, cb-data)

Client checks if message is HMAC(key, magic) and if
HMAC(server-verifier, cb-data) matches clients view of the TLS
connection, then mutual auth success.

Discussion
==========

"Version2 HT-*" mitigates the effect of a server-side key theft (the
server doesn't know the key). The magic is hashed, just like the key
was in Version1, thus it appears that Version2 provides the same
robustness as Version1.

Note that Version2 would require XEP-ISR-SASL2 to hand out a key
string, the magic string and the server-verifier, i.e. it would
require a change to the current state of XEP-ISR-SASL2.

TODO List
=========

- Specify token push mechanism in XEP-ISR-SASL2 so that server can
  periodically push new tokens to clients.
