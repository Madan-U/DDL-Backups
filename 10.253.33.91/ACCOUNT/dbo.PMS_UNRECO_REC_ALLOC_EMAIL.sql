-- Object: PROCEDURE dbo.PMS_UNRECO_REC_ALLOC_EMAIL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--Altered this sp under SRE-41448
------------------MODIFIED THIS PROCEDURE UNDER SRE-41448 DATED ON 03-NOV-2025----------------------------------------------

CREATE PROCEDURE [dbo].[PMS_UNRECO_REC_ALLOC_EMAIL]       
          
AS ---- EXEC [PMS_UNRECO_REC_ALLOC] 'AUG 16 2022'          
      
DECLARE @EDTDATE DATETIME = (GETDATE())          
            
SELECT A.CLTCODE,BANKCODE=CONVERT(VARCHAR(20),''),BANK_NAME=CONVERT(VARCHAR(MAX),''),            
A.VDT,A.EDT,RELDATE=CONVERT(DATETIME,''),A.VNO,A.VTYP,DDNO=CONVERT(VARCHAR(500),''),            
A.DRCR,A.VAMT,A.CDT,A.ENTEREDBY,A.CHECKEDBY,A.NARRATION INTO #EDTRPT            
FROM LEDGER A WITH (NOLOCK), MSAJAG.DBO.CLIENT_DETAILS B WITH (NOLOCK)            
WHERE A.CLTCODE = B.CL_CODE            
AND VDT > = @EDTDATE-10 AND VDT  < = @EDTDATE + ' 23:59:59' AND RIGHT(LEFT(EDT,11),4) = '2049'            
AND A.VTYP = 2 AND A.ENTEREDBY NOT IN ('TPR','B_TPR','B_KYC','TPR1','PMTGATEWAY')            
            
UPDATE #EDTRPT SET BANKCODE = B.CLTCODE, BANK_NAME = B.ACNAME FROM #EDTRPT A, LEDGER B WITH (NOLOCK)            
WHERE A.VNO = B.VNO AND A.VTYP = B.VTYP AND A.VAMT = B.VAMT AND A.CLTCODE <>  B.CLTCODE            
            
UPDATE #EDTRPT SET RELDATE = B.reldt, DDNO= B.ddno FROM #EDTRPT A, LEDGER1 B WITH (NOLOCK)            
WHERE A.VNO = B.VNO AND A.VTYP = B.VTYP AND A.VAMT = B.relamt            
            
DELETE FROM #EDTRPT WHERE NARRATION LIKE '%VIRTUAL%'          
          
DELETE FROM #EDTRPT WHERE NARRATION LIKE '%AMOUNT RECEIVED%'          
          
SELECT CLTCODE,VDT,CONVERT(NUMERIC(18,2),SUM(VAMT)) AS AMOUNT INTO #EDTRPT_FINAL FROM #EDTRPT  GROUP BY CLTCODE,VDT ORDER BY CLTCODE        
        
ALTER TABLE #EDTRPT_FINAL ADD SRNO INT IDENTITY (1,1)         
        
DECLARE @EMAILS VARCHAR(4000),@BODYCONTENT VARCHAR(MAX),@SUB VARCHAR(4000),@XML VARCHAR(MAX),@TBLE VARCHAR(MAX),@SUB1 VARCHAR(4000)                
        
SET @SUB = 'UnRecon Client status as on : ' + CONVERT(VARCHAR(11),@EDTDATE,105)        
        
SET @SUB1 = '

Kindly consider the below-mentioned CMS UnRecon entries as on '+ CONVERT(VARCHAR(11),@EDTDATE,105) + '.' +

'Please take necessary action related to square-off, limit, or trading exposure as per Risk policies and regulatory guidelines.'               
          
