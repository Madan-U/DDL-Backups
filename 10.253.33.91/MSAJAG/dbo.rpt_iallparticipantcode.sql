-- Object: PROCEDURE dbo.rpt_iallparticipantcode
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_iallparticipantcode    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iallparticipantcode    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iallparticipantcode    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iallparticipantcode    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iallparticipantcode    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/*
displays list of partycipants code from isettlement table
*/
CREATE PROCEDURE 
rpt_iallparticipantcode
 AS 
select distinct partipantcode from isettlement
union
select distinct partipantcode from ihistory

GO
