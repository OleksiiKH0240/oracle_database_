
------------------------------------------------------------------------------------------------------------------------
-- GENRES INSERT
-- довідник

insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (1, 'action');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (2, 'adventure');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (3, 'comedy');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (4, 'drama');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (5, 'slice of life');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (6, 'fantasy');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (7, 'magic');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (8, 'supernatural');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (9, 'horror');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (10, 'mystery');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (11, 'psychological');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (12, 'romance');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (13, 'sci-fi');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (14, 'cyberpunk');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (15, 'game');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (16, 'ecchi');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (17, 'demons');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (18, 'harem');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (19, 'josei');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (20, 'martial arts');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (21, 'historical');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (22, 'hentai');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (23, 'isekai');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (24, 'military');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (25, 'mecha');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (26, 'music');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (27, 'parody');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (28, 'police');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (29, 'post-apocalyptic');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (30, 'reverse harem');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (31, 'school');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (32, 'seinen');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (33, 'shoujo');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (34, 'shoujo-ai');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (35, 'shounen');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (36, 'shounen-ai');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (37, 'space');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (38, 'sports');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (39, 'super power');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (40, 'tragedy');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (41, 'vampire');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (42, 'yuri');
insert into GENRES (GENRE_ID, GENRE_NAME) VALUES (43, 'yao');

------------------------------------------------------------------------------------------------------------------------
-- SUBSCRIPTIONS INSERT
-- довідник

-- insert into SUBSCRIPTIONS (SUBSCRIPTION_ID, SUBSCRIPTION_NAME, PRICE) VALUES (-1, 'unknown', 0.0);
insert into SUBSCRIPTIONS (SUBSCRIPTION_ID, SUBSCRIPTION_NAME, PRICE) VALUES (0, 'basic', 0.0);
insert into SUBSCRIPTIONS (SUBSCRIPTION_ID, SUBSCRIPTION_NAME, PRICE) VALUES (1, 'advanced', 100.0);
insert into SUBSCRIPTIONS (SUBSCRIPTION_ID, SUBSCRIPTION_NAME, PRICE) VALUES (2, 'unlimited', 150.0);

------------------------------------------------------------------------------------------------------------------------
-- STUDIOS INSERT
-- довідник

-- insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (-1, 'unknown');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (1, 'A-1 Pictures');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (2, 'A.C.G.T');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (3, 'A.P.P.P.');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (4, 'Actas');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (5, 'Ajia-do Animation Works');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (6, 'Artland');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (7, 'Artmic (defunct)');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (8, 'Arvo Animation');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (9, 'Ashi Productions');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (10, 'Asahi Production');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (11, 'Asread');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (12, 'AXsiZ');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (13, 'Bandai Namco Pictures');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (14, 'Bee Train');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (15, 'Bibury Animation Studios');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (16, 'Blue Lynx');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (17, 'Bones');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (18, 'Brain`s Base');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (19, 'Bridge (studio)');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (20, 'C2C');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (21, 'Chaos Project');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (22, 'CloverWorks');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (23, 'CoMix Wave Films');
insert into STUDIOS (STUDIO_ID, STUDIO_NAME) VALUES (24, 'Blackfyre Incorporate');

------------------------------------------------------------------------------------------------------------------------
-- USERS INSERT
-- CAN BE REUSED

drop sequence USERS_SEQ;

create sequence USERS_SEQ;

alter procedure INSERT_USERS compile reuse settings;

-- delete from USERS where USER_ID > 0;

begin
    INSERT_USERS(3000);
end;


-- select *
-- from USERS;

------------------------------------------------------------------------------------------------------------------------
-- ANIME_TITLES INSERT
-- CAN BE REUSED

drop sequence ANIME_TITLES_SEQ;

create sequence ANIME_TITLES_SEQ;

alter procedure INSERT_ANIME_TITLES compile reuse settings;

-- delete from ANIME_TITLES where ANIME_ID > 0;

begin
    INSERT_ANIME_TITLES(100);
end;

-- select *
-- FROM ANIME_TITLES;

------------------------------------------------------------------------------------------------------------------------
-- COMMENTS INSERT PROCEDURE
-- CAN BE REUSED

drop sequence COMMENTS_SEQ;

create sequence COMMENTS_SEQ;

alter procedure INSERT_COMMENTS compile reuse settings;

-- delete from COMMENTS where COMMENT_ID > 0;

begin
    INSERT_COMMENTS(20000);
end;

-- select *
-- from COMMENTS
-- order by COMMENT_ID;

-- select COMMENTS_SEQ.nextval from dual;

------------------------------------------------------------------------------------------------------------------------
-- PAYMENTS INSERT
-- CAN BE REUSED

drop sequence PAYMENTS_SEQ;

create sequence PAYMENTS_SEQ;

alter procedure INSERT_PAYMENTS compile reuse settings;

-- delete from PAYMENTS where PAYMENT_ID > 0;

begin
    INSERT_PAYMENTS(6000);
end;

-- select p.*, u.USER_MONEY
-- from PAYMENTS p,
--      USERS u
-- where p.USER_ID = u.USER_ID;

------------------------------------------------------------------------------------------------------------------------
-- ANIME_GENRES_RELATIONS INSERT
-- CAN'T BE REUSED OR YOU SHOULD DELETE ALL DATA FROM TABLE ANIME_GENRES_RELATIONS FIRST

-- delete from ANIME_GENRES_RELATIONS where ANIME_ID > 0 and GENRE_ID > 0;

begin
    INSERT_ANIME_GENRES_RELATIONS();
end;

-- select ANIME_ID, count(GENRE_ID), listagg(GENRE_ID, ',')
-- from ANIME_GENRES_RELATIONS
-- group by ANIME_ID;
--
-- select *
-- from ANIME_TITLES;

------------------------------------------------------------------------------------------------------------------------
-- ANIME_USERS_RELATIONS INSERT
-- CAN'T BE REUSED OR YOU SHOULD DELETE ALL DATA FROM TABLE ANIME_USERS_RELATIONS

-- delete from ANIME_USERS_RELATIONS where ANIME_ID > 0 and USER_ID > 0;

begin
    INSERT_ANIME_USERS_RELATIONS(3000);
end;

-- select ANIME_ID, count(USER_ID), listagg(USER_ID, ',')
-- from ANIME_USERS_RELATIONS
-- group by ANIME_ID;

------------------------------------------------------------------------------------------------------------------------
-- DELETE ALL RANDOM GENERATED DATA

-- delete from ANIME_USERS_RELATIONS where ANIME_ID > 0 and USER_ID > 0;
-- delete from ANIME_GENRES_RELATIONS where ANIME_ID > 0 and GENRE_ID > 0;
-- delete from PAYMENTS where PAYMENT_ID > 0;
-- delete from COMMENTS where COMMENT_ID > 0;
-- delete from ANIME_TITLES where ANIME_ID > 0;
-- delete from USERS where USER_ID > 0;
--

-- DELETE OTHER TABLE DATA
-- delete from GENRES where GENRE_ID > 0;
-- delete from SUBSCRIPTIONS where SUBSCRIPTION_ID >= 0;
-- delete from STUDIOS where STUDIO_ID > 0;

commit;
