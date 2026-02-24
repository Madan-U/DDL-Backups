-- Object: PROCEDURE dbo.rpt_datewisedetailofposscripcummulative
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datewisedetailofposscripcummulative    Script Date: 04/27/2001 4:32:38 PM ******/
CREATE  PROCEDURE rpt_datewisedetailofposscripcummulative 
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripcd varchar(12),
@series varchar(3),
@fdate varchar(12),
@tdate varchar(12),
@flag int
as

if @flag = 1
begin
select  qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)  
from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd  
and series=@series
and sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' 
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)    
from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series and
sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' 
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)  
  from detailPlusOneAlbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' 
group by sell_buy, sauda_date
order by sauda_date
end
else if @flag = 2
begin
select  qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)   
from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' 
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)   
 from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series and
sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' and tmark <>'$'
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)  
  from detailPlusOneAlbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' and tmark <>'$'
group by sell_buy, sauda_date
order by sauda_date
end
else if @flag = 3
begin
select  qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)  
 from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' 
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)  
  from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series and
sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' and tmark = '$'
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)  
  from detailPlusOneAlbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and sauda_date >= @fdate 
and sauda_date <= @tdate+' 23:59:59' and tmark = '$'
group by sell_buy, sauda_date
order by sauda_date
end

GO
