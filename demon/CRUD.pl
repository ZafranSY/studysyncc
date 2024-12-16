package CRUD;

use JSON::XS;

sub create {
    my $dbh = shift(@_);

    print "Category: ";
    my $category = <STDIN>;
    $category =~ s/\n//;

    print "Ref. Name: ";
    my $ref_name = <STDIN>;
    $ref_name =~ s/\n//;

    print "Session-Semester: ";
    my $sessem = <STDIN>;
    $sessem =~ s/\n//;

    print "Description: ";
    my $description = <STDIN>;
    $description =~ s/\n//;


    print "Owner: ";
    my $owner = <STDIN>;
    $owner =~ s/\n//;

    print "Link: ";
    my $link = <STDIN>;
    $link =~ s/\n//;

    my $sth = $dbh->prepare(
        'INSERT INTO gdlinks (category, ref_name, sessem, description, owner, link) values (?, ?, ?, ?, ?, ?)'
    ) or die 'prepare statement failed: ' . $dbh->errstr();

    $sth->execute($category, $ref_name, $sessem, $description, $owner, $link) or die 'execution failed: ' . $dbh->errstr();
}

sub createJSON {
    my $dbh = shift(@_);
    my $json = shift(@_);

    my $table = $json->{'table'};
    my $data = $json->{'data'};

    print "\$table = $table\n";

    if ($table eq "gdlinks") {
        my $sth = $dbh->prepare(
            'INSERT INTO gdlinks (category, ref_name, sessem, description, owner, link) values (?, ?, ?, ?, ?, ?)'
        ) or die 'prepare statement failed: ' . $dbh->errstr();

        $sth->execute($data->{'category'}, $data->{'ref_name'}, $data->{'sessem'}, 
                      $data->{'description'}, $data->{'owner'}, $data->{'link'}) or die 'execution failed: ' . $dbh->errstr();


        $json->{'operation'} = "CREATE";
        return $json;
    }
}

sub readJSON {
    my $dbh = shift(@_);
    my $json = shift(@_);

    my $table = $json->{'table'};
    my $data = $json->{'data'};

    print "\$table = $table\n";

    if ($table eq "gdlinks") {
        my $sth = $dbh->prepare(
            'SELECT * FROM gdlinks'
        ) or die 'prepare statement failed: ' . $dbh->errstr();

        $sth->execute() or die 'execution failed: ' . $dbh->errstr();

        return $sth->fetchall_arrayref({});
    }
}

sub updateJSON {
    my $dbh = shift(@_);
    my $json = shift(@_);

    my $table = $json->{'table'};
    my $data = $json->{'data'};
    my $id =  $json->{'id'};

    print "\$table = $table\n";

    if ($table eq "gdlinks") {
        my $sth = $dbh->prepare(
            'UPDATE gdlinks SET category=?, ref_name=?, sessem=?, description=?, owner=?, link=? WHERE id_gdlink=?'
        ) or die 'prepare statement failed: ' . $dbh->errstr();

        $sth->execute($data->{'category'}, $data->{'ref_name'}, $data->{'sessem'}, 
                      $data->{'description'}, $data->{'owner'}, $data->{'link'}, $id) or die 'execution failed: ' . $dbh->errstr();


        $json->{'operation'} = "UPDATE";
        return $json;
    }
}

sub deleteJSON {
    my $dbh = shift(@_);
    my $json = shift(@_);

    my $table = $json->{'table'};
    my $id = $json->{'id'};

    print "\$table = $table\n";

    if ($table eq "gdlinks") {
        my $sth = $dbh->prepare(
            'DELETE FROM gdlinks WHERE id_gdlink=?'
        ) or die 'prepare statement failed: ' . $dbh->errstr();

        $sth->execute($id) or die 'execution failed: ' . $dbh->errstr();

        $json->{'operation'} = "DELETE";
        return $json;
    }
}
sub getCategory {
    my $dbh = shift(@_);

    # Prepare the SQL statement to get unique categories
    my $sth = $dbh->prepare('SELECT DISTINCT category FROM gdlinks')
        or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query
    $sth->execute() or die 'execution failed: ' . $dbh->errstr();

    # Fetch all unique categories
    my @categories = ();
    while (my $row = $sth->fetchrow_hashref()) {
        push @categories, $row->{'category'};
    }

    return \@categories;
}
sub getSemester {
    my $dbh = shift(@_);

    # Prepare the SQL statement to get unique session-semester values
    my $sth = $dbh->prepare('SELECT DISTINCT sessem FROM gdlinks')
        or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query
    $sth->execute() or die 'execution failed: ' . $dbh->errstr();

    # Fetch all unique session-semester values
    my @semesters = ();
    while (my $row = $sth->fetchrow_hashref()) {
        push @semesters, $row->{'sessem'};
    }

    return \@semesters;
}
sub getBySemesterAndCategory {
    my ($dbh, $semester, $category) = @_;

    # Prepare the SQL query with placeholders for semester and category
    my $sth = $dbh->prepare(
        'SELECT * FROM gdlinks WHERE sessem = ? AND category = ?'
    ) or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query with the provided semester and category
    $sth->execute($semester, $category) or die 'execution failed: ' . $dbh->errstr();

    # Fetch all matching rows
    return $sth->fetchall_arrayref({});
}

1;