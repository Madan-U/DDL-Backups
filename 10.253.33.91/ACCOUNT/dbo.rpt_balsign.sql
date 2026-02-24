-- Object: PROCEDURE dbo.rpt_balsign
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_balsign    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_balsign    Script Date: 11/28/2001 12:23:46 PM ******/



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
