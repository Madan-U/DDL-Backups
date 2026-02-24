-- Object: PROCEDURE dbo.subbrokerconfirmview
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc subbrokerconfirmview(@trdDate varchar(11)) as 
update TrdBackUp set sett_no = sett_mst.sett_no , sett_type = Sett_Mst.sett_type,
table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
BrokApplied = (  case  
                         when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * trdbackup.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /
 power(10,broktable.round_to))
                        when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * trdbackup.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                   when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                  when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * trdbackup.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * trdbackup.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
             when ( trdbackup.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * trdbackup.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
       NetRate = (  case  
                                          when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( trdbackup.marketrate + broktable.Normal),broktable.round_to) */
                                                                 trdbackup.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((trdbackup.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  trdbackup.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (trdbackup.marketrate + round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to)) */
                                                                   trdbackup.marketrate + ((floor(( (((broktable.Normal /100 )* trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * 
(broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (trdbackup.marketrate - round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to))           */
                                                                   trdbackup.marketrate -  ((floor((  ( ((broktable.Normal /100 )* trdbackup.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )
) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + trdbackup.marketrate ),broktable.round_to)*/
                                                                 trdbackup.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (trdbackup.marketrate + round((broktable.day_puc/100) * trdbackup.marketrate ,broktable.round_to))*/
                                                                trdbackup.marketrate + ((floor(( (((broktable.day_puc/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((trdbackup.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               trdbackup.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (trdbackup.marketrate - round((broktable.day_sales/ 100) * trdbackup.marketrate ,broktable.round_to))*/
                                                                trdbackup.marketrate - ((floor((  (((broktable.day_sales/ 100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + trdbackup.marketrate ),broktable.round_to )*/
                                                                 trdbackup.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (trdbackup.marketrate + round(( broktable.sett_purch/100) * trdbackup.marketrate ,broktable.round_to))*/
                                                                 trdbackup.marketrate + ((floor(( ( (( broktable.sett_purch/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero ))
 * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( trdbackup.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( trdbackup.marketrate - broktable.sett_sales ),broktable.round_to) */
                       trdbackup.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( trdbackup.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (trdbackup.marketrate - round((broktable.sett_sales/100) * trdbackup.marketrate ,broktable.round_to)) */
                                                                 trdbackup.marketrate -  ((floor((  (((broktable.sett_sales/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero ))
 * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
       Amount = 
                             (  case  
                                          when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( trdbackup.marketrate + broktable.Normal),broktable.round_to) */
                                                             trdbackup.Tradeqty  *  (  trdbackup.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))

                                           when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((trdbackup.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                trdbackup.Tradeqty * (   trdbackup.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
                                           when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (trdbackup.marketrate + round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to)) */
                                                               trdbackup.Tradeqty  * (   trdbackup.marketrate + ((floor(( (((broktable.Normal /100 )* trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (trdbackup.marketrate - round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to))           */
                                                                trdbackup.Tradeqty * (   trdbackup.marketrate -  ((floor((  ( ((broktable.Normal /100 )* trdbackup.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + trdbackup.marketrate ),broktable.round_to)*/
                                                             trdbackup.Tradeqty * (    trdbackup.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (trdbackup.marketrate + round((broktable.day_puc/100) * trdbackup.marketrate ,broktable.round_to))*/
                                                               trdbackup.Tradeqty * ( trdbackup.marketrate + ((floor(( (((broktable.day_puc/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((trdbackup.marketrate - broktable.day_sales),broktable.round_to)*/
                                                              trdbackup.Tradeqty * ( trdbackup.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (trdbackup.marketrate - round((broktable.day_sales/ 100) * trdbackup.marketrate ,broktable.round_to))*/
                                                              trdbackup.Tradeqty * (  trdbackup.marketrate - ((floor((  (((broktable.day_sales/ 100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + trdbackup.marketrate ),broktable.round_to )*/
                                                               trdbackup.Tradeqty * (  trdbackup.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))


                                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (trdbackup.marketrate + round(( broktable.sett_purch/100) * trdbackup.marketrate ,broktable.round_to))*/
                                                               trdbackup.Tradeqty * (  trdbackup.marketrate + ((floor(( ( (( broktable.sett_purch/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                        when ( trdbackup.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( trdbackup.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                     trdbackup.Tradeqty * ( trdbackup.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) )
                                         when ( trdbackup.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (trdbackup.marketrate - round((broktable.sett_sales/100) * trdbackup.marketrate ,broktable.round_to)) */
                                                       trdbackup.Tradeqty  * (  trdbackup.marketrate -  ((floor((  (((broktable.sett_sales/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
   Else  0 
                        End 
                         ),


        Ins_chrg  = ((floor(( ((taxes.insurance_chrg * trdbackup.marketrate * trdbackup.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),


        turn_tax  =  ((floor(( ((taxes.turnover_tax * trdbackup.marketrate * trdbackup.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to)),

        other_chrg = ((floor(( ((taxes.other_chrg * trdbackup.marketrate * trdbackup.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to)),

        sebi_tax =     ((floor(( ((taxes.sebiturn_tax * trdbackup.marketrate * trdbackup.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to)),

        Broker_chrg =  ((floor(( ((taxes.broker_note * trdbackup.marketrate * trdbackup.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),


        Service_tax =  (case  
                        when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * trdbackup.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (trdbackup.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * trdbackup.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * trdbackup.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  trdbackup.marketrate,broktable.round_to)  * trdbackup.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( trdbackup.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * trdbackup.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( trdbackup.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
NBrokApp = (  case  
                         when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * trdbackup.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /
 power(10,broktable.round_to))
                        when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * trdbackup.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                   when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                  when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * trdbackup.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * trdbackup.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
             when ( trdbackup.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( trdbackup.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * trdbackup.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * trdbackup.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
       N_NetRate = (  case  
                                          when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( trdbackup.marketrate + broktable.Normal),broktable.round_to) */
                                                                 trdbackup.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((trdbackup.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  trdbackup.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (trdbackup.marketrate + round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to)) */
                                                                   trdbackup.marketrate + ((floor(( (((broktable.Normal /100 )* trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * 
(broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( trdbackup.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (trdbackup.marketrate - round((broktable.Normal /100 )* trdbackup.marketrate,broktable.round_to))           */
                                                                   trdbackup.marketrate -  ((floor((  ( ((broktable.Normal /100 )* trdbackup.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )
) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + trdbackup.marketrate ),broktable.round_to)*/
                                                                 trdbackup.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (trdbackup.marketrate + round((broktable.day_puc/100) * trdbackup.marketrate ,broktable.round_to))*/
                                                                trdbackup.marketrate + ((floor(( (((broktable.day_puc/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((trdbackup.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               trdbackup.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (trdbackup.marketrate - round((broktable.day_sales/ 100) * trdbackup.marketrate ,broktable.round_to))*/
                                                                trdbackup.marketrate - ((floor((  (((broktable.day_sales/ 100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + trdbackup.marketrate ),broktable.round_to )*/
                                                                 trdbackup.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (trdbackup.marketrate + round(( broktable.sett_purch/100) * trdbackup.marketrate ,broktable.round_to))*/
                                                                 trdbackup.marketrate + ((floor(( ( (( broktable.sett_purch/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero ))
 * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( trdbackup.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( trdbackup.marketrate - broktable.sett_sales ),broktable.round_to) */
                       trdbackup.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( trdbackup.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (trdbackup.marketrate - round((broktable.sett_sales/100) * trdbackup.marketrate ,broktable.round_to)) */
                                                                 trdbackup.marketrate -  ((floor((  (((broktable.sett_sales/100) * trdbackup.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero ))
 * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 
                        End 
                         ),

        NSertax =  (case  
                        when ( trdbackup.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * trdbackup.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (trdbackup.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (trdbackup.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (trdbackup.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (trdbackup.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * trdbackup.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (trdbackup.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( trdbackup.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * trdbackup.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( trdbackup.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  trdbackup.marketrate,broktable.round_to)  * trdbackup.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( trdbackup.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * trdbackup.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( trdbackup.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * trdbackup.marketrate,broktable.round_to) * trdbackup.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  trdbackup.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * trdbackup.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         )
FROM BrokTable,TrdBackUp,SUBtaxes TAXES,globals,scrip1,scrip2,Sett_mst,SubBrokerConCursorSalePur C, MultiBroker M
  WHERE 
 TrdBackUp.PartiPantCode = C.PartiPantCode and TrdBackUp.Sauda_Date like C.SDate + '%'  and
                TrdBackUp.Scrip_Cd = C.Scrip_Cd And
 TrdBackUp.Series = C.Series And
 TrdBackUp.MarketType = C.MarketType And
    TrdBackUp.TMark = C.Tmark and
 TrdBackUp.PartiPantCode = M.CltCode and
 TrdBackUp.User_Id = M.User_Id and                 
           ((TrdBackUp.Sauda_date <= sett_mst.End_date) And (TrdBackUp.Sauda_date >= sett_mst.Start_date))   
       And
  (sett_mst.sett_type = 
   ( 
    case    
    when TrdBackUp.series = 'AE'   AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
    then 
    'M'
   
   when TrdBackUp.series = 'AE' AND (scrip1.demat_date >= Sett_mst.Sec_payout) 
    then 
    'P'
   when TrdBackUp.series = 'BE' 
   then 
   'W'
   when TrdBackUp.series = 'TT' 
   then 
   'O'
   
   when TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3'
   then 
   'L'
   when  TrdBackUp.series <> 'BE' and TrdBackUp.series <> 'AE' and TrdBackUp.markettype = '1'
   then 
   'N'
   
   when TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '4'
   then 
   'A'
   when TrdBackUp.series = '01'  and TrdBackUp.markettype = '3'
   then 
   'P'
   when TrdBackUp.series = '02'  and TrdBackUp.markettype = '3'
   then 
   'P'
   when TrdBackUp.series = '03'  and TrdBackUp.markettype = '3'
   then 
   'P'
   when TrdBackUp.series = '04'  and TrdBackUp.markettype = '3'
   then 
   'P'
   when TrdBackUp.series = '05'  and TrdBackUp.markettype = '3'
   then 
   'P'
   end)
       ) 
           And 
              (TrdBackUp.Series = scrip2.series)
           And
             (scrip2.scrip_cd = TrdBackUp.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
   Broktable.Table_no = ( case when ( trdbackup.series = 'EQ'  and trdbackup.markettype = '3' ) Then
           			( Case When ( trdbackup.SELL_BUY = 1 AND trdbackup.TMARK = '$' )
           				Then m.P_To_P
           				Else ( Case When ( trdbackup.SELL_BUY = 2 AND trdbackup.TMARK = '$' )
           						Then m.sb_tableno
          					 	Else AlbmCF_tableno
           					End )
				end )
      			else ( case when (trdbackup.TMark = 'D' )
                			then m.Sub_TableNo          
           				else m.table_no   
      				end  ) 
      			End ) 
            And 
            Broktable.Line_no = ( case when trdbackup.TMark = 'D' then 
           (				Select min(Broktable.line_no) from broktable where
                          		Broktable.table_no = m.Sub_TableNo and Trd_Del = 'D'  
                                        and Trdbackup.Partipantcode =  m.cltcode    
                          		and trdbackup.marketrate <= Broktable.upper_lim )
      				ELSE ( case when ( trdbackup.series = 'EQ'  and trdbackup.markettype = '3' ) Then
          					(Select min(Broktable.line_no) from broktable where
                                       		Broktable.table_no = ( Case When ( trdbackup.SELL_BUY = 1 AND trdbackup.TMARK = '$' )
             									Then m.P_To_P
             									Else ( Case When ( trdbackup.SELL_BUY = 2 AND trdbackup.TMARK = '$' )
										                Then m.sb_tableno
										                Else AlbmCF_tableno
									             End )
								                End )  
				                                              and Trdbackup.Partipantcode =  m.cltcode and Trd_Del = 'T'   
                                						and trdbackup.marketrate <= Broktable.upper_lim )
							             Else ( case when (trdbackup.TMark = 'D' )  then 
								                  (Select min(Broktable.line_no) from broktable where
						                                   Broktable.table_no = m.demat_tableno and Trd_Del = 'D'  
			                                                           and Trdbackup.Partipantcode =  m.cltcode    
                             						           and trdbackup.marketrate <= Broktable.upper_lim )    
									        else ( case when m.brok_scheme = 2 then 
									           (Select min(Broktable.line_no) from broktable where
				                                                     Broktable.table_no = m.table_no                                                  
							                         and Trd_Del =       
										          ( Case When c.PQty = c.SQty then 
											          ( Case When c.PRate >= c.SRate 
        											  then ( Case When ( trdbackup.Sell_Buy = 1 ) 
										                          Then 'F'  
									                	          Else 'S'
											                 End )
											          Else
											               ( Case When ( trdbackup.Sell_Buy = 2 ) 
										                          Then 'F'  
											                   Else 'S'
											          End )     
										          End )
										     Else
         ( Case When c.Pqty >= c.Sqty 
                then ( Case When ( trdbackup.Sell_Buy = 1 ) 
                         Then 'F'  
                         Else 'S'
                End )
                Else
                    ( Case When ( trdbackup.Sell_Buy = 2 ) 
                               Then 'F'  
                        Else 'S'
                      End )     
           End )
           End )
           and Trdbackup.Partipantcode =  m.cltcode    
                                                     and trdbackup.marketrate <= Broktable.upper_lim) 
      else ( case when m.brok_scheme = 1 then     
                 (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = m.table_no                                                  
                         and Trd_Del = ( Case When c.Pqty >= c.Sqty 
           then ( Case When ( trdbackup.Sell_Buy = 1 ) 
                    Then 'F'  
                    Else 'S'
                 End )
                Else
                ( Case When ( trdbackup.Sell_Buy = 2 ) 
                    Then 'F'  
                    Else 'S'
                 End )     
             End )
                                                     and Trdbackup.Partipantcode =  m.cltcode    
                                                     and trdbackup.marketrate <= Broktable.upper_lim)           
      else ( case when m.brok_scheme = 3 then     
                 (Select min(Broktable.line_no) from broktable where
                                                     Broktable.table_no = m.table_no                                                  
                         and Trd_Del = ( Case When c.Pqty > c.Sqty 
           then ( Case When ( trdbackup.Sell_Buy = 1 ) 
                    Then 'F'  
                    Else 'S'
                 End )
                Else
                ( Case When ( trdbackup.Sell_Buy = 2 ) 
                    Then 'F'  
                    Else 'S'
                 End )     
             End )
                                                       and Trdbackup.Partipantcode =  m.cltcode    
                                                      and trdbackup.marketrate <= Broktable.upper_lim)           
       else 
              (Select min(Broktable.line_no) from broktable 
               where Broktable.table_no = m.table_no   
                /* And Trd_Del = 'T' */
                               and Trdbackup.Partipantcode =  m.cltcode        
                     and trdbackup.marketrate <= Broktable.upper_lim ) 
       end )
      end )
                  end ) 
    end )
         end )
  end )
and            
 taxes.exchange = 'NSE'
  and taxes.trans_cat = 'TRD'  
  and trdbackup.sauda_Date like @TrdDate + '%'

GO
