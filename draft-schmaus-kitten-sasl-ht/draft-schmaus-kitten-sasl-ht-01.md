%%%
Title = "The Hashed Token SASL Mechanism"
category = "info"
docName = "draft-schmaus-kitten-sasl-ht-01"
ipr= "trust200902"
area = "Internet"
workgroup = "Common Authentication Technology Next Generation"

date = 2017-03-28T00:00:00Z

[[author]]
initials="F."
surname="Schmaus"
fullname="Florian Schmaus"
organization="University of Erlangen-Nuremberg"
 [author.address]
 email = "schmaus@cs.fau.de"
%%%

.# Abstract

This document specifies a SASL mechanism designed to be used with short-lived, exclusively ephemeral tokens.

{mainmatter}

#  Introduction

This section specifies the the family of Hashed Token (HT-*) SASL mechanisms.
It provides hash agility, mutual authentication and is secured by channel binding.

This mechanism was designed to be used with short-lived tokens for quick, one round-trip, re-authentication of a previous session.
Clients are supposed to request such tokens from the server after being authenticated using a "strong" SASL mechanism (e.g. SCRAM).
Hence a typical sequence of actions using SASL-HT may look like the following:

F> ~~~
F> A) Client authenticates using a strong mechanism (e.g., SCRAM)
F> B) Client requests secret SASL-HT token
F>    <normal client-server interaction here>
F> C) Connection between client and server gets interrupted
F>    (e.g., WiFi ↔ GSM switch)
F> D) Client resumes previous session using the token from B
F> E) Client requests secret SASL-HT token
F>    [goto C]
F> ~~~
Figure: Example sequence using SASL-HT

An example application protocol specific extension based on SASL-HT is [@XEP-ISR-SASL2].

Since the token is not salted, and only one hash iteration is used, the HT-* mechanism is not suitable to protect long-lived shared secrets (e.g. "passwords").
You may want to look at [@RFC5802] for that.
  
##  Conventions and Terminology

The key words "**MUST**", "**MUST NOT**", "**REQUIRED**", "**SHALL**", "**SHALL NOT**",
"**SHOULD**", "**SHOULD NOT**", "**RECOMMENDED**", "**MAY**", and "**OPTIONAL**" in this
document are to be interpreted as described in RFC 2119 [@!RFC2119].

