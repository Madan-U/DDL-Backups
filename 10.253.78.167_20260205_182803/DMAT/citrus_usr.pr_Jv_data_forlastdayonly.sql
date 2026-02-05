-- Object: PROCEDURE citrus_usr.pr_Jv_data_forlastdayonly
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc  [citrus_usr].[pr_Jv_data_forlastdayonly]
as 
begin
declare @pa_date datetime 
select @pa_date = MAX (run_date) from csv_output_log order by 1 desc 
---print @pa_date
 
 SELECT CONVERT (VARCHAR (11), FROMDT,103 ) FROMDT ,CONVERT (VARCHAR (11), FROMDT,103 ) TODT , CLTCODE , DRCR , DPAM_SBA_NO , 
 CASE WHEN CHARGE_NAME = 'AMC' THEN 'DEMAT ACCOUNT MONTHLY MAINTENANCE CHARGES' + ' DT : ' + CONVERT(VARCHAR(11),CHARGE_NAME_DT ,109)
 WHEN  CHARGE_NAME = 'PLEDGE' THEN 'CHARGES FOR PLEDGING/UNPLEDGING SHARES'  + ' DT : ' + CONVERT(VARCHAR(11),CHARGE_NAME_DT ,109)
 WHEN CHARGE_NAME = 'NORMAL TRX' THEN 'CHARGES FOR SELLING/TRANSFER OF SHARES FROM YOUR DEMAT A/C'  + ' DT : ' + CONVERT(VARCHAR(11),CHARGE_NAME_DT ,109)
 ELSE CHARGE_NAME END  CHARGE_NAME, AMOUNT,RUN_DATE
    FROM CSV_OUTPUT_LOG  WHERE RUN_DATE =  @pa_date
    
end

GO
