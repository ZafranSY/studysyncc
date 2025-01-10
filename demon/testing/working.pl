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


#  http://localhost/createLink         ONLY FOR ACADEMIC OFFICER & PEOPLE WITH CREATE PERM WITHIN CATEGORY#  request body =>
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






app->start;