Additionally, the key words "**MIGHT**", "**COULD**", "**MAY WISH TO**", "**WOULD
PROBABLY**", "**SHOULD CONSIDER**", and "**MUST (BUT WE KNOW YOU WON'T)**" in
this document are to interpreted as described in RFC 6919 [@!RFC6919].

## Applicability

Because this mechanism transports information that should not be controlled by an attacker, the HT-* mechanism **MUST** only be used over channels protected by TLS, or over similar integrity-protected and authenticated channels.
In addition, when TLS is used, the client MUST successfully validate the server's certificate ([@!RFC5280], [@!RFC6125]).

The family of HT-* mechanisms is not applicable for proxy authentication, since they can not carry a authorization identity string (authzid).

#  The HT-* Family of Mechanisms

Each mechanism in this family differs by the choice of the hash algorithm and the choice of the channel binding [@!RFC5929] type.

A HT mechanism name is a string "HT-" followed by the capitalized "Hash Name String", followed by "-", and suffixed by one of 'ENDP' and 'UNIQ'.

Hence each mechanism has a name of the following form:

F> ~~~
F> HT-<hash-alg>-<cb-type>
F> ~~~

Where \<hash-alg\> is the capitalized "Hash Name String" of the IANA "Named Information Hash Algorithm Registry" [@!iana-hash-alg] as specified in [@!RFC6920], and \<cb-type\> is one of 'ENDP' or 'UNIQ' denoting the channel binding type.
In case of 'ENDP', the tls-server-end-point channel binding type is used.
In case of 'UNIQ', the tls-unique channel binding type is used.
Valid channel binding types are defined in the IANA "Channel-Binding Types" registry [@!iana-cbt] as specified in [@!RFC5056].

CBT   | Channel Binding Type 
------|-----------------------
ENDP  | tls-server-end-point 
UNIQ  | tls-unique
Table: Mapping of CBT to Channel Bindings

The following table lists the HT-* SASL mechanisms registered this document.

Mechanism Name      | Hash Algorithm   | Channel-binding unique prefix
--------------------|------------------|------------------------------
HT-SHA-512-ENDP     | SHA-512          | tls-server-end-point
HT-SHA-512-UNIQ     | SHA-512          | tls-unique
HT-SHA3-512-ENDP    | SHA3-512         | tls-server-end-point
HT-SHA-256-UNIQ     | SHA-256          | tls-unique
Table: Defined HT-* SASL mechanisms

# The HT Mechanism

The mechanism consists of a simple exchange of exactly two messages between the initiator and responder.

The following syntax specifications use the Augmented Backus-Naur form (ABNF) notation as specified in [@!RFC5234].

## Initiator First Message

The HT-* SASL mechanism starts with the initiator-msg, send by the initiator to the responder.

initiator-msg = authcid-length authcid-data initiator-hashed-token

authcid-length = 4OCTET

authcid-data = 1*OCTET

initiator-hashed-token = 1*OCTET

The initiator message starts with an unsigned 32-bit integer in big endian. It denotes length of the authcid-data, which contains the authentication identity.
Before sending the authentication identity string the initiator **SHOULD** prepare the data with the UsernameCaseMapped profile of [@!RFC7613].

The initiator-hashed-token value is defined as: HMAC(token, "Initiator" || cb-data)

HMAC() is the function defined in [@!RFC2104] with H being the selected HT-* hash algorithm, 'cb-data' represents the data provided by the channel binding type, and 'token' are the UTF-8 encoded octets of the token string which acts as shared secret between initiator and responder.

The initiator-msg **MUST NOT** be included in TLS 1.3 0-RTT early data (see [@!I-D.ietf-tls-tls13#19]).

## Final Responder Message

This message is followed by a message from the responder to the initiator. This 'responder-msg' is defined as follows:

responder-msg = 1*OCTET

The responder-msg value is defined as: HMAC(token, "Responder" || cb-data)

The initiating entity **MUST** verify the responder-msg to achieve mutual authentication.

# Compliance with SASL Mechanism Requirements

This section describes compliance with SASL mechanism requirements specified in Section 5 of [@!RFC4422].

1.   "HT-SHA-256-ENDP", "HT-SHA-256-UNIQ", "HT-SHA-3-512-ENDP" and "HT-SHA-3-512-UNIQ".
2.   Definition of server-challenges and client-responses:
     a)  HT is a client-first mechanism.
     b)  HT does not send additional data with success.
3.   HT is capable of transferring authorization identities from the client to the server.
4.   HT does not offer any security layers (HT offers channel binding instead).
5.   HT does not protect the authorization identity.

#  Security Considerations

To be secure, HT-* **MUST** be used over a TLS channel that has had the session hash extension [@!RFC7627] negotiated, or session resumption **MUST NOT** have been used.

#  IANA Considerations

IANA has added the following family of SASL mechanisms to the SASL Mechanism registry established by [@!RFC4422]:

~~~
To: iana@iana.org
Subject: Registration of a new SASL family HT

SASL mechanism name (or prefix for the family): HT-*
Security considerations:
  Section FIXME of draft-schmaus-kitten-sasl-ht-00 
Published specification (optional, recommended):
  draft-schmaus-kitten-sasl-ht-00 (TODO)
Person & email address to contact for further information:
IETF SASL WG <kitten@ietf.org>
Intended usage: COMMON
Owner/Change controller: IESG <iesg@ietf.org>
Note: Members of this family MUST be explicitly registered
using the "IETF Review" [@!RFC5226] registration procedure.
Reviews MUST be requested on the Kitten WG mailing list
<kitten@ietf.org> (or a successor designated by the responsible
Security AD).
~~~

<reference anchor='iana-hash-alg' target='https://www.iana.org/assignments/named-information/named-information.xhtml#hash-alg'>
    <front>
        <title>IANA Named Information Hash Algorithm Registry</title>
        <author initials='N.' surname='Williams' fullname='Nicolas Williams'>
            <organization>IANA</organization>
        </author>
        <date year='2010'/>
    </front>
</reference>

<reference anchor='iana-cbt' target='https://www.iana.org/assignments/channel-binding-types/channel-binding-types.xhtml'>
    <front>
        <title>IANA Channel-Binding Types</title>
        <author initials='N.' surname='Williams' fullname='Nicolas Williams'>
            <organization>IANA</organization>
        </author>
        <date year='2010'/>
    </front>
</reference>

<reference anchor='XEP-ISR-SASL2' target='http://geekplace.eu/xeps/xep-isr-sasl2/xep-isr-sasl2.html'>
    <front>
        <title>XEP-XXXX: Instant Stream Resumption</title>
        <author initials='F.' surname='Schmaus' fullname='Florian Schmaus'>
        </author>
        <date year='2017'/>
    </front>
</reference>

{backmatter}

# Acknowledgments

Thanks to Thijs Alkemade.
