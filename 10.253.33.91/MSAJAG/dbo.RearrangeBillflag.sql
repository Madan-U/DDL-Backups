-- Object: PROCEDURE dbo.RearrangeBillflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeBillflag    Script Date: 12/16/2003 2:31:22 PM ******/

/*This procedure is used for the updating the billflag according to sell_buy,tmark and trns_cat*/
/* Thereafter  rearranging of all the billflags is done partywise and scripwise and also  */ 

CREATE  PROCEDURE RearrangeBillflag (@Sett_No varchar(7),@Sett_Type varchar(2)) AS 
declare 
 	@@trade_no varchar(14),
 	@@Party varchar(10),
        	@@Scrip varchar(12),  
        	@@series varchar(2),
        	@@Pqty numeric(9), 
        	@@Sqty numeric(9),
        	@@Ltrade_no varchar(14),
        	@@Lqty numeric(9), 
 	@@Pdiff numeric(9),
	@@PartiPantCode varchar(15),
	@@TMark varchar(1),
	@@TTRADE_NO VARCHAR(14),
	@@TFLAG INT,
	@@TRD CURSOR,
	@@Flag cursor,
 	@@loop cursor
	 update settlement set billflag = ( Case when sell_buy = 1 then 2 else 3 end ) where sett_no = @sett_no and sett_type = @sett_type
	drop table tempbillflag
	select * into tempbillflag  from CursorBillunequalsalePur where sett_no = @sett_no and sett_type = @sett_type

                update settlement set billflag = 2 from tempbillflag b 
                where b.party_code = settlement.party_code and 
                b.scrip_cd = settlement.scrip_Cd
                and b.series = settlement.series          
                and  b.sqty <> 0 and b.pqty <> 0
                and  Settlement.sell_buy = 1
	 and settlement.sett_no = b.sett_no
 	and settlement.sett_type = b.sett_type
	and settlement.PartiPantCode = b.PartiPantCode
                and settlement.TMark = b.TMark
	and settlement.sett_no = @sett_no 
	and settlement.Sett_Type = @Sett_type

                update settlement set billflag = 3 from tempbillflag b 
                where b.party_code = settlement.party_code and 
                b.scrip_cd = settlement.scrip_Cd
                and b.series = settlement.series          
                and  b.sqty <> 0 and b.pqty <> 0
                and  Settlement.sell_buy = 2
                and settlement.sett_no = b.sett_no
	 and settlement.sett_type = b.sett_type
	and settlement.PartiPantCode = b.PartiPantCode
                and settlement.TMark = b.TMark
                and settlement.sett_no = @sett_no 
	and settlement.Sett_Type = @Sett_type

                update settlement set billflag = 4 from tempbillflag b 
                where b.party_code = settlement.party_code and 
                b.scrip_cd = settlement.scrip_Cd
                and b.series = settlement.series          
                and b.Pqty > 0 and b.sqty = 0
                and Settlement.sell_buy = 1 
	 and settlement.sett_no = b.sett_no
	 and settlement.sett_type = b.sett_type
	and settlement.PartiPantCode = b.PartiPantCode
                and settlement.TMark = b.TMark
                and settlement.sett_no = @sett_no 
	and settlement.Sett_Type = @Sett_type

                update settlement set billflag = 5 from tempbillflag b 
                where b.party_code = settlement.party_code and 
                b.scrip_cd = settlement.scrip_Cd
                and b.series = settlement.series          
           and b.sqty > 0 and b.pqty = 0
                and Settlement.sell_buy = 2 
        	and settlement.sett_no = b.sett_no
       	and settlement.sett_type = b.sett_type
	and settlement.PartiPantCode = b.PartiPantCode
                and settlement.TMark = b.TMark
                and settlement.sett_no = @sett_no 
	and settlement.Sett_Type = @Sett_type
	
	/*  apply billflag =4 if sell_ buy = 'B' else 5  to all trades where TMark  = 'D' */
	Update settlement set billflag = 1 
	where TMark = 'D'
	And  tradeqty > 0 


	/*  apply billflag = 1 to all trades where client2. tran_cat   = 'DEL' */
	Update Settlement set billflag = 1  FROM settlement, CLIENT2 
	where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
	and CLIENT2.tran_cat = 'DEL' 
	And  tradeqty > 0 
	and sett_no = @sett_no and Sett_Type = @Sett_type

	set @@Flag = cursor for
 	select party_code,scrip_cd,series,pqty,sqty,PartiPantCode,tmark from tempbillflag
	where  pqty <> 0 AND  sqty <> 0 and sett_no = @sett_no and Sett_Type = @Sett_type
 	and isnull(pqty,0) <> isnull(sqty,0)
	
	open @@flag
	fetch next from @@Flag into @@party,@@scrip,@@series,@@Pqty,@@sqty,@@PartiPantCode,@@TMark
	While @@fetch_status = 0 
	begin
			if @@Pqty > @@Sqty AND @@fetch_status = 0 
        		begin 
  			select @@pdiff = @@Pqty - @@Sqty 
  			
		/*	set @@Loop  = cursor for 
   			select trade_no,tradeqty from settlement 
   			where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
   			and sett_no = @sett_no and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
   			and PartiPantCode = @@PartiPantCode and TMark = @@TMark	
  			open @@loop
  			fetch next from @@Loop into @@Ltrade_no,@@Lqty     
  			
			if @@fetch_status = 0 
  			begin
   				update settlement set Billflag = 4   
   				where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
   				and trade_no = @@ltrade_no and tradeqty = @@lqty     and PartiPantCode = @@PartiPantCode	
   				and sett_no = @sett_no and Sett_Type = @Sett_type   and TMark = @@TMark	
   				close @@Loop
   				deallocate @@Loop 
  			end
  			else if @@fetch_status <> 0  
  			begin 
   				close @@Loop
   				deallocate @@Loop  
			*/
   				set @@Loop  = cursor for 
    				select trade_no,tradeqty from settlement 
    				where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1    and PartiPantCode = @@PartiPantCode	
    				and sett_no = @sett_no and Sett_Type = @Sett_type and TMark = @@TMark and SettFlag = 4	
				/* order by marketrate asc, Tradeqty Desc  */
