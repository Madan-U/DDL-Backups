-- Object: PROCEDURE citrus_usr.pr_holding_migration
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec  pr_holding_migration 'D:\Files for migration\DP57\dpc9 dt 31 march 2011\08DPC9U.672011'    
CREATE proc [citrus_usr].[pr_holding_migration](@pa_path varchar(8000))    
as    
begin     
    
    DECLARE @@L_COUNT INTEGER      
       truncate table TMP_dpc9_SOURCE      
      
       DECLARE @@SSQL VARCHAR(8000)      
       SET @@SSQL ='BULK INSERT TMP_dpc9_SOURCE FROM ''' + @pa_path + ''' WITH       
       (      
           FIELDTERMINATOR = ''\n'',      
           ROWTERMINATOR = ''\n''      
      
       )'      
      
       EXEC(@@SSQL)    
    
   CREATE TABLE #TMP_DPC9    
  (    
   ID             INT IDENTITY(1,1) NOT NULL,     
   ORG_DETAILS    VARCHAR(8000),     
   MOD_DETAILS    VARCHAR(800),     
   ISIN           VARCHAR(50),    
   BOID           VARCHAR(16) ,    
   target_set_no varchar(50)    
  )    
    
  CREATE CLUSTERED INDEX [indx_id] ON [dbo].[#TMP_DPC9]     
  (    
   [ID] ASC, isin ,BOID     
  )    
    
    
   DELETE FROM TMP_dpc9_SOURCE     
      WHERE  details NOT LIKE '01%'    
         AND details NOT LIKE '02%'    
         AND details NOT LIKE '04%'    
         AND details NOT LIKE '07%'    
   AND details NOT LIKE '06%'    
    
    
          
   INSERT INTO #TMP_DPC9     
   SELECT ORG_DETAILS = DETAILS,    
    DETAILS = DETAILS ,     
   ISIN = (CASE     
                   WHEN DETAILS LIKE '02%' THEN  citrus_usr.fn_splitval_by(DETAILS,2,'~')  + '~' + citrus_usr.fn_splitval_by(DETAILS,3,'~')    
                   ELSE ''    
                 END),    
    BOID = (CASE WHEN DETAILS LIKE '01%' THEN SUBSTRING(DETAILS,10,16) ELSE '' END),    
    target_set_no  = citrus_usr.fn_splitval_by(DETAILS,7,'~')    
   FROM   TMP_dpc9_SOURCE     
    
  UPDATE #TMP_DPC9     
  SET    #TMP_DPC9.MOD_DETAILS = #TMP_DPC9.MOD_DETAILS + '~' + T.BOID     
  FROM   (SELECT ID,     
     BOID    
     FROM   #TMP_DPC9    
     WHERE  BOID <> '') T     
  WHERE  T.ID = (SELECT TOP 1 ID    
      FROM   #TMP_DPC9 S    
      WHERE  S.ID < #TMP_DPC9.ID    
      AND S.BOID <> ''    
      ORDER BY 1 DESC)    
     AND (left(#TMP_DPC9.MOD_DETAILS,2) = '07')    
    
      
  UPDATE #TMP_DPC9     
  SET    #TMP_DPC9.MOD_DETAILS = #TMP_DPC9.MOD_DETAILS + '~' + T.ISIN     
  FROM   (SELECT ID,     
     ISIN    
     FROM   #TMP_DPC9    
     WHERE  ISIN <> '') T     
  WHERE  T.ID = (SELECT TOP 1 ID    
      FROM   #TMP_DPC9 S    
      WHERE  S.ID < #TMP_DPC9.ID    
      AND S.ISIN <> ''    
      ORDER BY 1 DESC)    
     AND (left(#TMP_DPC9.MOD_DETAILS,2) = '06')    
    
  UPDATE #TMP_DPC9     
  SET    #TMP_DPC9.MOD_DETAILS = #TMP_DPC9.MOD_DETAILS + '~' + T.BOID     
  FROM   (SELECT ID,     
     BOID    
     FROM   #TMP_DPC9    
     WHERE  BOID <> '') T     
  WHERE  T.ID = (SELECT TOP 1 ID    
      FROM   #TMP_DPC9 S    
      WHERE  S.ID < #TMP_DPC9.ID    
      AND S.BOID <> ''    
      ORDER BY 1 DESC)    
     AND (left(#TMP_DPC9.MOD_DETAILS,2) = '06')    
    
  
      --dp_daily_hldg_cdsl    
  --07~INE400H01019~ADHUNIK METALIK - EQ~500.000~0.000~0.000~500.000~0.000~0.000~0.000~0.000~0.000~0N0~~1201090400000014    
   insert into dp_daily_hldg_cdsl    
   select dpam_dpm_id ,dpam_id ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,2,'~')       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,4,'~')       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,7,'~')       
  ,0    
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,6,'~')       
  ,0,0,0  
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,5,'~')       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,8,'~')  
  ,0       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,9,'~')       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,11,'~')       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,10,'~')       
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,12,'~')   
  ,'JUL 31 2011'    
  ,'MIG'    
  ,getdate()    
  ,'MIG'    
  ,getdate()    
  ,1    
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,14,'~')   , null     
   from #TMP_DPC9,dp_acct_mstr 
   where dpam_sba_no = citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,15,'~') 
   and left(#TMP_DPC9.MOD_DETAILS,2) in ('07')    
     
    
    
    
  insert into dp_daily_hldg_cdsl    
   select dpam_dpm_id ,dpam_id ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,6,'~')       
  ,0     
  ,0    
  ,0    
  ,0    
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,5,'~')    
  ,0        
  ,0    
  ,0       
  ,0    
  ,0        
  ,0    
  ,0       
  ,0    
  ,0  
  ,'JUL 31 2011'    
  ,'MIG'    
  ,getdate()    
  ,'MIG'    
  ,getdate()    
  ,1    
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,14,'~')   , null      
  from #TMP_DPC9,dp_acct_mstr where dpam_sba_no = citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,8,'~') and left(#TMP_DPC9.MOD_DETAILS,2) in ('06') and #TMP_DPC9.MOD_DETAILS like '%DEMAT PENDING%'    
  
  insert into dp_daily_hldg_cdsl    
   select dpam_dpm_id ,dpam_id ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,6,'~')       
  ,0     
  ,0    
  ,0    
  ,0    
  ,0  
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,5,'~')          
  ,0    
  ,0       
  ,0    
  ,0        
  ,0    
  ,0       
  ,0    
  ,0  
  ,'JUL 31 2011'    
  ,'MIG'    
  ,getdate()    
  ,'MIG'    
  ,getdate()    
  ,1    
  ,citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,14,'~')   , null    
  from #TMP_DPC9,dp_acct_mstr where dpam_sba_no = citrus_usr.fn_splitval_by(#TMP_DPC9.MOD_DETAILS,8,'~')     
  and left(#TMP_DPC9.MOD_DETAILS,2) in ('06') and #TMP_DPC9.MOD_DETAILS like '%REMAT PENDING%'    
    
     
    
end

GO
