api_csv_daemon
==============

A API interface to interact between Swoppen systems and Konrona.pos Cloud, based in Perl

DE: http://www.combase.de

DE: http://www.combase.net/produkte/korona-pos/cloud/

EN: http://www.combase-usa.com/

EN: http://www.combase-usa.com/products/koronaposfamily/cloud/

https://www.koronacloud.com/web/

http://www.hotellerie.swoppen.com/

Is an daemon for the interfaces between  Korona.pos Cloud API and the client program of swoppensystems.

The following Korona.pos Cloud API objects are used:
- Cashier
- Currency
- Customer
- Customer Group
- Price List
- Receipt
- Sale

The following states stored in the program:
- last revision of the exported bons
- the customer which are stored Korona.pos cloud
- stored files in the configured file path and their md5hash

function:
It is periodically read out a pre-configured folders, and files that have been taken have been added or changed.
If this is the case it will be parsed and the Korona.pos Cloud API, customers will be synchronized.
At the same time all sales will bi written in the file "Cash.OUT" which are queried since the last 
synchronization between the Korona.pos Cloud API.
