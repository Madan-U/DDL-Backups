-- Object: PROCEDURE dbo.Settbrokeditup
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 01/15/2005 1:17:06 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 12/16/2003 2:31:26 Pm ******/



/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 05/08/2002 12:35:23 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 01/14/2002 20:33:21 ******/






/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 09/07/2001 11:09:32 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 7/1/01 2:26:55 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 06/26/2001 8:49:40 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 3/30/01 2:45:03 Pm ******/


/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 3/15/01 10:10:13 Am ******/

/****** Object:  Stored Procedure Dbo.settbrokeditup    Script Date: 22-feb-01 7:48:15 Pm ******/


Create Procedure Settbrokeditup (@sett_no Varchar(7),@sett_type Varchar(2),@party_code Varchar(10),@scrip_cd Varchar(12),@series Varchar(2),@trade_no Varchar(14),@order_no Varchar(16),@marketrate Numeric(18,9),@brok Numeric(18,8),@val_perc Varchar(1),@sell_buy Int,@netrate Numeric(18,9), @flag Int) As 
If @flag = 1 
Begin
 Update Settlement Set Status = 'e',
 Brokapplied =(  Case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Settlement.marketrate,broktable.round_to)

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then Round((@brok/100 )* Settlement.marketrate,broktable.round_to)         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
       Netrate = (  Case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then Round(( Settlement.marketrate + @brok),broktable.round_to)

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) )   

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then ((settlement.marketrate + Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Settlement.marketrate ))

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate ,broktable.round_to)))

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Settlement.marketrate - @brok))

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/ 100) * Settlement.marketrate,broktable.round_to )))

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Settlement.marketrate ) )

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then ((settlement.marketrate + Round(( @brok/100) * Settlement.marketrate,broktable.round_to )))

                        When ( Settlement.settflag =5  And @val_perc ="v" )
                             Then (( Settlement.marketrate - @brok ))

                        When ( Settlement.settflag =5  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/100) * Settlement.marketrate,broktable.round_to )))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then (( Settlement.marketrate + @brok) * Settlement.tradeqty)

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) * Settlement.tradeqty)   

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then ((settlement.marketrate + Round((@brok /100 )* Settlement.marketrate,broktable.round_to)) * Settlement.tradeqty)

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - Round((@brok/100 )* Settlement.marketrate,broktable.round_to)) * Settlement.tradeqty)         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Settlement.marketrate )  * Settlement.tradeqty)

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate,broktable.round_to )) * Settlement.tradeqty)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Settlement.marketrate - @brok) * Settlement.tradeqty)

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/ 100) * Settlement.marketrate,broktable.round_to ))* Settlement.tradeqty)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Settlement.marketrate )   * Settlement.tradeqty)

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate,broktable.round_to ))  * Settlement.tradeqty)

                        When ( Settlement.settflag =5  And @val_perc ="v" )
                             Then (( Settlement.marketrate - @brok )   * Settlement.tradeqty)

                        When ( Settlement.settflag =5  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/100) * Settlement.marketrate,broktable.round_to ))   * Settlement.tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = Round(((taxes.insurance_chrg * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to), 

        Turn_tax  = Round(((taxes.turnover_tax * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to),              

        Other_chrg = Round(((taxes.other_chrg * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to), 

        Sebi_tax = Round(((taxes.sebiturn_tax * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),              

        Broker_chrg = Round(((taxes.broker_note * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),

        Service_tax = (case  
                        When ( Settlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Settlement.marketrate  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),
      Trade_amount = Settlement.tradeqty * Settlement.marketrate,
      Nbrokapp = (  Case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Settlement.marketrate,broktable.round_to)

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then Round((@brok/100 )* Settlement.marketrate,broktable.round_to)         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
        Nsertax =  (case  
                        When ( Settlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Settlement.marketrate  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),       
N_netrate = (  Case  
                   When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                   Then Round(( Settlement.marketrate + @brok),broktable.round_to)

                   When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                   Then ((settlement.marketrate - @brok ) )   

                   When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                   Then ((settlement.marketrate + Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))

                   When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                   Then ((settlement.marketrate - Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))         

                   When (settlement.settflag = 2  And @val_perc ="v" ) 
                   Then ((@brok + Settlement.marketrate ))

                   When (settlement.settflag = 2  And @val_perc ="p" ) 
                   Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate ,broktable.round_to)))

                   When (settlement.settflag = 3  And @val_perc ="v" )
                   Then ((  Settlement.marketrate - @brok))

                   When (settlement.settflag = 3  And @val_perc ="p" )
                   Then ((settlement.marketrate - Round((@brok/ 100) * Settlement.marketrate,broktable.round_to )))

                   When ( Settlement.settflag = 4  And @val_perc ="v" )
                   Then ((@brok + Settlement.marketrate ) )

                   When ( Settlement.settflag = 4  And @val_perc ="p" )
                   Then ((settlement.marketrate + Round(( @brok/100) * Settlement.marketrate,broktable.round_to )))

                   When ( Settlement.settflag =5  And @val_perc ="v" )
                   Then (( Settlement.marketrate - @brok ))

                   When ( Settlement.settflag =5  And @val_perc ="p" )
                   Then ((settlement.marketrate - Round((@brok/100) * Settlement.marketrate,broktable.round_to )))

   Else  0 
          End 
                  )
  From Globals,client2,broktable,taxes,client1
  Where Settlement.sett_no = @sett_no 
  And Settlement.sett_type = @sett_type 
  And Settlement.party_code Like @party_code
  And Settlement.scrip_cd Like @scrip_cd
  And Settlement.series Like @series
  And Settlement.trade_no Like @trade_no
  And Settlement.order_no Like @order_no
  And Client2.party_code = @party_code
  And Client1.cl_code = Client2.cl_code
/*  And (client2.tran_cat = Taxes.trans_cat) */
  And Taxes.trans_cat  = (case When Cl_type = 'pro' Then 'pro' Else Client2.tran_cat End )
 And Client2.table_no = Broktable.table_no
 And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
  And (taxes.exchange = 'nse')
End 
Else If @flag = 2 
Begin
 Update Settlement Set Status = 'e',
 Brokapplied =(  Case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Settlement.marketrate,broktable.round_to)

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then Round((@brok/100 )* Settlement.marketrate,broktable.round_to)         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
       Netrate = (  Case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then Round(( Settlement.marketrate + @brok),broktable.round_to)

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) )   

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then ((settlement.marketrate + Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Settlement.marketrate ))

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate ,broktable.round_to)))

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Settlement.marketrate - @brok))

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/ 100) * Settlement.marketrate,broktable.round_to )))

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Settlement.marketrate ) )

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then ((settlement.marketrate + Round(( @brok/100) * Settlement.marketrate,broktable.round_to )))

                        When ( Settlement.settflag =5  And @val_perc ="v" )
                             Then (( Settlement.marketrate - @brok ))

                        When ( Settlement.settflag =5  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/100) * Settlement.marketrate,broktable.round_to )))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then (( Settlement.marketrate + @brok) * Settlement.tradeqty)

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - @brok ) * Settlement.tradeqty)   

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then ((settlement.marketrate + Round((@brok /100 )* Settlement.marketrate,broktable.round_to)) * Settlement.tradeqty)

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then ((settlement.marketrate - Round((@brok/100 )* Settlement.marketrate,broktable.round_to)) * Settlement.tradeqty)         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok + Settlement.marketrate )  * Settlement.tradeqty)

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate,broktable.round_to )) * Settlement.tradeqty)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then ((  Settlement.marketrate - @brok) * Settlement.tradeqty)

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/ 100) * Settlement.marketrate,broktable.round_to ))* Settlement.tradeqty)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then ((@brok + Settlement.marketrate )   * Settlement.tradeqty)

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate,broktable.round_to ))  * Settlement.tradeqty)

                        When ( Settlement.settflag =5  And @val_perc ="v" )
                             Then (( Settlement.marketrate - @brok )   * Settlement.tradeqty)

                        When ( Settlement.settflag =5  And @val_perc ="p" )
                             Then ((settlement.marketrate - Round((@brok/100) * Settlement.marketrate,broktable.round_to ))   * Settlement.tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = Round(((taxes.insurance_chrg * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to), 

        Turn_tax  = Round(((taxes.turnover_tax * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to),              

        Other_chrg = Round(((taxes.other_chrg * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to), 

        Sebi_tax = Round(((taxes.sebiturn_tax * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),              

        Broker_chrg = Round(((taxes.broker_note * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),

        Service_tax = (case  
                        When ( Settlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Settlement.marketrate  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),
      Trade_amount = Settlement.tradeqty * Settlement.marketrate,
      Nbrokapp = (  Case  
                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                             Then @brok

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                             Then Round((@brok /100 ) * Settlement.marketrate,broktable.round_to)

                        When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                             Then Round((@brok/100 )* Settlement.marketrate,broktable.round_to)         

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then ((@brok))

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then @brok

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round((@brok/ 100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then @brok

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then Round((@brok/100) * Settlement.marketrate ,broktable.round_to)

   Else  0 
                        End 
                         ),
        Nsertax =  (case  
                        When ( Settlement.settflag = 1 And @val_perc ="v")
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 1 And @val_perc ="p")
                             Then Round(((@brok/100 ) * (settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="v" ) 
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When (settlement.settflag = 2  And @val_perc ="p" ) 
                             Then Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="v" )
                             Then Round((@brok * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When (settlement.settflag = 3  And @val_perc ="p" )
                             Then Round(((@brok/ 100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="v" )
                             Then Round((@brok) * ( Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        When ( Settlement.settflag = 4  And @val_perc ="p" )
                             Then Round((( @brok/100) * ( Settlement.marketrate  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="v" )
                             Then Round( (@brok * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to)

                        When ( Settlement.settflag = 5  And @val_perc ="p" )
                             Then  Round(((@brok/100) * ( Settlement.marketrate * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),       
N_netrate = (  Case  
                   When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 1)
                   Then Round(( Settlement.marketrate + @brok),broktable.round_to)

                   When ( Settlement.settflag = 1 And @val_perc ="v" And Settlement.sell_buy = 2)
                   Then ((settlement.marketrate - @brok ) )   

                   When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 1)
                   Then ((settlement.marketrate + Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))

                   When ( Settlement.settflag = 1 And @val_perc ="p" And Settlement.sell_buy = 2)
                   Then ((settlement.marketrate - Round((@brok /100 )* Settlement.marketrate,broktable.round_to)))         

                   When (settlement.settflag = 2  And @val_perc ="v" ) 
                   Then ((@brok + Settlement.marketrate ))

                   When (settlement.settflag = 2  And @val_perc ="p" ) 
                   Then ((settlement.marketrate + Round((@brok/100) * Settlement.marketrate ,broktable.round_to)))

                   When (settlement.settflag = 3  And @val_perc ="v" )
                   Then ((  Settlement.marketrate - @brok))

                   When (settlement.settflag = 3  And @val_perc ="p" )
                   Then ((settlement.marketrate - Round((@brok/ 100) * Settlement.marketrate,broktable.round_to )))

                   When ( Settlement.settflag = 4  And @val_perc ="v" )
                   Then ((@brok + Settlement.marketrate ) )

                   When ( Settlement.settflag = 4  And @val_perc ="p" )
                   Then ((settlement.marketrate + Round(( @brok/100) * Settlement.marketrate,broktable.round_to )))

                   When ( Settlement.settflag =5  And @val_perc ="v" )
                   Then (( Settlement.marketrate - @brok ))

                   When ( Settlement.settflag =5  And @val_perc ="p" )
                   Then ((settlement.marketrate - Round((@brok/100) * Settlement.marketrate,broktable.round_to )))

   Else  0 
          End 
                  )
  From Globals,client2,broktable,taxes,client1
  Where Settlement.sett_no = @sett_no 
  And Settlement.sett_type = @sett_type 
  And Settlement.party_code Like @party_code
  And Settlement.scrip_cd Like @scrip_cd
  And Settlement.series Like @series
  And Settlement.trade_no Like @trade_no
  And Settlement.order_no Like @order_no
  And Settlement.marketrate = @marketrate
  And Client2.party_code = @party_code
  And Client1.cl_code = Client2.cl_code
  And Taxes.trans_cat  = (case When Cl_type = 'pro' Then 'pro' Else Client2.tran_cat End )
/*  And (client2.tran_cat = Taxes.trans_cat)*/
 And Client2.table_no = Broktable.table_no
 And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
  And (taxes.exchange = 'nse')
End
Else If @flag = 3
Begin
Update Settlement Set Status = 'e', Netrate = Round(@netrate,round_to), N_netrate =round(@netrate,round_to),
Brokapplied = Round(abs(@netrate - Marketrate),broktable.round_to), Nbrokapp = Round(abs(@netrate - Marketrate),broktable.round_to),
Service_tax = Round(tradeqty*abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to), Nsertax = Round(tradeqty*abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to),
Amount = Round(@netrate*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Settlement.sett_no = @sett_no 
And Settlement.sett_type = @sett_type 
And Settlement.party_code Like @party_code
And Settlement.scrip_cd Like @scrip_cd
And Settlement.series Like @series
And Settlement.trade_no Like @trade_no
And Settlement.order_no Like @order_no
And Client2.party_code = @party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End
Else
Begin
Update Settlement Set Status = 'e', Netrate = Round(@netrate,round_to), N_netrate =round(@netrate,round_to),
Brokapplied = Round(abs(@netrate - Marketrate),broktable.round_to), Nbrokapp = Round(abs(@netrate - Marketrate),broktable.round_to),
Service_tax = Round(abs(tradeqty*@netrate - Marketrate)*globals.service_tax/100,broktable.round_to), Nsertax = Round(tradeqty*abs(@netrate - Marketrate)*globals.service_tax/100,broktable.round_to),
Amount = Round(@netrate*tradeqty,broktable.round_to) 
From Client2,globals,broktable
Where Settlement.sett_no = @sett_no 
And Settlement.sett_type = @sett_type 
And Settlement.party_code Like @party_code
And Settlement.scrip_cd Like @scrip_cd
And Settlement.series Like @series
And Settlement.trade_no Like @trade_no
And Settlement.order_no Like @order_no
And Settlement.marketrate = @marketrate
And Client2.party_code = @party_code
And Client2.table_no = Broktable.table_no
And Sell_buy = @sell_buy	
And Broktable.line_no = ( Select Min(line_no) From Broktable Where Table_no = Client2.table_no)
End

GO
