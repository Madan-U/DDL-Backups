-- Object: PROCEDURE dbo.AfterContSelect
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc AfterContSelect   
@tqty int, 
@tparty varchar(7), 
@tscrip varchar(12), 
@tseries varchar(2), 
@tdate varchar(10), 
@tsellbuy varchar(2),
@tsett_type varchar(2),
@flag smallint
AS
if @flag = 1
 begin
           select  contractno,trade_no,tradeqty ,marketrate,netrate,markettype
  from settlement
   where party_code = @tparty
  and scrip_cd = @tscrip
  and convert(varchar,sauda_date,3) like @tdate
  and sell_buy = @tsellbuy 
  and series = @tSeries
  and billno = 0
  and  tradeqty =@tqty 
  and sett_type like @tsett_type
  
 end 
else if @flag = 2
 begin
  select  contractno,trade_no,tradeqty ,marketrate,netrate,markettype
  from settlement
   where  tradeqty > @tqty  
  and party_code = @tparty
  and scrip_cd = @tscrip
  and convert(varchar,sauda_date,3) like @tdate
  and sell_buy = @tsellbuy 
  and series = @tSeries
  and sell_buy = @tsellbuy
  and sett_type like @tsett_type
  and billno = 0
  
 end
else if @flag  = 3
 begin
  select  contractno,trade_no,tradeqty ,marketrate,netrate,markettype
  from settlement
   where party_code = @tparty
  and scrip_cd = @tscrip
  and convert(varchar,sauda_date,3) like @tdate
  and sell_buy = @tsellbuy 
  and series = @tSeries
  and sell_buy = @tsellbuy
  and sett_type like @tsett_type
  and billno = 0
  order by tradeqty desc
 end 
else if @flag = 4
 begin
  select distinct s1.party_code, s1.scrip_cd, s1.series,
      s1.Pqty , s1.Sqty from billsalepur1 s1,client2
       where client2.tran_cat = 'Trd' 
       ANd isnull(s1.pqty,0) <> isnull(s1.sqty,0)
      and client2.party_code = s1.party_code 
  and s1.party_code = @tparty
  and s1.scrip_cd = @tscrip
  and s1.series = @tSeries
  and convert(varchar,sauda_date,3) like @tdate
  and sett_type like @tsett_type
  order by s1.party_code
 end

GO
