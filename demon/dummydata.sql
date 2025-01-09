INSERT INTO sessionSemester (semester_id) VALUES ('2024/2025-1'), ('2024/2025-2');

INSERT INTO Categories (category, semester_id) VALUES 
('PSM 1', '2024/2025-1'),
('Course Files', '2024/2025-1'),
('Training', '2024/2025-1'),
('Workshop', '2024/2025-1'),
('PSM 2', '2024/2025-2'),
('Course Materials', '2024/2025-2'),
('Seminars', '2024/2025-2'),
('Internship', '2024/2025-2'),
('Conferences', '2024/2025-2'),
('Lectures', '2024/2025-2');

INSERT INTO roles (role_name) VALUES ('Admin'), ('Teacher'), ('Student');

INSERT INTO user (full_name, login_name, email, role_id, session_id) VALUES
('Alice Johnson', 'alice', 'alice@example.com', 1, '313'),
('Bob Smith', 'bob', 'bob@example.com', 2, 'qw'),
('Charlie Brown', 'charlie', 'charlie@example.com', 3, 'wassup');

INSERT INTO gdlinks (category, sessem, ref_name, description, owner, link) VALUES
('PSM 1', '2024/2025-1', 'Thesis Guidelines', 'Thesis writing instructions', 'alice@example.com', 'http://example.com/thesis'),
('Course Files', '2024/2025-1', 'Lecture Notes', 'All lecture notes', 'bob@example.com', 'http://example.com/notes'),
('Training', '2024/2025-1', 'Cybersecurity Training', 'Basic cybersecurity training', 'charlie@example.com', 'http://example.com/cybersecurity'),
('Workshop', '2024/2025-1', 'AI Workshop', 'Introduction to AI workshop', 'alice@example.com', 'http://example.com/aiworkshop'),
('PSM 2', '2024/2025-2', 'Final Reports', 'Examples of final reports', 'bob@example.com', 'http://example.com/reports'),
('Course Materials', '2024/2025-2', 'Assignment Templates', 'Templates for assignments', 'charlie@example.com', 'http://example.com/templates'),
('Internship', '2024/2025-2', 'Internship Reports', 'Previous internship reports', 'bob@example.com', 'http://example.com/internship'),
('Lectures', '2024/2025-2', 'Recorded Lectures', 'Video lectures', 'alice@example.com', 'http://example.com/videos');
