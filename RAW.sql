--"Previous WK Data"
SELECT "Date",SYMBOL , "Close" FROM MARKET.T1 t 
WHERE "Date" < (SELECT TO_CHAR(SYSDATE - 7, 'YYYY-MM-DD') FROM dual) 
AND "Date" > (SELECT TO_CHAR(SYSDATE - 14, 'YYYY-MM-DD') FROM dual);


-- Month  max
SELECT SYMBOL,MAX("Close") as prev_mon_max_close,MAX(Volume) AS prev_mon_max_volume FROM MARKET.T1 t 
WHERE SUBSTR("Date",6,2) = (SELECT TO_CHAR(SYSDATE-30 , 'mm') FROM SYS.DUAL )
GROUP BY SYMBOL ;

SELECT TO_CHAR(SYSDATE-30 , 'mm') FROM SYS.DUAL ; 
SELECT SUBSTR("Date",6,2) FROM MARKET.T1 t ;
SELECT * FROM MARKET.T1 t WHERE SUBSTR("Date",6,2)='05' AND SYMBOL = '20MICRONS' ORDER BY "Close" DESC 

--CURRENT DAY
SELECT SYMBOL ,"Close" FROM MARKET.T1 t WHERE "Date" = (SELECT TO_CHAR(SYSDATE-1, 'YYYY-MM-DD') FROM dual);

SELECT PREV_MON.SYMBOL,
PREV_MON.prev_mon_max_close,CURR_D."Close",
PREV_MON.prev_mon_max_volume,CURR_D.Volume,
CASE WHEN PREV_MON.prev_mon_max_close >= CURR_D."Close" THEN 0 ELSE 1 END AS Close_month_breakout,
CASE WHEN PREV_MON.prev_mon_max_volume >= CURR_D.Volume THEN 0 ELSE 1 END AS Volume_month_breakout
FROM 
(SELECT SYMBOL,MAX("Close") as prev_mon_max_close,MAX(Volume) AS prev_mon_max_volume FROM MARKET.T1 t 
WHERE SUBSTR("Date",6,2) = (SELECT TO_CHAR(SYSDATE-30 , 'mm') FROM SYS.DUAL )
GROUP BY SYMBOL ) PREV_MON
INNER JOIN 
(SELECT SYMBOL ,"Close",Volume FROM MARKET.T1 t WHERE "Date" = (SELECT TO_CHAR(SYSDATE-1, 'YYYY-MM-DD') FROM dual)) CURR_D
ON PREV_MON.SYMBOL = CURR_D.SYMBOL;


DROP VIEW MARKET.MONTHLY_BREAKOUT ;
CREATE OR REPLACE VIEW MARKET.v_prev_monthly_breakout AS 
SELECT DISTINCT PREV_MON.SYMBOL,
PREV_MON.prev_mon_max_close,CURR_D.curr_mon_max_cls,
PREV_MON.prev_mon_max_volume,CURR_D.curr_mon_max_vol,
CASE WHEN PREV_MON.prev_mon_max_close >= CURR_D.curr_mon_max_cls THEN 0 ELSE 1 END AS Close_month_breakout,
CASE WHEN PREV_MON.prev_mon_max_volume >= CURR_D.curr_mon_max_vol THEN 0 ELSE 1 END AS Volume_month_breakout
FROM 
(SELECT SYMBOL,MAX("Close") as prev_mon_max_close,MAX(Volume) AS prev_mon_max_volume FROM MARKET.T1 t 
WHERE SUBSTR("Date",6,2) = (SELECT TO_CHAR(SYSDATE-30 , 'mm') FROM SYS.DUAL )
GROUP BY SYMBOL ) PREV_MON
INNER JOIN 
(SELECT DISTINCT 
curr_m.SYMBOL AS SYMBOL ,
curr_m.curr_mon_max_close AS curr_mon_max_close,CURR_D."Close" AS today_close,
curr_m.curr_mon_max_volume AS curr_mon_max_volume,CURR_D.Volume AS today_volume,
CASE WHEN curr_m.curr_mon_max_close >= CURR_D."Close" THEN curr_m.curr_mon_max_close ELSE CURR_D."Close" END AS curr_mon_max_cls,
CASE WHEN curr_m.curr_mon_max_volume >= CURR_D.Volume THEN curr_mon_max_volume ELSE CURR_D.Volume END AS curr_mon_max_vol
FROM 
(SELECT SYMBOL,MAX("Close") as curr_mon_max_close,MAX(Volume) AS curr_mon_max_volume FROM MARKET.T1 t 
WHERE SUBSTR("Date",6,2) = (SELECT TO_CHAR(SYSDATE-1 , 'mm') FROM SYS.DUAL ) AND 
"Date" <> (SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual)
GROUP BY SYMBOL ) curr_m
INNER JOIN 
(SELECT SYMBOL ,"Close",Volume FROM MARKET.T1 t WHERE "Date" = (SELECT TO_CHAR(SYSDATE-1, 'YYYY-MM-DD') FROM dual)) CURR_D
ON curr_m.SYMBOL = CURR_D.SYMBOL) CURR_D
ON PREV_MON.SYMBOL = CURR_D.SYMBOL;


