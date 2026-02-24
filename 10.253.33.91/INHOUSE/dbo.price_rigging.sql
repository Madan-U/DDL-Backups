-- Object: PROCEDURE dbo.price_rigging
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure price_rigging(@pcode as varchar(11),@scode as varchar(10),@settno as varchar(11))        
as        
------196---anand1(NSE)        
declare @Order_No varchar(50),@cnt int       
set @cnt=1      
select marketrate as Rate,case when Sell_Buy ='1' then 'Buy' else 'Sell' end as [Sell/Buy],TradeQty,      
Order_No as [Order No],Trade_No as [Trade No],right(sauda_date,7) as Time,flag=space(2) into #file       
from msajag.dbo.history where partY_code=@pcode  and scrip_cd=@scode        
and sett_type='N' and sett_no=@settno order by order_no        
insert into #file      
select  marketrate as Rate,case when Sell_Buy ='1' then 'Buy' else 'Sell' end as [Sell/Buy],TradeQty,      
Order_No  as [Order No],Trade_No as [Trade No],right(sauda_date,7) as Time,flag=space(2) from msajag.dbo.settlement       
where partY_code=@pcode  and scrip_cd=@scode        
and sett_type='N' and sett_no=@settno order by order_no        
declare @val int,@abc varchar(20)      
set @val=1      
DECLARE error_cursor CURSOR FOR                                       
select [Order No] from #file order by  [Order No]      
      
OPEN error_cursor                                      
FETCH NEXT FROM error_cursor                                       
INTO @Order_No                      
WHILE @@FETCH_STATUS = 0                                      
BEGIN                          
if @val=1      
      begin       
      update #file set flag=@cnt where [Order No]=@Order_No      
      set @val=@val+1      
      set @abc=@Order_No      
      end      
else      
    begin      
 if (@abc<>@Order_No)                             
    begin      
----      
   if (@abc<>@Order_No and @cnt=4 )                             
     begin      
      set @abc=@Order_No      
      set @cnt=0      
      --update #file set flag=@cnt where [Order No]=@Order_No      
      end      
----      
     set @abc=@Order_No      
     set @cnt=@cnt+1      
      update #file set flag=@cnt where [Order No]=@Order_No      
   end      
else      
   begin      
   update #file set flag=@cnt where [Order No]=@Order_No      
------      
--if (@abc<>@Order_No and @cnt=4 )                             
--begin      
--      
--set @abc=@Order_No      
--set @cnt=1      
--update #file set flag=@cnt where [Order No]=@Order_No      
--end      
------      
end      
end      
--if ((@abc<>@Order_No)  and @cnt=4 )      
--if @cnt=4       
--      
--    set @cnt=0      
  FETCH NEXT FROM error_cursor                                       
  INTO @Order_No                   
END         
      
CLOSE error_cursor                                      
DEALLOCATE error_cursor                                      
      
select * from #file order by  [Order No]

GO
