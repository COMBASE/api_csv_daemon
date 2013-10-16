package Baeko;

use strict;
use warnings;
use Dancer ':syntax';
use Data::Dumper;

our $VERSION = '0.1';


get '/baeko_insert_' => sub {
	template 'baeko', {};
};

1;