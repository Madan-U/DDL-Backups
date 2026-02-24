-- Object: PROCEDURE citrus_usr.pr_select_trxgen_cdsl_Harmonization
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin tran
--select * from dp_mstr where default_dp=dpm_excsm_id
--pr_select_trxgen_cdsl 'OFFM','25/11/2008','25/11/2008','1','BN',3,'HO','','N','*|~*','|*~|',''
--rollback
CREATE PROCEDURE [citrus_usr].[pr_select_trxgen_cdsl_Harmonization]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(4),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20),  
@PA_POOL_ACCTNO VARCHAR(16),
@pa_broker_yn CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20),  
@pa_output VARCHAR(20) output  
)  
AS  
BEGIN  


--  
/*  
p-pending  
o-overduwe  
s-upload success  
f-fail  
e-execute  
r-reject  
0-intial  
*/  
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
      SET @l_TRX_TAB = citrus_usr.fn_splitval(@currstring,1)  
    
    if @pa_broker_yn = 'Y' 
    begin
					
IF @L_TRX_TAB= 'CLSR_ACCT_GEN'         
BEGIN  
           
--Print @L_DPM_ID
--print @PA_EXCSM_ID

 SELECT identity(numeric,1,1) id  , CONVERT(VARCHAR(16),ISNULL(CLSR_BO_ID,''))AS CLSR_BO_ID ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,''))AS CLSR_TRX_TYPE,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) in ('A','C') then '0' else CONVERT(VARCHAR(1),ISNULL(CLSR_INI_BY,'0')) end AS CLSR_INI_BY ,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) in ('A','C') then '00' else CONVERT(VARCHAR(2),ISNULL(CLSR_REASON_CD,'00')) end AS CLSR_REASON_CD ,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) in ('A','C') then '' else CONVERT(VARCHAR(1),ISNULL(CLSR_REMAINING_BAL,'')) end AS CLSR_REMAINING_BAL ,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) in ('A','C') then '' else CONVERT(VARCHAR(16),ISNULL(CLSR_NEW_BO_ID,'')) end  AS CLSR_NEW_BO_ID ,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) in ('A','C') then '' else CONVERT(VARCHAR(100),ISNULL(CLSR_RMKS,'')) end  AS CLSR_RMKS,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) in ('A','C') then '' else CONVERT(VARCHAR(16),ISNULL(CLSR_ID,0)) end  AS CLSR_REQ_INT_REFNO  ,
		case when CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,'')) ='A' then '' else REPLACE(CONVERT(VARCHAR(10), CLSR_DATE, 103), '/', '')+LEFT(REPLACE(CONVERT(VARCHAR(12), CLSR_CREATED_DT, 114),':','') ,6)  end  CLSR_DATE
		, convert(varchar(20) , CLSR_DATE ,126) CLSR_DATE_1 into #Tmp_closure1 FROM CLOSURE_ACCT_CDSL 
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
  	    and CLSR_DPM_ID = @L_DPM_ID
        and isnull(CLSR_BATCH_NO,0) =0

		SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
        and CLSR_DPM_ID = @L_DPM_ID
        and isnull(CLSR_BATCH_NO,0) =0


		--select   * from #Tmp_closure1
 
		select detailshr  from (
		--select 0 id, 'CntrlSctiesDpstryPtcpt	,BrnchId	,BtchId	,SndrId	,CntrlSctiesDpstryPtcptRole	,SndrDt	,RcvDt	,RcrdNb	,RcdSRNumber	,BOTxnTyp	,ClntId	,PrdNb	,BnfcrySubTp	,Purpse	,Titl	,FrstNm	,MddlNm	,LastNm	,FSfx	,BnfcryShrtNm	,ScndHldrNmOfFthr	,BirthDt	,Gndr	,PAN	,PANVrfyFlg	,PANXmptnCd	,UID	,AdhrAuthntcnWthUID	,RsnForNonUpdtdAdhr	,VID	,SMSFclty	,PrmryISDCd	,MobNb	,FmlyFlgForMobNbOf	,ScndryISDCd	,PhneNb	,EmailAdr	,FmlyFlgForEmailAdr	,AltrnEmailAdr	,NoNmntnFlg	,MdOfOpr	,ClrMmbId	,StgInstr	,GrssAnlIncmRg	,NetWrth	,NetWrthAsOnDt	,LEI	,LEIExp	,OneTmDclrtnFlgForGSECIDT	,INIFSC	,MICRCd	,DvddCcy	,DvddBkCcy	,RBIApprvdDt	,RBIRefNb	,Mndt	,SEBIRegNb	,EdctnLvl	,AnlRptFlg	,BnfclOwnrSttlmCyclCd	,ElctrncConf	,EmailRTADwnldFlg	,GeoCd	,Xchg	,MntlDsblty	,Ntlty	,CASMd	,AncstrlFlg	,PldgStgInstrFlg	,BkAcctTp	,BnfcryAcctCtgy	,BnfcryBkAcctNb	,BnfcryBkNm	,BnfcryTaxDdctnSts	,ClrSysId	,BSDAFlg	,Ocptn	,PMSClntAcctFlg	,PMSSEBIRegnNb	,PostvConf	,FrstClntOptnToRcvElctrncStmtFlg	,ComToBeSentTo	,DelFlg	,RsnCdDeltn	,DtOfDeath	,AccntOpSrc	,CustdPmsEmailId	,POAOrDDPITp	,TradgId	,SndrRefNb1	,SndrRefNb2	,CtdnFlg	,DmtrlstnGtwy	,NmneeMnrInd	,SrlNbr	,NmneePctgOfShr	,FlgForShrPctgEqlty	,RsdlSecFlg	,RltshWthBnfclOwnr	,NbOfPOAMppng	,POAId	,POAToOprtAcct	,POAOrDDPIId	,SetUpDt	,FrDt	,ToDt	,GPABPAFlg	,POAMstrID	,PoaLnkPurpCd	,Rmk	,BOUCCLkFlg	,CnsntInd	,UnqClntId	,Brkr	,Sgmt	,MapUMapFlg	,CmAcctToMap	,PurpCd	,AdrPrefFlg	,Adr1	,Adr2	,Adr3	,Adr4	,Ctry	,PstCd	,CtrySubDvsnCd	,CitySeqNb	,FaxNb	,ITCrcl	,ProofOfRes	,NbOfCoprcnrs	,SgntryId	,SgntrSz	,BnfclOwnrAcctOfPMSFlg	,CrspdngBPId	,ClngMbrPAN	,LclAddPrsnt	,BnkAddPrsnt	,NmnorGrdnAddPrsnt	,MnrNmnGrdnAddPrsnt	,FrgnOrCorrAddPrsnt	,NbOfAuthSgnt	,AuthFlg	,CoprcnrOrMmbr	,TypMod	,SubTypMod	,StsChgRsnOrClsrRsnCd	,NmChgRsnCd	,ExctDt	,AddModDelInd	,AppKrta	,ChgKrtaRsn	,DtIntmnBO	,PrfDpstryFldFrCAS	,CoprcnrsId	,ClsrInitBy	,RmngBal	,CANm	,CertNbr	,CertXpryDt	,NbrPOASgntryReqSign	,DpstryInd	,AcctTyp	,SrcCMBPID	,TrgtDPID	,TrgtClntID	,SrlFlg	,UPIId	,SignTyp	,NBOID	,Rsvd1	,Rsvd2	,Rsvd3	,Rsvd4' details 
		select 0 id, 'CntrlSctiesDpstryPtcpt,BrnchId,BtchId,SndrId,CntrlSctiesDpstryPtcptRole,SndrDt,RcvDt,RcrdNb,RcdSRNumber,BOTxnTyp,ClntId,PrdNb,BnfcrySubTp,Purpse,Titl,FrstNm,MddlNm,LastNm,FSfx,BnfcryShrtNm,ScndHldrNmOfFthr,BirthDt,Gndr,PAN,PANVrfyFlg,PANXmptnCd,UID,AdhrAuthntcnWthUID,RsnForNonUpdtdAdhr,VID,SMSFclty,PrmryISDCd,MobNb,FmlyFlgForMobNbOf,ScndryISDCd,PhneNb,EmailAdr,FmlyFlgForEmailAdr,AltrnEmailAdr,NoNmntnFlg,MdOfOpr,ClrMmbId,StgInstr,GrssAnlIncmRg,NetWrth,NetWrthAsOnDt,LEI,LEIExp,OneTmDclrtnFlgForGSECIDT,INIFSC,MICRCd,DvddCcy,DvddBkCcy,RBIApprvdDt,RBIRefNb,Mndt,SEBIRegNb,EdctnLvl,AnlRptFlg,BnfclOwnrSttlmCyclCd,ElctrncConf,EmailRTADwnldFlg,GeoCd,Xchg,MntlDsblty,Ntlty,CASMd,AncstrlFlg,PldgStgInstrFlg,BkAcctTp,BnfcryAcctCtgy,BnfcryBkAcctNb,BnfcryBkNm,BnfcryTaxDdctnSts,ClrSysId,BSDAFlg,Ocptn,PMSClntAcctFlg,PMSSEBIRegnNb,PostvConf,FrstClntOptnToRcvElctrncStmtFlg,ComToBeSentTo,DelFlg,RsnCdDeltn,DtOfDeath,AccntOpSrc,CustdPmsEmailId,POAOrDDPITp,TradgId,SndrRefNb1,SndrRefNb2,CtdnFlg,DmtrlstnGtwy,NmneeMnrInd,SrlNbr,NmneePctgOfShr,FlgForShrPctgEqlty,RsdlSecFlg,RltshWthBnfclOwnr,NbOfPOAMppng,POAId,POAToOprtAcct,POAOrDDPIId,SetUpDt,FrDt,ToDt,GPABPAFlg,POAMstrID,PoaLnkPurpCd,Rmk,BOUCCLkFlg,CnsntInd,UnqClntId,Brkr,Sgmt,MapUMapFlg,CmAcctToMap,PurpCd,AdrPrefFlg,Adr1,Adr2,Adr3,Adr4,Ctry,PstCd,CtrySubDvsnCd,CitySeqNb,FaxNb,ITCrcl,ProofOfRes,NbOfCoprcnrs,SgntryId,SgntrSz,BnfclOwnrAcctOfPMSFlg,CrspdngBPId,ClngMbrPAN,LclAddPrsnt,BnkAddPrsnt,NmnorGrdnAddPrsnt,MnrNmnGrdnAddPrsnt,FrgnOrCorrAddPrsnt,NbOfAuthSgnt,AuthFlg,CoprcnrOrMmbr,TypMod,SubTypMod,StsChgRsnOrClsrRsnCd,NmChgRsnCd,ExctDt,AddModDelInd,AppKrta,ChgKrtaRsn,DtIntmnBO,PrfDpstryFldFrCAS,CoprcnrsId,ClsrInitBy,RmngBal,CANm,CertNbr,CertXpryDt,NbrPOASgntryReqSign,DpstryInd,AcctTyp,SrcCMBPID,TrgtDPID,TrgtClntID,SrlFlg,UPIId,SignTyp,NBOID,Rsvd1,Rsvd2,Rsvd3,Rsvd4' detailshr 
		union all 
		--select id, SUBSTRING(CLSR_BO_ID,4,5)	+','+'	,'+'	,'+ @PA_LOGINNAME+'	,'+'	,'+left(CLSR_DATE_1	,10) +','+CLSR_DATE_1	+','+convert(varchar(100),id )+','+convert(varchar(100),id )+','+'BOCLS'	+','+CLSR_BO_ID	+',	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,' + isnull(CLSR_REQ_INT_REFNO	,'') +',	,	,	,	,	,	,	,	,	,	,	,	,	,	,,	,	,	,	,'+clsr_rmks+',	,	,,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,'+citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd',CLSR_REASON_CD)	+',	,	,	,	,	,	,	,	,'+citrus_usr.fn_get_standard_value_harm('ClsrInitBy',CLSR_INI_BY)+' 	,NA	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,'
		select id, SUBSTRING(CLSR_BO_ID,4,5)+','+','+','+ @PA_LOGINNAME+','+','+left(CLSR_DATE_1,10) +','+CLSR_DATE_1+','+convert(varchar(100),id )+','+convert(varchar(100),id )+','+'BOCLS'+','+CLSR_BO_ID+',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' + isnull(CLSR_REQ_INT_REFNO,'') +',,,,,,,,,,,,,,,,,,,,'+clsr_rmks+',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'+citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd',CLSR_REASON_CD)+',,,,,,,,,'+citrus_usr.fn_get_standard_value_harm('ClsrInitBy',CLSR_INI_BY)+',NA,,,,,,,,,,,,,,,,,'
		from #Tmp_closure1 
		--left outer join 
		--STANDARD_VALUE_LIST  BOTxnTyp  on BOTxnTyp.ISO_Tags ='BOTxnTyp'  and BOTxnTyp.CDSL_Old_Values <> '' 
		--and EFTSCd = EFTSCd.Standard_Value
		) a 
		order by id 



