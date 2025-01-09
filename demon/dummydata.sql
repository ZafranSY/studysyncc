-- 1. Insert sessionSemester
INSERT INTO sessionSemester (semester_id)
VALUES 
    ('2024/2025-1'),
    ('2024/2025-2'),
    ('2023/2024-1'),
    ('2023/2024-2'),
    ('2022/2023-1'),
    ('2022/2023-2');

-- 2. Insert Categories
INSERT INTO Categories (category, semester_id)
VALUES
    ('PSM 1', '2024/2025-1'),
    ('Timetable', '2024/2025-2'),
    ('CourseFiles', '2023/2024-1'),
    ('Research', '2023/2024-2'),
    ('Course Coordination', '2024/2025-2'),
    ('Training', '2022/2023-1'),
    ('Workshop', '2022/2023-2');

-- 3. Insert roles
INSERT INTO roles (role_name)
VALUES
    ('Academic Officer'),
    ('Pensyarah'),
    ('Pelajar FSKSM');

-- 4. Insert some example users
INSERT INTO user (full_name, login_name, email, role_id, session_id)
VALUES 
    ('Rizam Ahmad', 'rizam', 'rizam@utm.my', 2, '2024/2025-1'),
    ('Ali Hassan', 'ali', 'ali@utm.my', 3, '2024/2025-2'),
    ('Siti Mariam', 'siti', 'siti@utm.my', 1, '2023/2024-1');

-- 5. Insert gdlinks
INSERT INTO gdlinks (category, sessem, ref_name, description, owner, link)
VALUES
    ('Course Coordination', '2023/2024-2', 'Web Technology course materials', 'WebTech course materials', 'rizam@utm.my', 'https://drive.google.com/drive/folders/???'),
    ('Research', '2024/2025-1', 'AI Research Papers', 'Research papers on AI', 'rizam@utm.my', 'https://drive.google.com/drive/folders/???'),
    ('Timetable', '2023/2024-1', 'Semester Timetable', 'Fall 2023 Semester Timetable', 'ali@utm.my', 'https://drive.google.com/drive/folders/???'),
    ('CourseFiles', '2022/2023-1', 'Database Systems Course Materials', 'Course materials for Database Systems', 'siti@utm.my', 'https://drive.google.com/drive/folders/???'),
    ('Workshop', '2022/2023-2', 'Workshop on Machine Learning', 'Machine Learning Workshop files', 'rizam@utm.my', 'https://drive.google.com/drive/folders/???');

-- 6. Insert linkVisibility
INSERT INTO linkVisibility (gdlink_id, user_id, role_id)
VALUES
    (1, 1, 2),  -- Web Technology course materials visible to Rizam with Pensyarah role
    (2, 2, 3),  -- AI Research Papers visible to Ali with Pelajar FSKSM role
    (3, 3, 1),  -- Semester Timetable visible to Siti with Academic Officer role
    (4, 2, 2),  -- Database Systems Course Materials visible to Ali with Pensyarah role
    (5, 1, 3);  -- Machine Learning Workshop visible to Rizam with Pelajar FSKSM role
