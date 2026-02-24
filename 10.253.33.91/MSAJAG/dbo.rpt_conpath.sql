-- Object: PROCEDURE dbo.rpt_conpath
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_conpath    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_conpath    Script Date: 01/04/1980 5:06:26 AM ******/



/*report :  allparty ledger 
    file : allparty.asp
    file : ledgerview.asp
*/

/* selects conpath from owner for a exchange and segment */

CREATE PROCEDURE rpt_conpath

@exch varchar(3),
@segment varchar(20)

AS

select conpath from account.dbo.owner where exchange=@exch and segment like ltrim(@segment)+'%'

GO
