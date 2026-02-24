-- Object: PROCEDURE dbo.EXPCETIONAL_POST_REPORT_EMAIL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--Alter this SRE under [SRE-34813]
  
CREATE PROC [dbo].[EXPCETIONAL_POST_REPORT_EMAIL]        
AS        
DECLARE @RPTDATE VARCHAR(11) , @HOUR VARCHAR(2)        
        
SELECT @HOUR = DATEPART(HOUR, GETDATE())         
        
IF @HOUR < 4        
BEGIN         
SELECT @RPTDATE = GETDATE()-1        
END        
ELSE        
BEGIN        
SELECT @RPTDATE = GETDATE()        
END        
        
TRUNCATE TABLE POST_MISMATCH_ANG_EMAIL  
        
INSERT INTO POST_MISMATCH_ANG_EMAIL EXEC [EXPCETIONAL_POST_REPORT] @RPTDATE        
    
SELECT CLTCODE,BANKCODE,BANK_NAME,        
CONVERT(VARCHAR(11),VDT,109) AS VDT,CONVERT(VARCHAR(11),EDT,109) EDT,CONVERT(VARCHAR(11),RELDATE,109) AS RELDATE,VNO,VTYP,DDNO,        
DRCR,CONVERT(NUMERIC(18,2),VAMT) AS VAMT,CONVERT(VARCHAR(100),CDT) AS CDT,ENTEREDBY,CHECKEDBY,NARRATION,EXCHANGE INTO #POST_MISMATCH_FINAL         
FROM POST_MISMATCH_ANG_EMAIL        
        
DECLARE @EMAILS VARCHAR(4000),@BODYCONTENT VARCHAR(MAX),@PEOPLE VARCHAR(4000),@SNAME VARCHAR(4000),@SUB VARCHAR(4000),@XML VARCHAR(MAX),@TBLE VARCHAR(MAX),@SUB1 VARCHAR(4000)                      
              
SET @SUB = 'Posting mismatch report : ' + CONVERT(VARCHAR(11),@RPTDATE,105)              
              
SET @SUB1 = 'Posting mismatch report for ' + CONVERT(VARCHAR(11),@RPTDATE,105) + '.'                    
                
SET @XML =  CAST((SELECT [td/@align]='center',[td/@width]='5%',td = CLTCODE,'',                      
     [td/@align]='center',[td/@width]='5%',td = BANKCODE ,'',               
  [td/@align]='center',[td/@width]='10%',td = BANK_NAME ,'',               
  [td/@align]='center',[td/@width]='5%',td =VDT,''  ,        
  [td/@align]='center',[td/@width]='5%',td =EDT,''  ,        
  [td/@align]='center',[td/@width]='5%',td =RELDATE,'',          
  [td/@align]='center',[td/@width]='5%',td =VNO,'' ,         
  [td/@align]='center',[td/@width]='5%',td =VTYP,'',        
  [td/@align]='center',[td/@width]='5%',td =DDNO,'',        
  [td/@align]='center',[td/@width]='5%',td =DRCR,'',        
  [td/@align]='center',[td/@width]='10%',td =VAMT,'',         
  [td/@align]='center',[td/@width]='10%',td =CDT,'',         
  [td/@align]='center',[td/@width]='5%',td =ENTEREDBY,'',         
  [td/@align]='center',[td/@width]='5%',td =CHECKEDBY,'',         
  [td/@align]='center',[td/@width]='10%',td =NARRATION,'',         
  [td/@align]='center',[td/@width]='5%',td =EXCHANGE,''         
FROM #POST_MISMATCH_FINAL ORDER BY VDT ASC FOR XML PATH('TR'), ELEMENTS ) AS VARCHAR(MAX))                      
                
SET @TBLE ='<HTML><HEAD><STYLE>BODY>TABLE>TBODY>TR>TD:NTH-CHILD(1)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(2)BODY>TABLE>TBODY > TR > TD:NTH-CHILD(3)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(4)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(5)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(6)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(7)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(10) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(11)BODY > TABLE > TBODY > TR > TD:NTH-CHILD(12) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(13) </STYLE> </HEAD> <TABLE BORDER = 1;> <THEAD> <TR STYLE="BACKGROUND-COLOR: #4F6E9C; COLOR: WHITE; FONT-SIZE: 13PX"><TH> CLTCODE </TH> <TH> BANKCODE </TH>  <TH> BANK_NAME </TH><TH> VDT </TH><TH> EDT </TH><TH> RELDATE </TH><TH> VNO </TH><TH> VTYP </TH>   <TH> DDNO </TH><TH> DRCR </TH><TH> VAMT </TH><TH> CDT </TH><TH> ENTEREDBY </TH><TH> CHECKEDBY </TH>  <TH> NARRATION </TH><TH> EXCHANGE </TH> </TR> </THEAD><TBODY STYLE="FONT-SIZE: 13PX;">'                          
    
IF @XML IS NOT NULL                
BEGIN    
SET @TBLE = @TBLE + @XML + '</TBODY></TABLE></BODY></HTML>'                      
END     
ELSE  
BEGIN  
SET @TBLE = @TBLE + '</TBODY></TABLE></BODY></HTML>'     
END  
                
SELECT @BODYCONTENT = '<P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">Dear All,</SPAN></P><P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">'+ @SUB1 + '</P>'+@TBLE+''             
    
EXEC MSDB.DBO.SP_SEND_DBMAIL                       
@PROFILE_NAME='BO SUPPORT',                       
@RECIPIENTS='swapnil.kank@angelbroking.com;sanjay.karamalkar@angelbroking.com;vivekanand.rajguru@angelbroking.com;arun.tiwari@angelbroking.com;jvbanking@angelbroking.com;pay-inbanking@angelbroking.com',                       
@copy_recipients ='narayan.patankar@angelbroking.com;rahulc.shah@angelbroking.com',              
--@blind_copy_recipients='ananthanarayanan.b@angelbroking.com',                      
@SUBJECT=@SUB,                      
@BODY=@BODYCONTENT,                      
@IMPORTANCE = 'HIGH',                      
@BODY_FORMAT ='HTML'            
         
DROP TABLE #POST_MISMATCH_FINAL

GO
