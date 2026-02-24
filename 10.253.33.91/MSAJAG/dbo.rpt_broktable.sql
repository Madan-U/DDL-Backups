-- Object: PROCEDURE dbo.rpt_broktable
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure rpt_broktable

@valperc as varchar(20),
@val1 as varchar(20),
@trddel as int
as


if @val1 = '%'

begin


if @trddel = 0 

begin
select table_no,line_no,Table_name,Upper_lim,val_perc,Day_puc,Day_Sales,Sett_Purch,sett_sales,NORMAL,round_to,
Trd_del = (case when trd_del = 'T' then 'Trading' 
		when trd_del = 'D' then 'Delivery'
		when trd_del = 'F' then 'First Leg'
		when trd_del = 'S' then 'Second Leg'
	   end)
from broktable
where table_no in (select distinct table_no from broktable where trd_del in ('T','S','F','D') and val_perc like @valperc)		
order by table_no,line_no,upper_lim
end


if @trddel = 1

begin
select table_no,line_no,Table_name,Upper_lim,val_perc,Day_puc,Day_Sales,Sett_Purch,sett_sales,NORMAL,round_to,
Trd_del = (case when trd_del = 'T' then 'Trading' 
		when trd_del = 'D' then 'Delivery'
		when trd_del = 'F' then 'First Leg'
		when trd_del = 'S' then 'Second Leg'
	   end)
from broktable
where  table_no in (select distinct table_no from broktable where trd_del in ('T','S','F') and val_perc like @valperc)		
order by table_no,line_no,upper_lim
end
if @trddel = 2

begin
select table_no,line_no,Table_name,Upper_lim,val_perc,Day_puc,Day_Sales,Sett_Purch,sett_sales,NORMAL,round_to,
Trd_del = (case when trd_del = 'T' then 'Trading' 
		when trd_del = 'D' then 'Delivery'
		when trd_del = 'F' then 'First Leg'
		when trd_del = 'S' then 'Second Leg'
	   end)
from broktable
where table_no in (select distinct table_no from broktable where trd_del in ('D') and val_perc like @valperc)		
order by table_no,line_no,upper_lim
end

end



if @val1 <> '%'

begin


if @trddel = 0 

begin
select table_no,line_no,Table_name,Upper_lim,val_perc,Day_puc,Day_Sales,Sett_Purch,sett_sales,NORMAL,round_to,
Trd_del = (case when trd_del = 'T' then 'Trading' 
		when trd_del = 'D' then 'Delivery'
		when trd_del = 'F' then 'First Leg'
		when trd_del = 'S' then 'Second Leg'
	   end)
from broktable
where table_no in (select distinct table_no from broktable where
(day_puc = cast(@val1 as numeric(18,6)) or day_sales = cast(@val1 as numeric(18,6)) or sett_purch = cast(@val1 as numeric(18,6)) or sett_sales = cast(@val1 as numeric(18,6)) or normal = cast(@val1 as numeric(18,6)))
and trd_del in ('T','S','F','D') and val_perc like @valperc)		
order by table_no,line_no,upper_lim
end


if @trddel = 1

begin
select table_no,line_no,Table_name,Upper_lim,val_perc,Day_puc,Day_Sales,Sett_Purch,sett_sales,NORMAL,round_to,
Trd_del = (case when trd_del = 'T' then 'Trading' 
		when trd_del = 'D' then 'Delivery'
		when trd_del = 'F' then 'First Leg'
		when trd_del = 'S' then 'Second Leg'
	   end)
from broktable
where table_no in (select distinct table_no from broktable where
 (day_puc = cast(@val1 as numeric(18,6)) or day_sales = cast(@val1 as numeric(18,6)) or sett_purch = cast(@val1 as numeric(18,6)) or sett_sales = cast(@val1 as numeric(18,6)) or normal = cast(@val1 as numeric(18,6)))
and trd_del in ('T','S','F') and val_perc like @valperc)			
order by table_no,line_no,upper_lim
end
if @trddel = 2

begin
select table_no,line_no,Table_name,Upper_lim,val_perc,Day_puc,Day_Sales,Sett_Purch,sett_sales,NORMAL,round_to,
Trd_del = (case when trd_del = 'T' then 'Trading' 
		when trd_del = 'D' then 'Delivery'
		when trd_del = 'F' then 'First Leg'
		when trd_del = 'S' then 'Second Leg'
	   end)
from broktable
where  table_no in (select distinct table_no from broktable where
 (day_puc = cast(@val1 as numeric(18,6)) or day_sales = cast(@val1 as numeric(18,6)) or sett_purch = cast(@val1 as numeric(18,6)) or sett_sales = cast(@val1 as numeric(18,6)) or normal = cast(@val1 as numeric(18,6)))
and trd_del in ('D') and val_perc like @valperc)		
order by table_no,line_no,upper_lim
end

end

GO