---Select * from CLOSURE_ACCT_CDSL 

--SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
--WHERE  CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)  AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
				 
PRINT(@L_TOT_REC)
	IF @L_TOT_REC > 0 
    BEGIN         
          /* UPDATE IN BITMAP_REF_MSTR TABLE */         
          if @PA_BATCH_TYPE = 'CDSL'
          Begin

		  

 		    UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 

 	      
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
            and isnull(CLSR_BATCH_NO,0) =0

--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_TYPE = 'AC' AND BATCHC_TRANS_TYPE = 'ACCOUNT CLOSURE' AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS,
                   BATCHC_STATUS,          
                   BATCHC_TRANS_TYPE,      
                   BATCHC_FILEGEN_DT,                 
                   BATCHC_CREATED_BY,        
                   BATCHC_CREATED_DT ,        
                   BATCHC_DELETED_IND, 
                   BATCHC_TYPE       
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),
                   'P',       
				   'ACCOUNT CLOSURE',      
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1 ,
                   'AC'       
                  ) 
  
            END
		END 
	
        else
        Begin
            UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'NSDL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  print 'sac'
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
 
--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_TYPE = 'AC' AND BATCHN_TRANS_TYPE = 'ACCOUNT CLOSURE' AND BATCHN_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_NSDL_MSTR                                             
                  (          
                   BATCHN_DPM_ID,        
                   BATCHN_NO,        
                   BATCHN_RECORDS,        
                   BATCHN_STATUS,      
                   BATCHN_TRANS_TYPE,                 
                   BATCHN_FILEGEN_DT,        
                   BATCHN_CREATED_BY,        
                   BATCHN_CREATED_DT ,
                   BATCHN_DELETED_IND,
                   BATCHN_TYPE        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'P',
                   'ACCOUNT CLOSURE', 
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00',     
                   @PA_LOGINNAME,
                   getdate() , 
                   1,
                   'AC'        
                  ) 
  
				END 
           END               
		END
