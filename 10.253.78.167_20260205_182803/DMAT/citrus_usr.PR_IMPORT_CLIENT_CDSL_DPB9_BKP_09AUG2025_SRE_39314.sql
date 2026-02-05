-- Object: PROCEDURE citrus_usr.PR_IMPORT_CLIENT_CDSL_DPB9_BKP_09AUG2025_SRE_39314
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------





CREATE PROCEDURE  [citrus_usr].[PR_IMPORT_CLIENT_CDSL_DPB9_BKP_09AUG2025_SRE_39314]
			(
			 @pa_exch          VARCHAR(20)    
            ,@pa_login_name    VARCHAR(20)    
            ,@pa_mode          VARCHAR(10)                                    
            ,@pa_db_source     VARCHAR(250)    
            ,@rowdelimiter     CHAR(4) =     '*|~*'      
            ,@coldelimiter     CHAR(4) =     '|*~|'      
            ,@pa_errmsg        VARCHAR(8000) output    
            )      
AS    
/*    
*********************************************************************************    
 SYSTEM         : Dp    
 MODULE NAME    : p  
 DESCRIPTION    : This Procedure Will Contain The Update Queries For Master Tables    
 COPYRIGHT(C)   : Marketplace Technologies     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            08-OCT-2007   VERSION.    
-----------------------------------------------------------------------------------*/    
BEGIN    
 --
-- 

INSERT INTO DPB9LOG
SELECT GETDATE(),'DPB9 MAIN','START'
 
set nocount ON  
  
set dateformat dmy
 
declare @l_err varchar (100)
set @l_err = ''
exec  pr_file_validation  @pa_tab =  'dpb9' ,@pa_sub_tab = 'Duplicate' , @pa_task_id = ''  ,@pa_mode =@pa_mode ,@pa_db_source = @pa_db_source,@pa_errmsg        = @l_err

if @l_err = 'return'
begin
				return
end
 

 declare @c_client_summary cursor  
           , @c_ben_acct_no    VARCHAR(16)  
           , @L_CLIENT_VALUES  VARCHAR(8000)  
           , @l_crn_no numeric  
           , @l_dpm_dpid varchar(20)  
           , @l_compm_id numeric  
           , @l_dp_acct_values varchar(8000)  
           , @l_excsm_id numeric  
           , @L_ADR varchar(8000)  
           , @L_CONC varchar(8000)  
           , @l_br_sh_name varchar(50)  
           , @l_entr_value varchar(8000)  
           , @l_dpba_values varchar(8000)  
           , @l_entp_value varchar(8000)  
           , @c_cx_panno  varchar(50)  
           , @l_entpd_value varchar(8000)  
           , @L_ACCP_VALUE  VARCHAR(8000)  
           , @L_ACCPD_VALUE  VARCHAR(8000)  
           , @L_DPAM_ID NUMERIC  
           , @L_BANK_NAME VARCHAR(150)  
           , @L_ADDR_VALUE VARCHAR(8000)  
           , @L_BANM_BRANCH VARCHAR(250)  
           , @L_MICR_NO VARCHAR(20)  
           , @L_BANM_ID NUMERIC  
           , @L_acc_conc VARCHAR(8000)   
           , @l_cli_exists_yn char(1)  
		   , @@BOCTGRY VARCHAR(10)  
		   , @@ho_cd varchar(20)  
		   , @l_dppd_details varchar(8000)  
		  
       
  select top 1 @@ho_cd = ltrim(rtrim(isnull(entm_short_name,'HO'))) from entity_mstr where entm_enttm_cd = 'HO'  

update a set dpam_bbo_code=accp_value from dp_acct_mstr  a
,account_properties
where isnull(dpam_bbo_code,'')<>accp_value
and accp_lst_upd_dt >='sep  1 2012'
and accp_clisba_id = dpam_id 
and ACCP_ACCPM_PROP_CD = 'bbo_code' 
                         
   /*BULK IMPORT*//*Changed on 26/06/12 by Tushar */ 


insert into dpb9log
select GETDATE(),'dpb9','start'
  

  EXEC PR_BULK_INS_DPB9  @PA_EXCH     = @pa_exch
            ,@PA_LOGIN_NAME    =@pa_login_name
            ,@PA_MODE          =@pa_mode
            ,@PA_DB_SOURCE     =@pa_db_source
            ,@ROWDELIMITER     ='*|~*'   
            ,@COLDELIMITER     ='|*~|'    
            ,@PA_ERRMSG        =''
 
 
 

set dateformat ymd

declare @l_exp_boid varchar(8000)
set @l_exp_boid  = ''

select @l_exp_boid = @l_exp_boid  + boid + ','  
FROM dpb9_pc1
where ISDATE(right(DATEOFBIRTH,4)+'-'+substring(DATEOFBIRTH,3,2)+'-'+left(DATEOFBIRTH,2)) =0 
and DATEOFBIRTH <> ''
and BOAcctStatus <> '3' 



if isnull(@l_exp_boid,'') <> '' 
begin 


UPDATE filetask
SET   usermsg = isnull(usermsg ,'') + 'Following client have invalid date of birth please correct and re import file.' + @l_exp_boid 
WHERE  task_id = (select TOP 1 TASK_ID  from filetask where TASK_NAME LIKE 'CLIENT MASTER IMPORT-DPB9DPS8-CDSL%' AND STATUS = 'RUNNING' )

end 


set dateformat dmy 

 
 
 insert into dpb9log
select GETDATE(),'dpb9','end'

--if exists (select top 1 substring(value,4,8), * from vwdps8_source where value like '00%' and substring(value,4,8)= '12033201')
--begin 

-- 

--end 



  
 insert into dpb9log
select GETDATE(),'dps8','start'

exec pr_bulk_dps8 @pa_db_source
 
 insert into dpb9log
select GETDATE(),'dps8','end'

 

 
insert into client_incr
select boid from dpb9_pc0


insert into PDB9_pc22_bak_dnd 
select *  from dpb9_pc22 

 insert into dpb9log
select GETDATE(),'insert into dps8_source111_bak_dnd','start'

insert into dps8_source111_bak_dnd
select value,boid,lastmoddate , getdate () dt   from dps8_source111 
where citrus_usr.fn_splitval_by(value,1,'~') <>'00'


select citrus_usr.fn_splitval_by(value,3,'~') poa 
, boid  boid 
,citrus_usr.fn_splitval_by(value,10,'~') hold
,citrus_usr.fn_splitval_by(value,4,'~') regn
, citrus_usr.fn_splitval_by(value,2,'~') tt
,citrus_usr.fn_splitval_by(value,5,'~') rd
into #temppc5  
from dps8_source111 
where citrus_usr.fn_splitval_by(value,1,'~') ='05'
and citrus_usr.fn_splitval_by(value,2,'~') ='3'
  
 
update pc5 
set pc5.typeoftrans = tp.tt
from  dps8_pc5 pc5 , #temppc5 tp
  where pc5.boid = tp.boid 
  and pc5.MasterPOAId = tp.poa
  and pc5.POARegNum = tp.regn 
  and pc5.HolderNum = tp.hold
  and pc5.typeoftrans <> tp.tt
    and pc5.SetupDate = rd

 insert into dpb9log
select GETDATE(),'insert into dps8_source111_bak_dnd','end'


-- below part commented on 28032023 as this is update cliba flg as 0-- Tp and yogesh


--insert into dpb9log
--select GETDATE(),'PR_REMOVE_DUPLICATE_DEF_BANK','start'

--EXEC PR_REMOVE_DUPLICATE_DEF_BANK 	-- added to remove default bank mapping issue to client on Sep 29 2016 

--insert into dpb9log
--select GETDATE(),'PR_REMOVE_DUPLICATE_DEF_BANK','end'

-- below part commented on 28032023 as this is update cliba flg as 0-- Tp and yogesh
 
  /*BULK IMPORT*//*Changed on 26/06/12 by Tushar */
--  
--delete from dpb9_pc0 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914' ) 
--delete from dpb9_pc1 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914' ) 
--delete from dpb9_pc2   where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc3  where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc4  where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc5  where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc6  where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc7  where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc8  where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc12 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc16 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc17 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc18 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--delete  from dpb9_pc19 where boid  in (select ca_cmcd from MOSL_EDP_Client_modification where ca_authdt = '20130914') 
--
--


insert into dpb9log
select GETDATE(),'old bulk update','end'
/*Changed on 26/06/12 by Tushar */ 

     INSERT INTO [TMP_POA_DTLS_MSTR_CDSL]  
     SELECT  * FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_CUST_PROD_NO IN ('48','49')  
     DELETE FROM TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_CUST_PROD_NO IN ('48','49')  

/*Changed on 26/06/12 by Tushar */ 

       
       
     IF EXISTS(SELECT BITRM_ID FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD = 'POA_CLIENT_IMPORT_YN' AND BITRM_BIT_LOCATION = 1)  
     BEGIN
      
          update clim  
          set clim_name1 = ltrim(rtrim(isnull(Name,'')))
             ,clim_name2 =  ltrim(rtrim(isnull(MiddleName,'')))
             ,clim_name3 =  ltrim(rtrim(isnull(SearchName,'')))
             ,clim_dob = CASE WHEN ISDATE(CONVERT(DATETIME,CITRUS_USR.FNGETDATE(DATEOFBIRTH),103)) = 1 THEN  ISNULL(CITRUS_USR.FNGETDATE(DATEOFBIRTH),'') ELSE 'JAN 01 1900' END 
             ,clim_gender = ISNULL(SEXCD,'')  
          from  client_mstr CLIM  
               ,dp_acct_mstr ,DPB9_PC1  
          where  dpam_sba_no =  BOID  
          and    clim_crn_no =  dpam_crn_no   
  
							

			Update dpam 
			set    dpam_stam_cd =  CASE WHEN BOACCTSTATUS ='1' THEN 'ACTIVE'
								  --WHEN BOACCTSTATUS ='2' THEN '02'
									WHEN BOACCTSTATUS ='2' THEN '04'  -- changed as per CDAS code on 29042013
									WHEN BOACCTSTATUS ='3' THEN '05'
									WHEN BOACCTSTATUS ='4' THEN '04'
									WHEN BOACCTSTATUS ='5' THEN '05' 
									WHEN BOACCTSTATUS ='6' THEN '06' ELSE CONVERT(VARCHAR(10),BOACCTSTATUS ) END
			,DPAM_CLICM_CD = CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END 
			,DPAM_ENTTM_cD = CASE WHEN LEN(BOCATEGORY)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'  ELSE CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'   END 
			,DPAM_SUBCM_CD = CASE WHEN LEN(ProdCode)=1 THEN '0'+ CONVERT(VARCHAR(10),ProdCode)  ELSE CONVERT(VARCHAR(10),ProdCode)   END + CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END  + CASE WHEN LEN(BOSUBSTATUS)=1 THEN '0'+CONVERT(VARCHAR(10),BOSUBSTATUS)    ELSE CONVERT(VARCHAR(10),BOSUBSTATUS) END   
            ,dpam_lst_upd_dt = getdate()
			,dpam_sba_name = ltrim(rtrim(isnull(Name,''))) + ' ' + ltrim(rtrim(isnull(MiddleName,''))) + ' ' + ltrim(rtrim(isnull(SearchName,'')))
			from   dp_acct_mstr dpam
			, DPB9_PC1
			where  dpam_sba_no =  BOID and  dpam_stam_cd not in ('02_BILLSTOP' , '05' )

			--below update written to update sub category as corporate body domestic on 26/06/2013
			update dp_acct_mstr set dpam_subcm_cd = '022512' where dpam_subcm_cd = '402512'            
			update dp_acct_mstr set dpam_subcm_cd = '012182' where dpam_subcm_cd = '082182'  
       
