-- Object: PROCEDURE citrus_usr.PR_SELECT_TRXGEN_CDSL_SP_XML_backjun262014
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[PR_SELECT_TRXGEN_CDSL_SP_XML_backjun262014]  
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



create table #tempdata(cd varchar(100),details varchar(8000),qty numeric(19,3))


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
insert into #tempdata (details,qty)
exec PR_SELECT_TRXGEN_CDSL_SP @l_TRX_TAB  ,  
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
    


select case when cd = 'Dmat' then '<Tp>'  + '1' + '</Tp>'
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
--ok
 WHEN cd = 'NP' THEN  '<Tp>'+ '3' +'</Tp>'
--+'<Dpstry>'+ ltrim(rtrim(substring(details , 1 , 2))) +'</Dpstry>'
+'<Dpstry>'+ '01' +'</Dpstry>'
+'<Clr>'+ ltrim(rtrim(substring(details , 4 , 2))) +'</Clr>'
+'<Xchg>'+ ltrim(rtrim(substring(details , 5 , 2))) +'</Xchg>'
+'<Sttlm>'+ ltrim(rtrim(substring(details , 7 , 13))) +'</Sttlm>'
+'<Ptcpt>'+ ltrim(rtrim(substring(details , 20 , 6))) +'</Ptcpt>'
+'<Mmb>'+ ltrim(rtrim(substring(details , 26 , 8))) +'</Mmb>'
--+'<Bnfcry>'+ ltrim(rtrim(substring(details , 34	 , 16))) +'</Bnfcry>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 34	 , 17))) +'</Bnfcry>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 50 , 12))) +'</ISIN>'
--+'<Qty>'+ ltrim(rtrim(convert(varchar,qty))) +'</Qty>'
+'<Qty>'+ ltrim(rtrim(convert(varchar,convert(numeric,qty)))) +'</Qty>'
+'<Flg>'+'S' +'</Flg>'
+'<Ref>'+ ltrim(rtrim(substring(details , 90 , 16))) +'</Ref>'
+'<Arf>'+ '' +'</Arf>'
--120420121201090001809694INE002A01018000000000020000SX10000039IN301862             6904769/1275   
--ok              
 WHEN cd = 'ID' THEN  +'<Tp>'+ '4' +'</Tp>'
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
+'<Arf>'+''+'</Arf>'
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
+'<Arf>'+ '' +'</Arf>'
--ok
 WHEN cd = 'EP' THEN  '<Tp>'+ '10' +'</Tp>'
+'<Xchg>'+ ltrim(rtrim(substring(details , 1 , 2))) +'</Xchg>'
+'<Clr>'+ ltrim(rtrim(substring(details , 3 , 2))) +'</Clr>'
+'<Mmb>'+ ltrim(rtrim(substring(details , 5 , 8))) +'</Mmb>'
+'<Sttlm>' + ltrim(rtrim(substring(details , 13 , 13)))  + '</Sttlm>'
+'<Bnfcry>'+ ltrim(rtrim(substring(details , 26	 , 16))) +'</Bnfcry>'
+'<ISIN>'+ ltrim(rtrim(substring(details , 41 , 12))) +'</ISIN>'
+'<Qty>'+ ltrim(rtrim(convert(varchar,qty))) +'</Qty>'
+'<Flg>'+ ltrim(rtrim(substring(details , 69 , 1))) +'</Flg>'
+'<CtrPty>' + ltrim(rtrim(substring(details , 70 , 16))) + '</CtrPty>'
+'<Ref>'+ ltrim(rtrim(substring(details , 86 , 16))) + '</Ref>'
+'<Dt>' + ltrim(rtrim(substring(details , 102 , 8)))  + '</Dt>'
+'<Arf>'+ '' +'</Arf>'
 WHEN cd = 'PLEDGE' THEN  '<Tp>'+ '7' +'</Tp>'
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
--WHEN cd = 'DESTAT' THEN  

else details end as details , qty
from #tempdata 

if isnull(@PA_BATCH_NO,'') = '' 
begin
	select @PA_BATCH_NO = max(CONVERT(BIGINT,BITRM_VALUES)) from BITMAP_REF_MSTR 
	WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  
end

UPDATE BITMAP_REF_MSTR SET BITRM_VALUES =  CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))       
WHERE BITRM_PARENT_CD  = 'CDSL_BTCH_'  + 'ALL' + '_CURNO' AND  BITRM_CHILD_CD= @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID  


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
	BATCHC_DELETED_IND  
	)  
	VALUES  
	(  
	@L_DPM_ID,  
	@PA_BATCH_NO,  
	@L_TOT_REC,  
	'ALL',
	CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00',  
	'T',  
	'P',  
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
