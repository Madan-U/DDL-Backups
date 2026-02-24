-- Object: PROCEDURE dbo.ChangeBrkhIS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ChangeBrkhIS    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.ChangeBrkhIS    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.ChangeBrkhIS    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.ChangeBrkhIS    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.ChangeBrkhIS    Script Date: 12/27/00 8:58:47 PM ******/

CREATE Procedure ChangeBrkhIS (@party varchar(10) , @s_date varchar(12)) as 
SELECT distinct HISTORY.Party_Code,client1.short_name,HISTORY.marketrate,
       HISTORY.user_id,HISTORY.Sauda_date,tradeqty,
       BrokTable.Table_No, BrokTable.Line_No,HISTORY.trade_no,
       BrokTable.Val_perc,Broktable.Normal,Broktable.Day_puc,Broktable.day_sales,
       Broktable.Sett_purch,Broktable.Sett_sales,HISTORY.Sell_buy,HISTORY.settflag,
       SerTax=globals.service_tax,globals.year,globals.exchange, client1.off_phone1,
       BrokApplied = (  case  
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then broktable.Normal
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then broktable.Normal    
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then (broktable.Normal /100 ) * HISTORY.marketrate
 when ( HISTORY.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then (broktable.Normal /100 )* HISTORY.marketrate         
 when (HISTORY.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then ((broktable.day_puc))
 when (HISTORY.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then (broktable.day_puc/100) * HISTORY.marketrate 
                 when (HISTORY.SettFlag = 3  and broktable.val_perc ="V" )
                             Then broktable.day_sales
                when (HISTORY.SettFlag = 3  and broktable.val_perc ="P" )
                             Then (broktable.day_sales/ 100) * HISTORY.marketrate 
             when ( HISTORY.SettFlag = 4  and broktable.val_perc ="V" )
                             Then broktable.sett_purch 
                        when ( HISTORY.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (broktable.sett_purch/100) * HISTORY.marketrate 
   when ( HISTORY.SettFlag = 5  and broktable.val_perc ="V" )
                             Then broktable.sett_sales 
                        when ( HISTORY.SettFlag = 5  and broktable.val_perc ="P" )
                             Then (broktable.sett_sales/100) * HISTORY.marketrate 
   Else  0 
                        End 
                         ),
       NetRate = (  case  
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then ( ( HISTORY.marketrate + broktable.Normal))
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then ((HISTORY.marketrate - broktable.Normal ) )   
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then ((HISTORY.marketrate + ((broktable.Normal /100 )* HISTORY.marketrate)))
   when ( HISTORY.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then ((HISTORY.marketrate - ((broktable.Normal /100 )* HISTORY.marketrate)))         
   when (HISTORY.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ((broktable.day_puc + HISTORY.marketrate ))
   when (HISTORY.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ((HISTORY.marketrate + ((broktable.day_puc/100) * HISTORY.marketrate )))
          when (HISTORY.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ((  HISTORY.marketrate - broktable.day_sales))
   when (HISTORY.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ((HISTORY.marketrate - ((broktable.day_sales/ 100) * HISTORY.marketrate )))
   when ( HISTORY.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.sett_purch + HISTORY.marketrate ) )
                        when ( HISTORY.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ((HISTORY.marketrate + (( broktable.sett_purch/100) * HISTORY.marketrate )))
   when ( HISTORY.SettFlag =5  and broktable.val_perc ="V" )
                             Then (( HISTORY.marketrate - broktable.sett_sales ))
                        when ( HISTORY.SettFlag =5  and broktable.val_perc ="P" )
                             Then ((HISTORY.marketrate - ((broktable.sett_sales/100) * HISTORY.marketrate )))
   Else  0 
                        End 
                         ),
       Amount =  (case  
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then (( HISTORY.marketrate + broktable.Normal) * HISTORY.Tradeqty)
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then ((HISTORY.marketrate - broktable.Normal   ) * HISTORY.Tradeqty)   
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then ((HISTORY.marketrate + ((broktable.Normal /100 )* HISTORY.marketrate)) * HISTORY.Tradeqty)
   when ( HISTORY.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then ((HISTORY.marketrate - ((broktable.Normal /100 )* HISTORY.marketrate)) * HISTORY.Tradeqty)         
   when (HISTORY.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ((broktable.day_puc + HISTORY.marketrate )  * HISTORY.Tradeqty)
   when (HISTORY.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ((HISTORY.marketrate + ((broktable.day_puc/100) * HISTORY.marketrate )) * HISTORY.Tradeqty)
          when (HISTORY.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ((  HISTORY.marketrate - broktable.day_sales) * HISTORY.Tradeqty)
   when (HISTORY.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ((HISTORY.marketrate - ((broktable.day_sales/ 100) * HISTORY.marketrate ))* HISTORY.Tradeqty)
   when ( HISTORY.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.sett_purch + HISTORY.marketrate )   * HISTORY.Tradeqty)
                        when ( HISTORY.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ((HISTORY.marketrate + (( broktable.sett_purch/100) * HISTORY.marketrate ))  * HISTORY.Tradeqty)
   when ( HISTORY.SettFlag =5  and broktable.val_perc ="V" )
                             Then (( HISTORY.marketrate - broktable.sett_sales )   * HISTORY.Tradeqty)
                        when ( HISTORY.SettFlag =5  and broktable.val_perc ="P" )
                             Then ((HISTORY.marketrate - ((broktable.sett_sales/100) * HISTORY.marketrate ))   * HISTORY.Tradeqty)
   Else  0 
                        End 
                         ),
        Ins_chrg  = ((taxes.insurance_chrg * HISTORY.marketrate * HISTORY.Tradeqty)/100), 
        turn_tax  = ((taxes.turnover_tax * HISTORY.marketrate * HISTORY.Tradeqty)/100 ),              
        other_chrg = ((taxes.other_chrg * HISTORY.marketrate * HISTORY.Tradeqty)/100 ), 
        sebi_tax = ((taxes.sebiturn_tax * HISTORY.marketrate * HISTORY.Tradeqty)/100),              
        Broker_chrg = ((taxes.broker_note * HISTORY.marketrate * HISTORY.Tradeqty)/100),
        Service_tax = (case  
                        when ( HISTORY.SettFlag = 1 and broktable.val_perc ="V")
                             Then (broktable.Normal * HISTORY.Tradeqty * Globals.service_tax) / 100
                        when (HISTORY.SettFlag = 1 and broktable.val_perc ="P")
                             Then ((broktable.Normal /100 ) * (HISTORY.marketrate * HISTORY.Tradeqty * globals.service_tax) / 100)
   when (HISTORY.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ( (broktable.day_puc * HISTORY.Tradeqty * globals.service_tax) /100)
   when (HISTORY.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ((broktable.day_puc/100) * ( HISTORY.marketrate * HISTORY.Tradeqty * Globals.service_tax) / 100)
          when (HISTORY.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ((broktable.day_sales * HISTORY.Tradeqty * Globals.service_tax) / 100)
   when (HISTORY.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ((broktable.day_sales/ 100) * ( HISTORY.marketrate * HISTORY.Tradeqty * globals.service_tax) / 100)
   when ( HISTORY.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.sett_purch) * ( HISTORY.Tradeqty * Globals.service_tax) / 100)
                        when ( HISTORY.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (( broktable.sett_purch/100) * ( HISTORY.marketrate  * HISTORY.Tradeqty * Globals.service_tax)/100 )
   when ( HISTORY.SettFlag = 5  and broktable.val_perc ="V" )
                             Then ( (broktable.sett_sales * HISTORY.Tradeqty * Globals.service_tax) /100)
                        when ( HISTORY.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  ( (broktable.sett_sales/100) * ( HISTORY.marketrate * HISTORY.Tradeqty * globals.service_tax)  /100)
   Else  0 
                        End 
                         ),
      Trade_amount = HISTORY.Tradeqty * HISTORY.MarketRate 
                                                  
      FROM BrokTable,Client2,HISTORY,taxes,globals,scrip1,scrip2,Sett_mst,client1 
      WHERE 
            HISTORY.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
           ((HISTORY.Sauda_date <= sett_mst.End_date) And (HISTORY.Sauda_date >= sett_mst.Start_date))
    
       And
  (sett_mst.sett_type = 
   ( 
    case    
    when HISTORY.series = 'AE'   AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
    then 
    'M'
   
   when HISTORY.series = 'AE' AND (scrip1.demat_date >= Sett_mst.Sec_payout) 
    then 
    'P'
   when HISTORY.series = 'BE' 
   then 
   'W'
   when HISTORY.series = 'TT' 
   then 
   'O'
   
   when HISTORY.series = 'EQ'  and HISTORY.markettype = '3'
   then 
   'L'
   when  HISTORY.series <> 'BE' and HISTORY.series <> 'AE' and HISTORY.markettype = '1'
   then 
   'N'
   
   when HISTORY.series = 'EQ'  and HISTORY.markettype = '4'
   then 
   'A'
   end)
       ) 
           And 
              (HISTORY.Series = scrip2.series)
           And
             (scrip2.scrip_cd = HISTORY.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
            (Broktable.Table_no = ( case 
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
                         then 
                              client2.demat_tableno 
/*      When  
                             (Client2.Tran_cat = 'TRD')  And  (HISTORY..Series = 'BE')
                        Then
                                Client2.sub_TableNo   */
                         Else 
                              client2.table_no 
                         end  ))
/*            AND 
              HISTORY.MarketRate <= BrokTable.Upper_lim  */
            And 
              Broktable.Line_no = 
                 (Select min(Broktable.line_no) from broktable where
                       ( Broktable.table_no =
                        (case 
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
                         then 
                              client2.demat_tableno
/*  When  
                             (Client2.Tran_cat = 'TRD')  And  (HISTORY..Series = 'BE')
                        Then
                                Client2.sub_TableNo  */
                         Else 
                              client2.table_no   
                         end
                         ) 
                        and
                        HISTORY.Party_Code =  Client2.Party_code 
                        ) 
                                            
                      and  
                        (HISTORY.marketrate <= Broktable.upper_lim))
               
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')
    And HISTORY.party_code = @party
   and convert(varchar,sauda_date,103) = @s_date 
                  AND TRADEQTY > 0

GO