/*Changed on 26/06/12 by Tushar */ 

			Update dpam set dPAM_SUBCM_CD = CASE WHEN LEN(ProdCode)=1 THEN '0'+ CONVERT(VARCHAR(10),ProdCode)  ELSE CONVERT(VARCHAR(10),ProdCode)   END + CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END  + CASE WHEN LEN(BOSUBSTATUS)=1 THEN '0'+CONVERT(VARCHAR(10),BOSUBSTATUS)    ELSE CONVERT(VARCHAR(10),BOSUBSTATUS) END   
			from   dp_acct_mstr dpam
			, DPb9_PC1
			where  dpam_sba_no =  BOID and  dpam_stam_cd not in ('02_BILLSTOP' , '05' )
			and dpam_subcm_cd = ''


		UPDATE DPHD
		SET    DPHD_FH_FTHNAME  = ltrim(rtrim(FTHNAME))
		,DPHD_LST_UPD_DT = GETDATE()
		FROM   DP_HOLDER_DTLS DPHD
		, DPB9_PC1
		WHERE  DPHD_DPAM_SBA_NO =  BOID 
		
		UPDATE DPHD
		SET    DPHD_SH_FNAME = ltrim(rtrim(NAME))
			,DPHD_SH_MNAME =ltrim(rtrim(MIDDLENAME))
			,DPHD_SH_LNAME=ltrim(rtrim(SEARCHNAME))
			,DPHD_SH_FTHNAME=ltrim(rtrim(FTHNAME))
			--,DPHD_SH_DOB=case when DATEOFBIRTH <> '' then left(DATEOFBIRTH,2)+'/'+substring(DATEOFBIRTH,3,2) + '/' + right(DATEOFBIRTH,4) else DATEOFBIRTH end 
			,DPHD_SH_PAN_NO=PANGIR
			,DPHD_LST_UPD_DT = GETDATE()
		FROM   DP_HOLDER_DTLS DPHD
		, DPB9_PC2
		WHERE  DPHD_DPAM_SBA_NO =  BOID 
		
		UPDATE DPHD
		SET    DPHD_TH_FNAME = ltrim(rtrim(NAME))
			,DPHD_TH_MNAME =ltrim(rtrim(MIDDLENAME))
			,DPHD_TH_LNAME=ltrim(rtrim(SEARCHNAME))
			,DPHD_TH_FTHNAME=ltrim(rtrim(FTHNAME))
			--,DPHD_TH_DOB=case when DATEOFBIRTH <> '' then left(DATEOFBIRTH,2)+'/'+substring(DATEOFBIRTH,3,2) + '/' + right(DATEOFBIRTH,4) else DATEOFBIRTH end 
			,DPHD_TH_PAN_NO=PANGIR
			,DPHD_LST_UPD_DT = GETDATE()
		FROM   DP_HOLDER_DTLS DPHD
		, DPB9_PC3
		WHERE  DPHD_DPAM_SBA_NO =  BOID 
		
--		UPDATE DPHD
--		SET    DPHD_NOM_FNAME = ltrim(rtrim(NAME))
--			,DPHD_NOM_MNAME =ltrim(rtrim(MIDDLENAME))
--			,DPHD_NOM_LNAME=ltrim(rtrim(SEARCHNAME))
--			,DPHD_NOM_FTHNAME=ltrim(rtrim(FTHNAME))
--			,DPHD_NOM_DOB=case when DATEOFBIRTH <> '' then left(DATEOFBIRTH,2)+'/'+substring(DATEOFBIRTH,3,2) + '/' + right(DATEOFBIRTH,4) else DATEOFBIRTH end 
--			,DPHD_NOM_PAN_NO=PANGIR
--			,DPHD_LST_UPD_DT = GETDATE()
--		FROM   DP_HOLDER_DTLS DPHD
--		, DPB9_PC6
--		WHERE  DPHD_DPAM_SBA_NO =  BOID 
		
		UPDATE DPHD
		SET    DPHD_GAU_FNAME = ltrim(rtrim(NAME))
			,DPHD_GAU_MNAME =ltrim(rtrim(MIDDLENAME))
			,DPHD_GAU_LNAME=ltrim(rtrim(SEARCHNAME))
			,DPHD_GAU_FTHNAME=ltrim(rtrim(FTHNAME))
			,DPHD_GAU_DOB=case when DATEOFBIRTH <> '' then left(DATEOFBIRTH,2)+'/'+substring(DATEOFBIRTH,3,2) + '/' + right(DATEOFBIRTH,4) else DATEOFBIRTH end 
			,DPHD_GAU_PAN_NO=PANGIR
			,DPHD_LST_UPD_DT = GETDATE()
		FROM   DP_HOLDER_DTLS DPHD
		, DPB9_PC7
		WHERE  DPHD_DPAM_SBA_NO =  BOID 
		
		UPDATE DPHD
		SET    DPHD_NOMGAU_FNAME = ltrim(rtrim(NAME))
				,DPHD_NOMGAU_MNAME =ltrim(rtrim(MIDDLENAME))
				,DPHD_NOMGAU_LNAME=ltrim(rtrim(SEARCHNAME))
			,DPHD_NOMGAU_FTHNAME=ltrim(rtrim(FTHNAME))
			,DPHD_NOMGAU_DOB=case when DATEOFBIRTH <> '' then left(DATEOFBIRTH,2)+'/'+substring(DATEOFBIRTH,3,2) + '/' + right(DATEOFBIRTH,4) else DATEOFBIRTH end 
			,DPHD_NOMGAU_PAN_NO=PANGIR
			,DPHD_LST_UPD_DT = GETDATE()
		FROM   DP_HOLDER_DTLS DPHD
		, DPB9_PC8
		WHERE  DPHD_DPAM_SBA_NO =  BOID 
                       
/*Changed on 26/06/12 by Tushar */ 

/*Changed on 26/06/12 by Tushar */ 






select identity(numeric,1,1) fre_id
,'F' fre_action
,'D' fre_type
,convert(datetime,left(FreezeActDt,2)+'/'+substring(FreezeActDt,3,2)+'/'+right(FreezeActDt,4),103) fre_Exec_date
,dpam_dpm_id fre_dpmid
,dpam_id fre_Dpam_id
,'' fre_Isin_code
,0 fre_QTY
,'A' fre_status
,'A' fre_level
,'MIG' fre_created_by
,getdate() fre_created_dt
,'MIG' fre_lst_upd_by
,getdate() fre_lst_upd_dt
,1 fre_deleted_ind
,null FRE_BATCH_NO
,'D' FRE_REQ_INT_BY
,null FRE_TRNS_NO
,case when FreezeResCd ='1' then 'By BO'
when FreezeResCd ='2' then ' ITO Attachement'
when FreezeResCd ='3' then ' SEBI Directive'
when FreezeResCd ='4' then ' Disinvestment / Pvt. Deal'
when FreezeResCd ='5' then ' Court Order'
when FreezeResCd ='6' then ' PAN verifiation pending'
when FreezeResCd ='7' then ' Sole/ First Holder Deceased'
when FreezeResCd ='8' then ' 2nd Holder Deceased'
when FreezeResCd ='9' then ' 3rd Holder Deceased'
when FreezeResCd ='10' then ' Order from special recovery office'
when FreezeResCd ='11' then ' CBI order'
when FreezeResCd ='12' then ' FIU/IND requirement '
when FreezeResCd ='13' then ' IPV pending'
when FreezeResCd ='14' then ' Assignment'
when FreezeResCd ='95' then ' RGESS freeze'
when FreezeResCd ='96' then ' Restrain PAN'
when FreezeResCd ='97' then ' Minor turn major'
when FreezeResCd ='98' then 'PAN not recorded'
when FreezeResCd ='21' then 'KYC PENDING' 
when FreezeResCd ='17'THEN'REQUESTED BY BO'
when FreezeResCd ='18'THEN'CORPORATE ACTIN FREEZE'
when FreezeResCd ='19'THEN'FATCA NONCOMPLIANT (UNDER ITRULE 114H(B))'
when FreezeResCd ='20'THEN'KYC DEFICIENCY REPORTED BY CDSL'
when FreezeResCd ='21'THEN'KYC PENDING'
when FreezeResCd ='22'THEN'KYC VERIFICATION NON COMPLIANT ACCOUNT'
when FreezeResCd ='94'THEN'NDU FREEZE SETUP'
when FreezeResCd ='16'THEN'INITIATED BY BO'

end + isnull(FreezeRmks  ,'')  fre_rmks
,case when FrozenFor ='1' then '01'
when FrozenFor ='2' then '02'
when FrozenFor ='3' then '03' end fre_for  into #newfreez from dpb9_pc4 
,dp_acct_mstr 
where dpam_sba_no = boid  and TypeOfTrans in ('1','')
and not exists (select 1 from freeze_Unfreeze_dtls where fre_action ='F' and dpam_id = fre_dpam_id) 


declare @l_maxfre numeric
set @l_maxfre = 1 
select @l_maxfre  = max(fre_id) from freeze_Unfreeze_dtls

insert into freeze_Unfreeze_dtls
select @l_maxfre + fre_id
,fre_action
,fre_type
,fre_Exec_date
,fre_dpmid
,fre_Dpam_id
,fre_Isin_code
,fre_QTY
,fre_status
,fre_level
,fre_created_by
,fre_created_dt
,fre_lst_upd_by
,fre_lst_upd_dt
,fre_deleted_ind
,FRE_BATCH_NO
,FRE_REQ_INT_BY
,FRE_TRNS_NO
,fre_rmks
,fre_for from #newfreez


update  f set fre_action ='U'
, fre_rmks = ''
--case when FreezeResCd ='1' then 'By BO'
--when FreezeResCd ='2' then ' ITO Attachement'
--when FreezeResCd ='3' then ' SEBI Directive'
--when FreezeResCd ='4' then ' Disinvestment / Pvt. Deal'
--when FreezeResCd ='5' then ' Court Order'
--when FreezeResCd ='6' then ' PAN verifiation pending'
--when FreezeResCd ='7' then ' Sole/ First Holder Deceased'
--when FreezeResCd ='8' then ' 2nd Holder Deceased'
--when FreezeResCd ='9' then ' 3rd Holder Deceased'
--when FreezeResCd ='10' then ' Order from special recovery office'
--when FreezeResCd ='11' then ' CBI order'
--when FreezeResCd ='12' then ' FIU/IND requirement '
--when FreezeResCd ='13' then ' IPV pending'
--when FreezeResCd ='14' then ' Assignment'
--when FreezeResCd ='95' then ' RGESS freeze'
--when FreezeResCd ='96' then ' Restrain PAN'
--when FreezeResCd ='97' then ' Minor turn major'
--when FreezeResCd ='98' then 'PAN not recorded'
--when FreezeResCd ='21' then 'KYC PENDING' 
--when FreezeResCd ='17'THEN'REQUESTED BY BO'
--when FreezeResCd ='18'THEN'CORPORATE ACTIN FREEZE'
--when FreezeResCd ='19'THEN'FATCA NONCOMPLIANT (UNDER ITRULE 114H(B))'
--when FreezeResCd ='20'THEN'KYC DEFICIENCY REPORTED BY CDSL'
--when FreezeResCd ='21'THEN'KYC PENDING'
--when FreezeResCd ='22'THEN'KYC VERIFICATION NON COMPLIANT ACCOUNT'
--when FreezeResCd ='94'THEN'NDU FREEZE SETUP'
--when FreezeResCd ='16'THEN'INITIATED BY BO'
--end + ' - '  + isnull(FreezeRmks  ,'')    
from dpb9_pc4 
,dp_acct_mstr ,freeze_Unfreeze_dtls f
where dpam_sba_no = boid  and TypeOfTrans in ('3')
and fre_action ='F' and dpam_id = fre_dpam_id 



SELECT DPAM_CRN_NO INTO #TEMPCRN FROM DP_ACCT_MSTR WHERE DPAM_DELETED_IND = 1 GROUP BY DPAM_CRN_NO 
HAVING COUNT(DPAM_CRN_NO ) = 1


SELECT  ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,EXISTSFLAG 
INTO #TMP_ADDRESSES FROM (
SELECT DISTINCT  ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG 
FROM DPB9_PC12 WHERE ISNULL(ADDR1,'') <>''
UNION
SELECT DISTINCT ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC1 WHERE ISNULL(ADDR1,'') <>''
UNION
SELECT DISTINCT ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC2 WHERE ISNULL(ADDR1,'') <>''
UNION
SELECT DISTINCT ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC3 WHERE ISNULL(ADDR1,'') <>''
UNION
SELECT DISTINCT ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC6 WHERE ISNULL(ADDR1,'') <>'' and TypeOfTrans <>'3'
UNION
SELECT DISTINCT '' ADDR1 , '' ADDR2 , '' ADDR3 ,'' CITY ,'' STATE , '' COUNTRY ,'' PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC6 WHERE ISNULL(ADDR1,'') <>'' and TypeOfTrans ='3'
UNION
SELECT DISTINCT ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC7 WHERE ISNULL(ADDR1,'') <>''
UNION
SELECT DISTINCT ADDR1 , ADDR2 , ADDR3 ,CITY ,STATE , COUNTRY ,PINCODE ,'N' EXISTSFLAG
FROM DPB9_PC8 WHERE ISNULL(ADDR1,'') <>''

) A 







UPDATE #TMP_ADDRESSES SET EXISTSFLAG = 'Y'
FROM #TMP_ADDRESSES , ADDRESSES WHERE LTRIM(RTRIM(ADR_1))=LTRIM(RTRIM(ADDR1))
AND LTRIM(RTRIM(ADR_2))=LTRIM(RTRIM(ADDR2))
AND LTRIM(RTRIM(ADR_3))=LTRIM(RTRIM(ADDR3))
AND LTRIM(RTRIM(ADR_CITY))=LTRIM(RTRIM(CITY))
AND LTRIM(RTRIM(ADR_STATE))=LTRIM(RTRIM(STATE))
AND LTRIM(RTRIM(ADR_COUNTRY))=LTRIM(RTRIM(COUNTRY))
AND LTRIM(RTRIM(ADR_ZIP))=LTRIM(RTRIM(PINCODE))

