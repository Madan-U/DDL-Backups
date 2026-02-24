-- Object: PROCEDURE dbo.CLOSE_CLIENT_LEDGER_EMAIL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[CLOSE_CLIENT_LEDGER_EMAIL] (@RUNDATE VARCHAR(11))



AS



DECLARE @bodycontent VARCHAR(max),@SUB varchar(500)

 

SET @SUB = 'Closed Client Ledger Alert : '+ CONVERT(VARCHAR(11),GETDATE(),105)



DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'CLOSED_LEDGER_DATA_'+ REPLACE(CONVERT(VARCHAR(10), GETDATE(), 104), '.', '') + '.CSV'

DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [ACCOUNT].[DBO].[RPT_CLOSE_CLIENT_LEDGER]  ''' + @RUNDATE + ''''

DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'



EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT



SELECT @bodycontent = '<div style="margin: 0px; padding: 0px; border: 0px; font-variant-numeric: inherit; font-variant-east-asian: inherit; font-stretch: inherit; font-size: 15px; line-height: inherit; font-family: ''''Segoe UI'''', ''''Segoe UI Web (West
 European)'''', ''''Segoe UI'''', -apple-system, BlinkMacSystemFont, Roboto, ''''Helvetica Neue'''', sans-serif; vertical-align: baseline; color: #201f1e; background-color: #ffffff;" align="center">

<table class="x_MsoNormalTable" style="font: inherit; width: 525pt;" border="0" width="700" cellspacing="0" cellpadding="0">

<tbody>

<tr style="height: 13px;">

<td style="border-top: 1pt solid #d9d9d9; border-right: 1pt solid #d9d9d9; border-left: 1pt solid #d9d9d9; border-image: initial; border-bottom: none; padding: 0cm; height: 13px;" colspan="3">

<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: left;">&nbsp;</p>

</td>

</tr>

<tr style="height: 46px;">

<td style="width: 19.5881px; border-top: none; border-right: none; border-bottom: none; border-image: initial; border-left: 1pt solid #d9d9d9; padding: 0cm; height: 46px;" width="3%">

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: center;" align="center"><span style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit
; font-weight: inherit; font-stretch: inherit; font-size: 5pt; line-height: inherit; font-family: inherit; vertical-align: baseline; color: inherit;">&nbsp;</span></p>

</td>

<td style="padding: 0cm; height: 46px;" valign="top">

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: left;" align="right"><a style="margin: 0px; padding: 0px; border: 0px; font: inherit; vertical-align: baseline; color: #954f72;" href="
https://clicktime.symantec.com/3TkWXrQ7qsRiaiCxNu8RpLr7Vc?u=http%3A%2F%2Flnk.etransmail.com%2Flt.pl%3Fid%3D80375%3Dd04FAAtSAgINGQcCAAEIAlZVUho%3DCg1GWw0ZUFYRVQZ0VlNfUVkEWFtLAEVEHlhWTldQW1BSUQAAUwEHBFUAVQUCTl1ERxILGhcJWVkeVExABwsRCwUNXhwAWFoYCkVNRFgNXFRPFA
M%3D%26fl%3DXEZBQEBYHhpbCV5RW0VRXwNLER8JBVxGBlQZVAlcTAdsdUdoAFUFDQkPU3wHdV5fVz8XICoyBWQA%26ext%3DdT1odHRwJTNBJTJGJTJGbG5rLmV0cmFuc21haWwuY29tJTJGbHQucGwlM0ZpZCUzRDgwMzc1JTNEZDA0RkFBdFNBZ0lOR1FjQ0FBRUlBbFpWVWhvJTNEQ2cxR1d3MFpVRllSVlFaMFZsTmZVVmtFV0Z0TEFFVk
VIbGhXVGxkUVcxWlRVd1VDVXdBRkJGTUlVUUlNVGwxRVJ4SUxHaGNKV1ZrZVZFeEFCd3NSQ3dVTlhod0FXRm9ZQ2tWTlJGZ05YRlJQRkFNJTNEJTI2ZmwlM0RYRVpCUUVCWUhocFBFa0FjVWxCU1V3d0RDd2dYQVVCRVRWNVpHQSUzRCUzRA%3D%3D" target="_blank" rel="noopener noreferrer" data-auth="NotApplicable"
><span style="margin: 0px; padding: 0px; border: 0px; font: inherit; vertical-align: baseline; color: windowtext; text-decoration-line: none;"><img class="CToWUd" src="https://ci3.googleusercontent.com/proxy/kKqX9I0H-jZvddIz0zPzSdOEv4i1V2jl2d9hezHRonUljqx
Bc1j1G7aj0CNUZxI-AQ0dbp7GEFqLXLZwSdxHAH94Su43az2ggekp0yL_8GJtw1ua7qplujHYyy5x-hS-OjNwkMi4sASgAHV39jTPja2YPFychezokSdZ7olU0m_5=s0-d-e1-ft#https://s3-ap-southeast-1.amazonaws.com/darwinbox-data/190/logo/5e3b2f36410ed__tenant-avatar-190_551251904.png" alt="L
ogo" height="45" data-imagetype="AttachmentByCid" /></span></a></p>

