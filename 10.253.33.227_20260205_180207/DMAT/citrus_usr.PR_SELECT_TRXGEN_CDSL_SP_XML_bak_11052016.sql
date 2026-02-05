-- Object: PROCEDURE citrus_usr.PR_SELECT_TRXGEN_CDSL_SP_XML_bak_11052016
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



create PROCEDURE [citrus_usr].[PR_SELECT_TRXGEN_CDSL_SP_XML_bak_11052016]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(2),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20),  
@PA_POOL_ACCTNO VARCHAR(16),
@PA_BROKER_YN CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20),  
@PA_OUTPUT VARCHAR(20) OUTPUT  
)  
AS  
BEGIN 



create table #tempdata(cd varchar(100),details varchar(8000),qty numeric(19,3),TRXEFLG char(1) ,
dptdc_slip_no varchar(16) , dptdc_created_by varchar(20) , dptdc_lst_upd_by varchar(20),verifier varchar(20),
dptdc_id numeric(19,0),request_dt varchar(14),usn numeric(18,0) )


	DECLARE @@L_TRX_CD VARCHAR(5)  
  ,@L_QTY varchar(100)  
  ,@L_TOTQTY VARCHAR(100)   
  ,@L_SQL VARCHAR(8000)  
  ,@l_TRX_TAB varchar(8000)  
  ,@remainingstring varchar(8000)  
  ,@foundat int  
  ,@delimeter  varchar(50)  
  ,@currstring  varchar(500)  
        ,@delimeterlength int  
        ,@l_dpm_id int   
        ,@L_TOT_REC int  
        ,@L_TRANS_TYPE VARCHAR(8000)   
       SET @delimeter        = '%'+ @ROWDELIMITER + '%'  
      SET @delimeterlength = LEN(@ROWDELIMITER)  
      SET @remainingstring = @PA_TRX_TAB    
   SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1     
  SET @L_TOT_REC = 0
  WHILE @remainingstring <> ''  
  BEGIN  
  --  
    SET @foundat = 0  
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)  
    --  
    IF @foundat > 0  
    BEGIN  
    --  
      SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)  
      SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @currstring      = @remainingstring  
      SET @remainingstring = ''  
    --  
    END  
    --  
    IF @currstring <> ''  
    BEGIN  
    --  
      SET @l_TRX_TAB = citrus_usr.fn_splitval(@currstring,1) + '*|~*'  
    
		
print @l_TRX_TAB

--select @l_TRX_TAB  ,  
--@PA_FROM_DT ,  
--@PA_TO_DT ,  
--@PA_BATCH_NO ,  
--@PA_BATCH_TYPE ,  
--@PA_EXCSM_ID ,  
--@PA_LOGINNAME ,  
--@PA_POOL_ACCTNO ,
--@PA_BROKER_YN , 
--@ROWDELIMITER ,  
--@COLDELIMITER ,
--@PA_OUTPUT   
insert into #tempdata (details,qty,TRXEFLG ,dptdc_slip_no , dptdc_created_by , dptdc_lst_upd_by,verifier,dptdc_id,request_dt )
exec PR_SELECT_TRXGEN_CDSL_SP --_MOSL 
@l_TRX_TAB  ,  
@PA_FROM_DT ,  
@PA_TO_DT ,  
@PA_BATCH_NO ,  
@PA_BATCH_TYPE ,  
@PA_EXCSM_ID ,  
@PA_LOGINNAME ,  
@PA_POOL_ACCTNO ,
@PA_BROKER_YN , 
@ROWDELIMITER ,  
@COLDELIMITER ,
@PA_OUTPUT   


update #tempdata set cd =  citrus_usr.fn_splitval(@currstring,1) where cd is null  



  END  
  --  
  END  
    

DECLARE @L_CNT NUMERIC,@l_lid numeric
select @l_lid = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd='USN_NO' and bitrm_deleted_ind=1
--
select identity(int,1,1) id, * into #tempdata_Usn from #tempdata where cd not in ('DMAT','DESTAT')

update #tempdata set Usn=@l_lid+id from #tempdata_Usn t ,#tempdata d where t.dptdc_id=d.dptdc_id and d.cd not in ('DMAT','DESTAT')


SELECT @L_CNT = COUNT(1) FROM #TEMPDATA

INSERT INTO DPTDC_USN
(
 USN_DPTDC_ID
,USN_BATCH_NO
,USN_NO
,USN_CREATED_BY
,USN_CREATED_DT
,USN_LST_UPD_BY
,USN_LST_UPD_DT
,USN_DELETED_IND
)
SELECT 
DPTDC_ID
,@PA_BATCH_NO
,Usn
,@PA_LOGINNAME
,GETDATE()
,@PA_LOGINNAME
,GETDATE()
,1
FROM #TEMPDATA where cd not in ('DMAT','DESTAT')

