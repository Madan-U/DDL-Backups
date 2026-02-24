-- Object: PROCEDURE citrus_usr.PR_INS_CLOSING_MSTR_CDSL
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_CLOSING_MSTR_CDSL]   
(  
     @pa_login_name       VARCHAR(20)  
    ,@pa_closing_dt       VARCHAR(11)  
    ,@pa_mode             VARCHAR(10)  
    ,@pa_db_source        VARCHAR(250)  
    ,@pa_rowdelimiter     CHAR(4) =     '*|~*'      
    ,@pa_coldelimiter     CHAR(4) =     '|*~|'      
    ,@pa_errmsg           VARCHAR(8000) output   
)  
AS  
BEGIN  
--  
  DECLARE @prevclosingdate DATETIME  
         ,@max_closingdate DATETIME   
     
  IF @pa_mode ='BULK'  
  BEGIN  
  --  
    TRUNCATE TABLE TMP_CLOSING_PRICE_MSTR_CDSL 
    truncate table TMP_CLOSING_PRICE_MSTR_CDSL_SOURCE 
        
    DECLARE @@ssql varchar(8000)    
        
    SET @@ssql ='BULK INSERT TMP_CLOSING_PRICE_MSTR_CDSL_SOURCE  FROM ''' + @pa_db_source + ''' WITH     
    (    
         FIELDTERMINATOR = ''~'',    
         ROWTERMINATOR = ''0x0a''    
    )'    
  
    EXEC(@@ssql)    
    
    INSERT INTO TMP_CLOSING_PRICE_MSTR_CDSL
    SELECT distinct  CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') 
    , CITRUS_USR.FN_SPLITVAL_BY(VALUE,2,'~') 
    , convert(datetime,substring(CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),1,2) + '/' + substring(CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),3,2) + '/'+substring(CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),5,4),103)
    , CITRUS_USR.FN_SPLITVAL_BY(VALUE,4,'~') 
    FROM TMP_CLOSING_PRICE_MSTR_CDSL_SOURCE WHERE VALUE LIKE 'I%'
    
    
    Select top 1 @pa_closing_dt =convert(datetime,substring(CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~'),1,2) + '/' + substring(CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~'),3,2) + '/'+substring(CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~'),5,4),103) 
    FROM TMP_CLOSING_PRICE_MSTR_CDSL_SOURCE WHERE VALUE NOT LIKE 'I%'
  --  
  END     
     
  SELECT TOP 1 @prevclosingdate = CLOPM_DT  
  FROM  CLOSING_PRICE_MSTR_CDSL   
  WHERE CLOPM_DT < CONVERT(DATETIME,@pa_closing_dt,103)  
  ORDER BY CLOPM_DT desc  
    
  SELECT TOP 1 @max_closingdate = CLOPM_DT  
  FROM  CLOSING_PRICE_MSTR_CDSL   
  ORDER BY CLOPM_DT desc  
  
    
  INSERT INTO TMP_CLOSING_PRICE_MSTR_CDSL  
  (  
  TMPCPM_ISIN   
  ,TMPCPM_PRICE  
  ,TMPCPM_ACTUAL_DT  
  ,TMPCPM_EXCH  
  )  
  SELECT  CLOPM_ISIN_CD  
          ,CLOPM_CDSL_RT  
          ,CONVERT(DATETIME,@pa_closing_dt,103)    
          ,CLOPM_EXCH  
  FROM CLOSING_PRICE_MSTR_CDSL   
  WHERE CLOPM_DT = @prevclosingdate   
  AND NOT EXISTS (SELECT TMPCPM_ISIN FROM TMP_CLOSING_PRICE_MSTR_CDSL WHERE TMPCPM_ISIN = CLOPM_ISIN_CD)  
  
  print @max_closingdate     
  print @pa_closing_dt
  IF isnull(@max_closingdate,'Jan  1 1900') < @pa_closing_dt  
  BEGIN  
  --  
    truncate table CLOSING_LAST_CDSL  
  
    
  
    INSERT INTO CLOSING_LAST_CDSL  
    (CLOPM_ISIN_CD  
    ,CLOPM_DT  
    ,CLOPM_CDSL_RT  
    ,CLOPM_CREATED_BY  
    ,CLOPM_CREATED_DT  
    ,CLOPM_LST_UPD_BY  
    ,CLOPM_LST_UPD_DT  
    ,CLOPM_DELETED_IND  
    ,clopm_exch)  
    SELECT distinct  TMPCPM_ISIN  
         , TMPCPM_ACTUAL_DT  
         , TMPCPM_PRICE  
         , 'HO'  
         , GETDATE()  
         , 'HO'  
         , GETDATE()  
         , 1  
         , TMPCPM_EXCH  
    FROM TMP_CLOSING_PRICE_MSTR_CDSL  
  --  
  END  
  
  
  
  DELETE FROM CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_DT = @pa_closing_dt  
     
     
     
  INSERT INTO CLOSING_PRICE_MSTR_CDSL  
  (  
    CLOPM_ISIN_CD  
   ,CLOPM_DT  
   ,CLOPM_CDSL_RT  
   ,CLOPM_CREATED_BY  
   ,CLOPM_CREATED_DT  
   ,CLOPM_LST_UPD_BY  
   ,CLOPM_LST_UPD_DT  
   ,CLOPM_DELETED_IND  
   ,CLOPM_EXCH  
  )  
  SELECT distinct TMPCPM_ISIN   
          ,TMPCPM_ACTUAL_DT  
          ,TMPCPM_PRICE  
          ,@pa_login_name  
          ,getdate()  
          ,@pa_login_name  
          ,getdate()  
          ,1  
          ,TMPCPM_EXCH  
  
  FROM  TMP_CLOSING_PRICE_MSTR_CDSL  
       

UPDATE FILETASK          
					SET    TASK_END_DATE  = GETDATE()        
					, STATUS         = 'COMPLETED'          
					, ERRMSG         = ''   
					, TASK_FILEDATE  = (select top 1 TMPCPM_ACTUAL_DT from TMP_CLOSING_PRICE_MSTR_CDSL)
					WHERE  LOGN_NAME      = @pa_login_name          
					AND    TASK_NAME      = 'DPM CLOSING PRICE-CDSL FILE'--@PA_TASK_NAME             
					AND    TASK_END_DATE    IS NULL   
					AND    STATUS         = 'RUNNING'  
--  
END

GO
