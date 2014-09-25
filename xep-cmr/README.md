Motivation
===========

The idea behind "Customizable Message Routing" (CMR) originated from a
Ignite Realtime forum thread [1]: A user asked about Openfire's
message routing behavior when multiple resources where available and
if a round-robin distribution of the messages to the resources would
be possible. He wanted to distribute incoming stanzas, originating
from sensors, evenly over nodes of a cluster collecting the data from
the sensors. Every node of the cluster is connected using the same JID
and has the same priority configured, but with a different resource of
course.

So we find ourselves in a M2M scenario using XMPP, where many clients
send their data to one XMPP entity which consists of multiple cluster
nodes (note that this is *not* a clustered XMPP server). Traditionally
the XMPP RFCs describe two possible routing algorithms in that case:
1. Route to all resources, or 2. Route to the "most available"
resource. The newer RFC 6121 leaves it to the server implementation
how to determine the "most available" resource.

That is where CMR jumps in, by exploiting this freedom of RFC 6121
e.g. by defining the "most available" resource as the resource chosen
by a round-robin algorithm.

The XEP of CMR can be found at

https://geekplace.eu/xeps/xep-cmr/xep-cmr.html

and the source is available at

https://github.com/Flowdalic/xeps/tree/master/xep-cmr

I don't consider the CMR specification finished. For example error
handling is missing in some cases. I also wounder if 5.4 shouldn't go
into an extra XEP.

1: https://community.igniterealtime.org/message/242204

XMPP Council 2014-09-24
=======================

http://logs.xmpp.org/council/2014-09-24/

[15:06:12] <Kev> 3) http://xmpp.org/extensions/inbox/cmr.html
Accept?
[15:06:16] <stpeter> sorry, I'm in a sales call at the moment :-)
[15:06:40] <Kev> I'm not blocking this either.
[15:07:13] *** ralphm shows as "online"
[15:07:16] <fippo> i like the general idea but will vote onlist
[15:07:40] <Lance> +1 for experimenting. though i'd prefer it to use disco instead of the <available /> bits
[15:07:48] <Kev> Lance: Certainly.
[15:07:50] <Tobias> i'm unsure about the use case, the use case section more describes the use cases for different routing rules...less so the use case for discovering those dynamically
[15:08:46] <ralphm> I'm with Tobias, fwiw
[15:09:36] <Kev> I have, FWIW, chatted with various people over the years that had use cases that would be solved by round-robin bare-JID handling.
[15:10:05] <Kev> Although I can't remember the details of any of them, just recalling conversations about flapping priorities around to do load-balancing.
[15:10:42] <Tobias> Kev, yeah..but what would it benefit a client knowing the server does routing X instead of routing Y?
[15:10:46] <Lance> it would probably be worth giving more explanation on why this is different than carbons, or how the two interact. this spec i assume is more for bots & iot than humans

See also: http://mail.jabber.org/pipermail/standards/2014-September/029213.html
