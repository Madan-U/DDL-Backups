-- Object: PROCEDURE dbo.brgross8
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brgross8    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brgross8    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brgross8    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brgross8    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brgross8    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : mtom
    File :  gross8.asp
*/
CREATE PROCEDURE brgross8
@br varchar(3)
AS
select m.party_code,m.short_name,m.clsdiff,m.grossamt 
from tblmtomdetail m,client2 c2,client1 c1,branches b  
where m.party_code=c2.party_code 
and c2.cl_code =c1.cl_code  
and b.short_name = c1.trader
and b.branch_cd = @br
and (m.grossamt > 8 * c2.exposure_lim) 
and c2.exposure_lim <> 0
order by m.grossamt desc

GO
