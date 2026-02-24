-- Object: PROCEDURE dbo.rpt_conpath
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_conpath    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_conpath    Script Date: 11/28/2001 12:23:49 PM ******/



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
