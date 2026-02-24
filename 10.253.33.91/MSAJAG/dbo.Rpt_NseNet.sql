-- Object: PROCEDURE dbo.Rpt_NseNet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 05/08/2002 12:35:16 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 01/14/2002 20:33:08 ******/






/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 09/07/2001 11:09:21 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 7/1/01 2:26:46 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 06/26/2001 8:49:11 PM ******/


/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 20-Mar-01 11:39:02 PM ******/

/* changed by animesh on 25/02/2001 
    added sett type parameter to select * from oppalbmscrip and also to select * from plusonealbmscrip */
/*
Changed by neelambari on  3 mar 2001
first part of query is using view tempsettsumscrip
Modification done to use finalsumscrip instead of tempsettsumscrip
*/
    
CREATE proc Rpt_NseNet (@sett_no varchar(7),@sett_type varchar(2)) as
/*
select * from tempsettsumScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from oppalbmScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from PlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = 'L' ) and sett_type = @sett_type 
order by Scrip_Cd,Series
*/



select * from finalsumScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from oppalbmScrip where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from PlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = 'L' ) and sett_type = @sett_type 
order by Scrip_Cd,Series

GO
