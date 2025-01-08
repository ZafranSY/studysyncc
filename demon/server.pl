use Mojolicious::Lite -signatures;
use DBI;
use JSON::XS;
use Data::Dumper;
print Dumper($json);

require("./CRUD.pl");

hook after_dispatch => sub ($c) {
    # Allow CORS headers for all methods
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type');
};

# Connect to the database.
my $database = 'adj2425';
my $user     = 'adj2425';
my $pass     = 'adj2425';
my $dbh      = DBI->connect(
    "DBI:MariaDB:database=$database;host=localhost",
    $user, $pass,
    { RaiseError => 1, PrintError => 0 }
);

get '/' => { text => 'GD Links AJAX/JSON Service' };

### Add the /save_coursefile route
post '/save_coursefile' => sub ($c) {
    my $refName     = $c->param('refName');
    my $description = $c->param('description');
    my $url         = $c->param('url');
    my $owner       = $c->param('owner');

    # SQL query to insert into link_details
    my $sth = $dbh->prepare(
        "INSERT INTO link_details (link_refName, link_description, link_url, owner, link_posted)
         VALUES (?, ?, ?, ?, NOW())"
    );

    eval {
        $sth->execute($refName, $description, $url, $owner);
        $c->render(json => { message => 'Data saved successfully' });
    } or do {
        my $error = $@ || 'Unknown error';
        $c->render(json => { error => $error }, status => 500);
    };
};

# Other routes
get '/create' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');
    my $json    = decode_json($jsonStr);
    my $result  = CRUD::createJSON($dbh, $json);
    $c->render(json => $result);
};

get '/read' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');
    my $json    = decode_json($jsonStr);
    my $result  = CRUD::readJSON($dbh, $json);
    $c->render(json => $result);
};

get '/update' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');
    my $json    = decode_json($jsonStr);
    my $result  = CRUD::updateJSON($dbh, $json);
    $c->render(json => $result);
};

get '/delete' => sub ($c) {
    my $jsonStr = $c->param('jsonStr');
    my $json    = decode_json($jsonStr);
    my $result  = CRUD::deleteJSON($dbh, $json);
    $c->render(json => $result);
};

get '/getCategory' => sub ($c) {
    my $categories = CRUD::getCategory($dbh);
    $c->render(json => $categories);
};

get '/getSemester' => sub ($c) {
    my $semesters = CRUD::getSemester($dbh);
    $c->render(json => $semesters);
};

get '/getBySemesterAndCategory' => sub ($c) {
    my $semester = $c->param('semester');
    my $category = $c->param('category');
    my $results  = CRUD::getBySemesterAndCategory($dbh, $semester, $category);
    $c->render(json => $results);
};

get '/getUpload' => sub ($c) {
    my $link    = $c->param('link');
    my $message = $c->param('message');    # Get the user's message

    if ($link =~ m/^https?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/) {
        my $result = CRUD::addLinkWithMessage($dbh, $link, $message);
        $c->render(
            json => {
                message      => "Link and message shared successfully",
                link         => $link,
                user_message => $message
            }
        );
    }
    else {
        $c->render(json => { error => "Invalid URL format" });
    }
};

get '/getCategoryBySemester' => sub ($c) {
    my $semester   = $c->param('semester');
    my $categories = CRUD::getCategoryBySemester($dbh, $semester);
    $c->render(json => $categories);
};

get '/getRefnameByCategory' => sub ($c) {
    my $category = $c->param('category');    # Get the 'category' parameter from the URL
    my $result   = CRUD::getRefnameByCategory($dbh, $category);
    $c->render(json => $result);
};

get '/getlinkbyRefname' => sub ($c) {
    my $ref_name = $c->param('link_refName');
    my $links    = CRUD::getlinkbyRefname($dbh, $ref_name);

    # Render the links as JSON
    $c->render(json => $links);
};

options '/usertodb' => sub ($c) {
    $c->res->code(200);
    $c->render(text => '');
};

post '/usertodb' => sub ($c) {
    my $jsonStr = $c->req->body;
    my $json    = decode_json($jsonStr);
    my $result  = CRUD::createUser($dbh, $json);
    $c->render(json => $result);
};

post '/create' => sub ($c) {
    my $json = $c->req->json;  # Get the JSON payload

    # Debugging: Print the received JSON payload to the terminal
    use Data::Dumper;
    print Dumper($json);

    # SQL query to insert data into the database
    my $sql = 'INSERT INTO link_details (link_refName, link_description, link_url, owner) VALUES (?, ?, ?, ?)';
    my $sth = $dbh->prepare($sql);

    # Execute the query with the received data
    $sth->execute(
        $json->{link_refName},
        $json->{link_description},
        $json->{link_url},
        $json->{owner},
    );

    # Get the last inserted ID
    my $id = $dbh->last_insert_id(undef, undef, 'link_details', 'id');

    # Respond with the created data and ID
    $c->render(json => { id => $id, %$json });
};
post '/save_coursefile' => sub ($c) {
    my $data = $c->req->json;

    # Validate required fields
    if (!$data->{refName} || !$data->{url} || !$data->{owner} || !$data->{sessem} || !$data->{category} || !$data->{courseFile}) {
        return $c->render(json => { error => 'Missing required fields' }, status => 400);
    }

    print "DEBUG: Received data: ", Dumper($data);

    my $result = CRUD::saveCourseFile($dbh, $data);

    if ($result->{success}) {
        $c->render(json => { message => $result->{message} });
    } else {
        $c->render(json => { error => $result->{error} }, status => 500);
    }
};


get '/getlink' => sub ($c) {
    my $sessem    = $c->param('sessem');
    my $category  = $c->param('category');
    my $courseFile_refName = $c->param('courseFile_refName');

    # Validate input parameters
    unless ($sessem && $category && $courseFile_refName) {
        return $c->render(json => { error => 'Missing required parameters' }, status => 400);
    }

    # Call the getlink subroutine
    my $filters = {
        sessem             => $sessem,
        category           => $category,
        courseFile_refName => $courseFile_refName,
    };

    my $links = getlink($dbh, $filters);

    # Render the results as JSON
    $c->render(json => $links);
};


get '/getAllLinks' => sub ($c) {
    my $links = getAllLinks($dbh);  # Call the new function to get all links
    $c->render(json => $links);
};

app->start;
