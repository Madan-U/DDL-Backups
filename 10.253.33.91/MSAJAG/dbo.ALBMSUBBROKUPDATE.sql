-- Object: PROCEDURE dbo.ALBMSUBBROKUPDATE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC ALBMSUBBROKUPDATE (@SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2)) AS
update TrdBackUp set sett_no = sett_mst.sett_no , sett_type = Sett_Mst.sett_type,
table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
 BrokApplied = (  case  
                       	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             	Then broktable.Normal
                       	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             	Then broktable.Normal    

                       	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             	Then round((broktable.Normal /100 ) * TrdBackUp.marketrate,broktable.round_to)
 	         	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to)         

               		 when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then ((broktable.day_puc))
         	         when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round((broktable.day_puc/100) * TrdBackUp.marketrate,broktable.round_to) 

                 	 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then broktable.day_sales
                	 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round((broktable.day_sales/ 100) * TrdBackUp.marketrate ,broktable.round_to)

             		 when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then broktable.sett_purch 
                         when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round((broktable.sett_purch/100) * TrdBackUp.marketrate ,broktable.round_to)

          		 when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="V" )
                             Then broktable.sett_sales 
                         when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="P" )
                             Then round((broktable.sett_sales/100) * TrdBackUp.marketrate ,broktable.round_to)
   Else  0 
                        End 
                         ),
       NetRate = (  case  
                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then round(( TrdBackUp.marketrate + broktable.Normal),broktable.round_to)
                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then round((TrdBackUp.marketrate - broktable.Normal ),broktable.round_to )   

                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then (TrdBackUp.marketrate + round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to))
		         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then (TrdBackUp.marketrate - round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to))           

		         when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round((broktable.day_puc + TrdBackUp.marketrate ),broktable.round_to)
			 when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then (TrdBackUp.marketrate + round((broktable.day_puc/100) * TrdBackUp.marketrate ,broktable.round_to))

		         when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((TrdBackUp.marketrate - broktable.day_sales),broktable.round_to)
			 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate - round((broktable.day_sales/ 100) * TrdBackUp.marketrate ,broktable.round_to))

			 when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((broktable.sett_purch + TrdBackUp.marketrate ),broktable.round_to )
                         when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate + round(( broktable.sett_purch/100) * TrdBackUp.marketrate ,broktable.round_to))

			 when ( TrdBackUp.SettFlag =5  and broktable.val_perc ="V" )
                             Then round(( TrdBackUp.marketrate - broktable.sett_sales ),broktable.round_to)
                         when ( TrdBackUp.SettFlag =5  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate - round((broktable.sett_sales/100) * TrdBackUp.marketrate ,broktable.round_to))

   Else  0 
                        End 
                         ),
       Amount =  (case  
                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then ( round(( TrdBackUp.marketrate + broktable.Normal),broktable.round_to) * TrdBackUp.Tradeqty) 
                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then ( round((TrdBackUp.marketrate - broktable.Normal ),broktable.round_to ) * TrdBackUp.TRadeQty )   

                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then ((TrdBackUp.marketrate + round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to)) * TrdBackUp.Tradeqty)
		         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then ((TrdBackUp.marketrate - round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to)) * TrdBackUp.Tradeqty)           

		         when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then (round((broktable.day_puc + TrdBackUp.marketrate ),broktable.round_to) * TrdBackUp.Tradeqty)

			 when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then (((TrdBackUp.marketrate + round((broktable.day_puc/100) * TrdBackUp.marketrate ,broktable.round_to))) * TrdBackUp.Tradeqty)

		         when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((TrdBackUp.marketrate - broktable.day_sales),broktable.round_to) * TrdBackUp.Tradeqty
			 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate - round((broktable.day_sales/ 100) * TrdBackUp.marketrate ,broktable.round_to)) * TrdBackUp.Tradeqty

			 when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((broktable.sett_purch + TrdBackUp.marketrate ),broktable.round_to ) * TrdBackUp.Tradeqty
                         when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate + round(( broktable.sett_purch/100) * TrdBackUp.marketrate ,broktable.round_to)) * TrdBackUp.Tradeqty

			 when ( TrdBackUp.SettFlag =5  and broktable.val_perc ="V" )
                             Then round(( TrdBackUp.marketrate - broktable.sett_sales ),broktable.round_to) * TrdBackUp.Tradeqty
                         when ( TrdBackUp.SettFlag =5  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate - round((broktable.sett_sales/100) * TrdBackUp.marketrate ,broktable.round_to)) * TrdBackUp.Tradeqty

   Else  0 
                        End 
                         ),
        Ins_chrg  = round(((taxes.insurance_chrg * TrdBackUp.marketrate * TrdBackUp.Tradeqty)/100),broktable.round_to), 
        turn_tax  = round(((taxes.turnover_tax * TrdBackUp.marketrate * TrdBackUp.Tradeqty)/100 ),broktable.round_to),              
        other_chrg = round(((taxes.other_chrg * TrdBackUp.marketrate * TrdBackUp.Tradeqty)/100 ),broktable.round_to), 
        sebi_tax = round(((taxes.sebiturn_tax * TrdBackUp.marketrate * TrdBackUp.Tradeqty)/100),broktable.round_to),              
        Broker_chrg = round(((taxes.broker_note * TrdBackUp.marketrate * TrdBackUp.Tradeqty)/100),broktable.round_to),
        Service_tax = (case  
                        when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((broktable.Normal * TrdBackUp.Tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        when (TrdBackUp.SettFlag = 1 and broktable.val_perc ="P")
                             Then round(((broktable.Normal /100 ) * (TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (broktable.day_puc * TrdBackUp.Tradeqty * globals.service_tax) /100,broktable.round_to )

                        when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((broktable.day_puc/100) * ( TrdBackUp.marketrate * TrdBackUp.Tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((broktable.day_sales * TrdBackUp.Tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((broktable.day_sales/ 100) * ( TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((broktable.sett_purch * TrdBackUp.Tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round((( broktable.sett_purch/100) * ( TrdBackUp.marketrate  * TrdBackUp.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (broktable.sett_sales * TrdBackUp.Tradeqty * Globals.service_tax) /100,broktable.round_to)

                        when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((broktable.sett_sales/100) * ( TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax)  /100),broktable.round_to)

   Else  0 
                        End 
                         ),
      Trade_amount = TrdBackUp.Tradeqty * TrdBackUp.MarketRate,
      NBrokApp =(  case  
                       	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             	Then broktable.Normal
                       	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             	Then broktable.Normal    

                       	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             	Then round((broktable.Normal /100 ) * TrdBackUp.marketrate,broktable.round_to)
 	         	 when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to)         

               		 when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then ((broktable.day_puc))
         	         when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round((broktable.day_puc/100) * TrdBackUp.marketrate,broktable.round_to) 

                 	 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then broktable.day_sales
                	 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round((broktable.day_sales/ 100) * TrdBackUp.marketrate ,broktable.round_to)

             		 when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then broktable.sett_purch 
                         when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round((broktable.sett_purch/100) * TrdBackUp.marketrate ,broktable.round_to)

          		 when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="V" )
                             Then broktable.sett_sales 
                         when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="P" )
                             Then round((broktable.sett_sales/100) * TrdBackUp.marketrate ,broktable.round_to)
   Else  0 
                        End 
                         ),
        NSertax = (case  
                        when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((broktable.Normal * TrdBackUp.Tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        when (TrdBackUp.SettFlag = 1 and broktable.val_perc ="P")
                             Then round(((broktable.Normal /100 ) * (TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (broktable.day_puc * TrdBackUp.Tradeqty * globals.service_tax) /100,broktable.round_to )

                        when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((broktable.day_puc/100) * ( TrdBackUp.marketrate * TrdBackUp.Tradeqty * Globals.service_tax) / 100),broktable.round_to)

                        when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((broktable.day_sales * TrdBackUp.Tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((broktable.day_sales/ 100) * ( TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((broktable.sett_purch * TrdBackUp.Tradeqty * Globals.service_tax) / 100,broktable.round_to)

                        when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round((( broktable.sett_purch/100) * ( TrdBackUp.marketrate  * TrdBackUp.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)

                        when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (broktable.sett_sales * TrdBackUp.Tradeqty * Globals.service_tax) /100,broktable.round_to)

                        when ( TrdBackUp.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((broktable.sett_sales/100) * ( TrdBackUp.marketrate * TrdBackUp.Tradeqty * globals.service_tax)  /100),broktable.round_to)

   Else  0 
                        End 
                         ),
N_NetRate =(  case  
                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                             Then round(( TrdBackUp.marketrate + broktable.Normal),broktable.round_to)
                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                             Then round((TrdBackUp.marketrate - broktable.Normal ),broktable.round_to )   

                         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                             Then (TrdBackUp.marketrate + round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to))
		         when ( TrdBackUp.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then (TrdBackUp.marketrate - round((broktable.Normal /100 )* TrdBackUp.marketrate,broktable.round_to))           

		         when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round((broktable.day_puc + TrdBackUp.marketrate ),broktable.round_to)
			 when (TrdBackUp.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then (TrdBackUp.marketrate + round((broktable.day_puc/100) * TrdBackUp.marketrate ,broktable.round_to))

		         when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((TrdBackUp.marketrate - broktable.day_sales),broktable.round_to)
			 when (TrdBackUp.SettFlag = 3  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate - round((broktable.day_sales/ 100) * TrdBackUp.marketrate ,broktable.round_to))

			 when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((broktable.sett_purch + TrdBackUp.marketrate ),broktable.round_to )
                         when ( TrdBackUp.SettFlag = 4  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate + round(( broktable.sett_purch/100) * TrdBackUp.marketrate ,broktable.round_to))

			 when ( TrdBackUp.SettFlag =5  and broktable.val_perc ="V" )
                             Then round(( TrdBackUp.marketrate - broktable.sett_sales ),broktable.round_to)
                         when ( TrdBackUp.SettFlag =5  and broktable.val_perc ="P" )
                             Then (TrdBackUp.marketrate - round((broktable.sett_sales/100) * TrdBackUp.marketrate ,broktable.round_to))

   Else  0 
                        End 
                         )                                                                     
      FROM BrokTable,TrdBackUp,taxes,globals,scrip1,scrip2,Sett_mst,Owner O,SubBrokerConCursorSalePur C, MultiBroker M
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
			                      			 Else ( case when trdbackup.TMark = 'D' then 
						 	                     IsNull(M.Sub_TableNo,O.Sub_TableNo)          
			  				            else
								IsNull(M.Table_No,O.Table_No)   
				                		           end )
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
                                                					IsNull(M.Table_No,O.Table_No)
                                            					End)								
				                       and TrdBackUp.Sell_Buy = 1 
                                                       and TrdBackUp.PartiPantCode = M.CltCode	
						       and TrdBackUp.User_Id = M.User_Id  	
                                               	       and TrdBackUp.marketrate <= Broktable.upper_lim),
						 (Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = (case when ( TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3')
                    				 				then IsNull(M.P_To_P,O.P_To_P)
                                            					Else
                                                					IsNull(M.Table_No,O.Table_No)
                                            					End)									
					      	 and TrdBackUp.Sell_Buy = 2 and broktable.Val_perc = 'V'
	 		                         and TrdBackUp.PartiPantCode = M.CltCode	
						 and TrdBackUp.User_Id = M.User_Id))
						else ( case when c.Sqty > c.Pqty  then	
							 Isnull((Select min(Broktable.line_no) from broktable where
				                         Broktable.table_no = (case when ( TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3')
                    					 				then IsNull(M.P_To_P,O.P_To_P)
                                	            					Else
                                        	        					IsNull(M.Table_No,O.Table_No)
                                            						End)										
						      	 and TrdBackUp.Sell_Buy = 2
		 		                         and TrdBackUp.PartiPantCode = M.CltCode	
							 and TrdBackUp.User_Id = M.User_Id   	
		        	                	 and TrdBackUp.marketrate <= Broktable.upper_lim),
							 (Select min(Broktable.line_no) from broktable where
			                	         Broktable.table_no = (case when ( TrdBackUp.series = 'EQ'  and TrdBackUp.markettype = '3')
                    					 				then IsNull(M.P_To_P,O.P_To_P)
                                            						Else
                                                						IsNull(M.Table_No,O.Table_No)
                                            						End)									
						      	 and TrdBackUp.Sell_Buy = 1 and broktable.Val_perc = 'V'
		 		                         and TrdBackUp.PartiPantCode = M.CltCode	
							 and TrdBackUp.User_Id = M.User_Id))
							end )
						end)
					else (Select min(Broktable.line_no) from broktable where
			                	         Broktable.table_no = 
								( case when ( trdbackup.series = 'EQ'  and trdbackup.markettype = '3')
										then IsNull(M.P_To_P,O.P_To_P)
                			      			 Else ( case when trdbackup.TMark = 'D' then 
							 	                     IsNull(M.Sub_TableNo,O.Sub_TableNo)          
   						        	        else
										IsNull(M.Table_No,O.Table_No)   
					                	        end )
								 end  ) 	
						and TrdBackUp.PartiPantCode = M.CltCode	
						and TrdBackUp.User_Id = M.User_Id     
						and (TrdBackUp.marketrate <= Broktable.upper_lim) )						
				 		end )  					                   			
	  		                end ) 
            And
             taxes.exchange = 'NSE'
             and taxes.trans_cat = 'TRD'  
  and trdbackup.SETT_NO = @SETT_NO AND TRDBACKUP.SETT_TYPE = @SETT_TYPE

GO
