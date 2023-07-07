drop trigger TRIGGER_ADD_USER_MONEY;
/

alter table PAYMENTS
    drop constraint FK_PAYMENTS_REFERENCE_USERS;
/

drop index IDX_PMNTS_USER_ID;
/

drop index IDX_PAYMENT_MONTH;

drop index IDX_PMNTS_USER_PAYMENT_ID;


drop table PAYMENTS cascade constraints;
/

/*==============================================================*/
/* Table: PAYMENTS                                              */
/*==============================================================*/
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
    ) local parallel nologging;
/

create bitmap index IDX_PAYMENT_MONTH on PAYMENTS(
                                          trunc(PAYMENT_DATE, 'MONTH') ASC
    ) local parallel nologging;

create bitmap index IDX_PMNTS_USER_PAYMENT_ID on PAYMENTS (
                                                         USER_ID ASC,
                                                         PAYMENT_ID ASC
    ) local parallel nologging;

alter table PAYMENTS
    add constraint FK_PAYMENTS_REFERENCE_USERS foreign key (USER_ID)
        references USERS (USER_ID);
/


create or replace trigger TRIGGER_ADD_USER_MONEY
    after insert
    on PAYMENTS
    for each row
begin
    update USERS
    set USER_MONEY = USER_MONEY + :new.PAID_MONEY
    where USER_ID = :new.USER_ID;
end;

/
