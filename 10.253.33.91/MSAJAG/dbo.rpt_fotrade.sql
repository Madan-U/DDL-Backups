-- Object: PROCEDURE dbo.rpt_fotrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 4/30/01 5:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotrade    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fotrade
@tdate varchar(12)
AS
select distinct t.party_code,c1.short_name 
from foTrade t, client1 c1,client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and
convert(varchar,t.activitytime,103)like ltrim(@tdate)+'%' 
order by c1.short_name,t.party_code

GO