--				order by marketrate Desc
			        Order by Sauda_date
   				open @@loop
   				fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   				while @@pdiff > 0 AND @@fetch_status = 0        
	   			begin
    					if @@pdiff >= @@Lqty AND @@fetch_status = 0 
    					begin
     						update settlement set Billflag = 4   
     						where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and PartiPantCode = @@PartiPantCode	
     						and sett_no = @sett_no and Sett_Type = @Sett_type  and TMark = @@TMark	
     						select @@pdiff = @@Pdiff - @@Lqty
    					end    
    					else if @@pdiff < @@Lqty AND @@fetch_status = 0 
    					begin	
						SELECT @@TTRADE_NO = @@ltrade_no
						SELECT @@TFLAG = 1 
						WHILE @@TFLAG = 1 
						BEGIN
							SET @@TRD = CURSOR FOR
							SELECT TRADE_NO FROM SETTLEMENT WHERE TRADE_NO = 'B' + @@TTRADE_NO
							AND party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
							AND PartiPantCode = @@PartiPantCode and sett_no = @sett_no and Sett_Type = @Sett_type	
							OPEN @@TRD
							FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
							IF @@FETCH_STATUS = 0 
								SELECT @@TFLAG = 1
							ELSE
								SELECT @@TFLAG = 0
							CLOSE @@TRD
							DEALLOCATE @@TRD			
						END																																																													 /*Added two more fiels on 05/01/2001*/	
     						insert into settlement select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
     						from Settlement where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty  and PartiPantCode = @@PartiPantCode	
     						and sett_no = @sett_no and Sett_Type = @Sett_type  and TMark = @@TMark	
 
     						update settlement set BillFlag = 2,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
     						where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty    and PartiPantCode = @@PartiPantCode	
     						and sett_no = @sett_no and Sett_Type = @Sett_type  and TMark = @@TMark	
     						select @@Pdiff = 0   
    					end 
    					fetch next from @@Loop into @@Ltrade_no,@@Lqty
   				end
   				close @@Loop
  			end    
 		/*end*/
 		else if @@Pqty < @@Sqty AND @@fetch_status = 0 
 		begin 
  			select @@pdiff = @@sqty - @@pqty
  		/*	set @@Loop  = cursor for 
   			select trade_no,tradeqty from settlement 
   			where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
   			and sett_no = @sett_no and Sett_Type = @Sett_type and tradeqty = @@Pdiff    
			and PartiPantCode = @@PartiPantCode and TMark = @@TMark		
  			
			open @@loop
  			fetch next from @@Loop into @@Ltrade_no,@@Lqty     
  			if @@fetch_status = 0 
  			begin
   				update settlement set Billflag = 5  
   				where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
   				and trade_no = @@ltrade_no and tradeqty = @@lqty     and PartiPantCode = @@PartiPantCode	
   				and sett_no = @sett_no and Sett_Type = @Sett_type  and TMark = @@TMark	
   				close @@Loop
   				deallocate @@Loop 
  			end
  			else if @@fetch_status <> 0  
  			begin 
   				close @@Loop
   				deallocate @@Loop  
			*/
   				set @@Loop  = cursor for 
    				select trade_no,tradeqty from settlement 
    				where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
    				and sett_no = @sett_no and Sett_Type = @Sett_type    and PartiPantCode = @@PartiPantCode
				and TMark = @@TMark and SettFlag = 5		
				/* order by marketrate asc, Tradeqty Desc  */
