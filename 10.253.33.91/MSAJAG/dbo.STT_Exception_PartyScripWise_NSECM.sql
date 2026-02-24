-- Object: PROCEDURE dbo.STT_Exception_PartyScripWise_NSECM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC
 STT_Exception_PartyScripWise_NSECM
 (
 @FromDate VarChar(11),
 @ToDate VarChar(11),
 @CliType VarChar(2),
 @FromCode VarChar(10),
 @ToCode VarChar(10),
 @ExceptionType VarChar(2)
 )

AS

Declare
	@SelectClause VarChar(8000),
	@FromClause VarChar(1000),
	@WhereClause VarChar(8000),
	@GroupBy VarChar(1000),
	@Having VarChar(1000),
	@OrderBy VarChar(1000)

--@ExceptionType - BO => IN BO But Not In EX
--@ExceptionType - EX => IN EX But Not In BO
/*
If @ExceptionType = 'BO'	--GET min AND max FROM stt_clientdetail, SINCE LISTING BASE IS FROM BO DATA
Begin
	If len(ltrim(rtrim(@FromDate))) = 0 select @FromDate = left(convert(varchar, min(sauda_date), 109), 11) from stt_clientdetail
	If len(ltrim(rtrim(@ToDate))) = 0 select @ToDate = left(convert(varchar, max(sauda_date), 109), 11) from stt_clientdetail

	If len(ltrim(rtrim(@FromCode))) = 0 select @FromCode = min(ltrim(rtrim(branch_id))) from stt_clientdetail
	If len(ltrim(rtrim(@ToCode))) = 0 select @ToCode = max(ltrim(rtrim(branch_id))) from stt_clientdetail
End

If @ExceptionType = 'EX'	--GET min AND max FROM stt_exchg SINCE LISTING BASE IS FROM EX DATA
Begin
	If len(ltrim(rtrim(@FromDate))) = 0 select @FromDate = left(convert(varchar, min(stt_date), 109), 11) from stt_exchg
	If len(ltrim(rtrim(@ToDate))) = 0 select @ToDate = left(convert(varchar, max(stt_date), 109), 11) from stt_exchg

	If len(ltrim(rtrim(@FromCode))) = 0 select @FromCode = min(ltrim(rtrim(party_code))) from stt_exchg
	If len(ltrim(rtrim(@ToCode))) = 0 select @ToCode = max(ltrim(rtrim(party_code))) from stt_exchg
End
*/

If len(ltrim(rtrim(@FromCode))) = 0 Set @FromCode = '0000000000'
If len(ltrim(rtrim(@ToCode))) = 0 Set @ToCode = 'zzzzzzzzzz'

Print '@FromDate: ' + @FromDate
Print '@ToDate: ' + @ToDate
Print '@FromCode: ' + @FromCode
Print '@ToCode: ' + @ToCode

Set @SelectClause = ''
Set @FromClause = ''
Set @WhereClause = ''
Set @GroupBy = ''
Set @Having = ''
Set @OrderBy = ''

Set @SelectClause = @SelectClause + ' select'

If @ExceptionType = 'BO' Set @SelectClause = @SelectClause + ' c.branch_id as party_code,'
If @ExceptionType = 'EX' Set @SelectClause = @SelectClause + ' e.party_code as party_code,'

If @ExceptionType = 'BO' Set @SelectClause = @SelectClause + ' c.scrip_cd as scrip_cd,'
If @ExceptionType = 'EX' Set @SelectClause = @SelectClause + ' e.scrip_cd as scrip_cd,'

Set @SelectClause = @SelectClause + ' isnull(sum(c.psttdel), 0) as P_DEL_STT_TOT_BO /*purchase-delivery-stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' isnull(e.tpsttdel, 0) as P_DEL_STT_TOT_EX /*purchase-delivery-stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' isnull(sum(c.psttdel)-e.tpsttdel, 0) as P_DEL_STT_TOT_DIFF /*diff of the above 2*/,'

Set @SelectClause = @SelectClause + ' isnull(sum(c.ssttdel), 0) as S_DEL_STT_TOT_BO /*sell-delivery-stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' isnull(e.tssttdel, 0) as S_DEL_STT_TOT_EX /*sell-delivery-stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' isnull(sum(c.ssttdel)-e.tssttdel, 0) as S_DEL_STT_TOT_DIFF /*diff of the above 2*/,'

Set @SelectClause = @SelectClause + ' isnull(sum(c.sstttrd), 0) as S_TRD_TOT_BO /*sell-trading-stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' isnull(e.tsstttrd, 0) as S_TRD_TOT_EX /*sell-trading-stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' isnull(sum(c.sstttrd)-e.tsstttrd, 0) as S_TRD_STT_TOT_DIFF /*diff of the above 2*/,'

