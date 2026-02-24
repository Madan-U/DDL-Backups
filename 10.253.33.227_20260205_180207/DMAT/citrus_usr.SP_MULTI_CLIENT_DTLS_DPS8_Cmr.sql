-- Object: PROCEDURE citrus_usr.SP_MULTI_CLIENT_DTLS_DPS8_Cmr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE PROCEDURE [citrus_usr].[SP_MULTI_CLIENT_DTLS_DPS8_Cmr]  
(   
@PA_FROM_ACCTNO VARCHAR(16),  
@PA_TO_ACCTNO VARCHAR(30),  
@PA_EXCSMID INT,  
@pa_login_pr_entm_id numeric,                
@pa_login_entm_cd_chain  varchar(8000)     
)  
AS  
BEGIN -- MAIN  
  
declare @l_bbo_code varchar(100) ,@l_close_dt varchar(15)  
set @l_bbo_code =''    
set @l_bbo_code = citrus_usr.fn_splitval(@PA_TO_ACCTNO,2)    
SET @PA_TO_ACCTNO = citrus_usr.fn_splitval(@PA_TO_ACCTNO,1)    
  
  
 IF @PA_FROM_ACCTNO = ''  and    @l_bbo_code<>''       
 BEGIN              
  SET @PA_FROM_ACCTNO = '0'              
  SET @PA_TO_ACCTNO = '99999999999999999'              
 END              
  
  
  
  if @l_bbo_code <> ''   
  begin   
  select @PA_FROM_ACCTNO = dpam_sba_no 
  from dp_acct_mstr where dpam_bbo_code = @l_bbo_code  and dpam_deleted_ind = 1   
    set @PA_TO_ACCTNO = @PA_FROM_ACCTNO  
  end   

  set @l_close_dt = ''
  select @l_close_dt = accp_value 
  from account_properties where accp_acct_no = @PA_FROM_ACCTNO and accp_accpm_prop_cd ='ACC_CLOSE_DT'

   
--IF @PA_TO_ACCTNO = '' or @PA_TO_ACCTNO <> ''             
-- BEGIN          
--   SET @PA_TO_ACCTNO = @PA_FROM_ACCTNO              
-- END      
  
--print @PA_FROM_ACCTNO  
--print @PA_TO_ACCTNO  
--print @l_bbo_code  
  
--  
--  
--select accp_value bbo ,dpam_sba_no clientid     
--into #bbocode  from account_properties , dp_Acct_mstr   
--where accp_accpm_prop_Cd='bbo_code'    
--and accp_clisba_id = dpam_id     
    
 --create clustered index ix_1 on #bbocode(clientid,bbo)    
  
DECLARE @@DPMID INT                       
SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSMID AND DPM_DELETED_IND =1      
DECLARE @@L_CHILD_ENTM_ID      NUMERIC                
SELECT @@L_CHILD_ENTM_ID =  CITRUS_USR.FN_GET_CHILD(@PA_LOGIN_PR_ENTM_ID , @PA_LOGIN_ENTM_CD_CHAIN)    
  
SELECT @@L_CHILD_ENTM_ID = case when @@L_CHILD_ENTM_ID  ='0' then @PA_LOGIN_PR_ENTM_ID else @@L_CHILD_ENTM_ID end   
print @PA_LOGIN_PR_ENTM_ID  
print @@L_CHILD_ENTM_ID  


  
--  SELECT distinct case when isnull(fre_action,'')= 'F' then 'FREEZED' else 
--		case when @l_close_dt <> '' then  STAM_DESC + ':' + @l_close_dt 
--			 when dpam.dpam_stam_cd = '04' then STAM_DESC + ':' + convert(varchar(11),dpam.dpam_lst_upd_dt ,106)
--				else STAM_DESC end end [STATUS]  
SELECT distinct 
case when (isnull(fre_action,'')= 'F' and  dpam.dpam_stam_cd  <> '05') then STAM_DESC-- + ': ' + 'FREEZED' 
			else  case when (@l_close_dt <> '' ) then  STAM_DESC + ': ' + convert(varchar(11),@l_close_dt,106)  --and dpam.dpam_stam_cd <> '04' remove condition as per naresh sir request on dec 23 2013
					   when (@l_close_dt = '' and dpam.dpam_stam_cd = '04') then STAM_DESC + ': ' + isnull( substring(dps8_pc1.ClosDt,0,3) + '-' + substring(dps8_pc1.ClosDt,3,2)+ '-' +substring(dps8_pc1.ClosDt,5,4),'')
--isnull(REPLACE(CONVERT(VARCHAR(11),dps8_pc1.ClosDt, 106), ' ', '-'),'')
							else STAM_DESC   end end
--+ ' '+ space(8)+ ' - ' + isnull(fre_rmks,'')