SET @XML =  CAST((SELECT [td/@align]='center',[td/@width]='10%',td = SRNO,'',                
    [td/@align]='center',[td/@width]='30%',td = CLTCODE ,'',                
    [td/@align]='center',[td/@width]='30%',td =VDT,'',
	[td/@align]='center',[td/@width]='30%',td =AMOUNT,''
FROM #EDTRPT_FINAL ORDER BY SRNO ASC FOR XML PATH('TR'), ELEMENTS ) AS VARCHAR(MAX))                
          
SET @TBLE ='<HTML><HEAD><STYLE>BODY>TABLE>TBODY>TR>TD:NTH-CHILD(1)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(2)BODY>TABLE>TBODY > TR > TD:NTH-CHILD(3)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(4)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(5)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(6)BODY>TABLE
>TBODY>TR>TD:NTH-CHILD(7)BODY>TABLE>TBODY>TR>TD:NTH-CHILD(10) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(11)BODY > TABLE > TBODY > TR > TD:NTH-CHILD(12) BODY > TABLE > TBODY > TR > TD:NTH-CHILD(13) </STYLE> </HEAD> <TABLE BORDER = 1;> <THEAD> <TR STYLE="BACKGROUND-COLOR: #4F6E9C; COLOR: WHITE; FONT-SIZE: 13PX"><TH> Srno </TH> <TH> CLTCODE </TH><TH> VDT </TH><TH> AMOUNT </TH></TR> </THEAD><TBODY STYLE="FONT-SIZE: 13PX;">'                    
                
SET @TBLE = @TBLE + @XML +'</TBODY></TABLE></BODY></HTML>'                
                
SELECT @BODYCONTENT = '<P><SPAN STYLE="COLOR: RGB(0, 0, 0); FONT-FAMILY: VERDANA; FONT-SIZE: MEDIUM; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACING: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; T
EXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION-STYLE: INITIAL; TEXT-DECORATION-COLOR: INIT
IAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">Dear All,</SPAN></P><P><SPAN STYLE="COLOR: RGB(0, 0, 0); FONT-FAMILY: VERDANA; FONT-SIZE: MEDIUM; FONT-STYLE: NORMAL; FONT-VARIANT-LIGATURES: NORMAL; FONT-VARIANT-CAPS: NORMAL; FONT-WEIGHT: 400; LETTER-SPACI
NG: NORMAL; ORPHANS: 2; TEXT-ALIGN: START; TEXT-INDENT: 0PX; TEXT-TRANSFORM: NONE; WHITE-SPACE: NORMAL; WIDOWS: 2; WORD-SPACING: 0PX; -WEBKIT-TEXT-STROKE-WIDTH: 0PX; BACKGROUND-COLOR: RGB(255, 255, 255); TEXT-DECORATION-THICKNESS: INITIAL; TEXT-DECORATION
-STYLE: INITIAL; TEXT-DECORATION-COLOR: INITIAL; DISPLAY: INLINE !IMPORTANT; FLOAT: NONE;">' + @SUB1 + '</P>'+@TBLE+''              

EXEC MSDB.DBO.SP_SEND_DBMAIL               
@PROFILE_NAME='BO SUPPORT',               
@RECIPIENTS='harigopal.thanvi@angelbroking.com;tushar.jorigal@angelbroking.com;csorm@angelbroking.com;csosurveillance@angelbroking.com;vishal@angelone.in',               
@copy_recipients ='swapnil.kank@angelbroking.com;rohit.kadam@angelbroking.com;vishal.doshi@angelbroking.com;narayan.patankar@angelbroking.com;Chetan.dave@angelbroking.com;rahulc.shah@angelbroking.com;csobankreco@angelone.in',      
--@blind_copy_recipients='ananthanarayanan.b@angelbroking.com',              
@SUBJECT=@SUB,              
@BODY=@BODYCONTENT,              
@IMPORTANCE = 'HIGH',              
@BODY_FORMAT ='HTML'    
/*,    
--@execute_query_database = 'Account',    
@query= 'SELECT [SRNO],[CLTCODE],[AMOUNT] FROM tempdb.dbo.#EDTRPT_FINAL ORDER BY SRNO',    
@query_result_header = 1,    
@query_no_truncate = 1,    
@query_result_no_padding = 0,    
@query_result_width = 2500,    
@attach_query_result_as_file = 1,    
@query_attachment_filename   = 'UnRecoFile.csv',    
@query_result_separator      = ','    
*/    
      
DROP TABLE #EDTRPT_FINAL      
DROP TABLE #EDTRPT    
  
--EXEC [PMS_UNRECO_REC_ALLOC_AR_EMAIL]  

EXEC INHOUSE.DBO.CHECKDIFFMTFCLASSINHOUSE_EMAIL  

EXEC INHOUSE.DBO.MTF_CASHCOLL_EMAIL    

EXEC MSAJAG.DBO.PAYOUT_DPID_MISSING_ANG  
  
EXEC CLIENT_TRADE_COUNT_EMAIL  

EXEC INHOUSE.DBO.OUTSIDEDPPAYOUTDATA_ANG_EMAIL
  
EXEC INHOUSE.DBO.NRI_AUCTION_ANG_EMAIL_ANG

GO
