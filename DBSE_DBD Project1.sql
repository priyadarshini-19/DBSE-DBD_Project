CREATE DATABASE Match_Sports;
USE Match_Sports;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('player','coach','organizer','admin') DEFAULT 'player',
    age INT,
    sport_preference VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Sports (
    sport_id INT AUTO_INCREMENT PRIMARY KEY,
    sport_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    sport_id INT NOT NULL,
    organizer_id INT NOT NULL,
    date_time DATETIME NOT NULL,
    end_time DATETIME,
    location VARCHAR(100),
    status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);

CREATE TABLE Session_Participants (
    session_id INT NOT NULL,
    user_id INT NOT NULL,
    attendance ENUM('confirmed','cancelled','pending') DEFAULT 'pending',
    PRIMARY KEY(session_id, user_id),
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Performance (
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    session_id INT NOT NULL,
    score INT,
    remarks TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id)
);

CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    type ENUM('reminder','confirmation','cancellation') DEFAULT 'reminder',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE AuthLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    device VARCHAR(50),
    platform ENUM('Android','iOS','Web'),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

SELECT s.sport_name, COUNT(sp.user_id) AS num_players
FROM Sports s
JOIN Sessions se ON s.sport_id = se.sport_id
JOIN Session_Participants sp ON se.session_id = sp.session_id
WHERE sp.attendance = 'confirmed'
GROUP BY s.sport_name;

SELECT se.date_time, se.end_time, s.sport_name, se.location, se.status
FROM Sessions se
JOIN Sports s ON se.sport_id = s.sport_id
WHERE DATE(se.date_time) = '2026-09-02';

SELECT u.name, u.sport_preference, MIN(se.date_time) AS next_match
FROM Users u
JOIN Sports s ON u.sport_preference = s.sport_name
JOIN Sessions se ON s.sport_id = se.sport_id
WHERE se.date_time > NOW()
GROUP BY u.user_id, u.sport_preference;

SELECT s.sport_name, se.date_time AS start_time, se.end_time, se.location
FROM Sessions se
JOIN Sports s ON se.sport_id = s.sport_id;

INSERT INTO Users (name, email, password_hash, role, age, sport_preference) VALUES
('Rahul Sharma','rahul1@example.com','hash1','player',22,'Football'),
('Priya Nair','priya2@example.com','hash2','player',20,'Cricket'),
('Amit Verma','amit3@example.com','hash3','coach',35,'Athletics'),
('Sneha Reddy','sneha4@example.com','hash4','player',19,'Badminton'),
('Vikram Singh','vikram5@example.com','hash5','admin',40,'Football'),
('Kiran Kumar','kiran6@example.com','hash6','player',23,'Tennis'),
('Meena Joshi','meena7@example.com','hash7','player',21,'Cricket'),
('Arjun Patel','arjun8@example.com','hash8','player',24,'Football'),
('Divya Rao','divya9@example.com','hash9','player',22,'Badminton'),
('Suresh Iyer','suresh10@example.com','hash10','coach',38,'Athletics'),
('Neha Gupta','neha11@example.com','hash11','player',20,'Tennis'),
('Ravi Menon','ravi12@example.com','hash12','player',25,'Football'),
('Anjali Das','anjali13@example.com','hash13','player',19,'Cricket'),
('Manoj Pillai','manoj14@example.com','hash14','organizer',32,'Athletics'),
('Pooja Sharma','pooja15@example.com','hash15','player',21,'Badminton'),
('Santosh Reddy','santosh16@example.com','hash16','player',23,'Football'),
('Lakshmi Prasad','lakshmi17@example.com','hash17','player',22,'Tennis'),
('Deepak Yadav','deepak18@example.com','hash18','player',24,'Cricket'),
('Shweta Kapoor','shweta19@example.com','hash19','player',20,'Badminton'),
('Nikhil Jain','nikhil20@example.com','hash20','player',26,'Football');

INSERT INTO Sports (sport_name) VALUES
('Football'),('Cricket'),('Athletics'),('Badminton'),('Tennis');

