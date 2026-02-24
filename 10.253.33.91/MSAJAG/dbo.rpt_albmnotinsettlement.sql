-- Object: PROCEDURE dbo.rpt_albmnotinsettlement
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmnotinsettlement    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmnotinsettlement    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmnotinsettlement    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmnotinsettlement    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmnotinsettlement    Script Date: 12/27/00 8:58:53 PM ******/

/* report : misnews 
   file : topclient_scripsett.asp
*/
/* selects those clients whose trades are in albm but not in current settlement */
CREATE PROCEDURE rpt_albmnotinsettlement
@settno varchar(7)
AS
select distinct party_code from settlement where sett_type='l' and
sett_no=@settno and party_code not in (select distinct party_code from settlement where
(sett_type='w' or sett_type='m' or sett_type='n') and billno=0)
order by party_code

GO
