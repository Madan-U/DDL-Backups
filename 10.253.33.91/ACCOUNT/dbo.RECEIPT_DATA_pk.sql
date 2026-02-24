-- Object: PROCEDURE dbo.RECEIPT_DATA_pk
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

              
--RECEIPT_DATA_pk '25/08/2015','31/08/2015'              
          
          
              
CREATE PROC [dbo].[RECEIPT_DATA_pk]                                 
(                          
 @FROMDATE varchar(11) ,                                
 @TODATE   varchar(11)         
                    
)                                
AS   
set nocount on    
set transaction isolation level read uncommitted                               
BEGIN                
 IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0                        
                        
BEGIN                        
                        
      SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)                        
                        
END                        
                        
IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0                        
                        
BEGIN                        
                        
      SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)                        
                        
END                        
                        
                         
 print @FROMDATE               
 DECLARE @RecData TABLE              
 (              
  CLTCODE varchar(10),                                
  VDT datetime,                                
  VNO varchar(12),                      
  --[NARRATION] NTEXT NOT NULL,   
  [NARRATION] VARCHAR(234),                                
  VAMT money,                                
  DRCR char(1),                                
  DDNO varchar(30),                                
  VTYP smallint,                                
  RELDT datetime,                                
  BOOKTYPE varchar(3),                      
  EXCHANGE varchar(8)              
 )       
   
                 
              
  INSERT INTO @RecData (CLTCODE,VDT,VNO,NARRATION,VAMT,DRCR,DDNO,VTYP,RELDT,BOOKTYPE,EXCHANGE)              
              
SELECT  *  FROM               
(                                
 SELECT                
  [CLTCODE]=CLTCODE,                                
  [VDT]    =L.VDT,                                
  [VNO]    =L.VNO,                      
  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                               
  [VAMT]   =L.VAMT,                                
  [DRCR]   =L.DRCR,                                
  [DDNO]   =L1.DDNO,                                
  [VTYP]   =L.VTYP,                                
  [RELDT]  =L1.RELDT,                                
  [BOOKTYPE]=L.BOOKTYPE,                      
  [EXCHANGE]='NSE'               
 FROM               
  LEDGER L (NOLOCK) ,               
  LEDGER1 L1 (NOLOCK)                
 WHERE               
  L.VNO=L1.VNO AND               
  L.VTYP=L1.VTYP AND               
  L.BOOKTYPE=L1.BOOKTYPE AND               
  L.DRCR ='D' AND               
  L.VTYP =2 AND               
  L.VDT >= @FROMDATE AND               
  L.VDT < =@TODATE + ' 23:59'                         
              
 UNION ALL                                
              
 SELECT               
  CLTCODE,              
  L.VDT,              
  L.VNO,              
  REPLACE(L.NARRATION , '"', ''),              
  L.VAMT,              
  L.DRCR,              
  L1.DDNO,                                
  L.VTYP,              
  L1.RELDT,              
  L.BOOKTYPE,              
  'NSE' AS EXCHANGE              
 FROM               
  LEDGER L(NOLOCK),               
  LEDGER1 L1 (NOLOCK)               
 WHERE               
  L.VNO=L1.VNO AND               
  L.VTYP=L1.VTYP AND               
  L.BOOKTYPE=L1.BOOKTYPE AND               
  L.DRCR ='C' AND               
  L.VTYP =2  AND               
  L.VDT >=@FROMDATE AND               
  L.VDT < =@TODATE + ' 23:59'                      
              
 ----BSE-----                 
              
 UNION ALL                
              
 SELECT                                
  [CLTCODE]=CLTCODE,                                
  [VDT]    =L.VDT,                                
  [VNO]    =L.VNO,                      
  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                                
  [VAMT]   =L.VAMT,                                
  [DRCR]   =L.DRCR,                                
  [DDNO]   =L1.DDNO,                                
  [VTYP]   =L.VTYP,                                
  [RELDT]  =L1.RELDT,                                
  [BOOKTYPE]=L.BOOKTYPE,                      
  [EXCHANGE]='BSE'                                
 FROM               
  AngelBSECM.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) ,               
  AngelBSECM.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)              
 WHERE               
  L.VNO=L1.VNO AND               
  L.VTYP=L1.VTYP AND               
  L.BOOKTYPE=L1.BOOKTYPE AND               
  L.DRCR ='D' AND               
  L.VTYP =2 AND               
  L.VDT >= @FROMDATE AND               
  L.VDT < =@TODATE + ' 23:59'                         
              
 UNION ALL                                
              
 SELECT               
  CLTCODE,              
  L.VDT,              
  L.VNO,              
  REPLACE(L.NARRATION , '"', ''),              
  L.VAMT,              
  L.DRCR,              
  L1.DDNO,                                
  L.VTYP,              
  L1.RELDT,              
  L.BOOKTYPE,'BSE' AS EXCHANGE               
 FROM               
  AngelBSECM.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),              
  AngelBSECM.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)              
 WHERE               
  L.VNO=L1.VNO AND               
  L.VTYP=L1.VTYP AND               
  L.BOOKTYPE=L1.BOOKTYPE AND               
  L.DRCR ='C' AND               
  L.VTYP =2  AND               
  L.VDT >=@FROMDATE AND               
  L.VDT < =@TODATE + ' 23:59'                         
              
