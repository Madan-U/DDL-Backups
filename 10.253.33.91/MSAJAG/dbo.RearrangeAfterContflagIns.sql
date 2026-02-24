-- Object: PROCEDURE dbo.RearrangeAfterContflagIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeAfterContflagIns    Script Date: 12/16/2003 2:31:22 PM ******/



/****** Object:  Stored Procedure dbo.RearrangeAfterContflagIns    Script Date: 05/08/2002 12:35:05 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterContflagIns    Script Date: 01/14/2002 20:32:46 ******/


/*created by bhagyashree on 2-11-2001*/
CREATE  PROCEDURE RearrangeAfterContflagIns (@Sett_Type varchar(2),@Party Varchar(10),@Scrip varchar(12),@Series varchar(2),@TDate Varchar(10),@Memcode varchar(15),@Tmark varchar(1)) AS 
declare 
 @@trade_no varchar(14),
 @@Pqty numeric(9), 
 @@Sqty numeric(9),
 @@Ltrade_no varchar(14),
 @@Lqty numeric(9), 
 @@Pdiff numeric(9),
 @@Flag cursor,
 @@loop cursor

	
	
	Update isettlement set settflag = (case when s.sell_buy = 1 then 2
						else 3 end )
	 from isettlement s,CursorContSaleIns b 
	where b.sett_type = s.sett_type 
	and b.party_code = s.party_code	
 	and b.scrip_cd = s.scrip_Cd           
	and b.series = s.series          
	and convert(varchar,b.sauda_date,3) = convert(varchar,s.sauda_date,3)
                AND  b.sqty<> 0 and b.pqty <>  0 
                /*and s.tmark = b.tmark*/
	and s.partipantcode = b.partipantcode 
	and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series  and convert(varchar,s.sauda_date,3) = @Tdate   
	and s.Sett_Type = @Sett_type
	and s.partipantcode like @Memcode
	/*and s.tmark = @Tmark  */
	
	
	Update isettlement set settflag = 4 from isettlement s,CursorContSaleIns b 
	where b.sett_type = s.sett_type 
	and b.party_code = s.party_code	
 	and b.scrip_cd = s.scrip_Cd           
	and b.series = s.series          
	and convert(varchar,b.sauda_date,3) = convert(varchar,s.sauda_date,3)
                AND  b.sqty = 0 and b.pqty >  0 
                AND s.SELL_BUY = 1
               /* and s.tmark = b.tmark*/
	and s.partipantcode = b.partipantcode 
	and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series  and convert(varchar,s.sauda_date,3) = @Tdate   
	and s.Sett_Type = @Sett_type
	and s.partipantcode like @Memcode
	/*and s.tmark = @Tmark */
	
	Update isettlement set settflag = 5 from isettlement s,CursorContSaleIns b 
	where b.sett_type = s.sett_type 
	and b.party_code = s.party_code	
 	and b.scrip_cd = s.scrip_Cd           
	and b.series = s.series          
	and convert(varchar,b.sauda_date,3) = convert(varchar,s.sauda_date,3)
                AND  b.sqty > 0 and b.pqty =  0 
                AND s.SELL_BUY = 2
               /* and s.tmark = b.tmark*/
	and s.partipantcode = b.partipantcode 
	and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series  and convert(varchar,s.sauda_date,3) = @Tdate   
	and s.Sett_Type = @Sett_type
	and s.partipantcode like @Memcode
	/*and s.tmark = @Tmark */

	/*  apply sett_flag =4 if sell_ buy = 'B' else 5  to all trades where TMark  = 'D' */
	Update isettlement set settflag = 1 
	where  party_code = @Party and scrip_cd = @scrip and series = @series    
	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
	and Partipantcode like @Memcode and TMark = 'D'
	And  tradeqty > 0 

	/*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */
	Update isettlement set settflag = 1  FROM isettlement t , CLIENT2 
	where  CLIENT2.PARTY_CODE = t.PARTY_CODE 
	and CLIENT2.tran_cat = 'DEL'  and
	t. party_code = @Party and t.scrip_cd = @scrip and t.series = @series    
	and convert(varchar,t.sauda_date,3) = @Tdate and t.Sett_Type = @Sett_type  
	and t.Partipantcode like @Memcode /*and t.Tmark = @Tmark*/
	And  t.tradeqty > 0 	

set @@Flag = cursor for
	 select pqty,sqty from CursorContUnEqualSalePurIns
	 where convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type
	 and Party_code = @Party and Scrip_Cd = @Scrip
	 and Series = @Series and Partipantcode like @Memcode /*and Tmark = @Tmark*/
	 and pqty <> 0 AND  sqty <> 0 and isnull(pqty,0) <> isnull(sqty,0)
	 group by pqty,sqty

