-- Object: PROCEDURE dbo.brnewclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnewclients    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brnewclients    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brnewclients    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brnewclients    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brnewclients    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Management info
    File : newclients.asp
displays new clients 
*/
CREATE PROCEDURE brnewclients
@br varchar(3)
AS
select distinct t.party_code 
from trade4432 t, client1 c1, client2 c2, branches b
where t.party_code not in (select party_code from client2)
and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br

GO
