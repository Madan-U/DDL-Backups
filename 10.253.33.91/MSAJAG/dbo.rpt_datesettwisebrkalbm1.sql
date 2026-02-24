-- Object: PROCEDURE dbo.rpt_datesettwisebrkalbm1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datesettwisebrkalbm1    Script Date: 04/27/2001 4:32:38 PM ******/

/*
this procedure gives us ther brokerage for all clients accoroing to i/o parameters for selected settlement
with albm effect for next settlement.
the reverse effect for 'l' type is not shown because brokerage for reverse type is not applied
*/

CREATE procedure  rpt_datesettwisebrkalbm1

@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@trader varchar(15),
@scrip varchar(20),
@fdate varchar(22),
@tdate varchar(22),
@flag int
as
if @statusid = 'broker' 
begin
	if @flag = 1
	begin
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and sett_no like ltrim(@settno)+'%'
		and sett_type like  ltrim(@settype)+'%'
		and short_name like  ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scrip)+'%'
	union all
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd 
		from plusonealbmexpdatewisebrok
		where party_code like ltrim( @partycode)+'%'
		and sett_no like  ltrim(@settno)+'%'
		 and sett_type like  ltrim(@settype)+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and short_name like   ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like   ltrim(@scrip)+'%'
		order by party_code,short_name,sett_no,sett_type,series,scrip_cd,sauda_date
	end 
	else if @flag = 2
	begin
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and sett_no like ltrim(@settno)+'%'
		and sett_type like  ltrim(@settype)+'%'
		and short_name like  ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scrip)+'%'
	union all
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd 
		from plusonealbmexpdatewisebrok
		where party_code like ltrim( @partycode)+'%'
		and sett_no like  ltrim(@settno)+'%'
		 and sett_type like  ltrim(@settype)+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and short_name like   ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like   ltrim(@scrip)+'%'
		and tmark <> '$'
		order by party_code,short_name,sett_no,sett_type,series,scrip_cd,sauda_date
	end 
	else if @flag = 3
	begin
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and sett_no like ltrim(@settno)+'%'
		and sett_type like  ltrim(@settype)+'%'
		and short_name like  ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scrip)+'%'
	union all
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd 
		from plusonealbmexpdatewisebrok
		where party_code like ltrim( @partycode)+'%'
		and sett_no like  ltrim(@settno)+'%'
		 and sett_type like  ltrim(@settype)+'%'
		and sauda_date >=@fdate
		and sauda_date <=@tdate+' 23:59:59'
		and short_name like   ltrim(@partyname)+'%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like   ltrim(@scrip)+'%'
		and tmark = '$'
		order by party_code,short_name,sett_no,sett_type,series,scrip_cd,sauda_date
	end 
end

GO
