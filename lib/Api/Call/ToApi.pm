package Api::Call::ToApi;

use strict;
use warnings;
use HTTP::Tiny;
use HTTP::Request;
use Data::Dumper;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub save{
	my ($self, $url, $json) = @_;
	my $req = HTTP::Request->new( 'POST', $url.'/save' );
	$req->header( 'Content-Type' => 'application/json', 'charset' => 'utf-8',);
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $re = $lwp->request( $req );
	return _decodeResponse($re->{_request}->{_content});
}

############################################################################################
sub _decodeResponse{
	my ($response) = @_;
	if (valid_json ($response)) {
		my $acknowlegde = decode_json($response);
		return $acknowlegde;
    }
}

1;