-- Object: PROCEDURE dbo.rpt_detailofposscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_detailofposscrip    Script Date: 04/27/2001 4:32:38 PM ******/

/* 
 finds details of a party and scrip for a settlement number and type including albm 
*/
CREATE PROCEDURE  rpt_detailofposscrip

@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12),
@partycode varchar(10),
@series varchar(3),
@sdate varchar(12)
AS


select  *
 from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd and series=@series
and left(convert(varchar,sauda_date,109),11) =@sdate  
union all
select *
  from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and left(convert(varchar,sauda_date,109),11) =@sdate 
union all
select *
  from detailPlusOneAlbmExp 
where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and left(convert(varchar,sauda_date,109),11) =@sdate

GO
