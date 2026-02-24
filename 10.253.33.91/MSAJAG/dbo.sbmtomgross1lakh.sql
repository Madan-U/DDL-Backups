-- Object: PROCEDURE dbo.sbmtomgross1lakh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomgross1lakh    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross1lakh    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross1lakh    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross1lakh    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross1lakh    Script Date: 12/27/00 8:59:15 PM ******/

/***  file :gross1lakhs.asp
     report: mtom    ***/
CREATE PROCEDURE  sbmtomgross1lakh
@subbroker varchar (15)
 AS
select distinct s.party_code,c1.short_name,clsdiff,grossamt 
from tblmtomdetail s,client1 c1,client2 c2 ,subbrokers sb
 where grossamt > 100000 and c1.cl_code=c2.cl_code  and s.party_code=c2.party_code
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
order by grossamt desc

GO