Set @SelectClause = @SelectClause + ' isnull(sum(c.totalstt), 0) as STT_TOT_BO /*stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' isnull(e.totalstt, 0) as STT_TOT_EX /*stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' isnull(sum(c.totalstt)-e.totalstt, 0) as TOT_DIFF /*diff of the above 2*/,'

If @ExceptionType = 'BO' Set @SelectClause = @SelectClause + ' c.rectype as rectype'
If @ExceptionType = 'EX' Set @SelectClause = @SelectClause + ' e.rectype as rectype'

Set @FromClause = @FromClause + ' from'
Set @FromClause = @FromClause + ' stt_clientdetail c full outer join stt_exchg_view_party_scrip_nsecm e'
Set @FromClause = @FromClause + ' on'
Set @FromClause = @FromClause + ' c.branch_id = e.party_code and'
Set @FromClause = @FromClause + ' c.scrip_cd = e.scrip_cd and'
Set @FromClause = @FromClause + ' c.sauda_date = e.stt_date and'
Set @FromClause = @FromClause + ' c.sett_type = e.sett_type and'
Set @FromClause = @FromClause + ' c.rectype = e.rectype'

Set @WhereClause = @WhereClause + ' where'

If @ExceptionType = 'BO'	--CONDITIONS ON stt_clientdetail TABLE
Begin
	Set @WhereClause = @WhereClause + ' c.rectype = 30 and'		--GET PARTY+SCRIP SUMMARY RECs ONLY.
	--NO e.rectype = 30 CONDITION HERE BECAUSE OF THE OUTER JOIN, e.rectype WILL RETURN null IF NO CORRES. REC. IS FOUND
	Set @WhereClause = @WhereClause + ' c.sauda_date >= ''' + @FromDate + ' 00:00:00' + ''' and'
	Set @WhereClause = @WhereClause + ' c.sauda_date <= ''' + @ToDate + ' 23:59:59' + ''' and'
	Set @WhereClause = @WhereClause + ' c.branch_id >= ''' + @FromCode + ''' and'
	Set @WhereClause = @WhereClause + ' c.branch_id <= ''' + @ToCode + ''''

	--LIST ONLY RECS WHOSE PARTY CODES IN stt_exchg_view_party_scrip ARE NULL
	--ie THEY R PRESENT ONLY IN BO
	Set @WhereClause = @WhereClause + ' and e.party_code is null'

	Set @GroupBy = @GroupBy + ' group by'
	Set @GroupBy = @GroupBy + ' c.branch_id, c.scrip_cd, e.tpsttdel, e.tssttdel, e.tsstttrd, e.totalstt, c.rectype'

	Set @OrderBy = @OrderBy + ' order by'
	Set @OrderBy = @OrderBy + ' 1, c.rectype desc'
End

If @ExceptionType = 'EX'	--CONDITIONS ON stt_exchg_view_party_scrip VIEW
Begin
	Set @WhereClause = @WhereClause + ' e.rectype = 30 and'		--GET PARTY+SCRIP SUMMARY RECs ONLY.
	--NO c.rectype = 30 CONDITION HERE BECAUSE OF THE OUTER JOIN, c.rectype WILL RETURN null IF NO CORRES. REC. IS FOUND
	Set @WhereClause = @WhereClause + ' e.stt_date >= ''' + @FromDate + ' 00:00:00' + ''' and'
	Set @WhereClause = @WhereClause + ' e.stt_date <= ''' + @ToDate + ' 23:59:59' + ''' and'
	Set @WhereClause = @WhereClause + ' e.party_code >= ''' + @FromCode + ''' and'
	Set @WhereClause = @WhereClause + ' e.party_code <= ''' + @ToCode + ''''

	--LIST ONLY RECS WHOSE PARTY CODES IN stt_clientdetail ARE NULL
	--ie THEY R PRESENT ONLY IN EX
	Set @WhereClause = @WhereClause + ' and c.party_code is null'

	Set @GroupBy = @GroupBy + ' group by'
	Set @GroupBy = @GroupBy + ' e.party_code, e.scrip_cd, e.tpsttdel, e.tssttdel, e.tsstttrd, e.totalstt, e.rectype'

	Set @OrderBy = @OrderBy + ' order by'
	Set @OrderBy = @OrderBy + ' 1, e.rectype desc'
End

Print @SelectClause
Print @FromClause
Print @WhereClause
Print @GroupBy
Print @OrderBy

Exec(@SelectClause + @FromClause + @WhereClause + @GroupBy + @Having + @OrderBy)

GO
