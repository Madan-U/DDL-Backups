-- Object: PROCEDURE dbo.SettBrokEditUp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SettBrokEditUp    Script Date: 3/30/01 2:45:03 PM ******/


/****** Object:  Stored Procedure dbo.SettBrokEditUp    Script Date: 3/15/01 10:10:13 AM ******/

/****** Object:  Stored Procedure dbo.SettBrokEditUp    Script Date: 22-Feb-01 7:48:15 PM ******/


CREATE procedure SettBrokEditUp (@Sett_no Varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10),@Scrip_Cd Varchar(12),@series Varchar(2),@Trade_No Varchar(14),@Order_No Varchar(16),@MarketRate Numeric(18,9),@Brok Numeric(18,8),@Val_Perc Varchar(1),@Sell_buy Int,@NetRate Numeric(18,9), @Flag Int) as 
if @Flag = 1 
begin
 update settlement set status = 'E',
 BrokApplied =(  case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then round((@brok /100 ) * settlement.marketrate,broktable.round_to)

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then round((@brok/100 )* settlement.marketrate,broktable.round_to)         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok))

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then @brok

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round((@brok/ 100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
       NetRate = (  case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then round(( settlement.marketrate + @brok),broktable.round_to)

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) )   

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then ((settlement.marketrate + round((@brok /100 )* settlement.marketrate,broktable.round_to)))

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - round((@brok /100 )* settlement.marketrate,broktable.round_to)))         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok + settlement.marketrate ))

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate ,broktable.round_to)))

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then ((  settlement.marketrate - @brok))

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/ 100) * settlement.marketrate,broktable.round_to )))

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then ((@brok + settlement.marketrate ) )

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then ((settlement.marketrate + round(( @brok/100) * settlement.marketrate,broktable.round_to )))

                        when ( settlement.SettFlag =5  and @val_perc ="V" )
                             Then (( settlement.marketrate - @brok ))

                        when ( settlement.SettFlag =5  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/100) * settlement.marketrate,broktable.round_to )))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then (( settlement.marketrate + @brok) * settlement.Tradeqty)

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) * settlement.Tradeqty)   

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then ((settlement.marketrate + round((@brok /100 )* settlement.marketrate,broktable.round_to)) * settlement.Tradeqty)

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - round((@brok/100 )* settlement.marketrate,broktable.round_to)) * settlement.Tradeqty)         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok + settlement.marketrate )  * settlement.Tradeqty)

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate,broktable.round_to )) * settlement.Tradeqty)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then ((  settlement.marketrate - @brok) * settlement.Tradeqty)

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/ 100) * settlement.marketrate,broktable.round_to ))* settlement.Tradeqty)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then ((@brok + settlement.marketrate )   * settlement.Tradeqty)

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate,broktable.round_to ))  * settlement.Tradeqty)

                        when ( settlement.SettFlag =5  and @val_perc ="V" )
                             Then (( settlement.marketrate - @brok )   * settlement.Tradeqty)

                        when ( settlement.SettFlag =5  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/100) * settlement.marketrate,broktable.round_to ))   * settlement.Tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 

        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              

        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 

        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              

        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),

        Service_tax = (case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V")
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 1 and @val_perc ="P")
                             Then round(((@brok/100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then round( (@brok * settlement.Tradeqty * globals.service_tax) /100,Broktable.Round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round(((@brok/ 100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then Round((@brok) * ( settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((( @brok/100) * ( settlement.marketrate  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then round( (@brok * settlement.Tradeqty * Globals.service_tax) /100,Broktable.Round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then  round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),
      Trade_amount = settlement.Tradeqty * settlement.MarketRate,
      NBrokApp = (  case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then round((@brok /100 ) * settlement.marketrate,broktable.round_to)

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then round((@brok/100 )* settlement.marketrate,broktable.round_to)         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok))

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then @brok

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round((@brok/ 100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
        NSertax =  (case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V")
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 1 and @val_perc ="P")
                             Then round(((@brok/100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then round( (@brok * settlement.Tradeqty * globals.service_tax) /100,Broktable.Round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round(((@brok/ 100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then Round((@brok) * ( settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((( @brok/100) * ( settlement.marketrate  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then round( (@brok * settlement.Tradeqty * Globals.service_tax) /100,Broktable.Round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then  round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),       
N_NetRate = (  case  
                   when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                   Then round(( settlement.marketrate + @brok),broktable.round_to)

                   when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                   Then ((settlement.marketrate - @brok ) )   

                   when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                   Then ((settlement.marketrate + round((@brok /100 )* settlement.marketrate,broktable.round_to)))

                   when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                   Then ((settlement.marketrate - round((@brok /100 )* settlement.marketrate,broktable.round_to)))         

                   when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                   Then ((@brok + settlement.marketrate ))

                   when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                   Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate ,broktable.round_to)))

                   when (settlement.SettFlag = 3  and @val_perc ="V" )
                   Then ((  settlement.marketrate - @brok))

                   when (settlement.SettFlag = 3  and @val_perc ="P" )
                   Then ((settlement.marketrate - round((@brok/ 100) * settlement.marketrate,broktable.round_to )))

                   when ( settlement.SettFlag = 4  and @val_perc ="V" )
                   Then ((@brok + settlement.marketrate ) )

                   when ( settlement.SettFlag = 4  and @val_perc ="P" )
                   Then ((settlement.marketrate + round(( @brok/100) * settlement.marketrate,broktable.round_to )))

                   when ( settlement.SettFlag =5  and @val_perc ="V" )
                   Then (( settlement.marketrate - @brok ))

                   when ( settlement.SettFlag =5  and @val_perc ="P" )
                   Then ((settlement.marketrate - round((@brok/100) * settlement.marketrate,broktable.round_to )))

   Else  0 
          End 
                  )
  from Globals,client2,broktable,taxes
  WHERE settlement.Sett_no = @Sett_No 
  and settlement.sett_Type = @Sett_Type 
  and settlement.Party_code Like @Party_Code
  and settlement.scrip_cd like @Scrip_Cd
  and settlement.series Like @Series
  and settlement.Trade_no Like @Trade_no
  and settlement.Order_no Like @Order_no
  and client2.party_code = @party_code
  And (Client2.Tran_cat = Taxes.Trans_cat)
 and Client2.Table_no = BrokTable.Table_no
 and Broktable.Line_no = ( Select min(line_no) from Broktable Where Table_no = client2.Table_no)
  And (taxes.exchange = 'NSE')
end 
else if @Flag = 2 
begin
 update settlement set status = 'E',
 BrokApplied =(  case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then round((@brok /100 ) * settlement.marketrate,broktable.round_to)

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then round((@brok/100 )* settlement.marketrate,broktable.round_to)         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok))

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then @brok

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round((@brok/ 100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
       NetRate = (  case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then round(( settlement.marketrate + @brok),broktable.round_to)

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) )   

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then ((settlement.marketrate + round((@brok /100 )* settlement.marketrate,broktable.round_to)))

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - round((@brok /100 )* settlement.marketrate,broktable.round_to)))         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok + settlement.marketrate ))

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate ,broktable.round_to)))

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then ((  settlement.marketrate - @brok))

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/ 100) * settlement.marketrate,broktable.round_to )))

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then ((@brok + settlement.marketrate ) )

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then ((settlement.marketrate + round(( @brok/100) * settlement.marketrate,broktable.round_to )))

                        when ( settlement.SettFlag =5  and @val_perc ="V" )
                             Then (( settlement.marketrate - @brok ))

                        when ( settlement.SettFlag =5  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/100) * settlement.marketrate,broktable.round_to )))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then (( settlement.marketrate + @brok) * settlement.Tradeqty)

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) * settlement.Tradeqty)   

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then ((settlement.marketrate + round((@brok /100 )* settlement.marketrate,broktable.round_to)) * settlement.Tradeqty)

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then ((settlement.marketrate - round((@brok/100 )* settlement.marketrate,broktable.round_to)) * settlement.Tradeqty)         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok + settlement.marketrate )  * settlement.Tradeqty)

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate,broktable.round_to )) * settlement.Tradeqty)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then ((  settlement.marketrate - @brok) * settlement.Tradeqty)

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/ 100) * settlement.marketrate,broktable.round_to ))* settlement.Tradeqty)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then ((@brok + settlement.marketrate )   * settlement.Tradeqty)

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate,broktable.round_to ))  * settlement.Tradeqty)

                        when ( settlement.SettFlag =5  and @val_perc ="V" )
                             Then (( settlement.marketrate - @brok )   * settlement.Tradeqty)

                        when ( settlement.SettFlag =5  and @val_perc ="P" )
                             Then ((settlement.marketrate - round((@brok/100) * settlement.marketrate,broktable.round_to ))   * settlement.Tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 

        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              

        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 

        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              

        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),

        Service_tax = (case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V")
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 1 and @val_perc ="P")
                             Then round(((@brok/100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then round( (@brok * settlement.Tradeqty * globals.service_tax) /100,Broktable.Round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round(((@brok/ 100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then Round((@brok) * ( settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((( @brok/100) * ( settlement.marketrate  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then round( (@brok * settlement.Tradeqty * Globals.service_tax) /100,Broktable.Round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then  round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),
      Trade_amount = settlement.Tradeqty * settlement.MarketRate,
      NBrokApp = (  case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                             Then @brok

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                             Then round((@brok /100 ) * settlement.marketrate,broktable.round_to)

                        when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                             Then round((@brok/100 )* settlement.marketrate,broktable.round_to)         

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then ((@brok))

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then @brok

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round((@brok/ 100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then @brok

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then round((@brok/100) * settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
        NSertax =  (case  
                        when ( settlement.SettFlag = 1 and @val_perc ="V")
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 1 and @val_perc ="P")
                             Then round(((@brok/100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                             Then round( (@brok * settlement.Tradeqty * globals.service_tax) /100,Broktable.Round_to)

                        when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                             Then round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="V" )
                             Then round((@brok * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when (settlement.SettFlag = 3  and @val_perc ="P" )
                             Then round(((@brok/ 100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="V" )
                             Then Round((@brok) * ( settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.SettFlag = 4  and @val_perc ="P" )
                             Then round((( @brok/100) * ( settlement.marketrate  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="V" )
                             Then round( (@brok * settlement.Tradeqty * Globals.service_tax) /100,Broktable.Round_to)

                        when ( settlement.SettFlag = 5  and @val_perc ="P" )
                             Then  round(((@brok/100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),       
N_NetRate = (  case  
                   when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 1)
                   Then round(( settlement.marketrate + @brok),broktable.round_to)

                   when ( settlement.SettFlag = 1 and @val_perc ="V" and settlement.sell_buy = 2)
                   Then ((settlement.marketrate - @brok ) )   

                   when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 1)
                   Then ((settlement.marketrate + round((@brok /100 )* settlement.marketrate,broktable.round_to)))

                   when ( settlement.SettFlag = 1 and @val_perc ="P" and settlement.sell_buy = 2)
                   Then ((settlement.marketrate - round((@brok /100 )* settlement.marketrate,broktable.round_to)))         

                   when (settlement.SettFlag = 2  and @val_perc ="V" ) 
                   Then ((@brok + settlement.marketrate ))

                   when (settlement.SettFlag = 2  and @val_perc ="P" ) 
                   Then ((settlement.marketrate + round((@brok/100) * settlement.marketrate ,broktable.round_to)))

                   when (settlement.SettFlag = 3  and @val_perc ="V" )
                   Then ((  settlement.marketrate - @brok))

                   when (settlement.SettFlag = 3  and @val_perc ="P" )
                   Then ((settlement.marketrate - round((@brok/ 100) * settlement.marketrate,broktable.round_to )))

                   when ( settlement.SettFlag = 4  and @val_perc ="V" )
                   Then ((@brok + settlement.marketrate ) )

                   when ( settlement.SettFlag = 4  and @val_perc ="P" )
                   Then ((settlement.marketrate + round(( @brok/100) * settlement.marketrate,broktable.round_to )))

                   when ( settlement.SettFlag =5  and @val_perc ="V" )
                   Then (( settlement.marketrate - @brok ))

                   when ( settlement.SettFlag =5  and @val_perc ="P" )
                   Then ((settlement.marketrate - round((@brok/100) * settlement.marketrate,broktable.round_to )))

   Else  0 
          End 
                  )
  from Globals,client2,broktable,taxes
  WHERE settlement.Sett_no = @Sett_No 
  and settlement.sett_Type = @Sett_Type 
  and settlement.Party_code Like @Party_Code
  and settlement.scrip_cd like @Scrip_Cd
  and settlement.series Like @Series
  and settlement.Trade_no Like @Trade_no
  and settlement.Order_no Like @Order_no
  and settlement.MarketRate = @MarketRate
  and client2.party_code = @party_code
  And (Client2.Tran_cat = Taxes.Trans_cat)
 and Client2.Table_no = BrokTable.Table_no
 and Broktable.Line_no = ( Select min(line_no) from Broktable Where Table_no = client2.Table_no)
  And (taxes.exchange = 'NSE')
end
else If @Flag = 3
Begin
update settlement set status = 'E', NetRate = Round(@NetRate,Round_To), N_NetRate =Round(@NetRate,Round_to),
BrokApplied = Round(Abs(@NetRate - MarketRate),BrokTable.Round_To), NBrokApp = Round(Abs(@NetRate - MarketRate),BrokTable.Round_To),
Service_Tax = Round(TradeQty*Abs(@NetRate - MarketRate)*Globals.service_tax/100,BrokTable.Round_To), NSerTax = Round(TradeQty*Abs(@NetRate - MarketRate)*Globals.service_tax/100,BrokTable.Round_To),
Amount = Round(@NetRate*TradeQty,BrokTable.Round_To) 
From Client2,Globals,BrokTable
WHERE settlement.Sett_no = @Sett_No 
and settlement.sett_Type = @Sett_Type 
and settlement.Party_code Like @Party_Code
and settlement.scrip_cd like @Scrip_Cd
and settlement.series Like @Series
and settlement.Trade_no Like @Trade_no
and settlement.Order_no Like @Order_no
and client2.party_code = @party_code
and Client2.Table_no = BrokTable.Table_no
and Sell_buy = @Sell_buy
and Broktable.Line_no = ( Select min(line_no) from Broktable Where Table_no = client2.Table_no)
end
else
begin
update settlement set status = 'E', NetRate = Round(@NetRate,Round_To), N_NetRate =Round(@NetRate,Round_to),
BrokApplied = Round(Abs(@NetRate - MarketRate),BrokTable.Round_To), NBrokApp = Round(Abs(@NetRate - MarketRate),BrokTable.Round_To),
Service_Tax = Round(Abs(TradeQty*@NetRate - MarketRate)*Globals.service_tax/100,BrokTable.Round_To), NSerTax = Round(TradeQty*Abs(@NetRate - MarketRate)*Globals.service_tax/100,BrokTable.Round_To),
Amount = Round(@NetRate*TradeQty,BrokTable.Round_To) 
From Client2,Globals,BrokTable
WHERE settlement.Sett_no = @Sett_No 
and settlement.sett_Type = @Sett_Type 
and settlement.Party_code Like @Party_Code
and settlement.scrip_cd like @Scrip_Cd
and settlement.series Like @Series
and settlement.Trade_no Like @Trade_no
and settlement.Order_no Like @Order_no
and settlement.MarketRate = @MarketRate
and client2.party_code = @party_code
and Client2.Table_no = BrokTable.Table_no
and Sell_buy = @Sell_buy	
and Broktable.Line_no = ( Select min(line_no) from Broktable Where Table_no = client2.Table_no)
end

GO
