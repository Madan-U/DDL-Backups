-- Object: PROCEDURE citrus_usr.pr_bulkdpt3upload
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE  proc [citrus_usr].[pr_bulkdpt3upload](@pa_file_path varchar(200),@PA_LOGIN_NAME varchar(50),@pa_ref_cur varchar(8000) output)                      
as                      
begin                      
                    
declare @@SSQL varchar(1000) 
              
              
--CREATE TABLE DPT3_TMP_VALUE (PREVAL VARCHAR(8000))

TRUNCATE TABLE DPT3_TMP_VALUE
DECLARE @@SSQL_PRE  VARCHAR(8000)

SET @@SSQL_PRE ='BULK INSERT DPT3_TMP_VALUE	 FROM ''' + @pa_file_path + ''' WITH 
(
FIELDTERMINATOR = ''\n'',
ROWTERMINATOR = ''\n''
)'

EXEC(@@SSQL_PRE)

TRUNCATE TABLE DPT3_TMP
INSERT INTO DPT3_TMP

SELECT 
CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	1	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	2	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	3	,'~'),
CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	4	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	5	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	6	,'~'),
CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	7	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	8	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	9	,'~'),
CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	10	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	11	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	12	,'~'),
CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	13	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	14	,'~'),CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	15	,'~'),
CITRUS_USR.FN_SPLITVAL_BY(PREVAL,	16	,'~')
FROM DPT3_TMP_VALUE WHERE PREVAL LIKE '1~%'
              
--print 'pankaj'
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
							WHERE ltrim(rtrim(DPT3T_BO_ID))=ltrim(rtrim(DPT3_BO_ID  ))
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
