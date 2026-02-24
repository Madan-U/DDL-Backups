-- Object: PROCEDURE dbo.rpt_partyname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_partyname    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyname    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyname    Script Date: 20-Mar-01 11:39:02 PM ******/







/* report:misnews
   file: detailgrossexp.asp
   finds name of a client code
*/

CREATE PROCEDURE rpt_partyname

@clcode varchar(6)

AS

select short_name from client1 where cl_code=@clcode

GO
