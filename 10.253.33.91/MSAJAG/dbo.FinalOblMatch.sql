-- Object: PROCEDURE dbo.FinalOblMatch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc FinalOblMatch (@sett_no varchar(7),@sett_type varchar(2)) as
delete from TempFinalObl 
insert into TempFinalObl 
select * from finalsumScrip where sett_no = @sett_no and sett_type = @sett_type 
/*
union all
select * from oppalbmScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from PlusOneAlbmScrip where sett_no =( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = @sett_type )
and sett_type = @sett_type 
update TempFinalObl set sett_no = @Sett_no,sett_Type = @sett_type
*/

GO
