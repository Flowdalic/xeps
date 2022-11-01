---
title: "The Hashed Token SASL Mechanism"
docName: "draft-schmaus-kitten-sasl-ht-09-SNAPSHOT"
date: 2022-10-10

ipr: "trust200902"
submissiontype: independent
area: "Internet"
wg: "Common Authentication Technology Next Generation"
cat: "exp"
venue:
  github: flowdalic/xeps/tree/master/draft-schmaus-kitten-sasl-ht

author:
 -
   name: Florian Schmaus
   organization: FAU Erlangen-Nürnberg
   email: flow@cs.fau.de
 -
   name: Christoph Egger
   organization: FAU Erlangen-Nürnberg
   email: egger@cs.fau.de

normative:
  RFC2104:
  RFC3629:
  RFC4086:
  RFC4422:
  RFC5056:
  RFC5234:
  RFC5246:
  RFC5280:
  RFC5929:
  RFC6125:
  RFC6920:
  RFC7627:
  RFC8446:
  RFC9266:
  iana-hash-alg:
    title: "IANA Named Information Hash Algorithm Registry"
    author:
      name: "Nicolas Williams"
      org: IANA
    date: 2010
    target: https://www.iana.org/assignments/named-information/named-information.xhtml#hash-alg
  iana-cbt:
    title: "IANA Channel-Binding Types"
    author:
      name: "Nicolas Williams"
      org: IANA
    date: 2010
    target: https://www.iana.org/assignments/channel-binding-types/channel-binding-types.xhtml

informative:
  RFC5226:
  RFC5802:
  RFC6120:
  XEP-0397:
    title: "XEP-0397: Instant Stream Resumption"
    author:
      name: "Florian Schmaus"
    date: 2018-11-03
    target: https://xmpp.org/extensions/xep-0397.html

--- abstract

This document specifies the family of Hashed Token SASL mechanisms which enable a proof-of-possession-based authentication scheme and are meant to be used for quick re-authentication of a previous session.
The Hashed Token SASL mechanism's authentication sequence consists of only one round-trip.
The usage of short-lived, exclusively ephemeral hashed tokens is achieving the single round-trip property.
The SASL mechanism specified herin further provides hash agility, mutual authentication and support for channel binding.

--- middle

# Introduction

This specification describes the family of Hashed Token (HT) Simple Authentication and Security Layer (SASL) {{RFC4422}} mechanisms, which enable a proof-of-possession-based authentication scheme.
The HT mechanism is designed to be used with short-lived, exclusively ephemeral tokens, called SASL-HT tokens, and allow for quick, one round-trip, re-authentication of a previous session.

Further properties of the HT mechanism are 1) hash agility, 2) mutual authentication, and 3) support for channel binding.

Clients are supposed to request SASL-HT tokens from the server after being authenticated using a "strong" SASL mechanism like SCRAM {{RFC5802}}.
Hence a typical sequence of actions using HT may look like the following:

~~~
A) Client authenticates using a strong mechanism (e.g., SCRAM)
B) Client requests secret SASL-HT token
C) Service returns SASL-HT token
   <normal client-server interaction here>
D) Connection between client and server gets interrupted,
   for example because of a WiFi ↔ GSM switch
E) Client resumes the previous session using HT and token from C)
F) Service revokes the successfully used SASL-HT token
   [goto B]
~~~
{: figure name="Example sequence using the Hashed Token (HT) SASL mechanism" }

The HT mechanism requires an accompanying, application protocol specific, extension, which allows clients to requests a new SASL-HT token (see [Section 5](#requirements-for-the-applicationprotocol-extension)).
One example for such an application protocol specific extension based on HT is {{XEP-0397}}.
This XMPP {{RFC6120}} extension protocol allows, amongst other things, B) and C),

Since the SASL-HT token is not salted, and only one hash iteration is used, the HT mechanism is not suitable to protect long-lived shared secrets (e.g. "passwords").
You may want to look at {{RFC5802}} for that.

## Conventions and Terminology

{::boilerplate bcp14+}

## Applicability

Because this mechanism transports information that should not be controlled by an attacker, the HT mechanism **MUST** only be used over channels protected by Transport Layer Security (TLS, see {{RFC5246}}), or over similar integrity-protected and authenticated channels.
Also, the application protcol specific extension which requests a new SASL-HT token **SHOULD** only be used over similarly protected channels.

Also, when TLS is used, the client **MUST** successfully validate the server's certificate ({{RFC5280}}, {{RFC6125}}).

The family of HT mechanisms is not applicable for proxy authentication since they can not carry an authorization identity string (authzid).

