-- Object: PROCEDURE dbo.SettBrokInsEditUp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.SettBrokEditUp    Script Date: 2/7/2001 12:40:11 PM ******/
CREATE procedure SettBrokInsEditUp (@Sett_no Varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10),@Scrip_Cd Varchar(12),@series Varchar(2),@Order_No Varchar(16),@MarketRate Numeric(18,9),@Brok Numeric(18,8),@Val_Perc Varchar(1), @Flag Int) as 
if @Flag = 1 
begin
 update ISettlement set     status = 'E',
 BrokApplied = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then @Brok
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then @Brok    
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then (@Brok /100 ) * ISettlement.marketrate
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then (@Brok /100 )* ISettlement.marketrate         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then (@Brok/100) * ISettlement.marketrate 
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then @Brok
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then (@Brok/ 100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then @Brok                         
   when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then @Brok 
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   Else  0 
                        End 
                         ),
       NetRate = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then ( ( ISettlement.marketrate + @Brok))
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - @Brok ) )   
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then ((ISettlement.marketrate + ((@Brok /100 )* ISettlement.marketrate)))
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - ((@Brok /100 )* ISettlement.marketrate)))         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok + ISettlement.marketrate ))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((ISettlement.marketrate + ((@Brok/100) * ISettlement.marketrate )))
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((  ISettlement.marketrate - @Brok))
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/ 100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok + ISettlement.marketrate ) )
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate + (( @Brok/100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag =5  and @Val_perc ="V" )
                             Then (( ISettlement.marketrate - @Brok ))
                        when ( ISettlement.SettFlag =5  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/100) * ISettlement.marketrate )))
   Else  0 
                        End 
                         ),
       Amount =  (case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then (( ISettlement.marketrate + @Brok) * ISettlement.Tradeqty)
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - @Brok   ) * ISettlement.Tradeqty)   
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then ((ISettlement.marketrate + ((@Brok /100 )* ISettlement.marketrate)) * ISettlement.Tradeqty)
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - ((@Brok /100 )* ISettlement.marketrate)) * ISettlement.Tradeqty)         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok + ISettlement.marketrate )  * ISettlement.Tradeqty)
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((ISettlement.marketrate + ((@Brok/100) * ISettlement.marketrate )) * ISettlement.Tradeqty)
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((  ISettlement.marketrate - @Brok) * ISettlement.Tradeqty)
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/ 100) * ISettlement.marketrate ))* ISettlement.Tradeqty)
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok + ISettlement.marketrate )   * ISettlement.Tradeqty)
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate + (( @Brok/100) * ISettlement.marketrate ))  * ISettlement.Tradeqty)
   when ( ISettlement.SettFlag =5  and @Val_perc ="V" )
                             Then (( ISettlement.marketrate - @Brok )   * ISettlement.Tradeqty)
                        when ( ISettlement.SettFlag =5  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/100) * ISettlement.marketrate ))   * ISettlement.Tradeqty)
   Else  0 
                        End 
                         ),
 Service_tax = (case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V")
                             Then (@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100
                        when (ISettlement.SettFlag = 1 and @Val_perc ="P")
                             Then ((@Brok /100 ) * (ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ( (@Brok * ISettlement.Tradeqty * globals.service_tax) /100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * Globals.service_tax) / 100)
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100)
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((@Brok/ 100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok) * ( ISettlement.Tradeqty * Globals.service_tax) / 100)
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (( @Brok/100) * ( ISettlement.marketrate  * ISettlement.Tradeqty * Globals.service_tax)/100 )
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then ( (@Brok * ISettlement.Tradeqty * Globals.service_tax) /100)
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then  ( (@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax)  /100)
   Else  0 
                        End 
                         ),
      Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,
      NBrokApp = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then @Brok
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then @Brok    
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then (@Brok /100 ) * ISettlement.marketrate
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then (@Brok /100 )* ISettlement.marketrate         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then (@Brok/100) * ISettlement.marketrate 
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then @Brok
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then (@Brok/ 100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then @Brok                         
   when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then @Brok 
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   Else  0 
                        End 
                         ),
        NSertax = (case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V")
                             Then (@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100
                        when (ISettlement.SettFlag = 1 and @Val_perc ="P")
                             Then ((@Brok /100 ) * (ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ( (@Brok * ISettlement.Tradeqty * globals.service_tax) /100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * Globals.service_tax) / 100)
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100)
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((@Brok/ 100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok) * ( ISettlement.Tradeqty * Globals.service_tax) / 100)
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (( @Brok/100) * ( ISettlement.marketrate  * ISettlement.Tradeqty * Globals.service_tax)/100 )
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then ( (@Brok * ISettlement.Tradeqty * Globals.service_tax) /100)
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then  ( (@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax)  /100)
   Else  0 
                        End 
                         ),       
N_NetRate = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then ( ( ISettlement.marketrate + @Brok))
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - @Brok ) )   
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then ((ISettlement.marketrate + ((@Brok /100 )* ISettlement.marketrate)))
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - ((@Brok /100 )* ISettlement.marketrate)))         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok + ISettlement.marketrate ))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((ISettlement.marketrate + ((@Brok/100) * ISettlement.marketrate )))
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((  ISettlement.marketrate - @Brok))
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/ 100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok + ISettlement.marketrate ) )
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate + (( @Brok/100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag =5  and @Val_perc ="V" )
                             Then (( ISettlement.marketrate - @Brok ))
                        when ( ISettlement.SettFlag =5  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/100) * ISettlement.marketrate )))
   Else  0 
                        End 
                         )