SELECT IDENTITY(NUMERIC,1,1) ID, * INTO #TMP_ADDRESSES1 FROM #TMP_ADDRESSES WHERE EXISTSFLAG ='N'
DECLARE @L_BITLOCATION NUMERIC
SELECT @L_BITLOCATION  = BITRM_BIT_LOCATION + 1 FROM BITMAP_REF_MSTR  WHERE BITRM_PARENT_CD ='ADR_CONC_ID'


UPDATE BITMAP_REF_MSTR SET BITRM_BIT_LOCATION = @L_BITLOCATION + (SELECT COUNT(*) FROM #TMP_ADDRESSES1) 
WHERE BITRM_PARENT_CD ='ADR_CONC_ID'

INSERT INTO ADDRESSES 
SELECT @L_BITLOCATION  + ID , ADDR1,ADDR2,ADDR3,CITY,STATE,COUNTRY,PINCODE,'MIG',GETDATE(),'MIG',GETDATE(),1 FROM #TMP_ADDRESSES1

DECLARE @L_CONCM_ID NUMERIC,
@L_CONCM_CD VARCHAR(50)
SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'PER_ADR1'


UPDATE  ENTAC SET ENTAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC12 
 , ADDRESSES 
 , ENTITY_ADR_CONC ENTAC
WHERE ENTAC_ENT_ID = DPAM_CRN_NO 
AND ENTAC_DELETED_IND =1 
AND ENTAC_CONCM_CD ='PER_ADR1'
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')


INSERT INTO ENTITY_ADR_CONC
SELECT A.DPAM_CRN_NO,'',@L_CONCM_ID ,@L_CONCM_CD, ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR A
 , DPB9_PC12 
 , ADDRESSES ,#TEMPCRN B
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND A.DPAM_CRN_NO = B.DPAM_CRN_NO 
AND NOT EXISTS(SELECT ENTAC_ENT_ID , ENTAC_CONCM_ID 
		   FROM ENTITY_ADR_CONC 
		   WHERE ENTAC_ENT_ID = A.DPAM_CRN_NO 
		    AND ENTAC_DELETED_IND =1 
			AND ENTAC_CONCM_CD ='PER_ADR1')
			

SET @L_CONCM_ID = 0
SET @L_CONCM_CD = ''
SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'COR_ADR1'

UPDATE  ENTAC SET ENTAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC1 
 , ADDRESSES 
 , ENTITY_ADR_CONC ENTAC
WHERE ENTAC_ENT_ID = DPAM_CRN_NO 
AND ENTAC_DELETED_IND =1 
AND ENTAC_CONCM_CD ='COR_ADR1'
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')

INSERT INTO ENTITY_ADR_CONC
SELECT A.DPAM_CRN_NO,'',@L_CONCM_ID ,@L_CONCM_CD, ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR A
 , DPB9_PC1 
 , ADDRESSES ,#TEMPCRN B
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND A.DPAM_CRN_NO = B.DPAM_CRN_NO 
AND NOT EXISTS(SELECT ENTAC_ENT_ID , ENTAC_CONCM_ID 
		   FROM ENTITY_ADR_CONC 
		   WHERE ENTAC_ENT_ID = A.DPAM_CRN_NO 
		    AND ENTAC_DELETED_IND =1 
			AND ENTAC_CONCM_CD ='COR_ADR1')

SET @L_CONCM_ID = 0
SET @L_CONCM_CD = ''

SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'AC_PER_ADR1'


UPDATE  ACCAC SET ACCAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC12 
 , ADDRESSES 
 , ACCOUNT_ADR_CONC ACCAC
WHERE ACCAC_CLISBA_ID = DPAM_ID 
AND ACCAC_DELETED_IND =1 
AND ACCAC_CONCM_ID =@L_CONCM_ID
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')

INSERT INTO ACCOUNT_ADR_CONC
SELECT DPAM_ID,DPAM_SBA_NO,'D',@L_CONCM_ID , ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR 
 , DPB9_PC12 
 , ADDRESSES 
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND NOT EXISTS(SELECT ACCAC_CLISBA_ID , ACCAC_CONCM_ID 
		   FROM ACCOUNT_ADR_CONC 
		   WHERE ACCAC_CLISBA_ID = DPAM_ID 
		    AND ACCAC_DELETED_IND =1 
			AND ACCAC_CONCM_ID =@L_CONCM_ID)

SET @L_CONCM_ID = 0
SET @L_CONCM_CD = ''
SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'AC_COR_ADR1'

UPDATE  ACCAC SET ACCAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC1
 , ADDRESSES 
 , ACCOUNT_ADR_CONC ACCAC
WHERE ACCAC_CLISBA_ID = DPAM_ID 
AND ACCAC_DELETED_IND =1 
AND ACCAC_CONCM_ID =@L_CONCM_ID
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')

INSERT INTO ACCOUNT_ADR_CONC
SELECT DPAM_ID,DPAM_SBA_NO,'D',@L_CONCM_ID , ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR 
 , DPB9_PC1
 , ADDRESSES 
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND NOT EXISTS(SELECT ACCAC_CLISBA_ID , ACCAC_CONCM_ID 
		   FROM ACCOUNT_ADR_CONC 
		   WHERE ACCAC_CLISBA_ID = DPAM_ID
		    AND ACCAC_DELETED_IND =1 
			AND ACCAC_CONCM_ID =@L_CONCM_ID)

SET @L_CONCM_ID = 0
SET @L_CONCM_CD = ''
SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'NOM_GUARDIAN_ADDR'

UPDATE  ACCAC SET ACCAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC8 
 , ADDRESSES 
 , ACCOUNT_ADR_CONC ACCAC
WHERE ACCAC_CLISBA_ID = DPAM_ID
AND ACCAC_DELETED_IND =1 
AND ACCAC_CONCM_ID =@L_CONCM_ID
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'')   =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'')  =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')   =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'')  = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')

INSERT INTO ACCOUNT_ADR_CONC
SELECT DPAM_ID,DPAM_SBA_NO,'D',@L_CONCM_ID , ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR 
 , DPB9_PC8 
 , ADDRESSES 
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND NOT EXISTS(SELECT ACCAC_CLISBA_ID , ACCAC_CONCM_ID 
		   FROM ACCOUNT_ADR_CONC 
		   WHERE ACCAC_CLISBA_ID = DPAM_ID 
		    AND ACCAC_DELETED_IND =1 
			AND ACCAC_CONCM_ID =@L_CONCM_ID)



SET @L_CONCM_ID = 0
SET @L_CONCM_CD = ''


SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'NOMINEE_ADR1' 

UPDATE  ACCAC SET ACCAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC6 
 , ADDRESSES 
 , ACCOUNT_ADR_CONC ACCAC
WHERE ACCAC_CLISBA_ID = DPAM_ID
AND ACCAC_DELETED_IND =1 
AND ACCAC_CONCM_ID =@L_CONCM_ID
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'') and TypeOfTrans <>'3'




INSERT INTO ACCOUNT_ADR_CONC
SELECT DPAM_ID,DPAM_SBA_NO,'D',@L_CONCM_ID , ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR 
 , DPB9_PC6 
 , ADDRESSES 
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND NOT EXISTS(SELECT ACCAC_CLISBA_ID , ACCAC_CONCM_ID 
		   FROM ACCOUNT_ADR_CONC 
		   WHERE ACCAC_CLISBA_ID = DPAM_ID 
		    AND ACCAC_DELETED_IND =1 
			AND ACCAC_CONCM_ID =@L_CONCM_ID)  and TypeOfTrans <>'3'
			
			
			
UPDATE  ACCAC SET ACCAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC6 
 , ADDRESSES 
 , ACCOUNT_ADR_CONC ACCAC
WHERE ACCAC_CLISBA_ID = DPAM_ID
AND ACCAC_DELETED_IND =1 
AND ACCAC_CONCM_ID =@L_CONCM_ID
AND DPAM_SBA_NO = BOID 
AND ISNULL('','') = ISNULL(ADR_1,'')
AND ISNULL('','') =ISNULL(ADR_2,'')
AND ISNULL('','') =ISNULL(ADR_3,'')
AND ISNULL('','')  =ISNULL(ADR_CITY,'')
AND ISNULL('','') = ISNULL(ADR_STATE,'')
AND ISNULL('','')= ISNULL(ADR_COUNTRY,'')
AND ISNULL('','')= ISNULL(ADR_ZIP,'') and TypeOfTrans ='3'




INSERT INTO ACCOUNT_ADR_CONC
SELECT DPAM_ID,DPAM_SBA_NO,'D',@L_CONCM_ID , ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR 
 , DPB9_PC6 
 , ADDRESSES 
WHERE DPAM_SBA_NO = BOID 
AND ISNULL('','') = ISNULL(ADR_1,'')
AND ISNULL('','') =ISNULL(ADR_2,'')
AND ISNULL('','') =ISNULL(ADR_3,'')
AND ISNULL('','')  =ISNULL(ADR_CITY,'')
AND ISNULL('','') = ISNULL(ADR_STATE,'')
AND ISNULL('','')= ISNULL(ADR_COUNTRY,'')
AND ISNULL('','')= ISNULL(ADR_ZIP,'')
AND NOT EXISTS(SELECT ACCAC_CLISBA_ID , ACCAC_CONCM_ID 
		   FROM ACCOUNT_ADR_CONC 
		   WHERE ACCAC_CLISBA_ID = DPAM_ID 
		    AND ACCAC_DELETED_IND =1 
			AND ACCAC_CONCM_ID =@L_CONCM_ID)  and TypeOfTrans ='3'
			
SET @L_CONCM_ID = 0
SET @L_CONCM_CD = ''


SELECT @L_CONCM_ID = CONCM_ID , @L_CONCM_CD = CONCM_CD  FROM CONC_CODE_MSTR WHERE CONCM_CD = 'GUARD_ADR' 

UPDATE  ACCAC SET ACCAC_ADR_CONC_ID = ADR_ID 
FROM DP_ACCT_MSTR 
 , DPB9_PC7 
 , ADDRESSES 
 , ACCOUNT_ADR_CONC ACCAC
WHERE ACCAC_CLISBA_ID = DPAM_ID
AND ACCAC_DELETED_IND =1 
AND ACCAC_CONCM_ID =@L_CONCM_ID
AND DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')

INSERT INTO ACCOUNT_ADR_CONC
SELECT DPAM_ID,DPAM_SBA_NO,'D',@L_CONCM_ID , ADR_ID,'MIG',GETDATE(),'MIG',GETDATE(),1  FROM DP_ACCT_MSTR 
 , DPB9_PC7 
 , ADDRESSES 
WHERE DPAM_SBA_NO = BOID 
AND ISNULL(ADDR1,'') = ISNULL(ADR_1,'')
AND ISNULL(ADDR2,'') =ISNULL(ADR_2,'')
AND ISNULL(ADDR3,'') =ISNULL(ADR_3,'')
AND ISNULL(CITY,'')  =ISNULL(ADR_CITY,'')
AND ISNULL(STATE,'') = ISNULL(ADR_STATE,'')
AND ISNULL(COUNTRY,'')= ISNULL(ADR_COUNTRY,'')
AND ISNULL(PINCODE,'')= ISNULL(ADR_ZIP,'')
AND NOT EXISTS(SELECT ACCAC_CLISBA_ID , ACCAC_CONCM_ID 
		   FROM ACCOUNT_ADR_CONC 
		   WHERE ACCAC_CLISBA_ID = DPAM_ID 
		    AND ACCAC_DELETED_IND =1 
			AND ACCAC_CONCM_ID =@L_CONCM_ID)

insert into dpb9log
select GETDATE(),' old bulk update','end'

/*Changed on 26/06/12 by Tushar */ 

insert into dpb9log
select GETDATE(),'main_old','start'

truncate table dpb9_tracemodifieddata




          declare @c_client_summary1  cursor  
                 ,@c_ben_acct_no1  varchar(20)  
  
                 set @c_client_summary1  = CURSOR fast_forward FOR                
                 SELECT distinct  BOID    FROM DPB9_PC0  
				 WHERE BOID IN (SELECT DPAM_SBA_NO FROM DP_ACCT_MSTR) 
--				 and not exists (select 1 from suresh_to_cdas_mobile where ClientID =BOID  ) 
--				 and not exists (select 1 from suresh_to_cdas_email where ClientID =BOID  ) 
--				 and not exists (select 1 from tempdata1235 where boid = sba  )
          
          open @c_client_summary1  
          
          fetch next from @c_client_summary1 into @c_ben_acct_no1   
          
          
          
        WHILE @@fetch_status = 0                                                                                                          
        BEGIN --#cursor  
        --  