update bitmap_ref_mstr set bitrm_bit_location=bitrm_bit_location+@l_cnt+1 where bitrm_parent_cd='USN_NO' and bitrm_deleted_ind=1

drop table #tempdata_Usn

select distinct case when cd = 'Dmat' then '<Tp>'  + '1' + '</Tp>'
+'<Bnfcry>' + ltrim(rtrim(substring(details , 1 , 16))) + '</Bnfcry>'
+'<ISIN>' + ltrim(rtrim(substring(details , 17 , 12)))  + '</ISIN>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 17 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
+'<Drf>' +  ltrim(rtrim(substring(details , 45 , 16))) + '</Drf>'
+'<Pg>' + convert(varchar,convert(numeric,ltrim(rtrim(substring(details , 119 , 5))))) + '</Pg>' -- total cert
+'<Dspchid>' + ltrim(rtrim(substring(details , 61 , 20))) + '</Dspchid>'
+'<Dspchnm>' + case when ltrim(rtrim(substring(details , 61 , 20)))='' then '' else ltrim(rtrim(substring(details , 81 , 30))) end + '</Dspchnm>'
+'<Dspchdt>' +  case when ltrim(rtrim(substring(details , 61 , 20)))='' then '' else ltrim(rtrim(substring(details , 111 , 8))) end + '</Dspchdt>'
+'<Lcksts>' + ltrim(rtrim(substring(details , 124 , 1))) + '</Lcksts>'
+'<Lckcd>' + case when ltrim(rtrim(substring(details , 125 , 2)))='00' then '' else ltrim(rtrim(substring(details , 125 , 2))) end  + '</Lckcd>'
+'<Lckrem>' + ltrim(rtrim(substring(details , 127 , 50))) + '</Lckrem>'
+'<Lckexpdt>' + case when ltrim(rtrim(substring(details , 177 , 8)))='00000000' then '' else ltrim(rtrim(substring(details , 177 , 8))) end  + '</Lckexpdt>' 
+'<Rcvdt>' + request_dt + '</Rcvdt>'
--ok
 WHEN cd = 'NP' THEN  '<Tp>'+ '3' +'</Tp>'
--+'<Dpstry>'+ ltrim(rtrim(substring(details , 1 , 2))) +'</Dpstry>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Dpstry>'+ '01' +'</Dpstry>'
+'<Clr>'+ ltrim(rtrim(substring(details , 4 , 2))) +'</Clr>'
+'<Xchg>'+ ltrim(rtrim(substring(details , 5 , 2))) +'</Xchg>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 7 , 13))) +'</Sttlm>'
+'<Ptcpt>'+ ltrim(rtrim(substring(details , 21 , 6))) +'</Ptcpt>'
+'<Mmb>'+ ltrim(rtrim(substring(details , 27 , 8))) +'</Mmb>'
--+'<Bnfcry>'+ ltrim(rtrim(substring(details , 34	 , 16))) +'</Bnfcry>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 35	 , 16))) +'</Bnfcry>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 51 , 12))) +'</ISIN>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,qty))) +'</Qty>'
+'<Qty>'+ ltrim(rtrim(convert(varchar,convert(numeric,qty)))) +'</Qty>'
+'<Flg>'+'S' +'</Flg>'
+'<Ref>'+ ltrim(rtrim(substring(details , 90 , 16))) +'</Ref>'

+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'

--+'<Arf>'+ '' +'</Arf>'
--120420121201090001809694INE002A01018000000000020000SX10000039IN301862             6904769/1275   
--ok              
 WHEN cd = 'ID' THEN  +'<Tp>'+ '4' +'</Tp>'
 +'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Dt>' + ltrim(rtrim(substring(details , 1 , 8))) +'</Dt>'
+'<Bnfcry>' + ltrim(rtrim(substring(details , 9 , 16))) +'</Bnfcry>'
+'<ISIN>' +  ltrim(rtrim(substring(details , 25 , 12))) +'</ISIN>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 25 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 52 , 1))) +'</Flg>'
+'<Trf>'+ ltrim(rtrim(substring(details , 53 , 1))) +'</Trf>'
+'<Clnt>'+ ltrim(rtrim(substring(details , 54 , 8))) +'</Clnt>'
+'<Brkr>'+ ltrim(rtrim(substring(details , 62 , 8))) +'</Brkr>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 70 , 13))) +'</Sttlm>'
+'<Ref>'+ ltrim(rtrim(substring(details , 83 , 16))) +'</Ref>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 99 , 13))) +'</CntrSttlm>'

