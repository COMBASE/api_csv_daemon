package Api::Currency;

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub getPage{
	my ($url) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/currencies/page/20')->{content};
    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{resultList};
    }
	return $resp;
}

############################################################################################
sub getByNumber{
	my ($url, $number) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/currencies/number/'.$number)->{content};
    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{result};
    }
	return $resp;
}
############################################################################################
1;