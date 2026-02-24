-- Object: PROCEDURE dbo.rpt_whistuserid
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_whistuserid    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_whistuserid    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_whistuserid    Script Date: 20-Mar-01 11:39:04 PM ******/



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* report : partywise turnover
   file : partywiseturn.asp
   finds oppsite saudas whom effect should be given in  current p settlement for a userid and for a scrip
   and calculates difference bet its total buy and sell amounts
*/
CREATE PROCEDURE rpt_whistuserid

@userid int ,
@wsettno varchar(7)



AS


select user_id, scrip_cd, 
amt=isnull((select sum(tradeqty*rate)from albmwuserid  a where a.user_id=al.user_id and a.sell_buy='1'and
a.sett_no=al.sett_no and a.ser<> '01' and a.scrip_cd=al.scrip_cd
group by user_id,scrip_cd,sell_buy),0) - 
isnull((select sum(tradeqty*rate) from albmwuserid  a where a.user_id=al.user_id and a.sell_buy='2' 
and a.sett_no=al.sett_no and a.ser <> '01' and  a.scrip_cd=al.scrip_cd
group by user_id,scrip_cd,sell_buy),0)
from albmwuserid   al
where al.user_id=@userid  and sett_no=@wsettno
group by al.sett_no,al.user_id,al.scrip_cd
/*
select * from albmhist where
user_id=@userid and sett_no=@wsettno
and ser <> '01'  
*/

GO
