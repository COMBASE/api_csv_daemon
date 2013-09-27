package Export::CashOut;

use strict;
use warnings;
use Data::Dumper;
use Api::Sale;
use Api::Cashier;
use Api::Receipt;
use Database::Insert;
use Database::Select;
my $maxRevision = 0;

my $file = 'C:\Dokumente und Einstellungen\user\Eigene Dateien\Dokumente\SwoppenSystems\Cash.OUT';
############################################################################################
sub main {
	my ($url, $customerGroup, $revision) = @_;
	my $currency = Api::Currency::getByNumber($url, 1);
	my $receipts = Api::Receipt::getUpdates($url, $revision);
	my $receiptsRef = ref $receipts eq 'HASH' ? [$receipts] : $receipts;
	my @ret=();
	my %chashierHash = ();
	foreach my $r (@$receiptsRef){
		my $sales = Api::Sale::getPage($url, $r->{uuid});
		$maxRevision = $r->{revision} if($r->{revision} > $maxRevision);
		my $arrrayRef = ref $sales eq 'HASH' ? [$sales] : $sales;
		foreach my $s (@$arrrayRef){
			$chashierHash{$s->{cashier}} = Api::Cashier::getByNumber($url, $s->{cashier}) if !$chashierHash{$s->{cashier}};
			my ($year, $month, $day, $time) = ($s->{bookingTime} =~ /(\d{4})-(\d{2})-(\d{2})T(\d\d:\d\d)/);
			$s->{customer} = $r->{customer};
			$s->{receiptnumber} = $r->{number};
			$s->{date} = qq~$day.$month.$year~;
			$s->{time} = $time;
			$s->{tax} = sprintf "%.0f,00", ($s->{grossItemPrice}-$s->{netItemPrice})/($s->{netItemPrice}/100);
			$s->{cashiername} = qq~$chashierHash{$s->{cashier}}->{firstname}~;
			$s->{currency} = qq~$currency->{symbol}~;
			$s->{grossItemPrice} =~ s/\./,/;
			$s->{netItemPrice} =~ s/\./,/;
			$s->{quantity} =~ s/\./,/;
			push(@ret, $s);
		}
	}
	return \@ret;
}

############################################################################################
sub writeFile{
	my ($selft, $url, $customerGroup, $revision) = @_;
	my $lastRevision = getLastExportedRevision($customerGroup);
	my $sales = main($url, $customerGroup, $lastRevision);
	open FILE, "> $file" or die $!;
	foreach (@$sales){
		if(defined $_->{customer}){
			my $cust = $_->{customer};
			my $str = qq~"$cust";"$_->{receiptnumber}";"$_->{date}";"$_->{time}";"$_->{quantity}";"$_->{article}";"$_->{description}";"$_->{tax}";"$_->{grossItemPrice}";"$_->{grossItemPrice}";"$_->{currency}";"$_->{cashier}";"$_->{cashiername}"~;
			print FILE $str; 
			print FILE $/; 
		}
	}
	close FILE;
	_setLastExportedRevision($customerGroup);
}

############################################################################################
sub export{
	my ($url, $customerGroup, $revision) = @_;
	my $ret = main($url, $customerGroup, $revision);
	_setLastExportedRevision($customerGroup);
	return $ret;
}

############################################################################################
sub getMaxRevision{
	return $maxRevision;
}

############################################################################################
sub getLastExportedRevision{
	my ($customerGroup) = @_;
	my $revision = Database::Select->getRevision($customerGroup);
	print Dumper($revision);
	if(defined $revision){return $revision->{revision};}
	return 0;
}

############################################################################################
sub _setLastExportedRevision{
	my ($customerGroup) = @_;
	Database::Insert->setRevision($customerGroup, $maxRevision);
}

1;
