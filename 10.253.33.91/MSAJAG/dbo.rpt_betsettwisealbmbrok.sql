-- Object: PROCEDURE dbo.rpt_betsettwisealbmbrok
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_betsettwisealbmbrok    Script Date: 04/27/2001 4:32:33 PM ******/

/* report : datewisebrokerage report
     file :betsettbrokreport.asp
     finds brokerage and delivery charge for selected number of settlements 
*/
CREATE PROCEDURE  rpt_betsettwisealbmbrok


@statusid varchar(10),
@statusname varchar(25),
@partycode varchar(10),
@fromsett varchar(7),
@tosett varchar(7),
@settype varchar(3),
@name varchar(21),
@trader varchar(15),
@scripcd varchar(21),
@flag int

as

if @statusid='broker'
begin
	if @flag = 1
	begin
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		 and sett_no between @fromsett  and @tosett
		and sett_type like  ltrim(@settype) + '%'
		and short_name like ltrim(@name)+ '%' 
		and trader like  ltrim(@trader)+'%'
		 and scrip_cd like  ltrim(@scripcd)+'%'
	union all
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd
		 from plusonealbmexpdatewisebrok
		where party_code like @partycode+'%'
		and sett_no between @fromsett  and @tosett
		and sett_type like  ltrim(@settype) + '%' 
		and short_name like ltrim(@name)+ '%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scripcd)+'%'
		order by party_code,short_name,sett_type,sett_no,series,scrip_cd,sauda_date
	end
	else if @flag = 2
	begin
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		 and sett_no between @fromsett  and @tosett
		and sett_type like  ltrim(@settype) + '%'
		and short_name like ltrim(@name)+ '%' 
		and trader like  ltrim(@trader)+'%'
		 and scrip_cd like  ltrim(@scripcd)+'%'
	union all
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd
		 from plusonealbmexpdatewisebrok
		where party_code like @partycode+'%'
		and sett_no between @fromsett  and @tosett
		and sett_type like  ltrim(@settype) + '%' 
		and short_name like ltrim(@name)+ '%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scripcd)+'%'
		and tmark <> '$'
		order by party_code,short_name,sett_type,sett_no,series,scrip_cd,sauda_date
	end
	else if @flag = 3
	begin
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd 
		from datewisenormalbrok 
		where party_code like @partycode+'%'
		 and sett_no between @fromsett  and @tosett
		and sett_type like  ltrim(@settype) + '%'
		and short_name like ltrim(@name)+ '%' 
		and trader like  ltrim(@trader)+'%'
		 and scrip_cd like  ltrim(@scripcd)+'%'
	union all
		select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd
		 from plusonealbmexpdatewisebrok
		where party_code like @partycode+'%'
		and sett_no between @fromsett  and @tosett
		and sett_type like  ltrim(@settype) + '%' 
		and short_name like ltrim(@name)+ '%' 
		and trader like  ltrim(@trader)+'%' 
		and scrip_cd like  ltrim(@scripcd)+'%'
		and tmark = '$'
		order by party_code,short_name,sett_type,sett_no,series,scrip_cd,sauda_date
	end
end

GO
