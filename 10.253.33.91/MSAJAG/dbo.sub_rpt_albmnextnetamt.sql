-- Object: PROCEDURE dbo.sub_rpt_albmnextnetamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_albmnextnetamt    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmnextnetamt    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmnextnetamt    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmnextnetamt    Script Date: 12/27/00 8:59:16 PM ******/
/* report: bill report
   file : albmwbill.asp
   displays settlement wise,  partywise, seriewise net amount for nextsettlement
*/
/*
modifoed by neelambari on 5 feb
here in queries for netamt groupby was done according to partycode but it should be partipantcode so changed that to partipantcode*/
CREATE PROCEDURE sub_rpt_albmnextnetamt 
@membercode varchar(10),
@settno varchar(7)
AS
select s.sett_no, s.series, s.scrip_cd, s.partipantcode,
netamt = isnull((select sum(tradeqty*marketrate) from trdbackup
 where sett_no=s.sett_no and sett_type=s.sett_type
and partipantcode=s.partipantcode and series=s.series and sell_buy= 1 and scrip_cd = s.scrip_cd
group by sett_no,sett_type,partipantcode,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from trdbackup
  where sett_no=s.sett_no and sett_type=s.sett_type
and partipantcode =s.partipantcode  and series=s.series and sell_buy= 2 and scrip_cd = s.scrip_cd
group by sett_no,sett_type,partipantcode,series,sell_buy ),0) 
from trdbackup  s 
where s.sett_type='L' and s.order_no not  like 'p%'
and s.partipantcode like ltrim(@membercode)+'%'  and s.sett_no=@settno
group by s.sett_no,s.sett_type,s.partipantcode,s.scrip_cd,s.series
order by s.sett_no,s.sett_type,s.partipantcode,s.series

GO
