-- Object: PROCEDURE dbo.Rpt_NseNetall
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.Rpt_NseNetall    Script Date: 05/08/2002 12:35:16 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNetall    Script Date: 01/14/2002 20:33:08 ******/

/****** Object:  Stored Procedure dbo.Rpt_NseNetall    Script Date: 12/26/2001 1:23:38 PM ******/

/* nse datewise position */
 /* displays scripwise summary for all settlement number and type */


CREATE proc Rpt_NseNetall  (@sett_no varchar(7),@sett_type varchar(2)) as

select * from finalsumScripnsedatewise  where sett_no like ltrim(@sett_no)  and sett_type  like ltrim(@sett_type)
union all
select * from oppalbmScrip where sett_no  like ltrim(@sett_no) and sett_type like ltrim(@sett_type )
union all
select * from PlusOneAlbmScrip s where sett_no = ( select min(Sett_no) from sett_mst where sett_no > s.sett_no  and sett_type = 'L' ) 
and sett_type like ltrim(@sett_type) 
order by Scrip_Cd,Series

GO
