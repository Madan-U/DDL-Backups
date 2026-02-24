-- Object: PROCEDURE dbo.Angel_TrdCalcBrokTax
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Proc Angel_TrdCalcBrokTax  
(@PartyCode varchar(15), @qty int,@buyrate decimal,@sellrate decimal)  
as  

  
declare @FirstLeg decimal  
declare @SecondLeg decimal  
/*
declare @PartyCode varchar(15)
declare @qty int
declare @buyrate decimal
declare @sellrate decimal
  
set @qty = 1000  
set @buyrate = 1050  
set @sellrate = 1098  
set @PartyCode = 'ZA41'

*/

select cl_code,y.table_no,y.val_perc,y.day_puc,y.trd_del,y.lower_lim,y.upper_lim,'TRD' as type  
into #brokInfo  from Msajag.dbo.client2 x (nolock), Msajag.dbo.broktable y (nolock)  
where x.table_no = y.table_no and x.cl_code = @PartyCode  
union  
select cl_code,y.table_no,y.val_perc,y.normal,y.trd_del,y.lower_lim,y.upper_lim,'DEL' as Del   
from Msajag.dbo.client2 x (nolock),   
Msajag.dbo.broktable y (nolock)  
where x.sub_tableno = y.table_no and x.cl_code = @PartyCode  

set @FirstLeg = case when @buyrate > @sellrate then @buyrate else @sellrate end  
--print @FirstLeg  
  
set @SecondLeg = case when @buyrate < @sellrate then @buyrate else @sellrate end  
--print @SecondLeg  
  
declare @firstBrok money, @secondBrok money  
  
set @firstBrok = (select   
case   
when val_perc = 'P' then ((@FirstLeg*day_puc)/100)*@qty  
when val_perc = 'V' then @qty*day_puc end  
 from #brokInfo where type = 'TRD' and Trd_del = 'F' and  @FirstLeg > lower_lim  
and  @FirstLeg < upper_lim )   

--print @firstBrok 
 
set @secondBrok = (select case   
when val_perc = 'P' then ((@SecondLeg*day_puc)/100)*@qty  
when val_perc = 'V' then @qty*day_puc end  
from #brokInfo where type = 'TRD' and Trd_del = 'S' and  @SecondLeg > lower_lim  
and  @SecondLeg < upper_lim)  

--print @secondBrok

select   
BuyBrok =case when  @buyrate > @sellrate  then @firstBrok else @secondBrok  end,  
SellBrok =case when @sellrate > @buyrate then @firstBrok else @secondBrok end,  
TurnoverTax=(((@qty*@sellrate)+(@qty*@buyrate))*Turnover_tax)/100,  
Service_tax=(((((@qty*@sellrate)+(@qty*@buyrate))*Turnover_tax)/100+(@firstBrok+@secondBrok))*10.3)/100,  
STT=((@qty*@sellrate)*insurance_chrg)/100,  
StampDuty= (((@qty*@sellrate)+(@qty*@buyrate))*Broker_note)/100,  
SebiTax=(((@qty*@sellrate)+(@qty*@buyrate))*Sebiturn_tax)/100  
from Msajag.dbo.taxes where Trans_Cat = 'TRD' and to_date > getdate()

GO
