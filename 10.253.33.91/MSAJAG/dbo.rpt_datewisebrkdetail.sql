-- Object: PROCEDURE dbo.rpt_datewisebrkdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datewisebrkdetail    Script Date: 04/27/2001 4:32:38 PM ******/
CREATE PROCEDURE rpt_datewisebrkdetail

@partycode varchar(10),
@partyname varchar(21),
@settno varchar(10),
@settype varchar(3),
@trader varchar(15),
@scrip varchar(15),
@fdate varchar(12),
@tdate varchar(12)

AS

		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , left(convert(varchar,sauda_date,109),11) as sauda_date, 
		series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and sett_no like ltrim(@settno)+'%'
		and sett_type like  ltrim(@settype)+'%'
		and short_name like  ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scrip)+'%'

GO
