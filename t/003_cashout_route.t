use Test::More tests => 3;
use strict;
use warnings;

# the order is important
use swoppensystems;
use Dancer::Test;

route_exists [GET => '/cashout'], 'a route handler is defined for /';
response_status_is ['GET' => '/cashout'], 200, 'response status is 200 for /';
