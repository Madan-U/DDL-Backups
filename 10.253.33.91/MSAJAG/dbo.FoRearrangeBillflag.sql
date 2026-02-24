-- Object: PROCEDURE dbo.FoRearrangeBillflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoRearrangeBillflag    Script Date: 5/26/01 4:17:01 PM ******/

CREATE PROCEDURE FoRearrangeBillflag (@ExpiryDate smalldatetime) AS 
declare 
 	@@trade_no varchar(15),
 	@@Party varchar(10),
        	@@Inst_Type varchar(6),  
        	@@Symbol varchar(11),
        	@@Pqty numeric(9), 
        	@@Sqty numeric(9),
        	@@Ltrade_no varchar(15),
        	@@Lqty numeric(9), 
 	@@Pdiff numeric(9),
	@@Flag cursor,
 	@@loop cursor
	 update FOSETTLEMENT set billflag = ( Case when sell_buy = 1 then 2 else 3 end ) where expirydate = @expirydate
	drop table FOtempbillflag
	select * into FOtempbillflag  from FOBILLTOTQT where expirydate = @expirydate

                update FOSETTLEMENT set billflag = 2 from FOtempbillflag b 
                where b.party_code = FOSETTLEMENT.party_code and 
                b.Inst_Type = FOSETTLEMENT.Inst_Type
                and b.symbol = FOSETTLEMENT.symbol          
                and  b.sqty <> 0 and b.pqty <> 0
                and  FOSETTLEMENT.sell_buy = 1
		and FOSETTLEMENT.expirydate = b.expirydate
              	and FOSETTLEMENT.expirydate = @expirydate

                update FOSETTLEMENT set billflag = 3 from FOtempbillflag b 
                where b.party_code = FOSETTLEMENT.party_code and 
                b.Inst_Type = FOSETTLEMENT.Inst_Type
                and b.symbol = FOSETTLEMENT.symbol          
                and  b.sqty <> 0 and b.pqty <> 0
                and  FOSETTLEMENT.sell_buy = 2
		and FOSETTLEMENT.expirydate = b.expirydate
              	and FOSETTLEMENT.expirydate = @expirydate

                update FOSETTLEMENT set billflag = 4 from FOtempbillflag b 
                where b.party_code = FOSETTLEMENT.party_code and 
                b.Inst_Type = FOSETTLEMENT.Inst_Type
                and b.symbol = FOSETTLEMENT.symbol          
                and b.Pqty > 0 and b.sqty = 0
                and FOSETTLEMENT.sell_buy = 1 
		and FOSETTLEMENT.expirydate = b.expirydate
                and FOSETTLEMENT.expirydate = @expirydate

                update FOSETTLEMENT set billflag = 5 from FOtempbillflag b 
                where b.party_code = FOSETTLEMENT.party_code and 
                b.Inst_Type = FOSETTLEMENT.Inst_Type
                and b.symbol = FOSETTLEMENT.symbol          
                and b.sqty > 0 and b.pqty = 0
                and FOSETTLEMENT.sell_buy = 2 
		and FOSETTLEMENT.expirydate = b.expirydate
              	and FOSETTLEMENT.expirydate = @expirydate
	
	set @@Flag = cursor for
 	select Party_Code,Inst_Type,Symbol,pqty,sqty,EXPIRYDATE from FOBILLTOTQT
	where  pqty <> 0 AND  sqty <> 0 and expirydate = @expirydate
 	and isnull(pqty,0) <> isnull(sqty,0)
	
	open @@flag
	fetch next from @@Flag into @@party,@@Inst_Type,@@Symbol,@@Pqty,@@sqty,@expirydate
	While @@fetch_status = 0 
	begin
        		if @@Pqty > @@Sqty 
        		begin 
  			select @@pdiff = @@Pqty - @@Sqty 
  			
			set @@Loop  = cursor for 
   			select trade_no,tradeqty from FOSETTLEMENT 
   			where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 1 
   			and expirydate = @expirydate and tradeqty = @@Pdiff  
  			open @@loop
  			fetch next from @@Loop into @@Ltrade_no,@@Lqty     

			if @@fetch_status = 0 
  			begin
   				update FOSETTLEMENT set Billflag = 4   
   				where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 1 
   				and trade_no = @@ltrade_no and tradeqty = @@lqty     and expirydate = @expirydate	
   				and expirydate = @expirydate   
   				close @@Loop
   				deallocate @@Loop 
  			end
  			else if @@fetch_status <> 0  
  			begin 
   				close @@Loop   				deallocate @@Loop  
   				set @@Loop  = cursor for 
    				select trade_no,tradeqty from FOSETTLEMENT 
    				where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 1    and expirydate = @expirydate	
    				and expirydate = @expirydate 
				order by Price asc, Tradeqty Desc  
   				open @@loop
   				fetch next from @@Loop into @@Ltrade_no,@@Lqty     

   				while @@pdiff > 0       
	   			begin
    					if @@pdiff >= @@Lqty 
    					begin
     						update FOSETTLEMENT set Billflag = 4   
     						where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and expirydate = @expirydate	
     						and expirydate = @expirydate   	
     						select @@pdiff = @@Pdiff - @@Lqty
    					end    
    					else if @@pdiff < @@Lqty 
					begin	
     						insert into FOSETTLEMENT select ContractNo,BillNo,'B'+Trade_no,Party_Code,Inst_type,Symbol,Sec_name,Expirydate,Strike_price,Option_type,User_id,Pro_cli,O_C_Flag,C_U_Flag,@@PDiff,AuctionPart,MarketType,Series,Order_no,Price,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*Price,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Cl_Rate
     						from FOSETTLEMENT where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and expirydate = @expirydate	
     						and expirydate = @expirydate   	
 
     						update FOSETTLEMENT set BillFlag = 2,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*Price    
     						where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty    and expirydate = @expirydate	
     						and expirydate = @expirydate   	
     						select @@Pdiff = 0   
    					end 
    					fetch next from @@Loop into @@Ltrade_no,@@Lqty
  
   				end
   				close @@Loop
  			end    
 		end
 		else if @@Pqty < @@Sqty
 		begin 
  			select @@pdiff = @@sqty - @@pqty
  			set @@Loop  = cursor for 
   			select trade_no,tradeqty from FOSETTLEMENT 
   			where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 2 
   			and expirydate = @expirydate and tradeqty = @@Pdiff    
			and expirydate = @expirydate  		
  			
			open @@loop
  			fetch next from @@Loop into @@Ltrade_no,@@Lqty     
  			if @@fetch_status = 0 
  			begin
   				update FOSETTLEMENT set Billflag = 5  
   				where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 2 
   				and trade_no = @@ltrade_no and tradeqty = @@lqty     and expirydate = @expirydate	
   				and expirydate = @expirydate   	
   				close @@Loop
   				deallocate @@Loop 
  			end
  			else if @@fetch_status <> 0  
  			begin 
   				close @@Loop
   				deallocate @@Loop  
   				set @@Loop  = cursor for 
    				select trade_no,tradeqty from FOSETTLEMENT 
    				where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 2 
    				and expirydate = @expirydate    and expirydate = @expirydate	 	
				order by Price asc, Tradeqty Desc  
   				
				open @@loop
   				fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   				while @@pdiff > 0       
   				begin
    					if @@pdiff >= @@Lqty 
    					begin
     						update FOSETTLEMENT set Billflag = 5   
     						where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and expirydate = @expirydate	
     						and expirydate = @expirydate   	
     						select @@pdiff = @@Pdiff - @@Lqty
    					end    
    					else if @@pdiff < @@Lqty 
    					begin	
						/*Added two more fiels on 05/01/2001*/
     						insert into FOSETTLEMENT select ContractNo,BillNo,'B'+Trade_no,Party_Code,Inst_type,Symbol,Sec_name,Expirydate,Strike_price,Option_type,User_id,Pro_cli,O_C_Flag,C_U_Flag,@@PDiff,AuctionPart,MarketType,Series,Order_no,Price,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*Price,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Cl_Rate																																																								 
     						from FOSETTLEMENT where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and expirydate = @expirydate	
     						and expirydate = @expirydate   	
     
     						update FOSETTLEMENT set billflag = 3,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff) * Price     
     						where party_code = @@Party and Inst_Type = @@Inst_Type and symbol = @@Symbol and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty   and expirydate =@expirydate	
     						and expirydate = @expirydate    	
     						
						select @@Pdiff = 0   
    					end 
    					fetch next from @@Loop into @@Ltrade_no,@@Lqty
 
   				end
   				close @@Loop
  			end
 		end 
 		fetch next from @@Flag into @@party,@@Inst_Type,@@Symbol,@@Pqty,@@sqty,@expirydate

	end 
	close @@Flag
	deallocate @@Flag
	
	UPDATE FOSETTLEMENT SET service_tax =isnull( ((brokapplied*tradeqty*(select service_tax from Foglobals where year_start_dt < getdate() )) /100),0),
	Nsertax = isnull(((brokapplied*tradeqty*(select service_tax from Foglobals where year_start_dt < getdate() )) /100),0), 
	Amount = (tradeqty * netrate) 
	where expirydate = @expirydate    

	exec FoUpdBillTax @expirydate

GO
