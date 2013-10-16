package Api::Sale;

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub getPage{
	my ($url, $receipt) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/sales/all/'.$receipt)->{content};

    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{resultList};
    }
	return $resp;
}

############################################################################################
1;