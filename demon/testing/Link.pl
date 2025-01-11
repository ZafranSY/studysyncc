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

sub getALLlink {
    my ($dbh,$session_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('
            SELECT * from gdlinks 
                where owner= ?
                OR gdlink_id IN 
                    (
                    select gdlink_id from linkPermission 
                        where   
                                (
                                user_email= ?
                                OR role_name=\'Everyone\' 
                                OR role_name=  ? 
                                )
                            AND can_read=1
                    
                        AND category IN 
                            (
                            select DISTINCT category from categoryPermission 
                                where can_read_category=1 
                                AND 
                                    (
                                    role_name=\'Everyone\' 
                                    OR role_name=? 
                                    OR user_email=?
                                    )   
                            )
                    )

                OR "Academic Officer"=?    
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($email, $email, $role_name,$role_name,$email,$role_name)
        or die 'execution failed: ' . $dbh->errstr();

    my @result;
    while (my @row = $sth->fetchrow_array) {
        push @result, \@row;  
    }
    
    return \@result;
}


sub getALLlinkCount {
    my ($dbh,$session_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('
            SELECT COUNT(*) from gdlinks 
                where owner= ?
                OR gdlink_id IN 
                    (
                    select gdlink_id from linkPermission 
                        where   
                                (
                                user_email= ?
                                OR role_name=\'Everyone\' 
                                OR role_name=  ? 
                                )
                            AND can_read=1
                    
                        AND category IN 
                            (
                            select DISTINCT category from categoryPermission 
                                where can_read_category=1 
                                AND 
                                    (
                                    role_name=\'Everyone\' 
                                    OR role_name=? 
                                    OR user_email=?
                                    )   
                            )
                    )

                OR "Academic Officer"=?    
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($email, $email, $role_name,$role_name,$email,$role_name)
        or die 'execution failed: ' . $dbh->errstr();

    my $row = $sth->fetchrow_hashref;
    return $row->{'COUNT(*)'};
}

sub getALLlinkIdRead {
    my ($dbh,$session_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('
            SELECT gdlink_id from gdlinks 
                where owner= ?
                OR gdlink_id IN 
                    (
                    select gdlink_id from linkPermission 
                        where   
                                (
                                user_email= ?
                                OR role_name=\'Everyone\' 
                                OR role_name=  ? 
                                )
                            AND can_read=1
                            
                    
                        AND category IN 
                            (
                            select DISTINCT category from categoryPermission 
                                where can_read_category=1 
                                AND 
                                    (
                                    role_name=\'Everyone\' 
                                    OR role_name=? 
                                    OR user_email=?
                                    )   
                            )
                    )

                OR "Academic Officer"=?    
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($email, $email, $role_name,$role_name,$email,$role_name)
        or die 'execution failed: ' . $dbh->errstr();

    my @result;
    while (my @row = $sth->fetchrow_array) {
        push @result, \@row;  
    }
    my @arr2d = map { @$_ } @result;
    return \@arr2d;
}

sub getALLlinkIdDelete {
    my ($dbh,$session_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('
            SELECT gdlink_id from gdlinks 
                where owner= ?
                OR gdlink_id IN 
                    (
                    select gdlink_id from linkPermission 
                        where   
                                (
                                user_email= ?
                                OR role_name=\'Everyone\' 
                                OR role_name=  ? 
                                )
                            AND can_read=1
                            AND can_delete=1
                        AND category IN 
                            (
                            select DISTINCT category from categoryPermission 
                                where can_read_category=1 
                                AND 
                                    (
                                    role_name=\'Everyone\' 
                                    OR role_name=? 
                                    OR user_email=?
                                    )   
                            )
                    )

                OR "Academic Officer"=?    
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($email, $email, $role_name,$role_name,$email,$role_name)
        or die 'execution failed: ' . $dbh->errstr();

    my @result;
    while (my @row = $sth->fetchrow_array) {
        push @result, \@row;  
    }
    my @arr2d = map { @$_ } @result;
    return \@arr2d;
}

sub getALLlinkIdUpdate {
    my ($dbh,$session_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('
            SELECT gdlink_id from gdlinks 
                where owner= ?
                OR gdlink_id IN 
                    (
                    select gdlink_id from linkPermission 
                        where   
                                (
                                user_email= ?
                                OR role_name=\'Everyone\' 
                                OR role_name=  ? 
                                )
                            AND can_read=1
                            AND can_update=1
                        AND category IN 
                            (
                            select DISTINCT category from categoryPermission 
                                where can_read_category=1 
                                AND 
                                    (
                                    role_name=\'Everyone\' 
                                    OR role_name=? 
                                    OR user_email=?
                                    )   
                            )
                    )

                OR "Academic Officer"=?    
    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($email, $email, $role_name,$role_name,$email,$role_name)
        or die 'execution failed: ' . $dbh->errstr();

    my @result;
    while (my @row = $sth->fetchrow_array) {
        push @result, \@row;  
    }
    my @arr2d = map { @$_ } @result;
    return \@arr2d;
}

sub getALLlinkCreateWhere {
    my ($dbh,$session_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my $sth = $dbh->prepare('
            select DISTINCT category,semester_id from categoryPermission 
                where ((can_read_category=1 AND can_create_links=1) AND 
                            (user_email= ?  
                            OR role_name=\'Everyone\' or 
                            role_name= ? ) 
                            )
                OR \'Academic Officer\' = ? ;

    ')
        or die 'prepare statement failed: ' . $dbh->errstr();
    $sth->execute($email, $role_name,$role_name)
        or die 'execution failed: ' . $dbh->errstr();

    my @result;
    while (my $row = $sth->fetchrow_hashref) {
        push @result, $row->{category}, $row->{semester_id};  # Store values directly
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


sub DeleteLink{
    my ($dbh,$session_id, $semester_id,$category_name,$gdlink_id) = @_;
    my $role_name=Authorization::getRoleName($dbh, $session_id);
    my $email=Authorization::getEmail($dbh, $session_id);
    my @canDeleteId=Link::getALLlinkIdDelete($dbh, $session_id);

    my $found = 0;
    my @arr2d = map { @$_ } @canDeleteId;
    my @deleteArrayID = map { @$_ } @arr2d;
    $logger->info(Dumper(\@deleteArrayID)) ;
    
    if (!$found) {
        return { message => "YOU DO NOT HAVE PERMISSION TO DELETE gdlink_id $gdlink_id OR IT DOESNT EXIST" };
    } 

    my $sth_insert = $dbh->prepare('DELETE FROM gdlinks where gdlink_id = ?') 
                or die 'prepare statement failed: ' . $dbh->errstr();
    $result=$sth_insert->execute($gdlink_id) 
                or die 'prepare statement failed: ' . $dbh->errstr();
    if ($result) {
        return { message => "gdlink_id $gdlink_id in $category_name, $semester_id deleted successfully" };
    } else {
        return { error => "Failed to delete category in gdlink_id $gdlink_id $category_name, $semester_id" };
    }

}
1;
