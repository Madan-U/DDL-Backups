-- Object: PROCEDURE dbo.brclsdiff
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brclsdiff    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brclsdiff    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brclsdiff    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brclsdiff    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brclsdiff    Script Date: 12/27/00 8:59:06 PM ******/

/*  Report : mtom
     File : diff10000.asp
*/
CREATE PROCEDURE brclsdiff
@br varchar(3)
AS
select m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim,m.LedgerAmt 
from tblmtomdetail m,client2 c2,client1 c1,branches b 
where m.party_code=c2.party_code 
and c2.cl_code =c1.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and m.clsdiff <= -10000 
order by m.clsdiff

GO
