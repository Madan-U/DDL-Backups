-- Object: PROCEDURE dbo.ALBMSUBDELCHECKCURSOR
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC ALBMSUBDELCHECKCURSOR (@SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2),@Memcode varchar(15),@Tmark varchar(1)) AS
DECLARE @@ALBMCUR CURSOR,
	@@SETTCUR CURSOR,
	@@PQTY NUMERIC(9),
	@@SQTY NUMERIC(9),
	@@PARTY VARCHAR(10),
	@@SCRIP VARCHAR(10),
	@@SERIES VARCHAR(2),
	@@TRADE_NO VARCHAR(14),
	@@SETT_TYPE VARCHAR(1),
	@@Lqty NUMERIC(9),
	@@PDIFF NUMERIC(9)
if @sett_no < '2000050'  and @sett_type = 'N' 
 select @@pdiff = 0 
else if @sett_no < '2000233'  and @sett_type = 'W' 
 select @@pdiff = 0 
else
begin
SELECT @@SERIES = (CASE WHEN @SETT_TYPE = 'L' THEN 'EQ' ELSE 'BE' END )
SELECT @@SETT_TYPE = ( CASE WHEN @SETT_TYPE = 'P' THEN 'W' ELSE 'N' END )
SET @@ALBMCUR = CURSOR FOR
SELECT PARTIPANTCODE,SCRIP_CD,SUM(PQTY),SUM(SQTY) FROM ALBMSUBCURSOR 
WHERE SETT_NO =  @SETT_NO  AND SETT_TYPE = @SETT_TYPE 
GROUP BY PARTIPANTCODE,SCRIP_CD
OPEN @@ALBMCUR
FETCH NEXT FROM @@ALBMCUR INTO @@PARTY,@@SCRIP,@@PQTY,@@SQTY
SELECT @@PARTY,@@SCRIP,@@PQTY,@@SQTY
WHILE @@FETCH_STATUS = 0 
BEGIN 
	IF @@PQTY > @@SQTY
	BEGIN
		SELECT @@PDIFF = @@PQTY - @@SQTY
		SET @@SETTCUR = CURSOR FOR		
		select trade_no,tradeqty from TRDBACKUP
   		where partIPANTcode = @@Party and scrip_cd = @@scrip and sell_buy = 2 
		and sett_no = @sett_no and Sett_Type = @@Sett_type and tradeqty = @@Pdiff AND BILLFLAG = 5
		OPEN @@SETTCUR 
		FETCH NEXT FROM @@SETTCUR INTO @@TRADE_NO,@@LQTY
		IF @@FETCH_STATUS = 0 
		BEGIN
			UPDATE TRDBACKUP SET BILLFLAG = 3 
	   		where partIPANTcode = @@Party and scrip_cd = @@scrip and sell_buy = 2 
			and sett_no = @sett_no and Sett_Type = @@Sett_type and tradeqty = @@Pdiff AND BILLFLAG = 5
			CLOSE @@SETTCUR
			DEALLOCATE @@SETTCUR
		END
		ELSE 
		BEGIN
			CLOSE @@SETTCUR
			DEALLOCATE @@SETTCUR
			SET @@SETTCUR = CURSOR FOR
			select trade_no,tradeqty from TRDBACKUP where PARTIPANTCODE = @@Party and scrip_cd = @@scrip 
			AND sell_buy = 2 and sett_no = @sett_no and Sett_Type = @@Sett_type 
			AND BILLFLAG = 5 order by marketrate asc, Tradeqty Desc  
			OPEN @@SETTCUR 
			FETCH NEXT FROM @@SETTCUR INTO @@TRADE_NO,@@LQTY
			WHILE @@FETCH_STATUS = 0 AND @@PDIFF > 0 
			BEGIN
				IF @@PDIFF >= @@LQTY	
				BEGIN
					UPDATE TRDBACKUP SET BILLFLAG = 3 
			   		where PARTIPANTCODE = @@Party and scrip_cd = @@scrip and sell_buy = 2 
					and sett_no = @sett_no and Sett_Type = @@Sett_type and tradeqty = @@LQTY AND BILLFLAG = 5		
					SELECT @@PDIFF = @@PDIFF - @@LQTY	
				END
				ELSE IF @@PDIFF < @@LQTY 
				BEGIN
					insert into TRDBACKUP select ContractNo,BillNo,'B'+Trade_no,PARTIPANTCODE,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,3,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
				        from TRDBACKUP where PARTIPANTCODE = @@Party and scrip_cd = @@scrip and sell_buy = 2 AND BILLFLAG = 5	
					and trade_no = @@trade_no and tradeqty = @@lqty and sett_no = @sett_no and Sett_Type = @@Sett_type  

			   	        update TRDBACKUP set BillFlag = 5,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
  			     	  	where PARTIPANTCODE = @@Party and scrip_cd = @@scrip And sell_buy = 2 AND BILLFLAG = 5	
			  	  	and trade_no = @@trade_no and tradeqty = @@lqty and sett_no = @sett_no and Sett_Type = @@Sett_type  
					
					select @@Pdiff = 0   
				END
				
				FETCH NEXT FROM @@SETTCUR INTO @@TRADE_NO,@@LQTY
			END
			CLOSE @@SETTCUR
			DEALLOCATE @@SETTCUR
		END				
	END
	ELSE IF @@PQTY < @@SQTY
	BEGIN
		SELECT @@PDIFF = @@SQTY - @@PQTY
		SET @@SETTCUR = CURSOR FOR
		select trade_no,tradeqty from TRDBACKUP 
   		where PARTIPANTCODE = @@Party and scrip_cd = @@scrip and sell_buy = 1 
		and sett_no = @sett_no and Sett_Type = @@Sett_type and tradeqty = @@Pdiff AND BILLFLAG = 4
		OPEN @@SETTCUR 
		FETCH NEXT FROM @@SETTCUR INTO @@TRADE_NO,@@LQTY		
		IF @@FETCH_STATUS = 0 
		BEGIN
			UPDATE TRDBACKUP SET BILLFLAG = 2 
	   		where PARTIPANTCODE = @@Party and scrip_cd = @@scrip and sell_buy = 1 
			and sett_no = @sett_no and Sett_Type = @@Sett_type and tradeqty = @@Pdiff AND BILLFLAG = 4
			CLOSE @@SETTCUR
			DEALLOCATE @@SETTCUR
		END
		ELSE 
		BEGIN
			CLOSE @@SETTCUR
			DEALLOCATE @@SETTCUR
			SET @@SETTCUR = CURSOR FOR				
			select trade_no,tradeqty from TRDBACKUP where PARTIPANTCODE = @@Party and scrip_cd = @@scrip 
			AND sell_buy = 1 and sett_no = @sett_no and Sett_Type = @@Sett_type 
			AND BILLFLAG = 4 order by marketrate asc, Tradeqty Desc  
			OPEN @@SETTCUR 
			FETCH NEXT FROM @@SETTCUR INTO @@TRADE_NO,@@LQTY
			WHILE @@FETCH_STATUS = 0 AND @@PDIFF > 0 
			BEGIN
				IF @@PDIFF >= @@LQTY	
				BEGIN
					UPDATE TRDBACKUP SET BILLFLAG = 2 
			   		where PARTIPANTCODE = @@Party and scrip_cd = @@scrip and sell_buy = 1 
					and sett_no = @sett_no and Sett_Type = @@Sett_type and tradeqty = @@LQTY AND BILLFLAG = 4	
					SELECT @@PDIFF = @@PDIFF - @@LQTY	
				END
				ELSE IF @@PDIFF < @@LQTY 
				BEGIN
					insert into TRDBACKUP select ContractNo,BillNo,'B'+Trade_no,PARTIPANTCODE,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,2,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
				        from TRDBACKUP where PARTIPANTCODE = @@Party and scrip_cd = @@scrip and sell_buy = 1 AND BILLFLAG = 4	
					and trade_no = @@trade_no and tradeqty = @@lqty and sett_no = @sett_no and Sett_Type = @@Sett_type  

			   	        update TRDBACKUP set BillFlag = 4,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
  			     	  	where PARTIPANTCODE = @@Party and scrip_cd = @@scrip And sell_buy = 1 AND BILLFLAG = 4	
			  	  	and trade_no = @@trade_no and tradeqty = @@lqty and sett_no = @sett_no and Sett_Type = @@Sett_type  
					
					select @@Pdiff = 0   
				END
				
				FETCH NEXT FROM @@SETTCUR INTO @@TRADE_NO,@@LQTY
			END
			CLOSE @@SETTCUR
			DEALLOCATE @@SETTCUR
		END				
	END
	FETCH NEXT FROM @@ALBMCUR INTO @@PARTY,@@SCRIP,@@PQTY,@@SQTY
END
	EXEC ALBMSUBBROKUPDATE @SETT_NO,@@SETT_TYPE
END

GO
