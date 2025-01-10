package Link;
use JSON;
use Data::Dumper;
use Log::Log4perl;
# Initialize Log4perl with a configuration
Log::Log4perl->init(\ q(
    log4perl.rootLogger              = DEBUG, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.layout  = Log::Log4perl::Layout::SimpleLayout
));

# Get a logger object
my $logger = Log::Log4perl->get_logger();

sub getLink {
    my ($dbh,$session_id, $semester_id,$category_name) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    $categoryPerm=CategoryPermission::getCategoryPermissionRead($dbh,$session_id, $semester_id);

    
    $a=(json => { categoriesPermission => $categoryPerm });
    

    my $found = 0;
    foreach my $perm (@{$a->{categoriesPermission}}) {
        if($perm eq $category_name){
            $found=1;
        }
    }
    if ($found!=1) {
        return { error => "Category $category_name doesnt exists or you lack permission" };
    } 
    
    my $sth = $dbh->prepare('
                        SELECT * 
                        FROM gdlinks 
                        WHERE (
                            gdlink_id IN (
                                SELECT gdlink_id 
                                FROM linkPermission 
                                WHERE semester_id = ? 
                                AND category = ?
                                AND (
                                    user_email = ?
                                    OR role_name = ?
                                    OR role_name = \'Everyone\'
                                ) 
                                AND can_read = 1
                            ) 
                            OR owner = ?
                        )
                        AND sessem = ?
                        AND category =?

                        OR EXISTS (
                            SELECT 1
                            FROM user 
                            WHERE email = ?
                            AND role_id = (SELECT role_id FROM roles WHERE role_name = "Academic Officer")
                        )
                        AND sessem = ?
                        AND category = ?;
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($semester_id, $category_name, $email, $role_name,$email,$semester_id,$category_name,$email,$semester_id,$category_name)
        or die 'execution failed: ' . $dbh->errstr();

    my @result;
    while (my @row = $sth->fetchrow_array) {
        push @result, \@row;  
    }
    
    return \@result;
}


sub CreateLink {
    my ($dbh,$session_id, $semester_id,$category_name,$ref_name,$desc,$link) = @_;
    $role_name=Authorization::getRoleName($dbh, $session_id);
    $email=Authorization::getEmail($dbh, $session_id);
    $categoryPerm=CategoryPermission::getCategoryPermissionRead($dbh,$session_id, $semester_id);
    $a=(json => { categoriesPermission => $categoryPerm });
    my $found = 0;
    foreach my $perm (@{$a->{categoriesPermission}}) {
        if($perm eq $category_name){
            $found=1;
        }
    }
    if ($found!=1) {
        return { error => "Category $category_name doesnt exists or you lack permission" };
    } 

    # GET INSERT PERM
    my $insPerm=CategoryPermission::CheckInsertPermission ($dbh, $semester_id, $category_name, $email,$role_name);
    if($insPerm==0){
        return { error => "Link $ref_name, $link failed to be inserted, NOT ENOUGH PERM" };
    }

    my $sth = $dbh->prepare('
                        INSERT INTO gdlinks (category, sessem, ref_name, description, owner, link)
                        SELECT ?, ?, ?, ?, ?, ?
                        FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM categoryPermission
                            WHERE category = ?
                            AND semester_id = ?
                            AND 
                            (
                            user_email = ?
                            OR role_name = \'Everyone\'
                            OR role_name = ?
                            )
                            AND can_create_links = 1
                            LIMIT 1
                        )
                        OR EXISTS (
                            SELECT 1
                            FROM user
                            WHERE email = ?
                            AND role_id = (SELECT role_id FROM roles WHERE role_name = "Academic Officer")
                            LIMIT 1);
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    my $result=$sth->execute($category_name, $semester_id,$ref_name,$desc,$email,$link,$category_name,$semester_id,$email,$role_name,$email)
        or die 'execution failed: ' . $dbh->errstr();

    if ($result) {
        return { message => "Link $ref_name, $link inserted successfully" };
    } else {
        return { error => "Link $ref_name, $link failed to be inserted" };
    }
    
    return $result;
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
        return { message => "Category $category on $semester_id deleted successfully" };
    } else {
        return { error => "Failed to delete category $category on $semester_id" };
    }
}

sub UpdateCategory {
    my ($dbh, $semester_id,$category,$new_category_name) = @_;
    
    my $sth_check = $dbh->prepare('SELECT 1 FROM Categories WHERE semester_id = ? AND category = ?') or die 'prepare statement failed: ' . $dbh->errstr();
    $sth_check->execute($semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    my $exists = $sth_check->fetchrow_array;
    if (!$exists) {
        return { error => "Category $category in $semester_id doesnt exists, Cannot Update" };
    }
    my $sth_insert = $dbh->prepare('UPDATE Categories SET category=? where semester_id = ? AND category = ?') or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($new_category_name,$semester_id,$category) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => "Category updated from $category on $semester_id to $new_category_name successfully" };
    } else {
        return { error => "Failed to Update semester from $category on $semester_id to $new_category_name" };
    }
}
1;
