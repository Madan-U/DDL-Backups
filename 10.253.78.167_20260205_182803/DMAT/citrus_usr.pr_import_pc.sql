-- Object: PROCEDURE citrus_usr.pr_import_pc
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



--[pr_import_dp] '','NSDL','21/12/2009','21/12/2009','N','76',3,'HO',''   
CREATE PROCeDURE [citrus_usr].[pr_import_pc](                   
                              @pa_exch          VARCHAR(20)  
											,@pa_login_name    VARCHAR(20)  
											,@pa_mode          VARCHAR(10)  																																
											,@pa_db_source     VARCHAR(250)  
											,@rowdelimiter     CHAR(4) =     '*|~*'    
											,@coldelimiter     CHAR(4) =     '|*~|'    
											,@pa_errmsg        VARCHAR(8000) output  
																			)               
AS                   
BEGIN                  
--    

INSERT INTO PIN_MSTR
(
PM_PIN_CODE,
PM_DISTRICT_CODE,
PM_DISTRICT_NAME,
PM_STATE_NAME,
PM_STATUS_FLAG,
PM_CREATED_BY,
PM_CREATED_DT,
PM_LST_UPD_BY,
PM_LST_UPD_DT,
PM_DELETED_IND
,PM_CITYREF_NO 

)         
select 
TMP_PIN_CODE,
TMP_DISTRICT_CODE,
TMP_DISTRICT_NAME,
TMP_STATE_NAME,
TMP_STATUS_FLAG,
@pa_login_name,
getdate(),
@pa_login_name,
GETDATE(),
1
,case when len(TMP_CITYREF_NO)='1' then '0'+TMP_CITYREF_NO else TMP_CITYREF_NO end 

from TMP_PIN_MSTR
where not exists (select PM_PIN_CODE from  PIN_MSTR where PM_PIN_CODE=TMP_PIN_CODE 
and case when len(TMP_CITYREF_NO)='1' then '0'+TMP_CITYREF_NO else TMP_CITYREF_NO end =PM_CITYREF_NO)   


UPDATE  T
SET PM_DISTRICT_CODE= TMP_DISTRICT_CODE,
PM_DISTRICT_NAME = TMP_DISTRICT_NAME,
PM_STATE_NAME = TMP_STATE_NAME,
PM_STATUS_FLAG = TMP_STATUS_FLAG,
PM_CITYREF_NO=case when len(TMP_CITYREF_NO)='1' then '0'+TMP_CITYREF_NO else TMP_CITYREF_NO end 
FROM 
 TMP_PIN_MSTR , PIN_MSTR T
WHERE tmp_PIN_CODE = PM_PIN_CODE and case when len(TMP_CITYREF_NO)='1' then '0'+TMP_CITYREF_NO else TMP_CITYREF_NO end =PM_CITYREF_NO


   
--                  
END

GO