open @@flag
fetch next from @@Flag into @@Pqty,@@sqty
if @@fetch_status = 0 	
	begin
		While @@fetch_status = 0 
		begin
			 if @@Sqty = 0
			 update isettlement set Settflag = 4 
			 where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
			 and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type    
			 and Partipantcode like @Memcode /*and Tmark = @Tmark*/

			 else if @@Pqty = 0
			 update isettlement set Settflag = 5 
			 where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2
			 and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type    
			 and Partipantcode like @Memcode /*and Tmark = @Tmark*/

			 else if @@Pqty = @@Sqty 
			 update isettlement set Settflag = (Case When Sell_Buy = 1 then 2 else 3 end ) 
			 where party_code = @Party and scrip_cd = @scrip and series = @series 
			 and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type    
			 and Partipantcode like @Memcode /*and Tmark = @Tmark*/

			  else if @@Pqty > @@Sqty 
		                  begin 
				  select @@pdiff = @@Pqty - @@Sqty 
				  set @@Loop  = cursor for 
					   select trade_no,tradeqty from isettlement 
					   where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
					   and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
					   and Partipantcode like @Memcode /*and Tmark = @Tmark*/
				  open @@loop
				  fetch next from @@Loop into @@Ltrade_no,@@Lqty     
				  if @@fetch_status = 0 
				  begin 
					   update isettlement set settflag = 4   
					   where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
					   and trade_no = @@ltrade_no and tradeqty = @@lqty  
					   and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
					   and Partipantcode like @Memcode /*and Tmark = @Tmark*/
				   close @@Loop
				   deallocate @@Loop 
			  	   end
			  	   else if @@fetch_status <> 0  
			 	   begin 
				   	close @@Loop
				   	deallocate @@Loop  
				
				   	set @@Loop  = cursor for 
						select trade_no,tradeqty from isettlement 
					   	where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
					   	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type 
					                and Partipantcode like @Memcode /*and Tmark = @Tmark*/
--						 order by marketrate asc, Tradeqty Desc ,tmark desc
						/*order by marketrate Desc*/
					        Order by Sauda_date
				   	open @@loop
				  	fetch next from @@Loop into @@Ltrade_no,@@Lqty     
				  	while @@pdiff > 0       
				  	begin
						if @@pdiff >= @@Lqty 	
	                                                                	begin
					     		update isettlement set settflag = 4   
							where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
					     		and trade_no = @@ltrade_no and tradeqty = @@lqty  
							and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
							and Partipantcode like @Memcode /*and Tmark = @Tmark*/

					     		select @@pdiff = @@Pdiff - @@Lqty
						 end    
					                else if @@pdiff < @@Lqty 
			    			begin
							insert into isettlement select ContractNo,BillNo,'B'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,4,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
				    			from isettlement where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
				     			and trade_no = @@ltrade_no and tradeqty = @@lqty  
				     			and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type
							and Partipantcode like @Memcode /*and Tmark = @Tmark*/
 
				     		               update isettlement set settflag = 2,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
				    		               where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
				     		               and trade_no = @@ltrade_no and tradeqty = @@lqty
				   		               and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
						               and Partipantcode like @Memcode /*and Tmark = @Tmark*/

				     		               select @@Pdiff = 0   
						end 
			    			fetch next from @@Loop into @@Ltrade_no,@@Lqty
			   		end
		   			close @@Loop
  				 end   			end
			else if @@Pqty < @@Sqty
			begin 
 				 select @@pdiff = @@sqty - @@pqty

 				set @@Loop  = cursor for 
 				 select trade_no,tradeqty from isettlement 
 				 where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
  				 and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
				 and Partipantcode like  @Memcode /*and Tmark = @Tmark*/

 				 open @@loop
			  	 fetch next from @@Loop into @@Ltrade_no,@@Lqty     
			 	 if @@fetch_status = 0 
				 begin
 				 	update isettlement set settflag = 5  
  				  	where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
 				  	and trade_no = @@ltrade_no and tradeqty = @@lqty  
				  	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
					and Partipantcode like @Memcode /*and Tmark = @Tmark*/

			 		close @@Loop
				 	deallocate @@Loop 
			  	end
				else if @@fetch_status <> 0  
			 	begin 
					close @@Loop
				   	deallocate @@Loop  
					
				   	set @@Loop  = cursor for 
				    	select trade_no,tradeqty from isettlement 
				    	where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
				    	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type 
					and Partipantcode like @Memcode /*and Tmark = @Tmark*/
--					 order by marketrate asc, Tradeqty Desc  ,tmark desc
					/*order by marketrate Desc*/
				        Order by Sauda_date

				   	open @@loop
				  	 fetch next from @@Loop into @@Ltrade_no,@@Lqty     
				  	 while @@pdiff > 0       
				   	begin
						if @@pdiff >= @@Lqty 
						begin
							update isettlement set settflag = 5   
						    	where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
						    	and trade_no = @@ltrade_no and tradeqty = @@lqty  
						   	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
							and Partipantcode like @Memcode /*and Tmark = @Tmark*/

						     	select @@pdiff = @@Pdiff - @@Lqty
					   	 end    
					    	else if @@pdiff < @@Lqty 
					    	begin	
							insert into isettlement select ContractNo,BillNo,'B'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,5,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
						     	from isettlement where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
						     	and trade_no = @@ltrade_no and tradeqty = @@lqty  
						     	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
							and Partipantcode like @Memcode /*and Tmark = @Tmark*/
		     
						     	update isettlement set settflag = 3,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff) * MarketRate     
						    	where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
						     	and trade_no = @@ltrade_no and tradeqty = @@lqty
						     	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type   
							and Partipantcode like @Memcode /*and Tmark = @Tmark*/

     						    	select @@Pdiff = 0   
					   	 end 
					    	fetch next from @@Loop into @@Ltrade_no,@@Lqty
				   	end
 				  	close @@Loop
				  end	
			end
			 fetch next from @@Flag into @@Pqty,@@sqty
		end 
		close @@Flag
		deallocate @@Flag
	end
/*ADDED BY BHAGYASHREE ON 17-9-2001 FOR UPDATING SETTFLAG=1 FOR TMARK='D'*/
	Update isettlement set settflag = 1 
	where  party_code = @Party and scrip_cd = @scrip and series = @series    
	and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
	and Partipantcode like @Memcode and TMark = 'D'
	And  tradeqty > 0 

exec InsSettBrokUpdate @Party,@TDate ,@scrip,@Series

GO
