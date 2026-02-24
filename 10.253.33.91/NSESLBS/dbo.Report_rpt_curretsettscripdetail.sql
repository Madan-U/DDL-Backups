-- Object: PROCEDURE dbo.Report_rpt_curretsettscripdetail
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_curretsettscripdetail    Script Date: 05/08/2002 12:35:12 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_curretsettscripdetail    Script Date: 01/14/2002 20:32:59 ******/  
  
/****** Object:  Stored Procedure dbo.rpt_curretsettscripdetail    Script Date: 12/26/2001 1:23:23 PM ******/  
  
  
/****** Object:  Stored Procedure dbo.rpt_curretsettscripdetail    Script Date: 04/27/2001 4:32:38 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_curretsettscripdetail    Script Date: 3/21/01 12:50:14 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_curretsettscripdetail    Script Date: 20-Mar-01 11:38:55 PM ******/  
  
/* report : netposition report   
*/  
    
CREATE PROCEDURE Report_rpt_curretsettscripdetail  
@settno varchar(7),  
@settype varchar(3),  
@scripcd varchar(12),  
@series varchar(3)  
  
  
 AS  
  
  
select * from rpt_currentsettsum where sett_no =@settno and sett_type = @settype and scrip_cd=@scripcd /* and series=@series*/  
union all  
select * from rpt_oppalbmScrip where sett_no = @settno and scrip_cd=@scripcd  and sett_type = @settype  
union all  
select * from rpt_PlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @settno   and sett_type = 'L' )  
and sett_type=@settype and scrip_cd=@scripcd  
order by party_code

GO