END
    --
    END
    ELSE IF @pa_broker_yn = 'N'
    BEGIN
    --
      						

IF @L_TRX_TAB= 'CLSR_ACCT_GEN'         
      BEGIN  
           
Print 'N'

 SELECT CONVERT(VARCHAR(16),ISNULL(CLSR_BO_ID,''))AS CLSR_BO_ID ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_TRX_TYPE,''))AS CLSR_TRX_TYPE,
		CONVERT(VARCHAR(2),ISNULL(CLSR_INI_BY,''))AS CLSR_INI_BY ,
		CONVERT(VARCHAR(2),ISNULL(CLSR_REASON_CD,'')) AS CLSR_REASON_CD ,
		CONVERT(VARCHAR(1),ISNULL(CLSR_REMAINING_BAL,''))AS CLSR_REMAINING_BAL ,
		CONVERT(VARCHAR(16),ISNULL(CLSR_NEW_BO_ID,''))AS CLSR_NEW_BO_ID ,
		CONVERT(VARCHAR(100),ISNULL(CLSR_RMKS,'')) AS CLSR_RMKS,
		CONVERT(VARCHAR(16),ISNULL(CLSR_ID,0)) AS CLSR_REQ_INT_REFNO  
		,identity(numeric,1,1) id 
		, convert(varchar(20) , CLSR_DATE ,126) CLSR_DATE_1 into #Tmp_closure FROM CLOSURE_ACCT_CDSL 
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
  	    and CLSR_DPM_ID = @L_DPM_ID

		SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
        and CLSR_DPM_ID = @L_DPM_ID
        and isnull(CLSR_BATCH_NO,0) =0

