-- Object: PROCEDURE citrus_usr.send_mail_SKYC_DP_Activation
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[send_mail_SKYC_DP_Activation]  
  
as  
  
DECLARE @ToMail VARCHAR(1000)  
DECLARE @CCMail VARCHAR(1000)  
DECLARE @HTMLBODY VARCHAR(max)  
DECLARE @SUBJ VARCHAR(1000)  
DECLARE @COUNT BIGINT  
DECLARE @CNT BIGINT  
DECLARE @SERVERNAME VARCHAR(50)  
  
select @SERVERNAME = @@SERVERNAME  
  
SELECT @ToMail = 'govindn@motilaloswal.com;nareshgupta@motilaloswal.com'  
SELECT @CCMail = 'binesh@motilaloswal.com;sureshn@motilaloswal.com;sbabar@motilaloswal.com'  
  
SELECT @SUBJ = @SERVERNAME + ' : 192.168.100.30 : Branch Code not mapped in DMAT through KYC on dated' + convert(varchar, GETDATE(), 106)  
  
select a.dpam_sba_no , b.*  
into #temp1  
from dp_acct_mstr a left outer join TMP_CLIENT_DTLS_MSTR_CDSL_KYC b  
on dpam_sba_no = TMPCLI_BOID  
where dpam_sba_no not in (select entr_sba from entity_relationship)  
  
declare @count_int int  
select @count_int = count(1) from #temp1  
  
if @count_int <> 0  
begin  
  
EXEC msdb.dbo.sp_send_dbmail  
  @profile_name = 'DMAT DB Alerts',  
  @recipients=@ToMail,  
  @copy_recipients = @CCMail,  
  @subject = @SUBJ,  
  @body = 'Please find attach file for SKYC_DP_Activation records',  
  @body_format = 'HTML',  
  @file_attachments = 'D:\Reports\SKYC_DP_Activation.csv'   
 drop table #temp1  
end

GO
