package Cloudapipricelist;
use Dancer ':syntax';
use HTTP::Tiny;
use HTTP::Request;
use LWP::UserAgent;
use Api::PriceList;

our $VERSION = '0.1';
set serializer => 'JSON';
my $uri = qq~config->{url}/config->{version}/config->{token}~;

post '/pricelist' => sub {
	my $name = param "name";
    my $number = param "number";
    my $net = param "net";
    my $currency = param "currency";
    if(defined $name && defined $number){
	    Api::PriceList->main($uri, $name, $number, $net, $currency);
    }
    redirect '/';
};

true;
