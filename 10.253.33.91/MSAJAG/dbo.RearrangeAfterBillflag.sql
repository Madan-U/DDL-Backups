-- Object: PROCEDURE dbo.RearrangeAfterBillflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 12/16/2003 2:31:22 PM ******/



/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 05/08/2002 12:35:05 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 01/14/2002 20:32:46 ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 12/26/2001 1:23:12 PM ******/



/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 5/4/01 5:14:52 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 4/5/01 6:40:56 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterBillflag    Script Date: 12/27/00 8:59:17 PM ******/

/*
Recent changes done by vaishali on 8/1/2001
Added tmark and member code in each condition
Added first 5 conditions to set the billflag
*/

CREATE  PROCEDURE RearrangeAfterBillflag (@Sett_No varchar(7),@Sett_Type varchar(2),@Party Varchar(10),@Scrip varchar(12),@Series varchar(2),@Memcode varchar(15),@Tmark varchar(1)) AS 
declare 
 @@trade_no varchar(14),
 @@Pqty numeric(9), 
 @@Sqty numeric(9),
 @@Ltrade_no varchar(14),
 @@Lqty numeric(9), 
 @@Pdiff numeric(9),
@@TTRADE_NO VARCHAR(14),
@@TFLAG INT,
@@TRD CURSOR,
 @@Flag cursor,
 @@loop cursor

	Update Settlement set Billflag = (case when s.sell_buy = 1 then 2
				       else 3  end )
	from Settlement s,Cursorbillsale b 
	where b.sett_no = s.sett_no
	and b.sett_type = s.sett_type 
	and b.party_code = s.party_code	
 	and b.scrip_cd = s.scrip_Cd           
	and b.series = s.series          
              	AND  b.sqty<> 0 and b.pqty <>  0 
              	and s.tmark = b.tmark
	and s.partipantcode = b.partipantcode 
	and  s.party_code = @Party and s.scrip_cd = @scrip
             	and s.series = @series    
	and s.Sett_no = @Sett_No and s.Sett_Type = @Sett_type
	and s.partipantcode = @Memcode
	and s.tmark = @Tmark
	


	Update Settlement set Billflag = 4 from Settlement s,Cursorbillsale b 
	where b.sett_no = s.sett_no
	and b.sett_type = s.sett_type 
	and b.party_code = s.party_code	
 	and b.scrip_cd = s.scrip_Cd           
	and b.series = s.series          
                AND  b.sqty = 0 and b.pqty >  0 
                AND s.SELL_BUY = 1
                and s.tmark = b.tmark
	and s.partipantcode = b.partipantcode 
	and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series    
	and s.Sett_no = @Sett_No and s.Sett_Type = @Sett_type
	and s.partipantcode = @Memcode
	and s.tmark = @Tmark

	Update Settlement set Billflag = 5 from Settlement s,Cursorbillsale b 
	where b.sett_no = s.sett_no
	and b.sett_type = s.sett_type 
	and b.party_code = s.party_code	
 	and b.scrip_cd = s.scrip_Cd           
	and b.series = s.series          
                AND  b.sqty > 0 and b.pqty =  0 
                AND s.SELL_BUY = 2
                and s.tmark = b.tmark
	and s.partipantcode = b.partipantcode 
	and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series    
	and s.Sett_no = @Sett_No and s.Sett_Type = @Sett_type
	and s.partipantcode = @Memcode
	and s.tmark = @Tmark
 

	/*  apply sett_flag =4 if sell_ buy = 'B' else 5  to all trades where TMark  = 'D' */
	Update settlement set Billflag = 1
	where  party_code = @Party and scrip_cd = @scrip and series = @series    
	 and Sett_Type = @Sett_type  and sett_no = @sett_no
	and Partipantcode = @Memcode and TMark = 'D'
	And  tradeqty > 0 

	/*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */
	Update settlement  set Billflag = 1  FROM Settlement t , CLIENT2 
	where  CLIENT2.PARTY_CODE = t.PARTY_CODE 
	and CLIENT2.tran_cat = 'DEL'  and
	t.party_code = @Party and t.scrip_cd = @scrip and t.series = @series    
	and  t.Sett_Type = @Sett_type  
	and t.Partipantcode = @Memcode and t.Tmark = @Tmark
	And  t.tradeqty > 0 	


	set @@Flag = cursor for
	select pqty,sqty from CursorBillUnEqualSalePur
	where sett_no = @sett_no and Sett_Type = @Sett_type
	and Party_code = @Party and Scrip_Cd = @Scrip
	and Series = @Series
	and partipantcode = @Memcode
	and tmark = @Tmark
	 and pqty <> 0 AND  sqty <> 0 and isnull(pqty,0) <> isnull(sqty,0)
	group by pqty,sqty

	open @@flag
	fetch next from @@Flag into @@Pqty,@@sqty
	
	While @@fetch_status = 0 
	begin
	 if @@Sqty = 0
		  update settlement set Billflag = 4 
		  where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
		  and sett_no = @sett_no and Sett_Type = @Sett_type  and  partipantcode = @Memcode
		  and tmark = @Tmark
	  else if @@Pqty = 0
		  update settlement set Billflag = 5 
		  where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2
		  and sett_no = @sett_no and Sett_Type = @Sett_type   and partipantcode = @Memcode	and tmark = @Tmark
	 else if @@Pqty = @@Sqty 
		  update settlement set Billflag = (Case When Sell_Buy = 1 then 2 else 3 end ) ,N_netrate = NetRate,NSertax = service_tax,nbrokapp = brokapplied
		  where party_code = @Party and scrip_cd = @scrip and series = @series 
		  and sett_no = @sett_no and Sett_Type = @Sett_type   and partipantcode = @Memcode and tmark = @Tmark
	 else if @@Pqty > @@Sqty 
	 begin 
		select @@pdiff = @@Pqty - @@Sqty 
		/*set @@Loop  = cursor for 
			select trade_no,tradeqty from settlement 
			where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
			and sett_no = @sett_no and Sett_Type = @Sett_type and tradeqty = @@Pdiff   and partipantcode = @Memcode	and tmark = @Tmark
			open @@loop
			fetch next from @@Loop into @@Ltrade_no,@@Lqty     
			if @@fetch_status = 0 
			begin
				update settlement set Billflag = 4   
  				where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
  				and trade_no = @@ltrade_no and tradeqty = @@lqty  
		   		and sett_no = @sett_no and Sett_Type = @Sett_type   and partipantcode = @Memcode	and tmark = @Tmark
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
   				where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
    				and sett_no = @sett_no and Sett_Type = @Sett_type  and partipantcode = @Memcode	
				and tmark = @Tmark  and SettFlag = 4
				/* order by marketrate asc, Tradeqty Desc  */
