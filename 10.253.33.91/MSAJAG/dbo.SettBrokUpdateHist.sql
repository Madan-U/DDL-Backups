-- Object: PROCEDURE dbo.SettBrokUpdateHist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SettBrokUpdateHist    Script Date: 4/6/01 7:04:01 PM ******/
/****** Object:  Stored Procedure dbo.SettBrokUpdateHist    Script Date: 3/30/01 2:45:02 PM ******/
/* CHANGED BY BGG FOR ROUNDING 24 APR 2001 */
/* Create   By Animesh On Date 31 - mar - 2001 For Max Rate and Qty Logic */
/* Add BrokScheme 2 in LineNo Selection */
CREATE procedure SettBrokUpdateHist (@tparty varchar(10), @tdate varchar(10),@tscrip_cd varchar(12),@Series varchar(2)) as 
update history set 
     table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
BrokApplied = (  case  
                         when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * s.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* s.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                      when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                      when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * s.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                   when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                  when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * s.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * s.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
             when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       NetRate = (  case  
                                          when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( s.marketrate + broktable.Normal),broktable.round_to) */
                                                                 s.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((s.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  s.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (s.marketrate + round((broktable.Normal /100 )* s.marketrate,broktable.round_to)) */
                                                                   s.marketrate + ((floor(( (((broktable.Normal /100 )* s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (s.marketrate - round((broktable.Normal /100 )* s.marketrate,broktable.round_to))           */
                                                                   s.marketrate -  ((floor((  ( ((broktable.Normal /100 )* s.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + s.marketrate ),broktable.round_to)*/
                                                                 s.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (s.marketrate + round((broktable.day_puc/100) * s.marketrate ,broktable.round_to))*/
                                                                s.marketrate + ((floor(( (((broktable.day_puc/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (s.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((s.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               s.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (s.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (s.marketrate - round((broktable.day_sales/ 100) * s.marketrate ,broktable.round_to))*/
                                                                s.marketrate - ((floor((  (((broktable.day_sales/ 100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + s.marketrate ),broktable.round_to )*/
                                                                 s.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (s.marketrate + round(( broktable.sett_purch/100) * s.marketrate ,broktable.round_to))*/
                                                                 s.marketrate + ((floor(( ( (( broktable.sett_purch/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( s.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( s.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                                   s.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( s.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (s.marketrate - round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to)) */
                                                                 s.marketrate -  ((floor((  (((broktable.sett_sales/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       Amount = 
                             (  case  
                                          when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( s.marketrate + broktable.Normal),broktable.round_to) */
                                                             s.Tradeqty  *  (  s.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))

                                           when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((s.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                s.Tradeqty * (   s.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
                                           when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (s.marketrate + round((broktable.Normal /100 )* s.marketrate,broktable.round_to)) */
                                                               s.Tradeqty  * (   s.marketrate + ((floor(( (((broktable.Normal /100 )* s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (s.marketrate - round((broktable.Normal /100 )* s.marketrate,broktable.round_to))           */
                                                                s.Tradeqty * (   s.marketrate -  ((floor((  ( ((broktable.Normal /100 )* s.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + s.marketrate ),broktable.round_to)*/
                                                             s.Tradeqty * (    s.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (s.marketrate + round((broktable.day_puc/100) * s.marketrate ,broktable.round_to))*/
                                                               s.Tradeqty * ( s.marketrate + ((floor(( (((broktable.day_puc/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (s.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((s.marketrate - broktable.day_sales),broktable.round_to)*/
                                                              s.Tradeqty * ( s.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (s.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (s.marketrate - round((broktable.day_sales/ 100) * s.marketrate ,broktable.round_to))*/
                                                              s.Tradeqty * (  s.marketrate - ((floor((  (((broktable.day_sales/ 100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + s.marketrate ),broktable.round_to )*/
                                                               s.Tradeqty * (  s.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))


                                         when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (s.marketrate + round(( broktable.sett_purch/100) * s.marketrate ,broktable.round_to))*/
                                                               s.Tradeqty * (  s.marketrate + ((floor(( ( (( broktable.sett_purch/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                        when ( s.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( s.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                     s.Tradeqty * ( s.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) )
                                         when ( s.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (s.marketrate - round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to)) */
                                                       s.Tradeqty  * (  s.marketrate -  ((floor((  (((broktable.sett_sales/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
   Else  0 

                        End 
                         ),
/*     Ins_chrg  = round(((taxes.insurance_chrg * s.marketrate * s.Tradeqty)/100),broktable.round_to), 
     turn_tax  = round(((taxes.turnover_tax * s.marketrate * s.Tradeqty)/100 ),broktable.round_to),              
     other_chrg = round(((taxes.other_chrg * s.marketrate * s.Tradeqty)/100 ),broktable.round_to), 
     sebi_tax = round(((taxes.sebiturn_tax * s.marketrate * s.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * s.marketrate * s.Tradeqty)/100),broktable.round_to),
*/
        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *s.marketrate *s.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),
        turn_tax  =  ((floor(( ((taxes.turnover_tax *s.marketrate *s.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to)),
        other_chrg = ((floor(( ((taxes.other_chrg *s.marketrate *s.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to)),
        sebi_tax =     ((floor(( ((taxes.sebiturn_tax *s.marketrate *s.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to)),
        Broker_chrg =  ((floor(( ((taxes.broker_note *s.marketrate *s.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),

    /*   Service_tax = (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to) 
   Else  0 
                        End 
                         ),  */



        Service_tax =  (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
      Trade_amount = s.Tradeqty * s.MarketRate,
      NBrokApp = (  case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 1)
                             Then /* broktable.Normal */
			((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 2)
                             Then /* broktable.Normal     */
			((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 1)
                             Then /* round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) */
			((floor(( ((broktable.Normal /100 ) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* s.marketrate,broktable.round_to)         */
			((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* ((broktable.day_puc)) */
			((floor(( ((broktable.day_puc)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * s.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_puc/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
			((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /* round((broktable.day_sales/ 100) * s.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_sales/ 100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch                         */
			((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * s.marketrate,broktable.round_to)  */
			((floor(( ((broktable.sett_purch/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
			((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * s.marketrate,Broktable.round_to) */
			((floor(( ((broktable.sett_sales/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
 /*        NSertax = (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then /* round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to) */
		((floor(( (((broktable.Normal) * s.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then /* round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to) */
		((floor(( (((((broktable.Normal /100 ) * s.marketrate) * s.Tradeqty * globals.service_tax) / 100)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to ) */
		((floor(( ( ((broktable.day_puc) * s.Tradeqty * globals.service_tax) /100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
		((floor(( (((((broktable.day_puc/100) *  s.marketrate) * s.Tradeqty * Globals.service_tax) / 100)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to) */
		((floor(( (((broktable.day_sales) * s.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /* round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to) */
		((floor(( (((((broktable.day_sales/ 100) *  s.marketrate) * s.Tradeqty * globals.service_tax) / 100)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to) */
		((floor(( ((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to) */
		((floor(( ((((( broktable.sett_purch/100) *  s.marketrate)  * s.Tradeqty * Globals.service_tax)/100 )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to) */
		((floor(( ( ((broktable.sett_sales) * s.Tradeqty* Globals.service_tax) /100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /* round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to)  */
		((floor(( (((((broktable.sett_sales/100) * s.marketrate) * s.Tradeqty * globals.service_tax)  /100))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
   Else  0 
                        End 
                         ), */

        NserTax =  (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
N_NetRate = (  case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 1)
                             Then /* ( ( s.marketrate + broktable.Normal)) */
			((floor(( ( ( s.marketrate + broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 2)
                             Then /* ((s.marketrate - broktable.Normal ) ) */
			((floor(( ((s.marketrate - broktable.Normal ) )  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))  
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 1)
/*                             Then ((s.marketrate + round((broktable.Normal /100 )* s.marketrate,broktable.round_to))) */
                             Then s.marketrate + 
			((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 2)
/*                             Then ((s.marketrate - round((broktable.Normal /100 )* s.marketrate,broktable.round_to)))         */
                             Then s.marketrate -
			((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* ((broktable.day_puc + s.marketrate )) */
			((floor(( ((broktable.day_puc + s.marketrate )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
/*                             Then ((s.marketrate + round((broktable.day_puc/100) * s.marketrate,broktable.round_to )))	*/
                             Then 	s.marketrate + 
			((floor(( ((broktable.day_puc/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
/*                             Then ((  s.marketrate - broktable.day_sales)) */
                             Then 	s.marketrate - 
			((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
/*                             Then ((s.marketrate - round((broktable.day_sales/ 100) * s.marketrate,broktable.round_to ))) */
                             Then 	s.marketrate - 
			((floor(( ((broktable.day_sales/ 100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
/*                             Then ((broktable.sett_purch + s.marketrate ) ) */
                             Then 	s.marketrate + 
			((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
/*                             Then ((s.marketrate + round(( broktable.sett_purch/100) * s.marketrate,broktable.round_to ))) */
                             Then s.marketrate + 
			((floor(( (( broktable.sett_purch/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag =5  and broktable.val_perc ="V" )
/*                             Then (( s.marketrate - broktable.sett_sales )) */
                             Then s.marketrate - 
			((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag =5  and broktable.val_perc ="P" )
/*                             Then ((s.marketrate - round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to))) */
                             Then s.marketrate - 
			((floor(( ((broktable.sett_sales/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
   Else  0 
                        End 
                         )
                                              
      FROM BrokTable,Client2,history s,taxes,globals,scrip1,scrip2,Sett_mst,client1, BillHistCursorSalePur C
      WHERE 
            s.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
 s.SETT_NO = SETT_MST.SETT_NO 
 AND 
 s.SETT_TYPE= SETT_MST.SETT_TYPE
 AND
              (s.Series = scrip2.series)
           And
             (scrip2.scrip_cd = s.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
           Broktable.Table_no = ( case when ( s.series = 'EQ'  and s.markettype = '3' ) Then
           ( Case When ( s.SELL_BUY = 1 AND s.TMARK = '$' )
           Then client2.P_To_P
           Else ( Case When ( s.SELL_BUY = 2 AND s.TMARK = '$' )
           Then client2.sb_tableno
           Else AlbmCF_tableno
           End )
      End )  
      else ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
                                then client2.demat_tableno 
                                Else ( case when (client2.Tran_cat = 'TRD') AND (s.TMark = 'D' )
                then client2.Sub_TableNo          
           else Client2.table_no   
                         end )
      end  ) 
      End ) 
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD') AND (s.TMark = 'D' )  then 
           (Select min(Broktable.line_no) from broktable where
                          Broktable.table_no = client2.Sub_TableNo and Trd_Del = 'D'  
                                        and s.Party_Code =  Client2.Party_code    
                          and s.marketrate <= Broktable.upper_lim )
      ELSE ( case when ( s.series = 'EQ'  and s.markettype = '3' ) Then
          (Select min(Broktable.line_no) from broktable where
                                       Broktable.table_no = ( Case When ( s.SELL_BUY = 1 AND s.TMARK = '$' )
             Then client2.P_To_P
             Else ( Case When ( s.SELL_BUY = 2 AND s.TMARK = '$' )
                Then client2.sb_tableno
                Else AlbmCF_tableno
             End )
             End )  
                                              and s.Party_Code =  Client2.Party_code and Trd_Del = 'T'   
                                and s.marketrate <= Broktable.upper_lim )
             Else ( case when (client2.Tran_cat = 'TRD') AND (s.TMark = 'D' )  then 
                  (Select min(Broktable.line_no) from broktable where
                                        Broktable.table_no = client2.demat_tableno and Trd_Del = 'D'  
                                                      and s.Party_Code =  Client2.Party_code    
                                        and s.marketrate <= Broktable.upper_lim )    
        else ( case when client2.brok_scheme = 2 then 
           (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = Client2.table_no                                                  
                         and Trd_Del =       
           ( Case When c.PQty = c.SQty then 
          ( Case When c.PRate >= c.SRate 
          then ( Case When ( s.Sell_Buy = 1 ) 
                          Then 'F'  
                          Else 'S'
                 End )
          Else
               ( Case When ( s.Sell_Buy = 2 ) 
                          Then 'F'  
                   Else 'S'
                 End )     
          End )
           Else
         ( Case When c.Pqty >= c.Sqty 
                then ( Case When ( s.Sell_Buy = 1 ) 
                         Then 'F'  
                         Else 'S'
                End )
                Else
                    ( Case When ( s.Sell_Buy = 2 ) 
                               Then 'F'  
                        Else 'S'
                      End )     
           End )
           End )
           and s.Party_Code =  Client2.Party_code    
                                                     and s.marketrate <= Broktable.upper_lim) 
      else ( case when client2.brok_scheme = 1 then     
                 (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = Client2.table_no                                                  
                         and Trd_Del = ( Case When c.Pqty >= c.Sqty 
           then ( Case When ( s.Sell_Buy = 1 ) 
                    Then 'F'  
                    Else 'S'
                 End )
                Else
                ( Case When ( s.Sell_Buy = 2 ) 
                    Then 'F'  
                    Else 'S'
                 End )     
             End )
                                                     and s.Party_Code =  Client2.Party_code    
                                                     and s.marketrate <= Broktable.upper_lim)           
      else ( case when client2.brok_scheme = 3 then     
                 (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = Client2.table_no                                                  
                         and Trd_Del = ( Case When c.Pqty > c.Sqty 
           then ( Case When ( s.Sell_Buy = 1 ) 
                    Then 'F'  
                    Else 'S'
                 End )
                Else
                ( Case When ( s.Sell_Buy = 2 ) 
                    Then 'F'  
                    Else 'S'
                 End )     
             End )
                                                       and s.Party_Code =  Client2.Party_code    
                                                      and s.marketrate <= Broktable.upper_lim)           
       else 
              (Select min(Broktable.line_no) from broktable 
               where Broktable.table_no = client2.table_no   
                /*And Trd_Del = 'T'*/ 
                               and s.Party_Code =  Client2.Party_code        
                     and s.marketrate <= Broktable.upper_lim ) 
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
  and s.party_code = @tparty 
  and convert(varchar,s.sauda_date,3)= @tdate
  and s.scrip_cd   =  @tscrip_cd
  and s.tradeqty > 0
  and s.series = @series
 and Left(convert(varchar,s.sauda_date,109),11) = c.sauda_Date
And S.Sett_no = c.sett_no
and S.sett_Type = C.Sett_type
And S.Party_code = C.Party_code
and S.scrip_cd like C.Scrip_Cd
and s.series = C.series
and s.TMark = c.TMark
and s.status <> 'E'   /*Added by vaishali on 03/03/2001*/

GO
