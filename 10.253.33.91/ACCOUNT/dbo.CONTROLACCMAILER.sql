-- Object: PROCEDURE dbo.CONTROLACCMAILER
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------




CREATE PROC [dbo].[CONTROLACCMAILER]    
AS    

----exec CONTROLACCMAILER
    
    --Altered SP under SRE-28013
DECLARE @EDT VARCHAR(11) = (GETDATE()-1)      
    
    
CREATE TABLE #CONTROL_ACC_ANG(SRNO INT,DATEF VARCHAR(11),SCLTCODE VARCHAR(50),SSEGMENT VARCHAR(50),SAMOUNT NUMERIC(18,2),TCLTCODE VARCHAR(50),TSEGMENT VARCHAR(50),TAMOUNT NUMERIC(18,2),DIFFAMOUNT NUMERIC(18,2))  
    
INSERT INTO #CONTROL_ACC_ANG EXEC CONTROL_ACC_ANG @EDT  
  
TRUNCATE TABLE CONTROL_ACC_ANG_TBL    
  
INSERT INTO CONTROL_ACC_ANG_TBL VALUES ('SRNO,DATEF,SCLTCODE,SSEGMENT,SAMOUNT,TCLTCODE,TSEGMENT,TAMOUNT,DIFFAMOUNT')  
  
INSERT INTO CONTROL_ACC_ANG_TBL  
SELECT CONVERT(VARCHAR(8000),CONVERT(VARCHAR(8000),SRNO)+','+CONVERT(VARCHAR(8000),DATEF)+','+CONVERT(VARCHAR(8000),SCLTCODE)+','+
CONVERT(VARCHAR(8000),SSEGMENT)+','+CONVERT(VARCHAR(8000),SAMOUNT)+','+CONVERT(VARCHAR(8000),TCLTCODE)+','+
CONVERT(VARCHAR(8000),TSEGMENT)+','+CONVERT(VARCHAR(8000),TAMOUNT)+','+CONVERT(VARCHAR(8000),DIFFAMOUNT))   AS A
FROM #CONTROL_ACC_ANG ORDER BY DIFFAMOUNT ASC,SRNO ASC
        
DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'CONTROL_ACC_ANG_'+ REPLACE(CONVERT(VARCHAR(11), @EDT, 104), ' ', '-') + '.CSV'                
--DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [ANGELFO].[NSECURFO].[DBO].MISSING_DISBROK  ''' + @SAUDA_DATE_L + ''''            
DECLARE @ADSTMT NVARCHAR(4000) = 'SELECT * FROM [ANAND1].[ACCOUNT].DBO.CONTROL_ACC_ANG_TBL'            
DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'                
                
EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT        
      
DECLARE @EMAILS VARCHAR(4000),@BODYCONTENT VARCHAR(MAX),@PEOPLE VARCHAR(4000),@SNAME VARCHAR(4000),@SUB VARCHAR(4000),@XML VARCHAR(MAX),@TBLE VARCHAR(MAX),@SUB1 VARCHAR(4000)            
    
SET @SUB = 'Control Account Recon status as on : ' + CONVERT(VARCHAR(11),@edt,105)    
    
IF (SELECT SUM(DIFFAMOUNT) FROM #CONTROL_ACC_ANG) = 0.00    
BEGIN     
SET @SUB1 = 'Control Account Recon status as on : ' + CONVERT(VARCHAR(11),@edt,105) + ' . All the Accounts for till the day are are ' + '<SPAN STYLE="COLOR:green"> Matched. </span>'    
END    
ELSE    
BEGIN     
SET @SUB1 = 'Control Account Recon status as on : ' + CONVERT(VARCHAR(11),@edt,105) + ' . Some Accounts for till the day are ' + '<SPAN STYLE="COLOR:red"> Unmatched </span>' + ' . Please check Detail Below.'         
END    
            
--SET @SUB1 = 'Please find below all control account recon status up to ' + CONVERT(VARCHAR(11),@edt,105)          
            
SET @XML =  CAST((SELECT [td/@align]='center',[td/@width]='10%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = SRNO,'',            
    [td/@align]='center',[td/@width]='11%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = DATEF ,'',            
    [td/@align]='center',[td/@width]='10%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td =SCLTCODE,'',            
    [td/@align]='center',[td/@width]='10%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = SSEGMENT,'',            
    [td/@align]='center',[td/@width]='13%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = SAMOUNT,'',            
    [td/@align]='center',[td/@width]='10%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = TCLTCODE ,'',            
    [td/@align]='center',[td/@width]='10%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = TSEGMENT,'',      
 [td/@align]='center',[td/@width]='13%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = TAMOUNT,'' ,    
 [td/@align]='center',[td/@width]='13%',[td/@style] = case when DIFFAMOUNT <> 0  then 'color:red' else 'color:green' end,td = DIFFAMOUNT,''      
FROM #CONTROL_ACC_ANG ORDER BY DIFFAMOUNT ASC,SRNO ASC FOR XML PATH('TR'), ELEMENTS ) AS VARCHAR(MAX))            
      
      
SET @TBLE ='<HTML><HEAD><STYLE>BODY>TABLE>TBODY>TR>TD:NTH-CHILD(1)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(2)BODY>TABLE>TBODY > TR > TD:NTH-CHILD(3)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(4)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(5)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(6)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(7)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(10) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(11)BODY > TABLE > TBODY > TR > TD:NTH-CHILD(12) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(13) </STYLE> </HEAD> <TABLE BORDER = 1;> <THEAD> <TR STYLE="BACKGROUND-COLOR: #4F6E9C; COLOR: WHITE; FONT-SIZE: 13PX"><TH> Srno </TH> <TH> Date </TH><TH> Scltcode </TH><TH> Ssemgnet </TH> <TH> Samount </TH> <TH> Tcltcode </TH> <TH> Tsemgnet </TH> <TH> Tamount </TH> <TH> DiffAmount </TH> </TR> </THEAD><TBODY STYLE="FONT-SIZE: 13PX;">'                
            
SET @TBLE = @TBLE + @XML +'</TBODY></TABLE></BODY></HTML>'            
            
SELECT @BODYCONTENT = '<P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">Dear All,</SPAN></P><P><SPAN STYLE="COLOR: RGB(0, 0, 128); FONT-FAMILY: VERDANA; FONT-SIZE: SMALL; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">'+ @SUB1 + '</P>'+@TBLE+''            
           
EXEC MSDB.DBO.SP_SEND_DBMAIL             
@PROFILE_NAME='BO SUPPORT',             
@RECIPIENTS='sajeev@angelbroking.com;banking@angelbroking.com;prathamesh.1gandhi@angelbroking.com;ayaz.shaikh@angelbroking.com',             
@copy_recipients ='rahulc.shah@angelbroking.com',    
@blind_copy_recipients='ganesh.jagdale@angelbroking.com',            
@SUBJECT=@SUB,            
@BODY=@BODYCONTENT,            
@IMPORTANCE = 'HIGH',            
@BODY_FORMAT ='HTML'            
    


DROP TABLE #CONTROL_ACC_ANG    
  
--RPT_ALERT_DELAYINACTIVE

GO
