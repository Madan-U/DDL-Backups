-- Object: PROCEDURE citrus_usr.pr_missing_poa_fromdps8pc5
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran   
--exec pr_missing_poa_fromdps8pc5 
--select COUNT(1) from dp_poa_dtls--827083 
--select * from dp_poa_dtls , dp_acct_mstr where DPPD_DPAM_ID = DPAM_ID and dpam_sba_no ='1203320009681210'
--rollback  
CREATE proc [citrus_usr].[pr_missing_poa_fromdps8pc5]  
as  
begin   
DECLARE @C_CLIENT_SUMMARY CURSOR, @C_BEN_ACCT_NO1 VARCHAR(16), @L_CLIENT_VALUES VARCHAR(8000), @L_CRN_NO NUMERIC, @L_DPM_DPID VARCHAR(20), @L_COMPM_ID NUMERIC, @L_DP_ACCT_VALUES VARCHAR(8000), @L_EXCSM_ID NUMERIC, @L_ADR VARCHAR(8000), @L_CONC VARCHAR(8000), @L_BR_SH_NAME VARCHAR(50), @L_ENTR_VALUE VARCHAR(8000), @L_DPBA_VALUES VARCHAR(8000), @L_ENTP_VALUE VARCHAR(8000), @C_CX_PANNO VARCHAR(50), @L_ENTPD_VALUE VARCHAR(8000), @L_ACCP_VALUE VARCHAR(8000), @L_ACCPD_VALUE VARCHAR(8000), @L_DPAM_ID NUMERIC, @L_BANK_NAME VARCHAR(150), @L_ADDR_VALUE VARCHAR(8000), @L_BANM_BRANCH VARCHAR(250), @L_MICR_NO VARCHAR(20), @L_BANM_ID NUMERIC, @L_ACC_CONC VARCHAR(8000), @L_CLI_EXISTS_YN CHAR(1), @@BOCTGRY VARCHAR(10), @@HO_CD VARCHAR(20), @L_DPPD_DETAILS VARCHAR(8000), @@l_error INTEGER   
   
 DECLARE @pa_ref_no VARCHAR(100)  
  
select DPAM_SBA_NO into #tempdata  from dp_acct_mstr where DPAM_CREATED_DT >='Jul 04 2015'-- and DPAM_STAM_CD = 'active'
and DPAM_ACCT_NO <> DPAM_SBA_NO
and exists (select boid from dps8_pc5 where DPAM_SBA_NO = boid)-- and DPAM_ACCT_NO not like 'W%'
and DPAM_CREATED_DT >'Jul 29 2015' 
and   not  exists   (select dppd_dpam_id from dp_poa_dtls where DPPD_DPAM_ID = DPAM_ID) 
and DPAM_CREATED_DT <='aug 09 2016' 
    
    
 SET @C_CLIENT_SUMMARY = CURSOR FAST_FORWARD  
 FOR  
select distinct  boid from dps8_pc5 where boid in (select dpam_sba_no from #tempdata)

    
  OPEN @C_CLIENT_SUMMARY  
  
 FETCH NEXT  
 FROM @C_CLIENT_SUMMARY  
 INTO @C_BEN_ACCT_NO1  
  
 WHILE @@FETCH_STATUS = 0  
 BEGIN --#CURSOR       
		  if not exists(select dppd_id from dp_poa_dtls , dps8_pc5 
		, dp_acct_mstr 
		where dpam_id = dppd_dpam_id 
		and BOID = dpam_sba_no 
		and dpam_sba_no = @c_ben_acct_no1
		and dppd_master_id =  MasterPOAId
		and dppd_poa_id = POARegNum
		)  
		  
		begin  
		   

		 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
		 where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(BOID,8) from dps8_pc5)
		  
		 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
		  
		 select distinct @l_crn_no = dpam_crn_no from dp_acct_mstr, dps8_pc5 WHERE BOID = @c_ben_acct_no1 AND dpam_sba_no  =BOID
		  
		 SET @l_dppd_details = ''  
		  
		-- SELECT @l_dppd_details = @l_dppd_details  + isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end +'|*~|'+ISNULL(ltrim(rtrim(dpam_sba_name)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(POARegNum)),'')+'|*~|'+ISNULL(ltrim(rtrim(GPABPAFlg)),'')  
		--  
		-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate) ,103),103) ELSE '' END   
		--  
		-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103),103) ELSE '' END   
		--  
		-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103),103) ELSE '' END   
		--  
		-- +'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
		--  
		-- FROM dps8_pc5 , dp_acct_mstr WHERE left(dpam_sba_no ,2) ='22' and MasterPOAId = dpam_sba_no and  boid = @c_ben_acct_no1 AND POARegNum <>''   
		--  

		SELECT @l_dppd_details = @l_dppd_details  + isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end +'|*~|'+ISNULL(ltrim(rtrim(dpam_sba_name)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(POARegNum)),'')+'|*~|'+ISNULL(ltrim(rtrim(GPABPAFlg)),'')  
		  
		 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate) ,103),103) ELSE '' END   
		  
		 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103),103) ELSE '' END   
		  
		 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103),103) ELSE '' END   
		  
		 +'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|'+'0|*~|'+'0|*~|'+'A*|~*'  
		  
		 FROM dps8_pc5 , citrus_usr.poam WHERE left(poam_master_id ,2) ='22' 
		 and MasterPOAId = poam_master_id 
		 and  boid = @c_ben_acct_no1 AND POARegNum <>''   
		  

		  print @l_dppd_details
		  print @l_crn_no

		  EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
		  
end  

FETCH NEXT  
 FROM @C_CLIENT_SUMMARY  
 INTO @C_BEN_ACCT_NO1  
 
   --    
 END  
  
 CLOSE @C_CLIENT_SUMMARY  
  
 DEALLOCATE @C_CLIENT_SUMMARY  
   
   
end

GO
