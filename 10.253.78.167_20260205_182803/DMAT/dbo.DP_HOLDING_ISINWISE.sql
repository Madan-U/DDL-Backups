-- Object: PROCEDURE dbo.DP_HOLDING_ISINWISE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

 CREATE PROCEDURE   [dbo].[DP_HOLDING_ISINWISE]

AS begin





	select distinct Td_ac_code, Td_Isin_code, Sum(Td_qty) as Td_QTY,TD_REFERENCE,DEMRM_SLIP_SERIAL_NO into #trxno2201 
	from SYNERGY_TRXN_DETAILS A WITH(NOLOCK) Inner Join CITRUS_USR.DEMAT_REQUEST_MSTR B
	On a.TD_REFERENCE = b.DEMRM_TRANSACTION_NO
AND TD_CURDATE > DATEADD(DAY, -2, GETDATE()) and TD_CURDATE < DATEADD(DAY, -1, GETDATE())
and td_trxno = '2201' 
Group by Td_ac_code, Td_Isin_code,DEMRM_SLIP_SERIAL_NO, TD_REFERENCE
Order by Td_ac_code, Td_Isin_code, Td_qty,DEMRM_SLIP_SERIAL_NO, TD_REFERENCE


	Select Td_ac_code,a.TD_ISIN_CODE,Td_qty,CLOPM_DT ,DEMRM_SLIP_SERIAL_NO

into #final1 from #trxno2201  a WITH (NOLOCK) , CITRUS_USR.closing_price_mstr_cdsl b WITH (NOLOCK) 

where  b.Clopm_isin_cd = a.TD_ISIN_CODE

and B.CLOPM_DT > DATEADD(DAY, -2, GETDATE()) and B.CLOPM_DT < DATEADD(DAY, -1, GETDATE())

Group by Td_ac_code,b.Clopm_isin_cd,a.TD_ISIN_CODE,Td_qty, B.CLOPM_DT,DEMRM_SLIP_SERIAL_NO


--Select * from closing_price_mstr_cdsl

	Select a.*,b.CLOPM_CDSL_RT  into #closing_price_mstr_cdsl from #final1 a ,CITRUS_USR.closing_price_mstr_cdsl b WITH (NOLOCK)

where  b.Clopm_isin_cd = a.TD_ISIN_CODE

and a.CLOPM_DT =b.CLOPM_DT

order by Td_ac_code,b.Clopm_isin_cd,a.TD_ISIN_CODE,Td_qty


	select  Td_ac_code,TD_ISIN_CODE,CLOPM_DT,Td_qty,CLOPM_CDSL_RT,Value,DEMRM_SLIP_SERIAL_NO Into #MULTI from

	(Select Td_ac_code,TD_ISIN_CODE,CLOPM_DT,Td_qty,CLOPM_CDSL_RT,Value = (Td_qty * CLOPM_CDSL_RT),DEMRM_SLIP_SERIAL_NO from #closing_price_mstr_cdsl)a

	where Value >= '500000' order by Td_qty desc


Select B.First_hold_name, b.NISE_PARTY_CODE, A.* into #RESULT from #MULTI A Inner join tbl_Client_master B

On a.Td_ac_code = B.CLIENT_CODE

--Select top 10 * from ISIN_MSTR where isin_cd='INE094A01015'


	Select C.CLOPM_DT as DATE,C.First_hold_name as PARTY_NAME,C.NISE_PARTY_CODE AS PARTY_CODE,C.Td_ac_code as CLIENT_ID,DEMRM_SLIP_SERIAL_NO AS SERIAL_NO, 
d.Isin_Name as SCRIP_NAME, C.TD_ISIN_CODE as SCRIP_ISIN,C.Td_qty as QTY,C.CLOPM_CDSL_RT as CL_RATE, CAST ( C.ValuE AS decimal(20,2) )as VALUE

into #DP_HOLDING_ISINWISE
from #RESULT C Inner Join CITRUS_USR.ISIN_MSTR D
On d.Isin_cd = C.TD_isin_code




DECLARE @BODYMSG NVARCHAR(MAX)    

DECLARE @SUBJECT NVARCHAR(MAX)    

DECLARE @TABLEHTML NVARCHAR(MAX)    

SET @SUBJECT = 'High Value DRF - Alert Report'     

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
N'<H3><FONT COLOR="BLUE">RECORDS FOR THE DAY</H3>' +    
N'<TABLE BORDER=1 >' +    
N'<TR><TH>DATE</TH>    
<TH>PARTY NAME</TH>    
<TH>PARTY CODE</TH>    
<TH>CLIENT ID</TH>
<TH>SERIAL NO</TH>    
<TH>SCRIP NAME</TH>    
<TH>SCRIP ISIN</TH>    
<TH>QTY</TH>    
<TH>CL RATE</TH>    
<TH>VALUE</TH>       
</TR>' +    


CAST ( (   
   


select DATE=(CONVERT(VARCHAR(20),DATE,103)),TD = [PARTY_NAME],'', TD = [PARTY_CODE],'', TD = [CLIENT_ID] ,'',TD = [SERIAL_NO],'',TD = [SCRIP_NAME],'',TD = [SCRIP_ISIN],'',TD = [QTY],'',TD = [CL_RATE],'',
TD = [VALUE],'' 

 from #DP_HOLDING_ISINWISE 
 
 FOR XML PATH('TR'), TYPE     

) AS NVARCHAR(MAX) ) +  
N'</TABLE>'     
EXEC MSDB.DBO.SP_SEND_DBMAIL    
@PROFILE_NAME ='DP AUTO PROCESS TEST PROFILE', @RECIPIENTS='jagannath@angelbroking.com;pmla.cso@angelbroking.com;bhushan.patil@angelbroking.com;pooja.khilnani@angelbroking.com;akshay.jambhale@angelbroking.com;subodh.salvi@angelbroking.com;pravin.rakshe@angelbroking.com;darshna@angelbroking.com' ,  
@COPY_RECIPIENTS='',    
@SUBJECT = @SUBJECT,    
@BODY = @TABLEHTML,    
@BODY_FORMAT = 'HTML' ;    



 END

GO
