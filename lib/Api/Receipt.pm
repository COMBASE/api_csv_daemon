package Api::Receipt;

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

###############################################################################
sub getPage{
	my ($url, $customerGroup, $revision) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/receipts/customergroup/'.$customerGroup);

    if (valid_json ($resp->{content})) {
		my $acknowlegde = decode_json($resp->{content});
		$resp = $acknowlegde->{resultList};
		#print Dumper($resp);
    }
	return $resp;
}

############################################################################################
sub getUpdates{
	my ($url, $revision) = @_;
	my $rev = (defined $revision) ? $revision : 0;
	return Api::Call::FromApi->getUpdates($url.'/receipts', $rev);
}

###############################################################################
sub getPageFromRevision{
	my ($url, $customerGroup, $revision) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/receipts/fromrevision/'.$revision);

    if (valid_json ($resp->{content})) {
		my $acknowlegde = decode_json($resp->{content});
		$resp = $acknowlegde->{resultList};
		#print Dumper($resp);
    }
	return $resp;
}
###############################################################################
1;