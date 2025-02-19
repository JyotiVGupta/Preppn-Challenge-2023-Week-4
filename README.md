# Preppn-Challenge-2023-Week-4

Solving Tableau Prep challenge 2023 Week 4 using SQL/Snowflake

**TASK**

2023 Week 4 - Data Source Bank acquires new customers every month. They are stored in separate tabs of an Excel workbook. We'd like to consolidate all the months into one dataset, to do comparisons between months.

- Stack the tables on top of one another i.e. Union them all.

- Make a Joining Date field based on the Joining Day, Table Names and the year 2023.

- Reshape the data so there is a field for each demographic, for each new customer.

- Remove duplicates.

**SQL/Snowflake Techniques Used**

1.  Common Table Expressions
2.  Pivot and column type-conversion
3.  UNION ALL
4.  Removing Duplicates

## Solution

### 1. Union the Tables

As all the tables had same fields, I used UNION ALL to union the tables. I created an extra column called 'table name' and record the month number the table belonged to in this column. I stored this new table in

```
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

)
```

### 2. Creating Joining date and Reshaping the data

Used Date_Part to create th date from the three columns (2023, Table name and Joining Day). Then Pivoted the data using CTE and PIVOT function

```
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
```

### 3. Removing the duplicates

In the Post CTE, I created a column 'rn' which gives a row number for each row restarting at every ID. That means for duplicate IDs row number will be 1, 2,.. and so on while for Distinct IDs it will be just 1. To remove duplicate rows, simply keep rows with rn=1

```
                     SELECT ID,
                            Joining_date,
                            ethnicity,
                            account_type,
                            date_of_birth
                                    FROM POST
                                        where rn = 1 ;

```

The output:

<img src= 'Output/Output.png' width = '600'>
