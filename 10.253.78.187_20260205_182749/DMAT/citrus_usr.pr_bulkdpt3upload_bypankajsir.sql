-- Object: PROCEDURE citrus_usr.pr_bulkdpt3upload_bypankajsir
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE  proc [citrus_usr].[pr_bulkdpt3upload_bypankajsir](@pa_file_path varchar(200),@PA_LOGIN_NAME varchar(50),@pa_ref_cur varchar(8000) output)                      
as                      
begin                      
                  
declare @@SSQL varchar(1000) 
              
--print 'pankaj'


truncate table  DPT3_TMP_DUMP                      
SET @@SSQL = 'BULK INSERT DPT3_TMP_DUMP FROM ''' + @pa_file_path +  ''' WITH                      
                   
    (                      
      FIELDTERMINATOR=''\n'',                      
      ROWTERMINATOR = ''\n''
    )'   
EXEC(@@SSQL) 

    
truncate table DPT3_TMP

insert into DPT3_TMP
(
DPT3T_IDENTIFIER,
DPT3T_EDIS_TXN_TYPE,
DPT3T_EDIS_TXN_STATUS,
DPT3T_BO_ID,
DPT3T_ISIN,
DPT3T_EX_ID,
DPT3T_CM_ID,
DPT3T_TXN_ID,
DPT3T_TXN_TIME,
DPT3T_TXN_QUANTITY,
DPT3T_TOT_LOCKED_QTY,
DPT3T_PENDING_QTY,
DPT3T_COUNTER_BOID,
DPT3T_EXEC_DATE,
DPT3T_SETTLE_ID,
DPT3T_VALIDITY_DAYS
)
select 
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,1,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,2,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,3,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,4,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,5,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,6,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,7,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,8,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,9,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,10,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,11,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,12,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,13,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,14,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,15,'~'),
citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,16,'~')
from DPT3_TMP_DUMP
where DPT3_VALUE is not null
and citrus_usr.FN_SPLITVAL_BY(DPT3_VALUE,1,'~') <> 'T'

 
--DELETE FROM DPT3_TMP                      
--SET @@SSQL = 'BULK INSERT DPT3_TMP FROM ''' + @pa_file_path +  ''' WITH                      
                   
--    (                      
--      FIELDTERMINATOR=''~'',                      
--      ROWTERMINATOR = ''\n''
--    )'   
--    --print   @@SSQL                
--EXEC(@@SSQL)                      
                    
--select * from DPT3_TMP
 
 
 
 
 
--SELECT 
--DPT3T_IDENTIFIER,
--DPT3T_EDIS_TXN_TYPE,
--DPT3T_EDIS_TXN_STATUS,
--DPT3T_BO_ID,
--DPT3T_ISIN,
--DPT3T_EX_ID,
--DPT3T_CM_ID,
--DPT3T_TXN_ID,
--DPT3T_TXN_TIME,
--DPT3T_TXN_QUANTITY,
--DPT3T_TOT_LOCKED_QTY,
--DPT3T_PENDING_QTY,
--DPT3T_COUNTER_BOID,
--DPT3T_EXEC_DATE,
--DPT3T_SETTLE_ID,
--DPT3T_VALIDITY_DAYS,
--@PA_LOGIN_NAME,
--getdate(),
--@PA_LOGIN_NAME,
--getdate(),
--'1'
-- FROM DPT3_TMP
-- WHERE NOT EXISTS (SELECT 1 FROM DPT3_MSTR 
--							WHERE ltrim(rtrim(DPT3T_BO_ID))=ltrim(rtrim(DPT3_BO_ID  ))
--							AND ltrim(rtrim(DPT3T_EDIS_TXN_TYPE))= ltrim(rtrim(DPT3_EDIS_TXN_TYPE  ))
--							AND ltrim(rtrim(DPT3T_EDIS_TXN_STATUS))=ltrim(rtrim(DPT3_EDIS_TXN_STATUS ))
--							AND ltrim(rtrim(DPT3T_ISIN))=ltrim(rtrim(DPT3_ISIN))
--							AND ltrim(rtrim(DPT3T_CM_ID)) = ltrim(rtrim(DPT3_CM_ID))
--							AND ltrim(rtrim(DPT3T_TXN_ID)) = ltrim(rtrim(DPT3_TXN_ID))
--							AND ltrim(rtrim(DPT3T_TXN_TIME)) = ltrim(rtrim(DPT3_TXN_TIME))
--							AND ltrim(rtrim(DPT3T_TXN_QUANTITY ))= ltrim(rtrim(DPT3_TXN_QUANTITY))
--							AND ltrim(rtrim(DPT3T_TOT_LOCKED_QTY)) = ltrim(rtrim(DPT3_TOT_LOCKED_QTY))
--							AND ltrim(rtrim(DPT3T_PENDING_QTY ))= ltrim(rtrim(DPT3_PENDING_QTY))
--							 AND ltrim(rtrim(isnull (DPT3T_COUNTER_BOID,''))) = ltrim(rtrim(isnull(DPT3_COUNTER_BOID,'')))
--							AND ltrim(rtrim(isnull(DPT3T_EXEC_DATE,''))) = ltrim(rtrim(isnull(DPT3_EXEC_DATE,'')))
--							AND ltrim(rtrim(isnull(DPT3T_SETTLE_ID,'') ))= ltrim(rtrim(isnull(DPT3_SETTLE_Id,'')))
--							AND ltrim(rtrim(isnull(DPT3T_VALIDITY_DAYS,'0'))) = ltrim(rtrim(isnull(DPT3_VALIDITY_DAYS,'0')))
--					)                
                      
-- select * FROM DPT3_TMP
-- return

INSERT INTO DPT3_MSTR
SELECT 
DPT3T_IDENTIFIER,
DPT3T_EDIS_TXN_TYPE,
DPT3T_EDIS_TXN_STATUS,
DPT3T_BO_ID,
DPT3T_ISIN,
DPT3T_EX_ID,
DPT3T_CM_ID,
DPT3T_TXN_ID,
DPT3T_TXN_TIME,
DPT3T_TXN_QUANTITY,
DPT3T_TOT_LOCKED_QTY,
DPT3T_PENDING_QTY,
DPT3T_COUNTER_BOID,
DPT3T_EXEC_DATE,
DPT3T_SETTLE_ID,
DPT3T_VALIDITY_DAYS,
@PA_LOGIN_NAME,
getdate(),
@PA_LOGIN_NAME,
getdate(),
'1'
 FROM DPT3_TMP
 WHERE NOT EXISTS (SELECT 1 FROM DPT3_MSTR 
							WHERE ltrim(rtrim(DPT3T_BO_ID))= ltrim(rtrim(DPT3_BO_ID  ))
							AND ltrim(rtrim(DPT3T_EDIS_TXN_TYPE))= ltrim(rtrim(DPT3_EDIS_TXN_TYPE  ))
							AND ltrim(rtrim(DPT3T_EDIS_TXN_STATUS))=ltrim(rtrim(DPT3_EDIS_TXN_STATUS ))
							AND ltrim(rtrim(DPT3T_ISIN))=ltrim(rtrim(DPT3_ISIN))
							AND ltrim(rtrim(DPT3T_CM_ID)) = ltrim(rtrim(DPT3_CM_ID))
							AND ltrim(rtrim(DPT3T_TXN_ID)) = ltrim(rtrim(DPT3_TXN_ID))
							AND ltrim(rtrim(DPT3T_TXN_TIME)) = ltrim(rtrim(DPT3_TXN_TIME))
							AND ltrim(rtrim(DPT3T_TXN_QUANTITY ))= ltrim(rtrim(DPT3_TXN_QUANTITY))
							AND ltrim(rtrim(DPT3T_TOT_LOCKED_QTY)) = ltrim(rtrim(DPT3_TOT_LOCKED_QTY))
							AND ltrim(rtrim(DPT3T_PENDING_QTY ))= ltrim(rtrim(DPT3_PENDING_QTY))
							 AND ltrim(rtrim(isnull (DPT3T_COUNTER_BOID,''))) = ltrim(rtrim(isnull(DPT3_COUNTER_BOID,'')))
							AND ltrim(rtrim(isnull(DPT3T_EXEC_DATE,''))) = ltrim(rtrim(isnull(DPT3_EXEC_DATE,'')))
							AND ltrim(rtrim(isnull(DPT3T_SETTLE_ID,'') ))= ltrim(rtrim(isnull(DPT3_SETTLE_Id,'')))
							AND ltrim(rtrim(isnull(DPT3T_VALIDITY_DAYS,'0'))) = ltrim(rtrim(isnull(DPT3_VALIDITY_DAYS,'0')))
					)                
                      
                      
                      
--TRUNCATE TABLE DPT3_TMP                      
                      
                      
end

GO