insert into dpb9_tracemodifieddata 
select  @c_ben_acct_no1,getdate(),0



/*changes done by tushar on may 22 2014 for nrn no update if nominee change*/
		if exists(select DPHD_NOM_FNAME,DPHD_NOM_MNAME,DPHD_NOM_LNAME FROM   DP_HOLDER_DTLS DPHD
		, DPB9_PC6
		WHERE  DPHD_DPAM_SBA_NO =  BOID 
		and ltrim(rtrim(isnull(DPHD_NOM_FNAME,'')))+ltrim(rtrim(isnull(DPHD_NOM_MNAME,'')))+ltrim(rtrim(isnull(DPHD_NOM_LNAME,''))) <> 
			ltrim(rtrim(isnull(NAME,''))) + ltrim(rtrim(isnull(MIDDLENAME,''))) + ltrim(rtrim(isnull(SEARCHNAME,''))) 
		and boid = @c_ben_acct_no1
		)
		begin 

			declare @l_nrn_no1 numeric

			set @l_nrn_no1 = 0 
			select @l_nrn_no1 = BITRM_BIT_LOCATION 
			from bitmap_ref_mstr 
			where bitrm_parent_cd like '%NRN_AUTO%'

			update bitmap set BITRM_BIT_LOCATION = BITRM_BIT_LOCATION + 1 
			from bitmap_ref_mstr bitmap
			where bitrm_parent_cd like '%NRN_AUTO%'


			UPDATE DPHD
			SET    NOM_NRN_NO = @l_nrn_no1
			FROM   DP_HOLDER_DTLS DPHD
			, DPB9_PC6
			WHERE  DPHD_DPAM_SBA_NO =  BOID  and boid = @c_ben_acct_no1



		end 	
		
			UPDATE DPHD
			SET    DPHD_NOM_FNAME = ltrim(rtrim(NAME))
				,DPHD_NOM_MNAME   = ltrim(rtrim(MIDDLENAME))
				,DPHD_NOM_LNAME   = ltrim(rtrim(SEARCHNAME))
				,DPHD_NOM_FTHNAME = ltrim(rtrim(FTHNAME))
				,DPHD_NOM_DOB=case when DATEOFBIRTH <> '' then left(DATEOFBIRTH,2)+'/'+substring(DATEOFBIRTH,3,2) + '/' + right(DATEOFBIRTH,4) else DATEOFBIRTH end 
				,DPHD_NOM_PAN_NO=PANGIR
				,DPHD_LST_UPD_DT = GETDATE()
			FROM   DP_HOLDER_DTLS DPHD
			, DPB9_PC6
			WHERE  DPHD_DPAM_SBA_NO =  BOID  and boid = @c_ben_acct_no1 and TypeOfTrans <>'3'
			
			UPDATE DPHD
			SET    DPHD_NOM_FNAME = ''
				,DPHD_NOM_MNAME   = ''
				,DPHD_NOM_LNAME   = ''
				,DPHD_NOM_FTHNAME = ''
				,DPHD_NOM_DOB=''
				,DPHD_NOM_PAN_NO=''
				,DPHD_LST_UPD_DT = GETDATE()
			FROM   DP_HOLDER_DTLS DPHD
			, DPB9_PC6
			WHERE  DPHD_DPAM_SBA_NO =  BOID  and boid = @c_ben_acct_no1 and TypeOfTrans = '3'
		
/*changes done by tushar on may 22 2014 for nrn no update if nominee change*/


			  select @l_crn_no = clim_crn_no from client_mstr,  DP_ACCT_MSTR 
			  where  DPAM_CRN_NO = CLIM_CRN_NO 
			  AND    DPAM_SBA_NO =  @c_ben_acct_no1  
			  
			 set @L_CONC=''
			 
			SELECT @L_CONC = 
			--case when PriPhInd = 'O'  then 'OFF_PH1|*~|'
			--when PriPhInd = 'M'  then 'MOBILE1|*~|'
			--else 'MOBILE1|*~|' end  + ISNULL(LTRIM(RTRIM(PRIPHNUM)),'')+'*|~*'--+'OFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'  

			--					+'RES_PH1|*~|'+ISNULL(ltrim(rtrim(PRIPHNUM)),'')+'*|~*'

			--							+ case when AltPhInd = 'O'  then 'OFF_PH2|*~|'
			--							  when AltPhInd = 'R'  then 'RES_PH2|*~|' else 'RES_PH2|*~|' end +ISNULL(ltrim(rtrim(AltPhNum)),'')+'*|~*'
										--+'RES_PH3|*~|'+ISNULL(ltrim(rtrim(AddPh)),'')+'*|~*'
										'FAX1|*~|'+ISNULL(LTRIM(RTRIM(FAX)),'')+'*|~*'--+'FAX2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAXF_NO)),'')+'*|~*'  
										+'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(pri_email)),'')+'*|~*'  
										+'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(PriPhNum)),'')+'*|~*'  
					   FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO1  
			          
				SELECT @L_CONC = isnull(@L_CONC,'')  +'MOBSMS|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*' 
					--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
					   FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO1  
			and PriPhNum <> ''
--					 print @C_BEN_ACCT_NO1
--			print @L_CONC
--changes done for 408 ------					
	
SELECT @L_CONC = @L_CONC  +'SECMOB|*~|'+ISNULL(ltrim(rtrim(AltPhNum)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @c_ben_acct_no1  


SELECT @L_CONC = @L_CONC  +'EMAIL2|*~|'+ISNULL(ltrim(rtrim(sec_email)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @c_ben_acct_no1    


SELECT @L_CONC = @L_CONC  +'SECIC|*~|'+ISNULL(ltrim(rtrim(isd_sec)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO1  

SELECT @L_CONC = @L_CONC  +'PRIIC|*~|'+ISNULL(ltrim(rtrim(isd_pri)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO1  
--changes done for 408 ------
         
          EXEC PR_INS_UPD_CONC @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
			 set @L_CONC=''
--changes done for 408 ------			 
		   set @L_acc_conc =''
           SELECT @L_acc_conc = 'SECMIC|*~|'+ISNULL(ltrim(rtrim(pri_isd)),'')+'*|~*'
           +'SH_MOBILE|*~|'+ISNULL(ltrim(rtrim(pri_ph_no)),'')+'*|~*'
           FROM   DPB9_PC2 WHERE boid = @c_ben_acct_no1 and isnull(pri_isd,'') <> ''  
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'THMIC|*~|'+ISNULL(ltrim(rtrim(pri_isd)),'')+'*|~*'
           +'TH_MOBILE|*~|'+ISNULL(ltrim(rtrim(pri_ph_no)),'')+'*|~*'
           FROM   DPB9_PC3 WHERE boid = @c_ben_acct_no1 and isnull(pri_isd,'') <> ''                  
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'GUAIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'GUARD_MOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC7 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''                  
           
           
           
           
            
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'NOMIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'NOMINEE_MOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC6 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 1                 
           
            SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'SECNOMIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'SECNOMMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC6 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''  and NOM_Sr_No =2               
           
           
            SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'THNOMIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'THNOMMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC6 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 3                 
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'NOMGIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'NOM_GUARD_MOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC8 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''   and NOM_Sr_No = 1                
           
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'SECNOMGIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'SECNOMGMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC8 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 2   
           
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'THNOMGIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'THNOMGMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC8 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 3                   
           
               
		
           
         
           EXEC  pr_dp_ins_upd_CONC @l_crn_no,'EDT','MIG',0,@c_ben_acct_no1,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''   
  
           set @L_acc_conc = ''  
           
--changes done for 408 ------   
          select @l_crn_no = clim_crn_no from client_mstr,  DP_ACCT_MSTR where DPAM_CRN_NO = CLIM_CRN_NO AND DPAM_SBA_NO =  @c_ben_acct_no1  
  
     
             SET @L_ACCP_VALUE = ''  
--          SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,'38') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(SEBIREGNUM)),'')) + '|*~|*|~*' FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD = 'SEBI_REG_NO'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'33') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(CLMEMID)),'')) + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'CMBP_ID'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'94') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ITCircle)),'')) + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1-- AND ACCPM_PROP_CD  = 'ADHAARFLAG'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'95') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ITCircle)),'')) + '|*~|*|~*'  FROM DPB9_PC2  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'ADHAARSECHLDR'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'96') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ITCircle)),'')) + '|*~|*|~*'  FROM DPB9_PC3  WHERE BOID = @C_BEN_ACCT_NO1-- AND ACCPM_PROP_CD  = 'ADHAARTHRDHLDR'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'41') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(RBIREFNUM)),'')) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'RBI_REF_NO'  
--         --SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GROUP_CD',UPPER(ISNULL(LTRIM(RTRIM(GROUPCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'GROUP_CD'  
         
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'18') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BANKCCY'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'27') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVBANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'DIVBANKCCY'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'16') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVIDEND_CURRENCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'DIVIDEND_CURRENCY'  
		 
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'46') + '|*~|' + + LEFT(ISNULL(LTRIM(RTRIM(CLOSDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(CLOSDT)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(CLOSDT)),''),4)  + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'ACC_CLOSE_DT'  and  CLOSDT <> ''
--         --SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(BENTAXDEDSTAT)),'')) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'TAX_DEDUCTION'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'44') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(CONFWAIVED)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'CONFIRMATION'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'25') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(ECS)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'ECS_FLG'  

--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'28') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BOSTMNTCYCLE',UPPER(ISNULL(LTRIM(RTRIM(BOSTATCYCLECD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'35') + '|*~|' + + LEFT(ISNULL(LTRIM(RTRIM(BOActDt)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(BOActDt)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(BOActDt)),''),4)  + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BILL_START_DT'  and BOActDt <> ''
		 
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'57') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler9)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'bsda'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'61') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(AnnlRep)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'RGESS_FLAG'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'42') + '|*~|' + '1'  + '|*~|*|~*'  FROM DPB9_PC16  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'SMS_FLAG'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='1' THEN 'PHYSICAL' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='2' THEN 'ELECTRONIC' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='3' THEN 'BOTH'  ELSE '0' END  + '|*~|*|~*'   FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO1 AND ACCPM_PROP_CD  = 'ANNUAL_REPORT'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler7)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler7)),''))='N' THEN 'NO'  ELSE '0' END  + '|*~|*|~*'   FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO1 AND ACCPM_PROP_CD  = 'PLEDGE_STANDING'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler3)),''))='PH' THEN 'PHYSICAL CAS REQUIRED' when  UPPER(ISNULL(LTRIM(RTRIM(Filler3)),''))='NO' then 'CAS NOT REQUIRED' else ''END  + '|*~|*|~*'  FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO1 AND ACCPM_PROP_CD  = 'cas_flag' --and Filler3 <> ''
--/**/
		
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'58') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler2)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(filler2)),''))='N' THEN 'NO' ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'Email_st_flag'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'66') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler8)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(filler8)),''))='N' THEN 'NO' ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = 'RTA_EMAIL'
--		--changes done for 408 ------		
--		--SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(AnnlRep)),''))='P' THEN 'PHYSICALLY' ELSE 'ELECTRONICALLY' END  + '|*~|*|~*'  FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'BONAFIDE'
--        SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(smart_flag)),''))='Y' THEN 'YES' ELSE 'NO' END  + '|*~|*|~*'  FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO1 AND ACCPM_PROP_CD  = 'SMART_REG'
        
----changes done for 408 ------

	--	SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'77') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(rel_WITH_BO)),'')) <> '' THEN citrus_usr.fn_get_cd_rel(UPPER(ISNULL(LTRIM(RTRIM(rel_WITH_BO)),''))) ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC6  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = '1ST_NRELATN_BO'
	--	SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'78') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(perc_OF_SHARES)),''))<> '' THEN UPPER(ISNULL(LTRIM(RTRIM(perc_OF_SHARES)),'')) ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC6  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = '1ST_NPER_SHR'
		--SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'79') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(RES_SEC_FLg)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(RES_SEC_FLg)),''))='N' THEN 'NO' ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC6  WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD  = '1ST_NRED_SEC_FLG'		
