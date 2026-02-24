-- Object: PROCEDURE dbo.RPT_PAYOUTDATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

  
  
  
--RPT_PAYOUTDATA 'MAY  5 2021','MAY  5 2021'                      
CREATE proc [dbo].[RPT_PAYOUTDATA] (                            
                            
@FROMDATE varchar(11) ,                             
@TODATE   varchar(11)                             
)                      
AS                           
                        
         TRUNCATE TABLE RPT_PAYOUT_DATA          
                          
BEGIN                             
 SELECT * INTO #TEMP FROM (                           
  SELECT                          
[CLTCODE]=CLTCODE,                            
[VDT]=L.VDT,                            
[vno]= L.VNO,                            
[NARRATION]=L.NARRATION,                            
[VAMT]=L.VAMT,                          
[DRCR]=L.DRCR,                            
[DDNO]=L1.ddno,                            
[vtyp]=L.VTYP,                            
[reldt]=L1.reldt,      
[EDT] =L.EDT,    
[CDT] =L.CDT,                           
[BOOKTYPE]=L.BOOKTYPE,                           
[EXCHANGE]='NSE'                            
                            
                            
FROM LEDGER L , LEDGER1 L1 (NOLOCK)                          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                           
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                          
and L.vdt< = @TODATE + ' 23:59' --and L1.reldt='1900-01-01 00:00:00.000'                          
UNION ALL                            
                          
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                          
 L.vtyp,L1.reldt,L.EDT,L.CDT,L.BOOKTYPE,'NSE' AS EXCHANGE                          
 FROM LEDGER L, LEDGER1 L1 (NOLOCK)                          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                           
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE --and L1.reldt='1900-01-01 00:00:00.000'                          
and L.vdt< = @TODATE + ' 23:59'                           
                          
                          
     
                          
                          
) A                            
                
  UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'/','')                          
where narration like '%/%'                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'|','')                          
where narration like '%|%'                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':','')                          
where narration like '%:%'                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'.','')                          
where narration like '%.%'                          
                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'_',' ')                          
where narration like '%_%'                          
                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'-',' ')                          
where narration like '%-%'                          
                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,')',' ')                          
where narration like '%)%'                          
                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'(',' ')                          
where narration like '%(%'                          
                          
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'&',' ')                      
where narration like '%&%'              
                        
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'#',' ')                          
where narration like '%#%'                          
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,',',' ')                          
where narration like '%,%'                        
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':-',' ')                          
where narration like '%:-%'                        
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'"',' ')                          
where narration like '%"%'                        
                          
   
    INSERT INTO RPT_PAYOUT_DATA  
SELECT       
 [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''),       
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT,       
    CONVERT(TIME(0), A.vdt) AS VDT_TIME,      
             [VNO]=Replace(Ltrim(Rtrim(A.vno)), ' ', ''),       
             [NARRATION]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(A.narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', '')
,'.', ''),      
             [EXCHANGE]=Replace(Ltrim(Rtrim(A.exchange)), ' ', ''),       
             [VAMT]=Replace(Ltrim(Rtrim(A.vamt)), ' ', ''),       
             [DRCR]=Replace(Ltrim(Rtrim(A.drcr)), ' ', ''),       
             [DDNO]=Replace(Replace(Ltrim(Rtrim(A.ddno)), ' ', ''),'''',''),       
             [VTYP]=Replace(Ltrim(Rtrim(A.vtyp)), ' ', ''),       
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) AS RELDT  ,       
             [BOOKTYPE]=Replace(Ltrim(Rtrim(A.booktype)), ' ', '')  ,       
             [SHORT_NAME]=ISNULL(Replace(Ltrim(Rtrim(B.short_name)), ' ', ''),''),       
             [REGION]=ISNULL(Replace(Ltrim(Rtrim(B.region)), ' ', ''),''),       
             [BRANCH_CD]=ISNULL(Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''),''),       
             [SUB_BROKER]=ISNULL(Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''),''),       
             ISNULL(REPLACE(REPLACE(replace(B.bank_name,',',' '),'"',''),'''',''),'')  AS BANK_NAME,       
             [AC_NUM]=ISNULL(Replace(Ltrim(Rtrim(B.ac_num)), ' ', ''),'') ,      
    CONVERT(VARCHAR(11), CONVERT(DATETIME, A.EDT, 103), 103)   AS EDT,   
      CDT,    
    CONVERT(TIME(0), A.EDT) AS EDT_TIME      
     ----INTO RPT_PAYOUT_DATA      
       
                                                                             
FROM #TEMP AS A LEFT OUTER JOIN                                              
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE                      
ORDER BY EXCHANGE                            
                          
--SELECT b.short_name,b.region,b.branch_cd,b.sub_broker,b.Bank_Name,b.AC_Num, A.* FROM #TEMP A                          
--LEFT OUTER JOIN                          
--msajag.dbo.client_details B on a.cltcode = b.cl_code ORDER BY EXCHANGE                          
              
 --- SELECT * FROM   #RPT_PAYOUT_DATA   ORDER  BY CLTCODE      
 BEGIN    
   
    
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\Automation\Banking\RPT_PAYOUT\'                         
SET @FILE1 = @PATH1 + 'RPT_PAYOUT' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name       
DECLARE @S1 VARCHAR(MAX)                                
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CLTCODE'''',''''VDT'''',''''VDT_TIME'''',''''VNO'''',''''NARRATION'''',''''EXCHANGE'''',''''VAMT'''',''''DRCR'''',''''DDNO'''',''''VTYP'''',''''RELDT'''',''''BOOKTYPE'''',''''SHORT_NAME'''',''''REGI
ON'''',''''BRANCH_CD'''',''''SUB_BROKER'''',''''BANK_NAME'''',''''AC_NUM'''',''''EDT'''',''''CDT'''',''''EDT_TIME'''''    --Column Name      
SET @S1 = @S1 + ' UNION ALL SELECT    cast([CLTCODE] as varchar),CONVERT (VARCHAR (11),VDT,109) as VDT,CONVERT (VARCHAR (11),VDT_TIME,109) as VDT_TIME,cast([VNO] as varchar), cast([NARRATION] as varchar), cast([EXCHANGE] as varchar),cast([VAMT] as varchar
) ,cast([DRCR] as varchar),cast([DDNO] as varchar) ,cast([VTYP] as varchar),CONVERT (VARCHAR (11),RELDT,109) as RELDT,cast([BOOKTYPE] as varchar ),cast([SHORT_NAME] as varchar),cast([REGION] as varchar),cast([BRANCH_CD] as varchar),cast([SUB_BROKER] as va
rchar),cast([BANK_NAME] as varchar),cast([AC_NUM] as varchar),cast([EDT] as varchar),cast([CDT] as varchar),CONVERT (VARCHAR (11),EDT_TIME,109) as EDT_TIME FROM [ACCOUNT].[dbo].[RPT_PAYOUT_DATA]    " QUERYOUT ' --Convert data type if required      
      
 +@file1+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''       
--       PRINT  (@S)       
EXEC(@S1)        
end    
   
    
END

GO
