-- Object: PROCEDURE dbo.InsDelTbl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.InsDelTbl    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.InsDelTbl    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.InsDelTbl    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.InsDelTbl    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.InsDelTbl    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.InsDelTbl    Script Date: 12/18/99 8:24:10 AM ******/
CREATE PROCEDURE  InsDelTbl as
/* CLIENTWISE NET POSITION*/
insert into deliveryClt  select  sett_no ,sett_type , scrip_cd , series , party_code,
Tradeqty = abs (isnull((select sum(tradeqty) from settlement s1  where s1.sell_buy = 1  and (s.scrip_cd = s1.scrip_cd) and (s.series = s1.series) and (s.party_code = s1.party_code)) -
             (select sum(tradeqty) from settlement s1  where s1.sell_buy = 2  and (s.scrip_cd = s1.scrip_cd)and (s.series = s1.series) and (s.party_code = s1.party_code)),0)) ,
inout = case
  when
     isnull((select sum(tradeqty) from settlement s1  where s1.sell_buy = 1  and (s.scrip_cd = s1.scrip_cd) and (s.series = s1.series) and (s.party_code = s1.party_code)) -
             (select sum(tradeqty) from settlement s1  where s1.sell_buy = 2  and (s.scrip_cd = s1.scrip_cd)and (s.series = s1.series) and (s.party_code = s1.party_code)),0)  > 0 
    then
  "O"
    when
       isnull((select sum(tradeqty) from settlement s1  where s1.sell_buy = 1  and (s.scrip_cd = s1.scrip_cd) and (s.series = s1.series) and (s.party_code = s1.party_code)) -
                  (select sum(tradeqty) from settlement s1  where s1.sell_buy = 2  and (s.scrip_cd = s1.scrip_cd)and (s.series = s1.series) and (s.party_code = s1.party_code)),0) < 0 
     then 
  "I"
    else
  "N"
    end
from settlement s
  where billno <> '0'
   group by scrip_cd , series,sett_no,sett_type ,party_code
/* DELIVERY NET POSITION*/
 insert into DelNet  select   sett_no ,sett_type, scrip_cd , series,
Tradeqty = abs (isnull((select sum(tradeqty) from settlement s1  where s1.sell_buy = 1  and (s.scrip_cd = s1.scrip_cd) and (s.series = s1.series) and (s.sett_no = s1.sett_no)) -
             (select sum(tradeqty) from settlement s1  where s1.sell_buy = 2  and (s.scrip_cd = s1.scrip_cd)and (s.series = s1.series) and (s.sett_no = s1.sett_no) ),0)) ,
inout = case
  when
     isnull((select sum(tradeqty) from settlement s1  where s1.sell_buy = 1  and (s.scrip_cd = s1.scrip_cd) and (s.series = s1.series) and (s.sett_no = s1.sett_no)) -
             (select sum(tradeqty) from settlement s1  where s1.sell_buy = 2  and (s.scrip_cd = s1.scrip_cd)and (s.series = s1.series) and ((s.sett_no = s1.sett_no)) ),0)  > 0 
    then
  "O"
    when
       isnull((select sum(tradeqty) from settlement s1  where s1.sell_buy = 1  and (s.scrip_cd = s1.scrip_cd) and (s.series = s1.series) and ((s.sett_no = s1.sett_no) )) -
                  (select sum(tradeqty) from settlement s1  where s1.sell_buy = 2  and (s.scrip_cd = s1.scrip_cd)and (s.series = s1.series) and ((s.sett_no = s1.sett_no))),0) < 0 
     then 
  "I"
    else
  "N"
    end
from settlement s 
  where billno <> '0'
    group by scrip_cd , series  , sett_no,sett_type

GO
