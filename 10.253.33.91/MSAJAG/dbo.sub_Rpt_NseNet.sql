-- Object: PROCEDURE dbo.sub_Rpt_NseNet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_Rpt_NseNet    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_Rpt_NseNet    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_Rpt_NseNet    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_Rpt_NseNet    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_Rpt_NseNet    Script Date: 12/27/00 8:59:18 PM ******/




CREATE proc sub_Rpt_NseNet (@sett_no varchar(7),@sett_type varchar(2),@membercode varchar(15)) as
select * from sub_tempsettsumScrip where sett_no = @sett_no and sett_type = @sett_type and partipantcode =@membercode
union all
select * from sub_oppalbmScrip where sett_no = @sett_no and sett_type = @sett_type and partipantcode =@membercode
union all
select * from sub_PlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = 'L' ) and sett_type = @sett_type 
and partipantcode =@membercode
order by Scrip_Cd,Series

GO