---Select * from CLOSURE_ACCT_CDSL 

--SELECT @L_TOT_REC = COUNT(CLSR_ID) FROM CLOSURE_ACCT_CDSL      
--WHERE  CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)  AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
			
			
			

				select detailshr  from (
		--select 0 id, 'CntrlSctiesDpstryPtcpt	,BrnchId	,BtchId	,SndrId	,CntrlSctiesDpstryPtcptRole	,SndrDt	,RcvDt	,RcrdNb	,RcdSRNumber	,BOTxnTyp	,ClntId	,PrdNb	,BnfcrySubTp	,Purpse	,Titl	,FrstNm	,MddlNm	,LastNm	,FSfx	,BnfcryShrtNm	,ScndHldrNmOfFthr	,BirthDt	,Gndr	,PAN	,PANVrfyFlg	,PANXmptnCd	,UID	,AdhrAuthntcnWthUID	,RsnForNonUpdtdAdhr	,VID	,SMSFclty	,PrmryISDCd	,MobNb	,FmlyFlgForMobNbOf	,ScndryISDCd	,PhneNb	,EmailAdr	,FmlyFlgForEmailAdr	,AltrnEmailAdr	,NoNmntnFlg	,MdOfOpr	,ClrMmbId	,StgInstr	,GrssAnlIncmRg	,NetWrth	,NetWrthAsOnDt	,LEI	,LEIExp	,OneTmDclrtnFlgForGSECIDT	,INIFSC	,MICRCd	,DvddCcy	,DvddBkCcy	,RBIApprvdDt	,RBIRefNb	,Mndt	,SEBIRegNb	,EdctnLvl	,AnlRptFlg	,BnfclOwnrSttlmCyclCd	,ElctrncConf	,EmailRTADwnldFlg	,GeoCd	,Xchg	,MntlDsblty	,Ntlty	,CASMd	,AncstrlFlg	,PldgStgInstrFlg	,BkAcctTp	,BnfcryAcctCtgy	,BnfcryBkAcctNb	,BnfcryBkNm	,BnfcryTaxDdctnSts	,ClrSysId	,BSDAFlg	,Ocptn	,PMSClntAcctFlg	,PMSSEBIRegnNb	,PostvConf	,FrstClntOptnToRcvElctrncStmtFlg	,ComToBeSentTo	,DelFlg	,RsnCdDeltn	,DtOfDeath	,AccntOpSrc	,CustdPmsEmailId	,POAOrDDPITp	,TradgId	,SndrRefNb1	,SndrRefNb2	,CtdnFlg	,DmtrlstnGtwy	,NmneeMnrInd	,SrlNbr	,NmneePctgOfShr	,FlgForShrPctgEqlty	,RsdlSecFlg	,RltshWthBnfclOwnr	,NbOfPOAMppng	,POAId	,POAToOprtAcct	,POAOrDDPIId	,SetUpDt	,FrDt	,ToDt	,GPABPAFlg	,POAMstrID	,PoaLnkPurpCd	,Rmk	,BOUCCLkFlg	,CnsntInd	,UnqClntId	,Brkr	,Sgmt	,MapUMapFlg	,CmAcctToMap	,PurpCd	,AdrPrefFlg	,Adr1	,Adr2	,Adr3	,Adr4	,Ctry	,PstCd	,CtrySubDvsnCd	,CitySeqNb	,FaxNb	,ITCrcl	,ProofOfRes	,NbOfCoprcnrs	,SgntryId	,SgntrSz	,BnfclOwnrAcctOfPMSFlg	,CrspdngBPId	,ClngMbrPAN	,LclAddPrsnt	,BnkAddPrsnt	,NmnorGrdnAddPrsnt	,MnrNmnGrdnAddPrsnt	,FrgnOrCorrAddPrsnt	,NbOfAuthSgnt	,AuthFlg	,CoprcnrOrMmbr	,TypMod	,SubTypMod	,StsChgRsnOrClsrRsnCd	,NmChgRsnCd	,ExctDt	,AddModDelInd	,AppKrta	,ChgKrtaRsn	,DtIntmnBO	,PrfDpstryFldFrCAS	,CoprcnrsId	,ClsrInitBy	,RmngBal	,CANm	,CertNbr	,CertXpryDt	,NbrPOASgntryReqSign	,DpstryInd	,AcctTyp	,SrcCMBPID	,TrgtDPID	,TrgtClntID	,SrlFlg	,UPIId	,SignTyp	,NBOID	,Rsvd1	,Rsvd2	,Rsvd3	,Rsvd4' details 
		select 0 id, 'CntrlSctiesDpstryPtcpt,BrnchId,BtchId,SndrId,CntrlSctiesDpstryPtcptRole,SndrDt,RcvDt,RcrdNb,RcdSRNumber,BOTxnTyp,ClntId,PrdNb,BnfcrySubTp,Purpse,Titl,FrstNm,MddlNm,LastNm,FSfx,BnfcryShrtNm,ScndHldrNmOfFthr,BirthDt,Gndr,PAN,PANVrfyFlg,PANXmptnCd,UID,AdhrAuthntcnWthUID,RsnForNonUpdtdAdhr,VID,SMSFclty,PrmryISDCd,MobNb,FmlyFlgForMobNbOf,ScndryISDCd,PhneNb,EmailAdr,FmlyFlgForEmailAdr,AltrnEmailAdr,NoNmntnFlg,MdOfOpr,ClrMmbId,StgInstr,GrssAnlIncmRg,NetWrth,NetWrthAsOnDt,LEI,LEIExp,OneTmDclrtnFlgForGSECIDT,INIFSC,MICRCd,DvddCcy,DvddBkCcy,RBIApprvdDt,RBIRefNb,Mndt,SEBIRegNb,EdctnLvl,AnlRptFlg,BnfclOwnrSttlmCyclCd,ElctrncConf,EmailRTADwnldFlg,GeoCd,Xchg,MntlDsblty,Ntlty,CASMd,AncstrlFlg,PldgStgInstrFlg,BkAcctTp,BnfcryAcctCtgy,BnfcryBkAcctNb,BnfcryBkNm,BnfcryTaxDdctnSts,ClrSysId,BSDAFlg,Ocptn,PMSClntAcctFlg,PMSSEBIRegnNb,PostvConf,FrstClntOptnToRcvElctrncStmtFlg,ComToBeSentTo,DelFlg,RsnCdDeltn,DtOfDeath,AccntOpSrc,CustdPmsEmailId,POAOrDDPITp,TradgId,SndrRefNb1,SndrRefNb2,CtdnFlg,DmtrlstnGtwy,NmneeMnrInd,SrlNbr,NmneePctgOfShr,FlgForShrPctgEqlty,RsdlSecFlg,RltshWthBnfclOwnr,NbOfPOAMppng,POAId,POAToOprtAcct,POAOrDDPIId,SetUpDt,FrDt,ToDt,GPABPAFlg,POAMstrID,PoaLnkPurpCd,Rmk,BOUCCLkFlg,CnsntInd,UnqClntId,Brkr,Sgmt,MapUMapFlg,CmAcctToMap,PurpCd,AdrPrefFlg,Adr1,Adr2,Adr3,Adr4,Ctry,PstCd,CtrySubDvsnCd,CitySeqNb,FaxNb,ITCrcl,ProofOfRes,NbOfCoprcnrs,SgntryId,SgntrSz,BnfclOwnrAcctOfPMSFlg,CrspdngBPId,ClngMbrPAN,LclAddPrsnt,BnkAddPrsnt,NmnorGrdnAddPrsnt,MnrNmnGrdnAddPrsnt,FrgnOrCorrAddPrsnt,NbOfAuthSgnt,AuthFlg,CoprcnrOrMmbr,TypMod,SubTypMod,StsChgRsnOrClsrRsnCd,NmChgRsnCd,ExctDt,AddModDelInd,AppKrta,ChgKrtaRsn,DtIntmnBO,PrfDpstryFldFrCAS,CoprcnrsId,ClsrInitBy,RmngBal,CANm,CertNbr,CertXpryDt,NbrPOASgntryReqSign,DpstryInd,AcctTyp,SrcCMBPID,TrgtDPID,TrgtClntID,SrlFlg,UPIId,SignTyp,NBOID,Rsvd1,Rsvd2,Rsvd3,Rsvd4' detailshr 
		union all 
		--select id, SUBSTRING(CLSR_BO_ID,4,5)	+','+'	,'+'	,'+ @PA_LOGINNAME+'	,'+'	,'+left(CLSR_DATE_1	,10) +','+CLSR_DATE_1	+','+convert(varchar(100),id )+','+convert(varchar(100),id )+','+'BOCLS'	+','+CLSR_BO_ID	+',	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,' + isnull(CLSR_REQ_INT_REFNO	,'') +',	,	,	,	,	,	,	,	,	,	,	,	,	,	,,	,	,	,	,'+clsr_rmks+',	,	,,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,'+citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd',CLSR_REASON_CD)	+',	,	,	,	,	,	,	,	,'+citrus_usr.fn_get_standard_value_harm('ClsrInitBy',CLSR_INI_BY)+' 	,NA	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,	,'
		select id, SUBSTRING(CLSR_BO_ID,4,5)+','+','+','+ @PA_LOGINNAME+','+','+left(CLSR_DATE_1,10) +','+CLSR_DATE_1+','+convert(varchar(100),id )+','+convert(varchar(100),id )+','+'BOCLS'+','+CLSR_BO_ID+',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' + isnull(CLSR_REQ_INT_REFNO,'') +',,,,,,,,,,,,,,,,,,,,'+clsr_rmks+',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'+citrus_usr.fn_get_standard_value_harm('StsChgRsnOrClsrRsnCd',CLSR_REASON_CD)+',,,,,,,,,'+citrus_usr.fn_get_standard_value_harm('ClsrInitBy',CLSR_INI_BY)+',NA,,,,,,,,,,,,,,,,,'
		from #Tmp_closure 
		--left outer join 
		--STANDARD_VALUE_LIST  BOTxnTyp  on BOTxnTyp.ISO_Tags ='BOTxnTyp'  and BOTxnTyp.CDSL_Old_Values <> '' 
		--and EFTSCd = EFTSCd.Standard_Value
		) a 
		order by id 





