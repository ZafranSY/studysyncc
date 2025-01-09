package CategoryPermission;

sub getCategoryPermission {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read = 1;')
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

sub getCategoryPermissionRead {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read = 1;')
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

sub getCategoryPermissionDelete {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read = 1 AND can_delete = 1;')
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
                            AND can_read = 1 AND can_create = 1;')
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

sub getCategoryPermissionUpdate {
    my ($dbh, $session_id, $semester_id) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('SELECT * 
                            FROM categoryPermission 
                            WHERE semester_id = ? 
                            AND (user_email = ? OR role_name = ? OR role_name=\'Everyone\') 
                            AND can_read = 1 AND can_update = 1;')
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