+  case when isnull(fre_action,'')= 'F'  then  ' '+ space(8)+ ' - ' + 
					case when dps8_pc4.FreezeResCd = '1' then  'Beneficial Owner'
						 when dps8_pc4.FreezeResCd = '2' then  'ITO Attachment'
						 when dps8_pc4.FreezeResCd = '3' then  'SEBI Directive'
						 when dps8_pc4.FreezeResCd = '4' then  'Disinvestment & Private Deals'
						 when dps8_pc4.FreezeResCd = '5' then  'Court Order'
						 when dps8_pc4.FreezeResCd = '6' then  'PAN verification pending'
						 when dps8_pc4.FreezeResCd = '7' then  'Sole/First Holder Deceased'
						 when dps8_pc4.FreezeResCd = '8' then  'Second Holder Deceased'
						 when dps8_pc4.FreezeResCd = '9' then  'Third Holder Deceased'
						 when dps8_pc4.FreezeResCd = '10' then  'Order from Special Recovery Officer'
						 when dps8_pc4.FreezeResCd = '11' then  'CBI Order'
						 when dps8_pc4.FreezeResCd = '12' then  'FIU-IND Requirement'
						 when dps8_pc4.FreezeResCd = '13' then  'In Person Verification pending'
						 when dps8_pc4.FreezeResCd = '14' then  'Assignment'
						 when dps8_pc4.FreezeResCd = '16' then  'Initiated By BO'
						 when dps8_pc4.FreezeResCd = '17' then  'Requested By BO'
						 when dps8_pc4.FreezeResCd = '95' then  'RGESS Freeze'
						 when dps8_pc4.FreezeResCd = '96' then  'Restrained PAN'
						 when dps8_pc4.FreezeResCd = '97' then  'Minor Attained Majority'
						 when dps8_pc4.FreezeResCd = '98' then  'PAN not recorded'
						 when dps8_pc4.FreezeResCd = '27' then  'ACCOUNT HOLDER RELATED KYC NON-COMPLIANT'
						 else '' end else '' end 
+ 
case when dps8_pc1.ClosInitBy = 1  then '-By BO'
	 when dps8_pc1.ClosInitBy = 2  then '-By DP'
	 when dps8_pc1.ClosInitBy = 3  then '-By CDSL' else '' end  [STATUS]  
--DISTINCT top 1 case when fre_action = 'F' then 'FREEZED' else STAM_DESC end [STATUS]  
  ,CLICM_DESC  [CATEGORY]  
  ,REPLACE (replace ( replace ( SUBCM_DESC , '-',''),'/',''),'INDIVIDUALHUFSAOPS','INDIVIDUAL-HF')   [SUBCATEGORY]  
  ,ENTTM_DESC  [TYPE]  
  --,case when isnumeric(right(dps8_pc1.DateOfBirth,4))=1 and right(dps8_pc1.DateOfBirth,4) > 1900 
  --then convert(varchar(11),convert(datetime,case when isnull(dps8_pc1.DateOfBirth,'') <> '' 
  --then left(dps8_pc1.DateOfBirth,2)+'/'+substring(dps8_pc1.DateOfBirth,3,2)+'/'+right(dps8_pc1.DateOfBirth,4) else '' end ,103) ,103) 
  --else dps8_pc1.DateOfBirth end + space(8) + '(' + isnull(dps8_pc1.usrtxt1,'') + ')' clim_dob  
  ,case when isnumeric(right(dps8_pc1.DateOfBirth,4))=1 and right(dps8_pc1.DateOfBirth,4) > 1900 
  then convert(varchar(11),convert(datetime,case when isnull(dps8_pc1.DateOfBirth,'') <> '' 
  then left(dps8_pc1.DateOfBirth,2)+'/'+substring(dps8_pc1.DateOfBirth,3,2)+'/'+right(dps8_pc1.DateOfBirth,4) else '' end ,103) ,103) 
  else dps8_pc1.DateOfBirth end + space(8)  clim_dob  
  ,isnull(ltrim(rtrim(dps8_pc12.Addr1)),'') [PADDRESS1]  
  ,isnull(ltrim(rtrim(dps8_pc12.Addr2)),'') + ' ' + isnull(ltrim(rtrim(dps8_pc12.Addr3)),'') [PADDRESS2]  
  ,isnull(ltrim(rtrim(dps8_pc12.City)),'') [PCITY]   
  ,isnull(ltrim(rtrim(dps8_pc12.State)),'') [PSTATE]  
  ,isnull(ltrim(rtrim(dps8_pc12.Country)),'') [PCOUNTRY]  
  ,isnull(ltrim(rtrim(dps8_pc12.PinCode)),'') [PPIN CODE]  
  ,CASE WHEN dps8_pc1.PriPhInd='O' THEN ltrim(rtrim(isnull(dps8_pc1.PriPhNum,''))) ELSE ltrim(rtrim(isnull(dps8_pc1.PriPhNum,'')))  END  [RESPHONENO] --res_ph1  
  ,CASE WHEN dps8_pc1.AltPhInd='O' THEN ltrim(rtrim(isnull(dps8_pc1.AltPhNum,''))) ELSE ltrim(rtrim(isnull(dps8_pc1.AltPhNum,'')))  END [RESPHONENO2]--res_ph2  
  ,ltrim(rtrim(isnull(dps8_pc12.PriPhNum,'')))   [P_RESPHONENO] --res_ph1  
  ,'' [P_RESPHONENO2]--res_ph2  
  
  , isnull(ltrim(rtrim(dps8_pc1.Addr1)),'') [CADDRESS1]  
  , isnull(ltrim(rtrim(dps8_pc1.Addr2)),'') +' ' +isnull(ltrim(rtrim(dps8_pc1.Addr3)),'')  [CADDRESS2]  
  , isnull(ltrim(rtrim(dps8_pc1.City)),'') [CCITY]  
  , isnull(ltrim(rtrim(dps8_pc1.State)),'') [CSTATE]  
  , isnull(ltrim(rtrim(dps8_pc1.Country)),'') [CCOUNTRY]  
  , isnull(ltrim(rtrim(dps8_pc1.PinCode)),'') [CPIN CODE]  
