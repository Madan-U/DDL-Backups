-- Object: PROCEDURE dbo.sub_rpt_ppartycodes
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_ppartycodes    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_ppartycodes    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_ppartycodes    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_ppartycodes    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_ppartycodes    Script Date: 12/27/00 8:59:16 PM ******/




CREATE PROCEDURE sub_rpt_ppartycodes

@settno varchar(7),
@settype varchar(3),
@membercode varchar(10),
@partyname varchar(25)
AS
select distinct h.party_code, m.name  from trdbackup h ,  multibroker m
where sett_no=@settno and sett_type='p' and
m.cltcode=h.partipantcode
and m.name like ltrim(@partyname)+'%'
and h.partipantcode like ltrim(@membercode)+'%'
and h.partipantcode not in(
select distinct partipantcode from trdbackup  where sett_no=@settno and sett_type='w')

GO
