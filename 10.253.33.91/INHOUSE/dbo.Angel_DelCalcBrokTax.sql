-- Object: PROCEDURE dbo.Angel_DelCalcBrokTax
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Proc Angel_DelCalcBrokTax  
(@PartyCode varchar(15), @qty int,@rate decimal)  
as  
  
declare @DelBrok decimal  
  
--set @qty = 1000  
--set @buyrate = 105  
--set @sellrate = 98  
  
select cl_code,y.table_no,y.val_perc,y.normal,y.trd_del,y.lower_lim,y.upper_lim,'DEL' as type   
into #brokInfo  
from Msajag.dbo.client2 x (nolock),   
Msajag.dbo.broktable y (nolock)  
where x.sub_tableno = y.table_no and x.cl_code =  @PartyCode  
  
set @DelBrok = (select   
case   
when val_perc = 'P' then ((@rate*normal)/100)*@qty  
when val_perc = 'V' then @qty*normal end  
from #brokInfo where  @rate > lower_lim  
and  @rate < upper_lim )   
  
select   
DelBrok = convert(dec(10,4),@DelBrok),  
TurnoverTax= convert(dec(10,4),((@qty*@rate)*Turnover_tax)/100),  
Service_tax= convert(dec(10,4),(((((@qty*@rate))*Turnover_tax)/100+(@DelBrok))*10.3)/100),  
STT=  convert(dec(10,2),round(((@qty*@rate)*insurance_chrg)/100,0)),  
StampDuty= convert(dec(10,4),(((@qty*@rate))*Broker_note)/100),  
SebiTax= convert(dec(10,4),(((@qty*@rate))*Sebiturn_tax)/100) into #fin  
from Msajag.dbo.taxes where Trans_Cat = 'DEL' and to_date > getdate()
  
select *,Total=DelBrok+TurnoverTax+Service_tax+STT+StampDuty+SebiTax from #fin

GO
