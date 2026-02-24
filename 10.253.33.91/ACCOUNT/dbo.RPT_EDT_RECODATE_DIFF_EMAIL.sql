-- Object: PROCEDURE dbo.RPT_EDT_RECODATE_DIFF_EMAIL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

    
CREATE PROC [dbo].[RPT_EDT_RECODATE_DIFF_EMAIL]      
AS      
DECLARE @RPTDATE VARCHAR(11)      
      
SET @RPTDATE = GETDATE()      
      
SELECT EXCHANGE='NSECM',CLTCODE,VAMT,DRCR,VTYP,VNO,VDT,EDT,CDT,VDT AS RELDT,DDNO = CONVERT(VARCHAR(200),''), NARRATION,ENTEREDBY       
INTO #RPT_EDT_RECODATE_DIFF      
FROM LEDGER WITH (NOLOCK) WHERE 1 <> 1      
      
INSERT INTO #RPT_EDT_RECODATE_DIFF EXEC [RPT_EDT_RECODATE_DIFF] @RPTDATE      
      
SELECT EXCHANGE,CLTCODE,CONVERT(NUMERIC(18,2),VAMT) AS VAMT,DRCR,VTYP,VNO,      
CONVERT(VARCHAR(11),VDT,109) AS VDT,CONVERT(VARCHAR(11),EDT,109) AS EDT,      
CONVERT(VARCHAR(100),CDT) AS CDT,CONVERT(VARCHAR(11),RELDT,109) AS RELDT,DDNO,NARRATION,ENTEREDBY INTO #RPT_EDT_RECODATE_DIFF_FINAL       
FROM #RPT_EDT_RECODATE_DIFF      
      
DECLARE @EMAILS VARCHAR(4000),@BODYCONTENT VARCHAR(MAX),@PEOPLE VARCHAR(4000),@SNAME VARCHAR(4000),@SUB VARCHAR(4000),@XML VARCHAR(MAX),@TBLE VARCHAR(MAX),@SUB1 VARCHAR(4000)                    
            
SET @SUB = 'Edt Mismatch Report : ' + CONVERT(VARCHAR(11),@RPTDATE,105)            
            
SET @SUB1 = 'Edt Mismatch Report for ' + CONVERT(VARCHAR(11),@RPTDATE,105) + '.'                  
              
SET @XML =  CAST((SELECT [td/@align]='center',[td/@width]='5%',td = EXCHANGE,'',                    
    [td/@align]='center',[td/@width]='5%',td = CLTCODE ,'',             
 [td/@align]='center',[td/@width]='5%',td = VAMT ,'',             
    [td/@align]='center',[td/@width]='5%',td =DRCR,''  ,      
 [td/@align]='center',[td/@width]='5%',td = VTYP,''  ,      
 [td/@align]='center',[td/@width]='10%',td =VNO,'',        
 [td/@align]='center',[td/@width]='10%',td =VDT,'' ,       
 [td/@align]='center',[td/@width]='10%',td =EDT,'',      
 [td/@align]='center',[td/@width]='10%',td =CDT,'',      
 [td/@align]='center',[td/@width]='10%',td =RELDT,'',      
 [td/@align]='center',[td/@width]='10%',td =DDNO,'',       
 [td/@align]='center',[td/@width]='10%',td =NARRATION,'',       
 [td/@align]='center',[td/@width]='5%',td =ENTEREDBY,''      
FROM #RPT_EDT_RECODATE_DIFF_FINAL ORDER BY VDT ASC FOR XML PATH('TR'), ELEMENTS ) AS VARCHAR(MAX))                    
              
SET @TBLE ='<HTML><HEAD><STYLE>BODY>TABLE>TBODY>TR>TD:NTH-CHILD(1)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(2)BODY>TABLE>TBODY > TR > TD:NTH-CHILD(3)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(4)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(5)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(6)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(7)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(10) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(11)BODY > TABLE > TBODY > TR > TD:NTH-CHILD(12) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(13) </STYLE> </HEAD> <TABLE BORDER = 1;> <THEAD> <TR STYLE="BACKGROUND-COLOR: #4F6E9C; COLOR: WHITE; FONT-SIZE: 13PX">  <TH> EXCHANGE </TH> <TH> CLTCODE </TH>  <TH> VAMT </TH><TH> DRCR </TH><TH> VTYP </TH><TH> VNO </TH><TH> VDT </TH><TH> EDT </TH>   <TH> CDT </TH><TH> RELDT </TH><TH> DDNO </TH><TH> NARRATION </TH><TH> ENTEREDBY </TH></TR> </THEAD><TBODY STYLE="FONT-SIZE: 13PX;">'                        
                    
SET @TBLE = @TBLE + @XML +'</TBODY></TABLE></BODY></HTML>'                    
                    
SELECT @BODYCONTENT = '<P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">Dear All,</SPAN></P><P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">'+ @SUB1 + '</P>'+@TBLE+''           
               
EXEC MSDB.DBO.SP_SEND_DBMAIL                     
@PROFILE_NAME='BO SUPPORT',                     
@RECIPIENTS='csobankreco@angelbroking.com;swapnil.kank@angelbroking.com;sagar.soner@angelbroking.com;sanjay.karamalkar@angelbroking.com;arjun.ghodke@angelbroking.com;nileshk.bhosle@angelbroking.com;chetan.dave@angelbroking.com',                     
@copy_recipients ='nirmal.purohit@angelbroking.com;vishal.doshi@angelbroking.com;nikunj.shah@angelbroking.com;narayan.patankar@angelbroking.com',            
@blind_copy_recipients='ananthanarayanan.b@angelbroking.com',                    
@SUBJECT=@SUB,                    
@BODY=@BODYCONTENT,                    
@IMPORTANCE = 'HIGH',                    
@BODY_FORMAT ='HTML'          
      
DROP TABLE #RPT_EDT_RECODATE_DIFF      
DROP TABLE #RPT_EDT_RECODATE_DIFF_FINAL

GO
