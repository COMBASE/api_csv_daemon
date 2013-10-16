package Cloudapicurrency;
use Dancer ':syntax';
use HTTP::Tiny;
use HTTP::Request;
use LWP::UserAgent;
use Api::Currency;

our $VERSION = '0.1';
set serializer => 'JSON';
my $uri = qq~config->{url}/config->{version}/config->{token}~;

post '/currency' => sub {
	my $name = param "name";
    my $number = param "number";
    # if(defined $name && defined $number){
	   #  Api::CustomerGroup->main($uri, $name, $number);
    # }
    redirect '/';
};

true;
