create table hero_type
(
    id     int auto_increment
        primary key,
    attack varchar(50) not null,
    name   varchar(50) not null,
    constraint id
        unique (id),
    constraint name
        unique (name)
);

create table monster
(
    id            int auto_increment
        primary key,
    ability_power int default (0)                   not null,
    attack_damage int default (50)                  not null,
    health_points int default (550)                 not null,
    type          enum ('Zombie', 'Troll', 'Gnome') null,
    constraint id
        unique (id)
);

create table quest
(
    id          int auto_increment
        primary key,
    prize       int default (350) not null,
    name        varchar(255)      not null,
    description text              null,
    constraint id
        unique (id),
    constraint name
        unique (name)
);

create table user
(
    id       int auto_increment
        primary key,
    username varchar(30)  not null,
    password varchar(255) not null,
    constraint id
        unique (id),
    constraint username
        unique (username)
);

create table hero
(
    id             int auto_increment
        primary key,
    killed_monster int default (0)   not null,
    ability_power  int default (0)   not null,
    attack_damage  int default (50)  not null,
    health_points  int default (550) not null,
    type           int               not null,
    user_id        int               not null,
    constraint id
        unique (id),
    constraint hero_ibfk_1
        foreign key (type) references hero_type (id),
    constraint hero_ibfk_2
        foreign key (user_id) references user (id)
);

create index type
    on hero (type);

create index user_id
    on hero (user_id);

create table monsters_heroes
(
    hero_id    int not null,
    monster_id int not null,
    constraint monsters_heroes_ibfk_1
        foreign key (hero_id) references hero (id),
    constraint monsters_heroes_ibfk_2
        foreign key (monster_id) references monster (id)
);

create index hero_id
    on monsters_heroes (hero_id);

create index monster_id
    on monsters_heroes (monster_id);

create table quests_heroes
(
    hero_id  int not null,
    quest_id int not null,
    constraint quests_heroes_ibfk_1
        foreign key (hero_id) references hero (id),
    constraint quests_heroes_ibfk_2
        foreign key (quest_id) references quest (id)
);

create index hero_id
    on quests_heroes (hero_id);

create index quest_id
    on quests_heroes (quest_id);

create definer = root@`%` trigger kill_monster
    after insert
    on quests_heroes
    for each row
BEGIN
    update hero SET health_points = health_points + 50 WHERE id IN (SELECT quest_id FROM quests_heroes);
    update hero SET ability_power = ability_power + 1 WHERE id IN (SELECT quest_id FROM quests_heroes);
    update hero SET attack_damage = hero.attack_damage + 5 WHERE id IN (SELECT quest_id FROM quests_heroes);
end;


