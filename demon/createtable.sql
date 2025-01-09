CREATE TABLE sessionSemester (
    semester_id VARCHAR(11) PRIMARY KEY
);

CREATE TABLE Categories(
    category VARCHAR(100),
    semester_id VARCHAR(11) not null,
    PRIMARY KEY (category, semester_id),
    FOREIGN KEY (semester_id) REFERENCES sessionSemester(semester_id)
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
    FOREIGN KEY (sessem) REFERENCES sessionSemester(semester_id),
    FOREIGN KEY (category) REFERENCES Categories(category),
    FOREIGN KEY (owner) REFERENCES user(email)
);

CREATE TABLE linkVisibility (
    link_visibility_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    gdlink_id INT NOT NULL,
    user_id INT,
    role_id INT,
    FOREIGN KEY (gdlink_id) REFERENCES gdlinks(gdlink_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);