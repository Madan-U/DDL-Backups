-- Object: PROCEDURE dbo.Auctionbrok
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Procedure Auctionbrok @TypeofTrans Int , @Sauda_date Varchar(11)
As
If @TypeofTrans = 1
Begin
     Update settlement set brokapplied = 0,service_tax = 0 ,Netrate = Marketrate,Amount= Marketrate * Tradeqty,
Ins_chrg =0 , turn_tax = 0,other_chrg=0 , sebi_tax = 0 , Broker_chrg =0,  Trade_amount = Marketrate * Tradeqty,
NBrokApp = 0 , NSerTax = 0, N_NetRate = Marketrate
Where sauda_date Like @sauda_date +'%' and Sett_type like 'A%' and sell_buy = 2

  Update isettlement set brokapplied = 0,service_tax = 0 ,Netrate = Marketrate,Amount= Marketrate * Tradeqty,
Ins_chrg =0 , turn_tax = 0,other_chrg=0 , sebi_tax = 0 , Broker_chrg =0,  Trade_amount = Marketrate * Tradeqty,
NBrokApp = 0 , NSerTax = 0, N_NetRate = Marketrate
Where sauda_date Like @sauda_date + '%' and Sett_type like 'A%' and sell_buy = 2
End
If @TypeofTrans = 2
Begin
     Update settlement set brokapplied = 0,service_tax = 0 ,Netrate = Marketrate,Amount= Marketrate * Tradeqty,
Ins_chrg =0 , turn_tax = 0,other_chrg=0 , sebi_tax = 0 , Broker_chrg =0,  Trade_amount = Marketrate * Tradeqty,
NBrokApp = 0 , NSerTax = 0, N_NetRate = Marketrate
Where sauda_date Like @sauda_date+'%' and Sett_type like 'A%' and sell_buy = 1

Update isettlement set brokapplied = 0,service_tax = 0 ,Netrate = Marketrate,Amount= Marketrate * Tradeqty,
Ins_chrg =0 , turn_tax = 0,other_chrg=0 , sebi_tax = 0 , Broker_chrg =0,  Trade_amount = Marketrate * Tradeqty,
NBrokApp = 0 , NSerTax = 0, N_NetRate = Marketrate
Where sauda_date Like @sauda_date + '%' and Sett_type like 'A%' and sell_buy = 1

End
If @TypeofTrans = 3
Begin
     Update settlement set brokapplied = 0,service_tax = 0 ,Netrate = Marketrate,Amount= Marketrate * Tradeqty,
Ins_chrg =0 , turn_tax = 0,other_chrg=0 , sebi_tax = 0 , Broker_chrg =0,  Trade_amount = Marketrate * Tradeqty,
NBrokApp = 0 , NSerTax = 0, N_NetRate = Marketrate
Where sauda_date Like @sauda_date+'%' and Sett_type like 'A%' and sell_buy = 1
Update isettlement set brokapplied = 0,service_tax = 0 ,Netrate = Marketrate,Amount= Marketrate * Tradeqty,
Ins_chrg =0 , turn_tax = 0,other_chrg=0 , sebi_tax = 0 , Broker_chrg =0,  Trade_amount = Marketrate * Tradeqty,
NBrokApp = 0 , NSerTax = 0, N_NetRate = Marketrate
Where sauda_date Like @sauda_date + '%' and Sett_type like 'A%' and sell_buy = 1

End

GO