, isnull(ltrim(rtrim(dps8_pc1.Title)),'') [Title_FH]

  --,CITRUS_USR.FN_CONC_VALUE(DPAM.DPAM_CRN_NO,'RES_PH1') [OFFPHONENO] --commented by pankaj on 14062011  
  ,  ltrim(rtrim(isnull(dps8_pc1.PriPhNum,''))) [OFFPHONENO]--of_ph1  
  ,BANM_NAME + ','+ isnull(TMPBA_DP_BANK_ADD1,'') [BADDRESS1]  
 ,isnull(TMPBA_DP_BANK_ADD2,'')   +' ' +isnull(ltrim(rtrim(TMPBA_DP_BANK_ADD3)),'')   [BADDRESS2]   
  ,isnull(TMPBA_DP_BANK_CITY,'') [BCITY]  
  ,isnull(TMPBA_DP_BANK_STATE,'') [BSTATE]  
  ,isnull(TMPBA_DP_BANK_CNTRY,'') [BCOUNTRY]  
  ,isnull(TMPBA_DP_BANK_ZIP,'') [BPIN CODE]  
  --,CITRUS_USR.FN_CONC_VALUE(BANM_ID,'RES_PH1') [OFFPHONENO]  
  , case when isnull(MobileNum,'') <> '' then isnull(MobileNum,'') else  case when  dps8_pc1.PriPhInd = 'M' then  dps8_pc1.PriPhNum else dps8_pc1.PriPhNum end end [MOBILE] --mobile sms else mobile 
--, case when isnull(dps8_pc16.MobileNum,'') <> '' and dps8_pc1.ClosDt=''  then isnull(dps8_pc16.MobileNum,'') else '' end [mobilesms] --mobile sms else mobile     
, ISNULL (dps8_pc1.PriPhNum,'' )[MOBILESMS] 
  --,  dps8_pc1.pri_email [EMAIL] --email  
  ,case when  isnull (dps8_pc1.pri_email,'') = '' then dps8_pc1.EMailId  else isnull (dps8_pc1.pri_email,'') end  [EMAIL] --email  
