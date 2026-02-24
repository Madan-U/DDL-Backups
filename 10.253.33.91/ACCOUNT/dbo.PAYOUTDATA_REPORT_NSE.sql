-- Object: PROCEDURE dbo.PAYOUTDATA_REPORT_NSE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

  
  
  
--PAYOUTDATA_REPORT_NSE '28/04/2021','28/04/2021'                      
CREATE proc [dbo].[PAYOUTDATA_REPORT_NSE] (                            
                            
@FROMDATE varchar(11) ,                             
@TODATE   varchar(11)                             
)                      
AS                           
                        
--IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0                          
                          
--BEGIN                          
                          
--      SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)                          
                          
--END                          
                          
--IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0                          
                          
--BEGIN                          
                          
--      SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)                          
                          
--END                          
                          
                           
-- print @FROMDATE                         
                          
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
                            
                            
FROM LEDGER L WITH(NOLOCK), LEDGER1 L1 (NOLOCK)                          
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                           
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                          
and L.vdt< = @TODATE + ' 23:59' --and L1.reldt='1900-01-01 00:00:00.000'                          
UNION ALL                            
                          
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                          
 L.vtyp,L1.reldt,L.EDT,L.CDT,L.BOOKTYPE,'NSE' AS EXCHANGE                          
 FROM LEDGER L WITH(NOLOCK), LEDGER1 L1 (NOLOCK)                          
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
                          
--select NARRATION from #temp                          
--where narration like '%%'                          
----where narration like '%:/.?=_-$(){}~&%'                          
--return                          
                        
                        
--SELECT                             
--[EXCHANGE]   = A.EXCHANGE,                         
--[SHORT_NAME] = B.SHORT_NAME,                                              
--[REGION]     = B.REGION,                                              
--[BRANCH_CD]  = B.BRANCH_CD,                                           
--[SUB_BROKER] = B.SUB_BROKER,               
--[BANK_NAME]  = B.BANK_NAME,                                              
--[AC_NUM]     = B.AC_NUM,                                            
--[CLTCODE]    = A.CLTCODE,                                  
--[VDT]        = A.vdt,                                                   
--[VNO]        = A.vno,        
--LEFT(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),100) AS NARRATION,                                              
----[NARRATION]  = left(REPLACE(A.narration , '"', ''),100),                                                           
--[VAMT]       = A.vamt,                                                
--[DRCR]   = A.DRCR,                              
--[DDNO]   = A.ddno,                                                         
--[VTYP]   = A.vtyp,                                 
--[RELDT]   = A.reldt,                                                 
--[BOOKTYPE]  = A.BOOKTYPE       
      
SELECT       
 [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''),       
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT,       
    CONVERT(TIME(0), A.vdt) AS VDT_TIME,      
             [VNO]=Replace(Ltrim(Rtrim(A.vno)), ' ', ''),       
             [NARRATION]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(A.narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''
  
    
),'.', ''),      
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
     INTO #FINAL      
       
                                                                             
FROM #TEMP AS A LEFT OUTER JOIN                                              
MSAJAG.DBO.CLIENT_DETAILS AS B WITH(NOLOCK) ON A.CLTCODE = B.CL_CODE                      
ORDER BY EXCHANGE                            
                          
--SELECT b.short_name,b.region,b.branch_cd,b.sub_broker,b.Bank_Name,b.AC_Num, A.* FROM #TEMP A                          
--LEFT OUTER JOIN                          
--msajag.dbo.client_details B on a.cltcode = b.cl_code ORDER BY EXCHANGE                          
              
  SELECT * FROM   #FINAL   ORDER  BY CLTCODE          
                            
END

GO
