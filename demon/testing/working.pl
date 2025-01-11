use Mojolicious::Lite -signatures;
use DBI;
use LWP::UserAgent;
use URI::Escape;

require("./User.pl");
require("./Link.pl");
require("./Semester.pl");
require("./Categories.pl");
require("./Authorization.pl");
require("./CategoryPermission.pl");

use Log::Log4perl;

# Initialize Log4perl with a configuration
Log::Log4perl->init(\ q(
    log4perl.rootLogger              = DEBUG, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.layout  = Log::Log4perl::Layout::SimpleLayout
));
my $logger = Log::Log4perl->get_logger();

# Global CORS headers
hook after_dispatch => sub ($c) {
     # Set CORS headers
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, PUT, DELETE');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
};


# Handle preflight OPTIONS request
options '*' => sub ($c) {
    $c->res->code(204);  # No Content
    $c->render(text => '');  # Empty response for OPTIONS request
};
# Connect to the database.
my $database = 'testing';
my $user     = 'adj2425';
my $pass     = 'adj2425';
my $dbh      = DBI->connect(
                "DBI:MariaDB:database=$database;host=localhost",
                $user, $pass,
                { RaiseError => 1, PrintError => 0 }
                );

get '/' => { text => 'GD Links AJAX/JSON Service' };

# http://localhost/getUserLogin
# request body =>
#       username : ??  
#       password : ?? 
post '/getUserLogin' => sub ($c) {
    my $payload = $c->req->json;
    my $username = $payload->{username};
    my $password = $payload->{password};
    my $result = User::callAuthAPI($dbh,$username, $password);

    if ($result->{success} == 1) {
        my $result = User::userToDB($dbh,$result);
    } else {
    }
    $c->render(json => $result);
};


# http://localhost/getSemester
get '/getSemester' => sub ($c) {
    my $result  = Semester::getSemester($dbh);
    $c->render(json => $result);
};

# http://localhost/getAllCategoriesWithinSemesterCount
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1

post '/getAllCategoriesWithinSemesterCount' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $semester_id = $payload->{semester_id};
    my $result  = Semester::getAllCategoriesWithinSemesterCount($dbh,$session_id,$semester_id);
    $c->render(json=>$result);
};

# http://localhost/getViewableCategoriesWithinSemesterCount
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1
post '/getViewableCategoriesWithinSemesterCount' => sub ($c) {
    my $payload = $c->req->json;
    my $semester_id = $payload->{semester_id};
    my $session_id = $payload->{session_id};
    my $result  = Semester::getViewableCategoriesWithinSemesterCount($dbh,$session_id,$semester_id);
    $c->render(json=>$result);
};

# http://localhost/createSemester
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1
post '/createSemester' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $result = Semester::CreateSemester($dbh, $semester_id);
    $c->render(json => $result);
};

# http://localhost/deleteSemester
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1  
post '/deleteSemester' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $result = Semester::DeleteSemester($dbh, $semester_id);
    $c->render(json => $result);
};

# http://localhost/updateSemester
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1   
#       new_semester_id : ?? i.e 2024/2025-1
post '/updateSemester' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $new_semester_id = $payload->{new_semester_id};
    my $result = Semester::UpdateSemester($dbh, $semester_id,$new_semester_id);
    $c->render(json => $result);
};


# http://localhost/getCategory
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
post '/getCategory' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $categoryPermission = CategoryPermission::getCategoryPermissionRead($dbh,$session_id, $semester_id);
    $c->render(json => { categoriesPermission => $categoryPermission });
};

# http://localhost/getAllLinksWithinCategoryCount
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1
#       category_name : ??

post '/getAllLinksWithinCategoryCount' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $semester_id = $payload->{semester_id};
    my $category_name = $payload->{category_name};
    my $result  = Categories::getAllLinksWithinCategoryCount($dbh,$session_id,$semester_id,$category_name);
    $c->render(json=>$result);
};

# http://localhost/getViewableLinksWithinCategoryCount
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? i.e 2024/2025-1
#       category_name : ??
post '/getViewableLinksWithinCategoryCount' => sub ($c) {
    my $payload = $c->req->json;
    my $semester_id = $payload->{semester_id};
    my $session_id = $payload->{session_id};
    my $category_name = $payload->{category_name};
    my $result  = Categories::getViewableLinksWithinCategoryCount($dbh,$session_id,$semester_id,$category_name);
    $c->render(json=>$result);
};


