package Database::Delete;

use strict;
use warnings;
use Dancer::Plugin::Database;
use Database::Select;
use Data::Dumper;

###############################################################################
sub deleteParsedFile{
my ($self, $customerGroup, $fileName, $fileHash) = @_;
    
    my $dbRevision = Database::Select->getParsedFiles($fileName, $customerGroup, );
    my $sth;

    if(defined $dbRevision){
        $sth = database->prepare( 'delete files_parsed SET file_hash = ? WHERE customer_group = ? and file_name = ?');    
    }    
    if(defined $sth){
        return $sth->execute($fileHash, $customerGroup, $fileName);
    }

}

###############################################################################
sub deleteRevision{
    my ($customerGroup, $revision) = @_;
    
    my $dbRevision = Database::Select->getRevision($customerGroup);
    my $sth;

    if(defined $dbRevision){
        $sth = database->prepare( 'delete last_revisions SET revision= ? WHERE customer_group = ?');    
    }
    if(defined $sth){
        return $sth->execute($customerGroup, $revision);
    }
}

###############################################################################
sub deleteOldCustomer{
    my $sth;
    print "DELETE FROM parsed_lines WHERE current = 1\n";
    $sth = database->prepare( 'DELETE FROM parsed_lines WHERE current = 1');    
    if(defined $sth){
        $sth->execute();
    }
}

###############################################################################
sub deleteCustomer{
    my ($self, $customer) = @_;
    print "$self: DELETE FROM parsed_lines WHERE customer_number = $customer->{number}\n";
    my $dbRevision = Database::Select->getCustomer($customer->{number});
    my $sth;

    if(defined $dbRevision){
        $sth = database->prepare( 'DELETE FROM parsed_lines WHERE customer_number = ?');
    }
    if(defined $sth){
        return $sth->execute($customer->{number});
    }
}
###############################################################################
1;