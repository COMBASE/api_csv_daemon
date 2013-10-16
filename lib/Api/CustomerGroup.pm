package Api::CustomerGroup;

use Text::CSV;
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
	my ($self, $uri, $name, $number, $customergroup) = @_;
	my $toUpdateCustomergroup = qq~"uuid":"$customergroup"~ if(defined $customergroup);
	$number = qq~"number":"$number"~ if(defined $number);
	$name = qq~"name":"$name"~ if(defined $name);
	my $json = qq~{$number,$name,$toUpdateCustomergroup,}~;
	my $req = HTTP::Request->new( 'POST', $uri.'/customergroups/save' );
	$req->header( 
					'Content-Type' => 'application/json', 
					'charset'	   => 'utf-8',
				 );
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $re = $lwp->request( $req );
}
############################################################################################

sub getPage{
	my ($url) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/customergroups/page/20')->{content};

    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{resultList};
    }
	return $resp;
}
############################################################################################
1;
