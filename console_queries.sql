--1
-- вивести найпопулярніше аніме(яке має більше за всіх коментарів) в кожен місяць з проміжку (2022.12 - 2023.05) та
-- вивести жанри аніме, кількість коментарів за цей місяць, кількість різних людей, що коментували,
-- відношення кількості коментаторів,які дивилися аніме, до всіх коментаторів

select /*+ INDEX(anime_titles PK_ANIME_TITLES)*/ month,
                                                 to_char(month, 'YYYY, Month', 'NLS_DATE_LANGUAGE = English') year_month_name,
                                                 best_of_month.ANIME_ID,
                                                 anime_titles.ANIME_NAME,
                                                 best_of_month.anime_genres,
                                                 best_of_month.month_comments_number,
                                                 best_of_month.anime_comments_number,
                                                 best_of_month.unique_users_number,
                                                 best_of_month.watched_users_to_all_users_rate

from (select comments_mod2.*,
             sum(anime_comments_number) over (partition by month )                      month_comments_number,
             row_number() over (partition by month order by anime_comments_number desc) rank
      from (select comment_month                                     month,
                   comments_truncated_date.ANIME_ID,
                   listagg(distinct (genres.GENRE_NAME), ',')        anime_genres,
                   count(distinct (COMMENT_ID))                      anime_comments_number,
                   count(distinct (comments_truncated_date.USER_ID)) unique_users_number,
                   round(count(distinct (aur.USER_ID)) / count(distinct (comments_truncated_date.USER_ID)),
                         2)                                          watched_users_to_all_users_rate
            from (select /*+ INDEX(cmnts IDX_COMMENT_MONTH)*/ trunc(COMMENT_DATE, 'MONTH') comment_month, cmnts.*
                  from COMMENTS cmnts
                  where COMMENT_DATE between date '2022-12-01' and date '2023-05-01') comments_truncated_date
                     left join ANIME_USERS_RELATIONS aur
                               on aur.USER_ID = comments_truncated_date.USER_ID and
                                  aur.ANIME_ID = comments_truncated_date.ANIME_ID
                     join ANIME_GENRES_RELATIONS agr on agr.ANIME_ID = comments_truncated_date.ANIME_ID
                     join GENRES genres on genres.GENRE_ID = agr.GENRE_ID
            group by comment_month, comments_truncated_date.ANIME_ID) comments_mod2) best_of_month
         join ANIME_TITLES anime_titles on best_of_month.ANIME_ID = anime_titles.ANIME_ID
where rank = 1
order by to_date(month)
;


-- 2
-- знайти топ-3 найприбутковіших місяців з проміжку ('2022-12-01', '2023-06-01'),
-- вивести топ-3 популярних аніме(які мають більше за всіх коментарів) за ці місяці,
-- вивести кількість коментарів аніме за 3 місяці, кількість всіх коментарів за 3 місяці,
-- кількість грошей заплачених користувачами за 3 місяці,
-- кількість грошей заплачених користувачами за кожен з трьох місяців

select result_table.ANIME_ID,
       ANIME_NAME,
       result_table.anime_comments_number,
       result_table.anime_popularity_months,
       result_table.months_commnet_number,
       result_table.months_paid_money,
       result_table.all_months_money
from (select *
      from (select ANIME_ID,
                   count(COMMENT_ID) over ( partition by ANIME_ID )            anime_comments_number,
                   row_number() over (partition by ANIME_ID order by ANIME_ID) row_number,
                   listagg(distinct (to_char(comment_month, 'MonthYYYY', 'NLS_DATE_LANGUAGE = English')),
                           '|') over ( partition by ANIME_ID)                  anime_popularity_months,
                   count(COMMENT_ID) over ( )                                  months_commnet_number,
                   sum(distinct month_paid_money) over ( )                     months_paid_money,
                   listagg(distinct ((to_char(comment_month, 'MonthYYYY', 'NLS_DATE_LANGUAGE = English')) || ' paid ' ||
                                     to_char(month_paid_money) || 'hrn'),
                           ' | ') over ()                                      all_months_money


            from (select /*+ INDEX(cmnts IDX_COMMENT_MONTH)*/ trunc(COMMENT_DATE, 'MONTH') comment_month,
                                                              cmnts.*
                  from COMMENTS cmnts) comments_truncated_date
                     join (select /*+ INDEX(pmnts IDX_PAYMENT_MONTH)*/ trunc(PAYMENT_DATE, 'MONTH') payment_month,
                                                                       sum(PAID_MONEY)              month_paid_money
                           from PAYMENTS pmnts
                           where PAYMENT_DATE between date '2022-12-01' and date '2023-06-01'
                           group by trunc(PAYMENT_DATE, 'MONTH')
                           order by month_paid_money desc
                               fetch first 3 rows only) payments_truncated_date
                          on comment_month = payment_month
--       group by ANIME_ID
            order by anime_comments_number desc
--           fetch first 3 row only
           ) pre_result_table
      where row_number = 1
          fetch first 3 row only) result_table
         join ANIME_TITLES on result_table.ANIME_ID = ANIME_TITLES.ANIME_ID
;

-- 3
-- вивести топ-5 найпопулярніших жанрів(перетин жанрів найпопулярніших аніме) за кожний місяць
-- з проміжку ('2023-01-01', '2023-06-01'),
-- назву жанру,
-- кількість комментарів у всіх аніме з цим жанром, відсоток коментарів від чоловіків
--

