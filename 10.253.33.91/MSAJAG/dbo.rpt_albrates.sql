-- Object: PROCEDURE dbo.rpt_albrates
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albrates    Script Date: 04/27/2001 4:32:33 PM ******/


/****** Object:  Stored Procedure dbo.rpt_albrates    Script Date: 04/21/2001 6:05:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albrates    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albrates    Script Date: 20-Mar-01 11:38:53 PM ******/







/* report : billreport
 file : billreport.asp
 shows albrates for a particular settlement's scrip 
*/   
CREATE PROCEDURE rpt_albrates
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(15)
AS
select rate from albmrate 
where sett_no=@settno
and sett_type=@settype
and scrip_Cd=@scripcd

GO
