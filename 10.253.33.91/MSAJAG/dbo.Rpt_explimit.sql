-- Object: PROCEDURE dbo.Rpt_explimit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_explimit    Script Date: 04/27/2001 4:32:38 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_explimit    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_explimit    Script Date: 20-Mar-01 11:38:55 PM ******/

/*
Written by neelambari on 13 feb 2001
report : Nse > ExposureLimit
*/

CREATE PROCEDURE Rpt_explimit
@partycode varchar(7),
@Partyname varchar(21)
AS
select c3.party_code,c3.exchange,c3.markettype ,
c3.margin, c3.nooftimes,c3.pmarginrate ,c1.short_name
from client3 c3 ,client1 c1 where c3.party_code like @partycode+'%' and 
c1.cl_code=c3.cl_code and c1.Short_name like @partyname+'%'

GO
