-- Object: PROCEDURE citrus_usr.AUTO_NON_POA_trade_infor_SMS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



---AUTO_NON_POA_trade_infor_SMS '2020180'

CREATE proc [citrus_usr].[AUTO_NON_POA_trade_infor_SMS] (@sett_no varchar(11))
as

begin
		Create table #DIY_Reprocess_log
		(sett_no varchar(11),sett_type VARCHAR(2),PARTY_CODE VARCHAR(15),SHORT_NAME VARCHAR(200),BRANCH_CD VARCHAR(20),SUB_BROKER VARCHAR(20)
		,SCRIP_CD VARCHAR(15),CERTNO VARCHAR(20),	DELQTY INT,	RECQTY INT,	ISETTQTYPRINT INT,	ISETTQTYMARK INT,
			IBENQTYPRINT INT,	IBENQTYMARK INT,	HOLD INT,	PLEDGE  INT,	BSEHOLD	INT , BSEPLEDGE	INT ,CL_TYPE VARCHAR(15),	COLLATERAL INT
			)
			 

		INSERT  INTO #DIY_Reprocess_log
		---Exec [ANGELDEMAT].msajag.dbo.Rpt_ShortagePayin 'broker','broker','2020018','2020018','N','%',-1
		Exec [ANGELDEMAT].msajag.dbo.Rpt_DelPayinMatch 'broker', 'broker', @SETT_NO,'N','ALL','%',2

		INSERT  INTO #DIY_Reprocess_log
		--Exec [ANGELDEMAT].msajag.dbo.Rpt_ShortagePayin 'broker','broker',@SETT_NO,@SETT_NO,'W','%',-1
		Exec [ANGELDEMAT].msajag.dbo.Rpt_DelPayinMatch 'broker', 'broker',@SETT_NO,'W','ALL','%',2

		select * into #diy from DIY_Reprocess_log where 1=2 
		
		
	 

 	
		 INSERT INTO #diy  
		 SELECT sett_no,sett_type,PARTY_CODE,SCRIP_CD,'',SELLtradeqty=0,sellRECQTY=0,
		 Sell_shortage = (case when DelQty  -  RecQty -  ISettQtyPrint -  IBenQtyPrint -hold-COLLATERAL>0 
		 then DelQty  -  RecQty -  ISettQtyPrint -  IBenQtyPrint -hold-COLLATERAL
		 else 0 end)
		 ,DP_ID='',ISIN=CERTNO,PROCESS_DATE=GETDATE(),0,'',0,'N',1,ADJ_QTY=0 
		 FROM #DIY_Reprocess_log

		UPDATE D SET DP_ID = Cltdpid FROM #diy D,[ANGELDEMAT].MSAJAG.DBO.CLIENT4 C  
		WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		AND SETT_NO=@SETT_NO AND PROCESS_FLAG=0
       
	    
	   
  
		  UPDATE D SET DP_ID = Cltdpid FROM #diy D,[ANGELDEMAT].BSEDB.DBO.CLIENT4 C  
		  WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		   AND SETT_NO= @SETT_NO AND PROCESS_FLAG=0 AND LEN(ISNULL(DP_ID,''))<16  

		  select client_code into #clt   FROM  #diy D (nolock),TBL_CLIENT_POA P  (nolock)
		   WHERE DP_ID=CLIENT_CODE   
			AND MASTER_POA ='2203320000000014' AND POA_STATUS ='A'   AND SETT_NO= @SETT_NO AND PROCESS_FLAG=0 

			create index #cl on #clt(client_code )

		  UPDATE  D SET POA_FLAG ='1'   FROM  citrus_usr.DIY_Reprocess_log D (nolock),#clt P  (nolock)
		   WHERE DP_ID=CLIENT_CODE   
			 AND SETT_NO= @SETT_NO AND PROCESS_FLAG=0 
      
 

			UPDATE D   
		   SET   
		   DP_HOLDING =HLD_AC_POS  
		   FROM  
			#diy d (nolock)   ,HoldingData h   (nolock) 
		   WHERE 
			DP_ID =HLD_AC_CODE    AND SETT_NO= @SETT_NO AND PROCESS_FLAG=0 
		   AND ISIN =HLD_ISIN_CODE     
   
   
			UPDATE D SET  ADJ_QTY =(CASE WHEN Sell_shortage >DP_HOLDING THEN DP_HOLDING ELSE Sell_shortage END)
		   FROM  #diy  D 
		   WHERE SETT_NO= @SETT_NO AND PROCESS_FLAG=0 



		-- DELETE D FROM  #diy D WHERE DP_HOLDING =0 AND SETT_NO= @SETT_NO AND PROCESS_FLAG=0 

		 

			--SELECT * FROM citrus_usr.DIY_Reprocess_log WHERE   SETT_NO= @SETT_NO AND PROCESS_FLAG=0 
			--AND POA_FLAG ='' AND DP_HOLDING >0  AND DP_CONCERN='Y'

			  create index #s on #diy (party_code ,scrip_cd)  

			  Declare @sdate datetime
			  select @sdate=start_date from [ANGELDEMAT].msajag.dbo.sett_mst where sett_no=@SETT_NO and sett_type='N' 
			  
			  
  
  
  select distinct a.party_code as COL1,Symbol,COL24,Initiated_By,Modified_By,DealerID,DP_ID,ISIN into #temp
   from   
    INTRANET.ebroking.dbo.tbl_All_tradeFile a inner join #diy b on  
   a.PARTY_CODE=b.party_code   
   and a.Symbol=b.scrip_cd  
   where Sauda_Date between @sdate and  @sdate + ' 23:59' and COL4='Equities' 
   UNION ALL
    select distinct a.party_code as COL1,Symbol,COL24,Initiated_By,Modified_By,DealerID,DP_ID,ISIN  from   
    INTRANET.ebroking.dbo.tbl_All_tradeFile_hist a inner join #diy b on  
   a.PARTY_CODE=b.party_code   
   and a.Symbol=b.scrip_cd  
   where Sauda_Date between @sdate and  @sdate + ' 23:59' and COL4='Equities'  
           
  
   ALTER TABLE #diy  
   ADD ORDER_TYPE VARCHAR(15),Initiated_By  VARCHAR(20)  
    
  
    
  UPDATE D SET ORDER_TYPE = COL24,Initiated_By=T.Initiated_By  FROM #diy D ,#temp T  
  WHERE  D.PARTY_CODE=COL1 AND SYMBOL=SCRIP_CD   
  AND COL24 ='DELIVERY'  
  
   UPDATE D SET ORDER_TYPE = COL24,Initiated_By=T.Initiated_By  FROM #diy D ,#temp T  
  WHERE  D.PARTY_CODE=COL1 AND SYMBOL=SCRIP_CD   
  AND COL24 ='MARGIN'  AND ISNULL(ORDER_TYPE,'')=''  
  
  UPDATE D SET ORDER_TYPE = COL24,Initiated_By=T.Initiated_By  FROM #diy D ,#temp T  
  WHERE  D.PARTY_CODE=COL1 AND SYMBOL=SCRIP_CD   
  AND COL24 ='INTRADAY' AND ISNULL(ORDER_TYPE,'')=''  
  
  UPDATE D SET ORDER_TYPE = COL24,Initiated_By=T.Initiated_By  FROM #diy D ,#temp T  
  WHERE  D.PARTY_CODE=COL1 AND SYMBOL=SCRIP_CD   
  AND COL24 ='BRACKETORDER' AND ISNULL(ORDER_TYPE,'')=''  
       
  
 -- insert into MIS.KYC.dbo.TBL_SELL_ORDER_TPIN_test (CLIENT_CODE,CREATED_DATE)
 --  SELECT distinct D.PARTY_CODE,GETDATE() d
 --   FROM #diy D 
	--left outer join 
	--INTRANET.risk.dbo.client_Details c
	--on d.PARTY_CODE=c.cl_code

   SELECT D.PARTY_CODE,branch_cd,sub_broker,CL_TYPE,SCRIP_CD,SELL_SHORTAGE,DP_HOLDING,adj_qty, POA_FLAG,Initiated_By, ORDER_TYPE,B2C ,DP_ID,ISIN
    into #FINAL_DIY
	FROM #diy D 
	left outer join 
	INTRANET.risk.dbo.client_Details c
	on d.PARTY_CODE=c.cl_code

select COUNT(*) from #FINAL_DIY
 
 
  SELECT DISTINCT PARTY_CODE INTO #FINAL_SMS  FROM #FINAL_DIY WHERE POA_FLAG ='' AND  CL_TYPE <>'NBF' AND INITIATED_BY  IN ('AEMOBILE','ANGELEYE') 
  AND DP_HOLDING <>0
  
 -- DELETE FROM #FINAL_DIY WHERE PARTY_CODE IN (SELECT * FROM #FINAL_SMS)

  INSERT INTO  #FINAL_SMS 
  SELECT DISTINCT PARTY_CODE FROM #FINAL_DIY WHERE POA_FLAG ='' AND  CL_TYPE <>'NBF' AND 
   INITIATED_BY  IN ('ADMIN','TWS','DIET')
 
 
 SELECT DISTINCT * FROM #FINAL_SMS
  
  end

GO