PRINT(@L_TOT_REC)
	IF @L_TOT_REC > 0 
	
BEGIN         
          /* UPDATE IN BITMAP_REF_MSTR TABLE */         
          if @PA_BATCH_TYPE = 'CDSL'
          Begin
 		    UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'CDSL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  print 'hetal'
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
            and isnull(CLSR_BATCH_NO,0) =0

--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHC_NO FROM BATCHNO_CDSL_MSTR   WHERE BATCHC_NO  = @PA_BATCH_NO AND BATCHC_DPM_ID = @L_DPM_ID AND BATCHC_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_CDSL_MSTR                                             
                  (          
                   BATCHC_DPM_ID,        
                   BATCHC_NO,        
                   BATCHC_RECORDS,        
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
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'ACCOUNT CLOSURE',      
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00'  ,      
                   'T',        
                   'AC',        
                   @PA_LOGINNAME,        
                   GETDATE(),        
                   1        
                  ) 
  
            END
			END  
        else
        Begin
            UPDATE BITMAP_REF_MSTR SET BITRM_VALUES = CONVERT(VARCHAR,(CONVERT(BIGINT,@PA_BATCH_NO) + 1))             
            WHERE   BITRM_PARENT_CD = 'NSDL_BTCH_CLOSURE_CURNO' AND BITRM_CHILD_CD = @L_DPM_ID AND BITRM_BIT_LOCATION = @PA_EXCSM_ID 
 	  
 	      print(@PA_BATCH_NO)
		   UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO =  @PA_BATCH_NO 
		   WHERE CONVERT(DATETIME,CONVERT(VARCHAR(11),CLSR_DATE,109)) BETWEEN @PA_FROM_DT  AND @PA_TO_DT       
 			and CLSR_DPM_ID = @L_DPM_ID
 