--		SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + 'YES' + '|*~|*|~*' 	FROM dpb9_pc6 ,ACCOUNT_PROPERTY_MSTR WHERE boid = @C_BEN_ACCT_NO1 AND ACCPM_PROP_CD  = 'MULTI_NOM_FLG' AND TypeOfTrans in ('','1','2')
--		SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + 'NO' + '|*~|*|~*' 	FROM dpb9_pc6 ,ACCOUNT_PROPERTY_MSTR WHERE boid  = @C_BEN_ACCT_NO1 AND ACCPM_PROP_CD  = 'MULTI_NOM_FLG' AND TypeOfTrans not in ('','1','2')
		

		/*new kyc aug 2021*/
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'102') + '|*~|' + UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('BOOS',UPPER(ISNULL(LTRIM(RTRIM(AFILLER4)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'99') + '|*~|' + UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('BONAFIDE',UPPER(ISNULL(LTRIM(RTRIM(AFILLER5)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'103') + '|*~|' + UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('PANVC',UPPER(ISNULL(LTRIM(RTRIM(PANVerCode)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'104') + '|*~|' + UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('PANVC2',UPPER(ISNULL(LTRIM(RTRIM(PANVerCd)),'')))) + '|*~|*|~*' FROM DPB9_PC2   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'105') + '|*~|' + UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('PANVC3',UPPER(ISNULL(LTRIM(RTRIM(PANVerCd)),'')))) + '|*~|*|~*' FROM DPB9_PC3   WHERE BOID = @C_BEN_ACCT_NO1 --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  

		/*new kyc aug 2021*/
		
--		/**/
--         SET @L_ACCPD_VALUE = ''  
--         SELECT DISTINCT @L_ACCPD_VALUE = CONVERT(VARCHAR,'41') + '|*~|' + CONVERT(VARCHAR,'6') + '|*~|'  + LEFT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),4)  + '|*~|*|~*' FROM DPB9_PC1    WHERE BOID = @C_BEN_ACCT_NO 
--         AND ISDATE(RIGHT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),4)) = 1          
  
  
            
         SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DPB9_PC1 WHERE DPAM_SBA_NO = BOID  AND BOID  = @C_BEN_ACCT_NO1  
  
         --EXEC PR_INS_UPD_ACCP @L_CRN_NO ,'EDT','MIG',@L_DPAM_ID,@C_BEN_ACCT_NO1,'D',@L_ACCP_VALUE,@L_ACCPD_VALUE ,0,'*|~*','|*~|',''  
                                                     
          --account_properties  
  
          --entity_properties  
              
         
        SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(BEN_RBI_REF_NO)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO'  
                             
        --SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,'28') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','NATIONALITY',UPPER(ISNULL(LTRIM(RTRIM(NATCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'NATIONALITY'  
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'65') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','OCCUPATION',UPPER(ISNULL(LTRIM(RTRIM(OCCUPATION)),'')))) + '|*~|*|~*' FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'OCCUPATION'  
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'12') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GEOGRAPHICAL',UPPER(ISNULL(LTRIM(RTRIM(GEOGCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'GEOGRAPHICAL'  
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'42') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','EDUCATION',UPPER(ISNULL(LTRIM(RTRIM(EDU)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'EDUCATION'  
          
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'40') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','LANGUAGE',UPPER(ISNULL(LTRIM(RTRIM(LANGCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'LANGUAGE'  
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'64') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'N' THEN 'NONE'   
        --                                                                                              WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'R' THEN 'RELATIVE'  
        --                                                                                              WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'S' THEN 'STAFF' ELSE '' END   + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'STAFF'  
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'15') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','ANNUAL_INCOME',UPPER(ISNULL(LTRIM(RTRIM(ANNINCOMECD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO1 --AND ENTPM_CD   = 'ANNUAL_INCOME'  
                             
        SET @L_ENTPD_VALUE = ''  
                           --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(BEN_RBI_APP_DATE)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID  
                              
  
  
  
         
         --EXEC PR_INS_UPD_ENTP '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''    
  
						

           UPDATE ENTP SET ENTP_VALUE = PANGIR FROM   
           ENTITY_PROPERTIES ENTP   
         , DP_ACCT_MSTR   
         , DPB9_PC1   
           WHERE DPAM_CRN_NO = ENTP_ENT_ID   
           AND DPAM_SBA_NO = boid   
           AND DPAM_SBA_NO =  @C_BEN_ACCT_NO1   
           AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_DELETED_IND = 1  
			
			 
		 
			 
                 SELECT @L_BANK_NAME = LTRIM(RTRIM(DIVIFSCD)) , @L_BANM_BRANCH = LTRIM(RTRIM(DIVBANKCD)) 
				FROM   DPB9_PC1   
				WHERE  BOID = @C_BEN_ACCT_NO1  
  
  
            SELECT @L_MICR_NO = DIVBANKCD FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO1  
  
          
             SET @L_BANM_ID = 0  
             IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE (BANM_RTGS_CD = @L_BANK_NAME AND BANM_MICR = @L_BANM_BRANCH))
             BEGIN  
                SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_RTGS_CD = @L_BANK_NAME AND BANM_MICR = @L_BANM_BRANCH)  
             END  
             ELSE   
             BEGIN  
                
               EXEC PR_MAK_BANM  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,@L_BANK_NAME,'','',0,0,'',0,'','*|~*','|*~|',''  
                 
                
               SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_RTGS_CD = @L_BANK_NAME AND BANM_MICR = @L_BANM_BRANCH)  
             END  
                         
if exists (select 1 from client_bank_accts ,dp_acct_mstr, dpb9_pc1  where dpam_id = cliba_clisba_id and DPAM_SBA_NO =@c_ben_acct_no1 
	and boid = dpam_sba_no and CLIBA_AC_NO   = CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO)))  and 	 cliba_banm_id = @L_BANM_ID )
begin 
declare @l_max datetime
select @l_max= max(cliba_lst_upd_dt) from client_bank_accts ,dp_acct_mstr where dpam_id = cliba_clisba_id 
and DPAM_SBA_NO =@c_ben_acct_no1 and CLIBA_FLG='1'


                   update cliba  
                   set    CLIBA_AC_NO   = DIVBANKACCTNO  
                   ,      cliba_banm_id = @L_BANM_ID  
				   ,      CLIBA_AC_TYPE =  CASE WHEN DIVACCTTYPE = '10' THEN 'SAVINGS' WHEN DIVACCTTYPE = '11' THEN 'CURRENT' ELSE 'OTHERS' END
                   ,      cliba_lst_upd_dt = getdate()
                   from client_bank_accts cliba  
                   ,    dp_acct_mstr   
                   ,     DPB9_PC1   
                
                   where cliba_clisba_id = dpam_id   
                   and   BOID = dpam_sba_no   
                   and  BOID = @c_ben_acct_no1   and CLIBA_FLG='1'
                   and cliba_lst_upd_dt = @l_max
                   and not exists (select 1 from client_bank_accts I where i.cliba_clisba_id=cliba.cliba_clisba_id
                   and i.CLIBA_AC_NO=cliba.CLIBA_AC_NO  and i.cliba_banm_id=cliba.cliba_banm_id)
                   
                   Update T set CLIBA_FLG='0' from client_bank_accts T ,dp_acct_mstr where dpam_id = cliba_clisba_id 
				   and DPAM_SBA_NO =@c_ben_acct_no1 
				   
				   --Update T set CLIBA_FLG='1' from client_bank_accts T ,dp_acct_mstr where dpam_id = cliba_clisba_id 
				   --and DPAM_SBA_NO =@c_ben_acct_no1 and   cliba_banm_id = @L_BANM_ID   and  exists (select 1 from DPB9_PC1 I where boid=dpam_sba_no
				   --and	CLIBA_AC_NO   = CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO))) )

				    Update T set CLIBA_FLG='1' 
					from client_bank_accts T ,dp_acct_mstr , bank_mstr ,dpb9_pc1 
					where dpam_id = cliba_clisba_id 
				   and DPAM_SBA_NO =@c_ben_acct_no1
				   and   cliba_banm_id = banm_id    
				  and  boid=dpam_sba_no and banm_rtgs_cd = ltrim(rtrim(DivIFScd)) 
				   and	CLIBA_AC_NO   = CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO))) 
                   
end 
else 
begin 

                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
						   where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(BOID,8) from DPB9_PC1)

                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           
set @L_DPBA_VALUES = ''
SELECT @L_DPBA_VALUES = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'+ ISNULL(@L_DPM_DPID,'') + '|*~|'
+ LTRIM(RTRIM(@C_BEN_ACCT_NO1)) +'|*~|' + LTRIM(RTRIM(NAME))+' '+ LTRIM(RTRIM(MIDDLENAME)) + ' '+ LTRIM(RTRIM(SEARCHNAME)) + '|*~|'
+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+ CASE WHEN DIVACCTTYPE = '10' THEN 'SAVINGS' WHEN DIVACCTTYPE = '11' THEN 'CURRENT' ELSE 'OTHERS' END +'|*~|' 
+ CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO))) + '|*~|1|*~|0|*~|A*|~*'  FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO1  

        EXEC PR_INS_UPD_DPBA '0','INS','MIG',@L_CRN_NO,@L_DPBA_VALUES,0,'*|~*','|*~|',''   
        
          Update T set CLIBA_FLG='0' from client_bank_accts T ,dp_acct_mstr where dpam_id = cliba_clisba_id 
				   and DPAM_SBA_NO =@c_ben_acct_no1 
				   
				   --Update T set CLIBA_FLG='1' from client_bank_accts T ,dp_acct_mstr where dpam_id = cliba_clisba_id 
				   --and DPAM_SBA_NO =@c_ben_acct_no1 and   cliba_banm_id = @L_BANM_ID   and exists (select 1 from DPB9_PC1 I where boid=dpam_sba_no
				   --and	CLIBA_AC_NO   = CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO))) )
				    Update T set CLIBA_FLG='1' 
					from client_bank_accts T ,dp_acct_mstr , bank_mstr ,dpb9_pc1 
					where dpam_id = cliba_clisba_id 
				   and DPAM_SBA_NO =@c_ben_acct_no1
				   and   cliba_banm_id = banm_id    
				  and  boid=dpam_sba_no and banm_rtgs_cd = ltrim(rtrim(DivIFScd)) 
				   and	CLIBA_AC_NO   = CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO))) 
        
end 
  
  
  
/*commented on dec 26 1012*/                    
if not exists(select dppd_id from dp_poa_dtls , DPB9_PC5 
, dp_acct_mstr 
where dpam_id = dppd_dpam_id 
and BOID = dpam_sba_no 
and dpam_sba_no = @c_ben_acct_no1
and dppd_master_id =  MasterPOAId
--and dppd_poa_id = POARegNum
and HolderNum=case when DPPD_HLD='1ST HOLDER' THEN '1' WHEN DPPD_HLD='2ND HOLDER' THEN '2' ELSE '3' END
)  
  
begin  
   

 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
 where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(BOID,8) from DPB9_PC5)
  
 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
  
 select distinct @l_crn_no = dpam_crn_no from dp_acct_mstr, DPB9_PC5 WHERE BOID = @c_ben_acct_no1 AND dpam_sba_no  =BOID
  
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
-- FROM DPB9_PC5 , dp_acct_mstr WHERE left(dpam_sba_no ,2) ='22' and MasterPOAId = dpam_sba_no and  boid = @c_ben_acct_no1 AND POARegNum <>''   
--  

SELECT @l_dppd_details = @l_dppd_details  + isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end +'|*~|'+ISNULL(ltrim(rtrim(dpam_sba_name)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(POARegNum)),'')+'|*~|'+ISNULL(ltrim(rtrim(GPABPAFlg)),'')  
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate) ,103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103),103) ELSE '' END   
  
 --+'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
 
+'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|0|*~|0|*~|'+'A*|~*'    

 FROM DPB9_PC5 , citrus_usr.poam WHERE left(poam_master_id ,2) ='22' 
 and MasterPOAId = poam_master_id 
 and  boid = @c_ben_acct_no1 AND POARegNum <>''   
  
  
  --select * from DPB9_PC5 ,dp_acct_mstr ,dp_poa_dtls where dpam_sba_no=@c_ben_acct_no1
  --and DPAM_ID=DPPD_DPAM_ID and DPAM_DELETED_IND=1 and DPPD_DELETED_IND=1
  --and MasterPOAId=dppd_master_id
  --and 

--  print @l_dppd_details
 -- print @l_crn_no

  EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
  
end  
ELSE 
BEGIN 

UPDATE D sET DPPD_POA_ID=POARegNum from dp_poa_dtls d , DPB9_PC5 
, dp_acct_mstr 
where dpam_id = dppd_dpam_id 
and BOID = dpam_sba_no 
and dpam_sba_no = @c_ben_acct_no1
and dppd_master_id =  MasterPOAId
--and dppd_poa_id = POARegNum
and HolderNum=case when DPPD_HLD='1ST HOLDER' THEN '1' WHEN DPPD_HLD='2ND HOLDER' THEN '2' ELSE '3' END
AND ISNULL(POARegNum,'')<>''
and TypeOfTrans in ('','1')
and dppd_eff_TO_dt =  '1900-01-01 00:00:00.000'
END