from Globals
  WHERE ISettlement.Sett_no = @Sett_No 
  and ISettlement.sett_Type = @Sett_Type 
  and ISettlement.Party_code Like @Party_Code
  and ISettlement.scrip_cd like @Scrip_Cd
  and ISettlement.series Like @Series
  and ISettlement.Order_no Like @Order_no
end 
else
begin
 update ISettlement set     status = 'E',
 BrokApplied = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then @Brok
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then @Brok    
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then (@Brok /100 ) * ISettlement.marketrate
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then (@Brok /100 )* ISettlement.marketrate         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then (@Brok/100) * ISettlement.marketrate 
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then @Brok
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then (@Brok/ 100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then @Brok                         
   when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then @Brok 
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   Else  0 
                        End 
                         ),
       NetRate = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then ( ( ISettlement.marketrate + @Brok))
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - @Brok ) )   
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then ((ISettlement.marketrate + ((@Brok /100 )* ISettlement.marketrate)))
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - ((@Brok /100 )* ISettlement.marketrate)))         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok + ISettlement.marketrate ))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((ISettlement.marketrate + ((@Brok/100) * ISettlement.marketrate )))
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((  ISettlement.marketrate - @Brok))
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/ 100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok + ISettlement.marketrate ) )
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate + (( @Brok/100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag =5  and @Val_perc ="V" )
                             Then (( ISettlement.marketrate - @Brok ))
                        when ( ISettlement.SettFlag =5  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/100) * ISettlement.marketrate )))
   Else  0 
                        End 
                         ),
       Amount =  (case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then (( ISettlement.marketrate + @Brok) * ISettlement.Tradeqty)
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - @Brok   ) * ISettlement.Tradeqty)   
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then ((ISettlement.marketrate + ((@Brok /100 )* ISettlement.marketrate)) * ISettlement.Tradeqty)
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - ((@Brok /100 )* ISettlement.marketrate)) * ISettlement.Tradeqty)         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok + ISettlement.marketrate )  * ISettlement.Tradeqty)
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((ISettlement.marketrate + ((@Brok/100) * ISettlement.marketrate )) * ISettlement.Tradeqty)
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((  ISettlement.marketrate - @Brok) * ISettlement.Tradeqty)
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/ 100) * ISettlement.marketrate ))* ISettlement.Tradeqty)
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok + ISettlement.marketrate )   * ISettlement.Tradeqty)
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate + (( @Brok/100) * ISettlement.marketrate ))  * ISettlement.Tradeqty)
   when ( ISettlement.SettFlag =5  and @Val_perc ="V" )
                             Then (( ISettlement.marketrate - @Brok )   * ISettlement.Tradeqty)
                        when ( ISettlement.SettFlag =5  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/100) * ISettlement.marketrate ))   * ISettlement.Tradeqty)
   Else  0 
                        End 
                         ),
 Service_tax = (case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V")
                             Then (@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100
                        when (ISettlement.SettFlag = 1 and @Val_perc ="P")
                             Then ((@Brok /100 ) * (ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ( (@Brok * ISettlement.Tradeqty * globals.service_tax) /100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * Globals.service_tax) / 100)
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100)
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((@Brok/ 100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok) * ( ISettlement.Tradeqty * Globals.service_tax) / 100)
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (( @Brok/100) * ( ISettlement.marketrate  * ISettlement.Tradeqty * Globals.service_tax)/100 )
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then ( (@Brok * ISettlement.Tradeqty * Globals.service_tax) /100)
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then  ( (@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax)  /100)
   Else  0 
                        End 
                         ),
      Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,
      NBrokApp = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then @Brok
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then @Brok    
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then (@Brok /100 ) * ISettlement.marketrate
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then (@Brok /100 )* ISettlement.marketrate         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then (@Brok/100) * ISettlement.marketrate 
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then @Brok
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then (@Brok/ 100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then @Brok                         
   when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then @Brok 
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then (@Brok/100) * ISettlement.marketrate 
   Else  0 
                        End 
                         ),
        NSertax = (case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V")
                             Then (@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100
                        when (ISettlement.SettFlag = 1 and @Val_perc ="P")
                             Then ((@Brok /100 ) * (ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ( (@Brok * ISettlement.Tradeqty * globals.service_tax) /100)
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * Globals.service_tax) / 100)
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((@Brok * ISettlement.Tradeqty * Globals.service_tax) / 100)
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((@Brok/ 100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax) / 100)
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok) * ( ISettlement.Tradeqty * Globals.service_tax) / 100)
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then (( @Brok/100) * ( ISettlement.marketrate  * ISettlement.Tradeqty * Globals.service_tax)/100 )
   when ( ISettlement.SettFlag = 5  and @Val_perc ="V" )
                             Then ( (@Brok * ISettlement.Tradeqty * Globals.service_tax) /100)
                        when ( ISettlement.SettFlag = 5  and @Val_perc ="P" )
                             Then  ( (@Brok/100) * ( ISettlement.marketrate * ISettlement.Tradeqty * globals.service_tax)  /100)
   Else  0 
                        End 
                         ),       