+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  

+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'

--+'<Arf>'+''+'</Arf>'
--
-- WHEN cd = 'OFFM' THEN  +'<Tp>'+ '5' +'</Tp>'
--+'<Dt>'+ substring(details , 1 , 8)+'</Dt>'
--+'<Bnfcry>'+ substring(details , 9 , 16)+'</Bnfcry>'
--+'<CtrPty>' +substring(details , 26 , 16)+  +'</CtrPty>'
--+'<ISIN>'+substring(details , 43 , 12) +'</ISIN>'
--+'<Qty>'+ substring(details , 53 , 15) +'</Qty>'
--+'<Flg>'+ substring(details , 72 , 1)+'</Flg>'
--+'<Trf>'+ substring(details , 74 , 1)+'</Trf>'
--+'<Rsn>'+ substring(details , 76 , 10)+'</Rsn>'
--+'<Ref>'+substring(details , 87 , 16) +'</Ref>'
--+'<Sttlm>'+ substring(details , 104 , 13)+'</Sttlm>'
--+'<CntrSttlm>'+ substring(details , 118 , 13)+'</CntrSttlm>'
--+'<Arf>'+ ''+'</Arf>'
--ok
WHEN cd = 'OFFM' THEN  +'<Tp>'+ '5' +'</Tp>'   
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Dt>'+ ltrim(rtrim(substring(details , 1 , 8))) +'</Dt>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 9 , 16))) +'</Bnfcry>'
+'<CtrPty>' + ltrim(rtrim(substring(details , 25 , 16)))  +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 41 , 12))) +'</ISIN>'
+'<Qty>'+ case when ltrim(rtrim(substring(details , 41 , 3))) not in  ('INC','INF') then ltrim(rtrim(convert(varchar,convert(numeric,qty)))) else ltrim(rtrim(convert(varchar,qty))) end +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 68 , 1))) +'</Flg>'
+'<Trf>'+ ltrim(rtrim(substring(details , 69 , 1))) +'</Trf>'
+'<Rsn>'+ ltrim(rtrim(substring(details , 70 , 1))) +'</Rsn>'
+'<Ref>'+ ltrim(rtrim(substring(details , 71 , 16))) +'</Ref>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 87 , 13))) +'</Sttlm>'
+'<CntrSttlm>'+ ltrim(rtrim(substring(details , 100 , 13))) +'</CntrSttlm>'
+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+ case when citrus_usr.fn_get_poa_id(dptdc_slip_no) = '' then '' else +'<Poa>'+ citrus_usr.fn_get_poa_id(dptdc_slip_no)  +'</Poa>' end  
--+'<Poa>'+ TRXEFLG +'</Poa>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'
--+'<Arf>'+ '' +'</Arf>'
--ok
 WHEN cd = 'EP' THEN  '<Tp>'+ '10' +'</Tp>'
 +'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Xchg>'+ ltrim(rtrim(substring(details , 1 , 2))) +'</Xchg>'
+'<Clr>'+ ltrim(rtrim(substring(details , 3 , 2))) +'</Clr>'
+'<Mmb>'+ ltrim(rtrim(substring(details , 5 , 8))) +'</Mmb>'
+'<Sttlm>' + ltrim(rtrim(substring(details , 13 , 13)))  + '</Sttlm>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 26	 , 16))) +'</Bnfcry>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 42 , 12))) +'</ISIN>'
+'<Qty>'+ ltrim(rtrim(convert(varchar,qty))) +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 69 , 1))) +'</Flg>'
+'<CtrPty>' + ltrim(rtrim(substring(details , 70 , 16))) + '</CtrPty>'
+'<Ref>'+ ltrim(rtrim(substring(details , 86 , 16))) + '</Ref>'
+'<Dt>' + ltrim(rtrim(substring(details , 102 , 8)))  + '</Dt>'

+'<Txnelflg>'+ TRXEFLG +'</Txnelflg>'
+'<Dis>'+ dptdc_slip_no +'</Dis>'
+'<Mkropid>'+ ltrim(rtrim(left(dptdc_created_by,12))) +'</Mkropid>'
+'<Ckropid>'+ dptdc_lst_upd_by +'</Ckropid>'
+'<Vfropid>'+ verifier +'</Vfropid>'

--+'<Arf>'+ '' +'</Arf>'
 WHEN cd = 'PLEDGE' THEN  '<Tp>'+ '7' +'</Tp>'
