-- Object: PROCEDURE dbo.RPT_ALERT_DELAYINACTIVE_NP_EMAIL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



              
CREATE PROCEDURE [dbo].[RPT_ALERT_DELAYINACTIVE_NP_EMAIL]        
              
AS               
  
DECLARE @RUNDATE DATETIME
  
SET @RUNDATE = GETDATE()  

SELECT EXCHNAGE='NSECM',A.CLTCODE,A.VAMT,A.DRCR,A.VTYP,A.VNO,A.VDT,A.EDT,    
A.CDT,B.RELDT,B.DDNO,A.NARRATION,A.ENTEREDBY,ACTIVE_DATE=CONVERT(DATETIME,'') INTO #DATA    
FROM ACCOUNT.DBO.LEDGER A WITH (NOLOCK) ,ACCOUNT.DBO.LEDGER1 B WITH (NOLOCK)    
WHERE A.VNO = B.VNO AND A.VTYP = B.VTYP AND A.VAMT = B.RELAMT     
AND A.VTYP='2' AND A.DRCR='C' AND A.VDT >= @RUNDATE-15  AND A.VDT <= @RUNDATE + ' 23:59'    
    
    
UPDATE #DATA SET ACTIVE_DATE = ADATE FROM #DATA A,    
(SELECT CL_CODE,ADATE=LEFT(MIN(Active_Date),11) FROM CLIENT_BROK_DETAILS WITH (NOLOCK)    
WHERE CL_CODE IN (SELECT DISTINCT CLTCODE FROM #DATA) GROUP BY CL_CODE) B    
WHERE A.CLTCODE = B.Cl_Code    
    
SELECT EXCHNAGE,CLTCODE,CONVERT(VARCHAR,VAMT) AS VAMT,DRCR,VTYP=CONVERT(VARCHAR,VTYP),VNO=CONVERT(VARCHAR,VNO),    
VDT=CONVERT(VARCHAR(11),VDT,105),EDT=CONVERT(VARCHAR(11),EDT,105),CDT=CONVERT(VARCHAR(11),CDT,105),RELDT=CONVERT(VARCHAR(11),RELDT,105),    
DDNO,NARRATION,ENTEREDBY,ACTIVE_DATE=CONVERT(VARCHAR(11),ACTIVE_DATE,105) INTO #DATA_FINAL    
FROM #DATA WHERE ACTIVE_DATE LIKE '%1900%' AND CLTCODE BETWEEN 'A' AND 'ZZZZZZZZZZ'
        
DECLARE @EMAILS VARCHAR(4000),@BODYCONTENT VARCHAR(MAX),@PEOPLE VARCHAR(4000),@SNAME VARCHAR(4000),@SUB VARCHAR(4000),@XML VARCHAR(MAX),@TBLE VARCHAR(MAX),@SUB1 VARCHAR(4000)                    
            
SET @SUB = 'Client Details Not Present in Master : ' + CONVERT(VARCHAR(11),@RUNDATE,105)            
            
SET @SUB1 = 'Client Details Not Present in Master for ' + CONVERT(VARCHAR(11),@RUNDATE,105) + '.'                  
              
SET @XML =  CAST((SELECT [td/@align]='center',[td/@width]='5%',td = EXCHNAGE,'',                    
    [td/@align]='center',[td/@width]='5%',td = CLTCODE ,'',             
 [td/@align]='center',[td/@width]='5%',td = VAMT ,'',                  
 [td/@align]='center',[td/@width]='10%',td =VNO,'',        
 [td/@align]='center',[td/@width]='10%',td =VDT,'' ,       
 [td/@align]='center',[td/@width]='10%',td =EDT,'',      
 [td/@align]='center',[td/@width]='10%',td =CDT,'',      
 [td/@align]='center',[td/@width]='10%',td =RELDT,'',      
 [td/@align]='center',[td/@width]='10%',td =DDNO,'',       
 [td/@align]='center',[td/@width]='10%',td =NARRATION,'',       
 [td/@align]='center',[td/@width]='10%',td =ENTEREDBY,'', 
 [td/@align]='center',[td/@width]='10%',td = ACTIVE_DATE,'' 
FROM #DATA_FINAL ORDER BY VDT ASC FOR XML PATH('TR'), ELEMENTS ) AS VARCHAR(MAX))                    
              
SET @TBLE ='<HTML><HEAD><STYLE>BODY>TABLE>TBODY>TR>TD:NTH-CHILD(1)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(2)BODY>TABLE>TBODY > TR > TD:NTH-CHILD(3)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(4)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(5)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(6)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(7)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(10) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(11)BODY > TABLE > TBODY > TR > TD:NTH-CHILD(12) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(13) </STYLE> </HEAD> <TABLE BORDER = 1;> <THEAD> <TR STYLE="BACKGROUND-COLOR: #4F6E9C; COLOR: WHITE; FONT-SIZE: 13PX">  <TH> EXCHANGE </TH> <TH> CLTCODE </TH>  <TH> VAMT </TH><TH> VNO </TH><TH> VDT </TH><TH> EDT </TH>   <TH> CDT </TH><TH> RELDT </TH><TH> DDNO </TH><TH> NARRATION </TH><TH> ENTEREDBY </TH><TH> ACTIVE_DATE </TH></TR> </THEAD><TBODY STYLE="FONT-SIZE: 13PX;">'                        
                    
SET @TBLE = @TBLE + @XML +'</TBODY></TABLE></BODY></HTML>'                    
                    
SELECT @BODYCONTENT = '<P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">Dear All,</SPAN></P><P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">'+ @SUB1 + '</P>'+@TBLE+''      
  
EXEC MSDB.DBO.SP_SEND_DBMAIL               
@PROFILE_NAME='BO SUPPORT',               
@RECIPIENTS='sandip.tote@angelbroking.com;mohitsohanlal.jain@angelbroking.com;nitin.kumar@angelbroking.com;ravindra.1raje@angelbroking.com;vishal.doshi@angelbroking.com',              
@copy_recipients='suresh.raut@angelbroking.com;arjun.ghodke@angelbroking.com;swapnil.kank@angelbroking.com;narayan.patankar@angelbroking.com;rahulc.shah@angelbroking.com;kyconcall@angelbroking.com;suraksha.p@angelbroking.com;vijaykumar.1bhat@angelbroking.com;sunny.1siddula@angelbroking.com;syed.hashmi@angelbroking.com;rohan.shinde@angelbroking.com',              
@blind_copy_recipients='ananthanarayanan.b@angelbroking.com;ganesh.jagdale@angelbroking.com',              
@SUBJECT=@SUB,              
@BODY=@BODYCONTENT,               
@IMPORTANCE = 'HIGH',              
@BODY_FORMAT ='HTML'              

DROP TABLE #DATA_FINAL
DROP TABLE #DATA

GO