,  dps8_pc12.EMailId [p_EMAIL] --email  
  ,  dps8_pc1.Fax [FAX1]--fax1  
 ,  dps8_pc12.Fax [p_FAX1]--fax1  
  , ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BA'),isnull(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'BR'),'')) + '-' + ISNULL(CITRUS_USR.FN_FIND_RELATIONS_NM(DPAM.DPAM_CRN_NO,'BA'),isnull(CITRUS_USR.FN_FIND_RELATIONS_NM(DPAM.DPAM_CRN_NO,'BR'),''))  BRANCH --br/ba  
  , ISNULL(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'REM'),isnull(CITRUS_USR.FN_FIND_RELATIONS(DPAM.DPAM_CRN_NO,'ONW'),'')) + '-' + ISNULL(CITRUS_USR.FN_FIND_RELATIONS_NM(DPAM.DPAM_CRN_NO,'REM'),isnull(CITRUS_USR.FN_FIND_RELATIONS_NM(DPAM.DPAM_CRN_NO,'ONW'),'')) ONWARD --onw\rem  
  ,DPAM.DPAM_SBA_NO CLIENTID  
  ,case when CLIM_NAME3 ='' then clim_short_name else CLIM_NAME3  end SHORTNAME  
  --,CLIM_NAME1,CLIM_NAME2,CLIM_NAME3  
   ,isnull(dps8_pc1.Name,'') CLIM_NAME1,isnull(dps8_pc1.middlename,'') CLIM_NAME2,isnull(dps8_pc1.searchname,'') CLIM_NAME3  
  --,CONVERT(VARCHAR(11),CLIM_CREATED_DT ,105) ACTDT  
  , left(dps8_pc1.AcctCreatDt,2) + '/' +  substring(dps8_pc1.AcctCreatDt,3,2) + '/'  + right(dps8_pc1.AcctCreatDt,4) ACTDT  
  ,case when ClosDt <> '' then left(dps8_pc1.ClosDt,2) +'/'+ substring(dps8_pc1.ClosDt,3,2)+'/'+right(dps8_pc1.ClosDt,4) else '' end CLDT  
  ,DPAM.dpam_sba_name  CLIM_NAME1  
  , dps8_pc1.DivBankAcctNo CLIBA_AC_NO  
  ,case when  dps8_pc1.DivAcctType ='10' then 'Savings Bank Account' when  dps8_pc1.DivAcctType ='11' then 'Current Account'  ELSE 'OTHERS' END CLIBA_AC_TYPE  
  ,isnull(BANM_NAME,'') BANM_NAME --citrus_usr.fn_splitval_by(isnull(BANM_NAME,''),'1','-') BANM_NAME  
  ,isnull( dps8_pc1.DivBankCd,'') BANM_MICR  
  ,isnull( dps8_pc1.DivIFScd,'') IFS_CODE  
  , dps8_pc1.PANGIR PAN    
  ,CASE WHEN  dps8_pc1.PANGIR <> '' THEN 'Verified' ELSE 'Not Verified' END  PANFLAG    
  ,CASE WHEN  dps8_pc16.MobileNum<>'' and dps8_pc1.ClosDt=''  THEN 'Y' ELSE 'N' END  SMS    
        ,SEBIRegNum SEBI_REG_NO  
        --,RBIAppDt RBI_APP_DATE  ,RBIRefNum 
,case when RBIAppDt <> '' then left(dps8_pc1.RBIAppDt,2) +'/'+ substring(dps8_pc1.RBIAppDt,3,2)+'/'+right(dps8_pc1.RBIAppDt,4) else '' end RBI_APP_DATE ,RBIRefNum 
        ,case when Occupation  = 'B'then 'Business'   
                        when Occupation  = 'F' then 'Farmer'                        
                        when Occupation  =  'H' then 'House Wife'                       
                        when Occupation  = 'O' then 'Others'                                                                     
                        when Occupation  = 'P' then 'Professional'                        
                        when Occupation  = 'R' then 'Retired'                        
                        when Occupation  =  'S' then 'Service'                       
                        when Occupation  =  'ST' then 'Student'    
         when Occupation  = 'PV' then 'PRIVATE SECTOR'  
      when Occupation  = 'PS' then 'PUBLIC SECTOR'  
      when Occupation  = 'GS' then 'GOVERNMENT SERVICES' else '' end     
OCCUPATION   
  -- ,ISNULL(CITRUS_USR.FN_UCC_ENTP(DPAM.DPAM_CRN_NO,'SMS_FLAG',''),'') SMS   
,case when BenTaxDedStat  = '1'  then  'Exempt'                      
                        when BenTaxDedStat= '2' then 'Resident Individual'                       
                        when BenTaxDedStat=  '3' then 'NRI With Repatriation'                       
                        when BenTaxDedStat= '4' then    'NRI Without Repatriation'                    
                        when BenTaxDedStat=  '5' then 'Domestic Companies'                       
                        when BenTaxDedStat=  '6' then 'Overseas Corporate Bodies'                       
                        when BenTaxDedStat=  '7' then 'Foreign Companies'                        
                        when BenTaxDedStat= '8'then    'Mutual Funds'                     
                        when BenTaxDedStat= '9' then  'Double Taxation Treaty'                        
                        when BenTaxDedStat= '10' then 'Others' else ''end TAXDEDUCTION   
    
     --, citrus_usr.fn_get_listing('TAX_DEDUCTION',isnull(citrus_usr.fn_ucc_entp(DPAM.DPAM_CRN_NO,'TAX_DEDUCTION',''),''))  TAXDEDUCTION   
  --, '' DPPD_FNAME --ISNULL(DPPD_FNAME,'') DPPD_FNAME  
  ,case when exists (select 1 from dps8_pc5 where boid =@PA_FROM_ACCTNO and TypeOfTrans in ('','1','2','4'))  then citrus_usr.fn_get_poa_name(dpam_sba_no) else '' end DPPD_FNAME        
  ,case when exists (select 1 from dps8_pc5 where boid =@PA_FROM_ACCTNO and TypeOfTrans in ('','1','2','4'))  then '' else '' end DPPD_MNAME        
  ,case when exists (select 1 from dps8_pc5 where boid =@PA_FROM_ACCTNO and TypeOfTrans in ('','1','2','4'))  then citrus_usr.fn_get_poa_id(dpam_sba_no) else '' end DPPD_LNAME        
  ,case when exists (select 1 from dps8_pc5 where boid =@PA_FROM_ACCTNO and TypeOfTrans in ('','1','2','4'))  then CASE WHEN isnull(convert(varchar(11),'',106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),'',106),'') END else '' end DPPD_DOB        
  ,case when exists (select 1 from dps8_pc5 where boid =@PA_FROM_ACCTNO and TypeOfTrans in ('','1','2','4'))  then ISNULL('','') else '' end  DPPD_PAN_NO      
  ,ltrim(rtrim(isnull(DPS8_PC2.Name,''))) DPHD_SH_FNAME  
  ,ltrim(rtrim(isnull(DPS8_PC2.MiddleName,''))) DPHD_SH_MNAME  
  ,ltrim(rtrim(isnull(DPS8_PC2.SearchName,''))) DPHD_SH_LNAME  
  ,ltrim(rtrim(isnull(DPS8_PC2.DateofBirth,''))) DPHD_SH_DOB  
  ,ltrim(rtrim(isnull(DPS8_PC2.PANGIR,''))) DPHD_SH_PAN_NO  
