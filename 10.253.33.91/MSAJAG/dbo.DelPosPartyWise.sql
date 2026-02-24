-- Object: PROCEDURE dbo.DelPosPartyWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DelPosPartyWise    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DelPosPartyWise    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DelPosPartyWise    Script Date: 20-Mar-01 11:38:49 PM ******/

CREATE procedure DelPosPartyWise  
@sett_no varchar(7),
@sett_type varchar(3),
@partycdfrom varchar(10),
@partycdto varchar(10),
@scripcdfrom varchar(10),
@scripcdto varchar(10)
as
select * from newtempsettsumScrip where sett_no = @sett_no and sett_type = @sett_type 
and party_code >=@partycdfrom and party_code < = @partycdto 
and scrip_cd >= @scripcdfrom and scrip_cd <=@scripcdto
union 
select * from newoppalbmScrip where sett_no = @sett_no and sett_type = @sett_type 
and party_code >=@partycdfrom and party_code < = @partycdto 
and scrip_cd >= @scripcdfrom and scrip_cd <=@scripcdto
union 
select * from newPlusOneAlbmScrip where sett_no =( select min(Sett_no) from sett_mst where sett_no > @sett_no and  sett_type = @sett_type )
and sett_type = @sett_type 
and party_code >=@partycdfrom and party_code < = @partycdto 
and scrip_cd >= @scripcdfrom and scrip_cd <=@scripcdto
order by party_code,scrip_cd

GO
