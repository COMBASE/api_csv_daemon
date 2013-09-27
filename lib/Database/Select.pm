package Database::Select;

use strict;
use warnings;
use Dancer::Plugin::Database;
use Data::Dumper;

###############################################################################
sub getRevision{
    my ($self, $customerGroup) = @_;
	my $sth = database->prepare( 'select * FROM last_revisions where customer_group = ?');
    $sth->execute($customerGroup);
	my $ret = $sth->fetchrow_hashref;
	return $ret;
}

###############################################################################
sub getParsedFiles{
    my ($self, $file, $customerGroup) = @_;
    my $sth = database->prepare( 'select * FROM files_parsed where customer_group = ? AND file_name = ?');
    $sth->execute($customerGroup, $file);
    return $sth->fetchrow_hashref;
}

###############################################################################
sub getCustomer{
    my ($self, $customer) = @_;
    my $sth = database->prepare( 'SELECT * FROM parsed_lines WHERE customer_number = ?');
    $sth->execute($customer);
    return $sth->fetchrow_hashref;
}


###############################################################################
sub getOldCustomer{
    my ($self, $customer) = @_;
    my $sth = database->prepare( 'SELECT * FROM parsed_lines WHERE current = 1');
    $sth->execute();
    return $sth->fetchall_arrayref;
}
###############################################################################
1;