,ltrim(rtrim(isnull(DPS8_PC2.Title,''))) Title_SH 
  ,ltrim(rtrim(isnull(DPS8_PC3.Title,''))) Title_TH 
  ,ltrim(rtrim(isnull(DPS8_PC3.Name,''))) DPHD_TH_FNAME  
  ,ltrim(rtrim(isnull(DPS8_PC3.MiddleName ,'')))DPHD_TH_MNAME  
  ,ltrim(rtrim(isnull(DPS8_PC3.SearchName,''))) DPHD_TH_LNAME  
  ,ltrim(rtrim(isnull(DPS8_PC3.DateofBirth,''))) DPHD_TH_DOB  
  ,ltrim(rtrim(isnull(DPS8_PC3.PANGIR,''))) DPHD_TH_PAN_NO  
        ,ltrim(rtrim(isnull(DPS8_PC6.DateOfBirth,''))) DPHD_NOM_DOB  
  ,ltrim(rtrim(isnull(DPS8_PC6.PANGIR,''))) DPHD_NOM_PAN_NO  
  ,ltrim(rtrim(isnull(DPS8_PC6.Name,''))) +' '+ ltrim(rtrim(isnull(DPS8_PC6.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC6.SearchName ,'')))  DPHD_NOM_FNAME  
  ,ltrim(rtrim(isnull(DPS8_PC6.MiddleName,''))) DPHD_NOM_MNAME  
  ,ltrim(rtrim(isnull(DPS8_PC6.SearchName ,'')))DPHD_NOM_LNAME  
  ,ltrim(rtrim(isnull(DPS8_PC1.FthName,''))) DPHD_FH_FTHNAME  
  ,'' dobminor  
  --,'' poa_asign  
,(select top 1 dps8_pc5.POARegNum from dps8_pc5 where BOId = dpam_sba_no) poa_asign

 ,(select top 1  BOName from dps8_pc18 where BOId = dpam_sba_no)  Auth_name

  ,(select top 1 case  when HolderNum= '1 ' then 'First Holder'                      
                 when HolderNum= '2'  then 'Second Holder'                       
                 when HolderNum= '3'  then 'Third Holder'                       
                                           
                  else '' end   from dps8_pc5 where BOId = dpam_sba_no) HolderNum

  ,ltrim(rtrim(isnull(DPS8_PC6.Addr1,''))) [NADDRESS1]  
  ,ltrim(rtrim(isnull(DPS8_PC6.Addr2,''))) +ltrim(rtrim(isnull(DPS8_PC6.Addr3,''))) NADDRESS2  
  ,ltrim(rtrim(isnull(DPS8_PC6.City,''))) [nCITY]  
  ,ltrim(rtrim(isnull(DPS8_PC6.State,''))) [nSTATE]  
  ,ltrim(rtrim(isnull(DPS8_PC6.Country,''))) [nCOUNTRY]  
  ,ltrim(rtrim(isnull(DPS8_PC6.PinCode,''))) [nPINCODE]  

--,ltrim(rtrim(isnull(DPS8_PC6.Title, ''))) [Title_NOM]
--,'' Title_NOM 

,(select top 1 DPS8_PC6.Title from DPS8_PC6 where BOId = dpam_sba_no) Title_NOM

,(select top 1 DPS8_PC8.Title from DPS8_PC8 where BOId = dpam_sba_no) Title_GNOM
,(select top 1 DPS8_PC7.Title from DPS8_PC7 where BOId = dpam_sba_no) Title_Gua

