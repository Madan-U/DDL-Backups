-- Object: PROCEDURE dbo.Stt_exception_partyscripwise_nsecm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure Dbo.stt_exception_partyscripwise_nsecm    Script Date: 01/15/2005 1:16:16 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.stt_exception_partyscripwise_nsecm    Script Date: 11/18/2004 8:33:46 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.stt_exception_partyscripwise_nsecm    Script Date: 11/18/2004 7:50:58 Pm ******/  
  
  
CREATE   Proc  
 Stt_exception_partyscripwise_nsecm  
 (  
 @fromdate Varchar(11),  
 @todate Varchar(11),  
 @clitype Varchar(2),  
 @fromcode Varchar(10),  
 @tocode Varchar(10),  
 @exceptiontype Varchar(2)  
 )  
  
As  
  
Declare  
 @selectclause Varchar(8000),  
 @fromclause Varchar(1000),  
 @whereclause Varchar(8000),  
 @groupby Varchar(1000),  
 @having Varchar(1000),  
 @orderby Varchar(1000)  
  
--@exceptiontype - Bo => In Bo But Not In Ex  
--@exceptiontype - Ex => In Ex But Not In Bo  
/*  
If @exceptiontype = 'bo' --get Min And Max From Stt_clientdetail, Since Listing Base Is From Bo Data  
Begin  
 If Len(ltrim(rtrim(@fromdate))) = 0 Select @fromdate = Left(convert(varchar, Min(sauda_date), 109), 11) From Stt_clientdetail  
 If Len(ltrim(rtrim(@todate))) = 0 Select @todate = Left(convert(varchar, Max(sauda_date), 109), 11) From Stt_clientdetail  
  
 If Len(ltrim(rtrim(@fromcode))) = 0 Select @fromcode = Min(ltrim(rtrim(branch_id))) From Stt_clientdetail  
 If Len(ltrim(rtrim(@tocode))) = 0 Select @tocode = Max(ltrim(rtrim(branch_id))) From Stt_clientdetail  
End  
  
If @exceptiontype = 'ex' --get Min And Max From Stt_exchg Since Listing Base Is From Ex Data  
Begin  
 If Len(ltrim(rtrim(@fromdate))) = 0 Select @fromdate = Left(convert(varchar, Min(stt_date), 109), 11) From Stt_exchg  
 If Len(ltrim(rtrim(@todate))) = 0 Select @todate = Left(convert(varchar, Max(stt_date), 109), 11) From Stt_exchg  
  
 If Len(ltrim(rtrim(@fromcode))) = 0 Select @fromcode = Min(ltrim(rtrim(party_code))) From Stt_exchg  
 If Len(ltrim(rtrim(@tocode))) = 0 Select @tocode = Max(ltrim(rtrim(party_code))) From Stt_exchg  
End  
*/  
  
If Len(ltrim(rtrim(@fromcode))) = 0 Set @fromcode = '0000000000'  
If Len(ltrim(rtrim(@tocode))) = 0 Set @tocode = 'zzzzzzzzzz'  
  
/*
Print '@fromdate: ' + @fromdate  
Print '@todate: ' + @todate  
Print '@fromcode: ' + @fromcode  
Print '@tocode: ' + @tocode  
*/
  
Set @selectclause = ''  
Set @fromclause = ''  
Set @whereclause = ''  
Set @groupby = ''  
Set @having = ''  
Set @orderby = ''  
  
Set @selectclause = @selectclause + ' Select'  
  
If @exceptiontype = 'bo' Set @selectclause = @selectclause + ' C.branch_id As Party_code,'  
If @exceptiontype = 'ex' Set @selectclause = @selectclause + ' E.party_code As Party_code,'  
  
If @exceptiontype = 'bo' Set @selectclause = @selectclause + ' C.scrip_cd As Scrip_cd,'  
If @exceptiontype = 'ex' Set @selectclause = @selectclause + ' E.scrip_cd As Scrip_cd,'  
  
Set @selectclause = @selectclause + ' Isnull(sum(c.psttdel), 0) As P_del_stt_tot_bo /*purchase-delivery-stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' Isnull(e.tpsttdel, 0) As P_del_stt_tot_ex /*purchase-delivery-stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' Isnull(sum(c.psttdel), 0)-isnull(e.tpsttdel, 0) As P_del_stt_tot_diff /*diff Of The Above 2*/,'  
  
Set @selectclause = @selectclause + ' Isnull(sum(c.ssttdel), 0) As S_del_stt_tot_bo /*sell-delivery-stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' Isnull(e.tssttdel, 0) As S_del_stt_tot_ex /*sell-delivery-stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' Isnull(sum(c.ssttdel), 0)-isnull(e.tssttdel, 0) As S_del_stt_tot_diff /*diff Of The Above 2*/,'  
  