--				order by marketrate Desc
			          Order by Sauda_date
   				open @@loop
  				fetch next from @@Loop into @@Ltrade_no,@@Lqty     
	   			while @@pdiff > 0       
		   		begin
			    		if @@pdiff >= @@Lqty 
    					begin
	    					update settlement set Billflag = 4   
    						where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty  
     						and sett_no = @sett_no and Sett_Type = @Sett_type  
						 and partipantcode = @Memcode and tmark = @Tmark

     						select @@pdiff = @@Pdiff - @@Lqty
   	 				end    
    					else if @@pdiff < @@Lqty 
    					begin
						SELECT @@TTRADE_NO = @@ltrade_no
						SELECT @@TFLAG = 1 
						WHILE @@TFLAG = 1 
						BEGIN
							SET @@TRD = CURSOR FOR
							SELECT TRADE_NO FROM SETTLEMENT WHERE TRADE_NO = 'B' + @@TTRADE_NO
							AND party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
							and sett_no = @sett_no and Sett_Type = @Sett_type  
							OPEN @@TRD
							FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
							IF @@FETCH_STATUS = 0 
								SELECT @@TFLAG = 1
							ELSE
								SELECT @@TFLAG = 0
							CLOSE @@TRD
							DEALLOCATE @@TRD			
						END	
     						insert into settlement select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,tmark,scheme,Dummy1,Dummy2
     						from Settlement where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty  
     						and sett_no = @sett_no and Sett_Type = @Sett_type  
 
     						update settlement set BillFlag = 2,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate,N_netrate = NetRate,NSertax = service_tax,nbrokapp = brokapplied    
    			 			where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty
     						and sett_no = @sett_no and Sett_Type = @Sett_type  
						 and partipantcode = @Memcode and tmark = @Tmark

     						select @@Pdiff = 0   
    					end 
    					fetch next from @@Loop into @@Ltrade_no,@@Lqty
  				 end
	   			close @@Loop
 			 /*end    */
		 end
		 else if @@Pqty < @@Sqty
 		begin 
 			 select @@pdiff = @@sqty - @@pqty
  			/*set @@Loop  = cursor for 
   			select trade_no,tradeqty from settlement 
  			 where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
  			 and sett_no = @sett_no and Sett_Type = @Sett_type and tradeqty = @@Pdiff 
			 and partipantcode = @Memcode and tmark = @Tmark 
  			open @@loop
  			fetch next from @@Loop into @@Ltrade_no,@@Lqty     
 			 if @@fetch_status = 0 
  			begin
  				 update settlement set Billflag = 5  
  				 where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
   				and trade_no = @@ltrade_no and tradeqty = @@lqty  
   				and sett_no = @sett_no and Sett_Type = @Sett_type  
				 and partipantcode = @Memcode and tmark = @Tmark
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
    				where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
    				and sett_no = @sett_no and Sett_Type = @Sett_type
				and partipantcode = @Memcode and tmark = @Tmark  and SettFlag = 5
				/* order by marketrate asc, Tradeqty Desc  */
