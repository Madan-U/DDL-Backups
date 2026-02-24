-- Object: PROCEDURE citrus_usr.PR_INS_CLOSING_MSTR_NSDL_NAV
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin tran
--PR_INS_CLOSING_MSTR_NSDL    'HO','','BULK','c:\BulkInsDbfolder\DPM CLOSING PRICE-NSDL FILE\pricefile 20080529.txt','*|~*','|*~|',''
--rollback tran
--select * from CLOSING_LAST_NSDL_NAV

CREATE PROCEDURE [citrus_usr].[PR_INS_CLOSING_MSTR_NSDL_NAV]       
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

  set     @prevclosingdate = 'jan 01 1900'
  set    @max_closingdate  = 'jan 01 1900'
         
  IF @pa_mode ='BULK'      
  BEGIN      
      
    TRUNCATE TABLE TMP_NAV_MSTR
    Truncate table temp_clom
            
    DECLARE @@ssql varchar(8000)        
            
    SET @@ssql ='BULK INSERT temp_clom FROM ''' + @pa_db_source + ''' WITH         
    (        
         FIELDTERMINATOR = ''|n'',        
         ROWTERMINATOR = ''\n''        
    )'        
      
    EXEC(@@ssql)        

    insert into TMP_NAV_MSTR
    (TMPNAV_ISIN       
    ,TMPNAV_RATE      
    ,TMPNAV_DATE    
    )
    select ltrim(rtrim(substring(field1,10,12)))
         , substring(field1,22,14)
         , convert(datetime,substring(field1,2,8))
    from temp_clom
        
  END         

--UPDATE TMP_NAV_MSTR SET TMPNAV_RATE   = TMPNAV_RATE/100      


  if @pa_mode = 'BULK'
  select top 1 @pa_closing_dt       =  TMPNAV_DATE from TMP_NAV_MSTR 
         
  SELECT TOP 1 @prevclosingdate = CLOPMNAV_DT      
  FROM  CLOSING_PRICE_MSTR_NSDL_NAV      
  WHERE CLOPMNAV_DT < CONVERT(DATETIME,@pa_closing_dt,103)      
  ORDER BY CLOPMNAV_DT desc      
      
      
  SELECT TOP 1 @max_closingdate = CLOPMNAV_DT  
  FROM  CLOSING_PRICE_MSTR_NSDL_NAV  
  ORDER BY CLOPMNAV_DT desc  
      
  INSERT INTO TMP_NAV_MSTR      
  (      
   TMPNAV_ISIN       
  ,TMPNAV_RATE      
  ,TMPNAV_DATE    
    
  )      
  SELECT  DISTINCT CLOPMNAV_ISIN_CD      
          ,CLOPMNAV_NSDL_RT      
          ,CONVERT(DATETIME,@pa_closing_dt,103)       
  FROM CLOSING_PRICE_MSTR_NSDL_NAV       B
  WHERE CLOPMNAV_DT = @prevclosingdate       
  AND NOT EXISTS (SELECT TMPNAV_ISIN FROM TMP_NAV_MSTR WHERE TMPNAV_ISIN = CLOPMNAV_ISIN_CD)      
         
    
  IF @max_closingdate <= @pa_closing_dt  
  BEGIN  
  --  
    truncate table CLOSING_LAST_NSDL_NAV

    INSERT INTO CLOSING_LAST_NSDL_NAV  
    (CLOPMNAV_ISIN_CD  
    ,CLOPMNAV_DT  
    ,CLOPMNAV_NSDL_RT  
    ,CLOPMNAV_CREATED_BY  
    ,CLOPMNAV_CREATED_DT  
    ,CLOPMNAV_LST_UPD_BY  
    ,CLOPMNAV_LST_UPD_DT  
    ,CLOPMNAV_DELETED_IND  
    )  
    SELECT TMPNAV_ISIN  
         , TMPNAV_DATE  
         , TMPNAV_RATE  
         , 'HO'  
         , GETDATE()  
         , 'HO'  
         , GETDATE()  
         , 1  
          
    FROM TMP_NAV_MSTR  
  --  
  END  
    
    
  DELETE FROM CLOSING_PRICE_MSTR_NSDL_NAV WHERE CLOPMNAV_DT = @pa_closing_dt      
         
         
  INSERT INTO CLOSING_PRICE_MSTR_NSDL_NAV      
  (      
    CLOPMNAV_ISIN_CD      
   ,CLOPMNAV_DT      
   ,CLOPMNAV_NSDL_RT      
   ,CLOPMNAV_CREATED_BY      
   ,CLOPMNAV_CREATED_DT      
   ,CLOPMNAV_LST_UPD_BY      
   ,CLOPMNAV_LST_UPD_DT      
   ,CLOPMNAV_DELETED_IND    
     
  )      
  SELECT TMPNAV_ISIN       
          ,TMPNAV_DATE      
          ,TMPNAV_RATE      
          ,@pa_login_name      
          ,getdate()      
          ,@pa_login_name      
          ,getdate()      
          ,1          
            
  FROM  TMP_NAV_MSTR      
           
--      
END

GO
