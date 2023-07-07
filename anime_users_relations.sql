alter table ANIME_USERS_RELATIONS
    drop constraint FK_ANIME_US_REFERENCE_ANIME_TI;

alter table ANIME_USERS_RELATIONS
    drop constraint FK_ANIME_US_REFERENCE_USERS;

drop index IDX_ANM_USRS_RLTNS_ANIME_ID;

drop index IDX_ANM_USRS_RLTNS_USER_ID;

drop index IDX_A_U_RLTNS_USER_ANIME_ID;


drop table ANIME_USERS_RELATIONS cascade constraints;


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
    ) local parallel nologging;


create bitmap index IDX_ANM_USRS_RLTNS_ANIME_ID on ANIME_USERS_RELATIONS (
                                                                          ANIME_ID ASC
    ) local parallel nologging;

create bitmap index IDX_A_U_RLTNS_USER_ANIME_ID on ANIME_USERS_RELATIONS (
                                                                          USER_ID ASC,
                                                                          ANIME_ID ASC
    ) local parallel nologging;

alter table ANIME_USERS_RELATIONS
    add constraint FK_ANIME_US_REFERENCE_ANIME_TI foreign key (ANIME_ID)
        references ANIME_TITLES (ANIME_ID);

alter table ANIME_USERS_RELATIONS
    add constraint FK_ANIME_US_REFERENCE_USERS foreign key (USER_ID)
        references USERS (USER_ID);
