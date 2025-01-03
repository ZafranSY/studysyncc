use Mojolicious::Lite -signatures;
use DBI;
use JSON::XS;

require("./CRUD.pl");
hook after_dispatch => sub ($c) {
    # Allow CORS headers for all methods
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type');


};
# Connect to the database.
my $database = 'adj2425';
my $user = 'adj2425';
my $pass = 'adj2425';
my $dbh = DBI->connect("DBI:MariaDB:database=$database;host=localhost", $user, $pass, { RaiseError => 1, PrintError => 0 });


#my $json = decode_json('{"category":"Research"}');

get '/' => {text => 'GD Links AJAX/JSON Service'};

### http://localhost:3000/create?jsonStr={"category":"Internship", "ref_name":"Evaluation Form", "sessem":"2023/2024-1", "description":"Borang Penilaian Latihan Industri oleh Penyelia Fakulti", "owner":"norsham@utm.my", "link":"https://forms.gle/"}
### http://localhost:3000/create?jsonStr={"table":"gdlinks", "data":{"category":"Internship", "ref_name":"Visit Form", "sessem":"2023/2024-1", "description":"Borang lawatan latihan praktik", "owner":"norsham@utm.my", "link":"https://forms.gle/"}}
get '/create' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');

    my $json = decode_json($jsonStr);
    my $result = CRUD::createJSON($dbh, $json);

    #$c->render(text=>"create $jsonStr");
    print $result;
    $c->render(json=>$result);
};


### http://localhost:3000/read?jsonStr={"table":"gdlinks"}
get '/read' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');

    my $json = decode_json($jsonStr);
    my $result = CRUD::readJSON($dbh, $json);
    $c->render(json=>$result);
};

### http://localhost:3000/create?jsonStr={"table":"gdlinks", "id":13, "data":{"category":"Internship", "ref_name":"Visit Form", "sessem":"2023/2024-1", "description":"Borang lawatan latihan praktik", "owner":"mrazak@utm.my", "link":"https://forms.gle/"}}
get '/update' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');

    my $json = decode_json($jsonStr);
    my $result = CRUD::updateJSON($dbh, $json);
    $c->render(json=>$result);
};


### http://localhost:3000/delete?jsonStr={"table":"gdlinks", "id":15}
get '/delete' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');

    my $json = decode_json($jsonStr);
    my $result = CRUD::deleteJSON($dbh, $json);

    $c->render(json=>$result);
};

### http://localhost:3000/getCategory
get '/getCategory' => sub ($c) {
    my $categories = CRUD::getCategory($dbh);
    $c->render(json => $categories);
};

### http://localhost:3000/getSemester
get '/getSemester' => sub ($c) {
    my $semesters = CRUD::getSemester($dbh);
    $c->render(json => $semesters);
};
### Example URL: http://localhost:3000/getBySemesterAndCategory?semester=2023/2024-1&category=Internship
get '/getBySemesterAndCategory' => sub ($c) {
    my $semester = $c->param('semester');
    my $category = $c->param('category');
    my $results = CRUD::getBySemesterAndCategory($dbh, $semester, $category);
    $c->render(json => $results);
};
get '/getUpload' => sub ($c)
{
    my $link = $c->param('link');
    my $message = $c->param('message');  # Get the user's message

    if ($link =~ m/^https?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/) {
        my $result = CRUD::addLinkWithMessage($dbh, $link, $message);  
        $c->render(json => { message => "Link and message shared successfully", link => $link, user_message => $message });
    } else {

        $c->render(json => { error => "Invalid URL format" });
    }
};


### Example URL: http://localhost:3000/getCategoryBySemester?semester=2023/2024-1
get '/getCategoryBySemester' => sub ($c) {
    my $semester = $c->param('semester');
    my $categories = CRUD::getCategoryBySemester($dbh, $semester);
    $c->render(json => $categories);
};

### Example URL: http://localhost:3000/getLinks
get '/getRefnameByCategory' => sub ($c) {
    my $category = $c->param('category');  # Get the 'category' parameter from the URL
    my $result = CRUD::getRefnameByCategory($dbh, $category);
    $c->render(json => $result);
};

### Example URL: http://localhost:3000/getLinks
get '/getlinkbyRefname' => sub ($c) {
     my $ref_name = $c->param('link_refName');
    my $links = CRUD::getlinkbyRefname($dbh,$ref_name);

    # Render the links as JSON
    $c->render(json => $links);
};


options '/usertodb' => sub ($c) {
    $c->res->code(200); 
    $c->render(text => '');
};

post '/usertodb' => sub ($c) {
    my $jsonStr = $c->req->body;
    my $json = decode_json($jsonStr);
    my $result = CRUD::createUser($dbh, $json);
    $c->render(json => $result);
};


app->start;