package Api::Customer;

use strict;
use warnings;
use HTTP::Tiny;
use Data::Dumper;
use Api::Call::FromApi;
use Api::Call::ToApi;
use List::Util 'max';
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub getPage{
	my ($self, $url) = @_;
    return Api::Call::FromApi->getPage($url.'/customers', 20);
}

############################################################################################
sub getUpdates{
	my ($self, $url, $revision) = @_;
	return Api::Call::FromApi->getUpdates($url.'/customers', $revision);
}

############################################################################################
sub getByNumber{
	my ($self, $url, $number) = @_;
	my $get = qq~$url/customers~;
	return Api::Call::FromApi->getByNumber($get, $number);
}

############################################################################################
sub getById{
	my ($self, $url, $id) = @_;
	return Api::Call::FromApi->getById($url.'/customers', $id);
}

############################################################################################
sub getDeleteById{
	my ($self, $url, $customer) = @_;
	my $json = qq~{
					"deleted":true,
					"uuid":$customer->{uuid},
					"number":$customer->{number},
					"name":"$customer->{name}",
					"firstName":"$customer->{firstName}",
					"lastName":"$customer->{lastName}",
					"customerGroup":$customer->{customerGroup}
					}~;
	my $deletedCloudCustomer = Api::Call::ToApi->save($url.'/customers', $json);
	return $deletedCloudCustomer;
}

############################################################################################
sub save{
	my ($self, $url, $customer) = @_;
	my $json = qq~{
					"number":$customer->{number},
					"name":"$customer->{name}",
					"firstName":"$customer->{firstName}",
					"lastName":"$customer->{lastName}",
					"customerGroup":$customer->{customerGroup}
					}~;
	my $newCloudCustomer = Api::Call::ToApi->save($url.'/customers', $json);
	return $newCloudCustomer;
}
############################################################################################
1;