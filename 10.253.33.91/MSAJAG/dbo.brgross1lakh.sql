-- Object: PROCEDURE dbo.brgross1lakh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brgross1lakh    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brgross1lakh    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brgross1lakh    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brgross1lakh    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brgross1lakh    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : mtom
   file : gross1lakhs.asp
*/
CREATE PROCEDURE brgross1lakh
@br varchar(3)
AS
select distinct t.party_code,t.short_name,clsdiff,grossamt 
from tblmtomdetail t,client1 c1, client2 c2, branches b 
where grossamt > 100000
and c1.cl_code = c2.cl_code
and b.short_name = c1.trader
and b.branch_cd = @br
and t.party_code=c2.party_code
order by grossamt desc

GO
