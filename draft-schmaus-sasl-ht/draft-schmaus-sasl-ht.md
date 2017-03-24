%%%
Title = "The Hashed Token SASL Mechanism"
category = "info"
docName = "draft-schmaus-sasl-ht"
ipr= "trust200902"
area = "Internet"
workgroup = "Common Authentication Technology Next Generation"

date = 2017-03-22T00:00:00Z

[[author]]
initials="F."
surname="Schmaus"
fullname="Florian Schmaus"
organization="University of Erlangen-Nuremberg"
 [author.address]
 email = "schmaus@cs.fau.de"
%%%

.# Abstract

This document specifies a new SASL mechanism designed to authenticate using short-lived, exclusively emphermeral tokens.

{mainmatter}

#  Introduction

This section specifies the Hashed Token (HT-*) SASL mechanism.
This mechanism was designed to be used with short-lived tokens (shared secrets) for authentication.
It provides hash agility, mutual authentication and is secured by channel binding.
Since the token is not salted, and only one iteration is used, the HT mechanism is not suitable to protect long-lived shared secrets (e.g. "passwords").
You may want to look at [@RFC5802] for that.
  
##  Conventions and Terminology

The key words "**MUST**", "**MUST NOT**", "**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**", "**RECOMMENDED**", "**MAY**", and "**OPTIONAL**" in this
document are to be interpreted as described in RFC 2119 [@!RFC2119].

Additionally, the key words "**MIGHT**", "**COULD**", "**MAY WISH TO**", "**WOULD
PROBABLY**", "**SHOULD CONSIDER**", and "**MUST (BUT WE KNOW YOU WON'T)**" in
this document are to interpreted as described in RFC 6919 [@!RFC6919].

#  The HT-* Family of Mechanisms

Each mechanism in this family differs by the choice of the hash algorithm and the choice of the channel binding type.
Each mechanism has a name of the form HT-\[HA\]-\[CBT\] where \[HA\] is the "Hash Name String" of the [@!iana-hash-alg] registry in capital letters, and \[CBT\] is one of 'ENDP' or 'UNIQ'.
In case of 'ENDP', the tls-server-end-point channel binding type is used.
In case of 'UNIQ', the tls-unique channel binding type is used.
For more information about channel binding, see [@!RFC5929] and the [@!iana-cbt] registry.

CBT   | Channel Binding Type 
------|-----------------------
ENDP  | tls-server-end-point 
UNIQ  | tls-unique
Table: Mapping of CBT to Channel Bindings

The following table lists a few examples of HT-* SASL mechanism names.

Mechanism Name      | Hash Algorithm         | Channel-binding unique prefix
--------------------|------------------------|------------------------------
HT-SHA-512-ENDP   | SHA-512 (FIPS 180-4)   | tls-server-end-point
HT-SHA3-256-ENDP  | SHA3-512 (FIPS 202)    | tls-server-end-point
HT-SHA-512-UNIQ   | SHA-512 (FIPS 180-4)   | tls-unique
HT-SHA-256-UNIQ   | SHA-256 [@!RFC6920]    | tls-unique
Table: Example HT-* SASL mechanisms

# The HT Mechanism

The mechanism consists of a simple exchange of exactly two messages between the initiator and responder.
It starts with the message from the initiator to the responder.
This 'initiator-message' is defined as follows:

initiator-message = HMAC(token, "Initiator" || cb-data)

HMAC() is the function defined in [@!RFC2104] with H being the chosen hash algorithm, 'cb-data' represents the data provided by the channel binding type, and 'token' are the UTF-8 encoded bytes of the token String which acts as shared secret between initiator and responder.
The initiator-message MUST NOT be included in TLS 1.3 0-RTT early data ([@!I-D.ietf-tls-tls13#18]).

This message is followed by a message from the responder to the initiator. This 'responder-message' is defined as follows:

responder-message = HMAC(token, "Responder" || cb-data)

The initiating entity MUST verify the responder-message to achieve mutual authentication.

#  Security Considerations

To be secure, HT-* MUST be used over a TLS channel that has had the session hash extension [@!RFC7627] negotiated, or session resumption MUST NOT have been used.

#  IANA Considerations

TODO

<reference anchor='iana-hash-alg' target='https://www.iana.org/assignments/named-information/named-information.xhtml#hash-alg'>
    <front>
        <title>IANA Named Information Hash Algorithm Registry</title>
        <author initials='J.' surname='MacFarlane' fullname='John MacFarlane'>
            <organization>University of California, Berkeley</organization>
            <address>
                <email>jgm@berkeley.edu</email>
                <uri>http://johnmacfarlane.net/</uri>
            </address>
        </author>
        <date year='2006'/>
    </front>
</reference>

<reference anchor='iana-cbt' target='https://www.iana.org/assignments/channel-binding-types/channel-binding-types.xhtml'>
    <front>
        <title>IANA Channel-Binding Types</title>
        <author initials='J.' surname='MacFarlane' fullname='John MacFarlane'>
            <organization>University of California, Berkeley</organization>
            <address>
                <email>jgm@berkeley.edu</email>
                <uri>http://johnmacfarlane.net/</uri>
            </address>
        </author>
        <date year='2006'/>
    </front>
</reference>

{backmatter}

# Acknowledgements

Thanks to Thijs Alkemade.
