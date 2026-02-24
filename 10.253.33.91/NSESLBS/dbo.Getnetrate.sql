-- Object: PROCEDURE dbo.Getnetrate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Procedure Getnetrate (@Tparty Varchar(10), @Sell_Buy Int , @Marketrate  Money) As   
  
Select  Broktable.Table_No, Broktable.Line_No,      Netrate = (  Case    
                                               When ( @Sell_Buy = 1 And Broktable.Val_Perc = 'V' )  
                                                     Then   
                                               @Marketrate + ((Floor(( ((Broktable.Sett_Purch  )) * Power(10, Broktable.Round_To)+Broktable.Rofig + Broktable.Errnum ) /   (Broktable.Rofig + Broktable.Nozero )) * (Broktable.Rofig +Broktable.Nozero ) )  / Power(10, Broktable.Round_To))  
                                         When ( @Sell_Buy = 1 And Broktable.Val_Perc = 'P' )  
                                                      Then   
                                                                 @Marketrate + ((Floor(( ( (( Broktable.Sett_Purch/100) * @Marketrate)) * Power(10, Broktable.Round_To)+Broktable.Rofig + Broktable.Errnum ) /  (Broktable.Rofig + Broktable.Nozero )) * (Broktable.Rofig +Broktable.Nozero ) )  / Power(10, Broktable.Round_To))  
                                        When ( @Sell_Buy  = 2  And Broktable.Val_Perc = 'V' )  
                                                      Then /* Round(( @Marketrate - Broktable.Sett_Sales ), Broktable.Round_To) */  
                                                                   @Marketrate - ((Floor(( (( Broktable.Sett_Sales )) * Power(10, Broktable.Round_To)+Broktable.Rofig + Broktable.Errnum ) /   (Broktable.Rofig + Broktable.Nozero )) * (Broktable.Rofig +Broktable.Nozero ) )  / Power(10, Broktable.Round_To))  
                                         When ( @Sell_Buy  = 2  And Broktable.Val_Perc = 'P' )  
                                                     Then /* (@Marketrate - Round((Broktable.Sett_Sales/100) * @Marketrate , Broktable.Round_To)) */  
                                                                 @Marketrate -  ((Floor((  (((Broktable.Sett_Sales/100) * @Marketrate)) * Power(10, Broktable.Round_To)+Broktable.Rofig + Broktable.Errnum ) /  (Broktable.Rofig + Broktable.Nozero )) * (Broktable.Rofig +Broktable.Nozero ) )  /  Power(10, Broktable.Round_To))  
   Else  0   
  
                        End   
                         )  
  
                                                
      From Broktable, Client2  
      Where   
           Broktable.Table_No = ( Client2.Table_No )  
            And   
            Broktable.Line_No = ( Select Min(Broktable.Line_No) From Broktable   
                                                   Where Broktable.Table_No = Client2.Table_No     
                       And @Marketrate < = Broktable.Upper_Lim   
        )  
           And Client2.Table_No = Broktable.Table_No  
           And Client2.Party_Code = @Tparty

GO
