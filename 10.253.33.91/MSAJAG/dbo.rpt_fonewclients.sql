-- Object: PROCEDURE dbo.rpt_fonewclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fonewclients    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fonewclients
AS
select distinct t.party_code 
from fotrade4432 t,client1 c1,client2 c2 
where t.party_code not in (select party_code from client2) 
and c1.cl_code = c2.cl_code

GO