/*commented on dec 26 1012*/ 

--if not exists(select dppd_id from dp_poa_dtls , TMP_CDSL_AUTH_SIGNATORY , dp_acct_mstr 
--              where dpam_id = dppd_dpam_id and BO_ID = dpam_sba_no and dpam_sba_no = @c_ben_acct_no1 
--              --and dppd_poa_type = 'AUTHORISED SIGNATORY'
--              and DPPD_FNAME =  HLDR_NAME)  
--  
--begin  
--   
--
-- select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(TMPCLI_BOID,8) from TMP_CLIENT_DTLS_MSTR_CDSL)
--  
-- select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
--  
-- select distinct @l_crn_no = clim_crn_no from client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 AND entp_deleted_ind = 1   
--
-- SET @l_dppd_details = ''
--
--
-- 
--  
-- SELECT @l_dppd_details = isnull(@l_dppd_details,'') + isnull(convert(varchar,@l_compm_id),'')+'|*~|'
--+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'
--+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'
--+isnull(@c_ben_acct_no1,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')
--+'|*~|'+ ISNULL(ltrim(rtrim('1ST HOLDER')),'') +'|*~|'
--+ISNULL(ltrim(rtrim(HLDR_NAME)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')
--+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')
--+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')
--+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('0')),'')
--+'|*~|'+ISNULL(ltrim(rtrim('AUTHORISED SIGNATORY')),'')  
--  
-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,HLDR_SETUP_DT,103))= 1 THEN convert(varchar,CONVERT(datetime,HLDR_SETUP_DT,103),103) ELSE '' END   
--  
-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,'',103))= 1 THEN convert(varchar,CONVERT(datetime,'',103),103) ELSE '' END   
--  
-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,'',103))= 1 THEN convert(varchar,CONVERT(datetime,'',103),103) ELSE '' END   
--  
-- +'|*~|'+ltrim(rtrim('0'))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
--  
-- FROM TMP_CDSL_AUTH_SIGNATORY where BO_ID = @c_ben_acct_no1 AND PURPOSE_CD = '18'
--  
--
-- EXEC pr_ins_upd_dppd '1',@l_crn_no,'EDT','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
--  
--end   

  
   
  
        update dpb9_tracemodifieddata 
		set diff = datediff(ss,dt,getdate()) 
	    where sba = @c_ben_acct_no1
  
  
                   fetch next from @c_client_summary1 into @c_ben_acct_no1   
                     
                     
                 --  
                 end  
      
                 close @c_client_summary1    
                 deallocate  @c_client_summary1    
  
                   
  
--                          
            insert into dpb9log
select GETDATE(),'main_old','end'                  
                                 
          insert into dpb9log
select GETDATE(),'main_new','start'
     
                            
                                 
          
     
                          
        set @c_client_summary  = CURSOR fast_forward FOR                
        SELECT BOID    FROM DPB9_PC1 
		WHERE BOID NOT IN (SELECT DPAM_SBA_NO FROM DP_ACCT_MSTR) --AND TYPEOFTRANS IN ('1')
--		AND DPIntRefNum NOT IN (SELECT DPAM_ACCT_NO FROM [192.168.100.222].CITRUS.CITRUS_USR.DP_ACCT_MSTR 
--								WHERE ISNULL(DPAM_BATCH_NO ,'0') <>'0' AND DPAM_ACCT_NO = DPAM_SBA_NO ) 
		
          
        select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
        where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  
		and dpm_dpid = (select top 1 left(BOID,8) from DPB9_PC1)

        select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
                    
          
        open @c_client_summary  
          
        fetch next from @c_client_summary into @c_ben_acct_no   
          
          
          
        WHILE @@fetch_status = 0                                                                                                          
        BEGIN --#cursor                                                                                                          
        --  
     
		   SELECT @@BOCTGRY = CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END 
		   FROM DPB9_PC1
		   WHERE  BOID = @C_BEN_ACCT_NO    
             
  
  
           SELECT  @L_CLIENT_VALUES = LTRIM(RTRIM(NAME)) + '|*~|' 
						 +LTRIM(RTRIM(MIDDLENAME)) + '|*~|' 
						 +LTRIM(RTRIM(SEARCHNAME)) + '|*~|'
						 +LEFT(LTRIM(RTRIM(ISNULL(LTRIM(RTRIM(NAME)),'') 
						 +'-'+ISNULL(LTRIM(RTRIM(BOID)),''))),50) + '|*~|'
						 +ISNULL(SEXCD,'')+'|*~|'
						 +CASE WHEN ISDATE(CONVERT(DATETIME,CITRUS_USR.FNGETDATE(DATEOFBIRTH),103)) = 1 THEN  ISNULL(CITRUS_USR.FNGETDATE(DATEOFBIRTH),'') ELSE '' END 
						 +'|*~||*~|ACTIVE|*~||*~|1|*~|' 
						 + ISNULL(LTRIM(RTRIM(PANGIR)),'') +'|*~|*|~*' 
						FROM DPB9_PC1 WHERE  BOID = @C_BEN_ACCT_NO  
  
                              
			
--			print 'jit2'
			 --print @L_CLIENT_VALUES
			
            EXEC pr_ins_upd_clim  '0','INS','MIG',@L_CLIENT_VALUES,0,'*|~*','|*~|','',''  
           

			 SELECT DISTINCT @L_CRN_NO = CLIM_CRN_NO FROM CLIENT_MSTR, DPB9_PC1 WHERE  BOID = @C_BEN_ACCT_NO 
			 AND CLIM_SHORT_NAME =  LEFT(LTRIM(RTRIM(ISNULL(LTRIM(RTRIM(NAME)),'')  +'-'+ ISNULL(LTRIM(RTRIM(BOID)),''))),50)                   
         
          

			SET @L_ADR ='' 
            SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*' 
    		FROM   DPB9_PC12 WHERE BOID = @C_BEN_ACCT_NO 
           
		
	       SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO 
  
                            
           EXEC PR_INS_UPD_ADDR @L_CRN_NO,'INS','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|','' 
  
     
        
         
--           SELECT @L_CONC = 'OFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
--							 +'MOBILE1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
--							+'OFF_PH2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'
--                           +'FAX1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAX_NO)),'')+'*|~*'+'FAX2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAXF_NO)),'')+'*|~*'  
--                           +'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_EMAIL_ID)),'')+'*|~*'  
--           FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no  
            SELECT @L_CONC = 
--            case when PriPhInd = 'O'  then 'OFF_PH1|*~|'
--when PriPhInd = 'M'  then 'MOBILE1|*~|'
--else 'MOBILE1|*~|' end  + ISNULL(LTRIM(RTRIM(PRIPHNUM)),'')+'*|~*'--+'OFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'  

--				    +'RES_PH1|*~|'+ISNULL(ltrim(rtrim(PRIPHNUM)),'')+'*|~*'

--						    + case when AltPhInd = 'O'  then 'OFF_PH2|*~|'
--							  when AltPhInd = 'R'  then 'RES_PH2|*~|' else 'RES_PH2|*~|' end +ISNULL(ltrim(rtrim(AltPhNum)),'')+'*|~*'
							--+'RES_PH3|*~|'+ISNULL(ltrim(rtrim(AddPh)),'')+'*|~*'
                            'FAX1|*~|'+ISNULL(LTRIM(RTRIM(FAX)),'')+'*|~*'--+'FAX2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAXF_NO)),'')+'*|~*'  
                            +'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(pri_email)),'')+'*|~*' 
                            +'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(PriPhNum)),'')+'*|~*'  
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  
          
