-- Object: PROCEDURE dbo.CBO_SETTOHIS_TRANSFER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  PROCEDURE CBO_SETTOHIS_TRANSFER
(
     
@SETNOFROM VARCHAR(25),
@SETNOTO VARCHAR(25),
@TYPE VARCHAR(10),   
@DIRECTION VARCHAR(10),
@ISTATUS Varchar(10)
)
AS
IF @DIRECTION='SETTOHIS'
BEGIN
Insert Into 
History 
	(ContractNo,
	BillNo,
	Trade_no,
	Party_Code,
	Scrip_Cd,
	User_id,
	Tradeqty,
	AuctionPart,
	MarketType,
	Series,
	Order_no,
	MarketRate,
	Sauda_date,
	Table_No,
	Line_No,
	Val_perc,
	Normal,
	Day_puc,
	day_sales,
	Sett_purch,
	Sett_sales,
	Sell_buy,
	Settflag,
	Brokapplied,
	NetRate,
	Amount,
	Ins_chrg,
	turn_tax,
	other_chrg,
	sebi_tax,
	Broker_chrg,
	Service_tax,
	Trade_amount,
	Billflag,
	sett_no,
	NBrokApp,
	NSerTax,
	N_NetRate,
	sett_type,
	Partipantcode,
	status,
	pro_cli,
	cpid,
	instrument,
	bookType,
	branch_id,
	dummy1,
	dummy2,
	tmark,
	Scheme)
	select 
	ContractNo,
	BillNo,
	Trade_no,
	Party_Code,
	Scrip_Cd,
	User_id,
	Tradeqty,
	AuctionPart,
	MarketType,
	Series,
	Order_no,
	MarketRate,
	Sauda_date,
	Table_No,
	Line_No,
	Val_perc,
	Normal,
	Day_puc,
	day_sales,
	Sett_purch,
	Sett_sales,
	Sell_buy,
	Settflag,
	Brokapplied,
	NetRate,
	Amount,
	Ins_chrg,
	turn_tax,
	other_chrg,
	sebi_tax,
	Broker_chrg,
	Service_tax,
	Trade_amount,
	Billflag,
	sett_no,
	NBrokApp,
	NSerTax,
	N_NetRate,
	sett_type,
	Partipantcode,
	status,
	pro_cli,
	cpid,
	instrument,
	bookType,
	branch_id,
	dummy1,
	dummy2,
	tmark,
	Scheme
	from 
	settlement 
	where 
	    sett_no >= @SETNOFROM 
	and sett_no <= @SETNOTO 
	and sett_type = @TYPE

	delete 
	from 
	settlement 
	Where 
	sett_no >= @SETNOFROM 
	and sett_no <= @SETNOTO 
	and sett_type = @TYPE

	if(@ISTATUS ='1')
	Begin
	Insert 
	Into 
	IHistory 
		(ContractNo,
		BillNo,
		Trade_no,
		Party_Code,
		Scrip_Cd,
		User_id,
		Tradeqty,
		AuctionPart,
		MarketType,
		Series,
		Order_no,
		MarketRate,
		Sauda_date,
		Table_No,
		Line_No,
		Val_perc,
		Normal,
		Day_puc,
		day_sales,
		Sett_purch,
		Sett_sales,
		Sell_buy,
		Settflag,
		Brokapplied,
		NetRate,
		Amount,
		Ins_chrg,
		turn_tax,
		other_chrg,
		sebi_tax,
		Broker_chrg,
		Service_tax,
		Trade_amount,
		Billflag,
		sett_no,
		NBrokApp,
		NSerTax,
		N_NetRate,
		sett_type,
		Partipantcode,
		Status,
		Pro_Cli,
		CpId,
		Instrument,
		BookType,
		Branch_Id,
		TMark,
		Scheme,
		Dummy1,
		Dummy2 )
		select 
		ContractNo,
		BillNo,
		Trade_no,
		Party_Code,
		Scrip_Cd,
		User_id,
		Tradeqty,
		AuctionPart,
		MarketType,
		Series,
		Order_no,
		MarketRate,
		Sauda_date,
		Table_No,
		Line_No,
		Val_perc,
		Normal,
		Day_puc,
		day_sales,
		Sett_purch,
		Sett_sales,
		Sell_buy,
		Settflag,
		Brokapplied,
		NetRate,
		Amount,
		Ins_chrg,
		turn_tax,
		other_chrg,
		sebi_tax,
		Broker_chrg,
		Service_tax,
		Trade_amount,
		Billflag,
		sett_no,
		NBrokApp,
		NSerTax,
		N_NetRate,
		sett_type,
		Partipantcode,
		Status,
		Pro_Cli,
		CpId,
		Instrument,
		BookType,
		Branch_Id,
		TMark,
		Scheme,
		Dummy1,
		Dummy2 
		from 
		isettlement 
		where 
		sett_no >= @SETNOFROM 
		and sett_no <= @SETNOTO 
		and sett_type = @TYPE

		delete from 	
		Isettlement 
		Where sett_no >= @SETNOFROM
		 and sett_no <= @SETNOTO
		 and sett_type = @TYPE



	END
