-- Object: PROCEDURE dbo.rpt_foconfirmlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 5/5/2001 1:24:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 4/30/01 5:50:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foconfirmlist    Script Date: 12/27/00 8:59:09 PM ******/
/** report :foconfirmation
file  : confirmationmain.asp  **/
CREATE PROCEDURE rpt_foconfirmlist
@partycode varchar(10),
@partyname varchar(21),
@sdate varchar(12)
AS
select distinct s.party_code  ,c1.short_name from fosettlement s,client1 c1 ,client2 c2
where c1.cl_code=c2.cl_code
and s.party_code=c2.party_code
and s.party_code like  @partycode+'%'
and c1.short_name like @partyname+'%'  
and convert(varchar,sauda_date,106) = @sdate

GO
