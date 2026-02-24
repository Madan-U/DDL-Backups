-- Object: PROCEDURE dbo.DEUTSCHEBank_Cash
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[DEUTSCHEBank_Cash] (@sdate varchar(12),@FROMFAMILY VARCHAR(15),
	@TOFAMILY VARCHAR(15),@FROMPARTYCODE varchar(20),@TOPARTYCODE varchar(20))  
  
AS  

if @FROMFAMILY = '' begin set @FROMFAMILY = '0'  end
if @TOFAMILY = '' begin set @TOFAMILY = 'zzzzzz' end
if @FROMPARTYCODE = '' begin set @FROMPARTYCODE = '0'  end
if @TOPARTYCODE = '' begin set @TOPARTYCODE = 'zzzzzz' end

select s.Contractno, MemberCode,sell_buy,
sum(s.tradeqty) as tradeqty, convert(varchar,convert(numeric(18,4),
round((sum(marketrate*tradeqty))/sum(tradeqty),4))) as marketrate,   
convert(varchar(11),sauda_date,101) as sauda_date,Ric = ISNULL(R.RIC,''),  
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),Brokerage = sum(Brokapplied*TradeQty),   
Pay_in = convert(varchar(11),sec_payin,101) , Exchangecode ='NSE'

    
from Owner,settlement s left outer join CMRicCodeMaster R on ( R.Scrip_Cd = s.Scrip_CD )  
,Sett_Mst, client1 c1, client2 c2  
where sauda_date like @sdate +'%' 
and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
  
And c1.cl_code = c2.cl_code  
and s.party_code = c2.party_code  
And s.Sett_No = Sett_Mst.Sett_No   
And s.Sett_Type = Sett_Mst.Sett_Type  
And s.tradeqty > 0
  
Group by  UPPER(family),s.Contractno, convert(varchar(11),sauda_date,101),sell_buy,Contractno,
RIC,convert(varchar(11),sec_payin,101),MemberCode
--order by sauda_date,sell_buy  
  
UNION  

  
select s.Contractno, MemberCode,sell_buy, sum(s.tradeqty) as tradeqty, convert(varchar,convert(numeric(18,4),round((sum(marketrate*tradeqty))/sum(tradeqty),4))) as marketrate,   
convert(varchar(11),sauda_date,101) as sauda_date,Ric = ISNULL(R.RIC,''),  
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),Brokerage = sum(Brokapplied*TradeQty),   
Pay_in = convert(varchar(11),sec_payin,101)  , Exchangecode ='NSE'
from Owner,isettlement s left outer join CMRicCodeMaster R on ( R.Scrip_Cd = s.Scrip_CD )  
,Sett_Mst, client1 c1, client2 c2  
where sauda_date like @sdate +'%'  
and family between @FROMFAMILY and @TOFAMILY  
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  

And c1.cl_code =c2.cl_code  
and s.party_code = c2.party_code  
And s.Sett_No = Sett_Mst.Sett_No   
And s.Sett_Type = Sett_Mst.Sett_Type  
And s.tradeqty > 0
  
Group by  s.Contractno, convert(varchar(11),sauda_date,101),sell_buy,Contractno,RIC,convert(varchar(11),
sec_payin,101),MemberCode
--order by sauda_date,sell_buy  
  
UNION  
  
select s.Contractno,MemberCode,s.sell_buy, sum(s.tradeqty) as tradeqty,convert(varchar,convert(numeric(18,4),round((sum(s.marketrate*s.tradeqty))/sum(s.tradeqty),4))) as marketrate,   
convert(varchar(11),s.sauda_date,101) as sauda_date,Ric = ISNULL(R.RIC,''),  
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),Brokerage = sum(s.Brokapplied*s.TradeQty),   
Pay_in = convert(varchar(11),M.sec_payin,101)  , Exchangecode ='BSE'
from bsedb.dbo.Owner,bsedb.dbo.settlement s left outer join bsedb.dbo.CMRicCodeMaster R on ( R.Scrip_Cd = s.Scrip_CD )  
,bsedb.dbo.Sett_Mst M, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2  
where sauda_date like @sdate +'%' 
and family between @FROMFAMILY and @TOFAMILY   
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  

And c1.cl_code = c2.cl_code  
and s.party_code = c2.party_code  
And s.Sett_No = M.Sett_No   
And s.Sett_Type = M.Sett_Type  
And s.tradeqty > 0  

Group by  s.Contractno, convert(varchar(11),sauda_date,101),sell_buy,Contractno,RIC,convert(varchar(11),
sec_payin,101),MemberCode 
  
--order by sauda_date,sell_buy  
  
UNION  
  
select s.Contractno,MemberCode,s.sell_buy, sum(s.tradeqty) as tradeqty,convert(varchar,convert(numeric(18,4),round((sum(s.marketrate*s.tradeqty))/sum(s.tradeqty),4))) as marketrate,   
convert(varchar(11),s.sauda_date,101) as sauda_date,Ric = ISNULL(R.RIC,''),  
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),Brokerage = sum(s.Brokapplied*s.TradeQty),   
Pay_in = convert(varchar(11),M.sec_payin,101)  , Exchangecode ='BSE'
from bsedb.dbo.Owner,bsedb.dbo.isettlement s left outer join bsedb.dbo.CMRicCodeMaster R on ( R.Scrip_Cd = s.Scrip_CD )  
,bsedb.dbo.Sett_Mst M, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2  
where sauda_date like @sdate +'%' 
and family between @FROMFAMILY and @TOFAMILY   
and c2.party_code=c1.cl_code

and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  

And c1.cl_code = c2.cl_code  
and s.party_code = c2.party_code  
And s.Sett_No = M.Sett_No   
And s.Sett_Type = M.Sett_Type  
And s.tradeqty > 0
  
Group by  s.Contractno, convert(varchar(11),sauda_date,101),sell_buy,Contractno,RIC,convert(varchar(11),
sec_payin,101),MemberCode
  
order by sauda_date,sell_buy,Contractno

GO
