-- Object: PROCEDURE dbo.RearrangeSubBillflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeSubBillflag    Script Date: 5/4/01 5:14:52 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubBillflag    Script Date: 4/5/01 6:40:56 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubBillflag    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubBillflag    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubBillflag    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubBillflag    Script Date: 12/27/00 8:59:18 PM ******/

CREATE PROCEDURE RearrangeSubBillflag (@Sett_No varchar(7),@Sett_Type varchar(2)) AS 
declare 
        @@trade_no varchar(14),
        @@PartiPantCode varchar(15),
        @@Scrip varchar(12),  
        @@series varchar(2),
        @@Pqty numeric(9), 
        @@Sqty numeric(9),
        @@Ltrade_no varchar(14),
        @@Lqty numeric(9), 
        @@Pdiff numeric(9),
	@@TTRADE_NO VARCHAR(14),
	@@TFLAG INT,
	@@TRD CURSOR,
        @@Flag cursor,
        @@loop cursor
 update TrdBackUp set billflag = ( Case when sell_buy = 1 then 2 else 3 end ) 
where trdBackUp.sett_no = @sett_no and TrdBackUp.Sett_Type = @Sett_type
                update TrdBackUp set billflag = ( Case when TrdBackUp.sell_buy = 1 then 2 else 3 end) from SubBrokerBillunequalsalePur1 b 
                where b.PartiPantCode = TrdBackUp.PartiPantCode and 
                b.scrip_cd = TrdBackUp.scrip_Cd
                and b.series = TrdBackUp.series          
                and  b.sqty <> 0 and b.pqty <> 0
  and TrdBackUp.sett_no = b.sett_no
  and TrdBackUp.sett_type = b.sett_type
                and TrdBackUp.sett_no = @sett_no and TrdBackUp.Sett_Type = @Sett_type

                update TrdBackUp set billflag = 4 from SubBrokerBillunequalsalePur1 b 
                where b.PartiPantCode = TrdBackUp.PartiPantCode and 
                b.scrip_cd = TrdBackUp.scrip_Cd
                and b.series = TrdBackUp.series          
                and b.Pqty > 0 and b.sqty = 0
                and TrdBackUp.sell_buy = 1 
         and TrdBackUp.sett_no = b.sett_no
         and TrdBackUp.sett_type = b.sett_type
                and TrdBackUp.sett_no = @sett_no and TrdBackUp.Sett_Type = @Sett_type

                update TrdBackUp set billflag = 5 from SubBrokerBillunequalsalePur1 b 
                where b.PartiPantCode = TrdBackUp.PartiPantCode and 
                b.scrip_cd = TrdBackUp.scrip_Cd
                and b.series = TrdBackUp.series          
                and b.sqty > 0 and b.pqty = 0
                and TrdBackUp.sell_buy = 2 
         and TrdBackUp.sett_no = b.sett_no
         and TrdBackUp.sett_type = b.sett_type
                and TrdBackUp.sett_no = @sett_no and TrdBackUp.Sett_Type = @Sett_type

set @@Flag = cursor for
 select PartiPantCode,scrip_cd,series,pqty,sqty from SubBrokerBillunequalsalePur1
 where  pqty <> 0 AND  sqty <> 0 and sett_no = @sett_no and Sett_Type = @Sett_type
 and isnull(pqty,0) <> isnull(sqty,0)
 group by PartiPantCode,scrip_cd,series,pqty,sqty
open @@flag
fetch next from @@Flag into @@PartiPantCode,@@scrip,@@series,@@Pqty,@@sqty
While @@fetch_status = 0 
begin
        if @@Pqty > @@Sqty 
        begin 
  select @@pdiff = @@Pqty - @@Sqty 
  /*set @@Loop  = cursor for 
   select trade_no,tradeqty from TrdBackUp 
   where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
   and sett_no = @sett_no and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
  open @@loop
  fetch next from @@Loop into @@Ltrade_no,@@Lqty     
  if @@fetch_status = 0 
  begin
   update TrdBackUp set Billflag = 4   
   where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
   and trade_no = @@ltrade_no and tradeqty = @@lqty  
   and sett_no = @sett_no and Sett_Type = @Sett_type  
   close @@Loop
   deallocate @@Loop 
  end
  else if @@fetch_status <> 0  
  begin 
   close @@Loop
   deallocate @@Loop  */

   set @@Loop  = cursor for 
    select trade_no,tradeqty from TrdBackUp 
    where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
    and sett_no = @sett_no and Sett_Type = @Sett_type  and SettFlag = 4 order by marketrate  Desc  
   open @@loop
   fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   while @@pdiff > 0       
   begin
    if @@pdiff >= @@Lqty 
    begin
     update TrdBackUp set Billflag = 4   
     where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     and trade_no = @@ltrade_no and tradeqty = @@lqty  
     and sett_no = @sett_no and Sett_Type = @Sett_type  
     select @@pdiff = @@Pdiff - @@Lqty
    end    
    else if @@pdiff < @@Lqty 
    begin