# http://localhost/createCategory
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage
#       category_name : ??
post '/createCategory' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $category = $payload->{category_name};
    my $result = Categories::CreateCategory($dbh, $semester_id,$category);
    $c->render(json => $result);
};

# http://localhost/deleteCategory
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage
#       category_name : ??
post '/deleteCategory' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $category = $payload->{category_name};
    my $result = Categories::DeleteCategory($dbh, $semester_id,$category);
    $c->render(json => $result);
};

# http://localhost/updateCategory
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? ======= get from localStorage
#       category_name : ??
#       new_category_name : ?? i.e 2024/2025-1
post '/updateCategory' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $category = $payload->{category_name};
    my $new_category_name = $payload->{new_category_name};
    my $result = Categories::UpdateCategory($dbh, $semester_id,$category,$new_category_name);
    $c->render(json => $result);
};


#  http://localhost/getLink             CAN VIEW PERMISSIBLE LINKS ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
#        category_name : ??  ======= get from localStorage
post '/getLink' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $linkVisibile = Link::getLink($dbh,$session_id, $semester_id,$category_name);
    $c->render(json => { linkViewable => $linkVisibile });
};

#  http://localhost/getAllLink             CAN VIEW PERMISSIBLE LINKS ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  

post '/getAllLink' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $linkVisibile = Link::getALLlink($dbh,$session_id);
    $c->render(json => { allLinks => $linkVisibile });
};

#  http://localhost/getAllLinkCount             CAN VIEW PERMISSIBLE LINKS ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
post '/getAllLinkCount' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $linkVisibile = Link::getALLlinkCount($dbh,$session_id);
    $c->render(json => { linkCount => $linkVisibile });
};


#  http://localhost/getALLlinkIdRead            CAN VIEW PERMISSIBLE LINKS ID ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
post '/getALLlinkIdRead' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $linkVisibile = Link::getALLlinkIdRead($dbh,$session_id);
    $c->render(json => { readbleLinkId => $linkVisibile });
};


#  http://localhost/getALLlinkIdDelete             CAN VIEW DELETEABLE LINKS ID ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
post '/getALLlinkIdDelete' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $linkVisibile = Link::getALLlinkIdDelete($dbh,$session_id);
    $c->render(json => { deleteableLinkId => $linkVisibile });
};

#  http://localhost/getALLlinkIdUpdate             CAN VIEW UPDATABLE LINKS ID ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
post '/getALLlinkIdUpdate' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $linkVisibile = Link::getALLlinkIdUpdate($dbh,$session_id);
    $c->render(json => { updateableLinkId => $linkVisibile });
};

#  http://localhost/getALLlinkCreateWhere             CAN VIEW UPDATABLE LINKS ID ONLY
#  request body =>
#        session_id : ??     ======= get from localStorage  
post '/getALLlinkCreateWhere' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $linkVisibile = Link::getALLlinkCreateWhere($dbh,$session_id);
    $c->render(json => { createAbleLinkWhere => $linkVisibile });
};




#  http://localhost/createLink         ONLY FOR ACADEMIC OFFICER & PEOPLE WITH CREATE PERM WITHIN CATEGORY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
#        category_name : ??  ======= get from localStorage
#        ref_name : ??       ======= get from fill form
#        desc : ??           ======= get from fill form
#        link : ??           ======= get from fill form
post '/createLink' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $ref_name   = $payload->{ref_name};
    my $desc   = $payload->{desc};
    my $link   = $payload->{link};
    my $result = Link::CreateLink($dbh,$session_id, $semester_id,$category_name,$ref_name,$desc,$link);
    $c->render(json => { result => $result });
};


#  http://localhost/deleteLink         ONLY FOR ACADEMIC OFFICER & PEOPLE WITH CREATE PERM WITHIN CATEGORY
#  request body =>
#        session_id : ??     ======= get from localStorage
#        semester_id : ??    ======= get from localStorage  
#        category_name : ??  ======= get from localStorage
#        gdlink_id : ????    ======= get when u click the delete button
post '/deleteLink' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $gdlink_id   = $payload->{gdlink_id};
    my $result = Link::DeleteLink($dbh,$session_id, $semester_id,$category_name,$gdlink_id);
    $c->render(json => { result => $result });
};


