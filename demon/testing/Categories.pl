package Categories;

sub getCategories {
    my ($dbh, $semester_id) = @_;
    my $sth = $dbh->prepare('SELECT * FROM Categories where semester_id= ? ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($semester_id) 
        or die 'execution failed: ' . $dbh->errstr();
    my @semesters;
    while (my $row = $sth->fetchrow_hashref) {
        push @semesters, $row->{category};
    }
    return \@semesters;
}

sub CreateCategory {
    my ($dbh, $semester_id, $category) = @_;
    
    my $sth_check = $dbh->prepare('SELECT 1 FROM Categories WHERE semester_id = ? AND category = ? ')
                or die 'prepare statement failed: ' . $dbh->errstr();
    $sth_check->execute($semester_id,$category)
                or die 'prepare statement failed: ' . $dbh->errstr();
    my $exists = $sth_check->fetchrow_array;
    if ($exists) {
        return { error => "Category $category in $semester_id already exists" };
    }
    my $sth_insert = $dbh->prepare('INSERT INTO Categories (semester_id,category) VALUES (?,?)')
                or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($semester_id,$category)
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => 'Semester added successfully' };
    } else {
        return { error => 'Failed to add semester' };
    }
}

sub DeleteCategory {
    my ($dbh, $semester_id, $category) = @_;
    
    my $sth_check = $dbh->prepare('SELECT 1 FROM Categories WHERE semester_id = ? AND category = ? ') 
                or die 'prepare statement failed: ' . $dbh->errstr();
    $sth_check->execute($semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    my $exists = $sth_check->fetchrow_array;
    if (!$exists) {
        return { error => "Category $category in $semester_id doesnt exists, Cannot Delete" };
    }
    my $sth_insert = $dbh->prepare('DELETE FROM Categories where semester_id = ? AND category = ?') 
                or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => 'Category deleted successfully' };
    } else {
        return { error => 'Failed to delete category' };
    }
}
1;
