-- Object: PROCEDURE dbo.rpt_settpartydetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settpartydetail    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settpartydetail    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settpartydetail    Script Date: 20-Mar-01 11:39:03 PM ******/
/*report netposition*/

CREATE procedure rpt_settpartydetail
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10)

as
select * from rpt_currentsettsum where sett_no =@settno and sett_type =@settype and party_code=@partycode  /* and series=@series*/
union all
select * from rpt_oppalbmScrip where sett_no =@settno and party_code=@partycode and sett_type =@settype
union all
select * from rpt_PlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @settno  and party_code=@partycode  and sett_type = 'L' )
and sett_type=@settype
order by scrip_cd,series

GO