#  http://localhost/updateLink         ONLY FOR ACADEMIC OFFICER & PEOPLE WITH CREATE PERM WITHIN CATEGORY
#  request body =>
#        session_id : ??    ======= get from localStorage
#        semester_id : ??   ======= get from localStorage  
#        category_name : ?? ======= get from localStorage
#        new_ref_name : ??  ======= get from form
#        new_desc : ??      ======= get from form
#        new_link : ??      ======= get from form
#        gdlink_id : ????   ======= get when u click the delete button
post '/updateLink' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $new_ref_name   = $payload->{new_ref_name};
    my $new_desc   = $payload->{new_desc};
    my $new_link   = $payload->{new_link};
    my $gdlink_id   = $payload->{gdlink_id};
    my $result = Link::UpdateLink($dbh,$session_id, $semester_id,$category_name,$new_ref_name,$new_desc,$new_link,$gdlink_id);
    $c->render(json => { result => $result });
};





# http://localhost/getCategoryPermission
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
#       category_name : ??    ======= get from click       
post '/getCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }

    my $categoryPermission = CategoryPermission::getCategoryPermission($dbh,$session_id, $semester_id,$category_name);
    $c->render(json => { categoriesPermission => $categoryPermission });
};


# http://localhost/createCategoryPermission
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
#       category_name : ??    ======= get from click     
#       insert_user_role : ????    ======= get from fill form     
#       insert_user_email : ????   ======= get from fill form     
#       can_read_category : ????   ======= get from fill form,,, boolean (0/1 true/false)
#       can_create_links : ????   ======= get from fill form,,, boolean (0/1 true/false)
post '/createCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $insert_user_role     = $payload->{insert_user_role};
    my $insert_user_email    = $payload->{insert_user_email};
    my $can_read_category    = $payload->{can_read_category};
    my $can_create_links    = $payload->{can_create_links};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    

    if ($auth_result->{error}) {
        $c->render(json => {result =>$auth_result});
        return;
    }
    
    if ($insert_user_email && $insert_user_role) {
        $c->render(json => { result => "Only one of insert_user_email or insert_user_role can be updated at a time" });
        return;
    }

    my $result;
    if($insert_user_role){
        $result = CategoryPermission::CreateCategoryPermissionRole($dbh,$session_id, $semester_id,$category_name,$insert_user_role,$can_read_category,$can_create_links);
    }
    if($insert_user_email){
        $result = CategoryPermission::CreateCategoryPermissionUser($dbh,$session_id, $semester_id,$category_name,$insert_user_email,$can_read_category,$can_create_links);
    }
    

    $c->render(json => { result => $result });
};




# http://localhost/updateCategoryPermission
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
#       category_name : ??    ======= get from click     
#       selected_user_role : ????    ======= get from click
#       selected_user_email : ????   ======= get from click
#       can_read_category : ????   ======= get from fill form,,, boolean (0/1 true/false)
#       can_create_links : ????   ======= get from fill form,,, boolean (0/1 true/false)
post '/updateCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $user_role     = $payload->{selected_user_role};
    my $user_email    = $payload->{selected_user_email};
    my $can_read_category    = $payload->{can_read_category};
    my $can_create_links    = $payload->{can_create_links};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    

    if ($auth_result->{error}) {
        $c->render(json => {result =>$auth_result});
        return;
    }
    
    if ($user_email && $user_role) {
        $c->render(json => { result => "Only one of user_email or user_role can be updated at a time" });
        return;
    }

    my $result;
    if($user_role){
        $result = CategoryPermission::UpdateCategoryPermissionRole($dbh,$session_id, $semester_id,$category_name,$user_role,$can_read_category,$can_create_links);
    }
    if($user_email){
        $result = CategoryPermission::UpdateCategoryPermissionUser($dbh,$session_id, $semester_id,$category_name,$user_email,$can_read_category,$can_create_links);
    }
    

    $c->render(json => { result => $result });
};



# http://localhost/deleteCategoryPermission
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
#       category_name : ??    ======= get from click     
#       selected_user_role : ????    ======= get from click
#       selected_user_email : ????   ======= get from click
post '/deleteCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $category_name   = $payload->{category_name};
    my $user_role     = $payload->{selected_user_role};
    my $user_email    = $payload->{selected_user_email};

    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    

    if ($auth_result->{error}) {
        $c->render(json => {result =>$auth_result});
        return;
    }
    
    if ($user_email && $user_role) {
        $c->render(json => { result => "Only one of user_email or user_role can be updated at a time" });
        return;
    }

    my $result;
    if($user_role){
        $result = CategoryPermission::DeleteCategoryPermissionRole($dbh,$session_id, $semester_id,$category_name,$user_role);
    }
    if($user_email){
        $result = CategoryPermission::DeleteCategoryPermissionUser($dbh,$session_id, $semester_id,$category_name,$user_email);
    }
    

    $c->render(json => { result => $result });
};








app->start;
