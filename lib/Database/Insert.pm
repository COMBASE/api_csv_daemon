package Database::Insert;

use strict;
use warnings;
use Dancer::Plugin::Database;
use Database::Select;
use Data::Dumper;

###############################################################################
sub setParsedFile{
my ($self, $customerGroup, $fileName, $fileHash) = @_;
    
    my $dbRevision = Database::Select->getParsedFiles($fileName, $customerGroup, $fileHash);
    my $sth;

    if(defined $dbRevision){
        $sth = database->prepare( 'UPDATE files_parsed SET file_hash = ? WHERE customer_group = ? and file_name = ?');    
    }
    else{
        $sth = database->prepare( ' INSERT INTO files_parsed (file_hash, customer_group, file_name ) VALUES (?, ?, ?)');
    }
    
    if(defined $sth){
        $sth->execute($fileHash, $customerGroup, $fileName);
        return Database::Select->getParsedFiles($fileName, $customerGroup, $fileHash);
    }

}

###############################################################################
sub setRevision{
    my ($self, $customerGroup, $revision) = @_;
    my $dbRevision = Database::Select->getRevision($customerGroup);
    my $sth;
    if(defined $dbRevision){
        $sth = database->prepare( 'UPDATE last_revisions SET revision= ? WHERE customer_group = ?');    
    }else{
        $sth = database->prepare( ' INSERT INTO last_revisions (revision, customer_group) VALUES (?, ?)');    
    }
    if(defined $sth){
        $sth->execute($revision, $customerGroup);
        return Database::Select->getRevision($customerGroup);
    }
}

###############################################################################
sub setCustomer{
    my ($self, $customer) = @_;
    
    my $dbCustomer = Database::Select->getCustomer($customer->{number});
    my $sth;
    if(defined $dbCustomer){
        $sth = database->prepare( 'UPDATE parsed_lines SET current = ? WHERE customer_number = ?');    
    }
    else{
        $sth = database->prepare( ' INSERT INTO parsed_lines (current, customer_number, name) VALUES (?, ?, ?)');    
    }
    
    if(defined $sth){
        $sth->execute($customer->{current}, $customer->{number}, $customer->{name});
        return Database::Select->getCustomer($customer->{number});
    }
}

###############################################################################
1;