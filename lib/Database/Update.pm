package Database::Update;

use strict;
use warnings;
use Dancer::Plugin::Database;
use Database::Select;
use Data::Dumper;

###############################################################################
sub updateParsedFile{
my ($self, $customerGroup, $fileName, $fileHash) = @_;
    
    my $dbRevision = Database::Select->getParsedFiles($fileName, $customerGroup, );
    my $sth;

    if(defined $dbRevision){
        $sth = database->prepare( 'UPDATE files_parsed SET file_hash = ? WHERE customer_group = ? and file_name = ?');    
    }    
    if(defined $sth){
        return $sth->execute($fileHash, $customerGroup, $fileName);
    }

}

###############################################################################
sub updateRevision{
    my ($customerGroup, $revision) = @_;
    
    my $dbRevision = Database::Select->getRevision($customerGroup);
    my $sth;

    if(defined $dbRevision){
        $sth = database->prepare( 'UPDATE last_revisions SET revision= ? WHERE customer_group = ?');    
    }
    if(defined $sth){
        return $sth->execute($customerGroup, $revision);
    }
}

###############################################################################
sub updateCustomer{
    my ($self, $customer) = @_;
    my $dbRevision = Database::Select->getCustomer($customer->{customer_number});
    my $sth;
    print "UPDATE parsed_lines SET current = $customer->{current} WHERE customer_number = $customer->{customer_number}\n";
    if(defined $dbRevision){
        $sth = database->prepare( 'UPDATE parsed_lines SET current = ? WHERE customer_number = ?');    
    }
    if(defined $sth){
        return $sth->execute($customer->{current}, $customer->{customer_number});
    }
}

###############################################################################
sub setAllCustommersToCurrent{
    my $sth;
   print "UPDATE parsed_lines SET current = 1\n";
    $sth = database->prepare( 'UPDATE parsed_lines SET current = 1');    
    if(defined $sth){
        $sth->execute();
    }   
}
###############################################################################
1;