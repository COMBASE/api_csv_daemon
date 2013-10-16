package Api::PriceList;


use HTTP::Tiny;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;
use strict;
use warnings;
use JSON::Parse 'valid_json';

use JSON qw( decode_json );

############################################################################################
sub main {
	my ($self, $uri, $name, $number, $net, $currency) = @_;

	$net = (defined $net && $net eq 'on') ? 'true' : 'false';

    my $json = qq~{"number":$number,"name":"$name","currency":$currency,"netPrices":$net}~;

	my $req = HTTP::Request->new( 'POST', $uri.'/prices/save' );
	$req->header( 
					'Content-Type' => 'application/json', 
					'charset'	   => 'utf-8',
				 );
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $re = $lwp->request( $req );
}
############################################################################################
1;