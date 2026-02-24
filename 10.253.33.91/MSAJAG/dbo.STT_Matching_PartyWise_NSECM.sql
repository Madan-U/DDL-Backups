-- Object: PROCEDURE dbo.STT_Matching_PartyWise_NSECM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE PROC
 STT_Matching_PartyWise_NSECM
 (
 @FromDate VarChar(11),
 @ToDate VarChar(11),
 @CliType VarChar(2),
 @FromCode VarChar(10),
 @ToCode VarChar(10),
 @PartyCodeType VarChar(5),
 @Show VarChar(1)
 )

AS

Declare
 @SelectClause VarChar(8000),
 @FromClause VarChar(1000),
 @WhereClause VarChar(8000),
 @GroupBy VarChar(1000),
 @Having VarChar(1000),
 @OrderBy VarChar(1000),
 @PartyCodeFieldName VarChar(10)

If @PartyCodeType = 'BO' Set @PartyCodeFieldName = 'party_code'
If @PartyCodeType = 'EX' Set @PartyCodeFieldName = 'branch_id'
/*
If len(ltrim(rtrim(@FromDate))) = 0 select @FromDate = left(convert(varchar, min(sauda_date), 109), 11) from stt_clientdetail
If len(ltrim(rtrim(@ToDate))) = 0 select @ToDate = left(convert(varchar, max(sauda_date), 109), 11) from stt_clientdetail

If @PartyCodeType = 'BO'
Begin
	If len(ltrim(rtrim(@FromCode))) = 0 select @FromCode = min(ltrim(rtrim(party_code))) from stt_clientdetail
	If len(ltrim(rtrim(@ToCode))) = 0 select @ToCode = max(ltrim(rtrim(party_code))) from stt_clientdetail
End

If @PartyCodeType = 'EX'
Begin
	If len(ltrim(rtrim(@FromCode))) = 0 select @FromCode = min(ltrim(rtrim(branch_id))) from stt_clientdetail
	If len(ltrim(rtrim(@ToCode))) = 0 select @ToCode = max(ltrim(rtrim(branch_id))) from stt_clientdetail
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
Set @SelectClause = @SelectClause + ' c.' + @PartyCodeFieldName + ' as party_code,'
Set @SelectClause = @SelectClause + ' '''' as scrip_cd,'
Set @SelectClause = @SelectClause + ' sum(c.psttdel) as P_DEL_STT_TOT_BO /*purchase-delivery-stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' e.tpsttdel as P_DEL_STT_TOT_EX /*purchase-delivery-stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' sum(c.psttdel)-e.tpsttdel as P_DEL_STT_TOT_DIFF /*diff of the above 2*/,'

Set @SelectClause = @SelectClause + ' sum(c.ssttdel) as S_DEL_STT_TOT_BO /*sell-delivery-stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' e.tssttdel as S_DEL_STT_TOT_EX /*sell-delivery-stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' sum(c.ssttdel)-e.tssttdel as S_DEL_STT_TOT_DIFF /*diff of the above 2*/,'

Set @SelectClause = @SelectClause + ' sum(c.sstttrd) as S_TRD_TOT_BO /*sell-trading-stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' e.tsstttrd as S_TRD_TOT_EX /*sell-trading-stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' sum(c.sstttrd)-e.tsstttrd as S_TRD_STT_TOT_DIFF /*diff of the above 2*/,'

Set @SelectClause = @SelectClause + ' sum(c.totalstt) as STT_TOT_BO /*stt-total-backoffice*/,'
Set @SelectClause = @SelectClause + ' e.totalstt as STT_TOT_EX /*stt-total-exchange*/,'
Set @SelectClause = @SelectClause + ' sum(c.totalstt)-e.totalstt as TOT_DIFF /*diff of the above 2*/,'
Set @SelectClause = @SelectClause + ' '''' as rectype'

Set @FromClause = @FromClause + ' from'
Set @FromClause = @FromClause + ' stt_clientdetail c, stt_exchg_view_party_nsecm e'

Set @WhereClause = @WhereClause + ' where'
Set @WhereClause = @WhereClause + ' c.' + @PartyCodeFieldName + ' = e.party_code /*for exch party code*/ and'
Set @WhereClause = @WhereClause + ' c.sauda_date = e.stt_date and'
Set @WhereClause = @WhereClause + ' c.sett_type = e.sett_type and'
Set @WhereClause = @WhereClause + ' c.rectype = e.rectype and'
Set @WhereClause = @WhereClause + ' c.rectype = 20 and'		--GET PARTY SUMMARY RECs ONLY.
Set @WhereClause = @WhereClause + ' e.rectype = 20 and'		--GET PARTY SUMMARY RECs ONLY.
Set @WhereClause = @WhereClause + ' c.sauda_date >= ''' + @FromDate + ' 00:00:00' + ''' and'
Set @WhereClause = @WhereClause + ' c.sauda_date <= ''' + @ToDate + ' 23:59:59' + ''' and'
Set @WhereClause = @WhereClause + ' c.' + @PartyCodeFieldName + ' >= ''' + @FromCode + ''' and'
Set @WhereClause = @WhereClause + ' c.' + @PartyCodeFieldName + ' <= ''' + @ToCode + ''''

Set @GroupBy = @GroupBy + ' group by'
Set @GroupBy = @GroupBy + ' c.' + @PartyCodeFieldName + ', e.tpsttdel, e.tssttdel, e.tsstttrd, e.totalstt'

If @Show = 'M' Set @Having = @Having + ' having (sum(c.totalstt)-e.totalstt) <> 0'

Set @OrderBy = @OrderBy + ' order by'
Set @OrderBy = @OrderBy + ' 1'

Print @SelectClause
Print @FromClause
Print @WhereClause
Print @GroupBy
Print @OrderBy

Exec(@SelectClause + @FromClause + @WhereClause + @GroupBy + @Having + @OrderBy)

GO
