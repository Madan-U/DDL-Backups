-- Object: PROCEDURE dbo.V2_Fout_Report
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE   PROC V2_FOUT_REPORT(                    
         @FROMCODE   VARCHAR(20),                    
         @TOCODE     VARCHAR(20),                    
         @OPT        VARCHAR(10),                    
         @STATUSID   VARCHAR(10),                    
         @STATUSNAME VARCHAR(25),                    
         @SESSIONID  VARCHAR(30),                  
         @REPORTOPT  VARCHAR(1))                    
                    
AS                    
              
  SET NOCOUNT ON    
    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
    
  INSERT INTO V2_PROCESS_LOGS              
  VALUES ('FOUT_REPORT',               
          'EXEC V2_FOUT_REPORT @FROMCODE='+@FROMCODE+', @TOCODE='+@TOCODE+' ,@OPT='+@OPT+' , @STATUSID='+@STATUSID+' ,@STATUSNAME='+@STATUSNAME+' ,@SESSIONID='+@SESSIONID+' ,@REPORTOPT='+@REPORTOPT,              
          LEFT(@STATUSID+'-'+@STATUSNAME,50),              
          GETDATE())              
              
  IF ISNULL(@FROMCODE,'') = ''                             
    BEGIN                            
      SELECT @FROMCODE ='0000000000'                            
    END                            
                        
  IF ISNULL(@TOCODE,'') = ''                             
    BEGIN                            
      SELECT @TOCODE ='ZZZZZZZZZZ'                            
    END                            
                    
                    
  IF @REPORTOPT='D'                          
    BEGIN                    
      SELECT GROUPNAME,                  
             PARTY_CODE,                        
             PARTY_NAME,                        
             NSEBALANCE,                        
             BSEBALANCE,                        
             NSEFOBALANCE,                        
             NSEESTIMATED1,                        
             NSEESTIMATED2,                                       
             BSEESTIMATED1,                        
             BSEESTIMATED2,                        
             FAACTUAL,                        
             CASH=-CASH,                        
             NONCASH=-NONCASH,                        
             IMMARGIN,                        
             VARMARGIN,                  
             RES_PHONE,                  
             SESID,            
             TOTALPARTY=NSEBALANCE+BSEBALANCE+NSEFOBALANCE,            
             ESTIMATETOTALPARTY = NSEBALANCE+BSEBALANCE+NSEFOBALANCE+NSEESTIMATED1+BSEESTIMATED1+NSEESTIMATED2+BSEESTIMATED2,            
             FANETPARTY = FAACTUAL - (NSEBALANCE+BSEBALANCE+NSEFOBALANCE+NSEESTIMATED1+BSEESTIMATED1+NSEESTIMATED2+BSEESTIMATED2),            
             FINTOTALPARTY = FAACTUAL + IMMARGIN + VARMARGIN + NONCASH - CASH,     
             BEN_HOLDING=-BEN_HOLDING             
      FROM   (SELECT GROUPNAME = (CASE                    
                                    WHEN @OPT = 'BROKER' THEN BRANCH_CODE                    
                                    WHEN @OPT = 'SUBBROKER' THEN SUBBROKER_CODE                                                 
                                    WHEN @OPT = 'TRADER' THEN TRADER                    
                                    WHEN @OPT = 'FAMILY' THEN FAMILY_CODE                    
                                    WHEN @OPT = 'CLIENT' THEN PARTY_CODE                    
                                    WHEN @OPT = 'AREA' THEN AREA_CODE                    
                                    WHEN @OPT = 'REGION' THEN REGION_CODE                    
                                    ELSE BRANCH_CODE                    
                                  END),                    
                     PARTY_CODE,                        
                     PARTY_NAME,                   
                     NSEBALANCE,                        
                     BSEBALANCE,                        
                     NSEFOBALANCE,                        
                     NSEESTIMATED1,                        
             	NSEESTIMATED2,                                    
                     BSEESTIMATED1,                        
                     BSEESTIMATED2,                        
                     FAACTUAL,                        
                     CASH,                        
                     NONCASH,                        
                     IMMARGIN,                        
                     VARMARGIN,                  
                     RES_PHONE,    
                     BEN_HOLDING,                   
                     SESID = @SESSIONID                         
              FROM   V2_FOUT_LEDGERBALANCES WITH(INDEX(FOUTIDX),NOLOCK)                    
              WHERE  @STATUSNAME = (CASE                     
                                      WHEN @STATUSID = 'BROKER' THEN @STATUSNAME                    
                                      WHEN @STATUSID = 'BRANCH' THEN BRANCH_CODE                    
                                      WHEN @STATUSID = 'TRADER' THEN TRADER                    
                                      WHEN @STATUSID = 'SUBBROKER' THEN SUBBROKER_CODE                    
                                      WHEN @STATUSID = 'AREA' THEN AREA_CODE                    
                                      WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                    
                                      WHEN @STATUSID = 'REGION' THEN REGION_CODE                    
                                      ELSE ''                                
                                    END)) DTL                  
      WHERE GROUPNAME >= @FROMCODE     
            AND GROUPNAME <= @TOCODE + 'ZZZZ'          
      ORDER BY 1, 2, 3                    
    END                          
    
  IF @REPORTOPT<>'D'                          
    BEGIN                                    
      SELECT GROUPNAME,                         
             PARTY_NAME,                        
             SUM(NSEBALANCE) AS NSEBALANCE,                            
             SUM(BSEBALANCE) AS BSEBALANCE,                        
             SUM(NSEFOBALANCE) AS NSEFOBALANCE,                                    
             SUM(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) AS TOTALPARTY,                                    
             SUM(NSEESTIMATED1) AS NSEESTIMATED1,                        
             SUM(NSEESTIMATED2) AS NSEESTIMATED2,                                       
             SUM(BSEESTIMATED1) AS BSEESTIMATED1,                        
             SUM(BSEESTIMATED2) AS BSEESTIMATED2,                                    
             SUM(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) AS ESTIMATETOTALPARTY,                                    
             SUM(FAACTUAL) AS FAACTUAL,                                    
             SUM(FAACTUAL - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) AS FANETPARTY,                                    
             SUM(CASH) AS CASH,                        
             SUM(NONCASH) AS NONCASH,                         
             SUM(IMMARGIN) AS IMMARGIN,                        
             SUM(VARMARGIN) AS VARMARGIN,                                    
             SUM(FAACTUAL + IMMARGIN + VARMARGIN + NONCASH + CASH) AS FINTOTALPARTY,                  
             SUM(BEN_HOLDING) AS BEN_HOLDING,                   
             SESID,              
             RES_PHONE=''                      
      FROM   (SELECT GROUPNAME = (CASE                    
                                    WHEN @OPT = 'BROKER' THEN BRANCH_CODE                    
                                    WHEN @OPT = 'SUBBROKER' THEN SUBBROKER_CODE                                                 
                                    WHEN @OPT = 'TRADER' THEN TRADER                    
                                    WHEN @OPT = 'FAMILY' THEN FAMILY_CODE                    
                         WHEN @OPT = 'CLIENT' THEN PARTY_CODE                    
                                    WHEN @OPT = 'AREA' THEN AREA_CODE                    
                                    WHEN @OPT = 'REGION' THEN REGION_CODE                    
        ELSE BRANCH_CODE                    
                                  END),                    
                     PARTY_CODE,                        
                     PARTY_NAME = (CASE                    
                                     WHEN @OPT = 'BROKER' THEN BRANCH_NAME                    
                                     WHEN @OPT = 'SUBBROKER' THEN SUBBROKER_NAME                                            
                                     WHEN @OPT = 'TRADER' THEN TRADER_NAME                    
                                     WHEN @OPT = 'FAMILY' THEN FAMILY_NAME                    
                                     WHEN @OPT = 'CLIENT' THEN PARTY_NAME                    
                                     WHEN @OPT = 'AREA' THEN AREA_NAME                    
                                     WHEN @OPT = 'REGION' THEN REGION_NAME                    
                                     ELSE BRANCH_NAME                    
                                   END),    
                     NSEBALANCE,                        
                     BSEBALANCE,                        
                     NSEFOBALANCE,                        
                     NSEESTIMATED1,                        
                     NSEESTIMATED2,                                       
                     BSEESTIMATED1,                        
                     BSEESTIMATED2,                        
                     FAACTUAL,                        
                     CASH=-CASH,                        
                     NONCASH=-NONCASH,                        
                     IMMARGIN,                        
                     VARMARGIN,                  
                     RES_PHONE,    
                     BEN_HOLDING=-BEN_HOLDING,                   
                     SESID = @SESSIONID                                
              FROM   V2_FOUT_LEDGERBALANCES WITH(INDEX(FOUTIDX),NOLOCK)                    
              WHERE  @STATUSNAME = (CASE                     
                                      WHEN @STATUSID = 'BROKER' THEN @STATUSNAME                    
                                      WHEN @STATUSID = 'BRANCH' THEN BRANCH_CODE                    
                                      WHEN @STATUSID = 'TRADER' THEN TRADER                    
                                      WHEN @STATUSID = 'SUBBROKER' THEN SUBBROKER_CODE                    
                                      WHEN @STATUSID = 'AREA' THEN AREA_CODE                    
                                      WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                    
                                      WHEN @STATUSID = 'REGION' THEN REGION_CODE                    
                                      ELSE ''                                
                                    END)) DTLRPT                  
      WHERE  GROUPNAME >= @FROMCODE                  
             AND GROUPNAME <= @TOCODE + 'ZZZZ'                 
      GROUP BY GROUPNAME, PARTY_NAME, SESID                  
      ORDER BY GROUPNAME, PARTY_NAME                  
    END

GO