</td>

<td style="width: 19.5881px; border-top: none; border-bottom: none; border-left: none; border-image: initial; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 46px;" width="3%">

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; text-align: center;" align="center">&nbsp;</p>

</td>

</tr>

<tr style="height: 30px;">

<td style="border-top: none; border-left: 1pt solid #d9d9d9; border-bottom: none; border-right: 1pt solid #d9d9d9; padding: 0cm; height: 30px;" colspan="3">

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretc
h: inherit; font-size: 9pt; line-height: inherit; font-family: inherit; vertical-align: baseline; color: inherit;">&shy;</span></p>

</td>

</tr>

<tr style="height: 34px;">

<td style="border-top: none; border-right: none; border-bottom: none; border-image: initial; border-left: 1pt solid #d9d9d9; padding: 0cm; height: 34px;">

<p class="x_MsoNormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>

</td>

<td style="padding: 0cm; height: 34px;">

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; line-height: 18pt;"><strong><span style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-variant: inherit; font-w
eight: inherit; font-stretch: inherit; font-size: 16pt; line-height: inherit; font-family: Arial, sans-serif, serif, EmojiFont; vertical-align: baseline; color: #2574bb;">Closed Client Ledger Alert</span></strong></p>

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

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="color: #201f1e; font-family: Calibri, sans-serif; font-size: 14.6667px; background-color: #ffffff;">Hi <strong>Team,</strong></span><
/p>

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;"><span style="color: #201f1e; font-family: Calibri, sans-serif; font-size: 14.6667px; background-color: #ffffff;">Please find the attached file as 
per requirement.</span></p>

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;&nbsp;</p>

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif;">&nbsp;</p>

<div style="margin: 0px; padding: 0px; border: 0px; font-variant-numeric: inherit; font-variant-east-asian: inherit; font-stretch: inherit; font-size: 15px; line-height: inherit; font-family: Calibri, Arial, Helvetica, sans-serif, serif, EmojiFont; vertic
al-align: baseline; color: #201f1e; background-color: white;">

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

<p class="x_xmsonormal" style="margin: 0cm 0cm 0.0001pt; font-size: 11pt; font-family: Calibri, sans-serif; color: #2574bb; background: white;"><span lang="EN-US" style="margin: 0px; padding: 0cm; border: 1pt none windowtext; font-style: inherit; font-var
iant: inherit; font-weight: inherit; font-stretch: inherit; font-size: 12pt; line-height: inherit; font-family: inherit; vertical-align: baseline;">&nbsp;</span></p>'





EXEC MSDB.DBO.SP_SEND_DBMAIL 

@PROFILE_NAME='BO SUPPORT', 

@RECIPIENTS='deepak.redekar@angelbroking.com;jvbanking@angelbroking.com;subodh.salvi@angelbroking.com;vasant.gaikwad@angelbroking.com;bipin.shetty@angelbroking.com;roohi.nisar@angelbroking.com',

@copy_recipients='Ankit.Kansal@angelbroking.com;narayan.patankar@angelbroking.com;suresh.raut@angelbroking.com;Dileswar.Jena@angelbroking.com',

@blind_copy_recipients='ganesh.jagdale@angelbroking.com',

@SUBJECT=@SUB,

@BODY=@BODYCONTENT,

@FILE_ATTACHMENTS = @ADNAME,

@IMPORTANCE = 'HIGH',

@BODY_FORMAT ='HTML'

GO
