package Api::Call::FromApi;

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub getPage{
	my ($self, $url) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/page/20')->{content};
    return _decodeResponse($resp);
}

############################################################################################
sub getByNumber{
	my ($self, $url, $number) = @_;
	$url = qq($url/number/$number);
	my $resp = HTTP::Tiny->new->get($url)->{content};
    return _decodeResponse($resp);
}

############################################################################################
sub getById{
	my ($self, $url, $id) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/id/'.$id)->{content};
    return _decodeResponse($resp);
}

############################################################################################
sub getUpdates{
	my ($self, $url, $revision) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/updates/'.$revision)->{content};
	return _decodeResponse($resp);
}
############################################################################################
sub _decodeResponse{
	my ($response) = @_;
	if (valid_json ($response)) {
		my $acknowlegde = decode_json($response);
		$response = (defined $acknowlegde->{resultList}) ? $acknowlegde->{resultList} : $acknowlegde->{result};
    }
	return $response;
}

############################################################################################
1;