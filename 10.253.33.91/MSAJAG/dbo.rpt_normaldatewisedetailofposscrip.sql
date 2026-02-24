-- Object: PROCEDURE dbo.rpt_normaldatewisedetailofposscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_normaldatewisedetailofposscrip    Script Date: 04/27/2001 4:32:47 PM ******/
CREATE  PROCEDURE rpt_normaldatewisedetailofposscrip 
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripcd varchar(12),
@series varchar(3),
@sdate varchar(12)

as

select  * from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate

GO
