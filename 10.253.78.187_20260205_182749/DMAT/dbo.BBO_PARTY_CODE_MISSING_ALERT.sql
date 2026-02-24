-- Object: PROCEDURE dbo.BBO/PARTY_CODE_MISSING_ALERT
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE PROC [dbo].[BBO/PARTY_CODE_MISSING_ALERT]
AS
BEGIN 
SELECT ROW_NUMBER() OVER(ORDER BY ACTIVE_DATE )SRNO,NISE_PARTY_CODE,CLIENT_CODE,ITPAN,FIRST_HOLD_NAME,ACTIVE_DATE,STATUS,POA_VER,SUB_TYPE 
INTO #BBO_1
FROm TBL_CLIENT_MASTER
WHERE ACTIVE_DATE >='2021-01-01'
AND ISNULL(NISE_PARTY_CODE,'')=''
AND STATUS='ACTIVE'


SELECT A.*,B.PARTY_CODE AS BO_PARTY_CODE ,B.PAN_GIR_NO AS BO_PAN_NO INTO #BBO FROM #BBO_1 A LEFT OUTER JOIN [AngelNseCM].MSAJAG.DBO.CLIENT_DETAILS B ON A.ITPAN=B.PAN_GIR_NO


IF (SELECT COUNT(1) FROM #BBO )<1
BEGIN
		RETURN
END

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
N'<TR><TH BGCOLOR = "#00bfff">SRNO</TH>          
<TH BGCOLOR = "#00bfff">NISE_PARTY_CODE</TH>          
<TH BGCOLOR = "#00bfff">CLIENT_CODE</TH>          
<TH BGCOLOR = "#00bfff">ITPAN</TH>         
<TH BGCOLOR = "#00bfff">FIRST_HOLD_NAME</TH>     
<TH BGCOLOR = "#00bfff">DP ACTIVE_DATE</TH>     
<TH BGCOLOR = "#00bfff">STATUS</TH>     
<TH BGCOLOR = "#00bfff">POA_VER</TH>     
<TH BGCOLOR = "#00bfff">SUB_TYPE</TH>    
 <TH BGCOLOR = "#00bfff">BO_PARTY_CODE</TH>    
<TH BGCOLOR = "#00bfff">BO_PAN_NO</TH>    
    
</TR>' +          
      
CAST ( (         

select  [SRNO],'', TD = ISNULL([NISE_PARTY_CODE],''),'', TD = [CLIENT_CODE],''  ,TD = [ITPAN],'',TD = [FIRST_HOLD_NAME],'', [ACTIVE_DATE]=(CONVERT(VARCHAR(11),ACTIVE_DATE)),'',TD = [STATUS],'',TD = ISNULL([POA_VER],''),'',TD =ISNULL([SUB_TYPE],''),'',TD = ISNULL([BO_PARTY_CODE],'--'),'',TD= ISNULL([BO_PAN_NO],'--')

 from #BBO    ORDER BY [SRNO] -- where [SRNO] =1
       
 FOR XML PATH('TR'), TYPE           
      
) AS NVARCHAR(MAX) ) +  
N'</TABLE>' 
    
      
      
EXEC MSDB.DBO.SP_SEND_DBMAIL          
@PROFILE_NAME ='DBA',      
@RECIPIENTS='suresh.raut@angelbroking.com;deepak.redekar@angelbroking.com;lal.singh@angelbroking.com;majid.shaikh@angelbroking.com;hyd-kycsouth@angelbroking.com' ,          
@COPY_RECIPIENTS='PUNIT.VERMA@angelbroking.com;rahulc.shah@angelbroking.com;siva.kopparapu@angelbroking.com',   
@BODY = @TABLEHTML,    
@SUBJECT = @SUBJECT,           
@BODY_FORMAT = 'HTML' ;          
      
      
END

GO
