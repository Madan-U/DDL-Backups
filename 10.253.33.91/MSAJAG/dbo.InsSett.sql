-- Object: PROCEDURE dbo.InsSett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.InsSett    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.InsSett    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.InsSett    Script Date: 20-Mar-01 11:38:51 PM ******/


CREATE proc InsSett (@SettType varchar(2),@Party varchar(12),@ContractNo Varchar(7),@PartiPantCode Varchar(15),@Order_No Varchar(16),
@Scrip_Cd Varchar(12), @Series Varchar(2), @Sell_buy int,@Flag int) as
 if @Flag = 1 
 begin
  insert into settlement  select @contractno,'0' ,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
   AuctionPart, markettype,series, order_no, MarketRate,
   Sauda_date, Table_No, Line_No, Val_perc, Normal ,  Day_puc, day_sales, Sett_purch, Sett_sales, Sell_buy,settflag, Brokapplied,NetRate,
   Amount, Ins_chrg,turn_tax,other_chrg,sebi_tax, Broker_chrg,Service_tax, Trade_amount , 1 , sett_no,
   BrokApplied , Service_tax ,NetRate , sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
   from tconfirmview where party_code = @Party 
   and sett_Type = @setttype and PartipantCode = @PartipantCode
 end 
 else if @Flag = 2 
 begin
  insert into Isettlement select @contractno,'0' ,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
   AuctionPart, markettype,series, order_no, MarketRate,
   Sauda_date, Table_No, Line_No, Val_perc, Normal ,  Day_puc, day_sales, Sett_purch, Sett_sales, Sell_buy,settflag, Brokapplied,NetRate,
   Amount, Ins_chrg,turn_tax,other_chrg,sebi_tax, Broker_chrg,Service_tax, Trade_amount , 1 , sett_no,
   BrokApplied , Service_tax ,NetRate , sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
   from tconfirmview where party_code =@Party 
   and sett_Type = @setttype and PartipantCode = @PartipantCode and Order_no = @Order_No
 end 
 else if @Flag = 3
 begin
  insert into Isettlement select @contractno,'0' ,Trade_no, Party_Code, Scrip_Cd,user_id ,tradeqty,
   AuctionPart, markettype,series, order_no, MarketRate,
   Sauda_date, Table_No, Line_No, Val_perc, Normal ,  Day_puc, day_sales, Sett_purch, Sett_sales, Sell_buy,settflag, Brokapplied,NetRate,
   Amount, Ins_chrg,turn_tax,other_chrg,sebi_tax, Broker_chrg,Service_tax, Trade_amount , 1 , sett_no,
   BrokApplied , Service_tax ,NetRate , sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
   from tconfirmview where party_code =@Party 
   and sett_Type = @setttype and PartipantCode = @PartipantCode and Scrip_Cd = @Scrip_Cd and Series = @Series and Sell_buy = @Sell_buy
 end

GO
