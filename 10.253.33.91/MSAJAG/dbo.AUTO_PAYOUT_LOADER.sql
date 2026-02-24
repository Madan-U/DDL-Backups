-- Object: PROCEDURE dbo.AUTO_PAYOUT_LOADER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE PROC [dbo].[AUTO_PAYOUT_LOADER]  
  
AS  
  
SELECT DISTINCT CL_CODE CL_CODE_96 INTO #CLIENT1 FROM CLIENT1  
SELECT DISTINCT CL_CODE CL_CODE_97 INTO #CLIENT1_97 FROM [AngelDemat].MSAJAG.DBO.CLIENT1   
  
SELECT CL_CODE_96, CL_CODE_97 INTO #FINAL_PARTY  
FROM #CLIENT1 A LEFT OUTER JOIN #CLIENT1_97  
 ON CL_CODE_96 = CL_CODE_97  
 WHERE CL_CODE_97 IS NULL  
  
  
DECLARE @BODYMSG NVARCHAR(MAX)      
DECLARE @SUBJECT NVARCHAR(MAX)      
DECLARE @TABLEHTML NVARCHAR(MAX)    
DECLARE @MIX NVARCHAR(MAX)   
  
SET @SUBJECT = '!!!..URGENT CRITICAL PAYOUT ISSUE..VERYIMPORTANT..!!!'      
  
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
N'<H3><FONT COLOR="BLUE">RUN THE LOADER FOR BELOW CLIENT CODE </H3>' +      
N'<TABLE BORDER=1 >' +      
N'<TR><TH>CL_CODE_96</TH>   
<TH>CL_CODE_97</TH>                  
</TR>' +      
  
CAST ( (     
     
select TD = [CL_CODE_96],TD = [CL_CODE_97]  
  
  
 from #FINAL_PARTY   
   
 FOR XML PATH('TR'), TYPE       
  
) AS NVARCHAR(MAX) ) +    
N'</TABLE>'       
  
EXEC MSDB.DBO.SP_SEND_DBMAIL      
@PROFILE_NAME ='BO SUPPORT',  
@RECIPIENTS='hyd-kyceast@angelbroking.com;hyd-kycsouth@angelbroking.com;kranthi.potla@angeltrade.com;suresh.k@angelbroking.com;lal.singh@angelbroking.com' ,      
--@RECIPIENTS='punit.verma@angelbroking.com' ,    
@COPY_RECIPIENTS='vijay.agre@angelbroking.com;vilasnaram@angelbroking.com;darshit.kapadia@angelbroking.com;ashok.maniyar@angelbroking.com;deepak.redekar@angelbroking.com',      
@SUBJECT = @SUBJECT,      
@BODY = @TABLEHTML,       
@BODY_FORMAT = 'HTML' ;

GO
