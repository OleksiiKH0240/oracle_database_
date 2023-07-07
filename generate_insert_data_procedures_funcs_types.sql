------------------------------------------------------------------------------------------------------------------------
-- USERS INSERT
-- CAN BE REUSED

-- drop sequence USERS_SEQ;

create sequence USERS_SEQ;

create or replace procedure insert_users(n in number default 10) is
    currDate           date   := sysdate;
    subscriptionId_val number := 0;
begin
    for i in 1..n
        loop
            if i > round(n / 2) then subscriptionId_val := round(DBMS_RANDOM.value(1, 2)); end if;
            currDate := SYSDATE + DBMS_RANDOM.value(0, 133);
            insert into USERS (USER_ID,
                               USER_NAME,
                               USER_MONEY,
                               IS_MAN,
                               REG_DATE,
                               SUBSCRIPTION_ID,
                               SUBSCRIPTION_EXPIRED_DATE)
            values (USERS_SEQ.nextval,
                    DBMS_RANDOM.string('x', 10),
                    0.0,
                    round(DBMS_RANDOM.value(0, 1)),
                    currDate,
                    subscriptionId_val,
                    currDate + DBMS_RANDOM.value(0, 366));
        end loop;

end;


-- begin
--     INSERT_USERS;
-- end;


------------------------------------------------------------------------------------------------------------------------
-- ANIME_TITLES INSERT
-- CAN BE REUSED

-- drop sequence ANIME_TITLES_SEQ;

create sequence ANIME_TITLES_SEQ;

create or replace procedure INSERT_ANIME_TITLES(n in number default 10) is
    subscriptionId_val number := 0;
    type NumberArray is table of NUMBER(12) index by binary_integer;
    studios_ids        NumberArray;
    idx                number;

begin
    SELECT STUDIO_ID bulk collect into studios_ids FROM STUDIOS where STUDIO_ID >= 0;

    for i in 1..n
        loop
            if i > round(n / 2) then subscriptionId_val := round(DBMS_RANDOM.value(1, 2)); end if;
            idx := round(DBMS_RANDOM.value(1, studios_ids.count));
            insert into ANIME_TITLES(ANIME_ID,
                                     ANIME_NAME,
                                     DESCRIPTION,
                                     SUBSCRIPTION_ID,
                                     STUDIO_ID)
            values (ANIME_TITLES_SEQ.nextval,
                    DBMS_RANDOM.string('x', 10),
                    DBMS_RANDOM.string('x', round(DBMS_RANDOM.value(50, 200))),
                    subscriptionId_val,
                    studios_ids(idx));
        end loop;
end;

-- begin
--     INSERT_ANIME_TITLES(20);
-- end;

------------------------------------------------------------------------------------------------------------------------
-- COMMENTS INSERT PROCEDURE
-- CAN BE REUSED

-- drop sequence COMMENTS_SEQ;

create sequence COMMENTS_SEQ;

create or replace procedure INSERT_COMMENTS(n in number default 10) is
    type NumberArray is table of NUMBER(12) index by binary_integer;
    type DateArray is table of Date index by binary_integer;
    users_ids           NumberArray;
    user_id_idx         number;
    anime_ids           NumberArray;
    anime_id_idx        number;
    users_reg_dates     DateArray;
    users_reg_dates_idx number;

begin
    SELECT USER_ID bulk collect into users_ids FROM USERS where USER_ID >= 0 order by USER_ID;
    SELECT REG_DATE bulk collect into users_reg_dates FROM USERS where USER_ID >= 0 order by USER_ID;
    SELECT ANIME_ID bulk collect into anime_ids FROM ANIME_TITLES where ANIME_ID >= 0;

    for i in 1..n
        loop
            user_id_idx := round(DBMS_RANDOM.value(1, users_ids.count));
            anime_id_idx := round(DBMS_RANDOM.value(1, anime_ids.count));
            users_reg_dates_idx := user_id_idx;
            insert into COMMENTS (COMMENT_ID,
                                  USER_ID,
                                  ANIME_ID,
                                  COMMENT_CONTENT,
                                  COMMENT_DATE)
            values (COMMENTS_SEQ.nextval,
                    users_ids(user_id_idx),
                    anime_ids(anime_id_idx),
                    DBMS_RANDOM.string('x', round(DBMS_RANDOM.value(50, 200))),
                    users_reg_dates(users_reg_dates_idx) + DBMS_RANDOM.value(1, 133));
        end loop;
