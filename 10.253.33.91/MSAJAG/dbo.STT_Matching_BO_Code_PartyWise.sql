-- Object: PROCEDURE dbo.STT_Matching_BO_Code_PartyWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC
	STT_Matching_BO_Code_PartyWise
	(
		@FromDate VarChar(11),
		@ToDate VarChar(11),
		@CliType VarChar(2),
		@PartyCodeType VarChar(5),
		@FromCode VarChar(10),
		@ToCode VarChar(10),
		@Group VarChar(5),
		@Show VarChar(1)
	)

AS

If len(ltrim(rtrim(@FromDate))) = 0 select @FromDate = left(convert(varchar, min(sauda_date), 109), 11) from stt_clientdetail
If len(ltrim(rtrim(@ToDate))) = 0 select @ToDate = left(convert(varchar, max(sauda_date), 109), 11) from stt_clientdetail
If len(ltrim(rtrim(@FromCode))) = 0 select @FromCode = min(party_code) from stt_clientdetail
If len(ltrim(rtrim(@ToCode))) = 0 select @ToCode = max(party_code) from stt_clientdetail

Print '@FromDate: ' + @FromDate
Print '@ToDate: ' + @ToDate
Print '@FromCode: ' + @FromCode
Print '@ToCode: ' + @ToCode

select
	isnull(c.party_code, 'zzzzzzzzzz') as party_code,
	'' as scrip_cd,
	sum(c.psttdel) as P_DEL_STT_TOT_BO,		/*purchase-delivery-stt-total-backoffice*/
	e.tpsttdel as P_DEL_STT_TOT_EX,		/*purchase-delivery-stt-total-exchange*/
	sum(c.psttdel-e.tpsttdel) as P_DEL_STT_TOT_DIFF,		/*diff of the above 2*/

	sum(c.ssttdel) as S_DEL_STT_TOT_BO,		/*sell-delivery-stt-total-backoffice*/
	e.tssttdel as S_DEL_STT_TOT_EX,		/*sell-delivery-stt-total-exchange*/
	sum(c.ssttdel)-e.tssttdel as S_DEL_STT_TOT_DIFF,		/*diff of the above 2*/

	sum(c.sstttrd) as S_TRD_TOT_BO,		/*sell-trading-stt-total-backoffice*/
	e.tsstttrd as S_TRD_TOT_EX,		/*sell-trading-stt-total-exchange*/
	sum(c.sstttrd)-e.tsstttrd as S_TRD_STT_TOT_DIFF,		/*diff of the above 2*/

	sum(c.totalstt) as STT_TOT_BO,		/*stt-total-backoffice*/
	e.totalstt as STT_TOT_EX,		/*stt-total-exchange*/
	sum(c.totalstt)-e.totalstt as TOT_DIFF,		/*diff of the above 2*/
	'' as rectype
from
	stt_clientdetail c, stt_exchg_view_party e
where
	c.party_code = e.party_code and	/*for exch party code*/
	c.sauda_date = e.stt_date and
	c.sett_type = e.sett_type and
	c.rectype = 20 and
	e.rectype = 20 and

	c.sauda_date >= @FromDate + ' 00:00:00' and
	c.sauda_date <= @ToDate + ' 23:59:59' and
	c.party_code >= @FromCode and
	c.party_code <= @ToCode
group by
	c.party_code, e.tpsttdel, e.tssttdel, e.tsstttrd, e.totalstt
order by
	1

GO