SELECT @L_CONC = isnull(@L_CONC,'')  +'MOBSMS|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  
--changes done for 408 ------
SELECT @L_CONC = isnull(@L_CONC,'')  +'SECMOB|*~|'+ISNULL(ltrim(rtrim(AltPhNum)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  


SELECT @L_CONC = isnull(@L_CONC,'')  +'EMAIL2|*~|'+ISNULL(ltrim(rtrim(sec_email)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  

SELECT @L_CONC = isnull(@L_CONC,'')  +'SECIC|*~|'+ISNULL(ltrim(rtrim(isd_sec)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  

SELECT @L_CONC = isnull(@L_CONC,'')  +'PRIIC|*~|'+ISNULL(ltrim(rtrim(isd_pri)),'')+'*|~*' 
		--+ 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EmailId)),'')+'*|~*' 						    
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  

--changes done for 408 ------
         
           EXEC PR_INS_UPD_CONC @L_CRN_NO,'INS','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
         set @L_CONC =''
  


		   SELECT @L_DP_ACCT_VALUES = ISNULL(CONVERT(VARCHAR,@L_COMPM_ID),'')+'|*~|'+ ISNULL(CONVERT(VARCHAR,@L_EXCSM_ID),'')+'|*~|'+ISNULL(CONVERT(VARCHAR,@L_DPM_DPID),'')+'|*~|'+ISNULL(@C_BEN_ACCT_NO,'')+'|*~|'
							+ISNULL(LTRIM(RTRIM(LTRIM(RTRIM(NAME)) + ' ' +LTRIM(RTRIM(MIDDLENAME)) + ' ' +LTRIM(RTRIM(SEARCHNAME)) )),'')+'|*~|'+ ISNULL(LTRIM(RTRIM(DPINTREFNUM)),'') +'|*~|'
							+CASE WHEN BOACCTSTATUS ='1' THEN 'ACTIVE'
								  --WHEN BOACCTSTATUS ='2' THEN '02'
									WHEN BOACCTSTATUS ='2' THEN '04'  -- changed as per CDAS code on 29042013
									WHEN BOACCTSTATUS ='3' THEN '05'
									WHEN BOACCTSTATUS ='4' THEN '04'
									WHEN BOACCTSTATUS ='5' THEN '05'
									WHEN BOACCTSTATUS ='6' THEN '06' ELSE CONVERT(VARCHAR(10),BOACCTSTATUS ) END + '|*~|'
							--+CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE)+'_CDSL' ELSE CONVERT(VARCHAR(10),BOCUSTTYPE)+'_CDSL' END  + '|*~|'
							--+CASE WHEN LEN(BOCATEGORY)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCATEGORY)  ELSE CONVERT(VARCHAR(10),BOCATEGORY) END  + '|*~|' 
							+ CASE WHEN LEN(BOCATEGORY)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'  ELSE CONVERT(VARCHAR(10),BOCATEGORY)+'_CDSL'   END  + '|*~|' 
							+ CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END   + '|*~|'

						    
							+CASE WHEN LEN(ProdCode)=1 THEN '0'+ CONVERT(VARCHAR(10),ProdCode)  ELSE CONVERT(VARCHAR(10),ProdCode)   END + CASE WHEN LEN(BOCUSTTYPE)=1 THEN '0'+ CONVERT(VARCHAR(10),BOCUSTTYPE) ELSE CONVERT(VARCHAR(10),BOCUSTTYPE) END  + CASE WHEN LEN(BOSUBSTATUS)=1 THEN '0'+CONVERT(VARCHAR(10),BOSUBSTATUS)    ELSE CONVERT(VARCHAR(10),BOSUBSTATUS) END   +'|*~|0|*~|A|*~|*|~*' 
			FROM DPB9_PC1 
			WHERE  BOID = @C_BEN_ACCT_NO   
            

		   
           EXEC PR_INS_UPD_DPAM @L_CRN_NO,'INS','MIG',@L_CRN_NO,@L_DP_ACCT_VALUES,0,'*|~*','|*~|',''  
             
          
      SET @L_ADR =''

          SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*' 
    	  FROM   DPB9_PC12 WHERE BOID = @C_BEN_ACCT_NO 
           
		
	       SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO 

		   SELECT @L_ADR = @L_ADR  + 'SH_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC2 WHERE BOID = @C_BEN_ACCT_NO 

		   SELECT @L_ADR = @L_ADR  + 'TH_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC3 WHERE BOID = @C_BEN_ACCT_NO 

	       SELECT @L_ADR = @L_ADR  + 'NOMINEE_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC6 WHERE BOID = @C_BEN_ACCT_NO 


		   SELECT @L_ADR = @L_ADR  + 'GUARD_ADR|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC7 WHERE BOID = @C_BEN_ACCT_NO 

		   SELECT @L_ADR = @L_ADR  + 'NOM_GUARDIAN_ADDR|*~|'+ISNULL(LTRIM(RTRIM(ADDR1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(ADDR3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'+ISNULL(STATE ,'') + '|*~|'+ISNULL(COUNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(PINCODE)),'')+'|*~|*|~*'  
           FROM   DPB9_PC8 WHERE BOID = @C_BEN_ACCT_NO 




                  
                            
           EXEC  PR_DP_INS_UPD_ADDR @L_CRN_NO,'EDT','MIG',0,@C_BEN_ACCT_NO,'DP',@L_ADR,0,'*|~*','|*~|',''   
  
  --changes done for 408 ------
          
           SELECT @L_acc_conc = 'SECMIC|*~|'+ISNULL(ltrim(rtrim(pri_isd)),'')+'*|~*'
           +'SH_MOBILE|*~|'+ISNULL(ltrim(rtrim(pri_ph_no)),'')+'*|~*'
           FROM   DPB9_PC2 WHERE boid = @c_ben_acct_no and isnull(pri_isd,'') <> ''  
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'THMIC|*~|'+ISNULL(ltrim(rtrim(pri_isd)),'')+'*|~*'
           +'TH_MOBILE|*~|'+ISNULL(ltrim(rtrim(pri_ph_no)),'')+'*|~*'
           FROM   DPB9_PC3 WHERE boid = @c_ben_acct_no and isnull(pri_isd,'') <> ''  
           
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'NOMIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'NOMINEE_MOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC6 WHERE boid = @c_ben_acct_no and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 1                 
           
            SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'SECNOMIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'SECNOMMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC6 WHERE boid = @c_ben_acct_no and isnull(PriPhInd,'') <> ''  and NOM_Sr_No =2               
           
           
            SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'THNOMIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'THNOMMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC6 WHERE boid = @c_ben_acct_no and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 3                 
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'NOMGIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'NOM_GUARD_MOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC8 WHERE boid = @c_ben_acct_no and isnull(PriPhInd,'') <> ''   and NOM_Sr_No = 1                
           
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'SECNOMGIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'SECNOMGMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC8 WHERE boid = @c_ben_acct_no and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 2   
           
           
           SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'THNOMGIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'THNOMGMOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC8 WHERE boid = @c_ben_acct_no and isnull(PriPhInd,'') <> ''  and NOM_Sr_No = 3                   
           
           
                SELECT @L_acc_conc = isnull(@L_acc_conc ,'') + 'GUAIC|*~|'+ISNULL(ltrim(rtrim(PriPhInd)),'')+'*|~*'
           +'GUARD_MOB|*~|'+ISNULL(ltrim(rtrim(PriPhNum)),'')+'*|~*'
           FROM   DPB9_PC7 WHERE boid = @c_ben_acct_no1 and isnull(PriPhInd,'') <> ''   
           
	
         
           EXEC  pr_dp_ins_upd_CONC @l_crn_no,'EDT','MIG',0,@c_ben_acct_no,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''   
  
           set @L_acc_conc = ''  
--changes done for 408 ------	
      --dp_holder_dtls/addresses/conctact_channels  

 declare   @PA_FH_DTLS varchar(500)
			 declare   @PA_SH_DTLS varchar(500)
			 declare   @PA_TH_DTLS varchar(500)
			 declare   @PA_NOMGAU_DTLS varchar(500)
			 declare   @PA_NOM_DTLS varchar(500)
			 declare   @PA_GAU_DTLS varchar(500)
			  ,@l_nrn_no numeric


set @l_nrn_no = 0 
select @l_nrn_no = BITRM_BIT_LOCATION 
from bitmap_ref_mstr 
where bitrm_parent_cd like '%NRN_AUTO%'

update bitmap set BITRM_BIT_LOCATION = BITRM_BIT_LOCATION + 1 
from bitmap_ref_mstr bitmap
where bitrm_parent_cd like '%NRN_AUTO%'

             SET  @PA_FH_DTLS =''
			 SET  @PA_SH_DTLS =''
			 SET  @PA_TH_DTLS =''
			 SET  @PA_NOMGAU_DTLS =''
			 SET  @PA_NOM_DTLS=''
			 SET  @PA_GAU_DTLS =''
			  
			  
					   SELECT @PA_FH_DTLS = ''+'|*~|'+''+'|*~|'+''+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  
					   SELECT @PA_SH_DTLS =  ISNULL(NAME,'')+'|*~|'+ISNULL(MIDDLENAME,'')+'|*~|'+ISNULL(SEARCHNAME,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+CITRUS_USR.FNGETDATE(DATEOFBIRTH)+'|*~|'+ISNULL(LTRIM(RTRIM(PANGIR)),'')+'|*~|'+'|*~|*|~*'  FROM   DPB9_PC2 WHERE BOID = @C_BEN_ACCT_NO  
					   SELECT @PA_TH_DTLS =  ISNULL(NAME,'')+'|*~|'+ISNULL(MIDDLENAME,'')+'|*~|'+ISNULL(SEARCHNAME,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+CITRUS_USR.FNGETDATE(DATEOFBIRTH)+'|*~|'+ISNULL(LTRIM(RTRIM(PANGIR)),'')+'|*~|'+'|*~|*|~*'  FROM   DPB9_PC3 WHERE BOID = @C_BEN_ACCT_NO  
					   SELECT @PA_NOMGAU_DTLS =ISNULL(NAME,'')+'|*~|'+ISNULL(MIDDLENAME,'')+'|*~|'+ISNULL(SEARCHNAME,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+CITRUS_USR.FNGETDATE(DATEOFBIRTH)+'|*~|'+ISNULL(LTRIM(RTRIM(PANGIR)),'')+'|*~|'+'|*~|*|~*'  FROM   DPB9_PC8 WHERE BOID = @C_BEN_ACCT_NO  
--					   SELECT @PA_NOM_DTLS = ISNULL(NAME,'')+'|*~|'+ISNULL(MIDDLENAME,'')+'|*~|'+ISNULL(SEARCHNAME,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+CITRUS_USR.FNGETDATE(DATEOFBIRTH)+'|*~|'+ISNULL(LTRIM(RTRIM(PANGIR)),'')+'|*~|'+'|*~|*|~*'  FROM   DPB9_PC6 WHERE BOID = @C_BEN_ACCT_NO  
					   SELECT @PA_NOM_DTLS = ISNULL(NAME,'')+'|*~|'+ISNULL(MIDDLENAME,'')+'|*~|'+ISNULL(SEARCHNAME,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+CITRUS_USR.FNGETDATE(DATEOFBIRTH)+'|*~|'+ISNULL(LTRIM(RTRIM(PANGIR)),'')+'|*~|'+'|*~|'+convert(varchar,@l_nrn_no)+'|*~|*|~*'  FROM   DPB9_PC6 WHERE BOID = @C_BEN_ACCT_NO  and TypeOfTrans <>'3'
					   SELECT @PA_NOM_DTLS = ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+''+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+'|*~|'+convert(varchar,'')+'|*~|*|~*'  FROM   DPB9_PC6 WHERE BOID = @C_BEN_ACCT_NO  and TypeOfTrans ='3'
					   SELECT @PA_GAU_DTLS = ISNULL(NAME,'')+'|*~|'+ISNULL(MIDDLENAME,'')+'|*~|'+ISNULL(SEARCHNAME,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FTHNAME)),'')+'|*~|'+CITRUS_USR.FNGETDATE(DATEOFBIRTH)+'|*~|'+ISNULL(LTRIM(RTRIM(PANGIR)),'')+'|*~|'+'|*~|*|~*'  FROM   DPB9_PC7 WHERE BOID = @C_BEN_ACCT_NO   
			  

			IF   @PA_FH_DTLS ='' 
			SET @PA_FH_DTLS  = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' 

			IF @PA_SH_DTLS =''
			SET @PA_SH_DTLS  = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' 

			IF  @PA_TH_DTLS =''
			SET @PA_TH_DTLS  = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' 

			IF   @PA_NOMGAU_DTLS =''
			SET @PA_NOMGAU_DTLS  = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' 

			IF  @PA_NOM_DTLS=''
			SET @PA_NOM_DTLS  = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' 

			IF  @PA_GAU_DTLS =''
			SET @PA_GAU_DTLS  = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' 


           EXEC PR_INS_UPD_DPHD '0',@L_CRN_NO,@C_BEN_ACCT_NO,'INS','MIG',@PA_FH_DTLS,@PA_SH_DTLS,@PA_TH_DTLS,@PA_NOMGAU_DTLS,@PA_NOM_DTLS,@PA_GAU_DTLS,0,'*|~*','|*~|',''               
  
           
      --dp_holder_dtls/addresses/conctact_channels  
  
                        -- entity_relationship    
                          -- select @l_br_sh_name  = entm_short_name from entity_mstr ,DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and entm_short_name = br_cd  
            DECLARE @l_activation_dt varchar(20)  
            select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
			where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(BOID,8) from DPB9_PC1)
            select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
            SELECT @L_ACTIVATION_DT = CITRUS_USR.FNGETDATE(BOACTDT) FROM DPB9_PC1 TCDMC WHERE BOID = @C_BEN_ACCT_NO  
  
  
            select @l_entr_value = convert(varchar,ISNULL(@l_compm_id,0))+'|*~|'+convert(varchar,ISNULL(@l_excsm_id,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@c_ben_acct_no,'')+'|*~|'+CONVERT(varchar,@l_activation_dt)+'|*~|HO|*~|' + @@ho_cd + '|*~|RE|*~||*~|AR|*~||*~|BR|*~|'+ '|*~|SB|*~||*~|RM_BR|*~||*~|FM|*~||*~|SBFR|*~||*~|INT|*~||*~|A*|~*'  

            exec pr_ins_upd_dpentr '0','','HO',@l_crn_no,@l_entr_value ,0,'*|~* ','|*~|',''  
         -- entity_relationship   
            SET @l_activation_dt = ''  
  --brokerage
                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
						   where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  and dpm_dpid = (select top 1 left(BOID,8) from DPB9_PC1)

                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           

							declare @l_brom_id varchar(100), @l_brkg_val varchar(1000)
							set @l_brom_id  = ''
                             SELECT @L_ACTIVATION_DT = CITRUS_USR.FNGETDATE(BOACTDT) FROM DPB9_PC1 TCDMC WHERE BOID = @C_BEN_ACCT_NO  
                            select @l_brom_id = brom_id from brokerage_mstr where BROM_DESC = 'GENERAL'
                            set @l_brkg_val = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no)) +'|*~|' + @l_activation_dt+'|*~|'+ @l_brom_id +'|*~|A*|~*'
		
							if @l_brom_id  <> ''
							exec pr_ins_upd_client_brkg @l_crn_no,'','MIG',@L_crn_no,@l_brkg_val,0,'*|~*','|*~|',''
                        --brokerage
      --bank_mstr/addresses/conctact_channels  
      
      
      
           SELECT @L_BANK_NAME = LTRIM(RTRIM(DIVIFSCD)) , @L_BANM_BRANCH = LTRIM(RTRIM(DIVBANKCD)) 
			FROM   DPB9_PC1   
			WHERE  BOID = @C_BEN_ACCT_NO  
  
  
            SELECT @L_MICR_NO = DIVBANKCD FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  
  
          
             SET @L_BANM_ID = 0  
             IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE (BANM_RTGS_CD = @L_BANK_NAME AND BANM_MICR = @L_BANM_BRANCH))
             BEGIN  
                SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_RTGS_CD = @L_BANK_NAME AND BANM_MICR = @L_BANM_BRANCH)  
             END  
             ELSE   
             BEGIN  
                
               EXEC PR_MAK_BANM  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,@L_BANK_NAME,'','',0,0,'',0,'','*|~*','|*~|',''  
                 
                
               SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_RTGS_CD = @L_BANK_NAME AND BANM_MICR = @L_BANM_BRANCH)  
             END  
                              
  
  
    
  
  
        SELECT @L_CRN_NO = DPAM_CRN_NO FROM DP_ACCT_MSTR,  DPB9_PC1  
		WHERE DPAM_SBA_NO  =  BOID AND BOID = @C_BEN_ACCT_NO  
        
		SELECT @L_DPBA_VALUES = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'+ ISNULL(@L_DPM_DPID,'') + '|*~|'+ LTRIM(RTRIM(@C_BEN_ACCT_NO)) +'|*~|' + LTRIM(RTRIM(NAME))+' '+ LTRIM(RTRIM(MIDDLENAME)) + ' '+ LTRIM(RTRIM(SEARCHNAME)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+ CASE WHEN DIVACCTTYPE = '10' THEN 'SAVINGS' WHEN DIVACCTTYPE = '11' THEN 'CURRENT' ELSE 'OTHERS' END +'|*~|' + CONVERT(VARCHAR,LTRIM(RTRIM(DIVBANKACCTNO))) + '|*~|1|*~|0|*~|A*|~*'  FROM   DPB9_PC1 WHERE BOID = @C_BEN_ACCT_NO  

        EXEC PR_INS_UPD_DPBA '0','INS','MIG',@L_CRN_NO,@L_DPBA_VALUES,0,'*|~*','|*~|',''   
      --client_bank_accts  
                              
 
      --client_bank_accts */  
  
      --account_properties  
           SET @L_ACCP_VALUE = ''  
--          SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,'38') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(SEBIREGNUM)),'')) + '|*~|*|~*' FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD = 'SEBI_REG_NO'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'33') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(CLMEMID)),'')) + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'CMBP_ID'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'41') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(RBIREFNUM)),'')) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO-- AND ACCPM_PROP_CD   = 'RBI_REF_NO'  
--         --SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GROUP_CD',UPPER(ISNULL(LTRIM(RTRIM(GROUPCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'GROUP_CD'  
        
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'18') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'BANKCCY'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'27') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVBANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'DIVBANKCCY'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'16') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVIDEND_CURRENCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'DIVIDEND_CURRENCY'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'46') + '|*~|' + + + LEFT(ISNULL(LTRIM(RTRIM(CLOSDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(CLOSDT)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(CLOSDT)),''),4)  + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'ACC_CLOSE_DT'    and CLOSDT <> ''
--         --SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(BENTAXDEDSTAT)),'')) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'TAX_DEDUCTION'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'44') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(CONFWAIVED)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'CONFIRMATION'  
--SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'25') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(ECS)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'ECS_FLG'  
--         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'28') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BOSTMNTCYCLE',UPPER(ISNULL(LTRIM(RTRIM(BOSTATCYCLECD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'35') + '|*~|' + + LEFT(ISNULL(LTRIM(RTRIM(BOActDt)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(BOActDt)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(BOActDt)),''),4)  + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD   = 'BILL_START_DT'   and BOActDt <> ''
		
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'57') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler9)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'bsda'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'61') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(AnnlRep)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'RGESS_FLAG'
--        SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'42') + '|*~|' + '1'  + '|*~|*|~*'  FROM DPB9_PC16  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'SMS_FLAG'
--        SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='1' THEN 'PHYSICAL' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='2' THEN 'ELECTRONIC' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='3' THEN 'BOTH'  ELSE '0' END  + '|*~|*|~*'   FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'ANNUAL_REPORT'
--SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler7)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler7)),''))='N' THEN 'NO'  ELSE '0' END  + '|*~|*|~*'   FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'PLEDGE_STANDING'
--SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler3)),''))='PH' THEN 'PHYSICAL CAS REQUIRED' when  UPPER(ISNULL(LTRIM(RTRIM(Filler3)),''))='NO' then 'CAS NOT REQUIRED' else ''END  + '|*~|*|~*'  FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'cas_flag' --and Filler3 <> ''
        
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'77') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(rel_WITH_BO)),'')) <> '' THEN citrus_usr.fn_get_cd_rel(UPPER(ISNULL(LTRIM(RTRIM(rel_WITH_BO)),''))) ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC6  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = '1ST_NRELATN_BO'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'78') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(perc_OF_SHARES)),''))<> '' THEN UPPER(ISNULL(LTRIM(RTRIM(perc_OF_SHARES)),'')) ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC6  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = '1ST_NPER_SHR'
--		SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'79') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(RES_SEC_FLg)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(RES_SEC_FLg)),''))='N' THEN 'NO' ELSE '' END  + '|*~|*|~*'  FROM DPB9_PC6  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = '1ST_NRED_SEC_FLG'

