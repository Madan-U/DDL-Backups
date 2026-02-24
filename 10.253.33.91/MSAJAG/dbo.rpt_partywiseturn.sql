-- Object: PROCEDURE dbo.rpt_partywiseturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_partywiseturn    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partywiseturn    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partywiseturn    Script Date: 20-Mar-01 11:39:02 PM ******/




/* report: partywise turnover
   file : partywiseturn.asp
*/   	
/* displays partywise turnover for settlements whose sec payin date is greater than today's date
including no delivery scrips
settlement will be transeferred to history on sec pay in date so search is not made in history
*/

/* old query
CREATE PROCEDURE rpt_partywiseturn


AS

select s.party_code, c1.short_name, scrip_cd, tradeqty,amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, s.series, s.sett_type 
from settlement s, sett_mst st, client1 c1, client2 c2
where 
order_no not like 'p%' and
st.sett_no=s.sett_no and s.sett_type=st.sett_type
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
and c1.cl_code=c2.cl_code and c2.party_code=s.party_code
group by s.party_code,c1.short_name,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy,tradeqty
order by c1.short_name,s.party_code,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy,tradeqty


*/

/* report: partywise turnover
   file : partywiseturn.asp
*/   	
/* displays partywise turnover for settlements whose sec payin date is greater than today's date
including no delivery scrips
settlement will be transeferred to history on sec pay in date so search is not made in history
*/
CREATE PROCEDURE rpt_partywiseturn



AS




select s.party_code, c1.short_name, scrip_cd, tradeqty,amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no,s.sett_type ,
series=(case when s.sett_type='p'  then 'BE' else s.series end ), pseries=s.series,
rate=(case when s.sett_type='p' then (select rate from albmrate a where s.sett_no=a.sett_no and s.sett_type='p'
and s.scrip_cd=a.scrip_cd) else 0 end),
party=(select distinct party_code from albmwparty where party_code=s.party_code)
from settlement s, sett_mst st, client1 c1, client2 c2
where 
order_no not like 'p%' and
s.series not in ('02','03','04','05') and /* only  effect of 01 series of w will be given in w type settlement */
st.sett_no=s.sett_no and s.sett_type=st.sett_type
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
and c1.cl_code=c2.cl_code and c2.party_code=s.party_code
group by s.party_code,c1.short_name,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy,tradeqty
order by c1.short_name,s.party_code,s.series,s.scrip_cd,s.sett_type,s.sett_no,sell_buy,tradeqty

GO
