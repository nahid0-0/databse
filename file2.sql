-- User Table
CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(255),
    bio TEXT,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Server Table
CREATE TABLE Server (
    server_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_by INT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES User(user_id) ON DELETE SET NULL
);

-- Channel Table
CREATE TABLE Channel (
    channel_id INT AUTO_INCREMENT PRIMARY KEY,
    server_id INT,
    name VARCHAR(100) NOT NULL,
    channel_type ENUM('text', 'voice') NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (server_id) REFERENCES Server(server_id) ON DELETE CASCADE
);

-- Post Table
CREATE TABLE Post (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    channel_id INT,
    title VARCHAR(200),
    content TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES Channel(channel_id) ON DELETE CASCADE
);

-- Comment Table
CREATE TABLE Comment (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Reaction Table
CREATE TABLE Reaction (
    reaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    reaction_type ENUM('like', 'dislike', 'love', 'haha', 'sad', 'angry'),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Message Table
CREATE TABLE Message (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    channel_id INT,
    user_id INT,
    content TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (channel_id) REFERENCES Channel(channel_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Role Table
CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    server_id INT,
    role_name VARCHAR(100),
    permissions TEXT,
    FOREIGN KEY (server_id) REFERENCES Server(server_id) ON DELETE CASCADE
);

-- User_Roles Table
CREATE TABLE User_Roles (
    user_id INT,
    server_id INT,
    role_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (server_id) REFERENCES Server(server_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Role(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, server_id, role_id)
);

-- Group Table
CREATE TABLE `Group` (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    server_id INT,
    name VARCHAR(100),
    created_by INT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (server_id) REFERENCES Server(server_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES User(user_id) ON DELETE SET NULL
);

-- User_Groups Table
CREATE TABLE User_Groups (
    user_id INT,
    group_id INT,
    joined_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `Group`(group_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, group_id)
);

-- Notification Table
CREATE TABLE Notification (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    read_status BOOLEAN DEFAULT FALSE,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Tag Table
CREATE TABLE Tag (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL UNIQUE
);

-- Post_Tags Table
CREATE TABLE Post_Tags (
    post_id INT,
    tag_id INT,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

-- Blocked_Users Table
CREATE TABLE Blocked_Users (
    blocker_id INT,
    blocked_id INT,
    block_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (blocker_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (blocked_id) REFERENCES User(user_id) ON DELETE CASCADE,
    PRIMARY KEY (blocker_id, blocked_id)
);

-- Friendship Table
CREATE TABLE Friendship (
    user1_id INT,
    user2_id INT,
    status ENUM('pending', 'accepted', 'rejected', 'blocked') NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user1_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user2_id) REFERENCES User(user_id) ON DELETE CASCADE,
    PRIMARY KEY (user1_id, user2_id)
);

-- Attachment Table
CREATE TABLE Attachment (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    message_id INT,
    file_path VARCHAR(255),
    file_type VARCHAR(50),
    uploaded_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (message_id) REFERENCES Message(message_id) ON DELETE CASCADE
);

-- Poll Table
CREATE TABLE Poll (
    poll_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    question TEXT NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    expiration_date DATETIME,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE
);

-- Poll_Option Table
CREATE TABLE Poll_Option (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    poll_id INT,
    option_text VARCHAR(255),
    FOREIGN KEY (poll_id) REFERENCES Poll(poll_id) ON DELETE CASCADE
);

-- Poll_Vote Table
CREATE TABLE Poll_Vote (
    poll_id INT,
    option_id INT,
    user_id INT,
    vote_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (poll_id) REFERENCES Poll(poll_id) ON DELETE CASCADE,
    FOREIGN KEY (option_id) REFERENCES Poll_Option(option_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    PRIMARY KEY (poll_id, option_id, user_id)
);

-- Insert into User
INSERT INTO User (username, email, password_hash, profile_picture, bio) 
VALUES 
('Alice', 'alice@example.com', 'hashed_password_1', 'alice.jpg', 'Bio for Alice'),
('Bob', 'bob@example.com', 'hashed_password_2', 'bob.jpg', 'Bio for Bob'),
('Charlie', 'charlie@example.com', 'hashed_password_3', 'charlie.jpg', 'Bio for Charlie');

-- Insert into Server
INSERT INTO Server (name, description, created_by) 
VALUES 
('Tech Community', 'A place to discuss tech', 1),
('Gaming Hub', 'All about gaming', 2);

-- Insert into Channel
INSERT INTO Channel (server_id, name, channel_type) 
VALUES 
(1, 'General', 'text'),
(1, 'Announcements', 'text'),
(2, 'Gaming Talk', 'text');

-- Insert into Post
INSERT INTO Post (user_id, channel_id, title, content) 
VALUES 
(1, 1, 'Welcome Post', 'Welcome to the Tech Community!'),
(2, 2, 'Update', 'New features are coming soon!');

-- Insert into Comment
INSERT INTO Comment (post_id, user_id, content) 
VALUES 
(1, 2, 'Thanks for the warm welcome!'),
(1, 3, 'Excited to be here!');

-- Insert into Reaction
INSERT INTO Reaction (user_id, reaction_type) 
VALUES 
(1, 'like'),
(2, 'love');

-- Insert into Message
INSERT INTO Message (channel_id, user_id, content) 
VALUES 
(1, 1, 'Hello everyone!'),
(2, 2, 'This is an announcement.');

-- Insert into Role
INSERT INTO Role (server_id, role_name, permissions) 
VALUES 
(1, 'Admin', 'all'),
(2, 'Moderator', 'manage_channels, moderate_messages');

-- Insert into User_Roles
INSERT INTO User_Roles (user_id, server_id, role_id) 
VALUES 
(1, 1, 1),
(2, 2, 2);

-- Insert into Group
INSERT INTO `Group` (server_id, name, created_by) 
VALUES 
(1, 'Tech Enthusiasts', 1),
(2, 'Gamers United', 2);

-- Insert into User_Groups
INSERT INTO User_Groups (user_id, group_id) 
VALUES 
(1, 1),
(2, 2);

-- Insert into Notification
INSERT INTO Notification (user_id, content) 
VALUES 
(1, 'You have a new follower.'),
(2, 'Your post received a reaction.');

-- Insert into Tag
INSERT INTO Tag (tag_name) 
VALUES 
('Tech'), 
('Gaming');

-- Insert into Post_Tags
INSERT INTO Post_Tags (post_id, tag_id) 
VALUES 
(1, 1),
(2, 2);

-- Insert into Blocked_Users
INSERT INTO Blocked_Users (blocker_id, blocked_id) 
VALUES 
(1, 2),
(3, 1);

-- Insert into Friendship
INSERT INTO Friendship (user1_id, user2_id, status) 
VALUES 
(1, 2, 'accepted'),
(2, 3, 'pending');

-- Insert into Attachment
INSERT INTO Attachment (message_id, file_path, file_type) 
VALUES 
(1, 'path/to/file.jpg', 'image'),
(2, 'path/to/document.pdf', 'document');

-- Insert into Poll
INSERT INTO Poll (post_id, question, expiration_date) 
VALUES 
(1, 'What is your favorite programming language?', '2024-12-31 23:59:59');

-- Insert into Poll_Option
INSERT INTO Poll_Option (poll_id, option_text) 
VALUES 
(1, 'Python'),
(1, 'C++'),
(1, 'JavaScript');

-- Insert into Poll_Vote
INSERT INTO Poll_Vote (poll_id, option_id, user_id) 
VALUES 
(1, 1, 1),
(1, 2, 2),
(1, 3, 3);

-- 1. Retrieve all users
SELECT * FROM User;

-- 2. Count total number of users
SELECT COUNT(*) AS total_users FROM User;

-- 3. Find a user by username
SELECT * FROM User WHERE username = 'Alice';

-- 4. List all users sorted by join date
SELECT * FROM User ORDER BY join_date DESC;

-- 5. Count users with a specific email domain
SELECT COUNT(*) AS total_users FROM User WHERE email LIKE '%@gmail.com';

-- 6. Retrieve users with no profile picture
SELECT * FROM User WHERE profile_picture IS NULL;

-- 7. Find duplicate emails
SELECT email, COUNT(*) FROM User GROUP BY email HAVING COUNT(*) > 1;

-- 8. Find users who joined before a specific date
SELECT * FROM User WHERE join_date < '2024-01-01';

-- 9. Get usernames and email addresses of all users
SELECT username, email FROM User;

-- 10. Count users who have set a bio
SELECT COUNT(*) AS users_with_bio FROM User WHERE bio IS NOT NULL;

-- 11. List the most recent 5 users to join
SELECT * FROM User ORDER BY join_date DESC LIMIT 5;

-- 12. Retrieve users whose username starts with a specific letter
SELECT * FROM User WHERE username LIKE 'A%';

-- 13. Find users who joined within the last 30 days
SELECT * FROM User WHERE join_date >= NOW() - INTERVAL 30 DAY;

-- 14. Update a user's bio
UPDATE User SET bio = 'Updated bio' WHERE username = 'Alice';

-- 15. Delete a user by username
DELETE FROM User WHERE username = 'Charlie';

-- 16. Add a new user
INSERT INTO User (username, email, password_hash, profile_picture, bio) 
VALUES ('Dave', 'dave@example.com', 'hashed_password_4', 'dave.jpg', 'Bio for Dave');

-- 17. Reset profile pictures for inactive users
UPDATE User SET profile_picture = NULL WHERE join_date < '2024-01-01';

-- 18. Find users with the longest bio (top 3)
SELECT * FROM User ORDER BY LENGTH(bio) DESC LIMIT 3;

-- 19. Check if a username or email already exists (for registration)
SELECT * FROM User WHERE username = 'NewUser' OR email = 'newuser@example.com';

-- 20. Get the earliest join date
SELECT MIN(join_date) AS earliest_join_date FROM User;

-- 21. List all servers created by a specific user
SELECT * FROM Server WHERE created_by = (SELECT user_id FROM User WHERE username = 'Alice');

-- 22. Find the number of posts made by each user
SELECT U.username, COUNT(P.post_id) AS post_count 
FROM User U 
LEFT JOIN Post P ON U.user_id = P.user_id 
GROUP BY U.user_id;

-- 23. Retrieve users who commented on a specific post
SELECT DISTINCT U.username 
FROM User U 
INNER JOIN Comment C ON U.user_id = C.user_id 
WHERE C.post_id = 1;

-- 24. Find all reactions given by a user
SELECT R.reaction_type 
FROM Reaction R 
INNER JOIN User U ON R.user_id = U.user_id 
WHERE U.username = 'Bob';

-- 25. Check which channels a specific user has messaged in
SELECT DISTINCT C.name AS channel_name 
FROM Channel C 
INNER JOIN Message M ON C.channel_id = M.channel_id 
WHERE M.user_id = (SELECT user_id FROM User WHERE username = 'Alice');

-- 26. Find users assigned to a specific role on a server
SELECT U.username 
FROM User U 
INNER JOIN User_Roles UR ON U.user_id = UR.user_id 
WHERE UR.role_id = (SELECT role_id FROM Role WHERE role_name = 'Admin' AND server_id = 1);

-- 27. Find the number of messages sent by each user
SELECT U.username, COUNT(M.message_id) AS message_count 
FROM User U 
LEFT JOIN Message M ON U.user_id = M.user_id 
GROUP BY U.user_id;

-- 28. List users who reacted to posts in a specific channel
SELECT DISTINCT U.username 
FROM User U 
INNER JOIN Reaction R ON U.user_id = R.user_id 
INNER JOIN Post P ON P.post_id = R.reaction_id 
WHERE P.channel_id = 1;

-- 29. Retrieve users and the groups they belong to
SELECT U.username, G.name AS group_name 
FROM User U 
INNER JOIN User_Groups UG ON U.user_id = UG.user_id 
INNER JOIN `Group` G ON UG.group_id = G.group_id;

-- 30. List all friendships for a specific user
SELECT U1.username AS user1, U2.username AS user2, F.status 
FROM Friendship F 
INNER JOIN User U1 ON F.user1_id = U1.user_id 
INNER JOIN User U2 ON F.user2_id = U2.user_id 
WHERE U1.username = 'Alice' OR U2.username = 'Alice';

-- 31. Find the user with the most posts
SELECT U.username, COUNT(P.post_id) AS post_count 
FROM User U 
LEFT JOIN Post P ON U.user_id = P.user_id 
GROUP BY U.user_id 
ORDER BY post_count DESC 
LIMIT 1;

-- 32. Count the number of users in each server
SELECT S.name AS server_name, COUNT(UR.user_id) AS user_count 
FROM Server S 
LEFT JOIN User_Roles UR ON S.server_id = UR.server_id 
GROUP BY S.server_id;

-- 33. Retrieve users who have never posted or commented
SELECT * 
FROM User U 
WHERE U.user_id NOT IN (SELECT user_id FROM Post) 
AND U.user_id NOT IN (SELECT user_id FROM Comment);

-- 34. Find the most active user by message count
SELECT U.username, COUNT(M.message_id) AS message_count 
FROM User U 
INNER JOIN Message M ON U.user_id = M.user_id 
GROUP BY U.user_id 
ORDER BY message_count DESC 
LIMIT 1;

-- 35. List users who reacted to posts but never commented
SELECT DISTINCT U.username 
FROM User U 
INNER JOIN Reaction R ON U.user_id = R.user_id 
WHERE U.user_id NOT IN (SELECT user_id FROM Comment);

-- 36. Find the average number of posts per user
SELECT AVG(post_count) AS avg_posts_per_user 
FROM (SELECT COUNT(P.post_id) AS post_count 
      FROM User U 
      LEFT JOIN Post P ON U.user_id = P.user_id 
      GROUP BY U.user_id) AS PostCounts;

-- 37. Retrieve users with the most reactions on their posts
SELECT U.username, COUNT(R.reaction_id) AS reaction_count 
FROM User U 
INNER JOIN Post P ON U.user_id = P.user_id 
INNER JOIN Reaction R ON P.post_id = R.reaction_id 
GROUP BY U.user_id 
ORDER BY reaction_count DESC 
LIMIT 1;

-- 38. Identify users who blocked another user
SELECT U1.username AS blocker, U2.username AS blocked 
FROM Blocked_Users B 
INNER JOIN User U1 ON B.blocker_id = U1.user_id 
INNER JOIN User U2 ON B.blocked_id = U2.user_id;

-- 39. Retrieve users who voted on a specific poll
SELECT DISTINCT U.username 
FROM User U 
INNER JOIN Poll_Vote PV ON U.user_id = PV.user_id 
WHERE PV.poll_id = 1;

-- 40. Count the number of unread notifications for each user
SELECT U.username, COUNT(N.notification_id) AS unread_notifications 
FROM User U 
INNER JOIN Notification N ON U.user_id = N.user_id 
WHERE N.read_status = FALSE 
GROUP BY U.user_id;

-- 41. Delete all users who haven't joined since 2023
DELETE FROM User WHERE join_date < '2023-01-01';

-- 42. Update all inactive users' bios to "Inactive"
UPDATE User SET bio = 'Inactive' WHERE user_id NOT IN (SELECT DISTINCT user_id FROM Post);

-- 43. Find the total number of blocked relationships
SELECT COUNT(*) AS total_blocks FROM Blocked_Users;

-- 44. Find the server with the most users
SELECT S.name, COUNT(UR.user_id) AS user_count 
FROM Server S 
LEFT JOIN User_Roles UR ON S.server_id = UR.server_id 
GROUP BY S.server_id 
ORDER BY user_count DESC 
LIMIT 1;

-- 45. List users with no assigned roles on any server
SELECT * FROM User 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM User_Roles);

-- 46. List users who sent the longest message
SELECT U.username, M.content 
FROM User U 
INNER JOIN Message M ON U.user_id = M.user_id 
ORDER BY LENGTH(M.content) DESC 
LIMIT 1;

-- 47. Check all servers without any channels
SELECT * FROM Server 
WHERE server_id NOT IN (SELECT DISTINCT server_id FROM Channel);

-- 48. Find duplicate emails in the `User` table (if any)
SELECT email, COUNT(*) 
FROM User 
GROUP BY email 
HAVING COUNT(*) > 1;

-- 49. Count total reactions across all posts
SELECT COUNT(*) AS total_reactions FROM Reaction;

-- 50. Add a default role for all new users in a specific server
INSERT INTO User_Roles (user_id, server_id, role_id) 
SELECT user_id, 1, 3 FROM User WHERE user_id NOT IN (SELECT user_id FROM User_Roles WHERE server_id = 1);



















