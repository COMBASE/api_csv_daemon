package Api::StockOrder;

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
	my $resp = HTTP::Tiny->new->get($url.'/stockorders/page/20')->{content};
    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{resultList};
    }
	return $resp;
}

############################################################################################
sub getByNumber{
	my ($url, $number) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/stockorders/number/'.$number)->{content};
    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{result};
    }
	return $resp;
}

############################################################################################
sub getById{
	my ($url, $id) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/stockorders/id/'.$id)->{content};
    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{result};
    }
	return $resp;
}

############################################################################################
1;