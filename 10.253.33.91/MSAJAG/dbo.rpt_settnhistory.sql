-- Object: PROCEDURE dbo.rpt_settnhistory
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settnhistory    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnhistory    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnhistory    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnhistory    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settnhistory    Script Date: 12/27/00 8:58:58 PM ******/

CREATE PROCEDURE rpt_settnhistory
@statusid varchar(15),
@statusname varchar(25),
@code varchar(10),
@name varchar(21),
@settno varchar(7),
@settype varchar(2),
@scripcd varchar(7),
@trader varchar(15)
AS
if (@statusid = 'broker' )
begin
   if (select count(*)from settlement s, client1 c1, client2 c2
 where s.party_code like ltrim(@code)+'%'
 and c1.cl_code = c2.cl_code
 and s.party_code = c2.party_code
 and c1.short_name like ltrim(@name)+'%'
 and s.sett_no = @settno
 and s.sett_type = @settype
 and s.scrip_cd like ltrim(@scripcd)+'%'
 and c1.trader like ltrim(@trader)+'%')>0 
   begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,
 Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
 from settlement s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like ltrim(@name)+'%' 
 and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no =@settno
 and s.sett_type = @settype
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
   end
   else
     begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from history s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like ltrim(@name)+'%'
 and c1.trader like  ltrim(@trader)+'%' and s.scrip_cd like  ltrim(@scripcd)+'%' 
 and s.sett_no =@settno and s.sett_type =@settype 
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
     end
end     
if (@statusid = 'subbroker' )
begin
   if (select count(*)from settlement s, client1 c1, client2 c2
 where s.party_code like ltrim(@code)+'%'
 and c1.cl_code = c2.cl_code
 and s.party_code = c2.party_code
 and c1.short_name like ltrim(@name)+'%'
 and s.sett_no = @settno
 and s.sett_type = @settype
 and s.scrip_cd like ltrim(@scripcd)+'%'
 and c1.trader like ltrim(@trader)+'%')>0 
   begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,
 Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
 from settlement s,client1 c1,client2 c2 , subbrokers sb
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like ltrim(@name)+'%' 
 and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no =@settno
 and s.sett_type =@settype and sb.sub_broker=c1.sub_broker
 and sb.sub_broker=@statusname
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
   end
   else
     begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from history s,client1 c1,client2 c2 , subbrokers sb
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like  ltrim(@name)+'%' 
 and c1.trader like  ltrim(@trader)+'%' and s.scrip_cd like  ltrim(@scripcd)+'%' 
 and s.sett_no like  ltrim(@settno)+'%' and s.sett_type like  ltrim(@settype)+'%' 
 and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy  
     end
end     
if (@statusid = 'branch' )
begin
   if (select count(*)from settlement s, client1 c1, client2 c2
 where s.party_code like ltrim(@code)+'%'
 and c1.cl_code = c2.cl_code
 and s.party_code = c2.party_code
 and c1.short_name like ltrim(@name)+'%'
 and s.sett_no = @settno
 and s.sett_type = @settype
 and s.scrip_cd like ltrim(@scripcd)+'%'
 and c1.trader like ltrim(@trader)+'%')>0 
   begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,
 Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
 from settlement s,client1 c1,client2 c2 , branches b
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like ltrim(@name)+'%' 
 and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no =@settno
 and s.sett_type = @settype 
 and b.short_name=c1.trader and b.branch_cd like @statusname
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
   end
   else
     begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from history s,client1 c1,client2 c2,branches b 
 where s.party_code = c2.party_code 
 and c1.cl_code = c2.cl_code and b.short_name = c1.trader 
 and b.branch_cd = @statusname and s.party_code like ltrim(@code)+'%' 
 and c1.short_name like ltrim(@name)+'%' and c1.trader like ltrim(@trader)+'%' 
 and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no= @settno
 and s.sett_type = @settype
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
     end
end     
if (@statusid = 'client' )
begin
   if (select count(*)from settlement s, client1 c1, client2 c2
 where s.party_code like ltrim(@code)+'%'
 and c1.cl_code = c2.cl_code
 and s.party_code = c2.party_code
 and c1.short_name like ltrim(@name)+'%'
 and s.sett_no = @settno
 and s.sett_type = @settype
 and s.scrip_cd like ltrim(@scripcd)+'%'
 and c1.trader like ltrim(@trader)+'%')>0 
   begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,
 Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
 from settlement s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code = @statusname
 and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no =@settno
 and s.sett_type = @settype
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy  
   end
   else
     begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from history s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code =@statusname
 and s.scrip_cd like  ltrim(@scripcd)+'%' and s.sett_no =@settno
 and s.sett_type =@settype
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
     end
end     
if (@statusid = 'trader' )
begin
   if (select count(*)from settlement s, client1 c1, client2 c2
 where s.party_code like ltrim(@code)+'%'
 and c1.cl_code = c2.cl_code
 and s.party_code = c2.party_code
 and c1.short_name like ltrim(@name)+'%'
 and s.sett_no = @settno
 and s.sett_type = @settype
 and s.scrip_cd like ltrim(@scripcd)+'%'
 and c1.trader like ltrim(@trader)+'%')>0 
   begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,
 Quantity = sum(s.tradeqty),Amount = sum(s.amount),s.sell_buy 
 from settlement s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like ltrim(@name)+'%' 
 and s.scrip_cd like ltrim(@scripcd)+'%' and s.sett_no =@settno
 and s.sett_type =@settype and c1.trader=@statusname
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy  
   end
   else
     begin
 select s.party_code,c1.short_name,s.scrip_cd,s.series,Quantity = sum(s.tradeqty),
 Amount = sum(s.amount),s.sell_buy,s.sett_no,s.sett_type 
 from history s,client1 c1,client2 c2 
 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
 and s.party_code like ltrim(@code)+'%' and c1.short_name like  ltrim(@name)+'%'
 and c1.trader = @statusname and s.scrip_cd like  ltrim(@scripcd)+'%' 
 and s.sett_no =@settno and s.sett_type =@settype
 group by s.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
 order by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy 
     end
end

GO
