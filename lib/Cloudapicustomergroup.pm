package Cloudapicustomergroup;
use Dancer ':syntax';
use HTTP::Tiny;
use HTTP::Request;
use LWP::UserAgent;
use Api::CustomerGroup;
use Data::Dumper;

our $VERSION = '0.1';
set serializer => 'JSON';
my $uri = qq~config->{url}/config->{version}/config->{token}~;

post '/customergroup' => sub {
	my $name = param "name";
    my $number = param "number";
    my $customergroup = param "customergroup";
	if(defined $name && defined $number){
	    Api::CustomerGroup->main($uri, $name, $number, $customergroup);
    }
    redirect '/';
};

true;
