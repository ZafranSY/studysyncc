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
    canManageLinkPerm BOOLEAN DEFAULT FALSE,
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
-- ------------------------------------------
-- ACADEMIC OFFICER PERM CANNOT BE OVERRIDEN
-- ------------------------------------------
DELIMITER //
CREATE TRIGGER before_insert_link_permission_AcademicOfficerNoOverride
BEFORE INSERT ON linkPermission
FOR EACH ROW
BEGIN
    -- If the role is "Academic Officer", set all permissions to TRUE and prevent overriding
    IF NEW.role_name = 'Academic Officer' THEN
        SET NEW.can_read = TRUE;
        SET NEW.can_update = TRUE;
        SET NEW.can_delete = TRUE;
    ELSE
        -- If can_read is FALSE, set other permissions to FALSE
        IF NEW.can_read = FALSE THEN
            SET NEW.can_update = FALSE;
            SET NEW.can_delete = FALSE;
        END IF;
    END IF;
END //

CREATE TRIGGER before_update_link_permission_AcademicOfficerNoOverride
BEFORE UPDATE ON linkPermission
FOR EACH ROW
BEGIN
    -- If the role is "Academic Officer", prevent overriding and ensure all permissions are TRUE
    IF NEW.role_name = 'Academic Officer' THEN
        SET NEW.can_read = TRUE;
        SET NEW.can_update = TRUE;
        SET NEW.can_delete = TRUE;
    ELSE
        -- If can_read is FALSE, set other permissions to FALSE
        IF NEW.can_read = FALSE THEN
            SET NEW.can_update = FALSE;
            SET NEW.can_delete = FALSE;
        END IF;
    END IF;
END //


------------------------------------------
-- can_read FALSE,, ALL WILL BE FALSE
------------------------------------------


CREATE TRIGGER before_insert_category_permission_ReadFalseAllFalse
BEFORE INSERT ON categoryPermission
FOR EACH ROW
BEGIN
    IF NEW.can_read = FALSE THEN
        SET NEW.can_update = FALSE;
        SET NEW.can_delete = FALSE;
        SET NEW.can_create = FALSE;
        SET NEW.canManageLinkPerm = FALSE;
    END IF;
END //

CREATE TRIGGER before_update_category_permission_ReadFalseAllFalse
BEFORE UPDATE ON categoryPermission
FOR EACH ROW
BEGIN
    IF NEW.can_read = FALSE THEN
        SET NEW.can_update = FALSE;
        SET NEW.can_delete = FALSE;
        SET NEW.can_create = FALSE;
        SET NEW.canManageLinkPerm = FALSE;
    END IF;
END //


------------------------------------------
-- GDLINK OWNER PERM CANNOT BE OVERRIDEN
------------------------------------------



CREATE TRIGGER before_insert_link_permission_NoOverrideOwner
BEFORE INSERT ON linkPermission
FOR EACH ROW
BEGIN
    -- Check if the user_email is the owner of the gdlink_id
    DECLARE owner_email VARCHAR(255);
    SELECT owner INTO owner_email
    FROM gdlinks
    WHERE gdlink_id = NEW.gdlink_id;
    
    -- If the user is the owner of the gdlink_id, set all permissions to TRUE
    IF NEW.user_email = owner_email THEN
        SET NEW.can_read = TRUE;
        SET NEW.can_update = TRUE;
        SET NEW.can_delete = TRUE;
    ELSE
        -- If can_read is FALSE, set other permissions to FALSE
        IF NEW.can_read = FALSE THEN
            SET NEW.can_update = FALSE;
            SET NEW.can_delete = FALSE;
        END IF;
    END IF;
END //


------------------------------------------
-- No Delete Everyone on both perm table
------------------------------------------


CREATE TRIGGER before_delete_link_permission_NoDeleteEveryone
BEFORE DELETE ON linkPermission
FOR EACH ROW
BEGIN
    -- Check if the role being deleted is "Everyone"
    IF OLD.role_name = 'Everyone' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete the "Everyone" role';
    END IF;
END //



CREATE TRIGGER before_delete_category_permission_NoDeleteEveryone
BEFORE DELETE ON categoryPermission
FOR EACH ROW
BEGIN
    -- Check if the role being deleted is "Everyone"
    IF OLD.role_name = 'Everyone' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete the "Everyone" role';
    END IF;
END //


------------------------------------------
-- AUTO PERM FOR LINKS OWNER 
------------------------------------------


CREATE TRIGGER after_insert_gdlinks_grant_owner_permissions
AFTER INSERT ON gdlinks
FOR EACH ROW
BEGIN
    INSERT INTO linkPermission (category, semester_id, gdlink_id, user_email, role_name, can_read, can_update, can_delete)
    VALUES (NEW.category, NEW.sessem, NEW.gdlink_id, NEW.owner, NULL, TRUE, TRUE, TRUE);
END //



------------------------------------------
-- AUTO PERMS FOR CATEGORIES, FOR ACADEMIC OFFICER
------------------------------------------

-- Grant all permissions for the "Academic Officer" role in Categories
CREATE TRIGGER after_insert_categories_grant_academic_officer_permissions
AFTER INSERT ON Categories
FOR EACH ROW
BEGIN
    INSERT INTO categoryPermission (category, semester_id, user_email, role_name, can_read, can_update, can_delete, can_create, canManageLinkPerm)
    VALUES (NEW.category, NEW.semester_id, NULL, 'Academic Officer', TRUE, TRUE, TRUE, TRUE, TRUE);
END //


DELIMITER ;