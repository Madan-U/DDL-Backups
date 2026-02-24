-- Object: PROCEDURE dbo.SubFinRecFile
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SubFinRecFile    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFile    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFile    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFile    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFile    Script Date: 12/27/00 8:59:17 PM ******/
CREATE proc SubFinRecFile (@sett_no varchar(7),@sett_type varchar(2)) as
delete from SubFinRec
insert into SubFinRec
select * from SubDelInsNormal where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from SubDelInsOppAlbm where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from SubDelInsPlusAlbm where sett_no =  ( select Min(Sett_no) from Sett_mst where Sett_no > @sett_no and sett_type = @sett_type  ) and sett_type = @sett_type 
order by party_code

update SubFinRec set sett_no = @sett_no,sett_type = @sett_type

GO
