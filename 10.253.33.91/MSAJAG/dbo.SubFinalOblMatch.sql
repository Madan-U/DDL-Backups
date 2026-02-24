-- Object: PROCEDURE dbo.SubFinalOblMatch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SubFinalOblMatch    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOblMatch    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOblMatch    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOblMatch    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOblMatch    Script Date: 12/27/00 8:59:16 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOblMatch    Script Date: 11/24/2000 4:05:15 PM ******/
CREATE proc SubFinalOblMatch (@sett_no varchar(7),@sett_type varchar(2),@Party_Code Varchar(10),@UserId varchar(8)) as
delete from subTempFinalObl 
insert into subTempFinalObl 
select * from subtempsettsumScrip where sett_no = @sett_no and sett_type = @sett_type  and party_code like @Party_Code + '%' and user_id like @Userid +'%'
and sett_type = @sett_type
union all
select * from suboppalbmScrip where sett_no = @sett_no and sett_type = @sett_type and party_code like @Party_Code + '%' and user_id like @Userid +'%' 
and sett_type = @sett_type
union all
select * from subPlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = @sett_type)
and sett_type = @sett_type and party_code like @Party_Code + '%' and user_id like @Userid +'%'
update subTempFinalObl set sett_no = @Sett_no,sett_Type = @sett_type

GO
