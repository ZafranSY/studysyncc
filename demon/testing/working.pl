use Mojolicious::Lite -signatures;
use DBI;

require("./Semester.pl");
require("./Authorization.pl");

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

get '/getSemester' => sub ($c) {
    my $result  = Semester::getSemester($dbh);
    $c->render(json => $result);
};

post '/createSemester' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{'semester_id'};
    my $result = Semester::CreateSemester($dbh, $semester_id);
    $c->render(json => $result);
};


get '/getCategories' => sub ($c) {
    my $result  = Semester::getSemester($dbh);
    $c->render(json => $result);
};

post '/createCategories' => sub ($c) {
    my $payload = $c->req->json;
    my $session_id = $payload->{session_id};
    my $required_rolename = 'Academic Officer'; 
    my $auth_result = Authorization::check_session_role($dbh, $session_id, $required_rolename);
    
    if ($auth_result->{error}) {
        $c->render(json => $auth_result);
        return;
    }
    
    my $semester_id = $payload->{'semester_id'};
    my $result = Semester::CreateSemester($dbh, $semester_id);
    $c->render(json => $result);
};



app->start;
