-- Object: PROCEDURE dbo.Settbrokinseditup
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure Dbo.settbrokinseditup    Script Date: 01/15/2005 1:17:13 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokinseditup    Script Date: 12/16/2003 2:31:26 Pm ******/



/****** Object:  Stored Procedure Dbo.settbrokinseditup    Script Date: 05/08/2002 12:35:23 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokinseditup    Script Date: 01/14/2002 20:33:21 ******/



/****** Object:  Stored Procedure Dbo.settbrokinseditup    Script Date: 09/27/2001 4:27:23 Pm ******/


/* Recent Changes Done By Vaishali On 20/08/2001 Added Dummy2 And Sauda Date Parameters.*/
Create Procedure Settbrokinseditup (@sett_no Varchar(7),@sett_type Varchar(2),@party_code Varchar(10),@scrip_cd Varchar(12),
   @series Varchar(2),@trade_no Varchar(16), @order_no Varchar(16),@marketrate Numeric(18,9),@brok Numeric(18,8),
   @val_perc Varchar(1),@sell_buy Int,@netrate Numeric(18,9),@saudadate Varchar(12), @dummy2 Varchar(2), @flag Int) As 
If @flag = 1 
Begin
 Update Isettlement Set Status = 'e',
 Brokapplied =(  Case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Isettlement.marketrate,broktable.round_to)

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then Round((@brok/100 )* Isettlement.marketrate,broktable.round_to)         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
       Netrate = (  Case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then Round(( Isettlement.marketrate + @brok),broktable.round_to)

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - @brok ) )   

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then ((isettlement.marketrate + Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Isettlement.marketrate ))

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)))

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Isettlement.marketrate - @brok))

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/ 100) * Isettlement.marketrate,broktable.round_to )))

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Isettlement.marketrate ) )

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then ((isettlement.marketrate + Round(( @brok/100) * Isettlement.marketrate,broktable.round_to )))

                        When ( Isettlement.settflag =5  And @val_perc ="v" )
                             Then (( Isettlement.marketrate - @brok ))

                        When ( Isettlement.settflag =5  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/100) * Isettlement.marketrate,broktable.round_to )))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then (( Isettlement.marketrate + @brok) * Isettlement.tradeqty)

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - @brok ) * Isettlement.tradeqty)   

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then ((isettlement.marketrate + Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)) * Isettlement.tradeqty)

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - Round((@brok/100 )* Isettlement.marketrate,broktable.round_to)) * Isettlement.tradeqty)         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Isettlement.marketrate )  * Isettlement.tradeqty)

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate,broktable.round_to )) * Isettlement.tradeqty)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Isettlement.marketrate - @brok) * Isettlement.tradeqty)

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/ 100) * Isettlement.marketrate,broktable.round_to ))* Isettlement.tradeqty)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Isettlement.marketrate )   * Isettlement.tradeqty)

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate,broktable.round_to ))  * Isettlement.tradeqty)

                        When ( Isettlement.settflag =5  And @val_perc ="v" )
                             Then (( Isettlement.marketrate - @brok )   * Isettlement.tradeqty)

                        When ( Isettlement.settflag =5  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/100) * Isettlement.marketrate,broktable.round_to ))   * Isettlement.tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = Round(((taxes.insurance_chrg * Isettlement.marketrate * Isettlement.tradeqty)/100),broktable.round_to), 

        Turn_tax  = Round(((taxes.turnover_tax * Isettlement.marketrate * Isettlement.tradeqty)/100 ),broktable.round_to),              

        Other_chrg = Round(((taxes.other_chrg * Isettlement.marketrate * Isettlement.tradeqty)/100 ),broktable.round_to), 

        Sebi_tax = Round(((taxes.sebiturn_tax * Isettlement.marketrate * Isettlement.tradeqty)/100),broktable.round_to),              

        Broker_chrg = Round(((taxes.broker_note * Isettlement.marketrate * Isettlement.tradeqty)/100),broktable.round_to),

        Service_tax = (case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Isettlement.marketrate  * Isettlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),
      Trade_amount = Isettlement.tradeqty * Isettlement.marketrate,
      Nbrokapp = (  Case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Isettlement.marketrate,broktable.round_to)

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then Round((@brok/100 )* Isettlement.marketrate,broktable.round_to)         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
        Nsertax =  (case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Isettlement.marketrate  * Isettlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),       