END


IF (@DIRECTION='HISTOSET')
BEGIN
Insert Into settlement 
	(ContractNo,
	BillNo,
	Trade_no,
	Party_Code,
	Scrip_Cd,
	User_id,
	Tradeqty,
	AuctionPart,
	MarketType,
	Series,
	Order_no,
	MarketRate,
	Sauda_date,
	Table_No,
	Line_No,
	Val_perc,
	Normal,
	Day_puc,
	day_sales,
	Sett_purch,
	Sett_sales,
	Sell_buy,
	Settflag,
	Brokapplied,
	NetRate,
	Amount,
	Ins_chrg,
	turn_tax,
	other_chrg,
	sebi_tax,
	Broker_chrg,
	Service_tax,
	Trade_amount,
	Billflag,
	sett_no,
	NBrokApp,
	NSerTax,
	N_NetRate,
	sett_type,
	Partipantcode,
	status,
	pro_cli,
	cpid,
	instrument,
	bookType,
	branch_id,
	dummy1,
	dummy2,
	tmark,
	Scheme)
	select 
	ContractNo,
	BillNo,
	Trade_no,
	Party_Code,
	Scrip_Cd,
	User_id,
	Tradeqty,
	AuctionPart,
	MarketType,
	Series,
	Order_no,
	MarketRate,
	Sauda_date,
	Table_No,
	Line_No,
	Val_perc,
	Normal,
	Day_puc,
	day_sales,
	Sett_purch,
	Sett_sales,
	Sell_buy,
	Settflag,
	Brokapplied,
	NetRate,
	Amount,
	Ins_chrg,
	turn_tax,
	other_chrg,
	sebi_tax,
	Broker_chrg,
	Service_tax,
	Trade_amount,
	Billflag,
	sett_no,
	NBrokApp,
	NSerTax,
	N_NetRate,
	sett_type,
	Partipantcode,
	status,
	pro_cli,
	cpid,
	instrument,
	bookType,
	branch_id,
	dummy1,
	dummy2,
	tmark,
	Scheme
	from 
	History 
	where 
	    sett_no >= @SETNOFROM 
	and sett_no <= @SETNOTO 
	and sett_type = @TYPE

	delete 
	from 
	History 
	Where 
	sett_no >= @SETNOFROM 
	and sett_no <= @SETNOTO 
	and sett_type = @TYPE

	if (@ISTATUS ='1')
	Begin
	Insert 
	Into 
	isettlement 
	(	ContractNo,
		BillNo,
		Trade_no,
		Party_Code,
		Scrip_Cd,
		User_id,
		Tradeqty,
		AuctionPart,
		MarketType,
		Series,
		Order_no,
		MarketRate,
		Sauda_date,
		Table_No,
		Line_No,
		Val_perc,
		Normal,
		Day_puc,
		day_sales,
		Sett_purch,
		Sett_sales,
		Sell_buy,
		Settflag,
		Brokapplied,
		NetRate,
		Amount,
		Ins_chrg,
		turn_tax,
		other_chrg,
		sebi_tax,
		Broker_chrg,
		Service_tax,
		Trade_amount,
		Billflag,
		sett_no,
		NBrokApp,
		NSerTax,
		N_NetRate,
		sett_type,
		Partipantcode,
		Status,
		Pro_Cli,
		CpId,
		Instrument,
		BookType,
		Branch_Id,
		TMark,
		Scheme,
		Dummy1,
		Dummy2 
	)
		select 
		ContractNo,
		BillNo,
		Trade_no,
		Party_Code,
		Scrip_Cd,
		User_id,
		Tradeqty,
		AuctionPart,
		MarketType,
		Series,
		Order_no,
		MarketRate,
		Sauda_date,
		Table_No,
		Line_No,
		Val_perc,
		Normal,
		Day_puc,
		day_sales,
		Sett_purch,
		Sett_sales,
		Sell_buy,
		Settflag,
		Brokapplied,
		NetRate,
		Amount,
		Ins_chrg,
		turn_tax,
		other_chrg,
		sebi_tax,
		Broker_chrg,
		Service_tax,
		Trade_amount,
		Billflag,
		sett_no,
		NBrokApp,
		NSerTax,
		N_NetRate,
		sett_type,
		Partipantcode,
		Status,
		Pro_Cli,
		CpId,
		Instrument,
		BookType,
		Branch_Id,
		TMark,
		Scheme,
		Dummy1,
		Dummy2 
		from 
		IHistory 
		where 
		sett_no >= @SETNOFROM 
		and sett_no <= @SETNOTO 
		and sett_type = @TYPE
		delete from 	
		IHistory 
		Where sett_no >= @SETNOFROM
		 and sett_no <= @SETNOTO
		 and sett_type = @TYPE

	END
END

GO
