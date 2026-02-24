-- Object: PROCEDURE dbo.rpt_singlepartywiseturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_singlepartywiseturn    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_singlepartywiseturn    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_singlepartywiseturn    Script Date: 20-Mar-01 11:39:03 PM ******/




/* report: partywise turnover
   file : partywiseturn.asp
*/   	
/* displays partywise turnover for settlements whose sec payin date is greater than today's date
including no delivery scrips for a party and series
settlement will be transeferred to history on sec pay in date so search is not made in history for trades
other than w
*/
CREATE PROCEDURE rpt_singlepartywiseturn

@party varchar(10),
@series varchar(3)

AS

if @series='BE' 
begin
select s.party_code, c1.short_name,scrip_cd, tradeqty=sum( tradeqty),amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, s.series, s.sett_type,
party=(select distinct party_code from albmwparty where s.party_code=@party) ,
rate=(case when s.sett_type='p' then (select rate from albmrate a where s.sett_no=a.sett_no and s.sett_type='p'
and s.scrip_cd=a.scrip_cd) else 0 end)
from settlement s, sett_mst st, client1 c1, client2 c2
where 
order_no not like 'p%' and
st.sett_no=s.sett_no and s.sett_type=st.sett_type
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
and s.party_code=@party 
and c1.cl_code=c2.cl_code and c2.party_code=s.party_code
and (s.series ='01' or s.series='be') /* only effect of 01 is shown in current settlement so ignore other trades */
group by s.party_code,c1.short_name,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy
order by c1.short_name,s.party_code,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy
end 
else
begin
select s.party_code, c1.short_name,scrip_cd,tradeqty=sum( tradeqty),amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, s.series, s.sett_type
from settlement s, sett_mst st, client1 c1, client2 c2
where 
order_no not like 'p%' and
st.sett_no=s.sett_no and s.sett_type=st.sett_type
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
and s.party_code=@party and s.series=@series
and c1.cl_code=c2.cl_code and c2.party_code=s.party_code
group by s.party_code,c1.short_name,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy
order by c1.short_name,s.party_code,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy
end





/* old
select party_code, scrip_cd, tradeqty,amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, s.series, s.sett_type 
from settlement s, sett_mst st
where 
order_no not like 'p%' and
st.sett_no=s.sett_no and s.sett_type=st.sett_type
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
and s.party_code=@party and s.series=@series
group by party_code,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy,tradeqty
order by party_code,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy,tradeqty
*/

GO