--,ltrim(rtrim(isnull(DPS8_PC7.Title, ''))) [Title_GNOM]
--,'' Title_GNOM 

   ,case when isnull(DPS8_PC7.DateOfBirth,'') <> '' then left(DPS8_PC7.DateOfBirth,2) +'/'+ substring(DPS8_PC7.DateOfBirth,3,2)+'/'+right(DPS8_PC7.DateOfBirth,4) else '' end DPHD_gau_DOB  
  ,ltrim(rtrim(isnull(DPS8_PC7.PANGIR,''))) DPHD_gau_PAN_NO  
  ,ltrim(rtrim(isnull(DPS8_PC7.Name,'')))+' '+ltrim(rtrim(isnull(DPS8_PC7.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC7.SearchName,''))) DPHD_gau_FNAME  
  ,ltrim(rtrim(isnull(DPS8_PC7.MiddleName,''))) DPHD_gau_MNAME  
  ,ltrim(rtrim(isnull(DPS8_PC7.SearchName,''))) DPHD_gau_LNAME  
  ,ltrim(rtrim(isnull(DPS8_PC7.Addr1,''))) [GADDRESS1]  
  ,ltrim(rtrim(isnull(DPS8_PC7.Addr2,''))) + ltrim(rtrim(isnull(DPS8_PC7.Addr3,''))) GADDRESS2  
  ,ltrim(rtrim(isnull(DPS8_PC7.City,''))) [GCITY]  
  ,ltrim(rtrim(isnull(DPS8_PC7.State,''))) [GSTATE]  
  ,ltrim(rtrim(isnull(DPS8_PC7.Country,''))) [GCOUNTRY]  
  ,ltrim(rtrim(isnull(DPS8_PC7.PinCode,''))) [GPINCODE]  
,case when isnull(DPS8_PC8.DateOfBirth,'') <> '' then left(DPS8_PC8.DateOfBirth,2) +'/'+ substring(DPS8_PC8.DateOfBirth,3,2)+'/'+right(DPS8_PC8.DateOfBirth,4) else '' end DPHD_nomgau_DOB  
  ,ltrim(rtrim(isnull(DPS8_PC8.PANGIR,''))) DPHD_nomgau_PAN_NO  
  ,ltrim(rtrim(isnull(DPS8_PC8.Name,'')))+' '+ltrim(rtrim(isnull(DPS8_PC8.MiddleName,'')))+' '+ltrim(rtrim(isnull(DPS8_PC8.SearchName,''))) DPHD_nomgau_FNAME  
  ,ltrim(rtrim(isnull(DPS8_PC8.MiddleName,''))) DPHD_nomgau_MNAME  
  ,ltrim(rtrim(isnull(DPS8_PC8.SearchName,''))) DPHD_nomgau_LNAME  
  ,ltrim(rtrim(isnull(DPS8_PC8.Addr1,''))) [nGADDRESS1]  
  ,ltrim(rtrim(isnull(DPS8_PC8.Addr2,''))) + ltrim(rtrim(isnull(DPS8_PC8.Addr3,''))) nGADDRESS2  
  ,ltrim(rtrim(isnull(DPS8_PC8.City,''))) [nGCITY]  
  ,ltrim(rtrim(isnull(DPS8_PC8.State,''))) [nGSTATE]  
  ,ltrim(rtrim(isnull(DPS8_PC8.Country,''))) [nGCOUNTRY]  
  ,ltrim(rtrim(isnull(DPS8_PC8.PinCode,''))) [nGPINCODE] 
  ,case when isnull(ConfWaived,'') ='' then 'N' else  isnull(ConfWaived,'') end  CONFIRMATION  
  ,case when isnull(ecs,'') ='' then 'N' else  isnull(ecs,'') end  ECS  
  ,DPIntRefNum INREFNO  
  --,CLIM_DOB         
  ,case when Occupation  = 'B'then 'Business'   
                        when Occupation  = 'F' then 'Farmer'                        
                        when Occupation  =  'H' then 'House Wife'                       
       when Occupation  = 'O' then 'Others'                                                                     
                        when Occupation  = 'P' then 'Professional'                        
                        when Occupation  = 'R' then 'Retired'                        
                        when Occupation  =  'S' then 'Service'                       
                        when Occupation  =  'ST' then 'Student'    
         when Occupation  = 'PV' then 'PRIVATE SECTOR'  
      when Occupation  = 'PS' then 'PUBLIC SECTOR'  
      when Occupation  = 'GS' then 'GOVERNMENT SERVICES' else '' end   OCCUPATION   
    ,dpam_acct_no formno  
    ,ISNULL(brom_desc,'') scheme  
    ,case when isnull(edu,'') = '01' then  'High School'                      
                        when isnull(edu,'') = '02'   then 'Graduate'                     
                        when isnull(edu,'') = '03'  then 'Post Graduate'                      
                        when isnull(edu,'') = '04'  then 'Doctrate'                                                                   
                        when isnull(edu,'') =  '05'   then 'Proffessional Degree'                     
                        when isnull(edu,'') =  '06' then 'Under High School'                            
                        when isnull(edu,'') =  '08'        then 'Others'                       
                        when isnull(edu,'') =  '07'     then 'Illiterate' else '' end EDUCATION  
    ,dpam_bbo_code BBO_CODE  
    ,isnull(accd_doc_path,'') accd_doc_path  
 ,ACCD_BINARY_IMAGE   
 ,clidb_created_dt   
 ,case when clim_gender = 'M' then 'M'   
    when clim_gender = 'F' then 'F' else '' end Gender  
    ,DivIFScd ifsc  
 , STAM_DESC  [CDASSTATUS]  
    ,isnull(dps8_pc1.AnnlRep,'N') RGESS  
 ,isnull(dps8_pc1.Filler9,'N') BSDA  
