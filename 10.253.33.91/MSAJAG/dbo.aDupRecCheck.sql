-- Object: PROCEDURE dbo.aDupRecCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc aDupRecCheck 
As
Declare
@@Membercode as varchar(10),
@@Mycode As cursor

Update Afttrade set party_code = ltrim(rtrim(branches.branch_cd) + afttrade.party_code) from  
client1 c1, Client2 C2 , Branches
where 
Afttrade.party_code  = c2.party_code
and
c2.cl_code = c1.cl_code
and 
c1.trader = branches.short_name
and  
branches.remote = 1
and afttrade.user_id = branches.terminal_id
and afttrade.party_code not like branches.branch_cd + '%'

Update AFTTrade Set Branch_id = Party_code

Set @@Mycode = cursor for 
    Select MemberCode  from Owner
    Open @@Mycode
    Fetch next  from @@Mycode into   @@MemberCode
Close @@Mycode
Deallocate @@Mycode


/* Line commented by VNS as per instructions of Animesh on 04-04-2001 */
/*Update aFTTrade set Order_no = 'P'+Order_No where TMark = '$'*/

if ( select count(*) from Owner where terminal = 'NEAT' ) > 0 
begin
insert into atrade select * from afttrade where trade_no not in 
      ( select tm.trade_no from atrade tm 
   where convert(varchar,afttrade.sauda_date,106) = convert(varchar,tm.sauda_date,106)
  and afttrade.trade_no = tm.trade_no
 and afttrade.order_no = tm.order_no
 and afttrade.scrip_cd = tm.scrip_cd
 and afttrade.series = tm.series
 and afttrade.tradeqty = tm.tradeqty
 and afttrade.marketrate = tm.marketrate
 and afttrade.sell_buy = tm.sell_buy
 and afttrade.markettype = tm.markettype)
end
else
begin
insert into atrade select * from afttrade where trade_no not in 
  ( select tm.trade_no from atrade tm
  where convert(varchar,afttrade.sauda_date,106) = convert(varchar,tm.sauda_date,106)
  and afttrade.trade_no = tm.trade_no
 and afttrade.order_no = tm.order_no
 and afttrade.scrip_cd = tm.scrip_cd
 and afttrade.series = tm.series
 and afttrade.tradeqty = tm.tradeqty
 and afttrade.marketrate = tm.marketrate
 and afttrade.user_id = tm.user_id
 and afttrade.sell_buy = tm.sell_buy
 and afttrade.markettype = tm.markettype)
end

GO
