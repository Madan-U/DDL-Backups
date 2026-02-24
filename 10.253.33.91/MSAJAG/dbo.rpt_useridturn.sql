-- Object: PROCEDURE dbo.rpt_useridturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_useridturn    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_useridturn    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_useridturn    Script Date: 20-Mar-01 11:39:04 PM ******/




/* report : userid wise turnover
   file : useridturn.asp
*/
/* displays turnover of a particular user for a particular series
*/

CREATE PROCEDURE rpt_useridturn 
@userid varchar(6),
@series varchar(3)

AS

if @series='EQ'
begin
	select Scrip_Cd,User_id, qty=Sum(s.tradeqty), amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, ser=s.series, s.sett_type ,
	series=(case when s.sett_type='p'  then 'BE' else s.series end ),
	rate=(case when s.sett_type='p' then (select rate from albmrate a where s.sett_no=a.sett_no and s.sett_type='p'
	and s.scrip_cd=a.scrip_cd) else 0 end)
	from settlement s, sett_mst st
	where 
	order_no not like 'p%' 
	and st.sett_no=s.sett_no and s.sett_type=st.sett_type
	and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
	and s.user_id=@userid  and (s.series=@series or s.series like 'w%')  /* w written for series like w1,w2 etc which are included in eq */
	group by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,s.sell_buy,s.order_no
	order by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,s.sell_buy,s.order_no
end 
else if @series='BE' 
begin
	select Scrip_Cd,User_id, qty=sum(s.tradeqty), amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, ser=s.series, s.sett_type ,
	series=(case when s.sett_type='p'  then 'BE' else s.series end ),
	rate=(case when s.sett_type='p' then (select rate from albmrate a where s.sett_no=a.sett_no and s.sett_type='p'
	and s.scrip_cd=a.scrip_cd) else 0 end)
	from settlement s, sett_mst st
	where 
	order_no not like 'p%' 
	and st.sett_no=s.sett_no and s.sett_type=st.sett_type
	and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
	and s.user_id=@userid  and (s.series=@series  or s.series='01') /* for be only one series i.e 01's opposite effect 
	has to be given for current settlement*/ 
	group by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,s.sell_buy,s.order_no
	order by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,s.sell_buy,s.order_no

end 
else
begin
	select Scrip_Cd,User_id, qty=sum(s.tradeqty), amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, ser=s.series, s.sett_type ,
	series=(case when s.sett_type='p'  then 'BE' else s.series end ),
	rate=(case when s.sett_type='p' then (select rate from albmrate a where s.sett_no=a.sett_no and s.sett_type='p'
	and s.scrip_cd=a.scrip_cd) else 0 end)
	from settlement s, sett_mst st
	where 
	order_no not like 'p%' 
	and st.sett_no=s.sett_no and s.sett_type=st.sett_type
	and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
	and s.user_id=@userid  and (s.series=@series ) /* no need to write s.series='W' for other series than eq */ 
	group by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,s.sell_buy,s.order_no
	order by user_id,s.series,scrip_cd,s.sett_type,s.sett_no,s.sell_buy,s.order_no
end

GO