-- ----NSEFO------                      
-- UNION ALL                 
              
-- SELECT                                
--  [CLTCODE]=CLTCODE,                                
--  [VDT]    =L.VDT,                                
--  [VNO]  =L.VNO,                      
--  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                                
--  [VAMT]   =L.VAMT,                                
--  [DRCR]   =L.DRCR,                                
--  [DDNO]   =L1.DDNO,                                
--  [VTYP]   =L.VTYP,                                
--  [RELDT]  =L1.RELDT,                                
--  [BOOKTYPE]=L.BOOKTYPE,                      
--  [EXCHANGE]='NSEFO'                                
-- FROM               
--  ANGELFO.ACCOUNTFO.DBO.LEDGER L (NOLOCK) ,               
--  ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                 
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='D' AND               
--  L.VTYP =2 AND               
--  L.VDT >= @FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
-- UNION ALL                                
              
-- SELECT               
--  CLTCODE,              
--  L.VDT,              
--  L.VNO,              
--  REPLACE(L.NARRATION , '"', ''),              
--  L.VAMT,              
--  L.DRCR,              
--  L1.DDNO,                                
--  L.VTYP,              
--  L1.RELDT,              
--  L.BOOKTYPE,              
--  'NSEFO' AS EXCHANGE                  
-- FROM               
--  ANGELFO.ACCOUNTFO.DBO.LEDGER L(NOLOCK),              
--  ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                                
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND              
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='C' AND               
--  L.VTYP =2  AND               
--  L.VDT >=@FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                       
              
-- --NSECURFO-----                      
              
-- UNION ALL                
              
-- SELECT                                
--  [CLTCODE]=CLTCODE,                           
--  [VDT]    =L.VDT,                                
--  [VNO]    =L.VNO,                      
--  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                               
--  [VAMT]   =L.VAMT,                                
--  [DRCR]   =L.DRCR,                                
--  [DDNO]   =L1.DDNO,                                
--  [VTYP]   =L.VTYP,                                
--  [RELDT]  =L1.RELDT,                                
--  [BOOKTYPE]=L.BOOKTYPE,                      
--  [EXCHANGE]='NSECURFO'                                
-- FROM               
--  ANGELFO.ACCOUNTCURFO.DBO.LEDGER L (NOLOCK) ,               
--  ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='D' AND               
--  L.VTYP =2 AND               
--  L.VDT >= @FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'       
              
-- UNION ALL                            
              
-- SELECT               
--  CLTCODE,              
--  L.VDT,              
--  L.VNO,              
--  REPLACE(L.NARRATION , '"', ''),              
--  L.VAMT,              
--  L.DRCR,              
--  L1.DDNO,                                
--  L.VTYP,              
--  L1.RELDT,              
--  L.BOOKTYPE,              
--  'NSECURFO' AS EXCHANGE              
-- FROM               
--  ANGELFO.ACCOUNTCURFO.DBO.LEDGER L(NOLOCK),              
--  ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)               
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='C' AND               
--  L.VTYP =2  AND               
--  L.VDT >=@FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                       
              
-- --MCDX----                      
              
-- UNION ALL                
              
-- SELECT                                
--  [CLTCODE]=CLTCODE,          
--  [VDT]    =L.VDT,                                
--  [VNO]    =L.VNO,                      
--  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                                
--  [VAMT]   =L.VAMT,                                
--  [DRCR]   =L.DRCR,                                
--  [DDNO]   =L1.DDNO,                                
--  [VTYP]   =L.VTYP,                                
--  [RELDT]  =L1.RELDT,                                
--  [BOOKTYPE]=L.BOOKTYPE,                      
--  [EXCHANGE]='MCDX'                                
-- FROM               
--  ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) ,               
--  ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                 
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='D' AND               
--  L.VTYP =2 AND               
--  L.VDT >= @FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
-- UNION ALL                                
              
-- SELECT               
--  CLTCODE,              
--  L.VDT,              
--  L.VNO,              
--  REPLACE(L.NARRATION , '"', ''),              
--  L.VAMT,              
--  L.DRCR,              
--  L1.DDNO,                                
--  L.VTYP,              
--  L1.RELDT,              
--  L.BOOKTYPE,              
--  'MCDX' AS EXCHANGE                
-- FROM               
--  ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L(NOLOCK),              
--  ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                  
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='C' AND               
--  L.VTYP =2  AND               
--  L.VDT >=@FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
-- --MCDXCDS----                      
              
-- UNION ALL                
              
