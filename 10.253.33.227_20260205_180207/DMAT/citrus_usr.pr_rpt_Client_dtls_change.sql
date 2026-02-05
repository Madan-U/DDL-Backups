-- Object: PROCEDURE citrus_usr.pr_rpt_Client_dtls_change
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_rpt_Client_dtls_change '','','apr 29 2010','apr 29 2010',''

CREATE procedure [citrus_usr].[pr_rpt_Client_dtls_change]
(
	--@PA_DPTYPE VARCHAR(4),
	@pa_fracc varchar(50),
	@pa_toacc varchar(50),
	@pa_frdt datetime,
	@pa_todt datetime,
	@pa_out varchar(8000) output
 )

as
if @pa_fracc = ''
	set @pa_fracc = '0'
if @pa_toacc = ''
	set @pa_toacc = '9999999999999999'
begin
--
	select ccd_clisba_id,ccd_cli_name,isnull(ccd_cli_addr,'-') ccd_cli_addr,isnull(ccd_cli_phno,'-') ccd_cli_phno,isnull(ccd_cli_mobile,'-') ccd_cli_mobile,
			isnull(ccd_cli_email,'-') ccd_cli_email,isnull(ccd_cli_bnkacno,'-') ccd_cli_bnkacno,isnull(ccd_cli_bnkmicr,'-') ccd_cli_bnkmicr,isnull(ccd_cli_bnkactyp,'-') ccd_cli_bnkactyp,
			isnull(ccd_cli_bnkname,'-') ccd_cli_bnkname,CONVERT(VARCHAR,ccd_cli_chngdate,103) ccd_cli_chngdate
	from Changed_Client_Dtls	
	where ccd_cli_chngdate between CONVERT(DATETIME,@pa_frdt,103) + ' 00:00:00' and CONVERT(DATETIME,@pa_todt,103) + ' 23:59:59'
	AND ccd_clisba_id between @pa_fracc and @pa_toacc

--
end


--select * from Changed_Client_Dtls

GO
