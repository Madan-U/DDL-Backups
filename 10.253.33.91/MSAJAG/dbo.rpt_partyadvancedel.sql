-- Object: PROCEDURE dbo.rpt_partyadvancedel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_partyadvancedel    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyadvancedel    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_partyadvancedel    Script Date: 20-Mar-01 11:39:02 PM ******/
/* report : nseposition
    file : nsedelclientscrips.asp 
*/
CREATE PROCEDURE rpt_partyadvancedel

@partycode varchar(10),
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12),
@series varchar(3)

aS

select qty=sum(qty) from certinfo c where c.party_code=@partycode and c.sett_no=@settno
and c.sett_type=@settype and c.scrip_cd=@scripcd and c.series=@series and targetparty=1
group by c.sett_no,c.sett_type,c.series,c.scrip_cd

GO
