-- Object: PROCEDURE dbo.nsetrade4432altercol
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.nsetrade4432altercol    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.nsetrade4432altercol    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.nsetrade4432altercol    Script Date: 20-Mar-01 11:38:52 PM ******/

create proc nsetrade4432altercol as
/*This sql script changes the size of participantcode in trade4432 for nsecm*/
/*since the institutional client code is of size 11 but previously the partipant code */
/* use to hold only 5 char now it will hold 15 char long*/
/*Run this script in MSAJAG DB*/
/*Created by ranjeet choudhary for nseCM trade4432 */
/*Date 6 March 2001*/
alter table trade4432
alter column PartipantCode char(15)

GO
