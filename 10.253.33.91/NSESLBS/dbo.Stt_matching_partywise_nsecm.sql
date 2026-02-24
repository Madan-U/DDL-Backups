-- Object: PROCEDURE dbo.Stt_matching_partywise_nsecm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  Proc  
 Stt_matching_partywise_nsecm  
 (  
 @fromdate Varchar(11),  
 @todate Varchar(11),  
 @clitype Varchar(2),  
 @fromcode Varchar(10),  
 @tocode Varchar(10),  
 @partycodetype Varchar(5),  
 @show Varchar(1)  
 )  
  
As  
  
Declare  
 @selectclause Varchar(8000),  
 @fromclause Varchar(1000),  
 @whereclause Varchar(8000),  
 @groupby Varchar(1000),  
 @having Varchar(1000),  
 @orderby Varchar(1000),  
 @partycodefieldname Varchar(10)  
  
If @partycodetype = 'bo' Set @partycodefieldname = 'party_code'  
If @partycodetype = 'ex' Set @partycodefieldname = 'branch_id'  
/*  
If Len(ltrim(rtrim(@fromdate))) = 0 Select @fromdate = Left(convert(varchar, Min(sauda_date), 109), 11) From Stt_clientdetail  
If Len(ltrim(rtrim(@todate))) = 0 Select @todate = Left(convert(varchar, Max(sauda_date), 109), 11) From Stt_clientdetail  
  
If @partycodetype = 'bo'  
Begin  
 If Len(ltrim(rtrim(@fromcode))) = 0 Select @fromcode = Min(ltrim(rtrim(party_code))) From Stt_clientdetail  
 If Len(ltrim(rtrim(@tocode))) = 0 Select @tocode = Max(ltrim(rtrim(party_code))) From Stt_clientdetail  
End  
  
If @partycodetype = 'ex'  
Begin  
 If Len(ltrim(rtrim(@fromcode))) = 0 Select @fromcode = Min(ltrim(rtrim(branch_id))) From Stt_clientdetail  
 If Len(ltrim(rtrim(@tocode))) = 0 Select @tocode = Max(ltrim(rtrim(branch_id))) From Stt_clientdetail  
End  
*/  
  
If Len(ltrim(rtrim(@fromcode))) = 0 Set @fromcode = '0000000000'  
If Len(ltrim(rtrim(@tocode))) = 0 Set @tocode = 'zzzzzzzzzz'  
  
Print '@fromdate: ' + @fromdate  
Print '@todate: ' + @todate  
Print '@fromcode: ' + @fromcode  
Print '@tocode: ' + @tocode  
  
Set @selectclause = ''  
Set @fromclause = ''  
Set @whereclause = ''  
Set @groupby = ''  
Set @having = ''  
Set @orderby = ''  
  
Set @selectclause = @selectclause + ' Select'  
Set @selectclause = @selectclause + ' C.' + @partycodefieldname + ' As Party_code,'  
Set @selectclause = @selectclause + ' '''' As Scrip_cd,'  
Set @selectclause = @selectclause + ' IsNull(Sum(c.psttdel),0) As P_del_stt_tot_bo /*purchase-delivery-stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' IsNull(E.tpsttdel,0) As P_del_stt_tot_ex /*purchase-delivery-stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' IsNull(Sum(c.psttdel),0)-IsNull(e.tpsttdel,0) As P_del_stt_tot_diff /*diff Of The Above 2*/,'  
  
Set @selectclause = @selectclause + ' IsNull(Sum(c.ssttdel),0) As S_del_stt_tot_bo /*sell-delivery-stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' IsNull(E.tssttdel,0) As S_del_stt_tot_ex /*sell-delivery-stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' IsNull(Sum(c.ssttdel),0)-IsNull(e.tssttdel,0) As S_del_stt_tot_diff /*diff Of The Above 2*/,'  
  
Set @selectclause = @selectclause + ' IsNull(Sum(c.sstttrd),0) As S_trd_tot_bo /*sell-trading-stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' IsNull(E.tsstttrd,0) As S_trd_tot_ex /*sell-trading-stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' IsNull(Sum(c.sstttrd),0)-IsNull(e.tsstttrd,0) As S_trd_stt_tot_diff /*diff Of The Above 2*/,'  
  
Set @selectclause = @selectclause + ' Sum(c.totalstt) As Stt_tot_bo /*stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' E.totalstt As Stt_tot_ex /*stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' Sum(c.totalstt)-e.totalstt As Tot_diff /*diff Of The Above 2*/,'  
Set @selectclause = @selectclause + ' '''' As Rectype'  
  
Set @fromclause = @fromclause + ' From'  
Set @fromclause = @fromclause + ' Stt_clientdetail C, Stt_exchg_view_party_nsecm E'  
  
Set @whereclause = @whereclause + ' Where'  
Set @whereclause = @whereclause + ' C.branch_id = E.party_code /*for Exch Party Code*/ And'  
Set @whereclause = @whereclause + ' C.sauda_date = E.stt_date And'  
Set @whereclause = @whereclause + ' C.sett_type = E.sett_type And'  
Set @whereclause = @whereclause + ' C.rectype = E.rectype And'  
Set @whereclause = @whereclause + ' C.rectype = 20 And'  --get Party Summary Recs Only.  
Set @whereclause = @whereclause + ' E.rectype = 20 And'  --get Party Summary Recs Only.  
Set @whereclause = @whereclause + ' C.sauda_date >= ''' + @fromdate + ' 00:00:00' + ''' And'  
Set @whereclause = @whereclause + ' C.sauda_date <= ''' + @todate + ' 23:59:59' + ''' And'  
Set @whereclause = @whereclause + ' C.' + @partycodefieldname + ' >= ''' + @fromcode + ''' And'  
Set @whereclause = @whereclause + ' C.' + @partycodefieldname + ' <= ''' + @tocode + ''''  
  
Set @groupby = @groupby + ' Group By'  
Set @groupby = @groupby + ' C.' + @partycodefieldname + ', E.tpsttdel, E.tssttdel, E.tsstttrd, E.totalstt'  
  
If @show = 'm' Set @having = @having + ' Having (sum(c.totalstt)-e.totalstt) <> 0'  
  
Set @orderby = @orderby + ' Order By'  
Set @orderby = @orderby + ' 1'  
  
Print @selectclause  
Print @fromclause  
Print @whereclause  
Print @groupby  
Print @orderby  
  
Exec(@selectclause + @fromclause + @whereclause + @groupby + @having + @orderby)

GO
