-- Object: PROCEDURE citrus_usr.E_DIS_Slip_gen_Process_MTF
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




---E_DIS_Slip_gen_Process '2020125','R'

CREATE proc [citrus_usr].[E_DIS_Slip_gen_Process_MTF] (@sett_no varchar(11) ,@flag varchar(1)='')
as 


		Create table #DIY_Reprocess_log
		(sett_no varchar(11),sett_type VARCHAR(2),PARTY_CODE VARCHAR(15),SHORT_NAME VARCHAR(200),BRANCH_CD VARCHAR(20),SUB_BROKER VARCHAR(20)
		,SCRIP_CD VARCHAR(15),CERTNO VARCHAR(20),	DELQTY INT,	RECQTY INT,	ISETTQTYPRINT INT,	ISETTQTYMARK INT,
			IBENQTYPRINT INT,	IBENQTYMARK INT,	HOLD INT,	PLEDGE  INT,	BSEHOLD	INT , BSEPLEDGE	INT ,CL_TYPE VARCHAR(15),	COLLATERAL INT
			)
			 
	


		INSERT  INTO #DIY_Reprocess_log
		---Exec [ANGELDEMAT].msajag.dbo.Rpt_ShortagePayin 'broker','broker','2020018','2020018','N','%',-1
		Exec [ANGELDEMAT].msajag.dbo.Rpt_DelPayinMatch 'broker', 'broker', @sett_no,'N','ALL','%',2

		INSERT  INTO #DIY_Reprocess_log
		--Exec [ANGELDEMAT].msajag.dbo.Rpt_ShortagePayin 'broker','broker',@sett_no,@sett_no,'W','%',-1
		Exec [ANGELDEMAT].msajag.dbo.Rpt_DelPayinMatch 'broker', 'broker', @sett_no,'W','ALL','%',2


		select party_code,certno,sum(qty) as qty into #hld from [ANGELDEMAT].msajag.dbo.deltrans 
		where bcltdpid in ('1203320030135814',
			'1203320030135829') and trtype ='904' and drcr='D' and delivered='0' and filler2=1
			group by party_code,certno

			update d set COLLATERAL=(case when COLLATERAL-qty >=0 then COLLATERAL-qty else 0 end)
			 from #DIY_Reprocess_log d,#hld h
			where d.PARTY_CODE= h.party_code and d.CERTNO =h.certno 


 		DECLARE @CNT INT
		SELECT @CNT =ISNULL(MAX(NO_CNT),0) FROM DIY_Reprocess_log_e_dis WHERE SETT_NO=@sett_no 
	--	print @cnt
		Declare @sdate datetime
		select @sdate=start_date from [ANGELDEMAT].msajag.dbo.sett_mst where sett_no=@sett_no and sett_type='N'

		 insert into DIY_Reprocess_log_e_dis_hst
		 select * from DIY_Reprocess_log_e_dis 
		 truncate table DIY_Reprocess_log_e_dis 
		 

		
		 INSERT INTO  DIY_Reprocess_log_e_dis  
		 SELECT sett_no,sett_type,PARTY_CODE,SCRIP_CD,'',SELLtradeqty=0,sellRECQTY=0,
		 Sell_shortage =(case when DelQty  -  RecQty -  ISettQtyPrint -  IBenQtyPrint-COLLATERAL>0 
		 then DelQty  -  RecQty -  ISettQtyPrint -  IBenQtyPrint-COLLATERAL
		 else 0 end)
		 ,DP_ID='',ISIN=CERTNO,PROCESS_DATE=GETDATE(),0,'',0,'N',@CNT+1,ADJ_QTY=0  
		 FROM #DIY_Reprocess_log D
		 where exists (select party_code from E_Dis_Trxn_Data t where party_code =t.Partycode and d.CERTNO=t.isin and getdate() between Request_date
		  and Request_date+ NO_of_days + ' 23:59' AND ISNULL(VALID,0)=0 and isnull(dummy3,'')='')

		  delete from DIY_Reprocess_log_e_dis where Sell_shortage=0

		    
		UPDATE D SET DP_ID = Cltdpid FROM DIY_Reprocess_log_e_dis D,[ANGELDEMAT].MSAJAG.DBO.CLIENT4 C  
		WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		AND SETT_NO= @sett_no AND PROCESS_FLAG=0
 

			select client_code into #clt   FROM  DIY_Reprocess_log_e_dis D (nolock),TBL_CLIENT_POA P  (nolock)
		    WHERE DP_ID=CLIENT_CODE   
			AND MASTER_POA ='2203320000000014' AND POA_STATUS ='A'   AND SETT_NO= @sett_no AND PROCESS_FLAG=0 

			delete DIY_Reprocess_log_e_dis where DP_ID in (select * from #clt )


 /*
 

			UPDATE D   
		   SET   
		   DP_HOLDING =HLD_AC_POS  
		   FROM  
			DIY_Reprocess_log_e_dis d (nolock)   ,HoldingData h   (nolock) 
		   WHERE 
			DP_ID =HLD_AC_CODE    AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
		   AND ISIN =HLD_ISIN_CODE     
		 */
   --select * from DIY_Reprocess_log_e_dis


   UPDATE D   
		   SET   
		   DP_HOLDING =qty  
		   FROM  
			DIY_Reprocess_log_e_dis d (nolock)   ,MTF_NONpoa h   (nolock) 
		   WHERE 
			DP_ID =dpid    AND SETT_NO= '2020180' AND PROCESS_FLAG=0 
		   AND d.ISIN =h.isin     
   

			UPDATE D SET  ADJ_QTY =(CASE WHEN Sell_shortage >DP_HOLDING THEN DP_HOLDING ELSE Sell_shortage END)
		   FROM  DIY_Reprocess_log_e_dis  D 
		   WHERE SETT_NO= @sett_no AND PROCESS_FLAG=0 

		 DELETE D FROM  DIY_Reprocess_log_e_dis D WHERE DP_HOLDING =0 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 

	     Exec Edis_trxn_process @sdate

			-- select * from E_Dis_Trxn_Data where dummy2=0
		 insert into E_DIS_Process_Data
		 select partycode,boid,n.isin,ALLOCATE_QTY as qty,ANGEL_TRXN_ID,	CDSL_TRXN_Id,	
		 Request_date,sett_no,sett_type ,process_status=0,process_date=getdate(),0
		 from HOLD_REP_N n, DIY_Reprocess_log_e_dis t
	   where t.Party_code =n.Partycode and t.isin=n.isin  and sett_no =@sett_no--and partycode='A133377'


	   --select * from HOLD_REP_N

	        update t set Ex_qty =isnull(Ex_qty,0)+ALLOCATE_QTY
		 FROM E_Dis_Trxn_Data t ,HOLD_REP_N n
		 where  t.Partycode =n.Partycode and t.isin=n.isin and t.CDSL_TRXN_Id=n.CDSL_TRXN_Id
		 and  t.ANGEL_TRXN_ID =n.ANGEL_TRXN_ID AND ISNULL(VALID,0)=0


		  update t set VALID =(case when t.qty <>ex_qty then '0' else '1' end),Pend_qty=T.qty-ex_qty
		 FROM E_Dis_Trxn_Data t ,HOLD_REP_N n
		 where  t.Partycode =n.Partycode and t.isin=n.isin and t.CDSL_TRXN_Id=n.CDSL_TRXN_Id
		 and  t.ANGEL_TRXN_ID =n.ANGEL_TRXN_ID AND ISNULL(VALID,0)=0

	
		

		  Select boid pa_login_name,(select srNo from tbl_ProcessSRNo) pa_slip_no,'3' As pa_excm_id,  
		 (Case when SETT_TYPE='N' then 11  
       When SETT_TYPE='W' then 13 END ) AS pa_tr_setm_type,  
		 'A|*~|'+ISIN+'|*~|'+convert(varchar(10),
		 (Qty))+'|*~|*|~*'  pa_values,  
		SETT_NO pa_settlm_no,  
		'1203320006951435' As pa_tr_acct_no  ,isin ,ANGEL_TRXN_ID,	CDSL_TRXN_Id
		  Into #FinalTable   
		  from 
		   E_DIS_Process_Data  
		 where SETT_NO= @sett_no AND process_status=0  
		 --and ADJ_QTY<>475
		---- AND SETT_TYPE ='W'
   
 

		 Alter table #FinalTable Add ID int Identity(1,1) primary key   

		 CREATE INDEX #F ON #FinalTable (ID)

		 --select * from #FinalTable

		  UPDATE #FinalTable SET pa_slip_no =pa_slip_no +ID
  
		declare @count int;  
		Declare @counter int=1,@totalcount int,@p26 varchar(100), @pa_login_name varchar(50),@pa_slip_no varchar(50),@pa_excm_id varchar(10), 
		@pa_values varchar(50),@pa_settlm_no varchar(50),@executionndate datetime,@pa_tr_setm_type varchar(10),@pa_tr_acct_no varchar(20),
		@isin varchar(15);  
     
			set @executionndate=  convert(varchar(11),getdate(),120)  
   
		 Select @totalcount= count(*) from #FinalTable  
  
		 While(@counter<=@totalcount)  
  
		 Begin  
		 select  @pa_login_name= pa_login_name,@pa_slip_no='E'+convert(varchar(100),(pa_slip_no)),@pa_excm_id=pa_excm_id,@pa_values=pa_values,  
		 @pa_settlm_no=pa_settlm_no,@pa_tr_setm_type=pa_tr_setm_type,@pa_tr_acct_no=pa_tr_acct_no,@isin=isin from #FinalTable where ID=@counter  
  
		--set @p26='INE008A01015|*~|IDBI-EQ (E|*~|87181|*~|1450.000|*~|*|~*'   
		exec pr_ins_upd_trx_cdsl_sp_PreEDIS @pa_id='0',@pa_tab='BOCM',@pa_action='INS',@pa_login_name=@pa_login_name,  
		@pa_dpm_dpid='12033200',@pa_dpam_acct_no=@pa_login_name,@pa_slip_no=@pa_slip_no,@pa_mkt_type=@pa_tr_setm_type,  
		@pa_settlm_no=@pa_settlm_no,@pa_req_dt=@executionndate,@pa_cm_id='0',@pa_excm_id=@pa_excm_id,@pa_cash_trf='NA',@pa_exe_dt=@executionndate,  
		@pa_tr_cmbpid='',@pa_tr_dp_id='12033200',@pa_tr_setm_type=@pa_tr_setm_type,@pa_tr_setm_no=@pa_settlm_no,@pa_tr_acct_no=@pa_tr_acct_no,@pa_values=@pa_values,  
		@pa_rmks='',@pa_trdReasoncd=0,@pa_Paymode=null,@pa_Bankacno=null,@pa_Bankacname=null,@pa_Bankbrname=null,@pa_Transfereename=null,@pa_DOI =null,  
		@pa_ChqRefno=null,@pa_chk_yn=1,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p26 output  
  
		--select @p26  
  
  		 
		set @counter=@counter+1  
  
		End 


		update d set slip_no='E'+convert(varchar(100),(pa_slip_no)),process_status=1 from #FinalTable (nolock) f, E_DIS_Process_Data (nolock) d where boid= pa_login_name and d.isin =f.ISIN 
		 AND SETT_NO= pa_settlm_no AND process_status=0  and f.ANGEL_TRXN_ID =d.ANGEL_TRXN_ID and	d.CDSL_TRXN_Id=f.CDSL_TRXN_Id
		 and sett_no=@pa_settlm_no


		EXEC PR_CDSL_PRETRADE_EDIS_RESPONSE_ANGEL '',''


		update tbl_ProcessSRNo set SRNO = SRNO+(select count(*) from #FinalTable)  


		Declare @cnt1 int

		select @cnt1=count(*) from #FinalTable
  
		select 'Process completed For : '+ convert(varchar(15) ,@cnt1) As MSG

GO
