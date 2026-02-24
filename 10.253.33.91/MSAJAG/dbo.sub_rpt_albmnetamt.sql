-- Object: PROCEDURE dbo.sub_rpt_albmnetamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_albmnetamt    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmnetamt    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_albmnetamt    Script Date: 20-Mar-01 11:39:10 PM ******/

/*
modified by neelambari on 5 feb 
Here in group by clause instead of partipant code ,  partycode was used
so changed in group by clause to partipantcode  instead of partycode
*/



CREATE PROCEDURE sub_rpt_albmnetamt 
@membercode varchar(10),
@scripcd varchar(12),
@settno varchar(7)
AS

select s.sett_no, s.series, s.scrip_cd,
netamt = isnull((select sum(tradeqty*marketrate) from trdbackup
 where sett_no=s.sett_no and sett_type=s.sett_type
and partipantcode=s.partipantcode and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 1 
group by sett_no,sett_type,partipantcode,scrip_cd,series,sell_buy ),0) 
- isnull((select sum(tradeqty*marketrate) from trdbackup  where sett_no=s.sett_no and sett_type=s.sett_type
and partipantcode=s.partipantcode and scrip_cd=s.scrip_cd and series=s.series and sell_buy= 2 
group by sett_no,sett_type,partipantcode,scrip_cd,series,sell_buy ),0) 
from trdbackup  s 
where s.sett_type='L' and s.order_no not  like 'p%'
and s.partipantcode like ltrim(@membercode)+'%'  and s.sett_no=@settno
and s.scrip_cd=@scripcd
group by s.sett_no,s.sett_type,s.partipantcode,s.series,s.scrip_cd
order by s.sett_no,s.sett_type,s.partipantcode,s.series,s.scrip_cd

GO
