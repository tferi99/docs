Ticket #867

one customer has the problem, that no matter what he tries or does, the SIP trunk from CUCM is not able to establish a connection to APAS. 
A sniffertrace revealed that somehow APAS is not sending the correct answers to CUCM and CUCM aborts the connection establishment (I think because of a timeout). 
Comparing this trace to other traces of working SIP trunks it shows a clear difference in the answering behaviour.

