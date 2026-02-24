-- Object: PROCEDURE dbo.STT_STAMP_DUTY_MASTER_ISSUE_TRADE_PROCESS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC [dbo].[STT_STAMP_DUTY_MASTER_ISSUE_TRADE_PROCESS] 
AS 
BEGIN

SELECT CL_CODE,TRD_STT,DEL_STT,TRD_STAMP_DUTY,DEL_STAMP_DUTY ,EXCHANGE,SEGMENT

INTO #STT_MASTER_ISSUE 
FROM CLIENT_BROK_DETAILS WITH (NOLOCK)
WHERE (TRD_STT =0 OR TRD_STAMP_DUTY =0)
AND INACTIVE_FROM > GETDATE()
AND EXCHANGE NOT IN ('NSX','BSX','MCD','BSE')
AND SEGMENT='FUTURES'
UNION ALL
SELECT CL_CODE,TRD_STT,DEL_STT,TRD_STAMP_DUTY,DEL_STAMP_DUTY,EXCHANGE,SEGMENT
FROM CLIENT_BROK_DETAILS WITH (NOLOCK)
WHERE (TRD_STT =0 OR TRD_STAMP_DUTY =0)
AND INACTIVE_FROM > GETDATE()
--AND EXCHANGE NOT IN ('NSX','BSX','MCD','BSE')
AND SEGMENT NOT IN ( 'FUTURES','SLBS')


 DECLARE @P_COUNT NVARCHAR(100) 
 SELECT @P_COUNT =COUNT(DISTINCT CL_CODE ) FROM #STT_MASTER_ISSUE
    


DECLARE @BODYMSG NVARCHAR(MAX)          
      
DECLARE @SUBJECT NVARCHAR(MAX)          
      
DECLARE @TABLEHTML NVARCHAR(MAX)        

DECLARE @DATE VARCHAR(20)      
SET  @DATE = GETDATE()      
            
SET @SUBJECT = 'STT_STAMP_DUTY_ISSUE IN TRADE PROCESS' + ' '+ @DATE         
      
SET @TABLEHTML =           
      
N'<STYLE TYPE="TEXT/CSS">         
#BOX-TABLE          
{          
FONT-FAMILY: "LUCIDA SANS UNICODE", "LUCIDA GRANDE", SANS-SERIF;          
FONT-SIZE: 12PX;          
TEXT-ALIGN: CENTER;          
BORDER-COLLAPSE: COLLAPSE;          
BORDER-TOP: 7PX SOLID #9BAFF1;          
BORDER-BOTTOM: 7PX SOLID #9BAFF1;          
}          
#BOX-TABLE TH          
{          
FONT-SIZE: 13PX;          
FONT-WEIGHT: NORMAL;          
BACKGROUND: #B9C9FE;          
BORDER-RIGHT: 2PX SOLID #9BAFF1;          
BORDER-LEFT: 2PX SOLID #9BAFF1;          
BORDER-BOTTOM: 2PX SOLID #9BAFF1;          
COLOR: #039;          
}          
#BOX-TABLE TD          
{          
BORDER-RIGHT: 1PX SOLID #AABCFE;          
BORDER-LEFT: 1PX SOLID #AABCFE;          
BORDER-BOTTOM: 1PX SOLID #AABCFE;          
COLOR: #669;          
}          
TR:NTH-CHILD(ODD) { BACKGROUND-COLOR:#EEE; }          
TR:NTH-CHILD(EVEN) { BACKGROUND-COLOR:#FFF; }           
</STYLE>'+           
N'<H3><FONT COLOR="BLUE">BELOW ARE THE LIST OF CLIENTS '+'('+@P_COUNT+')'+' WITH MISMATCHED STT/STAMP DUTY.</H3>' +          
N'<TABLE BORDER=1 >' +          
N'<TR><TH>CL_CODE</TH>          
<TH>TRD_STT</TH>          
<TH>DEL_STT</TH>          
<TH>TRD_STAMP_DUTY</TH>      
<TH>DEL_STAMP_DUTY</TH>     
<TH>EXCHANGE</TH>      
<TH>SEGMENT</TH>               
</TR>' +          
      
CAST ( (         
         
select CL_CODE=[CL_CODE],TD = [TRD_STT],'', TD = [DEL_STT],'', TD = [TRD_STAMP_DUTY] ,'',TD = [DEL_STAMP_DUTY]   ,'',  TD = [EXCHANGE],'' ,TD = [SEGMENT]
     
 from #STT_MASTER_ISSUE       
       
 FOR XML PATH('TR'), TYPE           
      
) AS NVARCHAR(MAX) ) +        
N'</TABLE>'           
      
      
EXEC MSDB.DBO.SP_SEND_DBMAIL
@PROFILE_NAME ='DBA', 
--@COPY_RECIPIENTS='',       
@RECIPIENTS='updationteam@angelbroking.com;shashi.soni@angelbroking.com;siva.kopparapu@angelbroking.com;hyd-kycsouth@angelbroking.com;deepak.redekar@angelbroking.com' ,          
@COPY_RECIPIENTS='punit.verma@angelbroking.com',          
@SUBJECT = @SUBJECT,          
@BODY = @TABLEHTML,           
@BODY_FORMAT = 'HTML' ;          
      
      END

GO
