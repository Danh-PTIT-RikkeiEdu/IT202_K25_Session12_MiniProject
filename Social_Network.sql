create database DB_Social_Network;
use DB_Social_Network;

create table Users (
	user_id int primary key auto_increment,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    created_at datetime default(current_timestamp())
);

create table Posts (
	post_id int primary key auto_increment,
    user_id int,
    content text not null,
    created_at datetime default(current_timestamp()),
    is_deleted boolean default false,
    foreign key (user_id) references Users(user_id) on delete cascade
);

create index idx_posts_created_at on posts(created_at);

create table Comments (
	comment_id int primary key auto_increment,
    user_id int,
    post_id int,
    content text not null,
    created_at datetime default(current_timestamp()),
    foreign key (user_id) references Users(user_id) on delete cascade,
    foreign key (post_id) references Posts(post_id) on delete cascade
);

create table Friends (
    user_id int,
    friend_id int,
    primary key (user_id, friend_id), -- Chặn 1 ng addfr ngkh 2 lần
    status varchar(20) check (status in ('pending','accepted')),
    foreign key (user_id) references Users(user_id) on delete cascade,
    foreign key (friend_id) references Users(user_id) on delete cascade,
    constraint block_auto_addfr check (user_id != friend_id) 
);

create table Likes (
    user_id int,
    post_id int,
    primary key (user_id, post_id), -- 1ng chi dc like 1 bai 1 lan
    foreign key (user_id) references Users(user_id) on delete cascade, 
    foreign key (post_id) references Posts(post_id) on delete cascade
);

-- 1. chèn dữ liệu mẫu cho bảng users (3 người dùng)
insert into users (username, password, email) values 
('cong_danh', 'danh_pass_123', 'danh@example.com'),
('minh_tuan', 'tuan_secure_456', 'tuan@example.com'),
('thu_ha', 'ha_secret_789', 'ha@example.com');

-- 2. chèn dữ liệu mẫu cho bảng posts (3 bài viết)
insert into posts (user_id, content) values 
(1, 'chào mọi người, đây là bài viết đầu tiên của tôi trên mạng xã hội này!'),
(1, 'hôm nay học sql thú vị thật, mọi người thấy sao?'),
(2, 'có ai muốn đi cafe cuối tuần này không?');

-- 3. chèn dữ liệu mẫu cho bảng likes (tương tác thích)
insert into likes (user_id, post_id) values 
(1, 3), 
(2, 1), 
(3, 1), 
(3, 2);

-- 4. chèn dữ liệu mẫu cho bảng comments (tương tác bình luận)
insert into comments (user_id, post_id, content) values 
(2, 1, 'chào danh nhé! rất vui được kết nối.'),
(3, 1, 'bài viết hay quá bạn ơi!'),
(1, 3, 'đi luôn tuấn ơi, cho mình một slot.');

-- 5. chèn dữ liệu mẫu cho bảng friends (mối quan hệ bạn bè)
insert into friends (user_id, friend_id, status) values 
(1, 2, 'accepted'), 
(1, 3, 'pending'),  
(2, 3, 'accepted');

-- chức năng 1 Hiển thị Hồ sơ người dùng an toàn
create view view_user_info as
select user_id, username, email, created_at
from users;

select * from view_user_info;

-- chức năng 2: Báo cáo tương tác bài viết
CREATE VIEW vw_post_statistics AS
SELECT 
    p.post_id,
    p.content AS post_content,
    u.username AS author_name,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content, u.username;

SELECT * FROM vw_post_statistics;

