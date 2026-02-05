-- Object: PROCEDURE citrus_usr.Edis_trxn_process
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[Edis_trxn_process] (@payout varchar(8))
as

TRUNCATE TABLE HOLD_REP_N

	 select party_code,isin,adj_qty ,dp_id,ROW_NUMBER()over(order by party_code,isin desc) SR_NO into #pld1 from DIY_Reprocess_log_e_dis with(nolock)
	

	 	 SELECT distinct partycode,boid,isin,qty= (case when cast(ISNULL(Pend_qty,0)as float)>0 then cast(ISNULL(Pend_qty,0) as float) else qty end ) , ANGEL_TRXN_ID,	
		 CDSL_TRXN_Id,Request_date, ROW_NUMBER()OVER(ORDER BY PARTYCODE,boid,isin,
		 Request_date DESC) AS SRNO into #FINAL_DUMP
		 FROM E_Dis_Trxn_Data t
		 where exists (select party_code from DIY_Reprocess_log_e_dis d 
		 where d.party_code =t.Partycode and d.isin=t.isin 
		  --and getdate() between Request_date
		  --and Request_date+NO_of_days+ ' 23:59'
		  ) 
		  and dummy2=@payout --Request_date >='2021-02-20' and NO_of_days=5 --AND ISNULL(VALID,0)=0 and isnull(dummy3,'')=''
		 -- order by partycode,Request_date

 create Index #t on #pld1
 (SR_NO)

 create index #FIN1 on #FINAL_DUMP
 (partycode,isin )

 ALTER TABLE #FINAL_DUMP
 ADD ALLOCATE_QTY FLOAT

 DECLARE @CNT3 INT  ,@ISIN3 VARCHAR(15),@QTY3  INT ,@NEWQTY3 INT,@NEWID3 VARCHAR(25) ,@NEWSNO3 INT  ,@PARTY_CODE VARCHAR(10)
,@ID3 INT  ,@PARTY_CODE3 VARCHAR(10),@oldid3 varchar(25),@NEWSNO31 INT ,@NEWCNT3 INT ,@EXCHANGE3 VARCHAR(15) ,@ID31 INT,@QTYN FLOAT
 
 SELECT @CNT3=COUNT(*) FROM #pld1 

  SET @ID3 =1

WHILE (@ID3<=@CNT3)

	  BEGIN   --select * from #pld1
	          
			 SELECT @ISIN3=ISIN,@QTY3=adj_qty ,@NEWID3 =dp_id ,@PARTY_CODE=party_code FROM #pld1  WHERE SR_NO =@ID3  
			    
				
				SELECT * INTO  #final_data FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY request_Date desc) SR_NO , * 
				FROM #FINAL_DUMP WHERE ISIN =@ISIN3  AND boid= @NEWID3 and partycode=@PARTY_CODE)A
				ORDER BY SR_NO  

				insert into HOLD_REP_N   
					select * from (
				SELECT SR_NO,	partycode,	boid	,isin,	qty,	ANGEL_TRXN_ID,	CDSL_TRXN_Id,	Request_date,srno,
					(SELECT SUM(qty) 
									FROM #final_data b 
									WHERE b.SR_NO <= a.SR_NO) AS b 
							FROM #final_data a
							) a
							where b<@QTY3
				
				if( @@rowcount =0)
				   
				    begin 
					
				insert into HOLD_REP_N
				--select SR_NO,srno, isin ,CLIENTID ,@QTY3  ,0 from 	#final_data where SR_NO=1 
				select SR_NO,	partycode,	boid	,isin,	qty,	ANGEL_TRXN_ID,	CDSL_TRXN_Id,	Request_date, srno,@QTY3  from #final_data where SR_NO=1 

			end

				else 

				   begin 
				 
				    select @NEWID3=max(sr_no),@NEWQTY3=sum(qty) from HOLD_REP_N where ISIN =@ISIN3  AND boid= @NEWID3 and partycode =@PARTY_CODE
		
					insert into HOLD_REP_N
		           select  SR_NO,	partycode,	boid	,isin,	qty,	ANGEL_TRXN_ID,	CDSL_TRXN_Id,	Request_date,srno, @QTY3-@NEWQTY3  from 	#final_data where SR_NO=@NEWID3+1
		
		
		            END  



              SET @NEWSNO31=@NEWSNO31+1

                  
				 DROP TABLE #final_data




   	  SET @ID3 =@ID3 +1 
	  PRINT @ID3
	END 		

	
 --select * from HOLD_REP_N
 ----select * from #FINAL_DUMP

GO