--           UPDATE CLOSURE_ACCT_CDSL SET CLSR_BATCH_NO = @PA_BATCH_NO 
--		   WHERE CLSR_DATE BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106) AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)        
-- 			
-- 
          /* INSERT INTO BATCHNO_CDSL_MSTR */                          
				
			IF NOT EXISTS(SELECT BATCHN_NO FROM BATCHNO_NSDL_MSTR   WHERE BATCHN_NO  = @PA_BATCH_NO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_DELETED_IND =1)        
                 BEGIN        
                  INSERT INTO BATCHNO_NSDL_MSTR                                             
                  (          
                   BATCHN_DPM_ID,        
                   BATCHN_NO,        
                   BATCHN_RECORDS,        
                   BATCHN_STATUS,      
                   BATCHN_TRANS_TYPE,                 
                   BATCHN_FILEGEN_DT,        
                   BATCHN_CREATED_BY,        
                   BATCHN_CREATED_DT ,
                   BATCHN_DELETED_IND,
                   BATCHN_TYPE        
                  )        
                  VALUES        
                  (        
                   @L_DPM_ID,        
                   @PA_BATCH_NO,        
                   CONVERT(NUMERIC,@L_TOT_REC),       
				   'P',
                   'ACCOUNT CLOSURE', 
                   CONVERT(VARCHAR,CONVERT(DATETIME,@PA_FROM_DT,103),106)+' 00:00:00',     
                   @PA_LOGINNAME,
                   getdate() , 
                   1,
                   'AC'        
                  ) 
  
				END 
           END               
		END
	END 


    --
    END
  --  
  END  
  --  
  END  
    
--  
END

GO
