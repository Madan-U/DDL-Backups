-- Object: PROCEDURE dbo.rpt_partyturn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_partyturn    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyturn    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyturn    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyturn    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyturn    Script Date: 12/27/00 8:58:57 PM ******/

/* report : partywise turnover
   file : detailparty.asp
*/
/* displays details of turnover of a particular party */
CREATE PROCEDURE rpt_partyturn
@partycode varchar(10),
@series varchar(3)
AS
select Scrip_Cd,party_code, qty=sum(tradeqty), amount=sum(tradeqty*marketrate),Sell_buy, s.sett_no, s.series, s.sett_type 
from settlement s, sett_mst st
where 
order_no not like 'p%' 
and st.sett_no=s.sett_no and s.sett_type=st.sett_type
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
and s.party_code=@partycode and s.series=@series
group by party_code,s.series,scrip_cd,s.sett_type,s.sett_no,sell_buy
order by party_code,s.series,scrip_cd,s.sett_type,s.sett_no,sell_buy

GO
