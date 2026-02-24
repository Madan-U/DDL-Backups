-- Object: PROCEDURE citrus_usr.BBO/PARTY_CODE_MISSING_ALERT
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE PROC [citrus_usr].[BBO/PARTY_CODE_MISSING_ALERT]
AS
BEGIN 
SELECT ROW_NUMBER() OVER(ORDER BY ACTIVE_DATE DESC)SRNO,NISE_PARTY_CODE,CLIENT_CODE,ITPAN,FIRST_HOLD_NAME,ACTIVE_DATE,STATUS,POA_VER,SUB_TYPE 
INTO #BBO
FROM TBL_CLIENT_MASTER
WHERE  
ISNULL(NISE_PARTY_CODE,'')=''
AND STATUS='ACTIVE'


DECLARE @BODYMSG NVARCHAR(MAX),@DATE VARCHAR(20)=GETDATE()
      
DECLARE @SUBJECT NVARCHAR(MAX)          
      
DECLARE @TABLEHTML NVARCHAR(MAX)          
      
SET @SUBJECT = 'BBO/PARTY_CODE_MISSING_ALERT IN DP '   +  @DATE 
      
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
N'<H3><FONT COLOR="BLUE">BELOW IS THE LIST OF BBO/PARTY CODE MISSING</H3>' +          
N'<TABLE BORDER=1 >' +          
N'<TR><TH BGCOLOR = "#00bfff">SAUDA_DATE</TH>          
<TH BGCOLOR = "#00bfff">B2C</TH>          
<TH BGCOLOR = "#00bfff">INST_TYPE</TH>          
<TH BGCOLOR = "#00bfff">OC</TH>             
</TR>' +          
      
CAST ( (         

select  [SRNO],'', TD = [NISE_PARTY_CODE],'', TD = [CLIENT_CODE]  ,TD = [ITPAN],'',TD = [FIRST_HOLD_NAME],'', [ACTIVE_DATE]=(CONVERT(VARCHAR(20),ACTIVE_DATE)),'',TD = [STATUS],'',TD = [POA_VER],'',TD = [SUB_TYPE] 

 from #BBO      
       
 FOR XML PATH('TR'), TYPE           
      
) AS NVARCHAR(MAX) ) +        
N'</TABLE>'           
      
      
EXEC MSDB.DBO.SP_SEND_DBMAIL          
@PROFILE_NAME ='DBA',      
@RECIPIENTS='hyd-kycsouth@angelbroking.com;lal.singh@angelbroking.com' ,          
@COPY_RECIPIENTS='deepak.redekar@angelbroking.com;sanjay.more@angelbroking.com;Sheetal.Tajane@angelbroking.com;sm.sunnysiddula@angelbroking.com',          
@SUBJECT = @SUBJECT,          
@BODY = @TABLEHTML,           
@BODY_FORMAT = 'HTML' ;          
      
      
END

GO