select to_char(main_info_table.month, 'YYYY Month', 'NLS_DATE_LANGUAGE = English') month_str,
       main_info_table.GENRE_ID,
       GENRE_NAME,
       main_info_table.genre_comments_number,
       main_info_table.man_comments_percentage
from (select month,
             GENRE_ID,
             sum(anime_comments_number)                                                        genre_comments_number,
             round(sum(man_comments_number) / sum(anime_comments_number), 3)                   man_comments_percentage,
             row_number() over (partition by month order by count(anime_comments_number) desc) rank
      from (select comment_month                    month,
                   comments_truncated_date.ANIME_ID anime_id,
                   count(COMMENT_ID)                anime_comments_number,
                   sum(IS_MAN)                      man_comments_number
            from (select /*+ INDEX(cmnts IDX_COMMENT_MONTH)*/ trunc(COMMENT_DATE, 'MONTH') comment_month, cmnts.*
                  from COMMENTS cmnts
                  where COMMENT_DATE between date '2023-01-01' and date '2023-06-01') comments_truncated_date
                     join USERS on USERS.USER_ID = comments_truncated_date.USER_ID
            group by comment_month, comments_truncated_date.ANIME_ID) comments_mod2
               join ANIME_GENRES_RELATIONS agr on agr.ANIME_ID = comments_mod2.ANIME_ID
      group by month, GENRE_ID) main_info_table
         join GENRES genres on genres.GENRE_ID = main_info_table.GENRE_ID
where rank <= 5
order by month, rank
;

-- 4
-- вивести топ-5 найприбутковіших студій(студії у яких більше за все переглядів аніме за платними підписками) за весь час,
-- вивести ім'я студії, відносний дохід, відсоток чоловічих переглядів, кількість платних переглядів.

select /*+ INDEX(STUDIOS PK_STUDIOS)*/ STUDIO_NAME, top_studios.*
from (select /*+ INDEX_COMBINE(USERS)*/ STUDIO_ID,
                                        sum(PRICE)                                                   relatively_income,
                                        round(sum(IS_MAN) / count(ANIME_USERS_RELATIONS.USER_ID), 3) man_views_percentage,
                                        count(ANIME_USERS_RELATIONS.USER_ID)                         studio_paid_views
      from (select /*+ INDEX(ANIME_TITLES IDX_ANM_TTLS_SUBSCRIPTION_ID)*/ *
            from ANIME_TITLES
            where SUBSCRIPTION_ID > 0) paid_anime_titles
               join ANIME_USERS_RELATIONS on ANIME_USERS_RELATIONS.ANIME_ID = paid_anime_titles.ANIME_ID
               join USERS on ANIME_USERS_RELATIONS.USER_ID = USERS.USER_ID
               join SUBSCRIPTIONS on SUBSCRIPTIONS.SUBSCRIPTION_ID = paid_anime_titles.SUBSCRIPTION_ID
      group by STUDIO_ID
      order by relatively_income desc
          fetch first 5 rows only) top_studios
         join STUDIOS on top_studios.STUDIO_ID = STUDIOS.STUDIO_ID
;
;

-- 5
-- вивести топ-10 найактивніших користувачів(кількість коментарів + кількість платежів + кількість переглядів)
-- за певний період('2023-01-01', '2023-07-01'),
-- вивести ім'я користувача, стать користувача, відсоток коментарів, відсоток платежів, відсоток переглядів

select /*+ INDEX(USERS PK_USERS)*/USERS.USER_ID,
                                  USERS.USER_NAME,
                                  (case when IS_MAN = 1 then 'male' else 'female' end) sex,
                                  (comment_act_number + payment_act_number)            general_act_number,
                                  round(comment_act_number /
                                        (comment_act_number + payment_act_number + watch_act_number),
                                        3)                                             comment_act_percentage,
                                  round(payment_act_number /
                                        (comment_act_number + payment_act_number + watch_act_number),
                                        3)                                             payment_act_percentage,
                                  round(watch_act_number / (comment_act_number + payment_act_number + watch_act_number),
                                        3)                                             watch_act_percentage
from (select /*+ INDEX(COMMENTS IDX_CMNTS_USER_ANIME_ID)*/ USER_ID, count(COMMENT_ID) comment_act_number
      from COMMENTS
      where COMMENT_DATE between date '2023-01-01' and date '2023-07-01'
      group by USER_ID) user_comment_acts

         join (select /*+ INDEX(PAYMENTS IDX_PMNTS_USER_PAYMENT_ID)*/ USER_ID, count(PAYMENT_ID) payment_act_number
               from PAYMENTS
               where PAYMENT_DATE between date '2023-01-01' and date '2023-07-01'
               group by USER_ID) user_payment_acts on user_payment_acts.USER_ID = user_comment_acts.USER_ID
         join (select /*+ INDEX(ANIME_USERS_RELATIONS IDX_A_U_RLTNS_USER_ANIME_ID)*/ USER_ID,
                                                                                     count(ANIME_ID) watch_act_number
               from ANIME_USERS_RELATIONS
               where RELATION_DATE between date '2023-01-01' and date '2023-07-01'
               group by USER_ID) user_payment_acts on user_payment_acts.USER_ID = user_comment_acts.USER_ID
         join USERS on USERS.USER_ID = user_comment_acts.USER_ID
order by general_act_number desc
    fetch first 10 rows only
;
