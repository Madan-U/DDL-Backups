-- Object: PROCEDURE dbo.ALT_EXCHANGE_OBLIGATION
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE ALT_EXCHANGE_OBLIGATION

AS

DECLARE @FM_DATE VARCHAR(11),@LM_DATE VARCHAR(11)

SELECT @FM_DATE = LEFT(GETDATE()-DAY(GETDATE())+1,11), @LM_DATE = LEFT(CONVERT(DATETIME,EOMONTH(GETDATE())),11)

SELECT EXCHANGE='NSECM',SAUDA_DATE=OLB_DATE,SETT_NO,SETT_TYPE,PAMT=SUM(C_PAMT),SAMT=SUM(C_SAMT),NET_PAYIN_PAYOUT=SUM(C_PAMT)-SUM(C_SAMT) INTO #CASH
FROM MSAJAG.DBO.TBL_NSE_OBL WHERE OLB_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'
GROUP BY SETT_NO,SETT_TYPE,OLB_DATE
ORDER BY OLB_DATE,SETT_NO

SELECT EXCHANGE='NSEFO',SAUDA_DATE=FOEA_POSITION_DATE,PREMIUM_ACCOUNT=SUM(FOEA_NETPREMIUM),
CLEARING_HOUSE = SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE),
OPTION_EX_ALLOCATION=SUM(FOEA_EXERCISED_ASSIGNED_VALUE),
NET_PAYIN_PAYOUT=SUM(FOEA_NETPREMIUM)+SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE)+SUM(FOEA_EXERCISED_ASSIGNED_VALUE) INTO #FNO
FROM ANGELFO.NSEFO.DBO.FOEXERCISEALLOCATION WITH (NOLOCK)
WHERE FOEA_POSITION_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'
GROUP BY FOEA_POSITION_DATE
UNION ALL
SELECT EXCHANGE='NSECD',SAUDA_DATE=FOEA_POSITION_DATE,PREMIUM_ACCOUNT=SUM(FOEA_NETPREMIUM),
CLEARING_HOUSE = SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE),
OPTION_EX_ALLOCATION=SUM(FOEA_EXERCISED_ASSIGNED_VALUE),
NET_PAYIN_PAYOUT=SUM(FOEA_NETPREMIUM)+SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE)+SUM(FOEA_EXERCISED_ASSIGNED_VALUE)
FROM ANGELFO.NSECURFO.DBO.FOEXERCISEALLOCATION WITH (NOLOCK)
WHERE FOEA_POSITION_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'
GROUP BY FOEA_POSITION_DATE
UNION ALL
SELECT EXCHANGE='MCDX',SAUDA_DATE=FOEA_POSITION_DATE,PREMIUM_ACCOUNT=SUM(FOEA_NETPREMIUM),
CLEARING_HOUSE = SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE),
OPTION_EX_ALLOCATION=SUM(FOEA_EXERCISED_ASSIGNED_VALUE),
NET_PAYIN_PAYOUT=SUM(FOEA_NETPREMIUM)+SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE)+SUM(FOEA_EXERCISED_ASSIGNED_VALUE)
FROM ANGELCOMMODITY.MCDX.DBO.FOEXERCISEALLOCATION WITH (NOLOCK)
WHERE FOEA_POSITION_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'
GROUP BY FOEA_POSITION_DATE
UNION ALL
SELECT EXCHANGE='NCDX',SAUDA_DATE=FOEA_POSITION_DATE,PREMIUM_ACCOUNT=SUM(FOEA_NETPREMIUM),
CLEARING_HOUSE = SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE),
OPTION_EX_ALLOCATION=SUM(FOEA_EXERCISED_ASSIGNED_VALUE),
NET_PAYIN_PAYOUT=SUM(FOEA_NETPREMIUM)+SUM(FOEA_DAILY_MTM_SETTLEMENT_VALUE) + SUM(FOEA_FUTURES_FINAL_SETTLEMENT_VALUE)+SUM(FOEA_EXERCISED_ASSIGNED_VALUE)
FROM ANGELCOMMODITY.NCDX.DBO.FOEXERCISEALLOCATION WITH (NOLOCK)
WHERE FOEA_POSITION_DATE BETWEEN @FM_DATE AND @LM_DATE + ' 23:59'
GROUP BY FOEA_POSITION_DATE
ORDER BY EXCHANGE,SAUDA_DATE