N_netrate = (  Case  
                   When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                   Then Round(( Isettlement.marketrate + @brok),broktable.round_to)

                   When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                   Then ((isettlement.marketrate - @brok ) )   

                   When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                   Then ((isettlement.marketrate + Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))

                   When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                   Then ((isettlement.marketrate - Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))         

                   When (isettlement.settflag = 2  And @val_perc ="v" ) 
                   Then ((@brok + Isettlement.marketrate ))

                   When (isettlement.settflag = 2  And @val_perc ="p" ) 
                   Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)))

                   When (isettlement.settflag = 3  And @val_perc ="v" )
                   Then ((  Isettlement.marketrate - @brok))

                   When (isettlement.settflag = 3  And @val_perc ="p" )
                   Then ((isettlement.marketrate - Round((@brok/ 100) * Isettlement.marketrate,broktable.round_to )))

                   When ( Isettlement.settflag = 4  And @val_perc ="v" )
                   Then ((@brok + Isettlement.marketrate ) )

                   When ( Isettlement.settflag = 4  And @val_perc ="p" )
                   Then ((isettlement.marketrate + Round(( @brok/100) * Isettlement.marketrate,broktable.round_to )))

                   When ( Isettlement.settflag =5  And @val_perc ="v" )
                   Then (( Isettlement.marketrate - @brok ))

                   When ( Isettlement.settflag =5  And @val_perc ="p" )
                   Then ((isettlement.marketrate - Round((@brok/100) * Isettlement.marketrate,broktable.round_to )))

   Else  0 
          End 
                  )
  From Globals,client2,broktable,taxes
  Where Isettlement.sett_no = @sett_no 
  And Isettlement.sett_type = @sett_type 
  And Isettlement.party_code Like @party_code
  And Isettlement.scrip_cd Like @scrip_cd
  And Isettlement.series Like @series
  And Isettlement.order_no Like @order_no
  And Isettlement.trade_no Like @trade_no
  And Client2.party_code = @party_code
  And Isettlement.sauda_date Like @saudadate + '%' /* Added By Vaishali On 20/08/2001*/
  And Isettlement.dummy2 = @dummy2 /* Added By Vaishali On 20/08/2001*/
  And (client2.tran_cat = Taxes.trans_cat)
 And Client2.table_no = Broktable.table_no
 And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
  And (taxes.exchange = 'nse')
