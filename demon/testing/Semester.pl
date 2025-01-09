package Semester;

sub getSemester {
    my $dbh = shift(@_);
    my $sth = $dbh->prepare('SELECT * FROM sessionSemester')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute() or die 'execution failed: ' . $dbh->errstr();
    my @semesters;
    while (my $row = $sth->fetchrow_hashref) {
        push @semesters, $row->{semester_id};
    }
    return \@semesters;
}

sub CreateSemester {
    my ($dbh, $semester_id) = @_;
    if (!$semester_id || length($semester_id) != 11) {
        return { error => 'Invalid semester_id. It must be 11 characters.' };
    }
    my $sth_check = $dbh->prepare('SELECT 1 FROM sessionSemester WHERE semester_id = ?');
    $sth_check->execute($semester_id);
    my $exists = $sth_check->fetchrow_array;
    if ($exists) {
        return { error => "Semester ID $semester_id already exists" };
    }
    my $sth_insert = $dbh->prepare('INSERT INTO sessionSemester (semester_id) VALUES (?)');
    $sth_insert->execute($semester_id);
    if ($result) {
        return { message => 'Semester added successfully' };
    } else {
        return { error => 'Failed to add semester' };
    }
}

1;

1;