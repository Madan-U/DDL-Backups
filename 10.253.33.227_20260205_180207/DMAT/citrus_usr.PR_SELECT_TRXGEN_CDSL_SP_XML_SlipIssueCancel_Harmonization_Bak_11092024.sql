-- Object: PROCEDURE citrus_usr.PR_SELECT_TRXGEN_CDSL_SP_XML_SlipIssueCancel_Harmonization_Bak_11092024
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------







CREATE  PROCEDURE [citrus_usr].[PR_SELECT_TRXGEN_CDSL_SP_XML_SlipIssueCancel_Harmonization_Bak_11092024]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(2),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20),  
@PA_POOL_ACCTNO VARCHAR(100),
@PA_BROKER_YN CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20),  
@PA_OUTPUT VARCHAR(20) OUTPUT  
)  
AS  
BEGIN 


declare @l_dpm_id numeric
select  @l_dpm_id  = dpm_id from dp_mstr where dpm_excsm_id = @PA_EXCSM_ID  and dpm_excsm_id = default_dp and dpm_deleted_ind = 1 

DECLARE  @SLIIM TABLE (PA_SLIIM_ID INT)

DECLARE @@RM_ID              VARCHAR(8000)                    
      , @@CUR_ID             VARCHAR(8000)                    
      , @@FOUNDAT            INT                    
      , @@DELIMETERLENGTH    INT                   
      , @@DELIMETER          CHAR(1)               
      , @C_CRN_NO            NUMERIC                     
      , @C_DPAM_ID           NUMERIC                                                                   
      , @C_ACCT_NO           VARCHAR(25)                                                                     
      , @C_SBA_NO            VARCHAR(20)          
      , @L_CRN_NO            NUMERIC                  
      , @L_ACCT_NO           VARCHAR(25)                    
      , @L_VALUE             VARCHAR(8000)                  
      , @L_CLIENT_TYPE       VARCHAR(100)                  
      , @L_CHK               NUMERIC                  
      , @L_CTGRY_CHK         NUMERIC  
      
IF ISNULL(@PA_TRX_TAB, '') <> ''                  
    BEGIN--n_n                  
    --                  
      SET @@rm_id  =  @PA_TRX_TAB                  
      --                  
      --                  
      WHILE @@rm_id <> ''                    
      BEGIN--w_id                    
      --                    
        SET @@foundat = 0                    
        SET @@foundat =  PATINDEX('%*|~*%',@@rm_id)                    
        --                  
        IF @@foundat > 0                    
        BEGIN                    
        --                    
          SET @@cur_id  = SUBSTRING(@@rm_id, 0,@@foundat)                    
          SET @@rm_id   = SUBSTRING(@@rm_id, @@foundat+4,LEN(@@rm_id)- @@foundat+4)                    
        --                    
        END                    
        ELSE                    
        BEGIN                    
        --                    
          SET @@cur_id      = @@rm_id                    
          SET @@rm_id = ''                    
        --                    
        END                  
        --                  
        IF @@cur_id <> ''                  
        BEGIN                  
        --                  
          SET @l_crn_no  = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@cur_id,1))                  
                       
          --                   
          INSERT INTO @sliim                   
          SELECT @l_crn_no                  
         --                  
        --                  
        END                  
      --                    
      END                  
      --      
 end   
      -- 