--,fre_lst_upd_dt
, isnull([citrus_usr].[fn_reverse_mapping] ('CDSL','ANNUAL_INCOME',dps8_pc1.AnnIncomeCd),'') INCOME
, isnull([citrus_usr].[fn_reverse_mapping] ('CDSL','NATIONALITY',dps8_pc1.NatCd),'') NATIONALITY

, isnull([citrus_usr].[fn_reverse_mapping] ('CDSL','BOSTMNTCYCLE',dps8_pc1.BOStatCycleCd),'') BOSTMNTCYCLE
, dps8_pc6.NOM_Sr_No Nom_sr_no 
--, dps8_pc6.rel_WITH_BO rel_with_bo
,case when  dps8_pc6.rel_with_bo ='1' then 'Spouse'
when  dps8_pc6.rel_with_bo ='2' then 'Son'
when  dps8_pc6.rel_with_bo ='3' then 'Daughter'
when  dps8_pc6.rel_with_bo ='4' then 'Father'
when  dps8_pc6.rel_with_bo ='5' then 'Mother'
when  dps8_pc6.rel_with_bo ='6' then 'Brother'
when  dps8_pc6.rel_with_bo ='7' then 'Sister'
when  dps8_pc6.rel_with_bo ='8' then 'Grand-Son'
when  dps8_pc6.rel_with_bo ='9' then 'Grand-Daughter'
when  dps8_pc6.rel_with_bo ='10' then 'Grand-Father'
when  dps8_pc6.rel_with_bo ='11' then 'Grand-Mother'
when  dps8_pc6.rel_with_bo ='12' then 'Not Provided (if the relationship is not provided on nomination form)'
when  dps8_pc6.rel_with_bo ='13' then 'Others' else '' end  rel_with_bo
,DPS8_PC6.perc_OF_SHARES perc_of_shares
, DPS8_PC6.DateOfBirth DPHD_NOM_DOB
 , DPS8_PC6.PANGIR DPHD_NOM_PAN_NO
, ltrim(rtrim(isnull(DPS8_PC6.Name,''))) DPHD_NOM_FNAME
,ltrim(rtrim(isnull(DPS8_PC6.MiddleName,'')))DPHD_NOM_MNAME--
,ltrim(rtrim(isnull(DPS8_PC6.SearchName,''))) DPHD_NOM_LNAME
,DPS8_PC6.Addr1 NADDRESS1
, DPS8_PC6.Addr2 NADDRESS2
,DPS8_PC6.City nCITY
,DPS8_PC6.State nSTATE
,DPS8_PC6.Country nCOUNTRY
,DPS8_PC6.PinCode nPINCODE
 
FROM    DP_ACCT_MSTR DPAM  
left outer join client_bank_accts on cliba_clisba_id = dpam_id and CLIBA_DELETED_IND = 1 and CLIBA_FLG = 1 
left outer join  
  BANK_MSTR    on   banm_id = cliba_banm_id and BANM_DELETED_IND = 1  
left outer join freeze_unfreeze_dtls on fre_Dpam_id = dpam.dpam_id and fre_deleted_ind = 1 and fre_action = 'F'   
  left outer join dps8_pc1  dps8_pc1  on dps8_pc1.boid = dpam_sba_no   left outer join dps8_pc4 dps8_pc4 on dps8_pc4.boid = dpam_sba_no and dps8_pc1.boid = dps8_pc4.boid and dps8_pc4.typeoftrans not in ('3','4')
