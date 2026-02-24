-- Object: PROCEDURE dbo.rpt_balsign
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_balsign    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_balsign    Script Date: 01/04/1980 5:06:26 AM ******/




/* report : allpartyledger
     file :  ledgerview.asp
*/
/*
selects scheme of showing balances from owner table
*/

CREATE PROCEDURE  rpt_balsign

@conpath varchar(50)

AS

select distinct balsign from account.dbo.owner
where conpath=@conpath

GO
