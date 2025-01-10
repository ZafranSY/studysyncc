package CategoryPermission;

sub getCategoryPermission {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read_category = 1;')
                            or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($semester_id,$email,$role_name) 
        or die 'execution failed: ' . $dbh->errstr();
    my @categoryPermission;
    while (my $row = $sth->fetchrow_hashref) {
        push @categoryPermission, $row;
    }
    # return \@categoryPermission;
    return \@categoryPermission;
}

sub CheckInsertPermission {
    my ($dbh, $semester_id, $category_name, $email,$role_name) = @_;

    # First, check if the user is an Academic Officer
    my $sth_role_check = $dbh->prepare('
        SELECT 1
        FROM user
        WHERE email = ?
        AND role_id = (SELECT role_id FROM roles WHERE role_name = "Academic Officer")
        LIMIT 1
    ') or die 'Prepare failed: ' . $dbh->errstr();

    # Execute the role check query
    $sth_role_check->execute($email)
        or die 'Execution failed: ' . $dbh->errstr();

    # If the user is an Academic Officer, return permission granted
    if (my $row = $sth_role_check->fetchrow_arrayref) {
        return 1;  # Academic Officer has permission
    }

    # If not an Academic Officer, check the category permission
    my $sth = $dbh->prepare('
        SELECT 1
        FROM categoryPermission
        WHERE category = ?
            AND can_create_links = 1
            AND semester_id = ?
            AND (
            role_name = ? OR 
            role_name = \'Everyone\'   OR
            user_email = ?
            )
        LIMIT 1
    ') or die 'Prepare failed: ' . $dbh->errstr();

    # Execute the query for category permission
    $sth->execute($category_name, $semester_id, $email,$role_name)
        or die 'Execution failed: ' . $dbh->errstr();

    # Check if permission was granted
    if (my $row = $sth->fetchrow_arrayref) {
        return 1;  # Permission granted
    } else {
        return 0;  # Permission denied
    }
}

sub getCategoryPermissionRead {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read_category = 1;')
                            or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($semester_id,$email,$role_name) 
        or die 'execution failed: ' . $dbh->errstr();
    my @categoryPermission;
    while (my $row = $sth->fetchrow_hashref) {
        push @categoryPermission, $row->{category};
    }
    # return \@categoryPermission;
    return \@categoryPermission;
}


sub getCategoryPermissionCreate {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read_category = 1 AND can_create = 1;')
                            or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($semester_id,$email,$role_name) 
        or die 'execution failed: ' . $dbh->errstr();
    my @categoryPermission;
    while (my $row = $sth->fetchrow_hashref) {
        push @categoryPermission, $row->{category};
    }
    # return \@categoryPermission;
    return \@categoryPermission;
}


# 
# 
# 
# 
# 
# 
# 
# 
# YOU"RE HERE OKKKK
# 

sub CreateCategoryPermission {
    my ($dbh, $semester_id, $category) = @_;
    
    my $sth_check = $dbh->prepare('SELECT 1 FROM categoryPermission WHERE semester_id = ? AND category = ? ')
                or die 'prepare statement failed: ' . $dbh->errstr();
    $sth_check->execute($semester_id,$category)
                or die 'prepare statement failed: ' . $dbh->errstr();
    my $exists = $sth_check->fetchrow_array;
    if ($exists) {
        return { error => "Category $category in $semester_id already exists" };
    }
    my $sth_insert = $dbh->prepare('INSERT INTO categoryPermission (semester_id,category) VALUES (?,?)')
                or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($semester_id,$category)
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => "Category $category on $semester_id added successfully" };
    } else {
        return { error => "Failed to add Category $category on $semester_id" };
    }
    return $result;
}

sub DeleteCategoryPermission {
    my ($dbh, $semester_id, $category) = @_;
    
    my $sth_check = $dbh->prepare('SELECT 1 FROM categoryPermission WHERE semester_id = ? AND category = ? ') 
                or die 'prepare statement failed: ' . $dbh->errstr();
    $sth_check->execute($semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    my $exists = $sth_check->fetchrow_array;
    if (!$exists) {
        return { error => "Category $category in $semester_id doesnt exists, Cannot Delete" };
    }
    my $sth_insert = $dbh->prepare('DELETE FROM categoryPermission where semester_id = ? AND category = ?') 
                or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => "Category $category on $semester_id deleted successfully" };
    } else {
        return { error => "Failed to delete category $category on $semester_id" };
    }
}

sub UpdateCategoryPermission {
    my ($dbh, $semester_id,$category,$new_category_name) = @_;
    
    my $sth_check = $dbh->prepare('SELECT 1 FROM categoryPermission WHERE semester_id = ? AND category = ?') or die 'prepare statement failed: ' . $dbh->errstr();
    $sth_check->execute($semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    my $exists = $sth_check->fetchrow_array;
    if (!$exists) {
        return { error => "Category $category in $semester_id doesnt exists, Cannot Update" };
    }
    my $sth_insert = $dbh->prepare('UPDATE categoryPermission SET category=? where semester_id = ? AND category = ?') or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($new_category_name,$semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => "Category updated from $category on $semester_id to $new_category_name successfully" };
    } else {
        return { error => "Failed to Update semester from $category on $semester_id to $new_category_name" };
    }
}
1;
