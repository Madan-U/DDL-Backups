-- Object: PROCEDURE dbo.Rpt_balsign
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_balsign    Script Date: 01/15/2005 1:27:31 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_balsign    Script Date: 12/16/2003 2:31:43 Pm ******/



/****** Object:  Stored Procedure Dbo.rpt_balsign    Script Date: 05/08/2002 12:35:07 Pm ******/




/* Report : Allpartyledger
     File :  Ledgerview.asp
*/
/*
Selects Scheme Of Showing Balances From Owner Table
*/

Create Procedure  Rpt_balsign

@conpath Varchar(50)

As

Select Distinct Balsign From Account.dbo.owner
Where Conpath=@conpath

GO
