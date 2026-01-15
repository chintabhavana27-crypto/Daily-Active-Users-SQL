create DATABASE daily_users_db;
use daily_users_db;
CREATE TABLE users(
user_id INT PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100),
created_date DATE
);
CREATE TABLE user_activity(
activity_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT,
activity_date DATE NOT NULL,
activity_type VARCHAR(50),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);
INSERT INTO users(user_id,name,email,created_date)VALUES
(101,'Amit','suresh@email.com','2024-01-01'),
(102,'Priya','priya@email.com','2024-01-02'),
(103,'Ravi','ravi@email.com','2024-01-02');
INSERT INTO user_activity(user_id, activity_date, activity_type)VALUES
(101,'2024-01-01','login'),
(102,'2024-01-01','login'),
(101,'2024-01-01','purchase'),
(103,'2024-01-02','login'),
(101,'2024-01-02','login'),
(102,'2024-01-02','click');

# 1.Daily Active Users 
#count unique users active each day
select activity_date,
    count(distinct user_id) as daily_active_activity
    from user_activity
    group by activity_date
    order by activity_date;
    
#2.Monthly Active Users
#count unique users active each month
select
date_format(activity_date,'%y-%m') as month,
count(distinct user_id) as monthly_active_users
from user_activity
group by date_format(activity_date,'%y-%m')
order by month;

#3.Inactive Users
select u.user_id,u.name 
from users u 
left join user_activity a 
on u.user_id = a.user_id
where a.user_id is null;

#4.login activity analysis
--# count how many users performed login activity each day
SELECT activity_date,
COUNT(DISTINCT user_id) AS login_users
FROM user_activity
WHERE activity_type = 'login'
GROUP BY activity_date
ORDER BY activity_date;

#5.User Retention (Day-on-Day)
# 5 Users active today AND yesterday
SELECT 
    COUNT(DISTINCT ua1.user_id)AS retained_users
FROM user_activity ua1
JOIN user_activity ua2
ON ua1.user_id = ua2.user_id
WHERE ua1.activity_date = CURDATE()
 and ua2.activity_date = 
date_sub(curdate(),interval 1 day);

# 6.Top Active Users
# Users with the highest total activity.
SELECT user_id,
    COUNT(*) AS activity_count
FROM user_activity
GROUP BY user_id
ORDER BY activity_count DESC
LIMIT 5;