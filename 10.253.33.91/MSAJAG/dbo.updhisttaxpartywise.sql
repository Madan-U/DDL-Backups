-- Object: PROCEDURE dbo.updhisttaxpartywise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.updhisttaxpartywise    Script Date: 4/6/01 7:04:02 PM ******/
/****** Object:  Stored Procedure dbo.updhisttaxpartywise    Script Date: 3/17/01 9:56:13 PM ******/
/****** Object:  Stored Procedure dbo.updhisttaxpartywise    Script Date: 3/21/01 12:50:33 PM ******/
/****** Object:  Stored Procedure dbo.updhisttaxpartywise    Script Date: 20-Mar-01 11:39:11 PM ******/

/* Changed By BBG   24 APR 2001  for Rounding    */

/*Recent changes done by  vaishali on 03/03/2001  added condn. for status*/
CREATE proc updhisttaxpartywise  ( @party_code varchar (10) ,  @scrip_cd  varchar(12)  ) as
update history set
 	NBrokApp = (  case  
	when ( history.billflag = 4  and broktable.val_perc ="V" )
	Then /* broktable.normal  */
		((floor(( broktable.normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
	when ( history.billFlag = 4  and broktable.val_perc ="P" )
	Then  /* round((broktable.Normal /100 ) * history.marketrate,broktable.round_to) */
		((floor(( ((broktable.Normal /100 ) * history.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
	when ( history.billflag = 5  and broktable.val_perc ="V" )
	Then /* broktable.normal  */
		((floor(( broktable.normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
	when ( history.billflag = 5  and broktable.val_perc ="P" )
	Then /* round((broktable.Normal /100 ) * history.marketrate,broktable.round_to)*/
			((floor(( ((broktable.Normal /100 ) * history.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                  Else  
                       BrokApplied 
                  End 
                  ),
     N_NetRate = (  case  
                        when ( history.billflag = 4  and broktable.val_perc ="V" )
                        Then /* ((broktable.normal + history.marketrate ) ) */
		((floor(( ((broktable.normal + history.marketrate ) ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                        when ( history.billflag = 4  and broktable.val_perc ="P" )
/*                        Then ((history.marketrate + round((broktable.Normal /100 )* history.marketrate,broktable.round_to))) */
                        Then history.marketrate + 
		((floor(( ((broktable.Normal /100 )* history.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))                        
                        when ( history.billflag =5  and broktable.val_perc ="V" )
                        Then /* (( history.marketrate - broktable.normal )) */
		((floor(( (( history.marketrate - broktable.normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))                        
                        when ( history.billflag =5  and broktable.val_perc ="P" )
/*                        Then ((history.marketrate - round((broktable.Normal /100 )* history.marketrate,broktable.round_to))) */
                        Then history.marketrate - 
		((floor(( ((broktable.Normal /100 )* history.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))
                    Else  
                        NetRate 
                    End 
                 ),
/*     NSertax =   (   case  
                        
                        when ( history.billFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.normal,broktable.round_to) * history.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( history.billFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round((broktable.normal/100) *  history.marketrate,broktable.round_to)  * history.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( history.billFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.normal ,broktable.round_to) * history.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( history.billFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.normal/100) * history.marketrate,broktable.round_to) * history.Tradeqty * globals.service_tax)  /100),broktable.round_to) 
   Else  
                        history.Service_tax
                    End 
                ),  */


NSertax = (Case 
                        when ( history.billFlag = 4  and broktable.val_perc ="V" )
                             Then 
                                 /*  round((round(broktable.normal,broktable.round_to) * history.Tradeqty* Globals.service_tax) / 100,broktable.round_to) */

((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * history.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    
                                
                        when ( history.billFlag = 4  and broktable.val_perc ="P" )
                             Then /* round(((round(( broktable.normal/100) *  history.marketrate,broktable.round_to)  * history.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                  ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * history.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * history.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))
                                  
                             
                        when ( history.billFlag = 5  and broktable.val_perc ="V" )
                             Then 
                                  /* round ( (round(broktable.normal ,broktable.round_to) * history.Tradeqty* Globals.service_tax) /100,broktable.round_to)  */
((floor((
(((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * history.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( history.billFlag = 5  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.normal/100) * history.marketrate,broktable.round_to) * history.Tradeqty * globals.service_tax)  /100),broktable.round_to) */

((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * history.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * history.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))
   ELSE 
                         history.Service_tax
                    End 
                ),
/*          Ins_chrg  = round(((taxes.insurance_chrg * History.marketrate * History.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * History.marketrate * History.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * History.marketrate * History.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * History.marketrate * History.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * History.marketrate * History.Tradeqty)/100),broktable.round_to)  */


        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *history.marketrate *history.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),
        turn_tax  =  ((floor(( ((taxes.turnover_tax *history.marketrate *history.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to)),
        other_chrg = ((floor(( ((taxes.other_chrg *history.marketrate *history.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to)),
        sebi_tax =     ((floor(( ((taxes.sebiturn_tax *history.marketrate *history.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to)),
        Broker_chrg =  ((floor(( ((taxes.broker_note *history.marketrate *history.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),

   /* Add ed by Animesh On 18 Aug 2001 */
        Amount = NetRate * TradeQty , Trade_Amount = TradeQty * MarketRate


       FROM BrokTable,Client2,taxes,globals,scrip1,scrip2,Sett_mst,client1
      WHERE 
            history.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
           ((history.Sauda_date <= sett_mst.End_date) And (history.Sauda_date >= sett_mst.Start_date))
    
       And
  (sett_mst.sett_type = history.sett_type       ) 
           And 
              (history.Series = scrip2.series)
           And
             (scrip2.scrip_cd = history.scrip_cd)
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
     and history.Party_Code =  Client2.Party_code    
     And Trd_Del = 'D'
                                          and history.marketrate <= Broktable.upper_lim )            
                       end ) 
               
               
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')        
and client2.Tran_cat = 'TRD'
  And (billflag = 4 or billflag = 5)
  and history.tradeqty > 0
  And (history.party_code = @party_code )
  And ( history.scrip_cd = @scrip_cd  )  
  and history.sett_type not in ('L','P')
  and history.status <> 'E'   /*Added by vaishali on 03/03/2001*/ 

/*  Added By animesh for Angel cause they want Stamp Duty for only in Delivery Position on 13 Aug 2001 */

Update History Set Broker_Chrg = 0 Where Billflag in (2,3)

GO
