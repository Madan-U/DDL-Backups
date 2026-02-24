-- Object: PROCEDURE dbo.SettBrokDelUpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SettBrokDelUpdate    Script Date: 4/6/01 7:04:01 PM ******/
/****** Object:  Stored Procedure dbo.SettBrokDelUpdate    Script Date: 3/30/01 2:45:02 PM ******/

/*  CHANGED BY BBG FOR ROUNDING 24 APR 2001 */
/* Create   By Animesh On Date 31 - mar - 2001 For Max Rate and Qty Logic */
/* Add BrokScheme 2 in LineNo Selection */
CREATE procedure SettBrokDelUpdate (@tsett_no varchar(7),@tsett_type varchar(2),@tparty varchar(10)) as 
update settlement set 
     table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
BrokApplied = (  case  
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                      when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                      when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * settlement.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                   when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                  when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
             when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       NetRate = (  case  
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( settlement.marketrate + broktable.Normal),broktable.round_to) */
                                                                 settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((settlement.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)) */
                                                                   settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))           */
                                                                   settlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* settlement.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + settlement.marketrate ),broktable.round_to)*/
                                                                 settlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (settlement.marketrate + round((broktable.day_puc/100) * settlement.marketrate ,broktable.round_to))*/
                                                                settlement.marketrate + ((floor(( (((broktable.day_puc/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((settlement.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               settlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (settlement.marketrate - round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to))*/
                                                                settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + settlement.marketrate ),broktable.round_to )*/
                                                                 settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (settlement.marketrate + round(( broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to))*/
                                                                 settlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( settlement.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                                   settlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (settlement.marketrate - round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)) */
                                                                 settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       Amount = 
                             (  case  
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( settlement.marketrate + broktable.Normal),broktable.round_to) */
                                                             settlement.Tradeqty  *  (  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))

                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((settlement.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                settlement.Tradeqty * (   settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)) */
                                                               settlement.Tradeqty  * (   settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))           */
                                                                settlement.Tradeqty * (   settlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* settlement.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + settlement.marketrate ),broktable.round_to)*/
                                                             settlement.Tradeqty * (    settlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (settlement.marketrate + round((broktable.day_puc/100) * settlement.marketrate ,broktable.round_to))*/
                                                               settlement.Tradeqty * ( settlement.marketrate + ((floor(( (((broktable.day_puc/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((settlement.marketrate - broktable.day_sales),broktable.round_to)*/
                                                              settlement.Tradeqty * ( settlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (settlement.marketrate - round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to))*/
                                                              settlement.Tradeqty * (  settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + settlement.marketrate ),broktable.round_to )*/
                                                               settlement.Tradeqty * (  settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))


                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (settlement.marketrate + round(( broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to))*/
                                                               settlement.Tradeqty * (  settlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                        when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( settlement.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                     settlement.Tradeqty * ( settlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) )
                                         when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (settlement.marketrate - round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)) */
                                                       settlement.Tradeqty  * (  settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
   Else  0 

                        End 
                         ),
/*        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),
*/
        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *settlement.marketrate *settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),
        turn_tax  =  ((floor(( ((taxes.turnover_tax *settlement.marketrate *settlement.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to)),
        other_chrg = ((floor(( ((taxes.other_chrg *settlement.marketrate *settlement.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to)),
        sebi_tax =     ((floor(( ((taxes.sebiturn_tax *settlement.marketrate *settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to)),
        Broker_chrg =  ((floor(( ((taxes.broker_note *settlement.marketrate *settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),

    /*   Service_tax = (case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((round (broktable.Normal,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then round(((round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (round(broktable.day_puc,broktable.round_to) * settlement.Tradeqty * globals.service_tax) /100,broktable.round_to )
                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((round((broktable.day_puc/100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((round(broktable.day_sales,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((round((broktable.day_sales/ 100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.sett_purch,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round(( broktable.sett_purch/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.sett_sales ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.sett_sales/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)
  Else  0 
                        End 
                         ),   */


Service_tax =  (case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * settlement.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
      Trade_amount = settlement.Tradeqty * settlement.MarketRate,
      NBrokApp = (  case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and settlement.sell_buy = 1)
                             Then /* broktable.Normal */
			((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and settlement.sell_buy = 2)
                             Then /* broktable.Normal     */
			((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and settlement.sell_buy = 1)
                             Then /* round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) */
			((floor(( ((broktable.Normal /100 ) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and settlement.sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)         */
			((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* ((broktable.day_puc)) */
			((floor(( ((broktable.day_puc)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * settlement.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_puc/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
			((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /* round((broktable.day_sales/ 100) * settlement.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_sales/ 100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch                         */
			((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * settlement.marketrate,broktable.round_to)  */
			((floor(( ((broktable.sett_purch/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
			((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * settlement.marketrate,Broktable.round_to) */
			((floor(( ((broktable.sett_sales/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
  /*       NSertax = (case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((round (broktable.Normal,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then round(((round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (round(broktable.day_puc,broktable.round_to) * settlement.Tradeqty * globals.service_tax) /100,broktable.round_to )
                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((round((broktable.day_puc/100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((round(broktable.day_sales,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((round((broktable.day_sales/ 100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.sett_purch,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round(( broktable.sett_purch/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.sett_sales ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.sett_sales/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)

   Else  0 
                        End 
                         ),  */



NserTax =  (case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * settlement.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
N_NetRate = (  case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and settlement.sell_buy = 1)
                             Then /* ( ( settlement.marketrate + broktable.Normal)) */
			((floor(( ( ( settlement.marketrate + broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and settlement.sell_buy = 2)
                             Then /* ((settlement.marketrate - broktable.Normal ) ) */
			((floor(( ((settlement.marketrate - broktable.Normal ) )  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and settlement.sell_buy = 1)
/*                             Then ((settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))) */
                             Then settlement.marketrate + 
			((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and settlement.sell_buy = 2)
/*                             Then ((settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)))         */
                             Then settlement.marketrate -
			((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* ((broktable.day_puc + settlement.marketrate )) */
			((floor(( ((broktable.day_puc + settlement.marketrate )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
/*                             Then ((settlement.marketrate + round((broktable.day_puc/100) * settlement.marketrate,broktable.round_to )))	*/
                             Then 	settlement.marketrate + 
			((floor(( ((broktable.day_puc/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
/*                             Then ((  settlement.marketrate - broktable.day_sales)) */
                             Then 	settlement.marketrate - 
			((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
/*                             Then ((settlement.marketrate - round((broktable.day_sales/ 100) * settlement.marketrate,broktable.round_to ))) */
                             Then 	settlement.marketrate - 
			((floor(( ((broktable.day_sales/ 100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
/*                             Then ((broktable.sett_purch + settlement.marketrate ) ) */
                             Then 	settlement.marketrate + 
			((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
/*                             Then ((settlement.marketrate + round(( broktable.sett_purch/100) * settlement.marketrate,broktable.round_to ))) */
                             Then settlement.marketrate + 
			((floor(( (( broktable.sett_purch/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
/*                             Then (( settlement.marketrate - broktable.sett_sales )) */
                             Then settlement.marketrate - 
			((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
/*                             Then ((settlement.marketrate - round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to))) */
                             Then settlement.marketrate - 
			((floor(( ((broktable.sett_sales/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
   Else  0 
                        End 
                         )
                                              
      FROM BrokTable,Client2,settlement,taxes,globals,scrip1,scrip2,Sett_mst,client1,BillCurSorSalePur C
      WHERE 
            settlement.Party_Code = Client2.Party_code
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
           Broktable.Table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3' ) Then
           ( Case When ( settlement.SELL_BUY = 1 AND settlement.TMARK = '$' )
           Then client2.P_To_P
           Else ( Case When ( settlement.SELL_BUY = 2 AND settlement.TMARK = '$' )
           Then client2.sb_tableno
           Else AlbmCF_tableno
           End )
      End )  
      else ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
                                then client2.demat_tableno 
                                Else ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )
                then client2.Sub_TableNo          
           else Client2.table_no   
                         end )
      end  ) 
      End ) 
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
           (Select min(Broktable.line_no) from broktable where
                          Broktable.table_no = client2.Sub_TableNo and Trd_Del = 'D'  
                                        and settlement.Party_Code =  Client2.Party_code    
                          and settlement.marketrate <= Broktable.upper_lim )
      ELSE ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3' ) Then
          (Select min(Broktable.line_no) from broktable where
                                       Broktable.table_no = ( Case When ( settlement.SELL_BUY = 1 AND settlement.TMARK = '$' )
             Then client2.P_To_P
             Else ( Case When ( settlement.SELL_BUY = 2 AND settlement.TMARK = '$' )
                Then client2.sb_tableno
                Else AlbmCF_tableno
             End )
             End )  
                                              and settlement.Party_Code =  Client2.Party_code and Trd_Del = 'T'   
                                and settlement.marketrate <= Broktable.upper_lim )
             Else ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
                  (Select min(Broktable.line_no) from broktable where
                                        Broktable.table_no = client2.demat_tableno and Trd_Del = 'D'  
                                                      and settlement.Party_Code =  Client2.Party_code    
                                        and settlement.marketrate <= Broktable.upper_lim )    
        else ( case when client2.brok_scheme = 2 then 
           (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = Client2.table_no                                                  
                         and Trd_Del =       
           ( Case When c.PQty = c.SQty then 
          ( Case When c.PRate >= c.SRate 
          then ( Case When ( settlement.Sell_Buy = 1 ) 
                          Then 'F'  
                          Else 'S'
                 End )
          Else
               ( Case When ( settlement.Sell_Buy = 2 ) 
                          Then 'F'  
                   Else 'S'
                 End )     
          End )
           Else
         ( Case When c.Pqty >= c.Sqty 
                then ( Case When ( settlement.Sell_Buy = 1 ) 
                         Then 'F'  
                         Else 'S'
                End )
                Else
                    ( Case When ( settlement.Sell_Buy = 2 ) 
                               Then 'F'  
                        Else 'S'
                      End )     
           End )
           End )
           and settlement.Party_Code =  Client2.Party_code    
                                                     and settlement.marketrate <= Broktable.upper_lim) 
      else ( case when client2.brok_scheme = 1 then     
                 (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = Client2.table_no                                                  
                         and Trd_Del = ( Case When c.Pqty >= c.Sqty 
           then ( Case When ( settlement.Sell_Buy = 1 ) 
                    Then 'F'  
                    Else 'S'
                 End )
                Else
                ( Case When ( settlement.Sell_Buy = 2 ) 
                    Then 'F'  
                    Else 'S'
                 End )     
             End )
                                                     and settlement.Party_Code =  Client2.Party_code    
                                                     and settlement.marketrate <= Broktable.upper_lim)           
      else ( case when client2.brok_scheme = 3 then     
                 (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = Client2.table_no                                                  
                         and Trd_Del = ( Case When c.Pqty > c.Sqty 
           then ( Case When ( settlement.Sell_Buy = 1 ) 
                    Then 'F'  
                    Else 'S'
                 End )
                Else
                ( Case When ( settlement.Sell_Buy = 2 ) 
                    Then 'F'  
                    Else 'S'
                 End )     
             End )
                                                       and settlement.Party_Code =  Client2.Party_code    
                                                      and settlement.marketrate <= Broktable.upper_lim)           
       else 
              (Select min(Broktable.line_no) from broktable 
               where Broktable.table_no = client2.table_no   
                /*And Trd_Del = 'T'*/ 
                               and settlement.Party_Code =  Client2.Party_code        
                     and settlement.marketrate <= Broktable.upper_lim ) 
       end )
      end )
                  end ) 
    end )
         end )
  end )
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')  
  and settlement.sett_no = @tsett_no
  and settlement.sett_type = @tsett_type
  and settlement.party_code = @tparty 
  and settlement.tradeqty > 0
And settlement.Sett_no = c.sett_no
and settlement.sett_Type = C.Sett_type
And settlement.Party_code = C.Party_code
and settlement.scrip_cd like C.Scrip_Cd
and settlement.series = C.series
  and settlement.tmark = c.tmark
and Left(Convert(Varchar,settlement.Sauda_date,109),11) = C.Sauda_Date
and settlement.status <> 'E'   /*Added by vaishali on 03/03/2001*/

GO
