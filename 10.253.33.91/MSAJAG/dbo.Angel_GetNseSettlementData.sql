-- Object: PROCEDURE dbo.Angel_GetNseSettlementData
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_GetNseSettlementData      
as      
declare @fromdate as datetime      
select @fromdate=(locked_upto+1) from mis.remisior.dbo.company where coshrtname='ACDLCM'      
--select * from settlement where sauda_date >= @fromdate      
truncate table nsedata_temp      
--insert into nsedata_temp select * from settlement(nolock) where sauda_date >= @fromdate 

insert into nsedata_temp 
select ContractNo,	BillNo,	Trade_no,	Party_Code,	Scrip_Cd,	User_id,	Tradeqty,	AuctionPart,	MarketType,	Series,	Order_no,	MarketRate,	Sauda_date,	Table_No,	Line_No,	Val_perc,	Normal,	Day_puc,	day_sales,	Sett_purch,	Sett_sales,	Sell_buy,	Settflag,	Brokapplied,	NetRate,	Amount,	Ins_chrg,	turn_tax,	other_chrg,	sebi_tax,	Broker_chrg,	Service_tax,	Trade_amount,	Billflag,	sett_no,	NBrokApp,	NSerTax,	N_NetRate,	sett_type,	Partipantcode,	Status,	Pro_Cli,	CpId,	Instrument,	BookType,	Branch_Id,	TMark,	Scheme,	Dummy1,	Dummy2
from settlement(nolock) where sauda_date >= @fromdate

GO
