-- Object: PROCEDURE dbo.rpt_userturnover
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_userturnover    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_userturnover    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_userturnover    Script Date: 20-Mar-01 11:39:04 PM ******/




/* report : useridwise 
   file : useridwiseturn.asp
*/
/* displays useridwise, settlementwise,scripwise sum of quantity * marketrate including no delivery scrips
    settlement is transferred to history on security payin date so no need to check in history	
    if order no is p% then don't take it in calculation as its pure albm
 */
 
CREATE PROCEDURE rpt_userturnover

AS

select s.Scrip_Cd,s.User_id, amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no,ser= s.series, s.sett_type ,s.tradeqty,
series=(case when s.sett_type='p'  then 'BE' else s.series end ),
rate=(case when s.sett_type='p' then (select rate from albmrate a where s.sett_no=a.sett_no and s.sett_type='p'
and s.scrip_cd=a.scrip_cd) else 0 end),
userid=(select distinct a.user_id from  albmwuserid a where s.user_id=a.user_id ) 
from settlement s, sett_mst st
where 
Order_no  not like 'p%' 
and st.sett_no=s.sett_no and s.sett_type=st.sett_type
and s.series not in ('02','03','04','05') /* only effect of 01 of current settlement has to be given) */
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
group by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,sell_buy,s.order_no,s.tradeqty
order by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,sell_buy,s.order_no,s.tradeqty

GO
