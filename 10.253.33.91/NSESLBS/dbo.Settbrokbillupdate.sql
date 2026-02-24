-- Object: PROCEDURE dbo.Settbrokbillupdate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 01/15/2005 1:16:46 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 12/16/2003 2:31:26 Pm ******/



/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 05/08/2002 12:35:23 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 01/14/2002 20:33:21 ******/






/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 09/07/2001 11:09:31 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 7/1/01 2:26:55 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 06/26/2001 8:49:34 Pm ******/

/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 4/6/01 7:04:01 Pm ******/
/****** Object:  Stored Procedure Dbo.settbrokbillupdate    Script Date: 3/30/01 2:45:02 Pm ******/

/*  Changed By Bbg For Rounding 24 Apr 2001    */
/* Create   By Animesh On Date 31 - Mar - 2001 For Max Rate And Qty Logic */
/* Add Brokscheme 2 In Lineno Selection */
/*recent Changes Done By  Vaishali On 03/03/2001  Added Condn. For Status*/
Create Procedure Settbrokbillupdate (@settno Varchar(7), @sett_type Varchar(2),@tscrip_cd Varchar(12),@series Varchar(2)) As 
Update Settlement Set 
     Table_no = Broktable.table_no, Line_no = Broktable.line_no,val_perc = Broktable.val_perc,
    Normal = Broktable.normal, Day_puc= Broktable.day_puc,day_sales = Broktable.day_sales,
    Sett_purch =   Broktable.sett_purch,sett_sales = Broktable.sett_sales,
