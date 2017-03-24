%%%
Title = "The Hashed Token SASL Mechanism"
category = "info"
docName = "draft-schmaus-sasl-ht-00"
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

This section specifies the the family of Hashed Token (HT-*) SASL mechanisms.
This mechanism was designed to be used with short-lived tokens, used as shared secrets, for authentication.
It provides hash agility, mutual authentication and is secured by channel binding.
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
Each mechanism has a name of the form HT-(HA)-(CBT) where (HA) is the capitalized "Hash Name String" of the IANA "Named Information Hash Algorithm Registry" [@!iana-hash-alg] as specified in [@RFC6920], and (CBT) is one of 'ENDP' or 'UNIQ' denoting the channel binding type.
In case of 'ENDP', the tls-server-end-point channel binding type is used.
In case of 'UNIQ', the tls-unique channel binding type is used.
Valid channel binding types are defined in the IANA "Channel-Binding Types" registry [@!iana-cbt] as specified in [@RFC5056].

CBT   | Channel Binding Type 
------|-----------------------
ENDP  | tls-server-end-point 
UNIQ  | tls-unique
Table: Mapping of CBT to Channel Bindings

The following table lists a few examples of HT-* SASL mechanism names.

Mechanism Name      | Hash Algorithm   | Channel-binding unique prefix
--------------------|------------------|------------------------------
HT-SHA-512-ENDP     | SHA-512          | tls-server-end-point
HT-SHA-512-UNIQ     | SHA-512          | tls-unique
HT-SHA3-512-ENDP    | SHA3-512         | tls-server-end-point
HT-SHA-256-UNIQ     | SHA-256          | tls-unique
Table: Defined HT-* SASL mechanisms

# The HT Mechanism

The mechanism consists of a simple exchange of exactly two messages between the initiator and responder.

## Initiator First Message

It starts with the message from the initiator to the responder.
This 'initiator-message' is defined as follows:

initiator-message = authcid-length authcid-data initiator-hashed-token

authcid-length = 4OCTET
authcid-data = 1*OCTET
initiator-hashed-token = 1*OCTET

The initiator message starts with an unsigned 32-bit integer in big endian. It denotes length of the authcid-data, which contains the authentication identity.
Before sending the authentication identity string the initiator **SHOULD** prepare the data with the UsernameCaseMapped profile [@!RFC7613].

The initiator-hashed-token value is defined as: HMAC(token, "Initiator" || cb-data)

HMAC() is the function defined in [@!RFC2104] with H being the chosen hash algorithm, 'cb-data' represents the data provided by the channel binding type, and 'token' are the UTF-8 encoded octets of the token string which acts as shared secret between initiator and responder.
The initiator-message **MUST NOT** be included in TLS 1.3 0-RTT early data ([@!I-D.ietf-tls-tls13#19]).

## Final Responder Message

This message is followed by a message from the responder to the initiator. This 'responder-message' is defined as follows:

responder-message = 1*OCTET

The responder-messages value is defined as: HMAC(token, "Responder" || cb-data)

The initiating entity **MUST** verify the responder-message to achieve mutual authentication.

# Compliance with SASL Mechanism Requirements

This section describes compliance with SASL mechanism requirements specified in Section 5 of [@!RFC4422].

1.   "HT-SHA-256-ENDP", "HT-SHA-256-UNIQ", "HT-SHA-3-512-ENDP" and "HT-SHA-3-512-UNIQ".
2.   Definition of server-challenges and client-responses:
     a)  HT is a client-first mechanism.
     b)  HT does not send additional data with success.
3.   HT is capable of transferring authorization identities from the client to the server. (TODO)
4.   HT does not offer any security layers (HT offers channel binding instead).
5.   HT does not protect the authorization identity.

#  Security Considerations

To be secure, HT-* **MUST** be used over a TLS channel that has had the session hash extension [@!RFC7627] negotiated, or session resumption **MUST NOT** have been used.

#  IANA Considerations

IANA has added the following family of SASL mechanisms to the SASL Mechanism registry established by [@!RFC4422]:

   To: iana@iana.org
   Subject: Registration of a new SASL family HT

   SASL mechanism name (or prefix for the family): HT-*
   Security considerations: Section FIXME of draft-schmaus-sasl-ht-00 (TODO)
   Published specification (optional, recommended): draft-schmaus-sasl-ht-00 (TODO)
   Person & email address to contact for further information:
   IETF SASL WG <kitten@ietf.org>
   Intended usage: COMMON
   Owner/Change controller: IESG <iesg@ietf.org>
   Note: Members of this family MUST be explicitly registered
   using the "IETF Review" [@!RFC5226] registration procedure.
   Reviews MUST be requested on the Kitten WG mailing list
   <kitten@ietf.org> (or a successor designated by the responsible
   Security AD).

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

{backmatter}

# Acknowledgements

Thanks to Thijs Alkemade.
