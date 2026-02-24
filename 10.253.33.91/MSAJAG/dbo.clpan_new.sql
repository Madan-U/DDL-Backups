-- Object: PROCEDURE dbo.clpan_new
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure clpan_new( @basedon as varchar(11),@ttype as varchar(11),@val as int)
as 
set nocount on


--drop table #hyd_Client
select distinct c2.party_code,c1.long_name,l_address1,l_address2,l_address3,l_city,l_state,l_nation,l_zip,pan_gir_no,branch_cd,sub_broker
into #hyd_Client 
from client1 c1, client2 c2 where c1.cl_code=c2.cl_code 
and pan_gir_no=''
--and branch_cd='HYD'

select * into #hyd_trades from history where sauda_date>'Apr  1 2005 00:00:00'
and party_code in (select party_Code from #hyd_client)  

--select * from #hyd_trades
--select top 10 pan_gir_no from history
--select * from #hyd_trades1
--select * from #fin2
--select top 10 pan_gir_no from  settlement

select a.* into #hyd_trades1 from settlement a, #hyd_client b where sauda_date>'Apr  1 2005 00:00:00'
and a.party_Code=b.party_code ----0.51m,2.21m

/*declare @basedon as varchar(11)
set @basedon='orderval'
--set @basedon='Daily'
declare @ttype as varchar(11)
--set @ttype='All'
set @ttype='Delivery'
declare @val as int
set @val=100000
*/

if @ttype='All'
Begin

   if @basedon='orderval' 
   begin

	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty),order_no 
	into #aofin1 
	from #hyd_trades where isnumeric(trade_no)=1 
	group by PARTY_CODE,convert(varchar(11),sauda_Date),order_no 

	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty),order_no 
	into #aofin2 
	from #hyd_trades1 where isnumeric(trade_no)=1 
	group by party_code,convert(varchar(11),sauda_Date),order_no 

   select * into #aofin
   from
   (
   select distinct party_Code from #aofin1 where trade_value > @val
   union
   select distinct party_Code from #aofin2 where trade_value > @val
   ) a



   select distinct branch_cd,sub_broker,a.party_code,long_name,Address=l_address1+','+l_address2+',
	'+l_address3+','+l_city+','+l_state+','+l_nation+','+l_zip,pan_gir_no
   from #aofin a, #hyd_client b where a.party_code=b.party_code 

   end

   if @basedon='Daily' 
   begin

	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty) 
	into #adfin1 
	from #hyd_trades where isnumeric(trade_no)=1 
	group by party_code,convert(varchar(11),sauda_Date) 

  	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty)
	into #adfin2
	from #hyd_trades1 where isnumeric(trade_no)=1 
	group by party_code,convert(varchar(11),sauda_Date)

   select * into #adfin
   from
   (
   
   select distinct party_Code from #adfin1 where trade_value > @val
   union
   select distinct party_Code from #adfin2 where trade_value > @val
   ) a

   select distinct branch_cd,sub_broker,a.party_code,long_name,Address=l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_nation+','+l_zip,
   pan_gir_no
   from #adfin a, #hyd_client b where a.party_code=b.party_code 

   end

end

if @ttype='Delivery'
Begin

   if @basedon='orderval' 
   begin

	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty),order_no 
	into #dofin1 
	from #hyd_trades where isnumeric(trade_no)=1 and settflag in (4,5)
	group by party_code,convert(varchar(11),sauda_Date),order_no 

	select distinct
	party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty),order_no 
	into #dofin2 
	from #hyd_trades1 where isnumeric(trade_no)=1 and settflag in (4,5)
	group by party_code,convert(varchar(11),sauda_Date),order_no 

   select * into #dofin
   from
   (
  
   select distinct party_Code from #dofin1 where trade_value > @val
   union
   select distinct party_Code from #dofin2 where trade_value > @val
 ) a

   select distinct branch_cd,sub_broker,a.party_code,long_name,Address=l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_nation+','+l_zip,
   pan_gir_no
   from #dofin a, #hyd_client b where a.party_code=b.party_code 

   end

   if @basedon='Daily' 
   begin

	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty) 
	into #ddfin1 
	from #hyd_trades where isnumeric(trade_no)=1 and settflag in (4,5)
	group by party_code,convert(varchar(11),sauda_Date) 

	select distinct party_code,Sauda_Date=convert(varchar(11),sauda_Date),Trade_value=sum(marketrate*tradeqty)
	into #ddfin2 
	from #hyd_trades1 where isnumeric(trade_no)=1 and settflag in (4,5)
	group by party_code,convert(varchar(11),sauda_Date)

   select * into #ddfin
   from
   (
  
   select distinct party_Code from #dfin1 where trade_value > @val
   union
   select distinct party_Code from #ddfin2 where trade_value > @val
   ) a

   select distinct branch_cd,sub_broker,a.party_code,long_name,Address=l_address1+','+l_address2+','+l_address3+','+l_city+','+l_state+','+l_nation+','+l_zip,
   pan_gir_no
   from #ddfin a, #hyd_client b where a.party_code=b.party_code 

  end

end

set nocount off

GO