# The HT Family of Mechanisms

Each mechanism in this family differs by choice of the hash algorithm and the choice of the channel binding {{RFC5929}} type.

An HT mechanism name is a string beginning with "HT-" followed by the capitalised name of the used hash, followed by "-", and suffixed by one of 'ENDP', 'UNIQ', 'EXPR' or 'NONE'.

Hence each HT mechanism has a name of the following form:

~~~
HT-<hash-alg>-<cb-type>
~~~

Where \<hash-alg\> is the capitalised "Hash Name String" of the IANA "Named Information Hash Algorithm Registry" {{iana-hash-alg}} as specified in {{RFC6920}}, and \<cb-type\> is one of 'ENDP', 'UNIQ', 'EXPR' or 'NONE' denoting the channel binding type.
In the case of 'ENDP', the tls-server-end-point channel binding type is used.
In the case of 'UNIQ', the tls-unique channel binding type is used.
In the case of 'EXPR', the tls-exporter {{RFC9266}} channel binding type is used.
Valid channel binding types are defined in the IANA "Channel-Binding Types" registry {{iana-cbt}} as specified in {{RFC5056}}.

In the special case of 'NONE', no channel binding is to be used (cb-data is to be an empty string).

cb-type | Channel Binding Type
--------|-----------------------
ENDP    | tls-server-end-point
UNIQ    | tls-unique
EXPR    | tls-exporter
{: title="Mapping of cb-type to Channel Binding Types" }

The following table lists some examples of HT SASL mechanisms registered by this document.

Mechanism Name      | HT Hash Algorithm   | Channel-binding unique prefix
--------------------|---------------------|------------------------------
HT-SHA-512-ENDP     | SHA-512             | tls-server-end-point
HT-SHA-512-UNIQ     | SHA-512             | tls-unique
HT-SHA3-512-ENDP    | SHA3-512            | tls-server-end-point
HT-SHA-256-UNIQ     | SHA-256             | tls-unique
HT-SHA-256-NONE     | SHA-256             | N/A
{: title="Examples of HT SASL mechanisms" }

# The HT Authentication Exchange

The mechanism consists of a simple exchange of precisely two messages between the initiator and responder.

The following syntax specifications use the Augmented Backus-Naur form (ABNF) notation as specified in {{RFC5234}}.

## Initiator First Message

The HT mechanism starts with the initiator-msg, send by the initiator to the responder.
The following lists the ABNF grammar for the initiator-msg:

~~~
initiator-msg = authcid NUL initiator-hashed-token
authcid = 1*SAFE ; MUST accept up to 255 octets
initiator-hashed-token = 1*OCTET

NUL    = %0x00 ; The null octet
SAFE   = UTF1 / UTF2 / UTF3 / UTF4
         ;; any UTF-8 encoded Unicode character except NUL

UTF1   = %x01-7F ;; except NUL
UTF2   = %xC2-DF UTF0
UTF3   = %xE0 %xA0-BF UTF0 / %xE1-EC 2(UTF0) /
         %xED %x80-9F UTF0 / %xEE-EF 2(UTF0)
UTF4   = %xF0 %x90-BF 2(UTF0) / %xF1-F3 3(UTF0) /
         %xF4 %x80-8F 2(UTF0)
UTF0   = %x80-BF
~~~

The initiator first message starts with the authentication identity (authcid, see{{RFC4422}}) as UTF-8 {{RFC3629}} encoded string.
It is followed by initiator-hashed-token separated by as single null octet.

The value of the initiator-hashed-token is defined as follows:

~~~
initiator-hashed-token := HMAC(token, "Initiator" || cb-data)
~~~

HMAC() is the function defined in {{RFC2104}} with H being the selected HT hash algorithm, 'cb-data' represents the data provided by the selected channel binding type, and 'token' are the UTF-8 encoded octets of the SASL-HT token string which acts as a shared secret between initiator and responder.

The initiator-msg **MAY** be included in TLS 1.3 0-RTT early data, as specified in {{RFC8446}}.
If this is the case, then the initiating entity **MUST NOT** include any further application protocol payload in the early data besides the HT initiator-msg and potential required framing of the SASL profile.
The responder **MUST** abort the SASL authentication if the early data contains additional application protocol payload.

> SASL-HT hence allows exploiting TLS 1.3 early data for "0.5 Round Trip Time (RTT)" resumption of the application protocol's session.
> Using TLS early data requires extra care when implementing: The early data should only contain the SASL-HT payload, i.e., the initiator-msg, and not an application protocol specific payload.
> The reason for this is that the early data could be replayed, and thus needs to carry an idempotent operation.
> On the other hand, if the responding entity can verify the early data, then it can send additional application protocol payload together with the "resumption successful" response to the initiating entity.