--				order by marketrate Desc
			        Order by Sauda_date	
   				open @@loop
   				fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   				while @@pdiff > 0       
   				begin
    					if @@pdiff >= @@Lqty 
    					begin
     						update Settlement set Billflag = 5   
    						 where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty  
     						and sett_no = @sett_no and Sett_Type = @Sett_type  
						 and partipantcode = @Memcode and tmark = @Tmark
     						select @@pdiff = @@Pdiff - @@Lqty
    					end    
    					else if @@pdiff < @@Lqty 
    					begin
						SELECT @@TTRADE_NO = @@ltrade_no
						SELECT @@TFLAG = 1 
						WHILE @@TFLAG = 1 
						BEGIN
							SET @@TRD = CURSOR FOR
							SELECT TRADE_NO FROM SETTLEMENT WHERE TRADE_NO = 'B' + @@TTRADE_NO
							AND party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
							and sett_no = @sett_no and Sett_Type = @Sett_type  
							OPEN @@TRD
							FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
							IF @@FETCH_STATUS = 0 
								SELECT @@TFLAG = 1
							ELSE
								SELECT @@TFLAG = 0
							CLOSE @@TRD
							DEALLOCATE @@TRD			
						END	
     						insert into settlement select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
    						from Settlement where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty  
     						and sett_no = @sett_no and Sett_Type = @Sett_type  
     
     						update settlement set billflag = 3,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff) * MarketRate,N_netrate = NetRate,NSertax = service_tax,nbrokapp = brokapplied     
						where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
     						and trade_no = @@ltrade_no and tradeqty = @@lqty
     						and sett_no = @sett_no and Sett_Type = @Sett_type   
						 and partipantcode = @Memcode and tmark = @Tmark
     						select @@Pdiff = 0   
    					end 
    					fetch next from @@Loop into @@Ltrade_no,@@Lqty
   				end
   				close @@Loop
	 		/*end*/
 		end 
 		fetch next from @@Flag into @@Pqty,@@sqty
	end 
	close @@Flag
	deallocate @@Flag
exec SettBrokDelUpdate @sett_no,@sett_type,@party
exec updbilltax

/*else
 	update Settlement set Billflag = 1 
 	where party_code = @Party and scrip_cd = @scrip and series = @series  
 	and sett_no = @sett_no and Sett_Type = @Sett_type  
	 and partipantcode = @Memcode and tmark = @Tmark*/

GO