Set @selectclause = @selectclause + ' Isnull(sum(c.sstttrd), 0) As S_trd_tot_bo /*sell-trading-stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' Isnull(e.tsstttrd, 0) As S_trd_tot_ex /*sell-trading-stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' Isnull(sum(c.sstttrd), 0)-isnull(e.tsstttrd, 0) As S_trd_stt_tot_diff /*diff Of The Above 2*/,'  
  
Set @selectclause = @selectclause + ' Isnull(sum(c.totalstt), 0) As Stt_tot_bo /*stt-total-backoffice*/,'  
Set @selectclause = @selectclause + ' Isnull(e.totalstt, 0) As Stt_tot_ex /*stt-total-exchange*/,'  
Set @selectclause = @selectclause + ' Isnull(sum(c.totalstt), 0)-isnull(e.totalstt, 0) As Tot_diff /*diff Of The Above 2*/,'  
  
If @exceptiontype = 'bo' Set @selectclause = @selectclause + ' C.rectype As Rectype'  
If @exceptiontype = 'ex' Set @selectclause = @selectclause + ' E.rectype As Rectype'  
  
Set @fromclause = @fromclause + ' From'  
Set @fromclause = @fromclause + ' Stt_clientdetail C Full Outer Join Stt_exchg_view_party_scrip_nsecm E'  
Set @fromclause = @fromclause + ' On'  
Set @fromclause = @fromclause + ' C.branch_id = E.party_code And'  
Set @fromclause = @fromclause + ' C.scrip_cd = E.scrip_cd And'  
Set @fromclause = @fromclause + ' C.sauda_date = E.stt_date And'  
Set @fromclause = @fromclause + ' C.sett_type = E.sett_type And'  
Set @fromclause = @fromclause + ' C.rectype = E.rectype'  
  
Set @whereclause = @whereclause + ' Where'  
  
If @exceptiontype = 'bo' --conditions On Stt_clientdetail Table  
Begin  
 Set @whereclause = @whereclause + ' C.rectype = 30 And'  --get Party+scrip Summary Recs Only.  
 --no E.rectype = 30 Condition Here Because Of The Outer Join, E.rectype Will Return Null If No Corres. Rec. Is Found  
 Set @whereclause = @whereclause + ' C.sauda_date >= ''' + @fromdate + ' 00:00:00' + ''' And'  
 Set @whereclause = @whereclause + ' C.sauda_date <= ''' + @todate + ' 23:59:59' + ''' And'  
 Set @whereclause = @whereclause + ' C.branch_id >= ''' + @fromcode + ''' And'  
 Set @whereclause = @whereclause + ' C.branch_id <= ''' + @tocode + ''''  
  
 --list Only Recs Whose Party Codes In Stt_exchg_view_party_scrip Are Null  
 --ie They R Present Only In Bo  
 Set @whereclause = @whereclause + ' And E.party_code Is Null'  
  
 Set @groupby = @groupby + ' Group By'  
 Set @groupby = @groupby + ' C.branch_id, C.scrip_cd, E.tpsttdel, E.tssttdel, E.tsstttrd, E.totalstt, C.rectype'  
  
 Set @orderby = @orderby + ' Order By'  
 Set @orderby = @orderby + ' 1, C.rectype Desc'  
End  
  
If @exceptiontype = 'ex' --conditions On Stt_exchg_view_party_scrip View  
Begin  
 Set @whereclause = @whereclause + ' E.rectype = 30 And'  --get Party+scrip Summary Recs Only.  
 --no C.rectype = 30 Condition Here Because Of The Outer Join, C.rectype Will Return Null If No Corres. Rec. Is Found  
 Set @whereclause = @whereclause + ' E.stt_date >= ''' + @fromdate + ' 00:00:00' + ''' And'  
 Set @whereclause = @whereclause + ' E.stt_date <= ''' + @todate + ' 23:59:59' + ''' And'  
 Set @whereclause = @whereclause + ' E.party_code >= ''' + @fromcode + ''' And'  
 Set @whereclause = @whereclause + ' E.party_code <= ''' + @tocode + ''''  
  
 --list Only Recs Whose Party Codes In Stt_clientdetail Are Null  
 --ie They R Present Only In Ex  
 Set @whereclause = @whereclause + ' And C.party_code Is Null'  
  
 Set @groupby = @groupby + ' Group By'  
 Set @groupby = @groupby + ' E.party_code, E.scrip_cd, E.tpsttdel, E.tssttdel, E.tsstttrd, E.totalstt, E.rectype'  
  
 Set @orderby = @orderby + ' Order By'  
 Set @orderby = @orderby + ' 1, E.rectype Desc'  
End  

Print @selectclause
Print @fromclause
Print @whereclause
Print @groupby
Print @orderby

Exec (@selectclause + @fromclause + @whereclause + @groupby + @orderby)

GO
