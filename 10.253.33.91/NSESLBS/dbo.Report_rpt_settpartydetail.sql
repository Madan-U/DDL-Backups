-- Object: PROCEDURE dbo.Report_rpt_settpartydetail
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE procedure Report_rpt_settpartydetail
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
