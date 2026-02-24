-- Object: PROCEDURE dbo.BillBrokReCalUp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillBrokReCalUp    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillBrokReCalUp    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillBrokReCalUp    Script Date: 20-Mar-01 11:38:43 PM ******/

/*Recent changes done by  vaishali on 03/03/2001  added condn. for status*/
CREATE proc BillBrokReCalUp (@Sett_no Varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10),@Scrip_Cd Varchar(12),@series Varchar(2),@MarketRate Numeric(18,9),@Flag Int) as
if @Flag = 1 
Begin
update settlement set
     NBrokApp = (  case  
                       when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                       Then broktable.normal 

                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                        Then  round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to)


                       when ( settlement.billflag = 5  and broktable.val_perc ="V" )
                       Then broktable.normal 

                       when ( settlement.billflag = 5  and broktable.val_perc ="P" )
                       Then round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to)
                  Else  
                       BrokApplied 
                  End 
                  ),
     N_NetRate = (  case  
                        when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                        Then ((broktable.normal + settlement.marketrate ) )
                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                        Then ((settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)))
                        
                        when ( settlement.billflag =5  and broktable.val_perc ="V" )
                        Then (( settlement.marketrate - broktable.normal ))
                        
                        when ( settlement.billflag =5  and broktable.val_perc ="P" )
                        Then ((settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)))
                    Else  
                        NetRate 
                    End 
                 ),
    NSertax =   (   case  
                        when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                        Then round((broktable.Normal * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                        Then round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( settlement.billflag = 5  and broktable.val_perc ="V" )
                        Then round((broktable.Normal * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.billflag = 5  and broktable.val_perc ="P" )
                        Then  round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                    Else  
                        settlement.Service_tax
                    End 
                ),
        Ins_chrg  = round(((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to), 

        turn_tax  = round(((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to),              

        other_chrg = round(((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ),broktable.round_to), 

        sebi_tax = round(((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to),              

        Broker_chrg = round(((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100),broktable.round_to)
                                                  
      FROM BrokTable,Client2,settlement,taxes,globals,scrip1,scrip2,Sett_mst,client1, BrokCursorBillSalePur C
      WHERE 
            settlement.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
	sett_mst.sett_no = settlement.sett_no     
         and 
	sett_mst.sett_type = settlement.sett_type
           And 
              (settlement.Series = scrip2.series)
           And
             (scrip2.scrip_cd = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And             (scrip2.series = scrip1.series) 
           AND 
             Broktable.Table_no = ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
		                         client2.Sub_TableNo        
				else ( case when client2.brok_scheme = 1 then
					   ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
				else ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
					 then client2.P_To_P
					 else ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
		                         			then 
                		           	  				 client2.demat_tableno 
		                        			 Else ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
							 	                     client2.Sub_TableNo          
				  					     else
										     client2.Sub_TableNo
								                   end )
						end )
					 end  ) 
					
		 		end ) 
			END )
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
					(Select min(Broktable.line_no) from broktable where
		                         Broktable.table_no = client2.Sub_TableNo
					 and settlement.Party_Code =  Client2.Party_code   	
		                         and settlement.marketrate <= Broktable.upper_lim )         
				else ( case when client2.brok_scheme = 1 then					
					( case when c.Pqty >= c.Sqty then
						 Isnull((Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 1 
	 		                         and settlement.Party_Code =  Client2.Party_code   	
		                        	 and settlement.marketrate <= Broktable.upper_lim),
						 (Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 2 and broktable.Val_perc = 'V'
	 		                         and settlement.Party_Code =  Client2.Party_code))
					else ( case when c.Sqty > c.Pqty  then	
						 Isnull((Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 2
	 		                         and settlement.Party_Code =  Client2.Party_code   	
		                        	 and settlement.marketrate <= Broktable.upper_lim),
						 (Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 1 and broktable.Val_perc = 'V'
	 		                         and settlement.Party_Code =  Client2.Party_code))
						end )
					end)
				else 
				( case when ( settlement.series = 'EQ'  and settlement.markettype = '3') then
						(Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = client2.p_to_p and settlement.marketrate <= Broktable.upper_lim  and settlement.Party_Code =  Client2.Party_code) 
					 else
				                 (Select min(Broktable.line_no) from broktable where
				                 ( Broktable.table_no = ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout) then 
							                          client2.demat_tableno
								 Else ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 				 	                           	client2.Sub_TableNo          
								 else
									Sub_TableNo
							         end )
							end ) 
				                   and settlement.Party_Code =  Client2.Party_code    )     
			                           and (settlement.marketrate <= Broktable.upper_lim) )
					 end )
				end )
              end ) 
               

               
               
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')
/*           And
             (taxes.Sett_type = 'N')    
         And
              (taxes.Sett_type =  */
              
  And (billflag = 4 or billflag = 5)
  and settlement.sett_no = C.Sett_No
  and settlement.sett_type = C.Sett_Type
  and settlement.party_code = C.Party_Code
  and settlement.scrip_cd   =  C.Scrip_Cd
  and settlement.tradeqty = C.TradeQty
  and settlement.series = C.Series		
  and settlement.tradeqty > 0
  and settlement.Sett_no = @Sett_No 
  and settlement.sett_Type = @Sett_Type 
  and settlement.Party_code Like @Party_Code
  and settlement.scrip_cd like @Scrip_Cd
  and settlement.series Like @Series
  and settlement.sett_type not in ('L','P')
  and settlement.status <> 'E'   /*Added by vaishali on 03/03/2001*/
end 
else
Begin
update settlement set
       NBrokApp = (  case  
                       when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                       Then broktable.normal 

                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                        Then  round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to)


                       when ( settlement.billflag = 5  and broktable.val_perc ="V" )
                       Then broktable.normal 

                       when ( settlement.billflag = 5  and broktable.val_perc ="P" )
                       Then round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to)
                  Else  
                       BrokApplied 
                  End 
                  ),

       N_NetRate = (  case  
                        when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                        Then ((broktable.normal + settlement.marketrate ) )
                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                        Then ((settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)))
                        
                        when ( settlement.billflag =5  and broktable.val_perc ="V" )
                        Then (( settlement.marketrate - broktable.normal ))
                        
                        when ( settlement.billflag =5  and broktable.val_perc ="P" )
                        Then ((settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)))
                    Else  
                        NetRate 
                    End 
                 ),
        NSertax = (   case  
                        when ( settlement.billflag = 4  and broktable.val_perc ="V" )
                        Then round((broktable.Normal * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.billflag = 4  and broktable.val_perc ="P" )
                        Then round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)

                        when ( settlement.billflag = 5  and broktable.val_perc ="V" )
                        Then round((broktable.Normal * settlement.Tradeqty * Globals.service_tax) / 100,Broktable.Round_to)

                        when ( settlement.billflag = 5  and broktable.val_perc ="P" )
                        Then  round(((broktable.Normal /100 ) * (settlement.marketrate * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                    Else  
                        settlement.Service_tax
                    End 
                )


                                
      FROM BrokTable,Client2,settlement,taxes,globals,scrip1,scrip2,Sett_mst,client1, BrokCursorBillSalePur C
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
             Broktable.Table_no = ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
		                         client2.Sub_TableNo        
				else ( case when client2.brok_scheme = 1 then
					   ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
				else ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
					 then client2.P_To_P
					 else ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
		                         			then 
                		           	  				 client2.demat_tableno 
		                        			 Else ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
							 	                     client2.Sub_TableNo          
				  					     else
										     client2.Sub_TableNo
								                   end )
						end )
					 end  ) 
					
		 		end ) 
			END )
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
					(Select min(Broktable.line_no) from broktable where
		                         Broktable.table_no = client2.Sub_TableNo
					 and settlement.Party_Code =  Client2.Party_code   	
		                         and settlement.marketrate <= Broktable.upper_lim )         
				else ( case when client2.brok_scheme = 1 then					
					( case when c.Pqty >= c.Sqty then
						 Isnull((Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 1 
	 		                         and settlement.Party_Code =  Client2.Party_code   	
		                        	 and settlement.marketrate <= Broktable.upper_lim),
						 (Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 2 and broktable.Val_perc = 'V'
	 		                         and settlement.Party_Code =  Client2.Party_code))
					else ( case when c.Sqty > c.Pqty  then	
						 Isnull((Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 2
	 		                         and settlement.Party_Code =  Client2.Party_code   	
		                        	 and settlement.marketrate <= Broktable.upper_lim),
						 (Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = ( case when ( settlement.series = 'EQ'  and settlement.markettype = '3')
						 then client2.P_To_P else Client2.Sub_TableNo end )
					      	 and settlement.Sell_Buy = 1 and broktable.Val_perc = 'V'
	 		                         and settlement.Party_Code =  Client2.Party_code))
						end )
					end)
				else 
				( case when ( settlement.series = 'EQ'  and settlement.markettype = '3') then
						(Select min(Broktable.line_no) from broktable where
			                         Broktable.table_no = client2.p_to_p and settlement.marketrate <= Broktable.upper_lim  and settlement.Party_Code =  Client2.Party_code) 
					 else
				                 (Select min(Broktable.line_no) from broktable where
				                 ( Broktable.table_no = ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout) then 
							                          client2.demat_tableno
								 Else ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 				 	                           	client2.Sub_TableNo          
								 else
									Sub_TableNo
							         end )
							end ) 
				                   and settlement.Party_Code =  Client2.Party_code    )     
			                           and (settlement.marketrate <= Broktable.upper_lim) )
					 end )
				end )
              end ) 
               

               
           And
             (Client2.Tran_cat = Taxes.Trans_cat)
           And
             (taxes.exchange = 'NSE')
/*           And
             (taxes.Sett_type = 'N')    
         And
              (taxes.Sett_type =  */
              
  And (billflag = 4 or billflag = 5)
  and settlement.sett_no = C.Sett_No
  and settlement.sett_type = C.Sett_Type
  and settlement.party_code = C.Party_Code
  and settlement.scrip_cd   =  C.Scrip_Cd
  and settlement.tradeqty = C.TradeQty
  and settlement.series = C.Series		
  and settlement.tradeqty > 0
  and settlement.Sett_no = @Sett_No 
  and settlement.sett_Type = @Sett_Type 
  and settlement.Party_code Like @Party_Code
  and settlement.scrip_cd like @Scrip_Cd
  and settlement.series Like @Series
  and settlement.marketrate = @Marketrate	
  and settlement.Sett_Type not in ('L','P')
  and settlement.TMark = c.Tmark
  and settlement.status <> 'E'   /*Added by vaishali on 03/03/2001*/
end 

Update Settlement Set Broker_Chrg = 0 Where Billflag in (2,3)

GO
