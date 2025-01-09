use Mojolicious::Lite -signatures;
use DBI;

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

hook after_dispatch => sub ($c) {
    # Allow CORS headers for all methods
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type');
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

# http://localhost/getSemester
get '/getSemester' => sub ($c) {
    my $result  = Semester::getSemester($dbh);
    $c->render(json => $result);
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


# http://localhost/getCategory?semester_id=2024/2025-1
# param => 
#       semester_id         ======= get from localStorage
get '/getCategory' => sub ($c) {
    my $semester_id   = $c->param('semester_id');
    my $categories = Categories::getCategory($dbh, $semester_id);
    $c->render(json => { semester_id => $semester_id, categories => $categories });
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


# http://localhost/getCategoryPermissionAll
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
post '/getCategoryPermissionAll' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $categoryPermission = CategoryPermission::getCategoryPermission($dbh,$session_id, $semester_id);
    $c->render(json => { categoriesPermission => $categoryPermission });
};


# http://localhost/getCategoryPermission CRUD
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage       
post '/getCategoryPermissionRead' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $categoryPermission = CategoryPermission::getCategoryPermissionRead($dbh,$session_id, $semester_id);
    $c->render(json => { categoriesPermission => $categoryPermission });
};

post '/getCategoryPermissionDelete' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $categoryPermission = CategoryPermission::getCategoryPermissionDelete($dbh,$session_id, $semester_id);
    $c->render(json => { categoriesPermission => $categoryPermission });
};

post '/getCategoryPermissionCreate' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $categoryPermission = CategoryPermission::getCategoryPermissionCreate($dbh,$session_id, $semester_id);
    $c->render(json => { categoriesPermission => $categoryPermission });
};

post '/getCategoryPermissionUpdate' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id   = $payload->{session_id};
    my $semester_id   = $payload->{semester_id};
    my $categoryPermission = CategoryPermission::getCategoryPermissionUpdate($dbh,$session_id, $semester_id);
    $c->render(json => { categoriesPermission => $categoryPermission });
};



# http://localhost/createCategoryPermission
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage
#       category : ??
#       can_create : ??
#       can_read : ??
#       can_update : ??
#       can_delete : ??
#       role_name  : ??
#       user_email : ??
post '/createCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $can_create = $payload->{can_create};
    my $can_read = $payload->{can_read};
    my $can_update = $payload->{can_update};
    my $can_delete = $payload->{can_delete};
    my $user_email = $payload->{user_email};
    my $role_name = $payload->{role_name};
    my $result = CategoryPermission::CreateCategoryPermission($dbh, $semester_id,$categoryPermission);
    $c->render(json => $result);
};

# http://localhost/deleteCategoryPermission
# request body =>
#       session_id : ??     ======= get from localStorage
#       semester_id : ??    ======= get from localStorage
#       categoryPermission_name : ??
post '/deleteCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $categoryPermission = $payload->{categoryPermission_name};
    my $result = CategoryPermission::DeleteCategoryPermission($dbh, $semester_id,$categoryPermission);
    $c->render(json => $result);
};

# http://localhost/updateCategoryPermission
# request body =>
#       session_id : ??  ======= get from localStorage
#       semester_id : ?? ======= get from localStorage
#       categoryPermission_name : ??
#       new_categoryPermission_name : ?? i.e 2024/2025-1
post '/updateCategoryPermission' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{semester_id};
    my $categoryPermission = $payload->{categoryPermission_name};
    my $new_categoryPermission_name = $payload->{new_categoryPermission_name};
    my $result = CategoryPermission::UpdateCategoryPermission($dbh, $semester_id,$categoryPermission,$new_categoryPermission_name);
    $c->render(json => $result);
};

app->start;
