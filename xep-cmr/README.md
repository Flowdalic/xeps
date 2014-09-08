Motivation
===========

The idea behind "Customizeable Message Routing" (CMR) originated from
a Ignite Realtime forum thread
(https://community.igniterealtime.org/message/242204). A user asked
about Openfire's message routing behavior when multiple resources
where available and if a round-robin distribution of the messages to
the resources would be possible. He wanted to distributed incoming
stanzas, originating from sensors, evenly over nodes of a cluster
collecting the data from the sensors. Every node of the cluster is
connected using the same JID, but with a different resource of course.

So we find ourselves in a M2M scenario that uses XMPP. Traditionally the
XMPP RFCs lay out two possible routing algorithms in that case:
1. Route to all resource or 2. Route to the "most available"
resource. The newer RFC (6121) leave it up to the server
implementation how to determine the "most available" resource.

That is where CMR jumps in, by exploiting this freedom RFC 6121 to
allow e.g. to define the "most available" resource as the resource
chosen by a round-robin algorithm.