package ApiController::Order;

use strict;
use warnings;
use Api::StockOrder;
use Api::DispatchNotification;
###############################################################################
sub getDispatchNotifications{
	my ($self, $url) = @_;
	my $entryPage = Api::DispatchNotification->getPage($url);
}

###############################################################################
sub getStockReceiptPage{

}

###############################################################################
sub getStockOrderPage{
	my ($self, $url) = @_;
	my %orgs = ();
	my $entryPage = Api::StockOrder->getPage($url);
	return $entryPage;
}

1;