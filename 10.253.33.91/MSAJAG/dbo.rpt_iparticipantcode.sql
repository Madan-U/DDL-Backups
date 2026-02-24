-- Object: PROCEDURE dbo.rpt_iparticipantcode
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_iparticipantcode    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iparticipantcode    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iparticipantcode    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iparticipantcode    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iparticipantcode    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/*
displays list of partycipants code from isettlement table
*/
CREATE PROCEDURE 
rpt_iparticipantcode
@usertype varchar(3)
 AS 
select distinct partipantcode from isettlement
where sett_type  = @usertype
union
select distinct partipantcode from ihistory
where sett_type  = @usertype

GO
