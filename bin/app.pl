#!/usr/bin/perl
use Dancer;
use Cloudapi;
use Cloudapicurrency;
use Cloudapipricelist;
use Cloudapicustomergroup;
use Cloudapiinventory;
use Cloudapitimetracking;
use Swoppensystems;
#use Baeko;
#use FoodXML;
use threads;
use Import::CashIn;
use Data::Dumper;

my $url = config->{url}.'/'.config->{version}.'/'.config->{token};
my $customerGroup = config->{customergroup};
my $file = '/home/maz/Dokumente/KORONA.pos/swoppensystems/files/';
###############################################################################
sub main{
    my $thr = threads->new(\&sub1, "5");
    checkDb();
    dance;

}

###############################################################################
sub checkDb
{
    #TODO find db if not available create a new db
}

###############################################################################
sub sub1 {
    my ($sleepTime) = @_;
    for(;;){
		sleep($sleepTime);
		opendir DIR, $file;
		my @files = readdir(DIR);
		foreach (@files){
			my $fileEnding = /\.(.*)$/ ? $1 : '';
			if($fileEnding eq 'csv'){
				Import::CashIn->main($url, $customerGroup, "$file/$_");
			}
			sleep(1);
		}
    }
}
main();