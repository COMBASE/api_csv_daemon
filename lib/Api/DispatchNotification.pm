package Api::DispatchNotification;

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;
use Api::Call::FromApi;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub getPage{
	my ($self, $url) = @_;
	return Api::Call::FromApi->getPage($url.'/dispatchnotifications', 20);
}

############################################################################################
sub getByNumber{
	my ($self, $url, $number) = @_;
	return Api::Call::FromApi->getByNumber($url.'/dispatchnotifications', $number);
}

############################################################################################
sub getById{
	my ($self, $url, $id) = @_;
	return Api::Call::FromApi->getById($url.'/dispatchnotifications/', $id);
}

############################################################################################
1;