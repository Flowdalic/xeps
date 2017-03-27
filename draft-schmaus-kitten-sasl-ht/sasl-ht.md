Version2 HT-* tries to mitigate effects of token theft on the server.

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
server knows: message, magic
client knows: key,     magic

SASL Exchange
-------------

client → server: key, HMAC(magic, cb-data)

Server calculates client-magic = HMAC(key, message), and if
client-magic == magic, and if HMAC(magic, cb-data)
matches his view of the TLS connection, then auth success and channel
binding established.

server → client: message, HMAC(server-verifier, cb-data)

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
