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




