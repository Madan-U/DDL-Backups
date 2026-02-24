-- Object: PROCEDURE dbo.rpt_foclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 4/30/01 5:50:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclientlist    Script Date: 12/27/00 8:59:09 PM ******/
/* Report : Fo ContractWiseDetail Report
   File : clientlist.asp
 displays the list of clients
*/
CREATE PROCEDURE rpt_foclientlist
AS
select distinct t.party_code, c1.short_name 
from fotrade t , client1 c1, client2 c2 
where c1.cl_code = c2.cl_code 
and c2.party_code = t.party_code
order by t.party_code

GO
