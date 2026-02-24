-- Object: PROCEDURE dbo.ReUpdBillTax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ReUpdBillTax    Script Date: 4/6/01 7:04:01 PM ******/
/****** Object:  Stored Procedure dbo.ReUpdBillTax    Script Date: 3/17/01 9:55:54 PM ******/
/****** Object:  Stored Procedure dbo.ReUpdBillTax    Script Date: 3/21/01 12:50:11 PM ******/
/****** Object:  Stored Procedure dbo.ReUpdBillTax    Script Date: 20-Mar-01 11:38:53 PM ******/
/****** Object:  Stored Procedure dbo.ReUpdBillTax    Script Date: 2/5/01 12:06:15 PM ******/
/****** Object:  Stored Procedure dbo.ReUpdBillTax    Script Date: 12/27/00 8:58:52 PM ******/

/* CHANGED BY BGG 24 APR 2001 FOR ROUNDING   */

CREATE proc ReUpdBillTax (@sett_no varchar(10), @sett_type varchar(3),@Scrip_Cd Varchar(12),@Series Varchar(2)) as
update settlement set
	NBrokApp = (  case  
	when ( settlement.billflag = 4  and broktable.val_perc ="V" )
	Then /* broktable.normal  */
		((floor(( broktable.normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
	when ( settlement.billFlag = 4  and broktable.val_perc ="P" )
	Then  /* round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) */
		((floor(( ((broktable.Normal /100 ) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
	when ( settlement.billflag = 5  and broktable.val_perc ="V" )
	Then /* broktable.normal  */
		((floor(( broktable.normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
	when ( settlement.billflag = 5  and broktable.val_perc ="P" )
	Then /* round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to)*/
			((floor(( ((broktable.Normal /100 ) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))

                  Else  
                       BrokApplied 
                  End 
                  ),
     N_NetRate = (  case  
                        when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                        Then /* ((broktable.normal + settlement.marketrate ) ) */
		((floor(( ((broktable.normal + settlement.marketrate ) ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
/*                        Then ((settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))) */
                        Then settlement.marketrate + 
		((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))                        
                        when ( settlement.billflag =5  and broktable.val_perc ="V" )
                        Then /* (( settlement.marketrate - broktable.normal )) */
		((floor(( (( settlement.marketrate - broktable.normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))                        
                        when ( settlement.billflag =5  and broktable.val_perc ="P" )
/*                        Then ((settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))) */
                        Then settlement.marketrate - 
		((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                    Else  
                        NetRate 
                    End 
                 ),

NSertax = (Case 
                        when ( settlement.billFlag = 4  and broktable.val_perc ="V" )
                             Then 
                                 /*  round((round(broktable.normal,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to) */
                                       ((floor(( 
                                                  (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    
                                
                        when ( settlement.billFlag = 4  and broktable.val_perc ="P" )
                             Then /* round(((round(( broktable.normal/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                  ((floor(( 
                                             (((((floor((   ((broktable.Normal /100 ) * settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))
                                  
                             
                        when ( settlement.billFlag = 5  and broktable.val_perc ="V" )
                             Then 
                                  /* round ( (round(broktable.normal ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)  */
                                  ((floor(( 
                                             (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when ( settlement.billFlag = 5  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.normal/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to) */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))
   ELSE 
                         settlement.Service_tax
                    End 
                ),










  /*       NSertax = (Case 
                        when ( settlement.billFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.normal,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( settlement.billFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round(( broktable.normal/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( settlement.billFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.normal ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( settlement.billFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.normal/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to) 
   ELSE 
                         settlement.Service_tax
                    End 
                ),


        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to)   */


        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *settlement.marketrate *settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),
        turn_tax  =  ((floor(( ((taxes.turnover_tax *settlement.marketrate *settlement.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to)),
        other_chrg = ((floor(( ((taxes.other_chrg *settlement.marketrate *settlement.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to)),
        sebi_tax =     ((floor(( ((taxes.sebiturn_tax *settlement.marketrate *settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to)),
        Broker_chrg =  ((floor(( ((taxes.broker_note *settlement.marketrate *settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),
        Amount = NetRate * TradeQty , Trade_Amount = TradeQty * MarketRate
        FROM BrokTable,Client2,taxes,globals,scrip1,scrip2,Sett_mst,client1
        WHERE 
            settlement.Party_Code = Client2.Party_code
        and
            client1.cl_code=client2.cl_code
        And  
           ((settlement.Sauda_date <= sett_mst.End_date) And (settlement.Sauda_date >= sett_mst.Start_date))
    
       And
           (sett_mst.sett_type = settlement.sett_type       ) 
       And 
           (settlement.Series = scrip2.series)
       And
          (scrip2.scrip_cd = settlement.scrip_cd)
       And 
          (scrip2.co_code = scrip1.co_code) 
       And
          (scrip2.series = scrip1.series) 
       AND 
           Broktable.Table_no = ( case when (client2.Tran_cat = 'TRD')  then 
                           client2.Sub_TableNo            
   END )
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD')   then 
     (Select min(Broktable.line_no) from broktable where
                                Broktable.table_no = client2.Sub_TableNo
     and settlement.Party_Code =  Client2.Party_code    
     And Trd_Del = 'D'
                                          and settlement.marketrate <= Broktable.upper_lim )            
                       end ) 
               
               
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')        
and client2.Tran_cat = 'TRD'    
  And (billflag = 4 or billflag = 5)
  and settlement.tradeqty > 0
  and settlement.sett_type not in ('L','P')
  and settlement.status <> 'E'   /*Added by vaishali on 03/03/2001*/ 
and Settlement.sett_no = @sett_no
and Settlement.sett_type = @sett_type
and Settlement.Scrip_Cd = @Scrip_Cd
and Settlement.series = @series


/*  Added By animesh for Angel cause they want Stamp Duty for only in Delivery Position on 13 Aug 2001 */

Update History Set Broker_Chrg = 0 Where Billflag in (2,3)

GO
