package Import::CashIn;

use strict;
use warnings;
use Text::CSV;
use HTTP::Tiny;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;
use Digest::MD5::File;
use Database::Select;
use Database::Insert;
use Database::Update;
use Database::Delete;
use Api::Customer;
use Export::CashOut;

use JSON::Parse 'valid_json';
use JSON qw( decode_json );

my $url;
############################################################################################
sub main {
	my ( $self, $u, $customerGroup, $file ) = @_;
	$url = $u;
	my $csv      = Text::CSV->new( { sep_char => ';' } );
	my @ret      = ();
	my $sum      = 0;
	my $fileHash = _getMD5Hash($file);
	if ( _checkMD5HashFromDb( $fileHash, $file, $customerGroup ) ) {

		#print Dumper($fileHash, $file, $customerGroup);
		open( my $data, '<', $file ) or die "Could not open '$file' $!\n";

		#print qq~Insert new or changed file into database: $file\n~;
		Database::Insert->setParsedFile( $customerGroup, $file, $fileHash );
		while ( my $line = <$data> ) {
			chomp $line;
			if ( $csv->parse($line) ) {
				my @fields = $csv->fields();
				push( @ret, _handleCashInLine( $customerGroup, \@fields ) );
			}
			else {
				warn "Line could not be parsed: $line\n";
			}
		}
		_deleteOldCustomer($customerGroup);
		Database::Update->setAllCustommersToCurrent();
		Export::CashOut->writeFile( $url, $customerGroup );
	}
	return \@ret;
}

############################################################################################
sub _handleCashInLine {
	my ( $customerGroup, $fields ) = @_;

	if ( ( $fields->[0] !~ /\D/ ) && ( $fields->[0] ne "" ) ) {
		my $existingClienCustomer = Database::Select->getCustomer( $fields->[0] );
		my $existingCloudCustomer = Api::Customer->getByNumber( $url, $fields->[0] );
		if ( defined $existingClienCustomer && defined $existingCloudCustomer ) {
			$existingClienCustomer->{current} = 2;
			return Database::Update->updateCustomer($existingClienCustomer);
		}
		$existingClienCustomer->{number}        = $fields->[0];
		$existingClienCustomer->{name}          = "$fields->[1] $fields->[2]";
		$existingClienCustomer->{firstName}     = $fields->[1];
		$existingClienCustomer->{lastName}      = $fields->[2];
		$existingClienCustomer->{current}       = 2;
		$existingClienCustomer->{customerGroup} = $customerGroup;
		my $cloudCustomer = Api::Customer->save( $url, $existingClienCustomer );

		if ( defined $cloudCustomer ) {
			my $dbCustomer = Database::Insert->setCustomer($existingClienCustomer);
			$cloudCustomer->{current}         = $dbCustomer->{current};
			$cloudCustomer->{file_id}         = $dbCustomer->{file_id};
			$cloudCustomer->{customer_number} = $dbCustomer->{customer_number};
			return $cloudCustomer;
		}
	}
	return undef;
}

############################################################################################
sub _getMD5Hash {
	my ($file) = @_;
	my $md5 = Digest::MD5::File->new;
	$md5->addpath($file);
	return $md5->hexdigest;
}

############################################################################################
sub _checkMD5HashFromDb {
	my ( $hash, $file, $customerGroup ) = @_;
	my $dbFile = Database::Select->getParsedFiles( $file, $customerGroup );
	if ( defined $dbFile ) {
		if ( $dbFile->{file_hash} eq $hash ) { return 0; }
		return 1;
	}
	else {
		return 1;
	}
}

############################################################################################
sub _deleteOldCustomer {
	my ($customerGroup) = @_;
	my $oldCustomer = Database::Select->getOldCustomer();
	foreach (@$oldCustomer) {
		my $cloudCustomer = Api::Customer->getByNumber( $url, $_->[2] );
		if ( defined $cloudCustomer ) {
			$cloudCustomer->{customerGroup} = $customerGroup;
			my $deletedCloudCustomer = Api::Customer->getDeleteById( $url, $cloudCustomer );
			Database::Delete->deleteCustomer( { number => $_->[2] } )
			  if ( defined $deletedCloudCustomer );
		}
	}
}

############################################################################################
1;