End 
Else If @flag = 2 
Begin
 Update Isettlement Set Status = 'e',
 Brokapplied =(  Case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Isettlement.marketrate,broktable.round_to)

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then Round((@brok/100 )* Isettlement.marketrate,broktable.round_to)         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
       Netrate = (  Case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then Round(( Isettlement.marketrate + @brok),broktable.round_to)

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - @brok ) )   

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then ((isettlement.marketrate + Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Isettlement.marketrate ))

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)))

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Isettlement.marketrate - @brok))

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/ 100) * Isettlement.marketrate,broktable.round_to )))

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Isettlement.marketrate ) )

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then ((isettlement.marketrate + Round(( @brok/100) * Isettlement.marketrate,broktable.round_to )))

                        When ( Isettlement.settflag =5  And @val_perc ="v" )
                             Then (( Isettlement.marketrate - @brok ))

                        When ( Isettlement.settflag =5  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/100) * Isettlement.marketrate,broktable.round_to )))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then (( Isettlement.marketrate + @brok) * Isettlement.tradeqty)

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - @brok ) * Isettlement.tradeqty)   

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then ((isettlement.marketrate + Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)) * Isettlement.tradeqty)

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then ((isettlement.marketrate - Round((@brok/100 )* Isettlement.marketrate,broktable.round_to)) * Isettlement.tradeqty)         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Isettlement.marketrate )  * Isettlement.tradeqty)

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate,broktable.round_to )) * Isettlement.tradeqty)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Isettlement.marketrate - @brok) * Isettlement.tradeqty)

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/ 100) * Isettlement.marketrate,broktable.round_to ))* Isettlement.tradeqty)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Isettlement.marketrate )   * Isettlement.tradeqty)

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate,broktable.round_to ))  * Isettlement.tradeqty)

                        When ( Isettlement.settflag =5  And @val_perc ="v" )
                             Then (( Isettlement.marketrate - @brok )   * Isettlement.tradeqty)

                        When ( Isettlement.settflag =5  And @val_perc ="p" )
                             Then ((isettlement.marketrate - Round((@brok/100) * Isettlement.marketrate,broktable.round_to ))   * Isettlement.tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = Round(((taxes.insurance_chrg * Isettlement.marketrate * Isettlement.tradeqty)/100),broktable.round_to), 

        Turn_tax  = Round(((taxes.turnover_tax * Isettlement.marketrate * Isettlement.tradeqty)/100 ),broktable.round_to),              

        Other_chrg = Round(((taxes.other_chrg * Isettlement.marketrate * Isettlement.tradeqty)/100 ),broktable.round_to), 

        Sebi_tax = Round(((taxes.sebiturn_tax * Isettlement.marketrate * Isettlement.tradeqty)/100),broktable.round_to),              

        Broker_chrg = Round(((taxes.broker_note * Isettlement.marketrate * Isettlement.tradeqty)/100),broktable.round_to),

        Service_tax = (case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Isettlement.marketrate  * Isettlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),
      Trade_amount = Isettlement.tradeqty * Isettlement.marketrate,
      Nbrokapp = (  Case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                             Then @brok

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Isettlement.marketrate,broktable.round_to)

                        When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                             Then Round((@brok/100 )* Isettlement.marketrate,broktable.round_to)         

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
        Nsertax =  (case  
                        When ( Isettlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (isettlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (isettlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Isettlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Isettlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Isettlement.marketrate  * Isettlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Isettlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Isettlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Isettlement.marketrate * Isettlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),       
N_netrate = (  Case  
                   When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 1)
                   Then Round(( Isettlement.marketrate + @brok),broktable.round_to)

                   When ( Isettlement.settflag = 1 And @val_perc ="v" And Isettlement.sell_buy = 2)
                   Then ((isettlement.marketrate - @brok ) )   

                   When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 1)
                   Then ((isettlement.marketrate + Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))

                   When ( Isettlement.settflag = 1 And @val_perc ="p" And Isettlement.sell_buy = 2)
                   Then ((isettlement.marketrate - Round((@brok /100 )* Isettlement.marketrate,broktable.round_to)))         

                   When (isettlement.settflag = 2  And @val_perc ="v" ) 
                   Then ((@brok + Isettlement.marketrate ))

                   When (isettlement.settflag = 2  And @val_perc ="p" ) 
                   Then ((isettlement.marketrate + Round((@brok/100) * Isettlement.marketrate ,broktable.round_to)))

                   When (isettlement.settflag = 3  And @val_perc ="v" )
                   Then ((  Isettlement.marketrate - @brok))

                   When (isettlement.settflag = 3  And @val_perc ="p" )
                   Then ((isettlement.marketrate - Round((@brok/ 100) * Isettlement.marketrate,broktable.round_to )))

                   When ( Isettlement.settflag = 4  And @val_perc ="v" )
                   Then ((@brok + Isettlement.marketrate ) )

                   When ( Isettlement.settflag = 4  And @val_perc ="p" )
                   Then ((isettlement.marketrate + Round(( @brok/100) * Isettlement.marketrate,broktable.round_to )))

                   When ( Isettlement.settflag =5  And @val_perc ="v" )
                   Then (( Isettlement.marketrate - @brok ))

                   When ( Isettlement.settflag =5  And @val_perc ="p" )
                   Then ((isettlement.marketrate - Round((@brok/100) * Isettlement.marketrate,broktable.round_to )))

   Else  0 
          End 
                  )
  From Globals,client2,broktable,taxes
  Where Isettlement.sett_no = @sett_no 
  And Isettlement.sett_type = @sett_type 
  And Isettlement.party_code Like @party_code
  And Isettlement.scrip_cd Like @scrip_cd
  And Isettlement.series Like @series
  And Isettlement.order_no Like @order_no
  And Isettlement.trade_no Like @trade_no
  And Isettlement.marketrate = @marketrate
  And Isettlement.sauda_date Like @saudadate + '%' /* Added By Vaishali On 20/08/2001*/
  And Isettlement.dummy2 = @dummy2 /* Added By Vaishali On 20/08/2001*/
  And Client2.party_code = @party_code
  And (client2.tran_cat = Taxes.trans_cat)
 And Client2.table_no = Broktable.table_no
 And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
  And (taxes.exchange = 'nse')
End
/* Else If @flag = 3 
Begin
Update Isettlement Set Status = 'e', Netrate = ( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End ), 
N_netrate = ( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End ), 
Brokapplied = Round((abs(@netrate - Marketrate)*100/105),round_to),
Nbrokapp = Round((abs(@netrate - Marketrate)*100/105),round_to),
Service_tax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Nsertax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Amount = Round(( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End )*tradeqty,broktable.round_to) 

From Client2,globals,broktable
Where Isettlement.sett_no = @sett_no 
And Isettlement.sett_type = @sett_type 
And Isettlement.party_code Like @party_code
And Isettlement.scrip_cd Like @scrip_cd
And Isettlement.series Like @series
And Isettlement.order_no Like @order_no
And Isettlement.trade_no Like @trade_no
And Isettlement.sauda_date Like @saudadate + '%' 
And Isettlement.dummy2 = @dummy2 
And Client2.party_code = @party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End
*/
Else If @flag = 3
Begin
Update Isettlement Set Status = 'e', Netrate = Round(@netrate,round_to), N_netrate =round(@netrate,round_to),
Brokapplied = Round((abs(@netrate - Marketrate)*100/105),round_to),
Nbrokapp = Round((abs(@netrate - Marketrate)*100/105),round_to),
Service_tax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Nsertax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Amount = Round(( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End )*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Isettlement.sett_no = @sett_no 
And Isettlement.sett_type = @sett_type 
And Isettlement.party_code Like @party_code
And Isettlement.scrip_cd Like @scrip_cd
And Isettlement.series Like @series
And Isettlement.order_no Like @order_no
And Isettlement.trade_no Like @trade_no
And Isettlement.sauda_date Like @saudadate + '%'
And Isettlement.dummy2 = @dummy2 
And Client2.party_code = Isettlement.party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy	
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End

Else If @flag = 4  /* Inclusive Of Service Tax */
Begin
Update Isettlement Set Status = 'e', Netrate = ( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End ), 
N_netrate = ( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End ), 
Brokapplied = Round((abs(@netrate - Marketrate)*100/105),round_to),
Nbrokapp = Round((abs(@netrate - Marketrate)*100/105),round_to),
Service_tax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Nsertax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Amount = Round(( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End )*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Isettlement.sett_no = @sett_no 
And Isettlement.sett_type = @sett_type 
And Isettlement.party_code Like @party_code
And Isettlement.scrip_cd Like @scrip_cd
And Isettlement.series Like @series
And Isettlement.order_no Like @order_no
And Isettlement.trade_no Like @trade_no
And Isettlement.marketrate = @marketrate
And Isettlement.sauda_date Like @saudadate + '%' /* Added By Vaishali On 20/08/2001*/
And Isettlement.dummy2 = @dummy2 /* Added By Vaishali On 20/08/2001*/
And Client2.party_code = @party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy	
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End
Else If @flag = 5  /* Exclusive Of Service Tax */
Begin
Update Isettlement Set Status = 'e', Netrate = Round(@netrate,round_to), N_netrate =round(@netrate,round_to),
Brokapplied = Round(abs(@netrate - Marketrate),broktable.round_to), Nbrokapp = Round(abs(@netrate - Marketrate),broktable.round_to),
Service_tax = Round(abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to), Nsertax = Round(abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to),
Amount = Round(@netrate*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Isettlement.sett_no = @sett_no 
And Isettlement.sett_type = @sett_type 
And Isettlement.party_code Like @party_code
And Isettlement.scrip_cd Like @scrip_cd
And Isettlement.series Like @series
And Isettlement.order_no Like @order_no
And Isettlement.trade_no Like @trade_no
And Isettlement.sauda_date Like @saudadate + '%' /* Added By Vaishali On 20/08/2001*/
And Isettlement.dummy2 = @dummy2 /* Added By Vaishali On 20/08/2001*/
And Client2.party_code = @party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy	
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End
Else If @flag = 6 /* Exclusive Of Service Tax */
Begin
Update Isettlement Set Status = 'e', Netrate = Round(@netrate,round_to), N_netrate =round(@netrate,round_to),
Brokapplied = Round(abs(@netrate - Marketrate),broktable.round_to), Nbrokapp = Round(abs(@netrate - Marketrate),broktable.round_to),
Service_tax = Round(abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to), Nsertax = Round(abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to),
Amount = Round(@netrate*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Isettlement.sett_no = @sett_no 
And Isettlement.sett_type = @sett_type 
And Isettlement.party_code Like @party_code
And Isettlement.scrip_cd Like @scrip_cd
And Isettlement.series Like @series
And Isettlement.order_no Like @order_no
And Isettlement.trade_no Like @trade_no
And Isettlement.marketrate = @marketrate
And Isettlement.sauda_date Like @saudadate + '%' /* Added By Vaishali On 20/08/2001*/
And Isettlement.dummy2 = @dummy2 /* Added By Vaishali On 20/08/2001*/
And Client2.party_code = @party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy	
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End
/* Else If @flag = 7
Begin
Update Isettlement Set Status = 'e', Netrate = Round(@netrate,round_to), N_netrate =round(@netrate,round_to),
Brokapplied = Round((abs(@netrate - Marketrate)*100/105),round_to),
Nbrokapp = Round((abs(@netrate - Marketrate)*100/105),round_to),
Service_tax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Nsertax = Round(tradeqty*round(abs(@netrate - Marketrate) - Round((abs(@netrate - Marketrate)*100/105),round_to),round_to),round_to),
Amount = Round(( Case When Sell_buy = 1 Then
Round(marketrate + Round((abs(@netrate - Marketrate)*100/105),round_to),4) 
Else
Round(marketrate - Round((abs(@netrate - Marketrate)*100/105),round_to),4)  End )*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Isettlement.sett_no = @sett_no 
And Isettlement.sett_type = @sett_type 
And Isettlement.party_code Like @party_code
And Isettlement.scrip_cd Like @scrip_cd
And Isettlement.series Like @series
And Isettlement.order_no Like @order_no
And Isettlement.trade_no Like @trade_no
And Isettlement.sauda_date Like @saudadate + '%'
And Isettlement.dummy2 = @dummy2 
And Client2.party_code = Isettlement.party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy	
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End
*/

GO