SELECT @@TTRADE_NO = @@ltrade_no
SELECT @@TFLAG = 1 
WHILE @@TFLAG = 1 
BEGIN
SET @@TRD = CURSOR FOR
SELECT TRADE_NO FROM TRDBACKUP  WHERE TRADE_NO = 'B' + @@TTRADE_NO AND
 PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
  and sett_no = @sett_no and Sett_Type = @Sett_type  
OPEN @@TRD
FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
IF @@FETCH_STATUS = 0 
SELECT @@TFLAG = 1
ELSE
SELECT @@TFLAG = 0
CLOSE @@TRD
DEALLOCATE @@TRD	
END
     insert into TrdBackUp select ContractNo,BillNo,'B'+Trade_no,PartiPantCode,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
     from TrdBackUp where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     and trade_no = @@ltrade_no and tradeqty = @@lqty  
     and sett_no = @sett_no and Sett_Type = @Sett_type  
 
     update TrdBackUp set BillFlag = 2,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
     where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     and trade_no = @@ltrade_no and tradeqty = @@lqty
     and sett_no = @sett_no and Sett_Type = @Sett_type  
     select @@Pdiff = 0   
    end 
    fetch next from @@Loop into @@Ltrade_no,@@Lqty
   end
   close @@Loop
 /* end    */
 end
 else if @@Pqty < @@Sqty
 begin 
  select @@pdiff = @@sqty - @@pqty
  /*set @@Loop  = cursor for 
   select trade_no,tradeqty from TrdBackUp 
   where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
   and sett_no = @sett_no and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
  open @@loop
  fetch next from @@Loop into @@Ltrade_no,@@Lqty     
  if @@fetch_status = 0 
  begin
   update TrdBackUp set Billflag = 5  
   where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
   and trade_no = @@ltrade_no and tradeqty = @@lqty  
   and sett_no = @sett_no and Sett_Type = @Sett_type  
   close @@Loop
   deallocate @@Loop 
  end
  else if @@fetch_status <> 0  
  begin 
   close @@Loop
   deallocate @@Loop  
*/
   set @@Loop  = cursor for 
    select trade_no,tradeqty from TrdBackUp 
    where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
    and sett_no = @sett_no and Sett_Type = @Sett_type  and SettFlag = 5 order by marketrate Desc  
   open @@loop
   fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   while @@pdiff > 0       
   begin
    if @@pdiff >= @@Lqty 
    begin
     update TrdBackUp set Billflag = 5   
     where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     and trade_no = @@ltrade_no and tradeqty = @@lqty  
     and sett_no = @sett_no and Sett_Type = @Sett_type  
     select @@pdiff = @@Pdiff - @@Lqty
    end    
    else if @@pdiff < @@Lqty 
    begin
SELECT @@TTRADE_NO = @@ltrade_no
SELECT @@TFLAG = 1 
WHILE @@TFLAG = 1 
BEGIN
SET @@TRD = CURSOR FOR
SELECT TRADE_NO FROM TRDBACKUP WHERE TRADE_NO = 'B' + @@TTRADE_NO AND
 PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
  and sett_no = @sett_no and Sett_Type = @Sett_type  
OPEN @@TRD
FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
IF @@FETCH_STATUS = 0 
SELECT @@TFLAG = 1
ELSE
SELECT @@TFLAG = 0
CLOSE @@TRD
DEALLOCATE @@TRD	
END
     insert into TrdBackUp select ContractNo,BillNo,'B'+Trade_no,PartiPantCode,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
     from TrdBackUp where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     and trade_no = @@ltrade_no and tradeqty = @@lqty  
     and sett_no = @sett_no and Sett_Type = @Sett_type  
     
     update TrdBackUp set billflag = 3,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff) * MarketRate     
     where PartiPantCode = @@PartiPantCode and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     and trade_no = @@ltrade_no and tradeqty = @@lqty
     and sett_no = @sett_no and Sett_Type = @Sett_type   
     select @@Pdiff = 0   
    end 
    fetch next from @@Loop into @@Ltrade_no,@@Lqty
   end
   close @@Loop
/*  end*/
 end 
 fetch next from @@Flag into @@PartiPantCode,@@scrip,@@series,@@Pqty,@@sqty
end 
close @@Flag
deallocate @@Flag
UPDATE TrdBackUp SET service_tax = ((brokapplied*tradeqty*(select service_tax from globals where year_start_dt < getdate() )) /100),
Nsertax = ((brokapplied*tradeqty*(select service_tax from globals where year_start_dt < getdate() )) /100), 
Amount = (tradeqty * netrate) 
 where sett_no = @Sett_no
and sett_type = @Sett_Type

GO