left outer join  
bank_addresses_dtls on TMPBA_DP_BANK = isnull( dps8_pc1.DivBankCd,'')  and TMPBA_DP_BR = isnull( dps8_pc1.DivIFScd,'')
--left outer join  
-- ( select  max(banm_name ) banm_name ,banm_micr,banm_rtgs_cd ,banm_deleted_ind from  BANK_MSTR   group by banm_deleted_ind,banm_micr,banm_rtgs_cd ) bank_mstr on   TMPBA_DP_BANK = banm_micr and TMPBA_DP_BR = banm_rtgs_cd and BANM_DELETED_IND = 1    

  left outer join dps8_pc2  dps8_pc2  on dps8_pc2.boid = dps8_pc1.boid   
  left outer join dps8_pc3  dps8_pc3  on dps8_pc3.boid = dps8_pc1.boid   
  left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,  
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,NOM_Sr_No,rel_WITH_BO, perc_OF_SHARES, DateOfSetup D  
FROM dps8_pc6 where TypeOfTrans<>'3' GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,  
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,rel_WITH_BO, NOM_Sr_No, perc_OF_SHARES , DateOfSetup)  dps8_pc6  on dps8_pc6.boid = dps8_pc1.boid  

 
  left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,  
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D  
FROM dps8_pc7 where TypeOfTrans<>'3' GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,  
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc7  on dps8_pc7.boid = dps8_pc1.boid   
left outer join (SELECT BOID,Name,MiddleName,SearchName ,FthName,Addr1,  
Addr2,Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth,MAX(DateOfSetup) D  
FROM dps8_pc8 where TypeOfTrans<>'3' GROUP BY BOID,Name,MiddleName,SearchName ,FthName,Addr1,Addr2,  
Addr3,City,State,Country,PinCode,PANGIR,DateOfBirth)  dps8_pc8  on dps8_pc8.boid = dps8_pc1.boid   
  left outer join dps8_pc12 dps8_pc12 on dps8_pc12.boid = dps8_pc1.boid   
  left outer join dps8_pc16 dps8_pc16 on dps8_pc16.boid = dps8_pc1.boid   
  LEFT OUTER JOIN   
        client_dp_brkg     on dpam_id = clidb_dpam_id  and getdate() between clidb_eff_from_dt and clidb_eff_to_dt and clidb_deleted_ind =1  
        LEFT OUTER JOIN   
       brokerage_mstr on brom_id = clidb_brom_id    
--        LEFT OUTER JOIN   
--  DP_HOLDER_DTLS ON  DPAM_ID = DPHD_DPAM_ID AND DPHD_DELETED_IND =1  
  LEFT OUTER JOIN   
  DPS8_PC5 PC5 ON   DPAM_SBA_NO  = PC5.BOID AND PC5.TypeOfTrans IN ('1','2','4','')  and HolderNum = '1'
  left outer join   
        account_documents on accd_clisba_id = DPAM_ID and accd_deleted_ind = 1 and accd_accdocm_doc_id = 12  
  ,CLIENT_CTGRY_MSTR  
  ,ENTITY_TYPE_MSTR  
  ,STATUS_MSTR  
  ,SUB_CTGRY_MSTR   
  ,CLIENT_MSTR  
  --,CLIENT_BANK_ACCTS  
  --,BANK_MSTR    
  --,CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) ACCOUNT            
    
    
     WHERE isNumeric(dpam.DPAM_SBA_NO)=1   
        --and right(dpam.DPAM_SBA_NO,8)  BETWEEN @PA_FROM_ACCTNO AND @PA_TO_ACCTNO  
        and dpam.DPAM_SBA_NO  BETWEEN @PA_FROM_ACCTNO AND @PA_TO_ACCTNO  
  AND   DPAM.DPAM_CLICM_CD = CLICM_CD   
  AND   DPAM.DPAM_ENTTM_CD = ENTTM_CD  
  AND   DPAM.DPAM_STAM_CD  = STAM_CD  
  AND   DPAM.DPAM_SUBCM_CD = SUBCM_CD  
  AND   CLICM_ID           = SUBCM_CLICM_ID  
  AND   CLIM_CRN_NO        = DPAM.DPAM_CRN_NO   
  --and case when isnull(@l_bbo_code,'') ='' then '1' else isnull(dpam_bbo_code ,'') end = case when isnull(@l_bbo_code,'') ='' then '1' else @l_bbo_code end   
  and   [citrus_usr].[fn_valid_hier](dpam.dpam_sba_no,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) = 'Y'  
  --AND   CLIBA_CLISBA_ID    = DPAM.DPAM_ID  
  --AND   CLIBA_BANM_ID      = BANM_ID       
  --AND   DPAM.DPAM_ID       = ACCOUNT.DPAM_ID  
       -- and ISNULL(CITRUS_USR.FN_UCC_ACCP(dpam.DPAM_id,'BBO_CODE',''),'') like case when isnull(@l_bbo_code,'') ='' then '%' else @l_bbo_code end  --+ '%'  
   
   
  --and exists(select clientid,bbo from #bbocode where clientid = dpam.dpam_sba_no and bbo = case when @l_bbo_code <> '' then @l_bbo_code else bbo end )   
order by clidb_created_dt
--,fre_lst_upd_dt 
desc  
--  
--truncate table #bbocode  
--drop table #bbocode  
  
END -- MAIN

GO
