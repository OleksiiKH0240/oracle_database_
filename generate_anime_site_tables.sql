
------------------------------------------------------------------------------------------------------------------------
-- GENRES

create table GENRES
(
    GENRE_ID   NUMBER(12)   not null
        constraint PK_GENRES
            primary key,
    GENRE_NAME VARCHAR2(30) not null
)
/

------------------------------------------------------------------------------------------------------------------------
-- STUDIOS

create table STUDIOS
(
    STUDIO_ID   NUMBER(12) not null
        constraint PK_STUDIOS
            primary key,
    STUDIO_NAME VARCHAR2(30)
)
/

------------------------------------------------------------------------------------------------------------------------
-- SUBSCRIPTIONS

create table SUBSCRIPTIONS
(
    SUBSCRIPTION_ID   NUMBER(12)    not null
        constraint PK_SUBSCRIPTIONS
            primary key
        constraint CKC_SUBSCRIPTION_ID_SUBSCRIP
            check (SUBSCRIPTION_ID between -1 and 2),
    SUBSCRIPTION_NAME VARCHAR2(30),
    PRICE             NUMBER(15, 2) not null
)
/

------------------------------------------------------------------------------------------------------------------------
-- USERS

create table USERS
(
    USER_ID                   NUMBER(12)                    not null
        constraint PK_USERS
            primary key,
    USER_NAME                 VARCHAR2(30)                  not null,
    USER_MONEY                NUMBER(15, 2) default 0,
    IS_MAN                    NUMBER(12)                    not null
        constraint CKC_IS_MAN_USERS
            check (IS_MAN between 0 and 1),
    REG_DATE                  DATE          default SYSDATE not null,
    SUBSCRIPTION_ID           NUMBER(12)    default 0       not null
        constraint FK_USERS_REFERENCE_SUBSCRIP
            references SUBSCRIPTIONS
                on delete cascade,
    SUBSCRIPTION_EXPIRED_DATE DATE          default NULL
)
/

create index IDX_REG_DATE
    on USERS (REG_DATE)
/

create index IDX_SUBSCRIPTION_EXPIRED_DATE
    on USERS (SUBSCRIPTION_EXPIRED_DATE)
/

create bitmap index IDX_IS_MAN
    on USERS (IS_MAN)
/

create bitmap index IDX_USRS_SUBSCRIPTION_ID
    on USERS (SUBSCRIPTION_ID)
/

------------------------------------------------------------------------------------------------------------------------
-- ANIME_TITLES

create table ANIME_TITLES
(
    ANIME_ID        NUMBER(12)   not null
        constraint PK_ANIME_TITLES
            primary key,
    ANIME_NAME      VARCHAR2(30) not null,
    DESCRIPTION     VARCHAR2(300),
    SUBSCRIPTION_ID NUMBER(12)
        constraint FK_ANIME_TI_REFERENCE_SUBSCRIP
            references SUBSCRIPTIONS,
    STUDIO_ID       NUMBER(12)
        constraint FK_ANIME_TI_REFERENCE_STUDIOS
            references STUDIOS
)
/

create bitmap index IDX_ANM_TTLS_STUDIO_ID
    on ANIME_TITLES (STUDIO_ID)
/

create bitmap index IDX_ANM_TTLS_SUBSCRIPTION_ID
    on ANIME_TITLES (SUBSCRIPTION_ID)
/

------------------------------------------------------------------------------------------------------------------------
-- PAYMENTS

create table PAYMENTS
(
    PAYMENT_ID   NUMBER(12)           not null,
    USER_ID      NUMBER(12),
    PAID_MONEY   NUMBER(15, 2)        not null,
    PAYMENT_DATE DATE default SYSDATE not null,
    constraint PK_PAYMENTS primary key (PAYMENT_ID)
)
    indexing on partition by range (PAYMENT_DATE) interval (NUMTOYMINTERVAL(1, 'MONTH'))
(
    partition pos_data_p1 values less than (TO_DATE('28-10-2022', 'DD-MM-YYYY')),
    partition pos_data_p2 values less than (TO_DATE('28-11-2022', 'DD-MM-YYYY'))
);
/

create bitmap index IDX_PMNTS_USER_ID on PAYMENTS (
                                            USER_ID ASC
    ) local parallel;
/

create bitmap index IDX_PAYMENT_MONTH on PAYMENTS(
                                          trunc(PAYMENT_DATE, 'MONTH') ASC
    ) local parallel;

create bitmap index IDX_PMNTS_USER_PAYMENT_ID on PAYMENTS (
                                                         USER_ID ASC,
                                                         PAYMENT_ID ASC
    ) local parallel;

