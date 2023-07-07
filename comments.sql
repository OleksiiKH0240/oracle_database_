-- drop index IDX_COMMENT_DATE;

drop index IDX_CMNTS_ANIME_ID;

drop index IDX_CMNTS_USER_ID;

drop index IDX_COMMENT_MONTH;

drop index IDX_CMNTS_USER_ANIME_ID;

drop table COMMENTS cascade constraints;


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
-- indexing on partition by list (ANIME_ID) automatic
-- (
--     partition test_partition VALUES (-1)
-- );


create bitmap index IDX_CMNTS_USER_ID on COMMENTS (
                                                   USER_ID ASC
    ) local parallel nologging;

create bitmap index IDX_CMNTS_ANIME_ID on COMMENTS (
                                                    ANIME_ID ASC
    ) local parallel nologging;

create bitmap index IDX_COMMENT_MONTH on COMMENTS (
                                                   trunc(COMMENT_DATE, 'MONTH') ASC
    ) local parallel nologging;

create bitmap index IDX_CMNTS_USER_ANIME_ID on COMMENTS (
                                                         USER_ID ASC,
                                                         ANIME_ID ASC
    ) local parallel nologging;

-- create index IDX_COMMENT_COMMENT_DATE on COMMENTS (
--                                                 COMMENT_DATE ASC
--     ) local parallel nologging;

alter table COMMENTS
    add constraint FK_COMMENTS_REFERENCE_USERS foreign key (USER_ID)
        references USERS (USER_ID);

alter table COMMENTS
    add constraint FK_COMMENTS_REFERENCE_ANIME_TI foreign key (ANIME_ID)
        references ANIME_TITLES (ANIME_ID);