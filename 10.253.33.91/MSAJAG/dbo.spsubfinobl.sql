-- Object: PROCEDURE dbo.spsubfinobl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.spsubfinobl    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.spsubfinobl    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.spsubfinobl    Script Date: 20-Mar-01 11:39:10 PM ******/

CREATE procedure spsubfinobl 
@sett_no varchar(7),
@sett_type varchar(3)
as
select * from FinalsumScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from oppalbmScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from PlusOneAlbmScrip where sett_no =( select min(Sett_no) from sett_mst where sett_no > @sett_no and  sett_type = @sett_type )
and sett_type = @sett_type 
order by scrip_Cd

GO
