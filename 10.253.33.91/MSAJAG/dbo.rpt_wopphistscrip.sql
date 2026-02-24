-- Object: PROCEDURE dbo.rpt_wopphistscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_wopphistscrip    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_wopphistscrip    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_wopphistscrip    Script Date: 20-Mar-01 11:39:04 PM ******/



/* report : partywise turnover
   file : partywiseturn.asp
   finds oppsite saudas whom effect should be given in  current p settlement for a party and for a scrip
*/
CREATE PROCEDURE rpt_wopphistscrip

@partycode varchar(10),
@wsettno varchar(7),
@scripcd varchar(12)


AS

select * from albmhist where
party_code=@partycode  and sett_no=@wsettno
and ser <> '01'  and scrip_cd=ltrim(@scripcd)

GO