alter table PAYMENTS
    add constraint FK_PAYMENTS_REFERENCE_USERS foreign key (USER_ID)
        references USERS (USER_ID);
/

create trigger TRIGGER_ADD_USER_MONEY
    after insert
    on PAYMENTS
    for each row
begin
    update USERS
    set USER_MONEY = USER_MONEY + :new.PAID_MONEY
    where USER_ID = :new.USER_ID;
end;
/

------------------------------------------------------------------------------------------------------------------------
-- ANIME_GENRES_RELATIONS

create table ANIME_GENRES_RELATIONS
(
    ANIME_ID NUMBER(12)
        constraint FK_ANIME_GE_REFERENCE_ANIME_TI
            references ANIME_TITLES,
    GENRE_ID NUMBER(12)
        constraint FK_ANIME_GE_REFERENCE_GENRES
            references GENRES
)
/

create bitmap index IDX_ANM_GNRS_RLTNS_ANIME_ID
    on ANIME_GENRES_RELATIONS (ANIME_ID)
/

create bitmap index IDX_ANM_GNRS_RLTNS_GENRE_ID
    on ANIME_GENRES_RELATIONS (GENRE_ID)
/

------------------------------------------------------------------------------------------------------------------------
-- COMMENTS

create table COMMENTS
(
    COMMENT_ID      NUMBER(12)           not null,
    USER_ID         NUMBER(12),
    ANIME_ID        NUMBER(12),
    COMMENT_CONTENT VARCHAR2(300),
    COMMENT_DATE    DATE default SYSDATE not null,
    constraint PK_COMMENTS primary key (COMMENT_ID)
)
    indexing on partition by range (COMMENT_DATE) interval (NUMTOYMINTERVAL(1, 'MONTH'))
(
    partition pos_data_p1 values less than (TO_DATE('28-10-2022', 'DD-MM-YYYY')),
    partition pos_data_p2 values less than (TO_DATE('28-11-2022', 'DD-MM-YYYY'))
);


create bitmap index IDX_CMNTS_USER_ID on COMMENTS (
                                                   USER_ID ASC
    ) local parallel;

create bitmap index IDX_CMNTS_ANIME_ID on COMMENTS (
                                                    ANIME_ID ASC
    ) local parallel;

create bitmap index IDX_COMMENT_MONTH on COMMENTS (
                                                   trunc(COMMENT_DATE, 'MONTH') ASC
    ) local parallel;

create bitmap index IDX_CMNTS_USER_ANIME_ID on COMMENTS (
                                                         USER_ID ASC,
                                                         ANIME_ID ASC
    ) local parallel;

alter table COMMENTS
    add constraint FK_COMMENTS_REFERENCE_USERS foreign key (USER_ID)
        references USERS (USER_ID);

alter table COMMENTS
    add constraint FK_COMMENTS_REFERENCE_ANIME_TI foreign key (ANIME_ID)
        references ANIME_TITLES (ANIME_ID);

------------------------------------------------------------------------------------------------------------------------
-- ANIME_USERS_RELATIONS

create table ANIME_USERS_RELATIONS
(
    USER_ID       NUMBER(12),
    ANIME_ID      NUMBER(12),
    RELATION_DATE DATE default SYSDATE
)
    indexing on partition by range (RELATION_DATE) interval (NUMTOYMINTERVAL(1, 'MONTH'))
(
    partition pos_data_p1 values less than (TO_DATE('28-10-2022', 'DD-MM-YYYY')),
    partition pos_data_p2 values less than (TO_DATE('28-11-2022', 'DD-MM-YYYY'))
)
;


create bitmap index IDX_ANM_USRS_RLTNS_USER_ID on ANIME_USERS_RELATIONS (
                                                                         USER_ID ASC
    ) local parallel;


create bitmap index IDX_ANM_USRS_RLTNS_ANIME_ID on ANIME_USERS_RELATIONS (
                                                                          ANIME_ID ASC
    ) local parallel;

create bitmap index IDX_A_U_RLTNS_USER_ANIME_ID on ANIME_USERS_RELATIONS (
                                                                          USER_ID ASC,
                                                                          ANIME_ID ASC
    ) local parallel;

alter table ANIME_USERS_RELATIONS
    add constraint FK_ANIME_US_REFERENCE_ANIME_TI foreign key (ANIME_ID)
        references ANIME_TITLES (ANIME_ID);

alter table ANIME_USERS_RELATIONS
    add constraint FK_ANIME_US_REFERENCE_USERS foreign key (USER_ID)
        references USERS (USER_ID);

