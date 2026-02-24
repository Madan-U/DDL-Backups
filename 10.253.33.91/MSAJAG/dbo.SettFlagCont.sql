-- Object: PROCEDURE dbo.SettFlagCont
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SettFlagCont    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.SettFlagCont    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.SettFlagCont    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.SettFlagCont    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SettFlagCont    Script Date: 12/27/00 8:59:03 PM ******/

create proc SettFlagCont(@tparty varchar(10), @tdate varchar(10),@tscrip_cd varchar(12)) as  
update settlement
set nSerTax=globals.service_tax,
BrokApplied = (  case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then broktable.Normal
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then broktable.Normal    
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then (broktable.Normal /100 ) * settlement.marketrate
   when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then (broktable.Normal /100 )* settlement.marketrate         
   when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ((broktable.day_puc))
   when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then (broktable.day_puc/100) * settlement.marketrate 
          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then broktable.day_sales
   when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then (broktable.day_sales/ 100) * settlement.marketrate 
   when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then broktable.sett_purch                         
   when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (broktable.sett_purch/100) * settlement.marketrate 
   when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then broktable.sett_sales 
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then (broktable.sett_sales/100) * settlement.marketrate 
   Else  0 
                        End 
                         ),
NetRate = (  case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then ( ( settlement.marketrate + broktable.Normal))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then ((settlement.marketrate - broktable.Normal ) )   
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then ((settlement.marketrate + ((broktable.Normal /100 )* settlement.marketrate)))
   when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then ((settlement.marketrate - ((broktable.Normal /100 )* settlement.marketrate)))         
   when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ((broktable.day_puc + settlement.marketrate ))
   when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ((settlement.marketrate + ((broktable.day_puc/100) * settlement.marketrate )))
          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ((  settlement.marketrate - broktable.day_sales))
   when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate - ((broktable.day_sales/ 100) * settlement.marketrate )))
   when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.sett_purch + settlement.marketrate ) )
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate + (( broktable.sett_purch/100) * settlement.marketrate )))
   when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                             Then (( settlement.marketrate - broktable.sett_sales ))
                        when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate - ((broktable.sett_sales/100) * settlement.marketrate )))
   Else  0 
                        End 
                         ),
Amount =  (case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then (( settlement.marketrate + broktable.Normal) * settlement.Tradeqty)
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then ((settlement.marketrate - broktable.Normal   ) * settlement.Tradeqty)   
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then ((settlement.marketrate + ((broktable.Normal /100 )* settlement.marketrate)) * settlement.Tradeqty)
   when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then ((settlement.marketrate - ((broktable.Normal /100 )* settlement.marketrate)) * settlement.Tradeqty)         
   when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ((broktable.day_puc + settlement.marketrate )  * settlement.Tradeqty)
   when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ((settlement.marketrate + ((broktable.day_puc/100) * settlement.marketrate )) * settlement.Tradeqty)
          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ((  settlement.marketrate - broktable.day_sales) * settlement.Tradeqty)
   when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate - ((broktable.day_sales/ 100) * settlement.marketrate ))* settlement.Tradeqty)
   when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.sett_purch + settlement.marketrate )   * settlement.Tradeqty)
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate + (( broktable.sett_purch/100) * settlement.marketrate ))  * settlement.Tradeqty)
   when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                             Then (( settlement.marketrate - broktable.sett_sales )   * settlement.Tradeqty)
                        when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate - ((broktable.sett_sales/100) * settlement.marketrate ))   * settlement.Tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100), 
        turn_tax  = ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),              
        other_chrg = ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ), 
        sebi_tax = ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),              
        Broker_chrg = ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),
        settlement.Service_tax = (case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then (broktable.Normal * settlement.Tradeqty * Globals.service_tax) / 100
                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then ((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100)
   when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ( (broktable.day_puc * settlement.Tradeqty * globals.service_tax) /100)
   when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ((broktable.day_puc/100) * ( settlement.marketrate * settlement.Tradeqty * Globals.service_tax) / 100)
          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ((broktable.day_sales * settlement.Tradeqty * Globals.service_tax) / 100)
   when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ((broktable.day_sales/ 100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100)
   when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.sett_purch) * ( settlement.Tradeqty * Globals.service_tax) / 100)
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (( broktable.sett_purch/100) * ( settlement.marketrate  * settlement.Tradeqty * Globals.service_tax)/100 )
   when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then ( (broktable.sett_sales * settlement.Tradeqty * Globals.service_tax) /100)
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  ( (broktable.sett_sales/100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax)  /100)
   Else  0 
                        End 
                         ),
Trade_amount = settlement.Tradeqty * settlement.MarketRate,
nsertax = settlement.service_tax, Nbrokapp = brokapplied 
,settlement.Table_No = broktable.Table_No,settlement.Line_No = broktable.Line_No
,settlement.val_perc = broktable.val_perc ,settlement.Normal = broktable.Normal, settlement.Day_puc = broktable.Day_puc
,settlement.day_sales = broktable.day_sales,settlement.Sett_purch = broktable.Sett_Purch
,settlement.Sett_sales = broktable.sett_sales ,N_NetRate = NetRate
FROM BrokTable,Client2,settlement,taxes,globals,scrip1,scrip2,Sett_mst,client1 
WHERE  settlement.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
 SETTLEMENT.SETT_NO = SETT_MST.SETT_NO 
 AND 
 SETTLEMENT.SETT_TYPE= SETT_MST.SETT_TYPE
 AND
              (settlement.Series = scrip2.series)
           And
             (scrip2.scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
            (Broktable.Table_no = ( case 
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
                         then 
                              client2.demat_tableno 
                         Else 
                              client2.table_no 
                         end  ))
/*            AND 
              settlement.MarketRate <= BrokTable.Upper_lim  */
            And 
              Broktable.Line_no = 
                 (Select min(Broktable.line_no) from broktable where
                       ( Broktable.table_no =
                        (case 
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
                         then 
                              client2.demat_tableno
                         Else
                              client2.table_no   
                         end
                         ) 
                        and
                        settlement.Party_Code =  Client2.Party_code 
                        ) 
                                            
                      and  
                        (settlement.marketrate <= Broktable.upper_lim))
               
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')
  and settlement.party_code = @tparty 
  and convert(varchar,settlement.sauda_date,3)= @tdate
  and settlement.scrip_cd = @tscrip_cd
select * from settlement

GO
