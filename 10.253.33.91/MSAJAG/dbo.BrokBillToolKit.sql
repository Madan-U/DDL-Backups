-- Object: PROCEDURE dbo.BrokBillToolKit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BrokBillToolKit    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.BrokBillToolKit    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.BrokBillToolKit    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.BrokBillToolKit    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.BrokBillToolKit    Script Date: 12/27/00 8:58:45 PM ******/

CREATE proc BrokBillToolKit (@Sett_no varchar(7), @Sett_Type varchar(2)) as
update settlement set
       NBrokApp = (  case  
    when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                             Then broktable.normal 
                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                             Then (broktable.normal/100) * settlement.marketrate 
   when ( settlement.billflag = 5  and broktable.val_perc ="V" )
                             Then broktable.normal 
                        when ( settlement.billflag = 5  and broktable.val_perc ="P" )
                             Then (broktable.normal/100) * settlement.marketrate 
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
   when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.normal + settlement.marketrate ) )
                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate + (( broktable.normal/100) * settlement.marketrate )))
   when ( settlement.billflag =5  and broktable.val_perc ="V" )
                             Then (( settlement.marketrate - broktable.normal ))
                        when ( settlement.billflag =5  and broktable.val_perc ="P" )
                             Then ((settlement.marketrate - ((broktable.normal/100) * settlement.marketrate )))
   Else  
             NetRate 
                        End 
                         ),
        NSertax = (case  
   when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                             Then ((broktable.normal) * ( settlement.Tradeqty * Globals.service_tax) / 100)
                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                             Then (( broktable.normal/100) * ( settlement.marketrate  * settlement.Tradeqty * Globals.service_tax)/100 )
   when ( settlement.billflag = 5  and broktable.val_perc ="V" )
                             Then ( (broktable.normal * settlement.Tradeqty * Globals.service_tax) /100)
                        when ( settlement.billflag = 5  and broktable.val_perc ="P" )
                             Then  ( (broktable.normal/100) * ( settlement.marketrate * settlement.Tradeqty * globals.service_tax)  /100)
   Else  
       settlement.Service_tax
                        End 
                         )
                                                  
      FROM BrokTable,Client2,settlement,taxes,globals,scrip1,scrip2,Sett_mst,client1 
      WHERE 
            settlement.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
           ((settlement.Sauda_date <= sett_mst.End_date) And (settlement.Sauda_date >= sett_mst.Start_date))
    
       And
  (sett_mst.sett_type = 
   ( 
    case    
    when settlement.series = 'AE'   AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
    then 
    'M'
   
   when settlement.series = 'AE' AND (scrip1.demat_date >= Sett_mst.Sec_payout) 
    then 
    'P'
   when settlement.series = 'BE' 
   then 
   'W'
   when settlement.series = 'TT' 
   then 
   'O'
   when  settlement.series <> 'BE' and settlement.series <> 'AE' and settlement.markettype = '1'
   then 
   'N'
   end)
       ) 
           And 
              (settlement.Series = scrip2.series)
           And
             (scrip2.scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
 (Broktable.Table_no = ( case 
 when (settlement.sett_type = 'L')
 then client2.P_To_P
 else ( case
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
                         then 
                              client2.demat_tableno 
                         Else 
                               client2.sub_tableno 
                   end) 
 end  ) )
            And 
              Broktable.Line_no =  
 ( case
             when ( settlement.sett_type = 'L')
            then   (Select min(Broktable.line_no) from broktable where
                            Broktable.table_no = client2.p_to_p and settlement.marketrate <= Broktable.upper_lim  and settlement.Party_Code =  Client2.Party_code) 
 else
                 (Select min(Broktable.line_no) from broktable where
                       ( Broktable.table_no = 
                        ( case 
                         when 
                             (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
                         then 
                              client2.demat_tableno
                         Else
                              client2.sub_tableno   
                         end ) 
                        and
                        settlement.Party_Code =  Client2.Party_code    )  
                                            
                        and  
                        (settlement.marketrate <= Broktable.upper_lim) )
 end )
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')            
  And (billflag = 4 or billflag = 5)
   and settlement.sett_no = @sett_no 
   and settlement.sett_type = @sett_type

GO
