-- Object: PROCEDURE dbo.rpt_betsettalbmdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_betsettalbmdetail    Script Date: 04/27/2001 4:32:33 PM ******/
CREATE procedure  rpt_betsettalbmdetail
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(10),
@partyname varchar(21),
@settnof varchar(7),
@settnot varchar(7),
@settype varchar(3),
@trader varchar(15),
@scrip varchar(20),
@flag int

as
	if @flag = 1
	begin
	select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd , sett_no,sett_type
	from datewisenormalbrok 
	where party_code like ltrim(@partycode)+'%'
	and sett_no between @settnof and @settnot
	and sett_type like  @settype+'%'
	and short_name like @partyname+'%' 
	and trader like @trader+'%' 
	and scrip_cd like @scrip+'%'
union all
	select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd , sett_no,sett_type
	from plusonealbmexpdatewisebrok
	where party_code like ltrim(@partycode)+'%'
	and sett_no between @settnof and @settnot
	and sett_type like  @settype+'%'
	and short_name like @partyname+'%' 
	and trader like @trader+'%' 
	and scrip_cd like @scrip+'%'
	order by  sett_no , sett_type  ,party_code,short_name,series,scrip_cd,sauda_date
	end 
	else if @flag = 2
	begin
	select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd , sett_no,sett_type
	from datewisenormalbrok 
	where party_code like ltrim(@partycode)+'%'
	and sett_no between @settnof and @settnot
	and sett_type like  @settype+'%'
	and short_name like @partyname+'%' 
	and trader like @trader+'%' 
	and scrip_cd like @scrip+'%'
union all
	select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd , sett_no,sett_type
	from plusonealbmexpdatewisebrok
	where party_code like ltrim(@partycode)+'%'
	and sett_no between @settnof and @settnot
	and sett_type like  @settype+'%'
	and short_name like @partyname+'%' 
	and trader like @trader+'%' 
	and scrip_cd like @scrip+'%'
	and tmark <> '$'
	order by  sett_no , sett_type  ,party_code,short_name,series,scrip_cd,sauda_date
	end 
	else if @flag = 3
	begin
	select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series,scrip_cd , sett_no,sett_type
	from datewisenormalbrok 
	where party_code like ltrim(@partycode)+'%'
	and sett_no between @settnof and @settnot
	and sett_type like  @settype+'%'
	and short_name like @partyname+'%' 
	and trader like @trader+'%' 
	and scrip_cd like @scrip+'%'
union all
	select sett_type,sett_no,party_code, short_name, trader, DeliveryCharge , Brok  , sauda_date, series ,scrip_cd , sett_no,sett_type
	from plusonealbmexpdatewisebrok
	where party_code like ltrim(@partycode)+'%'
	and sett_no between @settnof and @settnot
	and sett_type like  @settype+'%'
	and short_name like @partyname+'%' 
	and trader like @trader+'%' 
	and scrip_cd like @scrip+'%'
	and tmark = '$'
	order by  sett_no , sett_type  ,party_code,short_name,series,scrip_cd,sauda_date
	end

GO