SELECT * FROM MARKET.MONTHLY_BREAKOUT mb WHERE CLOSE_MONTH_BREAKOUT =1 AND VOLUME_MONTH_BREAKOUT =1

SELECT * FROM MARKET.T1 t WHERE "Date" = (SELECT TO_CHAR(SYSDATE-1, 'YYYY-MM-DD') FROM dual)

DROP VIEW MARKET.CURRENT_MONTH_BREAKOUT ;

CREATE OR REPLACE VIEW MARKET.v_Current_Month_breakout AS 
SELECT DISTINCT 
curr_m.SYMBOL AS SYMBOL ,
curr_m.curr_mon_max_close AS curr_mon_max_close,CURR_D."Close" AS today_close,
curr_m.curr_mon_max_volume AS curr_mon_max_volume,CURR_D.Volume AS today_volume,
CASE WHEN curr_m.curr_mon_max_close >= CURR_D."Close" THEN 0 ELSE 1 END AS curr_mon_Close_bo,
CASE WHEN curr_m.curr_mon_max_volume >= CURR_D.Volume THEN 0 ELSE 1 END AS curr_mon_Volume_bo
FROM 
(SELECT SYMBOL,MAX("Close") as curr_mon_max_close,MAX(Volume) AS curr_mon_max_volume FROM MARKET.T1 t 
WHERE SUBSTR("Date",6,2) = (SELECT TO_CHAR(SYSDATE , 'mm') FROM SYS.DUAL ) AND 
"Date" <> (SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual)
GROUP BY SYMBOL ) curr_m
INNER JOIN 
(SELECT SYMBOL ,"Close",Volume FROM MARKET.T1 t WHERE "Date" = (SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual)) CURR_D
ON curr_m.SYMBOL = CURR_D.SYMBOL;

CREATE TABLE MARKET.t_CURRENT_MONTH_BREAKOUT AS SELECT * FROM MARKET.V_CURRENT_MONTH_BREAKOUT vcmb ;


SELECT * FROM MARKET.T_CURRENT_MONTH_BREAKOUT tcmb WHERE CURR_MON_CLOSE_BO =1 AND CURR_MON_VOLUME_BO =1;

SELECT * FROM (
SELECT SYMBOL , AVG("in-uptrend") avgg FROM (
SELECT DISTINCT * FROM MARKET.T1 t 
WHERE --"Date" =  (SELECT TO_CHAR(SYSDATE-1, 'YYYY-MM-DD') FROM dual) AND 
"Date" > (SELECT TO_CHAR(SYSDATE-10, 'YYYY-MM-DD') FROM dual)
) GROUP BY SYMBOL 
) WHERE avgg NOT IN (0,1) ORDER BY avgg ASC 
;

SELECT SYMBOL ,count("in-uptrend") AS cnt1 FROM MARKET.T1 t WHERE "in-uptrend" = 1 AND "Date" > (SELECT TO_CHAR(SYSDATE-10, 'YYYY-MM-DD') FROM dual) GROUP BY SYMBOL ;
SELECT SYMBOL ,count("in-uptrend") AS cnt0 FROM MARKET.T1 t WHERE "in-uptrend" = 0 AND "Date" > (SELECT TO_CHAR(SYSDATE-10, 'YYYY-MM-DD') FROM dual) GROUP BY SYMBOL ;




