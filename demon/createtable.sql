CREATE TABLE sessionSemester (
    semester_id VARCHAR(11) PRIMARY KEY
);

CREATE TABLE Categories(
    category VARCHAR(100),
    semester_id VARCHAR(11) not null,
    PRIMARY KEY (category, semester_id),
    FOREIGN KEY (semester_id) REFERENCES sessionSemester(semester_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE roles (
    role_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE user (
    user_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    login_name VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    role_id INT NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    successful_logins INT DEFAULT 0,
    last_login TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);


create table gdlinks (
    gdlink_id int not null auto_increment, 
    category varchar(100), 
    sessem varchar(15), 
    ref_name varchar(50), 
    description varchar(255), 
    owner varchar(255) not null, 
    link varchar(255), 
    primary key(gdlink_id),
    FOREIGN KEY (sessem) REFERENCES sessionSemester(semester_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (category) REFERENCES Categories(category) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (owner) REFERENCES user(email)
);

CREATE TABLE categoryPermission (
    category_perm_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    semester_id VARCHAR(11) NOT NULL,
    user_email VARCHAR(255),
    role_name VARCHAR(255),
    can_read BOOLEAN DEFAULT FALSE,
    can_update BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    can_create BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_email) REFERENCES user(email),
    FOREIGN KEY (role_name) REFERENCES roles(role_name),
    FOREIGN KEY (semester_id) REFERENCES sessionSemester(semester_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (category) REFERENCES Categories(category) ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (user_email IS NULL OR role_name IS NULL)
);


CREATE TABLE linkPermission (
    link_perm_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    semester_id VARCHAR(11) NOT NULL,
    gdlink_id int NOT NULL,
    user_email VARCHAR(255),
    role_name VARCHAR(255),
    can_read BOOLEAN DEFAULT FALSE,
    can_update BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_email) REFERENCES user(email),
    FOREIGN KEY (role_name) REFERENCES roles(role_name),
    FOREIGN KEY (semester_id) REFERENCES sessionSemester(semester_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (category) REFERENCES Categories(category) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (gdlink_id) REFERENCES gdlinks(gdlink_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (user_email IS NULL OR role_name IS NULL)
);