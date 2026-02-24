-- Object: PROCEDURE dbo.chgdeltax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.chgdeltax    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.chgdeltax    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.chgdeltax    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.chgdeltax    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.chgdeltax    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.chgdeltax    Script Date: 12/18/99 8:24:07 AM ******/
CREATE PROCEDURE chgdeltax
@partycode char(10)
AS
 update settlement set  
  
 BrokApplied = (  case  
                        when ( settlement.billflag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then broktable.Normal
                        when ( settlement.billflag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then broktable.Normal    
                        when ( settlement.billflag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then (broktable.Normal /100 ) * settlement.marketrate
   when ( settlement.billflag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then (broktable.Normal /100 )* settlement.marketrate         
   Else
       Brokapplied
                        End 
                         ),
 Amount =  (case  
   when ( settlement.Billflag = 1  and broktable.val_perc ="V" )
                             Then ((broktable.normal + settlement.marketrate )   * settlement.Tradeqty)
                        when ( settlement.Billflag = 1  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate + (( broktable.normal/100) * settlement.marketrate ))  * settlement.Tradeqty)
   Else  settlement.amount
                        End 
                        ) ,               
       
 Service_tax = (case  
   when ( settlement.billflag = 1 and broktable.val_perc ="V")
                             Then (broktable.Normal * settlement.Tradeqty * Globals.service_tax) / 100
                        when (settlement.billflag = 1 and broktable.val_perc ="P")
                             Then ((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100)
                        
   Else  settlement.service_tax 
                        End 
                         ),
        Ins_chrg  = ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100), 
        turn_tax  = ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),              
        other_chrg = ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ), 
        sebi_tax = ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),              
        Broker_chrg = ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100)
FROM BrokTable,Client2,settlement,taxes,globals,scrip1,scrip2,Sett_mst,client1 
      WHERE  
      settlement.party_code = @partycode 
            And
               client2.Party_Code = settlement.party_code
     and
     client1.cl_code=client2.cl_code
           And  
           ((Settlement.Sauda_date <= sett_mst.End_date) And (Settlement.Sauda_date >= sett_mst.Start_date))
           And 
              (Settlement.Series = scrip2.series)
           And
             (scrip2.scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
            (Broktable.Table_no = ( case 
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)                         then 
                              client2.demat_tableno 
                         Else 
                              client2.table_no 
                         End  ))
            And 
              Broktable.Line_no = 
                 (Select min(Broktable.line_no) from broktable where
                       ( Broktable.table_no =
                        (case                          when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
                         then 
                              client2.demat_tableno
                         Else
                              client2.table_no   
                         end
                         ) 
                        and
                        Client2.Party_code = settlement.party_code
                        ) 
                      and  
    (Settlement.marketrate <= Broktable.upper_lim))
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')
           and billflag  = 1 
      /*  order by settlement.party_code,settlement.scrip_cd,settlement.Tradeqty,settlement.sell_buy ,settlement.user_id*/

GO
