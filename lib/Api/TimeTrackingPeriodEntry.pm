package Api::TimeTrackingPeriodEntry;

use XML::Twig;
use HTTP::Tiny;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;
use strict;
use warnings;
use JSON::Parse 'valid_json';
use JSON qw( decode_json );

############################################################################################
sub newEntry {
	my ($self, $uri) = @_;

	my ($sec, $min, $hour, $mday, $mon, $year) = localtime();
	my $time = (($year*1)+1900).'-0'.$mon.'-'.$mday.'-'.$hour.':'.$min.':'.$sec.'+0200';

	my $json = qq~{
					"cashier":"1",
					"org":"1",
					"start":"$time",
					"timeTrackingEntity":"1"
				}~;

	my $req = HTTP::Request->new( 'POST', $uri.'/timeTrackings/save' );
	$req->header( 
					'Content-Type' => 'application/json', 
					'charset'	   => 'utf-8',
				 );
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $re = $lwp->request( $req );
	# print Dumper($json);
	# print Dumper($re->{_content});
	return decode_json($re->{_content}) if (valid_json ($re->{_content}));
	
}

###############################################################################
sub getPage{
	my ($self, $url) = @_;
	my $resp = HTTP::Tiny->new->get($url.'/timeTrackings/page/100')->{content};
    if (valid_json ($resp)) {
		my $acknowlegde = decode_json($resp);
		$resp = $acknowlegde->{resultList};
    }
    return $resp;
}

###############################################################################
1;
