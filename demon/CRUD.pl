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

# Function to handle search
sub getSearch {
    my ($dbh, $search) = @_;

    # Prepare the SQL query to search for entries that match the search term
    my $sth = $dbh->prepare(
        'SELECT * FROM gdlinks WHERE category LIKE ? OR ref_name LIKE ? OR description LIKE ?'
    ) or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query with the search term
    my $search_term = "%$search%"; # Use wildcards for partial matches
    $sth->execute($search_term, $search_term, $search_term) or die 'execution failed: ' . $dbh->errstr();

    # Fetch matching rows
    return $sth->fetchall_arrayref({});
}
sub addLinkWithDesc {
    my ($dbh, $link, $Desc) = @_;

    # Prepare the SQL statement to insert the link and message into the database
    my $sth = $dbh->prepare('INSERT INTO gdlinks (link, message) VALUES (?, ?)')
        or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query
    $sth->execute($link, $Desc) or die 'execution failed: ' . $dbh->errstr();

    # Return a success status
    return 1;
}

sub getCategoryBySemester {
    my ($dbh, $semester) = @_;

    # Prepare the SQL statement to fetch unique categories for the given semester
    my $sth = $dbh->prepare(
        'SELECT DISTINCT category FROM gdlinks WHERE sessem = ?'
    ) or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query with the provided semester
    $sth->execute($semester) or die 'execution failed: ' . $dbh->errstr();

    # Fetch the unique categories
    my @categories = ();
    while (my $row = $sth->fetchrow_hashref()) {
        push @categories, $row->{'category'};
    }

    return \@categories;
}
sub getRefnameByCategory {
    my ($dbh, $category) = @_;  # Get the database handle and category from the caller

    # SQL query to select the desired columns (ref_name, description, owner) where the category matches
    my $sql = 'SELECT ref_name, description, owner FROM gdlinks WHERE category = ?';
    
    # Prepare the statement and execute it with the provided category
    my $sth = $dbh->prepare($sql) or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($category) or die 'execution failed: ' . $dbh->errstr();
    
    # Fetch all results
    my @files;
    while (my $row = $sth->fetchrow_hashref) {
        push @files, {
            ref_name    => $row->{ref_name},
            description => $row->{description},
            owner       => $row->{owner},
        };
    }
    
    # Return the results as an array of hashes
    return \@files;
}


sub getLinks {
    my $dbh = shift(@_);

    # Prepare the SQL statement to retrieve all links
    my $sth = $dbh->prepare('SELECT link FROM gdlinks')
        or die 'prepare statement failed: ' . $dbh->errstr();

    # Execute the query
    $sth->execute() or die 'execution failed: ' . $dbh->errstr();

    # Fetch all links
    my @links = ();
    while (my $row = $sth->fetchrow_hashref()) {
        push @links, $row->{'link'};
    }

    return \@links;
}



1;