+'<Usn>'+ convert(varchar,usn) +'</Usn>'
+'<Pldgtp>'+ ltrim(rtrim(substring(details , 1 , 1))) +'</Pldgtp>'
+'<Subtp>'+ ltrim(rtrim(substring(details , 2 , 1))) +'</Subtp>'
+'<Lcksts>'+ ltrim(rtrim(substring(details , 3 , 1))) +'</Lcksts>'
+'<Lckid>'+ ltrim(rtrim(substring(details , 4 , 16))) +'</Lckid>'
+'<Prf>'+ ltrim(rtrim(substring(details , 20 , 8))) +'</Prf>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 28 , 16))) +'</Bnfcry>'
+'<CtrPty>'+ ltrim(rtrim(substring(details , 44 , 16))) +'</CtrPty>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 60 , 12))) +'</ISIN>'
+'<Qty>'+ ltrim(rtrim(convert(varchar,convert(numeric, qty)))) +'</Qty>'
+'<Val>'+ convert(varchar,convert(numeric(15,2),left(ltrim(rtrim(substring(details , 88 , 15))),13)+ '.' + right(ltrim(rtrim(substring(details , 88 , 15))),2))) +'</Val>'
+'<Xpry>'+ ltrim(rtrim(substring(details , 103 , 8))) +'</Xpry>'
+'<Ref>'+ ltrim(rtrim(substring(details , 127 , 16))) +'</Ref>'
+'<Agrmt>'+ ltrim(rtrim(substring(details , 143 , 20))) +'</Agrmt>'
+'<Remk>'+ ltrim(rtrim(substring(details , 163 , 100))) +'</Remk>'
+'<Psn></Psn>'
+'<Rcvdt>' + request_dt + '</Rcvdt>'
--WHEN cd = 'DESTAT' THEN  

else details end as details , qty
from #tempdata 

if isnull(@PA_BATCH_NO,'') = '' 
begin
	select @PA_BATCH_NO = max(CONVERT(BIGINT,BITRM_VALUES)) from BITMAP_REF_MSTR 
	WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID 
    AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
end

UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID 
AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  


--UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
--WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  

/* insert into batch table*/  

select  @L_TOT_REC = count(*) from #tempdata

if count(@L_TOT_REC)>0
begin  -- cnt

--	if exists (select cd from #tempdata where cd='DMAT')
--	begin
--
--
--	end
--
--	if exists (select cd from #tempdata where cd='DESTAT')
--	begin
--
--	end
--
--	if exists (select cd from #tempdata where cd='PLEDGE')
--	begin
--
--	end
--
--	if exists (select cd from #tempdata where cd in  ('OFFM','ID','NP','EP',))
--	begin
--
--        UPDATE D1 Set dptdc_batch_no=@pa_batch_no FROM dp_trx_dtls_cdsl D1 ,dp_acct_mstr D2  
--		WHERE  dptdc_dpam_id = dpam_id   
--		AND    dpam_dpm_id   = @l_dpm_id    
--		AND    isnull(dptdc_status,'P')='P'  
--		AND    ltrim(rtrim(isnull(dptdc_batch_no,''))) = ''  
--		AND    dptdc_request_dt BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'  
--		AND    dptdc_internal_trastm in ('CMBO','CMCM','BOBO','BOCM')  
--		AND    d2.dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_POOL_ACCTNO))     = '' THEN '%' ELSE @PA_POOL_ACCTNO  END
--
--	end


	IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1 AND BATCHC_TYPE='T' AND BATCHC_TRANS_TYPE='ALL')  
	BEGIN  
	INSERT INTO BATCHNO_CDSL_MSTR                                       
	(    
	BATCHC_DPM_ID,  
	BATCHC_NO,  
	BATCHC_RECORDS ,  
	BATCHC_TRANS_TYPE,
	BATCHC_FILEGEN_DT,
	BATCHC_TYPE,  
	BATCHC_STATUS,  
	BATCHC_CREATED_BY,  
	BATCHC_CREATED_DT ,  
	BATCHC_LST_UPD_BY,
    BATCHC_LST_UPD_DT,
	BATCHC_DELETED_IND  
	)  
	VALUES  
	(  
	@L_DPM_ID,  
	@PA_BATCH_NO,  
	@L_TOT_REC,  
	'ALL',
	getdate(),--CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
	'T',  
	'P',  
	@PA_LOGINNAME,  
	GETDATE(), 
	@PA_LOGINNAME,  
	GETDATE(),	 
	1  
	)      
																															    
	END   
--

END -- cnt

--  
END

GO
