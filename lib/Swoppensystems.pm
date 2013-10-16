package Swoppensystems;

use strict;
use warnings;
use Dancer ':syntax';
use Import::CashIn;
use Export::CashOut;
use Data::Dumper;
use Dancer::Request::Upload;

our $VERSION = '0.1';
set serializer => 'JSON';

my $uri = config->{url}.'/'.config->{version}.'/'.config->{token};
my $customerGroup = config->{customergroup};
my $path = '/home/maz/Dokumente/KORONA.pos/swoppensystems/files/';
###############################################################################
post '/chashin' =>sub{
	my $file = request->upload('file');
	my @ret = ();
	if(defined $file){
		open(FILE, ">$path$file->{filename}") or die "Couldn't open file $path.$file->{filename}, $!";
		foreach (split(/\n/,$file->content)){
			print FILE "$_\n";
		}
		close FILE;
	}
	template 'index',{
		customers => \@ret,
	};
};

###############################################################################
get '/cashout' => sub {
	my $revision = param('revision');
	my $ttContent = ();
	my $sales = Export::CashOut::main($uri, $customerGroup, $revision);
    template 'cashout', {
    	receipts			 => $sales,
		maxRevision			 => Export::CashOut::getMaxRevision(),
		lastExportedRevision => Export::CashOut::getLastExportedRevision($customerGroup),
    };
};

###############################################################################
get '/cashout.csv' => sub {
	my $revision = param('revision');
	my $sales = Export::CashOut::export($uri, $customerGroup, $revision);
	send_file(
		\"cashout", # anything, as long as it's a scalar-ref
		streaming => 1, # enable streaming
		callbacks => {
			override => sub {
				my ( $respond, $response ) = @_;
				my $http_status_code = 200 ;
				my @http_headers = ( 'Content-Type' => 'text/plain',
						     'Content-Disposition' => 'attachment; filename="cashout.csv"',
						     'Last-Modified' => strftime("%a, %d %b %Y %H:%M:%S GMT", gmtime),
						     'Expires' => strftime("%a, %d %b %Y %H:%M:%S GMT", gmtime),
						     'Pragma' => 'no-cache' );
				my $writer = $respond->( [ $http_status_code, \@http_headers ] );
				foreach (@$sales) {
					$writer->write(qq("$_->{customer}";"$_->{receiptnumber}";"$_->{date}";"$_->{time}";"$_->{quantity}";"$_->{article}";"$_->{description}";"$_->{tax}";"$_->{grossItemPrice}";"$_->{grossItemPrice}";"$_->{currency}";"$_->{cashier}";"$_->{cashiername}"\n));
				}
			},
		},
	);
};
###############################################################################

1;
