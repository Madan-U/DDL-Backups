-- Object: PROCEDURE dbo.Fosettupdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




create proc Fosettupdate(@Sdate Varchar(11)) as 
update fosettlement set BrokApplied = (  case  
      			when (fosettlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                              Then ROUND((broktable.day_puc),broktable.round_to)
	                when (fosettlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ROUND(((broktable.day_puc/100) * fosettlement.price ),broktable.round_to)
                        when (fosettlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ROUND((broktable.day_sales),BROKTABLE.ROUND_TO)
                        when (fosettlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ROUND(((broktable.day_sales/ 100) * fosettlement.price ),BROKTABLE.ROUND_TO)
                        when (fosettlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ROUND((broktable.sett_purch ),BROKTABLE.ROUND_TO)                        when (fosettlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ROUND(((broktable.sett_purch/100) * fosettlement.price),BROKTABLE.ROUND_TO)
	                when (fosettlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then ROUND((broktable.sett_sales),BROKTABLE.ROUND_TO) 
                        when (fosettlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then ROUND(((broktable.sett_sales/100) * fosettlement.price),BROKTABLE.ROUND_TO)
			Else  0 
                        End 
                         ),
 NetRate = (  case  
                       when (fosettlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ROUND((broktable.day_puc + fosettlement.price ),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 2  and broktable.val_perc ="P") 
                             Then ROUND(((fosettlement.price + ((broktable.day_puc/100) * fosettlement.price ))),BROKTABLE.ROUND_TO)
		        when (fosettlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ROUND(((fosettlement.price - broktable.day_sales)),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ROUND(((fosettlement.price - ((broktable.day_sales/ 100) * fosettlement.price ))),BROKTABLE.ROUND_TO)
			when ( fosettlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ROUND(((broktable.sett_purch + fosettlement.price ) ),BROKTABLE.ROUND_TO)
                        when (fosettlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ROUND(((fosettlement.price + (( broktable.sett_purch/100) * fosettlement.price ))),BROKTABLE.ROUND_TO)
			when ( fosettlement.SettFlag =5  and broktable.val_perc ="V" )
                             Then ROUND((( fosettlement.price - broktable.sett_sales )),BROKTABLE.ROUND_TO)
                        when ( fosettlement.SettFlag =5  and broktable.val_perc ="P" )
                             Then ROUND((fosettlement.price - ((broktable.sett_sales/100) * fosettlement.price )),BROKTABLE.ROUND_TO)
			Else  0 
                        End 
                         ),
     
             Amount =  (case         
			when (fosettlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ROUND(((broktable.day_puc + fosettlement.price )  * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ROUND(((fosettlement.price + ((broktable.day_puc/100) * fosettlement.price )) * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
		        when (fosettlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ROUND(((fosettlement.price - broktable.day_sales) * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ROUND(((fosettlement.price - ((broktable.day_sales/ 100) * fosettlement.price ))* fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
			when ( fosettlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ROUND(((broktable.sett_purch + fosettlement.price )   * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
                        when ( fosettlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ROUND(((fosettlement.price + (( broktable.sett_purch/100) * fosettlement.price ))  * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
			when ( fosettlement.SettFlag =5  and broktable.val_perc ="V" )
                             Then ROUND((( fosettlement.price - broktable.sett_sales )   * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
                        when ( fosettlement.SettFlag =5  and broktable.val_perc ="P" )
                             Then ROUND(((fosettlement.price - ((broktable.sett_sales/100) * fosettlement.price))   * fosettlement.Tradeqty),BROKTABLE.ROUND_TO)
			Else  0 
                        End 
                         ),
        Ins_chrg  = ROUND(((FOTAXES.insurance_chrg * fosettlement.price * fosettlement.Tradeqty)/100),BROKTABLE.ROUND_TO), 
        turn_tax  = ROUND(((FOTAXES.turnover_tax * fosettlement.price * fosettlement.Tradeqty)/100 ),BROKTABLE.ROUND_TO),              
        other_chrg = ROUND(((FOTAXES.other_chrg * fosettlement.price * fosettlement.Tradeqty)/100 ),BROKTABLE.ROUND_TO), 
        sebi_tax = ROUND(((FOTAXES.sebiturn_tax * fosettlement.price * fosettlement.Tradeqty)/100),BROKTABLE.ROUND_TO),              
        Broker_chrg = ROUND(((FOTAXES.broker_note * fosettlement.price * fosettlement.Tradeqty)/100),BROKTABLE.ROUND_TO),
        Service_tax = (case  
                        when ( fosettlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then ROUND(((broktable.Normal * fosettlement.Tradeqty * FOGLOBALS.service_tax) / 100),BROKTABLE.ROUND_TO)
                        when (fosettlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then ROUND(((broktable.Normal /100 ) * (fosettlement.price * fosettlement.Tradeqty * FOGLOBALS.service_tax) / 100),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then ROUND(((broktable.day_puc * fosettlement.Tradeqty * FOGLOBALS.service_tax) /100),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then ROUND(((broktable.day_puc/100) * ( fosettlement.price * fosettlement.Tradeqty * FOGLOBALS.service_tax) / 100),BROKTABLE.ROUND_TO)
		        when (fosettlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then ROUND(((broktable.day_sales *fosettlement.Tradeqty * FOGLOBALS.service_tax) / 100),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then ROUND(((broktable.day_sales/ 100) * (fosettlement.price * fosettlement.Tradeqty * FOGLOBALS.service_tax) / 100),BROKTABLE.ROUND_TO)
			when (fosettlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then ROUND(((broktable.sett_purch) * (fosettlement.price * FOGLOBALS.service_tax) / 100),BROKTABLE.ROUND_TO)
                        when (fosettlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then ROUND((( broktable.sett_purch/100) * (fosettlement.price  * fosettlement.Tradeqty * FOGLOBALS.service_tax)/100 ),BROKTABLE.ROUND_TO)
			when ( fosettlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then ROUND(((broktable.sett_sales * fosettlement.Tradeqty * FOGLOBALS.service_tax) /100),BROKTABLE.ROUND_TO)
               when ( fosettlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  ROUND(((broktable.sett_sales/100) * ( fosettlement.price * fosettlement.Tradeqty * FOGLOBALS.service_tax) /100),BROKTABLE.ROUND_TO)
			Else  0 
                        End 
                         ),
      Trade_amount = fosettlement.Tradeqty * fosettlement.price
      FROM BrokTable,FOTAXES,foscrip2,client1,Client2,FOGLOBALS,fosettsalepursum s
      WHERE 
            fosettlement.party_code = Client2.Party_code
	   and
	    client1.cl_code=client2.cl_code            
           and fosettlement.inst_type = foscrip2.inst_type 
           AND fosettlement.SYMBOL = FOSCRIP2.SYMBOL      
           AND fosettlement.expirydate=foscrip2.expirydate and
          /* (Broktable.Table_no =  ltrim(client2.std_rate)
				   
           And 
             Broktable.Line_no =  (select min(line_no) from broktable where fosettlement.price <= Broktable.upper_lim 
					and broktable.table_no = ltrim(client2.std_rate)
					))  */                                                                    
          /*the below 2 lines are added on 27 th march 2001 at krc */
           fosettlement.party_code = s.party_code and
 	   fosettlement.inst_type=S.inst_type and  
           fosettlement.symbol=S.symbol and
           fosettlement.expirydate=S.expirydate  AND
/*---------------------------------------------------------------------------*/
            Broktable.Table_no = ltrim(client2.std_rate) And   
            Broktable.Line_no =  ( case when client2.brok_scheme = 1 then					
					       		   (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.std_rate                                            						
				                	    and Trd_Del = ( Case When s.Pqty >= s.Sqty 
										 then ( Case When ( fosettlement.Sell_Buy = 1 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( fosettlement.Sell_Buy = 2 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )					
									    End )
                                                	    and fosettlement.Party_Code =  Client2.Party_code   	
                                               		    and fosettlement.price <= Broktable.upper_lim)							    
			   	        when client2.brok_scheme = 3 then					
					       		   (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.std_rate                                    						
				                	    and Trd_Del = ( Case When s.Pqty > s.Sqty 
										 then ( Case When ( fosettlement.Sell_Buy = 1 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( fosettlement.Sell_Buy = 2 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )					
									    End )
                                        	            and fosettlement.Party_Code =  Client2.Party_code   	
                                               		    and fosettlement.price <= Broktable.upper_lim)	
                                     /* when client2.brok_scheme = 2 then	
				       			(Select min(Broktable.line_no) from broktable where
                                       			 Broktable.table_no = Client2.std_rate                                            						
				          		 and Trd_Del =	 ( Case When s.PQty = s.SQty then	
								  ( Case When s.PRate >= s.SRate 
									 then ( Case When ( fosettlement.Sell_Buy = 1 ) 
							    		             Then 'F'  
							    		             Else 'S'
									        End )
									 Else
									      ( Case When ( fosettlement.Sell_Buy = 2 ) 
							    		             Then 'F'  
							    			     Else 'S'
									        End )					
									 End )
								   Else
									( Case When s.Pqty >= s.Sqty 
									       then ( Case When ( fosettlement.Sell_Buy = 1 ) 
							    			           Then 'F'  
							    			           Else 'S'
										      End )
									       Else
									           ( Case When ( fosettlement.Sell_Buy = 2 ) 
							    		                  Then 'F'  
							    			          Else 'S'
									             End )					
									  End )
								   End )
							    and fosettlement.Party_Code =  fosettlement.Party_code   	
                                               		    and fosettlement.price <= Broktable.upper_lim)	*/ 						    
				    else 
                                       (  select min(line_no) from broktable 
                                          where fosettlement.price <= Broktable.upper_lim 
			                  and broktable.table_no = ltrim(client2.std_rate))
				   end )
             and   
            (Client2.Tran_cat = FOTAXES.Trans_cat)
           And
             (FOTAXES.exchange = 'NSE') 
       and fosettlement.sauda_date like s.sdate + '%'
       and fosettlement.sauda_date like @Sdate + '%'

GO
