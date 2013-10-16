package Cloudapiinventory;

use Dancer ':syntax';
use Data::Dumper;
use ApiController::Order;

our $VERSION = '0.1';

my $url = config->{url}.'/'.config->{version}.'/'.config->{token};

###############################################################################
get '/stockorder' => sub {
	my $entryPage = ApiController::Order->getStockOrderPage($url);
	my $ttContent = ();
	$ttContent->{'stockorder'} = ref $entryPage eq 'HASH' ? [$entryPage] : $entryPage;
	template 'inventory';
	#, $ttContent;
};

###############################################################################
get '/dispatchnotifications' => sub {
	my $entryPage = ApiController::Order->getDispatchNotifications($url);
	my $ttContent = ();
	$ttContent->{'dispatchnotifications'} = ref $entryPage eq 'HASH' ? [$entryPage] : $entryPage;
	print Dumper($ttContent->{'dispatchnotifications'});
	template 'inventory', $ttContent;
};

###############################################################################
get '/stockreceipt' => sub {
	my $entryPage = ApiController::Order->getStockOrderPage($url);
#	print Dumper($entryPage);
	my $ttContent = ();
	$ttContent->{'stockreceipt'} = ref $entryPage eq 'HASH' ? [$entryPage] : $entryPage;
	template 'inventory', $ttContent;
};

true;
