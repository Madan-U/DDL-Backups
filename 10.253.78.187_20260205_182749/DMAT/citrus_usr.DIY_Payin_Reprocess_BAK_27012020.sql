-- Object: PROCEDURE citrus_usr.DIY_Payin_Reprocess_BAK_27012020
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



---DIY_Payin_Reprocess '2019235','R'

CREATE proc [citrus_usr].[DIY_Payin_Reprocess_BAK_27012020] (@sett_no varchar(11) ,@flag varchar(1))
as 

If @flag ='R'
 
 Begin 
		Create table #DIY_Reprocess_log
		(sett_no varchar(11),sett_type VARCHAR(2),PARTY_CODE VARCHAR(15),SHORT_NAME VARCHAR(200),SCRIP_CD VARCHAR(15),
		SERIES VARCHAR(10),buytradeqty INT,BUYRECQTY INT, SELLtradeqty INT ,sellRECQTY INT ,
		buy_shortage INT,Sell_shortage INT,cl_rate money,flag varchar(2),ISIN VARCHAR(15),
		CL_TYPE VARCHAR(15))


		INSERT  INTO #DIY_Reprocess_log
		Exec [196.1.115.197].msajag.dbo.Rpt_ShortagePayin 'broker','broker',@sett_no,@sett_no,'N','%',-1

		INSERT  INTO #DIY_Reprocess_log
		Exec [196.1.115.197].msajag.dbo.Rpt_ShortagePayin 'broker','broker',@sett_no,@sett_no,'W','%',-1

 		DECLARE @CNT INT
		SELECT @CNT =ISNULL(MAX(NO_CNT),0) FROM DIY_Reprocess_log WHERE SETT_NO=@sett_no 

		 INSERT INTO DIY_Reprocess_log  
		 SELECT sett_no,sett_type,PARTY_CODE,SCRIP_CD,SERIES,SELLtradeqty,sellRECQTY,Sell_shortage,DP_ID='',ISIN,PROCESS_DATE=GETDATE(),0,'',0,'N',@CNT+1,ADJ_QTY=0
		 FROM #DIY_Reprocess_log

		UPDATE D SET DP_ID = Cltdpid FROM DIY_Reprocess_log D,[196.1.115.197].MSAJAG.DBO.CLIENT4 C  
		WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		AND SETT_NO= @sett_no AND PROCESS_FLAG=0
      

	   
  
		  UPDATE D SET DP_ID = Cltdpid FROM citrus_usr.DIY_Reprocess_log D,[196.1.115.197].BSEDB.DBO.CLIENT4 C  
		  WHERE D.PARTY_CODE = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
		   AND SETT_NO= @sett_no AND PROCESS_FLAG=0 AND LEN(ISNULL(DP_ID,''))<16  

		  UPDATE  D SET POA_FLAG ='1'   FROM  citrus_usr.DIY_Reprocess_log D,TBL_CLIENT_POA P  
		   WHERE DP_ID=CLIENT_CODE   
			AND MASTER_POA ='2203320000000014' AND POA_STATUS ='A'   AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
      
 

			UPDATE D   
		   SET   
		   DP_HOLDING =HLD_AC_POS  
		   FROM  
			DIY_Reprocess_log d ,HoldingData h  
		   WHERE 
			DP_ID =HLD_AC_CODE    AND SETT_NO= @sett_no AND PROCESS_FLAG=0 
		   AND ISIN =HLD_ISIN_CODE     
   
   
			DECLARE @STDATE DATETIME ,@PREVDATE DATETIME
   
		   SELECT @STDATE = MAX(START_DATE) FROM [196.1.115.197].MSAJAG.DBO.SETT_MST WITH(NOLOCK) WHERE SETT_NO =@sett_no  AND SETT_TYPE ='N'

		   SELECT @PREVDATE = MAX(START_DATE) FROM [196.1.115.197].MSAJAG.DBO.SETT_MST WITH(NOLOCK) WHERE START_DATE <@STDATE AND SETT_TYPE ='N'

			SELECT DISTINCT PARTYCODE,ISIN INTO #PARTY 
			FROM  
			[172.31.16.75].Angel_WMS.DBO.po_acceptance_status a  
			WHERE date_time_stamp >= @PREVDATE +' 16:00:00.000' AND date_time_stamp<= @STDATE +' 23:59'
			--AND CreationDate <=CONVERT(VARCHAR(11),@date,120) +' 23:59' AND   
		   AND ACTION ='SELL'   and  isnull(convert(float, replace(Quantity,',','')),0) <>0 
			and  ISNULL(SYMBOL,'') <> '' AND ISNULL( ISIN,'')  <>'' --AND LEN(DPID)=16  
  
		   UPDATE D SET DP_CONCERN ='Y'  
		   FROM  citrus_usr.DIY_Reprocess_log  D,#PARTY P
		   WHERE PARTYCODE=PARTY_CODE AND D.ISIN =P.ISIN AND SETT_NO= @sett_no AND PROCESS_FLAG=0 

			UPDATE D SET  ADJ_QTY =(CASE WHEN Sell_shortage >DP_HOLDING THEN DP_HOLDING ELSE Sell_shortage END)
		   FROM  DIY_Reprocess_log  D 
		   WHERE SETT_NO= @sett_no AND PROCESS_FLAG=0 



		 DELETE D FROM  DIY_Reprocess_log D WHERE DP_HOLDING =0 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 


			--SELECT * FROM citrus_usr.DIY_Reprocess_log WHERE   SETT_NO= @sett_no AND PROCESS_FLAG=0 
			--AND POA_FLAG ='' AND DP_HOLDING >0  AND DP_CONCERN='Y'

		  Select DP_ID pa_login_name,(select srNo from tbl_ProcessSRNo) pa_slip_no,'3' As pa_excm_id,  
		 (Case when SETT_TYPE='N' then 11  
       When SETT_TYPE='W' then 13 END ) AS pa_tr_setm_type,  
		 'A|*~|'+ISIN+'|*~|'+convert(varchar(10),
		 (ADJ_QTY))+'|*~|*|~*'  pa_values,  
		SETT_NO pa_settlm_no,  
		'1203320006951435' As pa_tr_acct_no  ,isin 
		  Into #FinalTable   
		  from 
		   DIY_Reprocess_log  
		 where SETT_NO= @sett_no AND PROCESS_FLAG=0  AND  POA_FLAG  =''  AND  DP_CONCERN='Y' AND ADJ_QTY >0
		 --and ADJ_QTY<>475
		---- AND SETT_TYPE ='W'
    
 

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
		exec pr_ins_upd_trx_cdsl_sp @pa_id='0',@pa_tab='BOCM',@pa_action='INS',@pa_login_name=@pa_login_name,  
		@pa_dpm_dpid='12033200',@pa_dpam_acct_no=@pa_login_name,@pa_slip_no=@pa_slip_no,@pa_mkt_type=@pa_tr_setm_type,  
		@pa_settlm_no=@pa_settlm_no,@pa_req_dt=@executionndate,@pa_cm_id='0',@pa_excm_id=@pa_excm_id,@pa_cash_trf='NA',@pa_exe_dt=@executionndate,  
		@pa_tr_cmbpid='',@pa_tr_dp_id='12033200',@pa_tr_setm_type=@pa_tr_setm_type,@pa_tr_setm_no=@pa_settlm_no,@pa_tr_acct_no=@pa_tr_acct_no,@pa_values=@pa_values,  
		@pa_rmks='',@pa_trdReasoncd=0,@pa_Paymode=null,@pa_Bankacno=null,@pa_Bankacname=null,@pa_Bankbrname=null,@pa_Transfereename=null,@pa_DOI =null,  
		@pa_ChqRefno=null,@pa_chk_yn=1,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p26 output  
  
		--select @p26  
  
		update DIY_Reprocess_log set PROCESS_FLAG=1  where DP_ID= @pa_login_name and isin =@isin 
		 AND SETT_NO= @sett_no AND PROCESS_FLAG=0 


		set @counter=@counter+1  
  
		End  

		update DIY_Reprocess_log set PROCESS_FLAG=2  where  SETT_NO= @sett_no AND PROCESS_FLAG=0 

		update tbl_ProcessSRNo set SRNO = SRNO+(select count(*) from #FinalTable)  
  
		select 'Process completed sucessfully' As MSG  
  
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
