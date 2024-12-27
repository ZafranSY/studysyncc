

CREATE TABLE link_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    link_refName VARCHAR(255) NOT NULL,
    link_description TEXT,
    link_posted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    link_id INT,
    link_url VARCHAR(255) NOT NULL,
    owner VARCHAR(100) NOT NULL,
    FOREIGN KEY (link_id) REFERENCES gdlinks(id_gdlink)
);


CREATE TABLE Semester (
    semester_id INT PRIMARY KEY,
    academic_year VARCHAR(20),
    semester_number INT,
    display_name VARCHAR(20),
    is_current BOOLEAN,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE user (
    user_id INT NOT NULL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    login_name VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    role VARCHAR(255),
    session_id VARCHAR(255) NOT NULL,
    successful_logins INT DEFAULT 0
    last_login DATETIME,
);