-- SELECT                                
--  [CLTCODE]=CLTCODE,                                
-- [VDT]    =L.VDT,                                
--  [VNO]    =L.VNO,                      
--  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                               
--  [VAMT]   =L.VAMT,                                
--  [DRCR]   =L.DRCR,                                
--  [DDNO]   =L1.DDNO,                                
--  [VTYP]   =L.VTYP,                                
--  [RELDT]  =L1.RELDT,                                
--  [BOOKTYPE]=L.BOOKTYPE,                      
--  [EXCHANGE]='MCDXCDS'                                
-- FROM               
--  ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) ,               
--  ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)               
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='D' AND               
--  L.VTYP =2 AND               
--  L.VDT >= @FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
-- UNION ALL                                
              
-- SELECT               
--  CLTCODE,              
--  L.VDT,              
--  L.VNO,              
--  REPLACE(L.NARRATION , '"', ''),              
--  L.VAMT,              
--  L.DRCR,              
--  L1.DDNO,                                
--  L.VTYP,              
--  L1.RELDT,              
--  L.BOOKTYPE,              
--  'MCDXCDS' AS EXCHANGE              
-- FROM               
--  ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L(NOLOCK),              
--  ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                  
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='C' AND               
--  L.VTYP =2  AND               
--  L.VDT >=@FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
-- --NCDX----                      
              
-- UNION ALL               
              
-- SELECT                                
--  [CLTCODE]=CLTCODE,                                
--  [VDT]    =L.VDT,                                
--  [VNO]    =L.VNO,                      
--  [NARRATION]=REPLACE(L.NARRATION , '"', ''),                                
--  [VAMT]   =L.VAMT,                                
--  [DRCR]   =L.DRCR,                          
--  [DDNO]   =L1.DDNO,                                
--  [VTYP]   =L.VTYP,                                
--  [RELDT]  =L1.RELDT,                                
--  [BOOKTYPE]=L.BOOKTYPE,                      
--  [EXCHANGE]='NCDX'                                
-- FROM               
--  ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L (NOLOCK) ,               
--  ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                 
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='D' AND               
--  L.VTYP =2 AND               
--  L.VDT >= @FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
-- UNION ALL                                
              
-- SELECT               
--  CLTCODE,              
--  L.VDT,              
--  L.VNO,              
--  REPLACE(L.NARRATION , '"', ''),              
--  L.VAMT,              
--  L.DRCR,              
--L1.DDNO,                                
--  L.VTYP,              
--  L1.RELDT,              
--  L.BOOKTYPE,'NCDX' AS EXCHANGE                
-- FROM               
--  ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L(NOLOCK),              
--  ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)               
-- WHERE               
--  L.VNO=L1.VNO AND               
--  L.VTYP=L1.VTYP AND               
--  L.BOOKTYPE=L1.BOOKTYPE AND               
--  L.DRCR ='C' AND               
--  L.VTYP =2  AND               
--  L.VDT >=@FROMDATE AND               
--  L.VDT < =@TODATE + ' 23:59'                         
              
)A                                
              
  --CREATE CLUSTERED INDEX IDX_CL ON @RecData                  
  --(                  
  -- CLTCODE , VDT                  
  --)   
 
--  UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'/','')       
--where NARRATION like '%/%'                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'|','')                        
--where narration like '%|%'                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,':','')                        
--where narration like '%:%'                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'.','')                        
--where narration like '%.%'                        
                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'_',' ')                        
--where narration like '%_%'                        
                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'-',' ')                        
--where narration like '%-%'                        
                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,')',' ')                        
--where narration like '%)%'                        
                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'(',' ')                        
--where narration like '%(%'                        
                        
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'&',' ')                    
--where narration like '%&%'                        
                      
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'#',' ')                        
--where narration like '%#%'                        
                    
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,',',' ')                        
--where narration like '%,%'                      
                    
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,':-',' ')                        
--where narration like '%:-%'                      
                    
--UPDATE @RecData SET NARRATION = REPLACE(NARRATION,'"',' ')                        
--where narration like '%"%'                
              
  SELECT                                
    A.CLTCODE as CLTCODE,                    
    A.vdt as VDT,                                     
    A.vno as VNO,                   
    A.vamt as VAMT,                                
    A.DRCR as DRCR,                
    A.ddno as DDNO,                                        
    A.vtyp as VTYP,                   
    A.reldt as RELDT,                                   
    A.BOOKTYPE as BOOKTYPE,          
   --A.narration,    
   REPLACE(REPLACE(A.narration,'''',''),'""','') AS NARRATION,
    B.SHORT_NAME as SHORT_NAME,                                
    B.REGION as REGION,                                
    B.BRANCH_CD as BRANCH_CD,                                
    B.SUB_BROKER as SUB_BROKER,                                
   -- B.BANK_NAME as BANK_NAME,                                
    B.AC_NUM  as AC_NUM,          
    A.EXCHANGE     
                         
  FROM                 
    @RecData as A               
   LEFT OUTER JOIN                                
    MSAJAG.DBO.CLIENT_DETAILS as B               
  ON               
    A.CLTCODE = B.CL_CODE           
    --where B.AC_NUM=0          
-- where A.NARRATION like'%having matured date on%'          
   ORDER BY EXCHANGE            
            
 --SELECT * FROM #TEMP2 
  
END                                
   set nocount off

GO
