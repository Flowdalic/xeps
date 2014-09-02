Motiviation
===========

Basically https://community.igniterealtime.org/message/242204

Openfire has had the route.all-resources propertery for years now,
which is a global on/off switch. I can only assume that the motivation
for this feature orignitated from PubSub demands.

The thread shows that there is a demand for a third way, besides
sending the message stable to one resource and broadcasting it to all
resources (with the same priority): Using round robin, in order to
achieve load balancing.
