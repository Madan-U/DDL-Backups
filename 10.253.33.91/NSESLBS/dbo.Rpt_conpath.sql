-- Object: PROCEDURE dbo.Rpt_conpath
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_conpath    Script Date: 01/15/2005 1:33:40 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_conpath    Script Date: 12/16/2003 2:31:48 Pm ******/



/****** Object:  Stored Procedure Dbo.rpt_conpath    Script Date: 05/08/2002 12:35:11 Pm ******/




/*report :  Allparty Ledger 
    File : Allparty.asp
    File : Ledgerview.asp
*/

/* Selects Conpath From Owner For A Exchange And Segment */

Create Procedure Rpt_conpath

@exch Varchar(3),
@segment Varchar(20)

As

Select Conpath From Account.dbo.owner Where Exchange=@exch And Segment Like Ltrim(@segment)+'%'

GO