N_NetRate = (  case  
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 1)
                             Then ( ( ISettlement.marketrate + @Brok))
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="V" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - @Brok ) )   
                        when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 1)
                             Then ((ISettlement.marketrate + ((@Brok /100 )* ISettlement.marketrate)))
   when ( ISettlement.SettFlag = 1 and @Val_perc ="P" and ISettlement.sell_buy = 2)
                             Then ((ISettlement.marketrate - ((@Brok /100 )* ISettlement.marketrate)))         
   when (ISettlement.SettFlag = 2  and @Val_perc ="V" ) 
                             Then ((@Brok + ISettlement.marketrate ))
   when (ISettlement.SettFlag = 2  and @Val_perc ="P" ) 
                             Then ((ISettlement.marketrate + ((@Brok/100) * ISettlement.marketrate )))
          when (ISettlement.SettFlag = 3  and @Val_perc ="V" )
                             Then ((  ISettlement.marketrate - @Brok))
   when (ISettlement.SettFlag = 3  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/ 100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag = 4  and @Val_perc ="V" )
                             Then ((@Brok + ISettlement.marketrate ) )
                        when ( ISettlement.SettFlag = 4  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate + (( @Brok/100) * ISettlement.marketrate )))
   when ( ISettlement.SettFlag =5  and @Val_perc ="V" )
                             Then (( ISettlement.marketrate - @Brok ))
                        when ( ISettlement.SettFlag =5  and @Val_perc ="P" )
                             Then ((ISettlement.marketrate - ((@Brok/100) * ISettlement.marketrate )))
   Else  0 
                        End 
                         )
from Globals
  WHERE ISettlement.Sett_no = @Sett_No 
  and ISettlement.sett_Type = @Sett_Type 
  and ISettlement.Party_code Like @Party_Code
  and ISettlement.scrip_cd like @Scrip_Cd
  and ISettlement.series Like @Series
  and ISettlement.Order_no Like @Order_no
  and ISettlement.MarketRate = @MarketRate
end

GO