TRUNCATE TABLE CASH_OBL
TRUNCATE TABLE FNO_OBL

INSERT INTO CASH_OBL
SELECT EXCHANGE,SAUDA_DATE=CONVERT(VARCHAR(11),SAUDA_DATE,105),SETT_NO,SETT_TYPE,PAMT,SAMT,NET_PAYIN_PAYOUT FROM #CASH ORDER BY EXCHANGE,SAUDA_DATE

INSERT INTO FNO_OBL
SELECT EXCHANGE,SAUDA_DATE=CONVERT(VARCHAR(11),SAUDA_DATE,105),PREMIUM_ACCOUNT,CLEARING_HOUSE,OPTION_EX_ALLOCATION,NET_PAYIN_PAYOUT 
FROM #FNO ORDER BY EXCHANGE,SAUDA_DATE


--------- FILE EXPORT

DECLARE @CASHFILENAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'CASH_EXCHANGE_OBL_' + CONVERT(VARCHAR, GETDATE(), 112) + '.CSV'
DECLARE @CASH VARCHAR(MAX)                            
SET @CASH = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''EXCHANGE'''',''''SAUDA_DATE'''',''''SETT_NO'''',''''SETT_TYPE'''',''''PAMT'''',''''SAMT'''',''''NET_PAYIN_PAYOUT''''' 
SET @CASH = @CASH + ' UNION ALL SELECT EXCHANGE,SAUDA_DATE,SETT_NO,SETT_TYPE,CONVERT(VARCHAR,PAMT),CONVERT(VARCHAR,SAMT),CONVERT(VARCHAR,NET_PAYIN_PAYOUT) FROM MSAJAG.DBO.CASH_OBL" QUERYOUT ' +@CASHFILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
EXEC(@CASH)

DECLARE @FNOFILENAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'FNO_EXCHANGE_OBL_' + CONVERT(VARCHAR, GETDATE(), 112) + '.CSV'
DECLARE @FNO VARCHAR(MAX)                            
SET @FNO = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''EXCHANGE'''',''''SAUDA_DATE'''',''''PREMIUM_ACCOUNT'''',''''CLEARING_HOUSE'''',''''OPTION_EX_ALLOCATION'''',''''NET_PAYIN_PAYOUT''''' 
SET @FNO = @FNO + ' UNION ALL SELECT EXCHANGE,SAUDA_DATE,CONVERT(VARCHAR,PREMIUM_ACCOUNT),CONVERT(VARCHAR,CLEARING_HOUSE),CONVERT(VARCHAR,OPTION_EX_ALLOCATION),CONVERT(VARCHAR,NET_PAYIN_PAYOUT) FROM MSAJAG.DBO.FNO_OBL" QUERYOUT ' +@FNOFILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
EXEC(@FNO)

DECLARE @bodycontent VARCHAR(max),@SUB varchar(4000),@filenames varchar(max)

SET @SUB = 'Exchange Obligation Alert - '+ CONVERT(VARCHAR(11),GETDATE(),105)

SET @filenames = @CASHFILENAME + ';' + @FNOFILENAME

