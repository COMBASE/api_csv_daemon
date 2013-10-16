package Cloudapi;
use Dancer ':syntax';
use Api::Currency;
use Api::CustomerGroup;

our $VERSION = '0.1';
my $url = config->{url}.'/'.config->{version}.'/'.config->{token};

get '/' => sub {
	my $currencys = Api::Currency::getPage($url);
	my $customergroups = Api::CustomerGroup::getPage($url);
	my $ttContent = ();
	$ttContent->{'currencys'} = ref $currencys eq 'HASH' ? [$currencys] : $currencys;
	$ttContent->{'customergroups'} = ref $customergroups eq 'HASH' ? [$customergroups] : $customergroups;
	template 'index', $ttContent;
};

true;
