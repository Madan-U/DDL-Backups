-- Object: PROCEDURE dbo.ContSectionIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContSectionIns    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContSectionIns    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContSectionIns    Script Date: 20-Mar-01 11:38:48 PM ******/
/*Created by sheetal 24/10/2000
This is used in InsContPrint to print the constitutional contract*/
CREATE Proc ContSectionIns (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6),@flag smallint)
  as 
if @flag = 1
begin
SELECT distinct  s.contractNo,s.party_code,s.order_no ,/*tm=convert(char,sauda_date,108),*/
 s.sell_buy,scripname=scrip1.short_name,sdt=convert(char,s.sauda_date,103),s.markettype,
 pqty=isnull((case sell_buy
   when 1 then  (select sum(tradeqty) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end),0),
sqty=isnull((case sell_buy
   when 2 then (select sum(tradeqty) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end),0),
prate= isnull((case sell_buy
   when 1 then (select isnull(sum(Trade_Amount),0) from isettlement s1
     where s1.order_no = s.order_no
   and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
      group by s.order_no, s.scrip_cd,s.series)end),0) ,
srate = isnull((case sell_buy
      when 2 then (select isnull(sum(Trade_Amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
     where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
      and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)end),0) ,
  
pnetrate= isnull((case sell_buy
     when 1 then (select isnull(sum(Amount),0) from isettlement s1
     where s1.order_no = s.order_no
   and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
   and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end) ,0) ,
snetrate=isnull((case sell_buy
          when 2 then (select isnull(sum(Amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)end ) ,0),
    
pamt=isnull((case sell_buy
   when 1 then (select isnull(sum(amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)  end),0) ,
samt=isnull((case sell_buy 
  when 2 then (select isnull(sum(amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  end ),0) 
   
  from isettlement s ,scrip1,scrip2
  where s.scrip_cd=scrip2.scrip_cd
  and s.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
  and left(convert(varchar,s.sauda_date,109),11) LIKE @Sdate
  and s.tradeqty <> 0
  and convert(int,s.contractno) =@ContNo
  and rtrim(s.sett_type) like @Sett_Type
  group by s.sett_type,s.contractNo,s.party_code,s.order_no ,convert(char,s.sauda_date,103),s.scrip_cd,scrip1.short_name,s.series,
  s.sell_buy,s.markettype
  order by scrip1.short_name
end
else if @flag = 2
begin
SELECT distinct  s.contractNo,s.party_code,s.order_no ,/*tm=convert(char,sauda_date,108),s.sauda_date,*/
 s.sell_buy,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),s.markettype,
 pqty=isnull((case sell_buy
   when 1 then  (select sum(tradeqty) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)end),0),
 sqty=isnull((case sell_buy
   when 2 then (select sum(tradeqty) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end),0),
 prate= isnull((case sell_buy
   when 1 then (select isnull(sum(Trade_Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
      group by s.order_no, s.scrip_cd,s.series)end),0) ,
 srate = isnull((case sell_buy
     when 2 then (select isnull(sum(Trade_Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
      group by s.order_no, s.scrip_cd,s.series)end),0) ,
 
  /*pbrok=isnull((case sell_buy
  when 1 then settlement.brokapplied end),0),
  sbrok=isnull((case sell_buy
   when 2 then settlement.brokapplied end),0),*/
 pnetrate= isnull((case sell_buy
          when 1 then (select isnull(sum(Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end) ,0) ,
 snetrate=isnull((case sell_buy
          when 2 then (select isnull(sum(Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end ) ,0),
    
 pamt=isnull((case sell_buy
   when 1 then (select isnull(sum(amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series) end),0) ,
samt=isnull((case sell_buy 
  when 2 then (select isnull(sum(amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  end ),0) 
    
   
  
 /* Brokerage=isnull((tradeqty*brokapplied),0)*/
  from ihistory s ,scrip1,scrip2
  where s.scrip_cd=scrip2.scrip_cd
  and s.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
  and left(convert(varchar,s.sauda_date,109),11) LIKE @Sdate
  and s.tradeqty <> 0
 and convert(int,s.contractno) =@ContNo
 and rtrim(s.sett_type) like @Sett_Type
 group by s.sett_type,s.contractNo,s.party_code,s.order_no ,convert(char,s.sauda_date,103),s.scrip_cd,scrip1.short_name,s.series,
 s.sell_buy,s.markettype
 order by scrip1.short_name
end
else if @flag = 3
begin
SELECT distinct  s.contractNo,s.party_code,s.order_no ,/*tm=convert(char,sauda_date,108),*/
 s.sell_buy,scripname=scrip1.short_name,sdt=convert(char,s.sauda_date,103),s.markettype,
 pqty=isnull((case sell_buy
   when 1 then  (select sum(tradeqty) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end),0),
sqty=isnull((case sell_buy
   when 2 then (select sum(tradeqty) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end),0),
prate= isnull((case sell_buy
   when 1 then (select isnull(sum(Trade_Amount),0) from isettlement s1
     where s1.order_no = s.order_no
   and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
      group by s.order_no, s.scrip_cd,s.series)end),0) ,
srate = isnull((case sell_buy
      when 2 then (select isnull(sum(Trade_Amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
     where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
      and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)end),0) ,
  
pnetrate= isnull((case sell_buy
     when 1 then (select isnull(sum(Amount),0) from isettlement s1
     where s1.order_no = s.order_no
   and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
   and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end) ,0) ,
snetrate=isnull((case sell_buy
          when 2 then (select isnull(sum(Amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(Sum(TradeQty),1) from isettlement s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)end ) ,0),
    
pamt=isnull((case sell_buy
   when 1 then (select isnull(sum(amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)  end),0) ,
samt=isnull((case sell_buy 
  when 2 then (select isnull(sum(amount),0) from isettlement s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  end ),0) 
   
  from isettlement s ,scrip1,scrip2
  where s.scrip_cd=scrip2.scrip_cd
  and s.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
  and left(convert(varchar,s.sauda_date,109),11) LIKE @Sdate
  and s.tradeqty <> 0
  and convert(int,s.contractno) =@ContNo
  and rtrim(s.sett_type) like @Sett_Type
  group by s.sett_type,s.contractNo,s.party_code,s.order_no ,convert(char,s.sauda_date,103),s.scrip_cd,scrip1.short_name,s.series,
  s.sell_buy,s.markettype
union all
SELECT distinct  s.contractNo,s.party_code,s.order_no ,/*tm=convert(char,sauda_date,108),s.sauda_date,*/
 s.sell_buy,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),s.markettype,
 pqty=isnull((case sell_buy
   when 1 then  (select sum(tradeqty) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
     and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
   group by s.order_no, s.scrip_cd,s.series)end),0),
 sqty=isnull((case sell_buy
   when 2 then (select sum(tradeqty) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end),0),
 prate= isnull((case sell_buy
   when 1 then (select isnull(sum(Trade_Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
      group by s.order_no, s.scrip_cd,s.series)end),0) ,
 srate = isnull((case sell_buy
     when 2 then (select isnull(sum(Trade_Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
      group by s.order_no, s.scrip_cd,s.series)end),0) ,
 
  /*pbrok=isnull((case sell_buy
  when 1 then settlement.brokapplied end),0),
  sbrok=isnull((case sell_buy
   when 2 then settlement.brokapplied end),0),*/
 pnetrate= isnull((case sell_buy
          when 1 then (select isnull(sum(Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end) ,0) ,
 snetrate=isnull((case sell_buy
          when 2 then (select isnull(sum(Amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  /
        (select isnull(sum(tradeqty),1) from ihistory s1 
      where s1.order_no = s.order_no
      and s1.scrip_cd = s.scrip_cd
      and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)end ) ,0),
    
 pamt=isnull((case sell_buy
   when 1 then (select isnull(sum(amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series) end),0) ,
samt=isnull((case sell_buy 
  when 2 then (select isnull(sum(amount),0) from ihistory s1
     where s1.order_no = s.order_no
     and s1.scrip_cd = s.scrip_cd
     and s1.series = s.series
   and s1.sett_type = s.sett_type
     and s1.party_code = s.party_code
   and s1.sell_buy = s.sell_buy
     group by s.order_no, s.scrip_cd,s.series)  end ),0) 
    
   
  
 /* Brokerage=isnull((tradeqty*brokapplied),0)*/
  from ihistory s ,scrip1,scrip2
  where s.scrip_cd=scrip2.scrip_cd
  and s.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
  and left(convert(varchar,s.sauda_date,109),11) LIKE @Sdate
  and s.tradeqty <> 0
 and convert(int,s.contractno) =@ContNo
 and rtrim(s.sett_type) like @Sett_Type
 group by s.sett_type,s.contractNo,s.party_code,s.order_no ,convert(char,s.sauda_date,103),s.scrip_cd,scrip1.short_name,s.series,
 s.sell_buy,s.markettype
 order by scrip1.short_name
end

GO