SELECT @bodycontent = '
<div style="margin: 0px; padding: 0px; border: 0px; font-variant-numeric: inherit; font-variant-east-asian: inherit; font-stretch: inherit; font-size: 15px; line-height: inherit; font-family: ''''Segoe UI'''', ''''Segoe UI Web (West European)'''', ''''Segoe UI'''', -apple-system, BlinkMacSystemFont, Roboto, ''''Helvetica Neue'''', sans-serif; vertical-align: baseline; color: #201f1e; background-color: #ffffff;" align="center">
<table class="x_MsoNormalTable" style="font: inherit; width: 525pt;" border="0" width="700" cellspacing="0" cellpadding="0">
<tbody>
<tr style="height: 13px;">
<td style="border-top: 1pt solid #d9d9d9; border-right: 1pt solid #d9d9d9; border-left: 1pt solid #d9d9d9; border-image: initial; border-bottom: none; padding: 0cm; height: 13px;" colspan="3">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: left;">&nbsp;</p>
</td>
</tr>
<tr style="height: 46px;">
<td style="width: 19.5881px; border-top: none; border-right: none; border-bottom: none; border-image: initial; border-left: 1pt solid #d9d9d9; padding: 0cm; height: 46px;" width="3%">
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: center;" align="center"><span style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: 5pt; line-height: inherit; font-family: inherit; vertical-align: baseline; color: inherit;">&nbsp;</span></p>
</td>
<td style="padding: 0cm; height: 46px;" valign="top">
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: left;" align="right"><a style="margin: 0px; padding: 0px; border: 0px; font: inherit; vertical-align: baseline; color: #954f72;" href="https://clicktime.symantec.com/3TkWXrQ7qsRiaiCxNu8RpLr7Vc?u=http%3A%2F%2Flnk.etransmail.com%2Flt.pl%3Fid%3D80375%3Dd04FAAtSAgINGQcCAAEIAlZVUho%3DCg1GWw0ZUFYRVQZ0VlNfUVkEWFtLAEVEHlhWTldQW1BSUQAAUwEHBFUAVQUCTl1ERxILGhcJWVkeVExABwsRCwUNXhwAWFoYCkVNRFgNXFRPFAM%3D%26fl%3DXEZBQEBYHhpbCV5RW0VRXwNLER8JBVxGBlQZVAlcTAdsdUdoAFUFDQkPU3wHdV5fVz8XICoyBWQA%26ext%3DdT1odHRwJTNBJTJGJTJGbG5rLmV0cmFuc21haWwuY29tJTJGbHQucGwlM0ZpZCUzRDgwMzc1JTNEZDA0RkFBdFNBZ0lOR1FjQ0FBRUlBbFpWVWhvJTNEQ2cxR1d3MFpVRllSVlFaMFZsTmZVVmtFV0Z0TEFFVkVIbGhXVGxkUVcxWlRVd1VDVXdBRkJGTUlVUUlNVGwxRVJ4SUxHaGNKV1ZrZVZFeEFCd3NSQ3dVTlhod0FXRm9ZQ2tWTlJGZ05YRlJQRkFNJTNEJTI2ZmwlM0RYRVpCUUVCWUhocFBFa0FjVWxCU1V3d0RDd2dYQVVCRVRWNVpHQSUzRCUzRA%3D%3D" target="_blank" rel="noopener noreferrer" data-auth="NotApplicable"><span style="margin: 0px; padding: 0px; border: 0px; font: inherit; vertical-align: baseline; color: windowtext; text-decoration-line: none;"><img class="CToWUd" src="https://ci3.googleusercontent.com/proxy/kKqX9I0H-jZvddIz0zPzSdOEv4i1V2jl2d9hezHRonUljqxBc1j1G7aj0CNUZxI-AQ0dbp7GEFqLXLZwSdxHAH94Su43az2ggekp0yL_8GJtw1ua7qplujHYyy5x-hS-OjNwkMi4sASgAHV39jTPja2YPFychezokSdZ7olU0m_5=s0-d-e1-ft#https://s3-ap-southeast-1.amazonaws.com/darwinbox-data/190/logo/5e3b2f36410ed__tenant-avatar-190_551251904.png" alt="Logo" height="45" data-imagetype="AttachmentByCid" /></span></a></p>
</td>
<td style="width: 19.5881px; border-top: none; border-bottom: none; border-left: none; border-image: initial; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 46px;" width="3%">
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: center;" align="center">&nbsp;</p>
</td>
</tr>
<tr style="height: 30px;">
<td style="border-top: none; border-left: 1pt solid #d9d9d9; border-bottom: none; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 30px;" colspan="3">
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: 9pt; line-height: inherit; font-family: inherit; vertical-align: baseline; color: inherit;">&shy;</span></p>
</td>
</tr>
<tr style="height: 34px;">
<td style="border-top: none; border-right: none; border-bottom: none; border-image: initial; border-left: 1pt solid #d9d9d9; padding: 0cm; height: 34px;">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
<td style="padding: 0cm; height: 34px;">
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; line-height: 18pt;"><strong><span style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: 16pt; line-height: inherit; font-family: Arial, sans-serif, serif, EmojiFont; vertical-align: baseline; color: #2574bb;">Exchange Obligation Report</span></strong></p>
</td>
<td style="border-top: none; border-bottom: none; border-left: none; border-image: initial; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 34px;">&nbsp;</td>
</tr>
<tr style="height: 4px;">
<td style="border-top: none; border-left: 1pt solid #d9d9d9; border-bottom: none; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 4px;" colspan="3">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
</tr>
<tr style="height: 20px;">
<td style="border-top: none; border-right: none; border-bottom: none; border-image: initial; border-left: 1pt solid #d9d9d9; padding: 0cm; height: 20px;">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
<td style="padding: 0cm; height: 20px;">&nbsp;</td>
<td style="border-top: none; border-bottom: none; border-left: none; border-image: initial; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 20px;">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
</tr>
<tr style="height: 13px;">
<td style="border-top: none; border-left: 1pt solid #d9d9d9; border-bottom: none; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 13px;" colspan="3">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
</tr>
<tr style="height: 237.328px;">
<td style="border-top: none; border-right: none; border-bottom: none; border-image: initial; border-left: 1pt solid #d9d9d9; padding: 0cm; height: 237.328px;">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
<td style="padding: 0cm; height: 237.328px;" valign="top">
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="color: #201f1e; font-family: Calibri, sans-serif; font-size: 14.6667px; background-color: #ffffff;">Hi <strong>Team,</strong></span></p>
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="color: #201f1e; font-family: Calibri, sans-serif; font-size: 14.6667px; background-color: #ffffff;">Please find the attached file as per requirement.</span></p>
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;&nbsp;</p>
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
<div style="margin: 0px; padding: 0px; border: 0px; font-variant-numeric: inherit; font-variant-east-asian: inherit; font-stretch: inherit; font-size: 15px; line-height: inherit; font-family: Calibri, Arial, Helvetica, sans-serif, serif, EmojiFont; vertical-align: baseline; color: #201f1e; background-color: white;">
<p>Regards,</p>
<p>Team Angel One</p>
</div>
</td>
<td style="border-top: none; border-bottom: none; border-left: none; border-image: initial; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 237.328px;">&nbsp;</td>
</tr>
<tr style="height: 18px;">
<td style="border-top: none; border-left: 1pt solid #d9d9d9; border-bottom: 1pt solid #d9d9d9; border-right: none; background: #e6e6e6; padding: 0cm; height: 18px;">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>
</td>
<td style="border-top: none; border-right: none; border-left: none; border-image: initial; border-bottom: 1pt solid #d9d9d9; background: #e6e6e6; padding: 0cm; height: 18px;">&nbsp;</td>
<td style="border-top: none; border-left: none; border-bottom: 1pt solid #d9d9d9; border-right: 1pt solid #d9d9d9; background: #e6e6e6; padding: 0cm; height: 18px;">
<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="margin: 0px; padding: 0px; border: 0px; font: inherit; vertical-align: baseline; color: black;">&nbsp;</span></p>
</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
</div>
<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; color: #2574bb; background: white;"><span lang="EN-US" style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: 12pt; line-height: inherit; font-family: inherit; vertical-align: baseline;">&nbsp;</span></p>
'


EXEC MSDB.DBO.SP_SEND_DBMAIL 
@PROFILE_NAME='BO SUPPORT', 
--@RECIPIENTS='dileswar.jena@angelbroking.com',
--@copy_recipients='narayan.patankar@angelbroking.com',
@blind_copy_recipients='avinash.ghodake@angelbroking.com',
@SUBJECT=@SUB,
@BODY=@BODYCONTENT,
@FILE_ATTACHMENTS = @FILENAMES,
@IMPORTANCE = 'HIGH',
@BODY_FORMAT ='HTML'

GO
