-- Object: PROCEDURE dbo.RPT_DAILY_MG13_BKUP_28JUN2024
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[RPT_DAILY_MG13_BKUP_28JUN2024] (@RUNDATE VARCHAR(11),@PARTY VARCHAR(11),@RPT VARCHAR(11))  
  
AS ---- EXEC RPT_EXCHANGE_PEAK_MARGIN 'AUG 27 2021','GRMB131','NSECM'  
  
IF @RPT = 'NSECM'  
BEGIN  
  
SELECT [Trade Date]=CONVERT(VARCHAR(11),MARGINDATE,105),[Client Code]=PARTY_CODE,[VAR margin + Extreme Loss margin]=VARMARGIN,  
[Minimum Margin]=EXTREME_LOSS_MARGIN,[ Additional Margin]=ADDITIONAL_MARGIN,[MTM Loss]=MTOM_LOSS,  
[Total Actual Margin ]=TOTAL_MARGIN_VAR,[Total Margin to be Collected]=TOTAL_MARGIN,Peakmargin,[Client Flag]=CL_FLAG,Exchange='NSECM'  
FROM MSAJAG.DBO.TBL_CMMARGIN WITH (NOLOCK)  
WHERE MARGINDATE BETWEEN @RUNDATE AND @RUNDATE + ' 23:59'  
AND PARTY_CODE = @PARTY  
ORDER BY PARTY_CODE  
  
END  
  
IF @RPT = 'NSEFO'  
BEGIN  
SELECT [Trade Date]=convert(varchar(11),mdate,105),[Client Code]=party_code,[Span Margin]=spreadmargin,  
Filler=NonSpreadMargin,[Extreme Loss Margin]=mtom,[Delivery margin]=DEL_MARGIN,[Cystallized Obligation]=mtomloss,  
[Total Margin to be Collected]=TotalMargin,Peakmargin,[Client Flag]=Cl_Type,Exchange='NSEFO'  
from ANGELFO.NSEFO.DBO.FOMARGINNEW with (nolock)  
WHERE MDATE BETWEEN @RUNDATE AND @RUNDATE + ' 23:59'   
AND PARTY_CODE = @PARTY  
ORDER BY PARTY_CODE  
END  
  
IF @RPT = 'NSECD'  
BEGIN  
select [Trade Date]=convert(varchar(11),mdate,105),[Client Code]=party_code,[Span Margin]=spreadmargin,  
Filler=nonspreadmargin,[Extreme Loss Margin]=mtom,[Cystallized Obligation]=mtomloss,[Total Margin to be Collected]=totalmargin,Peakmargin,  
[Client Flag]=cl_type,Exchange='NSECD'  
from angelfo.nsecurfo.dbo.fomarginnew with (nolock)   
WHERE MDATE BETWEEN @RUNDATE AND @RUNDATE + ' 23:59'   
AND PARTY_CODE = @PARTY  
END  
  
IF @RPT = 'MCDX'  
BEGIN  
/*
SELECT [Trade Date]=convert(varchar(11),mdate,105),[Client Code]=party_code,[Initial Mrgin]=PMARGIN,[Other Margin]=0,MTM=MTOM,  
Reserved=0,Reserved=0,[MTM Collected]=PMARGINAMOUNT,[Initial Margin Collected]=TOTALMARGIN,[Other Margin Collected]=0,[Peak Margin Threshold %]=75,  
[Peak Margin]=SPREADMARGIN,Segments='MCDX'  
FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW WITH (NOLOCK)   
WHERE MDATE BETWEEN @RUNDATE AND @RUNDATE + ' 23:59'  
AND PARTY_CODE = @PARTY  
*/

SELECT [TRADE DATE]=CONVERT(VARCHAR(11),MDATE,105),[CLIENT CODE]=PARTY_CODE,[INITIAL MRGIN]=REGULARMARGIN,[OTHER MARGIN]=0,MTM=MTOMMARGIN,  
RESERVED=0,RESERVED=0,[MTM COLLECTED]=MTOMMARGIN,[INITIAL MARGIN COLLECTED]=REGULARMARGIN,[OTHER MARGIN COLLECTED]=0,
[PEAK MARGIN THRESHOLD %]=PEAKMARGIN_THRESHOLD,  
[PEAK MARGIN]=PEAKMARGIN,SEGMENTS='MCDX'  
FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW_DATA WITH (NOLOCK)   
WHERE MDATE BETWEEN @RUNDATE AND @RUNDATE + ' 23:59'  
AND PARTY_CODE = @PARTY  

END  
  
IF @RPT = 'NCDX'  
BEGIN  
SELECT [Trade Date]=convert(varchar(11),mdate,105),[Client Code]=party_code,[Initial Mrgin (Initial + Extreme Loss)]=PMARGIN,[Peak Initial Mrgin]=PSPANMARGIN,  
[Other Margin]=ADDMARGIN,MTM=MTOM,[Upfront initial Mrgn Collected]=TOTALMARGIN,[Peak Initial Mrgn Collected]=SPREADMARGIN,  
[Other Margins Collected by T+2]=MARGINPERCENT,[MTM (Gains)/ Loss Collected By T+2]=0,[Shortfall in Initial Mrgn]=0,  
[Shortfall in Peak Mrgn]=0,[Shortfall in Other Mrgn]=0,[Shortfall in MTM (Gain)/Loss]=0,  
Segments='NCDX'  
FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW WITH (NOLOCK)  
WHERE MDATE BETWEEN @RUNDATE AND @RUNDATE + ' 23:59'  
AND PARTY_CODE = @PARTY  
END

GO
