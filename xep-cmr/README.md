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