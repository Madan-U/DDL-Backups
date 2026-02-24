-- Object: PROCEDURE dbo.INTERSEGMENT_DATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
      
      
CREATE PROCEDURE [dbo].[INTERSEGMENT_DATA]      
      
      
      
(      
      
      
      
  @FROMDATE VARCHAR(11),        
      
  @TODATE VARCHAR(11)        
      
)      
      
      
      
AS      
 IF Len(@FROMDATE) = 10       
      
       AND Charindex('/', @FROMDATE) > 0       
      
      BEGIN       
      
          SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103) , 109)       
      
      END       
      
      
      
    IF Len(@TODATE) = 10       
      
       AND Charindex('/', @TODATE) > 0       
      
      BEGIN       
      
          SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103),  109)       
      
      END       
      
      
      
    PRINT @FROMDATE       
      
      
      
      
BEGIN      
      
      
      
SELECT 'NSE'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
  FROM LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
      
      
UNION       
      
      
      
SELECT 'BSE'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
  FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
      
      
UNION       
      
      
      
SELECT 'NSEFO'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
  FROM [AngelFO].ACCOUNTfo.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
      
      
UNION       
      
      
      
SELECT 'NSX'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
 FROM [AngelFO].ACCOUNTcurfo.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
      
      
UNION       
      
      
      
SELECT 'MCDX'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '' 
  
   
),':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
 FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
UNION       
      
      
      
SELECT 'NCDX'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
  FROM [AngelCommodity].ACCOUNTnCDX.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
UNION       
      
      
      
SELECT 'MCD'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
  FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59'        
      
UNION       
      
      
      
SELECT 'BSX'AS EXCHANGE,      
[CLTCODE]=Replace(Ltrim(Rtrim(cltcode)), ' ', ''),       
[VTYP]=Replace(Ltrim(Rtrim(vtyp)), ' ', ''),       
[VNO]=Replace(Ltrim(Rtrim(vno)), ' ', ''),       
CONVERT(VARCHAR(11), CONVERT(DATETIME, vdt, 103), 103)   AS VDT,      
[VAMT]=Replace(Ltrim(Rtrim(vamt)), ' ', ''),       
 [DRCR]=Replace(Ltrim(Rtrim(drcr)), ' ', ''),       
 [NARRATION]=REPLACE(REPLACE(REPLACE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '')
  
    
,':', ''),'-', ''),'.', ''),'&', ''),'@', ''),'%', ''),'()', '')      
 FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER with (nolock) WHERE VTYP in ('88','8') AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59:59' ORDER BY VNO       
      
      
      
      
      
      
      
      
      
END

GO