IF @PA_POOL_ACCTNO = 'SLIPISSUECANN'  
BEGIN  
	IF @PA_BATCH_TYPE = 'I'  
	BEGIN 
	 
		if @PA_TRX_TAB='' 
		begin
		select T.* into #HarmoTempA  from (
		Select '<Tp>39</Tp>'
		+ '<Distxn>1</Distxn>'
		+ '<Dpstry>1</Dpstry>'
		+ '<Issenty>B</Issenty>'
		+ '<Bnfcry>'+SLIIM_DPAM_ACCT_NO+'</Bnfcry>'
		+ '<Disalpa>'+convert(varchar(4),SLIIM_SERIES_TYPE)+'</Disalpa>'
		+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_FR)),12,0,'L','0'))    +'</Disfrm>'
		+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_TO)),12,0,'L','0'))    +'</Disto>'
		+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),((convert(numeric,SLIIM_SLIP_NO_TO)-convert(numeric,SLIIM_SLIP_NO_FR)+1))),3,0,'L','0') )+'</Dislvs>'
		--+'<Bkltno>'+convert(varchar(16),SLIIM_SLIP_NO_TO)+'</Bkltno>' --citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'','')
		+'<Bkltno>'+isnull(citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'',''),'')+'</Bkltno>' 
		+'<Isncflg>'+convert(varchar(1),'Y')+'</Isncflg>'
		+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
		--+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'L' else 'N' end) +'</Isncdt>'
		+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),citrus_usr.Fn_toSliptype(sliim_slip_no_to,'',SLIIM_DPAM_ACCT_NO)) ='1' then 'L' else 'N' end) +'</Isnctyp>'
		+'<Discncl></Discncl>'
		+'<Intby>'+'1'+'</Intby>'
		+'<Remk></Remk>' 
		+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/','')) +'</Rcvdt>'
		details , sliim_lst_upd_dt , sliim_id 
		FROM  slip_issue_mstr
		where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
		and not exists (select slibd_sliim_id from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 
		--and slibd_batch_no = @PA_BATCH_NO 
		and slibd_entity_type=@PA_BROKER_YN)
	and sliim_dt   BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
	AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'  
		and len(SLIIM_DPAM_ACCT_NO)=16 and @PA_BROKER_YN='B'
		--and exists (select boid from tslip07012016 where SLIIM_DPAM_ACCT_NO=boid and [from slip no]=SLIIM_SLIP_NO_FR and [to slip no]=SLIIM_SLIP_NO_TO)
		union all 
		Select '<Tp>39</Tp>'
		+ '<Distxn>1</Distxn>'
		+ '<Dpstry>1</Dpstry>'
		+ '<Issenty>P</Issenty>'
		+ '<Bnfcry>'+SLIIM_DPAM_ACCT_NO+'</Bnfcry>'
		+ '<Disalpa>'+convert(varchar(4),SLIIM_SERIES_TYPE)+'</Disalpa>'
		+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_FR)),12,0,'L','0'))    +'</Disfrm>'
		+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_TO)),12,0,'L','0'))    +'</Disto>'
		+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),((convert(numeric,SLIIM_SLIP_NO_TO)-convert(numeric,SLIIM_SLIP_NO_FR)+1))),3,0,'L','0') )+'</Dislvs>'
		--+'<Bkltno>'+convert(varchar(16),SLIIM_SLIP_NO_TO )+'</Bkltno>' --citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'P','')
		+'<Bkltno>'+isnull(citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'',''),'')+'</Bkltno>' 
		+'<Isncflg>'+convert(varchar(1),'Y')+'</Isncflg>'
		+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
		--+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'L' else 'N' end) +'</Isncdt>'
		+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),citrus_usr.Fn_toSliptype(sliim_slip_no_to,'P',SLIIM_DPAM_ACCT_NO)) ='1' then 'L' else 'N' end)+'</Isnctyp>'
		+'<Discncl></Discncl>'
		+'<Intby>1</Intby>'
		+'<Remk></Remk>'
		+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/','')) +'</Rcvdt>'
		 details, sliim_lst_upd_dt , sliim_id
		FROM  slip_issue_mstr_poa
		where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
		and not exists (select slibd_sliim_id from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 
		--and slibd_batch_no = @PA_BATCH_NO 
		and slibd_entity_type=@PA_BROKER_YN)
	and sliim_dt   BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
	AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'  		and len(SLIIM_DPAM_ACCT_NO)=16 and @PA_BROKER_YN='P'
		) T

		insert into sliim_batch_dtls (slibd_sliim_id
										,slibd_batch_no
										,slibd_created_by
										,slibd_created_dt
										,slibd_lst_upd_by 
										,slibd_lst_upd_dt
										,slibd_deleted_ind,slibd_entity_type,slibd_DIS_type)
		select  sliim_id ,@PA_BATCH_NO,@PA_LOGINNAME,getdate(),@PA_LOGINNAME,getdate(),1,@PA_BROKER_YN,'I' from slip_issue_mstr
		where	sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end --@L_DPM_ID -- change on feb 23 2015 to get batch for all selected records
		and  sliim_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
        AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
       -- and exists (select boid from tslip07012016 where SLIIM_DPAM_ACCT_NO=boid and [from slip no]=SLIIM_SLIP_NO_FR and [to slip no]=SLIIM_SLIP_NO_TO)
        union all
		select  sliim_id ,@PA_BATCH_NO,@PA_LOGINNAME,getdate(),@PA_LOGINNAME,getdate(),1,@PA_BROKER_YN,'I' from slip_issue_mstr_poa
		where	sliim_dpm_id   =  case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end ----@L_DPM_ID -- change on feb 23 2015 to get batch for all selected records
	and sliim_dt   BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
	AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'  		
		update bitmap_ref_mstr set bitrm_values=bitrm_values+1 where bitrm_parent_cd='DISC_BTCH_CLT_CURNO' and bitrm_deleted_ind=1
	 


		 
		Select cast(details as xml) xmlField,IDENTITY(int,1,1) ID,sliim_lst_upd_dt Rcvdt , sliim_id into Tmp from (
		Select * from #HarmoTempA ) tb 

		 --select * from Tmp 

		  
	

		Select distinct
		'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
		as Detailshar
		union all
		select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '000000' + ',' + ',' + 'DMU'	  + ' ,' + isnull(convert(varchar,ID),'') + ',' + '' + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') + ',' + '' + ',' +  + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 1, 2)  + ',' + ''  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ 
		--SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4)   
		convert(varchar(19),convert(datetime,SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2)),126)
		+','+ 'DIS Issued' + ',' + '' +','+'' +','+ '' +','+''+','+''+','+','+','+','+','+','+','+','+','+','+','+ '' +','+','+','+','+','+','+  + ','+ 
		SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 1, 2)
		+',' + isnull(convert(varchar,xmlField.value('(Disalpa)[1]', 'nvarchar(max)')),'') + ','+','+ 'NRM' +','+ ','+case when  left(isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') ,2) ='12' then 'BO' when left(isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') ,2) ='22' then 'POA' else '' end  +',' + isnull(convert(varchar,xmlField.value('(Disfrm)[1]', 'nvarchar(max)')),'') + ' ,' + isnull(convert(varchar,xmlField.value('(Disto)[1]', 'nvarchar(max)')),'') + ',' + 'NR' + ','+ 'DIS' + ','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+ '' +','+ isnull(convert(varchar,xmlField.value('(Dislvs)[1]', 'nvarchar(max)')),'') +','+','+',' + ','+ + ','+ convert(varchar(100),sliim_id)+'' +','+ '' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+'DP'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ 'DISI' + ',' +  +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+''+','+','+ ',' +'' + ','+','+','+','+''+','+','+','+','+','+'' +','+','+','+','+','+','+','+','+'DFT'+','+','+','+','
		as Detailshar
		FROM Tmp

		
		drop table Tmp
		drop table #HarmoTempA 
		


		end
		
		
		
	
		if @PA_TRX_TAB<>'' 
		begin
		--print '@PA_TRX_TAB is not blank'
		
		select T.* into #HarmoTempS  from (
		Select '<Tp>39</Tp>'
		+ '<Distxn>1</Distxn>'
		+ '<Dpstry>1</Dpstry>'
		+ '<Issenty>B</Issenty>'
		+ '<Bnfcry>'+SLIIM_DPAM_ACCT_NO+'</Bnfcry>'
		+ '<Disalpa>'+convert(varchar(4),SLIIM_SERIES_TYPE)+'</Disalpa>'
		+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_FR)),12,0,'L','0'))    +'</Disfrm>'
		+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_TO)),12,0,'L','0'))    +'</Disto>'
		+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),((convert(numeric,SLIIM_SLIP_NO_TO)-convert(numeric,SLIIM_SLIP_NO_FR)+1))),3,0,'L','0') )+'</Dislvs>'
		--+'<Bkltno>'+convert(varchar(16),SLIIM_SLIP_NO_TO )+'</Bkltno>' --citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'','')
		+'<Bkltno>'+isnull(citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'',''),'')+'</Bkltno>' 
		+'<Isncflg>'+convert(varchar(1),'Y')+'</Isncflg>'
		+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
		--+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'L' else 'N' end) +'</Isncdt>'
		+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),citrus_usr.Fn_toSliptype(sliim_slip_no_to,'',SLIIM_DPAM_ACCT_NO)) ='1' then 'L' else 'N' end) +'</Isnctyp>'
		+'<Discncl></Discncl>'
		+'<Intby>1</Intby>'
		+'<Remk></Remk>' 
		+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/','')) +'</Rcvdt>'
		details , sliim_lst_upd_dt , sliim_id 
		FROM  slip_issue_mstr,@sliim
		where	PA_SLIIM_ID=SLIIM_ID and	sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
		and not exists (select slibd_sliim_id from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID 
		and slibd_deleted_ind = 1 
		--and slibd_batch_no = @PA_BATCH_NO 
		and slibd_entity_type=@PA_BROKER_YN)
		and sliim_dt   BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
		AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'  
		and len(SLIIM_DPAM_ACCT_NO)=16 and @PA_BROKER_YN='B'
		--and exists (select boid from tslip07012016 where SLIIM_DPAM_ACCT_NO=boid and [from slip no]=SLIIM_SLIP_NO_FR and [to slip no]=SLIIM_SLIP_NO_TO)
		union all 
		Select '<Tp>39</Tp>'
		+ '<Distxn>1</Distxn>'
		+ '<Dpstry>1</Dpstry>'
		+ '<Issenty>P</Issenty>'
		+ '<Bnfcry>'+SLIIM_DPAM_ACCT_NO+'</Bnfcry>'
		+ '<Disalpa>'+convert(varchar(4),SLIIM_SERIES_TYPE)+'</Disalpa>'
		+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_FR)),12,0,'L','0'))    +'</Disfrm>'
		+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(SLIIM_SLIP_NO_TO)),12,0,'L','0'))    +'</Disto>'
		+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),((convert(numeric,SLIIM_SLIP_NO_TO)-convert(numeric,SLIIM_SLIP_NO_FR)+1))),3,0,'L','0') )+'</Dislvs>'
		--+'<Bkltno>'+convert(varchar(16),SLIIM_SLIP_NO_TO)+'</Bkltno>' --citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'P','')
		+'<Bkltno>'+isnull(citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'',''),'')+'</Bkltno>' 
		+'<Isncflg>'+convert(varchar(1),'Y')+'</Isncflg>'
		+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
		--+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'L' else 'N' end) +'</Isncdt>'
		+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),citrus_usr.Fn_toSliptype(sliim_slip_no_to,'P',SLIIM_DPAM_ACCT_NO)) ='1' then 'L' else 'N' end)+'</Isnctyp>'
		+'<Discncl></Discncl>'
		+'<Intby>1</Intby>'
		+'<Remk></Remk>' 
		+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/','')) +'</Rcvdt>'
		details, sliim_lst_upd_dt , sliim_id 
		FROM  slip_issue_mstr_poa,@sliim
		where	PA_SLIIM_ID=SLIIM_ID	and	sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
		and not exists (select slibd_sliim_id from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID 
		and slibd_deleted_ind = 1 
		--and slibd_batch_no = @PA_BATCH_NO 
		and slibd_entity_type=@PA_BROKER_YN)
	and sliim_dt   BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
	AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'   
		--and len(SLIIM_DPAM_ACCT_NO)=16 
		and @PA_BROKER_YN='P'
		) T
		
		

		insert into sliim_batch_dtls (slibd_sliim_id
										,slibd_batch_no
										,slibd_created_by
										,slibd_created_dt
										,slibd_lst_upd_by
										,slibd_lst_upd_dt
										,slibd_deleted_ind,slibd_entity_type,slibd_DIS_type)
		select  sliim_id ,@PA_BATCH_NO,@PA_LOGINNAME,getdate(),@PA_LOGINNAME,getdate(),1,@PA_BROKER_YN,'I' from slip_issue_mstr,@sliim
		where	PA_SLIIM_ID=SLIIM_ID and sliim_dpm_id   =  case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end ----@L_DPM_ID -- change on feb 23 2015 to get batch for all selected records--case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and sliim_dt   BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
	AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'   
	--and exists (select boid from tslip07012016 where SLIIM_DPAM_ACCT_NO=boid and [from slip no]=SLIIM_SLIP_NO_FR and [to slip no]=SLIIM_SLIP_NO_TO)
	    union all
		select  sliim_id ,@PA_BATCH_NO,@PA_LOGINNAME,getdate(),@PA_LOGINNAME,getdate(),1,@PA_BROKER_YN,'I' from slip_issue_mstr_poa,@sliim
		where	PA_SLIIM_ID=SLIIM_ID and sliim_dpm_id   =  case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end ----@L_DPM_ID -- change on feb 23 2015 to get batch for all selected records --case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and sliim_dt  BETWEEN  CONVERT(VARCHAR(11),CONVERT(DATETIME, @PA_FROM_DT,103),109)+' 00:00:00' 
	AND CONVERT(VARCHAR(11),CONVERT(DATETIME,@PA_TO_DT,103),109)+' 23:59:59'       	
		
		update bitmap_ref_mstr set bitrm_values=bitrm_values+1 where bitrm_parent_cd='DISC_BTCH_CLT_CURNO' and bitrm_deleted_ind=1
		
		

		Select cast(details as xml) xmlField,IDENTITY(int,1,1) ID,sliim_lst_upd_dt Rcvdt, sliim_id  into Tmp from (
		Select * from #HarmoTempS ) tb 
		order by sliim_id 


		
	 
		Select F.* into #Tmpfinal from (
		Select distinct
		'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
		as Detailshar ,'0' Sliim_id
		union all
		select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '000000' + ',' + ',' + 'DMU'	  + ' ,' + isnull(convert(varchar,ID),'') + ',' + '' + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') + ',' + '' + ',' +  + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 1, 2)  + ',' + ''  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ 
		--SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4)   
		convert(varchar(19),convert(datetime,SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2)),126)
		+','+ 'DIS Issued' + ',' + '' +','+'' +','+ '' +','+''+','+''+','+','+','+','+','+','+','+','+','+','+','+ '' +','+','+','+','+','+','+  + ','+ 
		SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 5, 4) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 1, 2)
		+',' + isnull(convert(varchar,xmlField.value('(Disalpa)[1]', 'nvarchar(max)')),'') + ','+','+ 'NRM' +','+ ','+case when  left(isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') ,2) ='12' then 'BO' when left(isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') ,2) ='22' then 'POA' else '' end  +',' + isnull(convert(varchar,xmlField.value('(Disfrm)[1]', 'nvarchar(max)')),'') + ' ,' + isnull(convert(varchar,xmlField.value('(Disto)[1]', 'nvarchar(max)')),'') + ',' + 'NR' + ','+ 'DIS' + ','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+ '' +','+ isnull(convert(varchar,xmlField.value('(Dislvs)[1]', 'nvarchar(max)')),'') +','+','+',' + ','+ + ','+ convert(varchar(100),sliim_id)+'' +','+ '' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+'DP'+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ 'DISI' + ',' +  +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+''+','+','+ ',' +'' + ','+','+','+','+''+','+','+','+','+','+'' +','+','+','+','+','+','+','+','+'DFT'+','+','+','+','
		as Detailshar , sliim_id
		FROM Tmp
		
		)
		F

		Select Distinct Detailshar from #Tmpfinal  order by Sliim_id
		

		drop table Tmp
		drop table #HarmoTempS
		

		end 
	
	
		
		
		

		
		 

	    END  
	
	end
	--union all 
	--Select '<Tp>39</Tp>'
	--+ '<Distxn>2</Distxn>'
	--+ '<Dpstry>1</Dpstry>'
	--+ '<Issenty>B</Issenty>'
	--+ '<Bnfcry>'+isnull(USES_DPAM_ACCT_NO,'')+'</Bnfcry>'
	--+ '<Disalpa>'+convert(varchar(4),USES_SERIES_TYPE)+'</Disalpa>'
	--+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(USES_SLIP_NO)),12,0,'L','0'))    +'</Disfrm>'
	--+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(USES_SLIP_NO)),12,0,'L','0'))    +'</Disto>'
	--+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs((USES_SLIP_NO-USES_SLIP_NO+1))),3,0,'L','0') )+'</Dislvs>'
	--+'<Bkltno>'+convert(varchar(16),'')+'</Bkltno>'
	--+'<Isncflg>'+case when USES_DPAM_ACCT_NO ='' then 'N' else convert(varchar(1),'Y') end +'</Isncflg>'
	--+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
	--+'<Isncdt>'+convert(varchar(1),case when SLIIM_LOOSE_Y_N ='Y' then 'L' else 'N' end +'</Isncdt>'
	--+'<Isnctyp>'+convert(varchar(1),case when SLIIM_LOOSE_Y_N ='Y' then 'L' else 'N' end +'</Isnctyp>'
	--+'<Discncl>1</Discncl>'
	--+'<Intby>2</Intby>'
	--+'<Remk></Remk>' details, sliim_lst_upd_dt , sliim_id 
	--FROM  used_slip,slip_issue_mstr 
	--where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	--and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO )
	--and sliim_lst_upd_dt  between BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	--and len(SLIIM_DPAM_ACCT_NO)=16
	--and sliim_dpam_acct_no = isnull(USES_DPAM_ACCT_NO,'')
	--and replace(USES_SLIP_NO,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_to
	--order by sliim_lst_upd_dt 


	--insert into sliim_batch_dtls 
	--select sliim_id , @pa_batch_no , 'MIG',getdate(),'MIG',getdate(),1 FROM  slip_issue_mstr
	--where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	--and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1)
	--and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	--and len(SLIIM_DPAM_ACCT_NO)=16
	--order by sliim_lst_upd_dt 


	
		IF @PA_POOL_ACCTNO = 'SLIPCANN'  
		BEGIN 
		IF @PA_BATCH_TYPE = 'C'  
		BEGIN  
             if @PA_TRX_TAB<>'' 
             begin
             
             Select T.* into  #HarmoTempCA from
			 (
					Select '<Tp>39</Tp>'
					+ '<Distxn>2</Distxn>'
					+ '<Dpstry>1</Dpstry>'
					+ '<Issenty>'+case when left(USES_DPAM_ACCT_NO,1)='2' then 'P' else  'B' end +'</Issenty>'
					+ '<Bnfcry>'+isnull(USES_DPAM_ACCT_NO,'')+'</Bnfcry>'
					+ '<Disalpa>'+convert(varchar(4),USES_SERIES_TYPE)+'</Disalpa>'
					+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(USES_SLIP_NO)),12,0,'L','0'))    +'</Disfrm>'
					+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(USES_SLIP_NO_to)),12,0,'L','0'))    +'</Disto>'
					+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),((convert(numeric,USES_SLIP_NO_to)-convert(numeric,USES_SLIP_NO))+1)),3,0,'L','0') )+'</Dislvs>'
					+'<Bkltno>'+convert(varchar(16),ISNULL(used_book_name,'0'))+'</Bkltno>'
					+'<Isncflg>'+case when USES_DPAM_ACCT_NO ='' then 'N' else convert(varchar(1),'Y') end +'</Isncflg>'
					+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),uses_cancellation_dt,103),'/',''))+'</Isncdt>'
					--+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'L' else 'N' end) +'</Isncdt>'
					+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),citrus_usr.Fn_toSliptype(uses_slip_no_to,USED_ENTITY_TYPE,USES_DPAM_ACCT_NO)) ='1' then 'N' else 'N' end) +'</Isnctyp>'
					+'<Discncl>'+case when ISNULL(USES_DIS_CANCELLATION_FLAG,'')='CANCELLATION DUE TO LOST DIS' then '1' when ISNULL(USES_DIS_CANCELLATION_FLAG,'')='CANCELLATION DUE TO MISPLACED DIS' then '2' else '3' end+'</Discncl>'
					+'<Intby>'+case when ISNULL(USES_TRX_INITIATION_FLAG,'')='DP' then '1' else '2' end+'</Intby>'
					+'<Remk>'+isnull(uses_slipremarks,'')+'</Remk>'
					+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),uses_cancellation_dt,103),'/','')) +'</Rcvdt>'
					 details, uses_lst_upd_dt  sliim_lst_upd_dt 
					FROM  used_slip_block, @sliim
					where 
					--uses_id=sliim_id 										
					uses_dpm_id   = @L_DPM_ID --case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
					and not exists (select slibd_sliim_id from sliim_batch_dtls where slibd_sliim_id = uses_ID AND slibd_DIS_type = 'C'
					and slibd_deleted_ind = 1 --and slibd_batch_no = @PA_BATCH_NO  ABD SKUVD
					and slibd_entity_type=@PA_BROKER_YN ) 
					and USES_CANCELLATION_DT  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
					--and len(SLIIM_DPAM_ACCT_NO)=16 
					and PA_SLIIM_ID=uses_ID and USES_DELETED_IND =1					
					and used_entity_type=@PA_BROKER_YN-- need to add filter of column dis type
			) T
					order by sliim_lst_upd_dt 
					


					insert into sliim_batch_dtls (slibd_sliim_id
													,slibd_batch_no
													,slibd_created_by
													,slibd_created_dt
													,slibd_lst_upd_by
													,slibd_lst_upd_dt
													,slibd_deleted_ind,slibd_entity_type,slibd_DIS_type)
					select  uses_id ,@PA_BATCH_NO,@PA_LOGINNAME,getdate(),@PA_LOGINNAME,getdate(),1,@PA_BROKER_YN ,'C'
					FROM  used_slip_block, @sliim
					where 
					--uses_id=sliim_id 										
					uses_dpm_id   = @L_DPM_ID --case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
					and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = uses_ID 
					and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO 
					and slibd_entity_type=@PA_BROKER_YN)
					and USES_CANCELLATION_DT  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
					--and len(SLIIM_DPAM_ACCT_NO)=16 
					and PA_SLIIM_ID=uses_ID 					
					and used_entity_type=@PA_BROKER_YN     	
					
					update bitmap_ref_mstr set bitrm_values=bitrm_values+1 where bitrm_parent_cd='DISC_BTCH_CLT_CURNO' and bitrm_deleted_ind=1

				

		Select cast(details as xml) xmlField,IDENTITY(int,1,1) ID,sliim_lst_upd_dt Rcvdt into Tmp from (
		Select * from #HarmoTempS ) tb 

		--Select * from Tmp

		Select distinct
		'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
		as Detailshar
		union all
		--select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '000000' + ',' + ',' + 'DMU'	  + ' ,' + isnull(convert(varchar,ID),'') + ',' + '' + ',' + substring(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),3,5) + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') + ',' + '' + ',' +  + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' + isnull(convert(varchar,xmlField.value('(Isndt)[1]', 'nvarchar(max)')),'') + ',' + ''  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),'')  +','+ 'DIS Issued' + ',' + '' +','+'' +','+ '' +','+''+','+''+','+','+','+','+','+','+','+','+','+','+','+ '' +','+','+','+','+','+','+  + ','+ 'Rcvdt' +',' + isnull(convert(varchar,xmlField.value('(Disalpa)[1]', 'nvarchar(max)')),'') + ','+','+ 'NRM' +','+ ','+'BO'+',' + isnull(convert(varchar,xmlField.value('(Disfrm)[1]', 'nvarchar(max)')),'') + ' ,' + isnull(convert(varchar,xmlField.value('(Disto)[1]', 'nvarchar(max)')),'') + ',' +  + ','+ 'DIS' + ','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+ '' +','+ isnull(convert(varchar,xmlField.value('(Dislvs)[1]', 'nvarchar(max)')),'') +','+','+',' + ',' + ','+ '' +','+ '' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ 'DISI' + ',' +  +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+''+','+','+ ',' +'' + ','+','+','+','+''+','+','+','+','+','+'' +','+','+','+','+','+','+','+','+','+','+','+','
		select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '000000' + ',' + ',' + 'DMU'	  + ' ,' + isnull(convert(varchar,ID),'') + ',' + '' + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') + ',' + '' + ',' +  + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isncdt)[1]', 'nvarchar(max)')),''), 5, 4)  + ',' + ''  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4)   +','+ 'DIS Issued' + ',' + '' +','+'' +','+ '' +','+''+','+''+','+','+','+','+','+','+','+','+','+','+','+ '' +','+','+','+','+','+','+  + ','+ 'Rcvdt' +',' + isnull(convert(varchar,xmlField.value('(Disalpa)[1]', 'nvarchar(max)')),'') + ','+','+ 'NRM' +','+ ','+'BO'+',' + isnull(convert(varchar,xmlField.value('(Disfrm)[1]', 'nvarchar(max)')),'') + ' ,' + isnull(convert(varchar,xmlField.value('(Disto)[1]', 'nvarchar(max)')),'') + ',' +  + ','+ 'DIS' + ','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+ '' +','+ isnull(convert(varchar,xmlField.value('(Dislvs)[1]', 'nvarchar(max)')),'') +','+','+',' + ',' + ','+ '' +','+ '' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ 'DISI' + ',' +  +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+''+','+','+ ',' +'' + ','+','+','+','+''+','+','+','+','+','+'' +','+','+','+','+','+','+','+','+','+','+','+','
		as Detailshar
		FROM Tmp
		

		drop table Tmp



             end
             if @PA_TRX_TAB='' 
             begin
             --print @PA_BROKER_YN
			 Select T.* into #HarmoTempCS from 
			 (
Select '<Tp>39</Tp>'
					+ '<Distxn>2</Distxn>'
					+ '<Dpstry>1</Dpstry>'
					+ '<Issenty>'+case when left(USES_DPAM_ACCT_NO,1)='2' then 'P' else  'B' end+'</Issenty>'
					+ '<Bnfcry>'+isnull(USES_DPAM_ACCT_NO,'')+'</Bnfcry>'
					+ '<Disalpa>'+convert(varchar(4),USES_SERIES_TYPE)+'</Disalpa>'
					+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(USES_SLIP_NO)),12,0,'L','0'))    +'</Disfrm>'
					+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),(USES_SLIP_NO_to)),12,0,'L','0'))    +'</Disto>'
					+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),((convert(numeric,USES_SLIP_NO_to)-convert(numeric,USES_SLIP_NO))+1)),3,0,'L','0') )+'</Dislvs>'
					+'<Bkltno>'+convert(varchar(16),ISNULL(used_book_name,'0'))+'</Bkltno>'
					+'<Isncflg>'+case when USES_DPAM_ACCT_NO ='' then 'N' else convert(varchar(1),'Y') end +'</Isncflg>'
					+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),uses_cancellation_dt,103),'/',''))+'</Isncdt>'
					--+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'L' else 'N' end) +'</Isncdt>'
					+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),citrus_usr.Fn_toSliptype(uses_slip_no_to,USED_ENTITY_TYPE,USES_DPAM_ACCT_NO)) ='1' then 'N' else 'N' end) +'</Isnctyp>'
					+'<Discncl>'+case when ISNULL(USES_DIS_CANCELLATION_FLAG,'')='CANCELLATION DUE TO LOST DIS' then '1' when ISNULL(USES_DIS_CANCELLATION_FLAG,'')='CANCELLATION DUE TO MISPLACED DIS' then '2' else '3' end+'</Discncl>'
					+'<Intby>'+case when ISNULL(USES_TRX_INITIATION_FLAG,'')='DP' then '1' else '2' end+'</Intby>'
					+'<Remk>'+isnull(uses_slipremarks,'')+'</Remk>'
					+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),uses_cancellation_dt,103),'/','')) +'</Rcvdt>'
					 details, uses_lst_upd_dt sliim_lst_upd_dt
					FROM  used_slip_block 
					where  uses_dpm_id   = @L_DPM_ID --case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
					and not exists (
					select slibd_sliim_id from sliim_batch_dtls where slibd_sliim_id = uses_ID   AND slibd_DIS_type = 'C'
					and slibd_deleted_ind = 1 --and slibd_batch_no = @PA_BATCH_NO 
					and slibd_entity_type=@PA_BROKER_YN
					)
					and USES_CANCELLATION_DT  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
					AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
					--and len(SLIIM_DPAM_ACCT_NO)=16 
					--and sliim_dpam_acct_no = isnull(USES_DPAM_ACCT_NO,'') -- need to add filter of column dis type
                    and isnull(used_entity_type,'')=@PA_BROKER_YN and USES_DELETED_IND =1
			--		and replace(USES_SLIP_NO,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_to
					) T
					order by sliim_lst_upd_dt 
					


					insert into sliim_batch_dtls (slibd_sliim_id
													,slibd_batch_no
													,slibd_created_by
													,slibd_created_dt
													,slibd_lst_upd_by
													,slibd_lst_upd_dt
													,slibd_deleted_ind,slibd_entity_type,slibd_DIS_type)
					select  uses_id ,@PA_BATCH_NO,@PA_LOGINNAME,getdate(),@PA_LOGINNAME,getdate(),1,@PA_BROKER_YN ,'C'
					FROM  used_slip_block 
					where 
					--uses_id=sliim_id 										
					uses_dpm_id   = @L_DPM_ID --case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
					and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = uses_ID 
					and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO )
					and USES_CANCELLATION_DT  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
					--and len(SLIIM_DPAM_ACCT_NO)=16 
					--and PA_SLIIM_ID=uses_ID 					
					and used_entity_type=@PA_BROKER_YN  
					
					update bitmap_ref_mstr set bitrm_values=bitrm_values+1 where bitrm_parent_cd='DISC_BTCH_CLT_CURNO' and bitrm_deleted_ind=1             
             end
		--insert into sliim_batch_dtls 
		--select sliim_id , @pa_batch_no , 'MIG',getdate(),'MIG',getdate(),1 FROM  slip_issue_mstr
		--where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
		--and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1)
		--and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
		--and len(SLIIM_DPAM_ACCT_NO)=16
		--order by sliim_lst_upd_dt 
		drop table Tmp
		
		Select cast(details as xml) xmlField,IDENTITY(int,1,1) ID,sliim_lst_upd_dt Rcvdt into Tmp from (
		Select * from #HarmoTempCS ) tb 
		

		--Select * from Tmp

		Select distinct
		'BtchId,SndrId,BrnchId,CntrlSctiesDpstryPtcptRole,TxnTyp,LineNb,SeqNm,SrcCntrlSctiesDpstryPtcpt,SrcClntIdOrBnfclOwnrId,ISIN,Qty,BuySellInd,OthrDpstryPtcpt,CntrBnfclOwnrId,CntrCMBPId,Xchg,ClrMmbId,MktTpAndId,SctiesSttlmTxId,OthrMktTpAndId,OthrSctiesSttlmTxId,ExecDt,TrdRsnCd,PlgRsnCd,FrzRsnCd,DISTpInd,DISSrlNb,MstrPwrOfAttnyId,CustdlTxnFlg,UnqClntId,UnqClrMmbId,BrkrId,CtdnPtcptId,Sgmt,ClrSysId,UnqEXId,MkrOprId,ChckrOprtrId,VrfrOprtId,ReqRcvdDtFrBO,Rmks,MdOfPmt,PmtTxRefNb,PmtDt,Acct,BkNm,Brnch,EPAcct,AgrmtId,AllUnitsOrAmtInd,DRFNb,AuthntcnRefNb,EarlyPayInFlg,BlkInd,ClsrDt,PldgTp,Cnsdrtn,DrctPyotFlg,CuspaTxnFlg,CuspaNSDLClntId,CuspaNSDLDPId,DmsIndFlg,DrctPayInFlg,DISIssncDt,DISAlphaPart,DISBookltNb,DISBookltTp,DISCxlFlg,DISIssdToClntOrPwrOfAttnyHldr,DISSrlNbFr,DISSrlNbTo,ISTxTp,DISTxTp,NbOfSOA,NbOfRgs,RcrdTp,RcrdNb,FolioNb,CertNbFr,CertNbTo,DNRFr,DNRTo,DsptchDt,DsptchDocId,DsptchNm,DocRcvdDt,DocTp,NbOfInstrs,NbOfDISLeavs,OrgnlOrdrRefNb ,LckInRsnCd,LckInAddtlInf,LckInXpryDt,IntlRefNb ,TrfeeNm,PldgSubTp,FreeOrLckInFlg,LckInId ,PldgReqFormNb,Val,PldgrIntlRef,PldgeeIntlRef,PldgIdr,MrgnPldgSeqNb,PartCntr,OthrDpstryFlg,FrzTp,FrzLvl,FrzInittdBy,FrzSubOptn,FrznFor,FrzActvtnTp,FrzActvtnDt,FrzXpryDt,FrzRsnDesc,FrzQtyTp,FrzInstrId,RmtFlg,RRFNb,MtlFndTp,MtlFndAmt,MtlFndInd,TxId,TtlNbOfTrfeeBnfclOwnrs,MltplQty,IsseFlg,FlgOfLooseSlip,AcctClsrFlg,ChanlInd,IrrvsblRsnCd1,IrrvsblRsnCd2,IrrvsblRsnCd3,IrrvsblRsnCd4,OthrDpstryClntCdOfFrstNmnee,OthrDpstryClntCdOfScndNmnee,OthrDpstryClntCdOfThrdNmnee,OthrDpstryFlgOfFrstNmnee,OthrDpstryFlgOfScndNmnee,OtherDpstryFlgOfThrdNmnee,OthrClntIdOfFrstNmnee,OthrClntIdOfScndNmnee,OthrClntIdOfThrdNmnee,OthrDpstryPtcptIdOfFrstNmnee,OthrDpstryPtcptIdOfScndNmnee,OthrDpstryPtcptIdOfThrdNmnee,PctgShrOfFrstNmnee,PctgShrOfScndNmnee,PctgShrOfThrdNmnee,Prty,RjctnRsnCd1,RjctnRsnCd2,RjctnRsnCd3,RjctnRsnCd4,SndrRefNb1,SndrRefNb2,StmpDtyInd,StsChngRsn,PANAndHldgPttrnMtcgh,WthtCnsdrtnFlg,TrnsmssnRsn,OthrDpstryClntCd,OthrDpstryId,TxUnqId,BuyPrTrd,MstSrcCntrlSctiesDpstryPtcpt,Rsn,CrtDnm,ConfAmt,DISISDTxTp,Rsvd1,Rsvd2,Rsvd3,Rsvd4'
		as Detailshar
		union all
		--select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '000000' + ',' + ',' + 'DMU'	  + ' ,' + isnull(convert(varchar,ID),'') + ',' + '' + ',' + substring(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),3,5) + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') + ',' + '' + ',' +  + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' + isnull(convert(varchar,xmlField.value('(Isndt)[1]', 'nvarchar(max)')),'') + ',' + ''  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),'')  +','+ 'DIS Issued' + ',' + '' +','+'' +','+ '' +','+''+','+''+','+','+','+','+','+','+','+','+','+','+','+ '' +','+','+','+','+','+','+  + ','+ 'Rcvdt' +',' + isnull(convert(varchar,xmlField.value('(Disalpa)[1]', 'nvarchar(max)')),'') + ','+','+ 'NRM' +','+ ','+'BO'+',' + isnull(convert(varchar,xmlField.value('(Disfrm)[1]', 'nvarchar(max)')),'') + ' ,' + isnull(convert(varchar,xmlField.value('(Disto)[1]', 'nvarchar(max)')),'') + ',' +  + ','+ 'DIS' + ','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+ '' +','+ isnull(convert(varchar,xmlField.value('(Dislvs)[1]', 'nvarchar(max)')),'') +','+','+',' + ',' + ','+ '' +','+ '' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ 'DISI' + ',' +  +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+''+','+','+ ',' +'' + ','+','+','+','+''+','+','+','+','+','+'' +','+','+','+','+','+','+','+','+','+','+','+','
		select distinct '' + Case when len(@PA_BATCH_NO)=7 then '0'+@PA_BATCH_NO when len(@PA_BATCH_NO)=6 then '00'+@PA_BATCH_NO when len(@PA_BATCH_NO)=5 then '000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=4 then '0000'+@PA_BATCH_NO  when len(@PA_BATCH_NO)=3 then '00000'+@PA_BATCH_NO else @PA_BATCH_NO end + ',' + @PA_LOGINNAME + ',' + '000000' + ',' + ',' + 'DMU'	  + ' ,' + isnull(convert(varchar,ID),'') + ',' + '' + ',' + '033200' + ',' + isnull(convert(varchar,xmlField.value('(Bnfcry)[1]', 'nvarchar(max)')),'') + ',' + '' + ',' +  + ' ,,' + '' + ',' + '' + ',' + '' + ','+','+',' + '' + ',' + '' + ',' + '' + ',' + '' + ',' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isndt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isndt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Isndt)[1]', 'nvarchar(max)')),''), 5, 4)  + ',' + ''  + ',,,' + '' + ',' + '' + ',' + '' + ','+','+','+','+','+','+','+','+',' + '' + ',' + '' + ',' + '' + ','+ SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 1, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 3, 2) + '-' + SUBSTRING(isnull(convert(varchar,xmlField.value('(Rcvdt)[1]', 'nvarchar(max)')),''), 5, 4)   +','+ 'DIS Issued' + ',' + '' +','+'' +','+ '' +','+''+','+''+','+','+','+','+','+','+','+','+','+','+','+ '' +','+','+','+','+','+','+  + ','+ 'Rcvdt' +',' + isnull(convert(varchar,xmlField.value('(Disalpa)[1]', 'nvarchar(max)')),'') + ','+','+ 'NRM' +','+ ','+'BO'+',' + isnull(convert(varchar,xmlField.value('(Disfrm)[1]', 'nvarchar(max)')),'') + ' ,' + isnull(convert(varchar,xmlField.value('(Disto)[1]', 'nvarchar(max)')),'') + ',' +  + ','+ 'DIS' + ','+','+','+','+','+','+','+','+','+','+','+','+','+' ,'+','+ '' +','+ isnull(convert(varchar,xmlField.value('(Dislvs)[1]', 'nvarchar(max)')),'') +','+','+',' + ',' + ','+ '' +','+ '' +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ 'DISI' + ',' +  +','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+','+ ',' +','+','+','+''+','+','+ ',' +'' + ','+','+','+','+''+','+','+','+','+','+'' +','+','+','+','+','+','+','+','+','+','+','+','
		as Detailshar
		FROM Tmp --order by convert(numeric,id)

		drop table Tmp

		END  
	End	   
	
	
	IF @PA_BATCH_TYPE = 'ALL'  
	BEGIN  

	
	Select '<Tp>39</Tp>'
	+ '<Distxn>1</Distxn>'
	+ '<Dpstry>1</Dpstry>'
	+ '<Issenty>B</Issenty>'
	+ '<Bnfcry>'+SLIIM_DPAM_ACCT_NO+'</Bnfcry>'
	+ '<Disalpa>'+convert(varchar(4),SLIIM_SERIES_TYPE)+'</Disalpa>'
	+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(SLIIM_SLIP_NO_FR)),12,0,'L','0'))    +'</Disfrm>'
	+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(SLIIM_SLIP_NO_TO)),12,0,'L','0'))    +'</Disto>'
	+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs((convert(numeric,SLIIM_SLIP_NO_TO)-convert(numeric,SLIIM_SLIP_NO_FR)+1))),3,0,'L','0') )+'</Dislvs>'
	--+'<Bkltno>'+convert(varchar(16),isnull(sliim_book_name,''))+'</Bkltno>'
	+'<Bkltno>'+isnull(citrus_usr.Fn_toSliptype_BookName(sliim_slip_no_to,'',''),'')+'</Bkltno>' 
	+'<Isncflg>'+convert(varchar(1),'Y')+'</Isncflg>'
	+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
	+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'N' else 'N' end) +'</Isncdt>'
	+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'N' else 'N' end) +'</Isnctyp>'
	+'<Discncl></Discncl>'
	+'<Intby></Intby>'
	+'<Remk></Remk>'
	+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/','')) +'</Rcvdt>'
	 details, sliim_lst_upd_dt 

	 

	FROM  slip_issue_mstr
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO)
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	union all 
	Select '<Tp>39</Tp>'
	+ '<Distxn>1</Distxn>'
	+ '<Dpstry>1</Dpstry>'
	+ '<Issenty>B</Issenty>'
	+ '<Bnfcry>'+SLIIM_DPAM_ACCT_NO+'</Bnfcry>'
	+ '<Disalpa>'+convert(varchar(4),SLIIM_SERIES_TYPE)+'</Disalpa>'
	+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(SLIIM_SLIP_NO_FR)),12,0,'L','0'))    +'</Disfrm>'
	+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(SLIIM_SLIP_NO_TO)),12,0,'L','0'))    +'</Disto>'
	+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs((convert(numeric,SLIIM_SLIP_NO_TO)-convert(numeric,SLIIM_SLIP_NO_FR)+1))),3,0,'L','0') )+'</Dislvs>'
	+'<Bkltno>'+convert(varchar(16),isnull('',''))+'</Bkltno>'
	+'<Isncflg>'+convert(varchar(1),'Y')+'</Isncflg>'
	+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
	+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'N' else 'N' end) +'</Isncdt>'
	+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'N' else 'N' end) +'</Isnctyp>'
	+'<Discncl></Discncl>'
	+'<Intby></Intby>'
	+'<Remk></Remk>'
	+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/','')) +'</Rcvdt>'
	 details, sliim_lst_upd_dt 
	FROM  slip_issue_mstr_poa
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO)
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	union all 
	Select '<Tp>39</Tp>'
	+ '<Distxn>2</Distxn>'
	+ '<Dpstry>1</Dpstry>'
	+ '<Issenty>B</Issenty>'
	+ '<Bnfcry>'+isnull(USES_DPAM_ACCT_NO,'')+'</Bnfcry>'
	+ '<Disalpa>'+convert(varchar(4),USES_SERIES_TYPE)+'</Disalpa>'
	+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(USES_SLIP_NO)),12,0,'L','0'))    +'</Disfrm>'
	+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(USES_SLIP_NO_to)),12,0,'L','0'))    +'</Disto>'
	+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs((convert(numeric,USES_SLIP_NO_to)-convert(numeric,USES_SLIP_NO))+1)),3,0,'L','0') )+'</Dislvs>'
	+'<Bkltno>'+convert(varchar(16),'')+'</Bkltno>'
	+'<Isncflg>'+case when USES_DPAM_ACCT_NO ='' then 'N' else convert(varchar(1),'Y') end +'</Isncflg>'
	+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
	+'<Isncdt>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'N' else 'N' end) +'</Isncdt>'
	+'<Isnctyp>'+convert(varchar(1),case when convert(varchar(1),SLIIM_LOOSE_Y_N) ='Y' then 'N' else 'N' end) +'</Isnctyp>'
	+'<Discncl>1</Discncl>'
	+'<Intby>2</Intby>'
	+'<Remk></Remk>'
	+'<Rcvdt>'+ convert(varchar(8),replace(convert(varchar(11),USES_CANCELLATION_DT,103),'/','')) +'</Rcvdt>'
	 details, sliim_lst_upd_dt 
	FROM  used_slip_block,slip_issue_mstr 
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO )
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	and sliim_dpam_acct_no = isnull(USES_DPAM_ACCT_NO,'')
	and replace(USES_SLIP_NO,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_to
	
	

	--insert into sliim_batch_dtls 
	--select sliim_id , @pa_batch_no , 'MIG',getdate(),'MIG',getdate(),1 FROM  slip_issue_mstr
	--where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	--and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1)
	--and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	--and len(SLIIM_DPAM_ACCT_NO)=16
	--order by sliim_lst_upd_dt 


	END 
 
