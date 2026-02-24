-- Object: PROCEDURE dbo.SubBrokerUpdBillTax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SubBrokerUpdBillTax    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.SubBrokerUpdBillTax    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.SubBrokerUpdBillTax    Script Date: 20-Mar-01 11:39:10 PM ******/


CREATE proc SubBrokerUpdBillTax as
UPDATE TrdBackUp SET 
     NBrokApp = (  case  
                       when ( TrdBackUp.billflag = 4  and broktable.val_perc ="V" )
                       Then broktable.normal 

                        when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                        Then  round((broktable.Normal /100 ) * TrdBackUp.marketrate,broktable.round_to)


                       when ( TrdBackUp.billflag = 5  and broktable.val_perc ="V" )
                       Then broktable.normal 

                       when ( TrdBackUp.billflag = 5  and broktable.val_perc ="P" )
                       Then round((broktable.Normal /100 ) * TrdBackUp.marketrate,broktable.round_to)
                  Else  
                       BrokApplied 
                  End 
                  ),

       N_NetRate = (  case  
                        when ( TrdBackUp.billflag = 4  and broktable.val_perc ="V" )
                        Then ((broktable.normal + TrdBackUp.marketrate ) )
                        when ( TrdBackUp.billflag = 4  and broktable.val_perc ="P" )
                        Then ((TrdBackUp.marketrate + round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to)))
                        
                        when ( TrdBackUp.billflag =5  and broktable.val_perc ="V" )
                        Then (( TrdBackUp.marketrate - broktable.normal ))
                        
                        when ( TrdBackUp.billflag =5  and broktable.val_perc ="P" )
                        Then ((TrdBackUp.marketrate - round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to)))
                    Else  
                        NetRate 
                    End 
                 ),
        NSertax = (   case  
                        when ( TrdBackUp.billflag = 4  and broktable.val_perc ="V" )
                        Then round((broktable.Normal * TrdBackUp.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( TrdBackUp.billflag = 4  and broktable.val_perc ="P" )
                        Then round(((broktable.Normal /100 ) * (TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( TrdBackUp.billflag = 5  and broktable.val_perc ="V" )
                        Then round((broktable.Normal * TrdBackUp.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( TrdBackUp.billflag = 5  and broktable.val_perc ="P" )
                        Then  round(((broktable.Normal /100 ) * (TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                    Else  
                        TrdBackUp.Service_tax
                    End 
                )
      FROM BrokTable,TrdBackUp,taxes,globals,scrip1,scrip2,Sett_mst,Owner O, MultiBroker M,SubBrokCursorBillSalePur C
      WHERE 
	TrdBackUp.PartiPantCode = C.PartiPantCode and TrdBackUp.Sett_No = C.Sett_No and TrdBackUp.Sett_Type = C.Sett_Type And
	TrdBackUp.Scrip_Cd = C.Scrip_Cd And
	TrdBackUp.Series = C.Series And
	/*TrdBackUp.MarketType = C.MarketType And*/
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
   when  TrdBackUp.series <> 'BE' and TrdBackUp.series <> 'AE' and TrdBackUp.markettype = '1'
   then 
   'N'
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
          and 
            Broktable.Table_no =  ( case when trdbackup.TMark = 'D' then 
					 	IsNull(M.Sub_TableNo,O.Sub_TableNo)
 					 else ( case when M.brok_scheme = 1 then
				                                         (case when (trdbackup.series = 'EQ' and trdbackup.markettype = '3')
                    						 then IsNull(M.P_To_P,O.P_To_P)
				                                            Else
               					                                 IsNull(M.Table_No,O.Table_No)
				                                            End)
						else ( case when ( trdbackup.series = 'EQ'  and trdbackup.markettype = '3')
							then IsNull(M.P_To_P,O.P_To_P)
			                      			 Else 
						 	           IsNull(M.Sub_TableNo,O.Sub_TableNo)          			  				         
	 					          end  ) 
					
		 			end ) 
				END )
            And 
              Broktable.Line_no =  ( case when TrdBackUp.TMark = 'D'   then 
					   (Select min(Broktable.line_no) from broktable where
		                                   Broktable.table_no =  IsNull(M.Sub_TableNo,O.Sub_TableNo)
                                                   and TrdBackUp.PartiPantCode = M.CltCode	
						   and TrdBackUp.User_Id = M.User_Id
		                                   and TrdBackUp.marketrate <= Broktable.upper_lim )         
                                      else ( case when M.brok_scheme = 1 then					
					        ( case when c.Pqty >= c.Sqty then
						       Isnull((Select min(Broktable.line_no) from broktable where
                                                       Broktable.table_no = (case when ( TrdBackUp.series = 'EQ' and TrdBackUp.markettype = '3')
                    				 				then IsNull(M.P_To_P,O.P_To_P)
                                            					Else
                                                					 IsNull(M.Sub_TableNo,O.Sub_TableNo)    
                                            					End)								
				                       and TrdBackUp.Sell_Buy = 1 
                                                       and TrdBackUp.PartiPantCode = M.CltCode	
						       and TrdBackUp.User_Id = M.User_Id  	
                                               	       and TrdBackUp.marketrate <= Broktable.upper_lim),
						 (Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = (case when ( TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3')
                    				 				then IsNull(M.P_To_P,O.P_To_P)
                                            					Else
                                                					 IsNull(M.Sub_TableNo,O.Sub_TableNo)    
                                            					End)									
					      	 and TrdBackUp.Sell_Buy = 2 and broktable.Val_perc = 'V'
	 		                         and TrdBackUp.PartiPantCode = M.CltCode	
						 and TrdBackUp.User_Id = M.User_Id))
						else ( case when c.Sqty > c.Pqty  then	
							 Isnull((Select min(Broktable.line_no) from broktable where
				                         Broktable.table_no = (case when ( TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3')
                    					 				then IsNull(M.P_To_P,O.P_To_P)
                                	            					Else
                                        	        							 IsNull(M.Sub_TableNo,O.Sub_TableNo)    
                                            						End)										
						      	 and TrdBackUp.Sell_Buy = 2
		 		                         and TrdBackUp.PartiPantCode = M.CltCode	
							 and TrdBackUp.User_Id = M.User_Id   	
		        	                	 and TrdBackUp.marketrate <= Broktable.upper_lim),
							 (Select min(Broktable.line_no) from broktable where
			                	         Broktable.table_no = (case when ( TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3')
                    					 				then IsNull(M.P_To_P,O.P_To_P)
                                            						Else
                                                						 IsNull(M.Sub_TableNo,O.Sub_TableNo)    
                                            						End)									
						      	 and TrdBackUp.Sell_Buy = 1 and broktable.Val_perc = 'V'
		 		                         and TrdBackUp.PartiPantCode = M.CltCode	
							 and TrdBackUp.User_Id = M.User_Id))
							end )
						end)
					else  (Select min(Broktable.line_no) from broktable where
			                	         Broktable.table_no = ( case when ( trdbackup.series = 'EQ'  and trdbackup.markettype = '3')
									then IsNull(M.P_To_P,O.P_To_P)
                	      			 			    Else 
					          				 IsNull(M.Sub_TableNo,O.Sub_TableNo)          
   								 end  ) 					
				                              and TrdBackUp.PartiPantCode = M.CltCode	
					              and TrdBackUp.User_Id = M.User_Id     
	  				              and (TrdBackUp.marketrate <= Broktable.upper_lim))
			 		end )       
			           end ) 

AND
                    (taxes.exchange = 'NSE')
             and taxes.trans_cat = 'TRD'               
  And (billflag = 4 or billflag = 5)

GO
