-- Object: PROCEDURE dbo.rpt_insertmtomdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_insertmtomdetail    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insertmtomdetail    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insertmtomdetail    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insertmtomdetail    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_insertmtomdetail    Script Date: 12/27/00 8:59:12 PM ******/

/* report : newmtom
   file :mtomtablefill.asp
*/
/* insert mtom details into tblmtomdetail */
CREATE PROCEDURE rpt_insertmtomdetail
@partycode varchar(10),
@partyname varchar(30),
@finnet varchar(12),
@finclos varchar(12),
@findiff varchar(12),
@grossamt varchar(12),
@ledamt varchar(12),
@turnoveramt varchar(12)
AS
insert into tblmtomdetail values (@partycode,@partyname,convert(money,@finnet),convert(money,@finclos),convert(money,@findiff),convert(money,@grossamt)
,convert(money,@ledamt),convert(money,@turnoveramt))

GO