## Initiator Authentication

Upon receiving the initiator-msg, the responder calculates itself the value of initiator-hashed-token and compares it with the received value found in the initiator-msg.
If both values are equal, then the initiator has been successfully authenticated.
Otherwise, if both values are not equal, then authentication **MUST** fail.

## Final Responder Message

After the initiator was authenticated the responder continues the SASL authentication by sending the responder-msg to the initiator.

The ABNF for responder-msg is:

~~~
responder-msg = 1*OCTET
~~~

The responder-msg value is defined as follows:

~~~
responder-msg := HMAC(token, "Responder" || cb-data)
~~~

The initiating entity **MUST** verify the responder-msg to achieve mutual authentication.

# Compliance with SASL Mechanism Requirements

This section describes compliance with SASL mechanism requirements specified in Section 5 of {{RFC4422}}.

1.   "HT-SHA-256-ENDP", "HT-SHA-256-UNIQ", "HT-SHA-3-512-ENDP" and "HT-SHA-3-512-UNIQ".
2.   Definition of server-challenges and client-responses:
     a)  HT is a client-first mechanism.
     b)  HT does send additional data with success (the responder-msg).
3.   HT is not capable of transferring authorization identities from the client to the server.
4.   HT does not offer any security layers (HT offers channel binding instead).
5.   HT does not protect the authorization identity.

# Requirements for the Application-Protocol Extension {#requirements-for-the-applicationprotocol-extension}

It is **REQUIRED** that the application-protocol specific extension provides a mechanism to request a SASL-HT token in form of a Unicode string.
The returned token **MUST** have been newly generated by a cryptographically secure random number generator and MUST contain at least 128 bit of entropy.

It is **RECOMMENDED** that the protocol allows the requestor to signal the name of the SASL mechanism which he intends to use with the token.
If a token is used with a different mechanism than the one which was signalled upon requesting the token, then the authentication **MUST** fail.
This allows pinning the token to a SASL mechanism, which increases the security because it makes it impossible for an attacker to downgrade the SASL mechanism.

It is **RECOMMENDED** that the protocol defines a way for a client to request rotation or revocation of a token.

# Security Considerations {#security-considerations}

To be secure, the HT mechanism **MUST** be used over a TLS channel that has had the session hash extension {{RFC7627}} negotiated, or session resumption **MUST NOT** have been used.

It is **RECOMMENDED** that implementations periodically require a full authentication using a strong SASL mechanism which does not use the SASL-HT token.

It is of vital importance that the SASL-HT token is generated by a cryptographically secure random generator. See {{RFC4086}} for more information about Randomness Requirements for Security. In addition, comparison of the client's HMAC with the server's calculated HMAC **SHOULD** be performed using constant-time comparison functions, to protect against timing attacks.

The tokens used with HT mechanisms **SHOULD** have a limited lifetime, e.g. based on usage count or time elapsed since issuance.

Due to the additional security properties afforded by channel binding, it is **RECOMMENDED** that clients use HT mechanisms supporting channel binding in environments that can support it.

# IANA Considerations

IANA is requested to add the following family of SASL mechanisms to the SASL Mechanism registry established by {{RFC4422}}:

> To: iana@iana.org
>
> Subject: Registration of a new SASL family HT
>
> SASL mechanism name (or prefix for the family): HT-*
>
> Security considerations:
>   [](#security-considerations) of draft-schmaus-kitten-sasl-ht
>
> Published specification (optional, recommended):
>   draft-schmaus-kitten-sasl-ht-XX (TODO)
>
> Person & email address to contact for further information:
> IETF SASL WG <kitten@ietf.org>
>
> Intended usage: COMMON
>
> Owner/Change controller: IESG <iesg@ietf.org>
>
> Note: Members of this family MUST be explicitly registered
> using the "IETF Review" {{RFC5226}} registration procedure.
> Reviews MUST be requested on the Kitten WG mailing list
> <kitten@ietf.org> (or a successor designated by the responsible
> Security AD).


--- back

# Acknowledgments
{:numbered="false"}

This document benefited from discussions on the KITTEN WG mailing list.
The authors would like to especially thank Thijs Alkemade, Sam Whited and Alexey Melnikov for their comments on this topic.
Furthermore, we would like to thank Alexander Würstlein, who came up with the idea to pin the token to a SASL mechanism for increased security.
