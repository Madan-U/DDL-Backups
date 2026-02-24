-- Object: PROCEDURE citrus_usr.PR_INS_CLOSING_MSTR_NSDL
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin tran
--PR_INS_CLOSING_MSTR_NSDL    'HO','','BULK','c:\BulkInsDbfolder\DPM CLOSING PRICE-NSDL FILE\pricefile 20080529.txt','*|~*','|*~|',''
--rollback tran
--select * from closing_last_nsdl

CREATE PROCEDURE [citrus_usr].[PR_INS_CLOSING_MSTR_NSDL]       
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
      
    TRUNCATE TABLE TMP_CLOSING_PRICE_MSTR_NSDL
    Truncate table temp_clom
            
    DECLARE @@ssql varchar(8000)        
            
    SET @@ssql ='BULK INSERT temp_clom FROM ''' + @pa_db_source + ''' WITH         
    (        
         FIELDTERMINATOR = ''\n'',        
         ROWTERMINATOR = ''\n''        
    )'        
      
    EXEC(@@ssql)        

    insert into TMP_CLOSING_PRICE_MSTR_NSDL
    (TMPCPM_ISIN       
    ,TMPCPM_PRICE      
    ,TMPCPM_ACTUAL_DT    
    )
    select ltrim(rtrim(substring(field1,10,12)))
         , substring(field1,22,14)
         , convert(datetime,substring(field1,2,8))
    from temp_clom
        
  END         

UPDATE TMP_CLOSING_PRICE_MSTR_NSDL SET TMPCPM_PRICE   = TMPCPM_PRICE/100      


  if @pa_mode = 'BULK'
  select top 1 @pa_closing_dt       =  TMPCPM_ACTUAL_DT from TMP_CLOSING_PRICE_MSTR_NSDL 
         
  SELECT TOP 1 @prevclosingdate = CLOPM_DT      
  FROM  CLOSING_PRICE_MSTR_NSDL      
  WHERE CLOPM_DT < CONVERT(DATETIME,@pa_closing_dt,103)      
  ORDER BY CLOPM_DT desc      
      
      
  SELECT TOP 1 @max_closingdate = CLOPM_DT  
  FROM  CLOSING_PRICE_MSTR_NSDL  
  ORDER BY CLOPM_DT desc  
      
  INSERT INTO TMP_CLOSING_PRICE_MSTR_NSDL      
  (      
   TMPCPM_ISIN       
  ,TMPCPM_PRICE      
  ,TMPCPM_ACTUAL_DT    
    
  )      
  SELECT  DISTINCT CLOPM_ISIN_CD      
          ,CLOPM_NSDL_RT      
          ,CONVERT(DATETIME,@pa_closing_dt,103)       
  FROM CLOSING_PRICE_MSTR_NSDL       B
  WHERE CLOPM_DT = @prevclosingdate       
  AND NOT EXISTS (SELECT TMPCPM_ISIN FROM TMP_CLOSING_PRICE_MSTR_NSDL WHERE TMPCPM_ISIN = CLOPM_ISIN_CD)      
         
    
  IF @max_closingdate <= @pa_closing_dt  
  BEGIN  
  --  
    truncate table CLOSING_LAST_NSDL

    INSERT INTO CLOSING_LAST_NSDL  
    (CLOPM_ISIN_CD  
    ,CLOPM_DT  
    ,CLOPM_NSDL_RT  
    ,CLOPM_CREATED_BY  
    ,CLOPM_CREATED_DT  
    ,CLOPM_LST_UPD_BY  
    ,CLOPM_LST_UPD_DT  
    ,CLOPM_DELETED_IND  
    )  
    SELECT TMPCPM_ISIN  
         , TMPCPM_ACTUAL_DT  
         , TMPCPM_PRICE  
         , 'HO'  
         , GETDATE()  
         , 'HO'  
         , GETDATE()  
         , 1  
          
    FROM TMP_CLOSING_PRICE_MSTR_NSDL  
  --  
  END  
    
    
  DELETE FROM CLOSING_PRICE_MSTR_NSDL WHERE CLOPM_DT = @pa_closing_dt      
         
         
  INSERT INTO CLOSING_PRICE_MSTR_NSDL      
  (      
    CLOPM_ISIN_CD      
   ,CLOPM_DT      
   ,CLOPM_NSDL_RT      
   ,CLOPM_CREATED_BY      
   ,CLOPM_CREATED_DT      
   ,CLOPM_LST_UPD_BY      
   ,CLOPM_LST_UPD_DT      
   ,CLOPM_DELETED_IND    
     
  )      
  SELECT TMPCPM_ISIN       
          ,TMPCPM_ACTUAL_DT      
          ,TMPCPM_PRICE      
          ,@pa_login_name      
          ,getdate()      
          ,@pa_login_name      
          ,getdate()      
          ,1          
            
  FROM  TMP_CLOSING_PRICE_MSTR_NSDL      
           
--      
END

GO
