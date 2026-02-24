-- Object: PROCEDURE dbo.Branchnewupdbilltax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Branchnewupdbilltax(@SETTNO VARCHAR(7),@SETTYPE VARCHAR(2),@statusid varchar(12),@statusname varchar(12)) as

If @StatusId = 'BROKER'
Begin
     If @settype = 'N' 
     Begin
          Update settlement set   Tmark = Tmark , table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
          Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
          Sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
          NBrokApp = (  case  
          When (  broktable.val_perc ="V" and settlement.billflag in(4,5) )
                             Then broktable.normal 
                        when (  broktable.val_perc ="P" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal /100 ) * settlement.marketrate), broktable.round_to)
          Else  
               BrokApplied 
                        End 
                         ),
          N_NetRate = (  case  
          When (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then ((broktable.normal + settlement.marketrate ) )
                        when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then((settlement.marketrate + round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
          When (broktable.val_perc ="V" AND settlement.SELL_BUY =2 and settlement.billflag = 5)
                             Then (( settlement.marketrate - broktable.normal ))
                        when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 and settlement.billflag = 5)
                             Then ((settlement.marketrate -  round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
          Else  
               NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
          NSertax = (case  
          When ( broktable.val_perc ="V" and settlement.billflag in(4,5))
                 Then round(((broktable.Normal * settlement.Tradeqty * Globals.service_tax) )/( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ), broktable.round_to)
          When (broktable.val_perc ="P" )
                           Then round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax)) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ),broktable.round_to)
          Else  
          Settlement.Service_tax
                        End 
                         ) ,
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to)
                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals, scrip1, scrip2,Sett_mst   ,Settlement
      WHERE 
            settlement.Party_Code = Client2.Party_code
   	and
	sett_mst.sett_type = settlement.sett_type	
     and sett_mst.sett_no = settlement.sett_no
           And
             (scrip2.Scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
 And Broktable.Table_no = ( Case When (client2.Tran_cat = 'DEL')  AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
				 Then client2.demat_tableno
			         Else ( Case When ( /* Billflag > 3  and*/ client2.Tran_cat = 'TRD') 
					     Then client2.sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then Client2.P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then Client2.Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then Client2.AlbmCF_tableno
										 Else CLIENT2.SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
			   End )
            And 
               Broktable.Line_no = 
                ( case 
                                      		when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = client2.Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
           /*(Client2.Tran_cat = Taxes.Trans_cat)*/
          /*  Taxes.trans_Cat = (case when client1.cl_type = 'PRO' then 'PRO' else  'del' end)  */
           Taxes.trans_Cat =  'Del' 
           And
             (Taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
end

else if @settype <> 'N' 
begin
    Update settlement set   Tmark = Tmark , table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
      NBrokApp = (  case  
    when (  broktable.val_perc ="V" and settlement.billflag in(4,5) )
                             Then broktable.normal 
                        when (  broktable.val_perc ="P" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal /100 ) * settlement.marketrate), broktable.round_to)
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
   when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then ((broktable.normal + settlement.marketrate ) )
                        when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then((settlement.marketrate + round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
   when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 and settlement.billflag = 5)
                             Then (( settlement.marketrate - broktable.normal ))
                        when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 and settlement.billflag = 5)
                             Then ((settlement.marketrate -  round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal * settlement.Tradeqty * Globals.service_tax) )/( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ), broktable.round_to)
                        when (broktable.val_perc ="P" )
                           Then round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax)) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ),broktable.round_to)
   Else  
       settlement.Service_tax
                        End 
                         ) ,
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to)
                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals, scrip1, scrip2,Sett_mst   ,Settlement
      WHERE 
            settlement.Party_Code = Client2.Party_code
   	and
	sett_mst.sett_type = settlement.sett_type	
     and sett_mst.sett_no = settlement.sett_no
           And
             (scrip2.Scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
 And Broktable.Table_no = ( Case When (client2.Tran_cat = 'DEL')  AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
				 Then client2.demat_tableno
			         Else ( Case When ( /* Billflag > 3  and*/ client2.Tran_cat = 'TRD') 
					     Then client2.sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then Client2.P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then Client2.Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then Client2.AlbmCF_tableno
										 Else CLIENT2.SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
			   End )
            And 
               Broktable.Line_no = 
                ( case 
                                      		when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = client2.Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
           /*(Client2.Tran_cat = Taxes.Trans_cat)*/
           Taxes.trans_Cat =  'DEL'    /* added by bhagyashree on 7-11-2001*/
           And
             (Taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'

End

End


If @StatusId = 'BRANCH'
Begin
if @settype = 'N' 
begin
    Update settlement set   Tmark = Tmark , table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
      NBrokApp = (  case  
    when (  broktable.val_perc ="V" and settlement.billflag in(4,5) )
                             Then broktable.normal 
                        when (  broktable.val_perc ="P" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal /100 ) * settlement.marketrate), broktable.round_to)
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
   when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then ((broktable.normal + settlement.marketrate ) )
                        when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then((settlement.marketrate + round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
   when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 and settlement.billflag = 5)
                             Then (( settlement.marketrate - broktable.normal ))
                        when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 and settlement.billflag = 5)
                             Then ((settlement.marketrate -  round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal * settlement.Tradeqty * Globals.service_tax) )/( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ), broktable.round_to)
                        when (broktable.val_perc ="P" )
                           Then round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax)) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ),broktable.round_to)
   Else  
       settlement.Service_tax
                        End 
                         ) ,
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to)
                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals, scrip1, scrip2,Sett_mst   ,Settlement,Client1
      WHERE 
            settlement.Party_Code = Client2.Party_code
   	and
	sett_mst.sett_type = settlement.sett_type	
     and sett_mst.sett_no = settlement.sett_no
           And
             (scrip2.Scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
 And Broktable.Table_no = ( Case When (client2.Tran_cat = 'DEL')  AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
				 Then client2.demat_tableno
			         Else ( Case When ( /* Billflag > 3  and*/ client2.Tran_cat = 'TRD') 
					     Then client2.sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then Client2.P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then Client2.Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then Client2.AlbmCF_tableno
										 Else CLIENT2.SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
			   End )
            And 
               Broktable.Line_no = 
                ( case 
                                      		when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = client2.Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
           /*(Client2.Tran_cat = Taxes.Trans_cat)*/
          /*  Taxes.trans_Cat = (case when client1.cl_type = 'PRO' then 'PRO' else  'del' end)  */
           Taxes.trans_Cat =  'Del' 
           And
             (Taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
And Client1.Branch_cd = @StatusName
And Client2.Cl_code = Client1.Cl_code
end

else if @settype <> 'N' 
begin
    Update settlement set   Tmark = Tmark , table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
      NBrokApp = (  case  
    when (  broktable.val_perc ="V" and settlement.billflag in(4,5) )
                             Then broktable.normal 
                        when (  broktable.val_perc ="P" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal /100 ) * settlement.marketrate), broktable.round_to)
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
   when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then ((broktable.normal + settlement.marketrate ) )
                        when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 and settlement.billflag = 4)
                             Then((settlement.marketrate + round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
   when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 and settlement.billflag = 5)
                             Then (( settlement.marketrate - broktable.normal ))
                        when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 and settlement.billflag = 5)
                             Then ((settlement.marketrate -  round((( broktable.normal/100) * settlement.marketrate ) , broktable.round_to)))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" and settlement.billflag in(4,5))
                             Then round(((broktable.Normal * settlement.Tradeqty * Globals.service_tax) )/( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ), broktable.round_to)
                        when (broktable.val_perc ="P" )
                           Then round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax)) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ),broktable.round_to)
   Else  
       settlement.Service_tax
                        End 
                         ) ,
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to)
                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals, scrip1, scrip2,Sett_mst   ,Settlement,client1
      WHERE 
            settlement.Party_Code = Client2.Party_code
   	and
	sett_mst.sett_type = settlement.sett_type	
     and sett_mst.sett_no = settlement.sett_no
           And
             (scrip2.Scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
 And Broktable.Table_no = ( Case When (client2.Tran_cat = 'DEL')  AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
				 Then client2.demat_tableno
			         Else ( Case When ( /* Billflag > 3  and*/ client2.Tran_cat = 'TRD') 
					     Then client2.sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then Client2.P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then Client2.Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then Client2.AlbmCF_tableno
										 Else CLIENT2.SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
			   End )
            And 
               Broktable.Line_no = 
                ( case 
                                      		when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = client2.Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
           /*(Client2.Tran_cat = Taxes.Trans_cat)*/
           Taxes.trans_Cat =  'DEL'    /* added by bhagyashree on 7-11-2001*/
           And
             (Taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
And client1.Branch_cd = @StatusName
and client2.cl_code = client1.cl_code
End

End

GO
