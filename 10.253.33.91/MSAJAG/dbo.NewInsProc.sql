-- Object: PROCEDURE dbo.NewInsProc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.NewInsProc    Script Date: 3/17/01 9:55:53 PM ******/

CREATE proc NewInsProc (@sett_no varchar(7),@sett_type varchar(2)) as
delete from DelPos 
insert into DelPos
select * from NewDelInsNormal where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from NewDelInsOppAlbm where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from NewDelInsPlusAlbm where sett_no =  ( select Min(Sett_no) from Sett_mst where Sett_no > @sett_no and sett_type = @sett_type  ) and sett_type = @sett_type 
order by party_code
update DelPos set sett_no = @sett_no,sett_type = @sett_type

GO
