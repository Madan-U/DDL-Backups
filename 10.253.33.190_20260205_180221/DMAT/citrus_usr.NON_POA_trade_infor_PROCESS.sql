-- Object: PROCEDURE citrus_usr.NON_POA_trade_infor_PROCESS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




---NON_POA_trade_infor_PROCESS '2020129'

CREATE proc [citrus_usr].[NON_POA_trade_infor_PROCESS] (@sett_no varchar(11),@FLAG VARCHAR(11))
as

 If @flag ='R'

begin


		Create table #DIY_Reprocess_log
		(sett_no varchar(11),sett_type VARCHAR(2),PARTY_CODE VARCHAR(15),SHORT_NAME VARCHAR(200),BRANCH_CD VARCHAR(20),SUB_BROKER VARCHAR(20)
		,SCRIP_CD VARCHAR(15),CERTNO VARCHAR(20),	DELQTY INT,	RECQTY INT,	ISETTQTYPRINT INT,	ISETTQTYMARK INT,
			IBENQTYPRINT INT,	IBENQTYMARK INT,	HOLD INT,	PLEDGE  INT,	BSEHOLD	INT , BSEPLEDGE	INT ,CL_TYPE VARCHAR(15),	COLLATERAL INT
			)
			 

		INSERT  INTO #DIY_Reprocess_log
		---Exec [ANGELDEMAT].msajag.dbo.Rpt_ShortagePayin 'broker','broker','2020018','2020018','N','%',-1
		Exec [AngelDemat].msajag.dbo.Rpt_DelPayinMatch 'broker', 'broker', @sett_no,'N','ALL','%',2

		INSERT  INTO #DIY_Reprocess_log
		--Exec [ANGELDEMAT].msajag.dbo.Rpt_ShortagePayin 'broker','broker',@sett_no,@sett_no,'W','%',-1
		Exec [AngelDemat].msajag.dbo.Rpt_DelPayinMatch 'broker', 'broker', @sett_no,'W','ALL','%',2

 		DECLARE @CNT INT
		SELECT @CNT =ISNULL(MAX(NO_CNT),0) FROM DIY_Reprocess_log WHERE SETT_NO=@sett_no 

		/*
		select party_code,certno,sum(qty) as qty into #hld from [ANGELDEMAT].msajag.dbo.deltrans 
		where bcltdpid in ('1203320030135814',
			'1203320030135829') and trtype ='904' and drcr='D' and delivered='0' and filler2=1
			group by party_code,certno

			update d set COLLATERAL=(case when COLLATERAL-qty >=0 then COLLATERAL-qty else 0 end)
			 from #DIY_Reprocess_log d,#hld h
			where d.PARTY_CODE= h.party_code and d.CERTNO =h.certno 
			*/



		 INSERT INTO DIY_Reprocess_log  
		 SELECT sett_no,sett_type,PARTY_CODE,SCRIP_CD,'',SELLtradeqty=0,sellRECQTY=0,
		 Sell_shortage = (case when DelQty  -  RecQty -  ISettQtyPrint -  IBenQtyPrint  >0 
		 then DelQty  -  RecQty -  ISettQtyPrint -  IBenQtyPrint ----hold
		 else 0 end)
		 ,DP_ID='',ISIN=CERTNO,PROCESS_DATE=GETDATE(),0,'',0,'N',@CNT+1,ADJ_QTY=0 
		 FROM #DIY_Reprocess_log

		UPDATE D SET DP_ID = Cltdpid FROM DIY_Reprocess_log D,[ANGELDEMAT].MSAJAG.DBO.CLIENT4 C  
		WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		AND SETT_NO= @sett_no AND PROCESS_FLAG=0
       
	    
	   
  
		  UPDATE D SET DP_ID = Cltdpid FROM citrus_usr.DIY_Reprocess_log D,[ANGELDEMAT].BSEDB.DBO.CLIENT4 C  
		  WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		   AND SETT_NO= @sett_no AND PROCESS_FLAG=0 AND LEN(ISNULL(DP_ID,''))<16  

		  select client_code into #clt   FROM  citrus_usr.DIY_Reprocess_log D (nolock),TBL_CLIENT_POA P  (nolock)
		   WHERE DP_ID=CLIENT_CODE   
			AND MASTER_POA ='2203320000000014' AND POA_STATUS ='A'   AND SETT_NO= @sett_no AND PROCESS_FLAG=0 

			create index #cl on #clt(client_code )

		  UPDATE  D SET POA_FLAG ='1'   FROM  citrus_usr.DIY_Reprocess_log D (nolock),#clt P  (nolock)
		   WHERE DP_ID=CLIENT_CODE   
			 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
      
 

			UPDATE D   
		   SET   
		   DP_HOLDING =FREE_QTY  
		   FROM  
			DIY_Reprocess_log d (nolock)   ,holding h   (nolock) 
		   WHERE 
			DP_ID =HLD_AC_CODE    AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
		   AND ISIN =HLD_ISIN_CODE     
   
    
   
			UPDATE D SET  ADJ_QTY =(CASE WHEN Sell_shortage >DP_HOLDING THEN DP_HOLDING ELSE Sell_shortage END)
		   FROM  DIY_Reprocess_log  D 
		   WHERE SETT_NO= @sett_no AND PROCESS_FLAG=0 



		 DELETE D FROM  DIY_Reprocess_log D WHERE DP_HOLDING =0 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
		  DELETE D FROM  DIY_Reprocess_log D WHERE Sell_shortage =0 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 

		 select * into #diy from DIY_Reprocess_log
		  WHERE SETT_NO= @sett_no AND PROCESS_FLAG=0  

			--SELECT * FROM citrus_usr.DIY_Reprocess_log WHERE   SETT_NO= @sett_no AND PROCESS_FLAG=0 
			--AND POA_FLAG ='' AND DP_HOLDING >0  AND DP_CONCERN='Y'

			  create index #s on #diy (party_code ,scrip_cd)  
    Declare @sdate datetime
	select @sdate=start_date from [AngelDemat].msajag.dbo.sett_mst where sett_no=@sett_no and sett_type='N' 
   
    select distinct a.party_code as COL1,Symbol,COL24,Initiated_By,Modified_By,DealerID into #temp from   
    INTRANET.ebroking.dbo.tbl_All_tradeFile a inner join #diy b on  
   a.PARTY_CODE=b.party_code   
   and a.Symbol=b.scrip_cd  
   where Sauda_Date between @sdate and  @sdate + ' 23:59' and COL4='Equities' 
   UNION ALL
    select distinct a.party_code as COL1,Symbol,COL24,Initiated_By,Modified_By,DealerID  from   
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
       
  
   SELECT D.PARTY_CODE,SCRIP_CD,SELL_SHORTAGE,DP_HOLDING,adj_qty, POA_FLAG,Initiated_By, ORDER_TYPE into #fina1 
    FROM #diy D 
    ----WHERE  	Initiated_By is null

	select f.*,cl_type into #f from #fina1 f,[AngelNseCM].msajag.dbo.client_details m
	where f.party_Code=m.cl_code  
	
	--select * from #f where cl_type ='cli' and Initiated_By in ('aemobile','AngelEye')


	--select * from DIY_Reprocess_log d where sett_no =@sett_no and Exists (select party_code from #f f where cl_type ='cli' 
	--and (Initiated_By in ('aemobile','AngelEye') or Initiated_By is null)
	--and f.party_code=d.PARTY_CODE and f.SCRIP_CD=d.SCRIP_CD) 

	--drop table #FinalTable


		  Select DP_ID pa_login_name,(select srNo from tbl_ProcessSRNo) pa_slip_no,'3' As pa_excm_id,  
		 (Case when SETT_TYPE='N' then 11  
       When SETT_TYPE='W' then 13 END ) AS pa_tr_setm_type,  
		 'A|*~|'+ISIN+'|*~|'+convert(varchar(10),
		 (ADJ_QTY))+'|*~|*|~*'  pa_values,  
		SETT_NO pa_settlm_no,  
		'1203320006951435' As pa_tr_acct_no  ,isin 
		  Into #FinalTable   
		  from 
		   DIY_Reprocess_log d where sett_no =@sett_no and 
		    Exists (select party_code from #f f where cl_type ='cli' and (Initiated_By in ('aemobile','AngelEye','Admin') or Initiated_By is null)
	and f.party_code=d.PARTY_CODE and f.SCRIP_CD=d.SCRIP_CD) and POA_FLAG='' and PROCESS_FLAG='0'
	and ADJ_QTY >0
    
 

		 Alter table #FinalTable Add ID int Identity(1,1) primary key   

		 CREATE INDEX #F ON #FinalTable (ID)

		 --select * from #FinalTable


  
		declare @count int;  
		Declare @counter int=1,@totalcount int,@p26 varchar(100), @pa_login_name varchar(50),@pa_slip_no varchar(50),@pa_excm_id varchar(10), 
		@pa_values varchar(50),@pa_settlm_no varchar(50),@executionndate datetime,@pa_tr_setm_type varchar(10),@pa_tr_acct_no varchar(20),
		@isin varchar(15);  
     
			set @executionndate=  convert(varchar(11),getdate(),120)  
   
		 Select @totalcount= count(*) from #FinalTable  
  
		 While(@counter<=@totalcount)  
  
		 Begin  
		 select  @pa_login_name= pa_login_name,@pa_slip_no='E'+convert(varchar(100),(pa_slip_no+@counter)),@pa_excm_id=pa_excm_id,@pa_values=pa_values,  
		 @pa_settlm_no=pa_settlm_no,@pa_tr_setm_type=pa_tr_setm_type,@pa_tr_acct_no=pa_tr_acct_no,@isin=isin from #FinalTable where ID=@counter  
  
		--set @p26='INE008A01015|*~|IDBI-EQ (E|*~|87181|*~|1450.000|*~|*|~*'   
		exec pr_ins_upd_trx_cdsl_sp_EBulk @pa_id='0',@pa_tab='BOCM',@pa_action='INS',@pa_login_name=@pa_login_name,  
		@pa_dpm_dpid='12033200',@pa_dpam_acct_no=@pa_login_name,@pa_slip_no=@pa_slip_no,@pa_mkt_type=@pa_tr_setm_type,  
		@pa_settlm_no=@pa_settlm_no,@pa_req_dt=@executionndate,@pa_cm_id='0',@pa_excm_id=@pa_excm_id,@pa_cash_trf='NA',@pa_exe_dt=@executionndate,  
		@pa_tr_cmbpid='',@pa_tr_dp_id='12033200',@pa_tr_setm_type=@pa_tr_setm_type,@pa_tr_setm_no=@pa_settlm_no,@pa_tr_acct_no=@pa_tr_acct_no,@pa_values=@pa_values,  
		@pa_rmks='',@pa_trdReasoncd=0,@pa_Paymode=null,@pa_Bankacno=null,@pa_Bankacname=null,@pa_Bankbrname=null,@pa_Transfereename=null,@pa_DOI =null,  
		@pa_ChqRefno=null,@pa_chk_yn=1,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p26 output  
  
		--select @p26  
  



		set @counter=@counter+1  
  
		End  

	 
		 update d set PROCESS_FLAG=1 from #FinalTable (nolock) f, DIY_Reprocess_log (nolock) d where DP_ID= pa_login_name and d.isin =f.ISIN 
		 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
		-- and   exists (select * from #fina f where  d.PARTY_CODE=f.PARTY_CODE and d.SCRIP_CD=f.SCRIP_CD)
 

		update DIY_Reprocess_log set PROCESS_FLAG=2  where  SETT_NO= @sett_no AND PROCESS_FLAG=0 

		update tbl_ProcessSRNo set SRNO = SRNO+(select count(*) from #FinalTable)  

		declare @cnt1 int
		select @cnt1 =count(*) from  #FinalTable
  
		select 'Process completed sucessfully :' +convert(varchar(10),@cnt1 )  As MSG  
  
	End  
  
 If @flag ='S'
     Begin 
	 select *,sr_no=row_number() over(order by process_date) from (
	   Select distinct sett_no,process_date 
	   from DIY_Reprocess_log  with (nolock) where sett_no =@sett_no )a 
	    ORDER BY  process_date 
	 End 

 If @flag ='D'
     Begin 

	   Select * 
	   from DIY_Reprocess_log  with (nolock)   where sett_no =@sett_no AND DP_ID <>'' 

	 End

GO