end;

-- begin
--     INSERT_COMMENTS;
-- end;

------------------------------------------------------------------------------------------------------------------------
-- PAYMENTS INSERT
-- CAN BE REUSED

-- drop sequence PAYMENTS_SEQ;

create sequence PAYMENTS_SEQ;

create or replace procedure INSERT_PAYMENTS(n in number default 10) is
    type DateArray is table of Date index by binary_integer;
    type NumberArray is table of NUMBER(12) index by binary_integer;
    users_ids           NumberArray;
    user_id_idx         number;
    users_reg_dates     DateArray;
    users_reg_dates_idx number;

begin
    SELECT USER_ID bulk collect into users_ids FROM USERS where USER_ID >= 0 order by USER_ID;
    SELECT REG_DATE bulk collect into users_reg_dates FROM USERS where USER_ID >= 0 order by USER_ID;

    for i in 1..n
        loop
            user_id_idx := round(DBMS_RANDOM.value(1, users_ids.count));
            users_reg_dates_idx := user_id_idx;
            insert into PAYMENTS(PAYMENT_ID,
                                 USER_ID,
                                 PAID_MONEY,
                                 PAYMENT_DATE)
            values (PAYMENTS_SEQ.nextval,
                    users_ids(user_id_idx),
                    DBMS_RANDOM.value(50, 200),
                    users_reg_dates(users_reg_dates_idx) + DBMS_RANDOM.VALUE(1, 133));
        end loop;
end;

-- begin
--     INSERT_PAYMENTS;
-- end;


------------------------------------------------------------------------------------------------------------------------
-- ANIME_GENRES_RELATIONS INSERT
-- CAN'T BE REUSED OR YOU SHOULD DROP TABLE ANIME_GENRES_RELATIONS FIRST

create or replace type number_array is table of NUMBER(12);

-- create or replace function is_value_in_array(
--     value number, array number_array
-- )
--     return boolean
--     is
-- BEGIN
--     if array.count = 0 then return false; end if;
--     for i in array.first..array.last
--         loop
--             if array(i) = value then return true; end if;
--         end loop;
--
--     return false;
-- END;

create or replace procedure INSERT_ANIME_GENRES_RELATIONS(max_genres_number in number default 7) is
    genre_ids number_array;
    curr_max_genres_number number := max_genres_number;
begin
    SELECT GENRE_ID bulk collect into genre_ids FROM GENRES where GENRE_ID >= 0;
    if curr_max_genres_number > genre_ids.count then curr_max_genres_number := genre_ids.count; end if;

    for anime_title in (select * from ANIME_TITLES where ANIME_ID >= 0)
        loop
            insert into ANIME_GENRES_RELATIONS (ANIME_ID, GENRE_ID)
            select anime_title.ANIME_ID, GENRE_ID
            from (select * from GENRES order by DBMS_RANDOM.VALUE()) random_genres
            where rownum <= round(dbms_random.value(3, curr_max_genres_number));

        end loop;
end;

-- begin
--     INSERT_ANIME_GENRES_RELATIONS;
-- end;

------------------------------------------------------------------------------------------------------------------------
-- ANIME_USERS_RELATIONS INSERT
-- CAN'T BE REUSED OR YOU SHOULD DROP TABLE ANIME_USERS_RELATIONS

create or replace procedure INSERT_ANIME_USERS_RELATIONS(max_users_number in number default 30) is
    users_ids number_array;
    curr_max_users_number number := max_users_number;
begin
    SELECT USER_ID bulk collect into users_ids FROM USERS where USER_ID >= 0;
    if curr_max_users_number > users_ids.count then curr_max_users_number := users_ids.count; end if;

    for anime_title in (select * from ANIME_TITLES where ANIME_ID >= 0)
        loop
            insert into ANIME_USERS_RELATIONS (ANIME_ID,
                                               USER_ID,
                                               RELATION_DATE)
            select anime_title.ANIME_ID, USER_ID, (REG_DATE + DBMS_RANDOM.VALUE(0, 133))
            from (select * from USERS order by DBMS_RANDOM.VALUE()) random_users
            where rownum <= round(dbms_random.value(15, max_users_number));

        end loop;
end;

-- begin
--     INSERT_ANIME_USERS_RELATIONS;
-- end;

