-- Object: PROCEDURE dbo.selsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.selsettno    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.selsettno    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.selsettno    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.selsettno    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.selsettno    Script Date: 12/27/00 8:59:16 PM ******/

CREATE proc selsettno  as
declare @@counter int,
	@@Sett_no varchar(7),
	@@Sett Cursor,
	@@Series Cursor,
	@@Ser varchar(2),
	@@SetLoop Varchar(7),
	@@Loop Cursor
delete from albmsauda
select @@Counter = 1

set @@Loop = cursor for
select distinct sett_no from settlement where sett_type = 'P'
union all 
select distinct sett_no from history where sett_type = 'P'
open @@Loop
fetch next from @@Loop into @@setloop
while @@fetch_status = 0 
begin
set @@series = cursor for 
select distinct series from settlement where sett_no = @@setloop and sett_type = 'P'
union all 
select distinct series from history where sett_no = @@setloop and sett_type = 'P'
open @@Series 
fetch next from @@series into @@ser
while @@fetch_status= 0 
begin 
if convert(int,@@ser) > 1 
begin
select @@Counter = 1
Select @@Sett_no = @@setloop
while @@Counter < convert(int,@@Ser) 
begin
	set @@sett = cursor for 
	select min(Sett_no) from sett_mst where sett_no > @@Sett_no and sett_type = 'W' and start_date > ( select start_date from sett_mst where sett_no = @@sett_no and sett_Type = 'W' )
	open @@Sett
	fetch next from @@Sett into @@Sett_No
	close @@Sett
	Select @@Counter = @@Counter + 1
end
deallocate @@Sett
end
insert into albmsauda  
select party_code,sell_buy,s.scrip_cd,s.series /* = ( Case when s.sett_Type = 'P' then 'BE' else s.series end )*/,tradeqty,marketrate,netrate,brokapplied,nsertax,nbrokapp,a.rate,
Sett_no = @@Sett_no ,
s.sett_type,billno,user_id from settlement s,albmrate a where
s.scrip_cd  = a.scrip_cd
and s.series = a.series and s.series = @@ser
and a.sett_no = s.sett_no
and tradeqty > 0 and s.sett_type = 'P'
and s.sett_type = a.sett_Type
and s.sett_no = @@sett_no
union all
select party_code,sell_buy,s.scrip_cd,s.series /* = ( Case when s.sett_Type = 'P' then 'BE' else s.series end )*/ ,tradeqty,marketrate,netrate,brokapplied,nsertax,nbrokapp,a.rate,
Sett_no =  @@Sett_no,s.sett_type,billno,user_id
from history s,albmrate a where
s.scrip_cd  = a.scrip_cd
and s.series = a.series and s.series = @@ser
and a.sett_no = s.sett_no
and tradeqty > 0 and s.sett_type = 'P'
and s.sett_type = a.sett_Type
and s.sett_no = @@setloop
fetch next from @@series into @@ser
end
select @@setloop
fetch next from @@loop into @@setloop
end

GO
