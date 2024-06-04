
** Solution 

    WITH C as

                    (SELECT *, '01' as table_name
                                    FROM PD2023_WK04_JANUARY
                            UNION ALL
                    SELECT *, '02' as table_name
                                    FROM PD2023_WK04_FEBRUARY

                            UNION ALL
                    SELECT *, '03' as table_name
                                    FROM PD2023_WK04_MARCH

                            UNION ALL
                    SELECT *, '04' as table_name
                                    FROM PD2023_WK04_APRIL

                            UNION ALL
                    SELECT *, '05' as table_name
                                    FROM PD2023_WK04_MAY

                            UNION ALL
                    SELECT *, '06' as table_name
                                    FROM PD2023_WK04_JUNE

                            UNION ALL
                    SELECT *, '07' as table_name
                                    FROM PD2023_WK04_JULY
                            UNION ALL
                    SELECT *, '08' as table_name
                                    FROM PD2023_WK04_AUGUST

                            UNION ALL
                    SELECT *, '09' as table_name
                                    FROM PD2023_WK04_SEPTEMBER

                            UNION ALL
                    SELECT *, '10' as table_name
                                    FROM PD2023_WK04_OCTOBER
                            UNION ALL
                    SELECT *, '11' as table_name
                                    FROM PD2023_WK04_NOVEMBER
                            UNION ALL
                    SELECT *, '12' as table_name
                                    FROM PD2023_WK04_DECEMBER
                    ),

            Pre As (
                    SELECT   ID,
                            date_from_parts(2023, DATE_PART('month', Date(table_name, 'Auto')), Joining_Day) as Joining_date,
                            demographic, value
                                    FROM C ),

            POST AS(

                    SELECT
                            ID,
                            Joining_date,
                            ethnicity, account_type,
                            date_of_birth :: DATE as date_of_birth,
                                ROW_NUMBER() OVER (PARTITION BY ID ORDER BY Joining_date) as rn
                                    FROM PRE

                                        PIVOT (MAX(Value) FOR Demographic IN ('Ethnicity', 'Account Type', 'Date of Birth')) As P
                                                    (ID, Joining_date, ethnicity,account_type, date_of_birth)
)

   
                    SELECT ID,
                            Joining_date,
                            ethnicity, 
                            account_type,
                            date_of_birth
                                    FROM POST
                                        where rn = 1 ;