--				order by marketrate Desc
			        Order by Sauda_date
   				
				open @@loop
   				fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   				while @@pdiff > 0 AND @@fetch_status = 0       
   				begin
    					if @@pdiff >= @@Lqty AND @@fetch_status = 0 
    					begin
     						update Settlement set Billflag = 5   
     						where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and PartiPantCode = @@PartiPantCode	
     						and sett_no = @sett_no and Sett_Type = @Sett_type  and TMark = @@TMark	
     						select @@pdiff = @@Pdiff - @@Lqty
    					end    
    					else if @@pdiff < @@Lqty AND @@fetch_status = 0 
    					begin	
						SELECT @@TTRADE_NO = @@ltrade_no
						SELECT @@TFLAG = 1 
						WHILE @@TFLAG = 1 
						BEGIN
							SET @@TRD = CURSOR FOR
							SELECT TRADE_NO FROM SETTLEMENT WHERE TRADE_NO = 'B' + @@TTRADE_NO
							AND party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
							AND PartiPantCode = @@PartiPantCode and sett_no = @sett_no and Sett_Type = @Sett_type
							OPEN @@TRD
							FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
							IF @@FETCH_STATUS = 0 
								SELECT @@TFLAG = 1
							ELSE
								SELECT @@TFLAG = 0
							CLOSE @@TRD
							DEALLOCATE @@TRD			
						END																																																														 /*Added two more fiels on 05/01/2001*/
     						insert into settlement select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
     						from Settlement where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty     and PartiPantCode = @@PartiPantCode	
     						and sett_no = @sett_no and Sett_Type = @Sett_type  and TMark = @@TMark	
     
     						update settlement set billflag = 3,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff) * MarketRate     
     						where party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty   and PartiPantCode =@@PartiPantCode	
     						and sett_no = @sett_no and Sett_Type = @Sett_type   and TMark = @@TMark	
     						
						select @@Pdiff = 0   
    					end 
    					fetch next from @@Loop into @@Ltrade_no,@@Lqty
   				end
   				close @@Loop
  			end
 		/*end */
 		fetch next from @@Flag into @@party,@@scrip,@@series,@@Pqty,@@sqty,@@partipantcode,@@TMark
	end 
	close @@Flag
	deallocate @@Flag
/*	
	UPDATE settlement SET service_tax = ((brokapplied*tradeqty*(select service_tax from globals where year_start_dt < getdate() )) /100),
	Nsertax = ((brokapplied*tradeqty*(select service_tax from globals where year_start_dt < getdate() )) /100), 
	Amount = (tradeqty * netrate) 
	where sett_no = @Sett_no
	and sett_type = @Sett_Type
*/

GO