--				 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'94') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ITCircle)),'')) + '|*~|*|~*'  FROM DPB9_PC1  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'ADHAARFLAG'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'95') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ITCircle)),'')) + '|*~|*|~*'  FROM DPB9_PC2  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'ADHAARSECHLDR'  
--		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,'96') + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ITCircle)),'')) + '|*~|*|~*'  FROM DPB9_PC3  WHERE BOID = @C_BEN_ACCT_NO --AND ACCPM_PROP_CD  = 'ADHAARTHRDHLDR'  		

	
----changes done for 408 ------
--		--SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(AnnlRep)),''))='P' THEN 'PHYSICALLY' ELSE 'ELECTRONICALLY' END  + '|*~|*|~*'  FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'BONAFIDE'
--        SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(smart_flag)),''))='Y' THEN 'YES' ELSE 'NO' END  + '|*~|*|~*'  FROM DPB9_PC1 ,ACCOUNT_PROPERTY_MSTR WHERE BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'SMART_REG'
----changes done for 408 ------	
--         SET @L_ACCPD_VALUE = ''  
--         SELECT DISTINCT @L_ACCPD_VALUE = CONVERT(VARCHAR,'41') + '|*~|' + CONVERT(VARCHAR,'6') + '|*~|'  + LEFT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),4)  + '|*~|*|~*' FROM DPB9_PC1    WHERE BOID = @C_BEN_ACCT_NO 
--         AND ISDATE(RIGHT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),4)) = 1          
  
         SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DPB9_PC1 WHERE DPAM_SBA_NO = BOID  AND BOID  = @C_BEN_ACCT_NO  
  
          --EXEC PR_INS_UPD_ACCP @L_CRN_NO ,'EDT','MIG',@L_DPAM_ID,@C_BEN_ACCT_NO,'D',@L_ACCP_VALUE,@L_ACCPD_VALUE ,0,'*|~*','|*~|',''    
      --account_properties  
  
      --entity_properties  
  
         
         SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(BEN_RBI_REF_NO)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO'  
                             
       --SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,'28') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','NATIONALITY',UPPER(ISNULL(LTRIM(RTRIM(NATCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'NATIONALITY'  
       -- SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'65') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','OCCUPATION',UPPER(ISNULL(LTRIM(RTRIM(OCCUPATION)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'OCCUPATION'  
       -- SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'12') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GEOGRAPHICAL',UPPER(ISNULL(LTRIM(RTRIM(GEOGCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'GEOGRAPHICAL'  
       -- SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'42') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','EDUCATION',UPPER(ISNULL(LTRIM(RTRIM(EDU)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'EDUCATION'  
          
       -- SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'40') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','LANGUAGE',UPPER(ISNULL(LTRIM(RTRIM(LANGCD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'LANGUAGE'  
       -- SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'64') + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'N' THEN 'NONE'   
       --                                                                                               WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'R' THEN 'RELATIVE'  
       --                                                                                               WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'S' THEN 'STAFF' ELSE '' END   + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'STAFF'  
       -- SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,'15') + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','ANNUAL_INCOME',UPPER(ISNULL(LTRIM(RTRIM(ANNINCOMECD)),'')))) + '|*~|*|~*' FROM DPB9_PC1   WHERE BOID = @C_BEN_ACCT_NO --AND ENTPM_CD   = 'ANNUAL_INCOME'  
                             
        SET @L_ENTPD_VALUE = ''  
                           --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(BEN_RBI_APP_DATE)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID  
                              
  
  
         
         --EXEC PR_INS_UPD_ENTP '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''     



 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr 
 where default_dp = excsm_id and  excsm_exch_cd= 'CDSL'  
and dpm_dpid = (select top 1 left(BOID,8) from DPB9_PC5)
  
 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id   
  
 select distinct @l_crn_no = dpam_crn_no from dp_acct_mstr, DPB9_PC5 
WHERE BOID = @c_ben_acct_no AND dpam_sba_no  =BOID
  


           
         SET @l_dppd_details = ''  
         
SELECT @l_dppd_details = @l_dppd_details  + isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end +'|*~|'+ISNULL(ltrim(rtrim(dpam_sba_name)),'') +'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(POARegNum)),'')+'|*~|'+ISNULL(ltrim(rtrim(GPABPAFlg)),'')  
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate) ,103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103),103) ELSE '' END   
  
 +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103),103) ELSE '' END   
  
 --+'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
 
+'|*~|'+ltrim(rtrim(dpam_sba_no))+'|*~|'+'0'+'|*~|'+'0|*~|0|*~|0|*~|'+'A*|~*'  
-- @l_dppd_details = @l_dppd_details + isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no,'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end  +'|*~|'+ISNULL(ltrim(rtrim(poam_name1)),'') +'|*~|'+ISNULL(ltrim(rtrim(poam_name2)),'')+'|*~|'+ISNULL(ltrim(rtrim(poam_name3)),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim('')),'')+'|*~|'+ISNULL(ltrim(rtrim(POARegNum)),'')+'|*~|'+ISNULL(ltrim(rtrim(GPABPAFlg)),'')  
  
-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(SetupDate) ,103),103) ELSE '' END   
  
-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103),103) ELSE '' END   
  
-- +'|*~|'+CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103),103) ELSE '' END   
  
-- +'|*~|'+ltrim(rtrim(poam_master_id))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
  
 FROM DPB9_PC5 , citrus_usr.poam WHERE MasterPOAId = poam_master_id and  boid = @c_ben_acct_no AND POARegNum <>''   
 
        -- select  '1',@l_crn_no,'INS','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
--        print 'tushar'
        
--        print @l_dppd_details
         if @l_dppd_details <> '' 
         EXEC pr_ins_upd_dppd '1',@l_crn_no,'INS','MIG',@l_dppd_details,0,'*|~*','|*~|',''  
  
         update dp_acct_mstr set dpam_batch_no =1 where dpam_batch_no is null and dpam_sba_no = @c_ben_acct_no and dpam_deleted_ind = 1  
               
      fetch next from @c_client_summary into @c_ben_acct_no   
    --  
    END  
                        
    CLOSE        @c_client_summary  
    DEALLOCATE   @c_client_summary  
      
     END  
       
   insert into dpb9log
select GETDATE(),'main_new','end'



 
   insert into dpb9log
select GETDATE(),'OTHERS','START'

set dateformat ymd 

     exec pr_upd_nom_dpb9
exec pr_upd_nom_g_dpb9
 exec pr_ins_upd_uccdtls_dpb9
   exec bult_entp_upd 
  exec bulk_upd_accp
  
  insert into dpb9log
select GETDATE(),'OTHERS','END'


  insert into dpb9log
select GETDATE(),'update status','Start'
Update dpam set     dpam_stam_cd =  CASE WHEN BOACCTSTATUS ='1' THEN 'ACTIVE'
WHEN BOACCTSTATUS ='2' THEN '04'
WHEN BOACCTSTATUS ='3' THEN '05'
WHEN BOACCTSTATUS ='4' THEN '04'
WHEN BOACCTSTATUS ='5' THEN '05' 
WHEN BOACCTSTATUS ='6' THEN '06' ELSE CONVERT(VARCHAR(10),BOACCTSTATUS ) END
from   dp_acct_mstr dpam
, DPs8_PC1
where  dpam_sba_no =  BOID-- and  dpam_stam_cd not in ('02_BILLSTOP' , '05' )
and  dpam_stam_cd <>  CASE WHEN BOACCTSTATUS ='1' THEN 'ACTIVE'
WHEN BOACCTSTATUS ='2' THEN '04'
WHEN BOACCTSTATUS ='3' THEN '05'
WHEN BOACCTSTATUS ='4' THEN '04'
WHEN BOACCTSTATUS ='5' THEN '05' 
WHEN BOACCTSTATUS ='6' THEN '06' ELSE CONVERT(VARCHAR(10),BOACCTSTATUS ) END
and boid like '120%' 

  insert into dpb9log
select GETDATE(),'update status','End'


--     update a set dpam_bbo_code=accp_value from dp_acct_mstr  a
--,account_properties
--where isnull(dpam_bbo_code,'')<>accp_value
--and accp_lst_upd_dt >='sep  1 2012'
--and accp_clisba_id = dpam_id 
--and ACCP_ACCPM_PROP_CD = 'bbo_code' 
     
	  
UPDATE filetask
SET    uploadfilename = isnull(uploadfilename ,'') 
+  citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\')   
--+ 'FILE DATA COUNT : '  + convert(varchar,(SELECT COUNT(DISTINCT Citrus_usr.fn_splitval_by(VALUE,2,'~') ) FROM dpb9_source  WHERE LEFT (VALUE,2) = '00')) 
--+ ' DATA INSERTED : ' + convert(varchar,@l_insertedcount+isnull(@l_insertedcount_pl,0))    
+  case when exists(select 1 from filetask 
					where citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\') = citrus_usr.fn_splitval_by(uploadfilename,1,'~')
					
					) then  '--> File Already Imported' else '' end 
,  TASK_FILEDATE =( SELECT TOP 1 CONVERT (DATETIME ,LEFT (citrus_usr.fn_splitval_by(VALUE,4,'~'),2)+ '/'+SUBSTRING (citrus_usr.fn_splitval_by(VALUE,4,'~'),3,2)+ '/' + RIGHT (citrus_usr.fn_splitval_by(VALUE,4,'~'),4) ,103)
FROM dpb9_source  WHERE LEFT (VALUE,1) = 'h')
WHERE  task_id = (select TOP 1 TASK_ID  from filetask where TASK_NAME LIKE 'CLIENT MASTER IMPORT-DPB9DPS8-CDSL%' AND STATUS = 'RUNNING' )



INSERT INTO DPB9LOG
SELECT GETDATE(),'DPB9 MAIN','END'
   
--    
END

GO