--  
END 
IF @PA_POOL_ACCTNO = 'SLIPISSUECANN_SELECT'  
BEGIN  
	IF @PA_BATCH_TYPE = 'I'  
	BEGIN  

	Select SLIIM_DPAM_ACCT_NO,SLIIM_SLIP_NO_FR,SLIIM_SLIP_NO_TO,'I' TYPE,'' ISSUEENTITY -- *,'I' flag
	FROM  slip_issue_mstr
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO)
	and sliim_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
	AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	--union all 
	Select *,'P' flag
	FROM  slip_issue_mstr_poa
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO)
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	--union all 
	--Select '<Tp>39</Tp>'
	--+ '<Distxn>2</Distxn>'
	--+ '<Dpstry>1</Dpstry>'
	--+ '<Issenty>B</Issenty>'
	--+ '<Bnfcry>'+isnull(USES_DPAM_ACCT_NO,'')+'</Bnfcry>'
	--+ '<Disalpa>'+convert(varchar(4),USES_SERIES_TYPE)+'</Disalpa>'
	--+'<Disfrm>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(USES_SLIP_NO)),12,0,'L','0'))    +'</Disfrm>'
	--+'<Disto>'+ convert(varchar(12),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs(USES_SLIP_NO)),12,0,'L','0'))    +'</Disto>'
	--+'<Dislvs>'+convert(varchar(3),citrus_usr.FN_FORMATSTR(convert(varchar(12),abs((USES_SLIP_NO-USES_SLIP_NO+1))),3,0,'L','0') )+'</Dislvs>'
	--+'<Bkltno>'+convert(varchar(16),'')+'</Bkltno>'
	--+'<Isncflg>'+case when USES_DPAM_ACCT_NO ='' then 'N' else convert(varchar(1),'Y') end +'</Isncflg>'
	--+'<Isncdt>'+convert(varchar(8),replace(convert(varchar(11),sliim_dt,103),'/',''))+'</Isncdt>'
	--+'<Isncdt>'+convert(varchar(1),case when SLIIM_LOOSE_Y_N ='Y' then 'L' else 'N' end +'</Isncdt>'
	--+'<Isnctyp>'+convert(varchar(1),case when SLIIM_LOOSE_Y_N ='Y' then 'L' else 'N' end +'</Isnctyp>'
	--+'<Discncl>1</Discncl>'
	--+'<Intby>2</Intby>'
	--+'<Remk></Remk>' details, sliim_lst_upd_dt , sliim_id 
	--FROM  used_slip,slip_issue_mstr 
	--where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	--and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO )
	--and sliim_lst_upd_dt  between BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	--and len(SLIIM_DPAM_ACCT_NO)=16
	--and sliim_dpam_acct_no = isnull(USES_DPAM_ACCT_NO,'')
	--and replace(USES_SLIP_NO,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_to
	--order by sliim_lst_upd_dt 


	

	END     
	Else IF @PA_BATCH_TYPE = 'C'  
	BEGIN  


	Select usesb.*,'C' flag
	FROM  used_slip_block usesb,slip_issue_mstr 
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO )
	and sliim_lst_upd_dt  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	and sliim_dpam_acct_no = isnull(USES_DPAM_ACCT_NO,'')
	and replace(USES_SLIP_NO,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_to
	order by sliim_lst_upd_dt 


	

	END     
	else IF @PA_BATCH_TYPE = 'ALL'  
	BEGIN  

	Select *,'I' flag


	FROM  slip_issue_mstr
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO)
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	--union all 
	Select *,'P' flag
	FROM  slip_issue_mstr_poa
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO)
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	--union all 
	Select *,'C' flag
	FROM  used_slip_block,slip_issue_mstr 
	where		sliim_dpm_id   = case when @L_DPM_ID='3' then sliim_dpm_id else @L_DPM_ID end
	and not exists (select 1 from sliim_batch_dtls where slibd_sliim_id = SLIIM_ID and slibd_deleted_ind = 1 and slibd_batch_no = @PA_BATCH_NO )
	and sliim_lst_upd_dt   BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
	and len(SLIIM_DPAM_ACCT_NO)=16
	and sliim_dpam_acct_no = isnull(USES_DPAM_ACCT_NO,'')
	and replace(USES_SLIP_NO,SLIIM_SERIES_TYPE,'') between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_to
	order by sliim_lst_upd_dt 




	END 
 
--  
END 
 

--

GO