Brokapplied = (  Case  
                         When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Sell_buy = 1)
                              Then  /* Broktable.normal */
		((floor(( Broktable.normal * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                         When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Sell_buy = 2)
                              Then /* Broktable.normal  */
		((floor(( Broktable.normal * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                         When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.normal /100 ) * Settlement.marketrate)  * Power(10,broktable.round_to) + Broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Sell_buy = 2)
                             Then /* Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to)         */
		((floor(( ((broktable.normal /100 )* Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                      When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                      When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                             Then /* Round((broktable.day_puc/100) * Settlement.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                   When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                             Then /* Broktable.day_sales */
		((floor(( Broktable.day_sales * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                  When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                             Then /*round((broktable.day_sales/ 100) * Settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                             Then /* Broktable.sett_purch  */
		((floor(( Broktable.sett_purch * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                         When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                             Then /* Round((broktable.sett_purch/100) * Settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
             When ( Settlement.settflag = 5  And Broktable.val_perc ="v" )
                             Then /* Broktable.sett_sales */
		((floor(( Broktable.sett_sales * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
                         When ( Settlement.settflag = 5  And Broktable.val_perc ="p" )
                             Then /* Round((broktable.sett_sales/100) * Settlement.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 		Power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       Netrate = (  Case  
                                          When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Sell_buy = 1)
                                                      Then /* Round (( Settlement.marketrate + Broktable.normal),broktable.round_to) */
                                                                 Settlement.marketrate + ((floor((  (( Broktable.normal)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))

                                           When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Sell_buy = 2)
                                                       Then /* Round((settlement.marketrate - Broktable.normal ),broktable.round_to )    */
                                                                  Settlement.marketrate - ((floor(( (( Broktable.normal )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 	Power(10,broktable.round_to))
                                           When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Sell_buy = 1)
                                                        Then /* (settlement.marketrate + Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to)) */
                                                                   Settlement.marketrate + ((floor(( (((broktable.normal /100 )* Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                          When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Sell_buy = 2)
                                                       Then /* (settlement.marketrate - Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to))           */
                                                                   Settlement.marketrate -  ((floor((  ( ((broktable.normal /100 )* Settlement.marketrate))  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                          When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                                                    Then /* Round((broktable.day_puc + Settlement.marketrate ),broktable.round_to)*/
                                                                 Settlement.marketrate + ((floor(( ((broktable.day_puc  )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                         When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                                                    Then /* (settlement.marketrate + Round((broktable.day_puc/100) * Settlement.marketrate ,broktable.round_to))*/
                                                                Settlement.marketrate + ((floor(( (((broktable.day_puc/100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                          When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                                                     Then /* Round((settlement.marketrate - Broktable.day_sales),broktable.round_to)*/
                                                               Settlement.marketrate - ((floor(( (( Broktable.day_sales)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                         When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                                                    Then /* (settlement.marketrate - Round((broktable.day_sales/ 100) * Settlement.marketrate ,broktable.round_to))*/
                                                                Settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                         When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                                                     Then /* Round((broktable.sett_purch + Settlement.marketrate ),broktable.round_to )*/
                                                                 Settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                         When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                                                      Then /* (settlement.marketrate + Round(( Broktable.sett_purch/100) * Settlement.marketrate ,broktable.round_to))*/
                                                                 Settlement.marketrate + ((floor(( ( (( Broktable.sett_purch/100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                        When ( Settlement.settflag =5  And Broktable.val_perc ="v" )
                                                      Then /* Round(( Settlement.marketrate - Broktable.sett_sales ),broktable.round_to) */
                                                                   Settlement.marketrate - ((floor(( (( Broktable.sett_sales )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to))
                                         When ( Settlement.settflag =5  And Broktable.val_perc ="p" )
                                                     Then /* (settlement.marketrate - Round((broktable.sett_sales/100) * Settlement.marketrate ,broktable.round_to)) */
                                                                 Settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 	Power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
        Amount = 
                             (  Case  
                                          When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Sell_buy = 1)
                                                      Then /* Round (( Settlement.marketrate + Broktable.normal),broktable.round_to) */
                                                             Settlement.tradeqty  *  (  Settlement.marketrate + ((floor((  (( Broktable.normal)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))

                                           When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Sell_buy = 2)
                                                       Then /* Round((settlement.marketrate - Broktable.normal ),broktable.round_to )    */
                                                                Settlement.tradeqty * (   Settlement.marketrate - ((floor(( (( Broktable.normal )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 	Power(10,broktable.round_to)))
                                           When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Sell_buy = 1)
                                                        Then /* (settlement.marketrate + Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to)) */
                                                               Settlement.tradeqty  * (   Settlement.marketrate + ((floor(( (((broktable.normal /100 )* Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                          When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Sell_buy = 2)
                                                       Then /* (settlement.marketrate - Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to))           */
                                                                Settlement.tradeqty * (   Settlement.marketrate -  ((floor((  ( ((broktable.normal /100 )* Settlement.marketrate))  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                          When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                                                    Then /* Round((broktable.day_puc + Settlement.marketrate ),broktable.round_to)*/
                                                             Settlement.tradeqty * (    Settlement.marketrate + ((floor(( ((broktable.day_puc  )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                         When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                                                    Then /* (settlement.marketrate + Round((broktable.day_puc/100) * Settlement.marketrate ,broktable.round_to))*/
                                                               Settlement.tradeqty * ( Settlement.marketrate + ((floor(( (((broktable.day_puc/100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                          When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                                                     Then /* Round((settlement.marketrate - Broktable.day_sales),broktable.round_to)*/
                                                              Settlement.tradeqty * ( Settlement.marketrate - ((floor(( (( Broktable.day_sales)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                         When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                                                    Then /* (settlement.marketrate - Round((broktable.day_sales/ 100) * Settlement.marketrate ,broktable.round_to))*/
                                                              Settlement.tradeqty * (  Settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                         When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                                                     Then /* Round((broktable.sett_purch + Settlement.marketrate ),broktable.round_to )*/
                                                               Settlement.tradeqty * (  Settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))


                                         When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                                                      Then /* (settlement.marketrate + Round(( Broktable.sett_purch/100) * Settlement.marketrate ,broktable.round_to))*/
                                                               Settlement.tradeqty * (  Settlement.marketrate + ((floor(( ( (( Broktable.sett_purch/100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)))
                                        When ( Settlement.settflag =5  And Broktable.val_perc ="v" )
                                                      Then /* Round(( Settlement.marketrate - Broktable.sett_sales ),broktable.round_to) */
                                                     Settlement.tradeqty * ( Settlement.marketrate - ((floor(( (( Broktable.sett_sales )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  	(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / Power(10,broktable.round_to)) )
                                         When ( Settlement.settflag =5  And Broktable.val_perc ="p" )
                                                     Then /* (settlement.marketrate - Round((broktable.sett_sales/100) * Settlement.marketrate ,broktable.round_to)) */
                                                       Settlement.tradeqty  * (  Settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * Settlement.marketrate)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) )  / 	Power(10,broktable.round_to)))
   Else  0 

                        End 
                         ),
/*        Ins_chrg  = Round(((taxes.insurance_chrg * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to), 
        Turn_tax  = Round(((taxes.turnover_tax * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to),              
        Other_chrg = Round(((taxes.other_chrg * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to), 
        Sebi_tax = Round(((taxes.sebiturn_tax * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),              
        Broker_chrg = Round(((taxes.broker_note * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),
*/
        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *settlement.marketrate *settlement.tradeqty)/100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /power(10,broktable.round_to)),
        Turn_tax  =  ((floor(( ((taxes.turnover_tax *settlement.marketrate *settlement.tradeqty)/100 ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
		(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
		Power(10,broktable.round_to)),
        Other_chrg = ((floor(( ((taxes.other_chrg *settlement.marketrate *settlement.tradeqty)/100 ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / 	Power(10,broktable.round_to)),
        Sebi_tax =     ((floor(( ((taxes.sebiturn_tax *settlement.marketrate *settlement.tradeqty)/100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /	Power(10,broktable.round_to)),
        Broker_chrg =  ((floor(( ((taxes.broker_note *settlement.marketrate *settlement.tradeqty)/100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /power(10,broktable.round_to)),

       /*      Service_tax = (case  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v")
                             Then Round((round (broktable.normal,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        When (settlement.settflag = 1 And Broktable.val_perc ="p")
                             Then Round(((round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)
                       When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                             Then Round ( (round(broktable.day_puc,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to )
                        When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                             Then Round(((round((broktable.day_puc/100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                             Then Round((round(broktable.day_sales,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                             Then Round(((round((broktable.day_sales/ 100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                             Then Round((round(broktable.sett_purch,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                             Then Round(((round(( Broktable.sett_purch/100) *  Settlement.marketrate,broktable.round_to)  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        When ( Settlement.settflag = 5  And Broktable.val_perc ="v" )
                             Then Round ( (round(broktable.sett_sales ,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) /100,broktable.round_to)
                        When ( Settlement.settflag = 5  And Broktable.val_perc ="p" )
                             Then  Round(((round((broktable.sett_sales/100) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),  */



Service_tax =  (case  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v")
                             Then    /*  Round((round (broktable.normal,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.normal)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    

                        When (settlement.settflag = 1 And Broktable.val_perc ="p")
                             Then /*  Round(((round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                          Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                          (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))


                        When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                             Then  /*  Round ( (round(broktable.day_puc,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    

                        When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                             Then /*  Round(((round((broktable.day_puc/100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    



                        When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                             Then /*  Round((round(broktable.day_sales,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( Broktable.day_sales ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    



                        When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                             Then /*  Round(((round((broktable.day_sales/ 100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_sales/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    


                        When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                             Then  /*   Round((round(broktable.sett_purch,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( Broktable.sett_purch)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    



                        When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                             Then /*   Round(((round(( Broktable.sett_purch/100) *  Settlement.marketrate,broktable.round_to)  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    


                        When ( Settlement.settflag = 5  And Broktable.val_perc ="v" )
                             Then    /*    Round ( (round(broktable.sett_sales ,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( Broktable.sett_sales)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    


                        When ( Settlement.settflag = 5  And Broktable.val_perc ="p" )
                             Then  /*  Round(((round((broktable.sett_sales/100) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_sales/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    

   Else  0 
                        End 
                         ),
      Trade_amount = Settlement.tradeqty * Settlement.marketrate,
      Nbrokapp = (  Case  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Settlement.sell_buy = 1)
                             Then /* Broktable.normal */
			((floor(( Broktable.normal * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Settlement.sell_buy = 2)
                             Then /* Broktable.normal     */
			((floor(( Broktable.normal * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Settlement.sell_buy = 1)
                             Then /* Round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to) */
			((floor(( ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Settlement.sell_buy = 2)
                             Then /* Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to)         */
			((floor(( ((broktable.normal /100 )* Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                             Then /* ((broktable.day_puc)) */
			((floor(( ((broktable.day_puc)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                             Then /* Round((broktable.day_puc/100) * Settlement.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_puc/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                             Then /* Broktable.day_sales */
			((floor(( Broktable.day_sales * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                             Then /* Round((broktable.day_sales/ 100) * Settlement.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_sales/ 100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                             Then /* Broktable.sett_purch                         */
			((floor(( Broktable.sett_purch * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                             Then /* Round((broktable.sett_purch/100) * Settlement.marketrate,broktable.round_to)  */
			((floor(( ((broktable.sett_purch/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 5  And Broktable.val_perc ="v" )
                             Then /* Broktable.sett_sales */
			((floor(( Broktable.sett_sales * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 5  And Broktable.val_perc ="p" )
                             Then /* Round((broktable.sett_sales/100) * Settlement.marketrate,broktable.round_to) */
			((floor(( ((broktable.sett_sales/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
  /*       Nsertax = (case  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v")
                             Then Round((round (broktable.normal,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        When (settlement.settflag = 1 And Broktable.val_perc ="p")
                             Then Round(((round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                             Then Round ( (round(broktable.day_puc,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to )
                        When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                             Then Round(((round((broktable.day_puc/100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                             Then Round((round(broktable.day_sales,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                             Then Round(((round((broktable.day_sales/ 100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                             Then Round((round(broktable.sett_purch,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                             Then Round(((round(( Broktable.sett_purch/100) *  Settlement.marketrate,broktable.round_to)  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        When ( Settlement.settflag = 5  And Broktable.val_perc ="v" )
                             Then Round ( (round(broktable.sett_sales ,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) /100,broktable.round_to)
                        When ( Settlement.settflag = 5  And Broktable.val_perc ="p" )
                             Then  Round(((round((broktable.sett_sales/100) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),      */



Nsertax =  (case  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v")
                             Then    /*  Round((round (broktable.normal,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.normal)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    

                        When (settlement.settflag = 1 And Broktable.val_perc ="p")
                             Then /*  Round(((round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                          Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                          (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))


                        When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                             Then  /*  Round ( (round(broktable.day_puc,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    

                        When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
                             Then /*  Round(((round((broktable.day_puc/100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    



                        When (settlement.settflag = 3  And Broktable.val_perc ="v" )
                             Then /*  Round((round(broktable.day_sales,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( Broktable.day_sales ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    



                        When (settlement.settflag = 3  And Broktable.val_perc ="p" )
                             Then /*  Round(((round((broktable.day_sales/ 100) *  Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_sales/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    


                        When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
                             Then  /*   Round((round(broktable.sett_purch,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( Broktable.sett_purch)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    



                        When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
                             Then /*   Round(((round(( Broktable.sett_purch/100) *  Settlement.marketrate,broktable.round_to)  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    


                        When ( Settlement.settflag = 5  And Broktable.val_perc ="v" )
                             Then    /*    Round ( (round(broktable.sett_sales ,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( Broktable.sett_sales)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    


                        When ( Settlement.settflag = 5  And Broktable.val_perc ="p" )
                             Then  /*  Round(((round((broktable.sett_sales/100) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_sales/100) *  Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))    

   Else  0 
                        End 
                         ),
N_netrate = (  Case  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Settlement.sell_buy = 1)
                             Then /* ( ( Settlement.marketrate + Broktable.normal)) */
			((floor(( ( ( Settlement.marketrate + Broktable.normal)) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="v" And Settlement.sell_buy = 2)
                             Then /* ((settlement.marketrate - Broktable.normal ) ) */
			((floor(( ((settlement.marketrate - Broktable.normal ) )  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))  
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Settlement.sell_buy = 1)
/*                             Then ((settlement.marketrate + Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to))) */
                             Then Settlement.marketrate + 
			((floor(( ((broktable.normal /100 )* Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 1 And Broktable.val_perc ="p" And Settlement.sell_buy = 2)
/*                             Then ((settlement.marketrate - Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to)))         */
                             Then Settlement.marketrate -
			((floor(( ((broktable.normal /100 )* Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 2  And Broktable.val_perc ="v" ) 
                             Then /* ((broktable.day_puc + Settlement.marketrate )) */
			((floor(( ((broktable.day_puc + Settlement.marketrate )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 2  And Broktable.val_perc ="p" ) 
/*                             Then ((settlement.marketrate + Round((broktable.day_puc/100) * Settlement.marketrate,broktable.round_to )))	*/
                             Then 	Settlement.marketrate + 
			((floor(( ((broktable.day_puc/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 3  And Broktable.val_perc ="v" )
/*                             Then ((  Settlement.marketrate - Broktable.day_sales)) */
                             Then 	Settlement.marketrate - 
			((floor(( Broktable.day_sales * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When (settlement.settflag = 3  And Broktable.val_perc ="p" )
/*                             Then ((settlement.marketrate - Round((broktable.day_sales/ 100) * Settlement.marketrate,broktable.round_to ))) */
                             Then 	Settlement.marketrate - 
			((floor(( ((broktable.day_sales/ 100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="v" )
/*                             Then ((broktable.sett_purch + Settlement.marketrate ) ) */
                             Then 	Settlement.marketrate + 
			((floor(( Broktable.sett_purch * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag = 4  And Broktable.val_perc ="p" )
/*                             Then ((settlement.marketrate + Round(( Broktable.sett_purch/100) * Settlement.marketrate,broktable.round_to ))) */
                             Then Settlement.marketrate + 
			((floor(( (( Broktable.sett_purch/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag =5  And Broktable.val_perc ="v" )
/*                             Then (( Settlement.marketrate - Broktable.sett_sales )) */
                             Then Settlement.marketrate - 
			((floor(( Broktable.sett_sales * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
                        When ( Settlement.settflag =5  And Broktable.val_perc ="p" )
/*                             Then ((settlement.marketrate - Round((broktable.sett_sales/100) * Settlement.marketrate ,broktable.round_to))) */
                             Then Settlement.marketrate - 
			((floor(( ((broktable.sett_sales/100) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /
			(broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /
			Power(10,broktable.round_to))
   Else  0 
                        End 
                         )
                                              
      From Broktable,client2,settlement,taxes,globals,scrip1,scrip2,sett_mst,client1,billcursorsalepur C
      Where 
            Settlement.party_code = Client2.party_code
    And
     Client1.cl_code=client2.cl_code
           And  
 Settlement.sett_no = Sett_mst.sett_no 
 And 
 Settlement.sett_type= Sett_mst.sett_type
 And
              (settlement.series = Scrip2.series)
           And
             (scrip2.scrip_cd = Settlement.scrip_cd)
           And 
             (scrip2.co_code = Scrip1.co_code) 
           And
             (scrip2.series = Scrip1.series) 
           And 
           Broktable.table_no = ( Case When ( Settlement.series = 'eq'  And Settlement.markettype = '3' ) Then
           ( Case When ( Settlement.sell_buy = 1 And Settlement.tmark = '$' )
           Then Client2.p_to_p
           Else ( Case When ( Settlement.sell_buy = 2 And Settlement.tmark = '$' )
           Then Client2.sb_tableno
           Else Albmcf_tableno
           End )
      End )  
      Else ( Case When (client2.tran_cat = 'del') And (scrip1.demat_date <= Sett_mst.sec_payout)
                                Then Client2.demat_tableno 
                                Else ( Case When (client2.tran_cat = 'trd') And (settlement.tmark = 'd' )
                Then Client2.sub_tableno          
           Else Client2.table_no   
                         End )
      End  ) 
      End ) 
            And 
            Broktable.line_no = ( Case When (client2.tran_cat = 'trd') And (settlement.tmark = 'd' )  Then 
           (select Min(broktable.line_no) From Broktable Where
                          Broktable.table_no = Client2.sub_tableno And Trd_del = 'd'  
                                        And Settlement.party_code =  Client2.party_code    
                          And Settlement.marketrate <= Broktable.upper_lim )
      Else ( Case When ( Settlement.series = 'eq'  And Settlement.markettype = '3' ) Then
          (select Min(broktable.line_no) From Broktable Where
                                       Broktable.table_no = ( Case When ( Settlement.sell_buy = 1 And Settlement.tmark = '$' )
             Then Client2.p_to_p
             Else ( Case When ( Settlement.sell_buy = 2 And Settlement.tmark = '$' )
                Then Client2.sb_tableno
                Else Albmcf_tableno
             End )
             End )  
                                              And Settlement.party_code =  Client2.party_code And Trd_del = 't'   
                                And Settlement.marketrate <= Broktable.upper_lim )
             Else ( Case When (client2.tran_cat = 'trd') And (settlement.tmark = 'd' )  Then 
                  (select Min(broktable.line_no) From Broktable Where
                                        Broktable.table_no = Client2.demat_tableno And Trd_del = 'd'  
                                                      And Settlement.party_code =  Client2.party_code    
                                        And Settlement.marketrate <= Broktable.upper_lim )    
        Else ( Case When Client2.brok_scheme = 2 Then 
           (select Min(broktable.line_no) From Broktable Where
                                                     Broktable.table_no = Client2.table_no                                                  
                         And Trd_del =       
           ( Case When C.pqty = C.sqty Then 
          ( Case When C.prate >= C.srate 
          Then ( Case When ( Settlement.sell_buy = 1 ) 
                          Then 'f'  
                          Else 's'
                 End )
          Else
               ( Case When ( Settlement.sell_buy = 2 ) 
                          Then 'f'  
                   Else 's'
                 End )     
          End )
           Else
         ( Case When C.pqty >= C.sqty 
                Then ( Case When ( Settlement.sell_buy = 1 ) 
                         Then 'f'  
                         Else 's'
                End )
                Else
                    ( Case When ( Settlement.sell_buy = 2 ) 
                               Then 'f'  
                        Else 's'
                      End )     
           End )
           End )
           And Settlement.party_code =  Client2.party_code    
                                                     And Settlement.marketrate <= Broktable.upper_lim) 
      Else ( Case When Client2.brok_scheme = 1 Then     
                 (select Min(broktable.line_no) From Broktable Where
                                                     Broktable.table_no = Client2.table_no                                                  
                         And Trd_del = ( Case When C.pqty >= C.sqty 
           Then ( Case When ( Settlement.sell_buy = 1 ) 
                    Then 'f'  
                    Else 's'
                 End )
                Else
                ( Case When ( Settlement.sell_buy = 2 ) 
                    Then 'f'  
                    Else 's'
                 End )     
             End )
                                                     And Settlement.party_code =  Client2.party_code    
                                                     And Settlement.marketrate <= Broktable.upper_lim)           
      Else ( Case When Client2.brok_scheme = 3 Then     
                 (select Min(broktable.line_no) From Broktable Where
                                                     Broktable.table_no = Client2.table_no                                                  
                         And Trd_del = ( Case When C.pqty > C.sqty 
           Then ( Case When ( Settlement.sell_buy = 1 ) 
                    Then 'f'  
                    Else 's'
                 End )
                Else
                ( Case When ( Settlement.sell_buy = 2 ) 
                    Then 'f'  
                    Else 's'
                 End )     
             End )
                                                       And Settlement.party_code =  Client2.party_code    
                                                      And Settlement.marketrate <= Broktable.upper_lim)           
       Else 
              (select Min(broktable.line_no) From Broktable 
               Where Broktable.table_no = Client2.table_no   
                /*and Trd_del = 't'*/ 
                               And Settlement.party_code =  Client2.party_code        
                     And Settlement.marketrate <= Broktable.upper_lim ) 
       End )
      End )
                  End ) 
    End )
         End )
  End )
/*           And
             (client2.tran_cat = Taxes.trans_cat) */
  And Taxes.trans_cat  = (case When Cl_type = 'pro' Then 'pro' Else Client2.tran_cat End )
           And
             (taxes.exchange = 'nse')  
  And Settlement.sett_no = @settno
  And Settlement.sett_type = @sett_type
  And Settlement.scrip_cd = @tscrip_cd
  And Settlement.tradeqty > 0
  And Settlement.series = @series
And Settlement.sett_no = C.sett_no
And Settlement.sett_type = C.sett_type
And Settlement.party_code = C.party_code
And Settlement.scrip_cd Like C.scrip_cd
And Settlement.series = C.series
  And Settlement.tmark = C.tmark
And Left(convert(varchar,settlement.sauda_date,109),11) = C.sauda_date
And Settlement.status <> 'e'   /*added By Vaishali On 03/03/2001*/

GO