INSERT INTO Sessions (sport_id, organizer_id, date_time, end_time, location, status) VALUES
(1,5,'2026-09-01 17:00:00','2026-09-01 19:00:00','City Stadium','scheduled'),
(2,3,'2026-09-02 10:00:00','2026-09-02 12:00:00','College Ground','scheduled'),
(3,3,'2026-09-03 07:00:00','2026-09-03 09:00:00','Athletics Track','scheduled'),
(4,3,'2026-09-04 09:00:00','2026-09-04 11:00:00','Indoor Arena','scheduled'),
(5,6,'2026-09-05 15:00:00','2026-09-05 17:00:00','Tennis Court','scheduled'),
(1,8,'2026-09-06 18:00:00','2026-09-06 20:00:00','City Stadium','scheduled'),
(2,7,'2026-09-07 09:00:00','2026-09-07 11:00:00','College Ground','scheduled'),
(3,10,'2026-09-08 06:30:00','2026-09-08 08:30:00','Athletics Track','scheduled'),
(4,9,'2026-09-09 11:00:00','2026-09-09 13:00:00','Indoor Arena','scheduled'),
(5,11,'2026-09-10 16:00:00','2026-09-10 18:00:00','Tennis Court','scheduled'),
(1,12,'2026-09-11 17:30:00','2026-09-11 19:30:00','City Stadium','scheduled'),
(2,13,'2026-09-12 10:30:00','2026-09-12 12:30:00','College Ground','scheduled'),
(3,14,'2026-09-13 07:15:00','2026-09-13 09:15:00','Athletics Track','scheduled'),
(4,15,'2026-09-14 09:30:00','2026-09-14 11:30:00','Indoor Arena','scheduled'),
(5,16,'2026-09-15 15:30:00','2026-09-15 17:30:00','Tennis Court','scheduled'),
(1,17,'2026-09-16 18:15:00','2026-09-16 20:15:00','City Stadium','scheduled'),
(2,18,'2026-09-17 09:15:00','2026-09-17 11:15:00','College Ground','scheduled'),
(3,19,'2026-09-18 06:45:00','2026-09-18 08:45:00','Athletics Track','scheduled'),
(4,20,'2026-09-19 11:15:00','2026-09-19 13:15:00','Indoor Arena','scheduled'),
(5,6,'2026-09-20 16:15:00','2026-09-20 18:15:00','Tennis Court','scheduled');

INSERT INTO Session_Participants (session_id, user_id, attendance) VALUES
(1,1,'confirmed'),(2,2,'confirmed'),(3,3,'confirmed'),(4,4,'confirmed'),
(5,6,'confirmed'),(6,8,'confirmed'),(7,7,'confirmed'),(8,10,'confirmed'),
(9,9,'confirmed'),(10,11,'confirmed'),(11,12,'confirmed'),(12,13,'confirmed'),
(13,14,'confirmed'),(14,15,'confirmed'),(15,16,'confirmed'),(16,17,'confirmed'),
(17,18,'confirmed'),(18,19,'confirmed'),(19,20,'confirmed'),(20,5,'confirmed');

INSERT INTO Performance (user_id, session_id, score, remarks) VALUES
(1,1,2,'Scored 2 goals'),
(2,2,45,'Top batsman'),
(3,3,1,'Coached athletics'),
(4,4,3,'Won badminton match'),
(6,5,2,'Tennis doubles win'),
(8,6,1,'Football assist'),
(7,7,30,'Cricket bowler'),
(10,8,2,'Athletics sprint'),
(9,9,4,'Badminton rally'),
(11,10,3,'Tennis singles win'),
(12,11,1,'Football defense'),
(13,12,50,'Cricket batting'),
(14,13,2,'Athletics jump'),
(15,14,5,'Badminton smash'),
(16,15,2,'Football striker'),
(17,16,3,'Tennis serve'),
(18,17,40,'Cricket batting'),
(19,18,1,'Athletics run'),
(20,19,6,'Badminton win'),
(5,20,2,'Football organizer');

INSERT INTO AuthLogs (user_id, device, platform) VALUES
(1,'Samsung Galaxy','Android'),
(2,'iPhone 12','iOS'),
(3,'Dell Laptop','Web'),
(4,'OnePlus','Android'),
(5,'MacBook','Web'),
(6,'iPhone 13','iOS'),
(7,'Samsung Tablet','Android'),
(8,'HP Laptop','Web'),
(9,'Pixel Phone','Android'),
(10,'iPad','iOS'),
(11,'Lenovo Laptop','Web'),
(12,'Samsung Galaxy','Android'),
(13,'iPhone 14','iOS'),
(14,'Dell Laptop','Web'),
(15,'OnePlus Nord','Android'),
(16,'MacBook Pro','Web'),
(17,'Samsung Galaxy','Android'),
(18,'iPhone 11','iOS'),
(19,'HP Laptop','Web'),
(20,'Pixel 6','Android');

SHOW TABLES;
SELECT * FROM Users;
SELECT * FROM Sports;
SELECT * FROM Sessions;
SELECT * FROM Session_Participants;
SELECT * FROM Performance;
SELECT * FROM Notifications;
SELECT * FROM AuthLogs;


