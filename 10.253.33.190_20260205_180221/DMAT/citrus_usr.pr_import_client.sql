-- Object: PROCEDURE citrus_usr.pr_import_client
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin transaction
----pr_import_client 'NSDL','HO','bulk','','*|~*','|*~|',''
--SELECT * FROM DP_CLIENT_SUMMARY where isnull(bank_micr,'') = ''
--select distinct entpm_cd  from entity_property_mstr
--SELECT * FROM bank_mstr 
--ROLLBACK transaction
--|*~||*~||*~|10000158|*~|SHYLA  V MRS|*~||*~|ACTIVE|*~|02|*~|01|*~|0101|*~|0|*~|A|*~|*|~*
CREATE PROCEDURE  [citrus_usr].[pr_import_client](@pa_exch          VARCHAR(20)  
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
set nocount on
  IF @pa_mode = 'BULK'
		BEGIN
		--

							declare @@l_count integer
                          /*  DECLARE @@ssql varchar(8000)
							
                            TRUNCATE TABLE tmp_client_source
                            TRUNCATE TABLE DP_CLIENT_SUMMARY
							
							SET @@ssql ='BULK INSERT tmp_client_source from ''' + @pa_db_source + ''' WITH 
							(
											FIELDTERMINATOR = ''\n'',
											ROWTERMINATOR = ''\n''

							)'

							EXEC(@@ssql)
							
							
							insert into DP_CLIENT_SUMMARY
							(Br_Cd                       
							,Ben_Acct_No                 
							,Ben_Type                    
							,Ben_Sub_Type                
							,Ben_Short_name              
							,Ben_Acct_Ctgry              
							,Ben_Occup                   
							,Ben_Fst_Hld_Name            
							,Fst_Hld_Fth_name            
							,Fst_Hld_Addr1               
							,Fst_Hld_Addr2               
							,Fst_Hld_Addr3               
							,Fst_Hld_Addr4               
							,Fst_Hld_Addr_Pin            
							,Ben_Hld_Ph_No               
							,Ben_Hld_Fax_No              
							,Ben_Sec_Hld_Name            
							,Sec_Hld_Fth_Name            
							,Ben_Thrd_Hld_Name           
							,Thrd_Hld_Fth_Name           
							,Corr_BP_Id                  
							,Addr_pref_flg               
							,Cli_Act_Dt_tm               
							,Filler_1                    
							,Fst_Hld_Fin_dtls            
							,Sec_Hld_Fin_dtls            
							,Thrd_Hld_Fin_dtls           
							,Nom_Gua_Ind                 
							,Nom_Gua_Name                
							,Date_of_Birth               
							,Nom_Gua_Addr1               
							,Nom_Gua_Addr2               
							,Nom_Gua_Addr3               
							,Nom_Gua_Addr4                
							,Nom_Gua_Addr_Pin             
							,Stan_Inst_Ind                
							,Ben_Bank_Acct_No             
							,Ben_Bank_Acc_Type            
							,Ben_Bank_Name                
							,Bank_Addr1                   
							,Bank_Addr2                   
							,Bank_Addr3                   
							,Bank_Addr4                   
							,Bank_Addr_Pin                
							,Bank_Micr                    
							,Ben_RBI_Ref_No               
							,Ben_RBI_App_date             
							,Ben_SEBI_Reg_No              
							,Ben_Tax_Ded_Status           
							,Ben_Status                   
							,Ben_Status_Change_Reason     
							,Ben_Acct_Closure_date        
							,Filler_2                     
							,Fst_Hld_CorrAdr1             
							,Fst_Hld_CorrAdr2             
							,Fst_Hld_CorrAdr3             
							,Fst_Hld_CorrAdr4             
							,Fst_Hld_Corr_Pin             
							,Fst_Hld_Corr_Ph1             
							,Fst_Hld_Corr_FX1             
							,Nom_Min_ind                  
							,Min_Nom_DOB                  
							,Min_Nom_Gua_Name             
							,Min_Nom_Gua_Addr1            
							,Min_Nom_Gua_Addr2            
							,Min_Nom_Gua_Addr3            
							,Min_Nom_Gua_Addr4            
							,Min_Nom_Gua_Pin              
							,Ben_Bank_ACC_No  
							,Fst_Hld_Email 
							,Fst_Hld_Mapin 
							,Fst_Hld_Mob 
							,SMS_flg_FH 
							,POA_flg_FH 
							,PAN_Flg_FH 
							,Fillers_3  
							,Sec_Hld_Email 
							,Sec_Hld_Mapin 
							,Sec_Hld_Mob 
							,SMS_flag_SH 
							,Filler_4 
							,PAN_Flg_SH 
							,Fillers_5 
							,Trd_Hld_Email 
							,Trd_Hld_Mapin 
							,Trd_Hld_Mob 
							,SMS_flg_TH 
							,Filler_6 
							,PAN_Flag_TH 
							,Filler_7 ) 
							select substring(client_data,10,6)     [Branch Code]
									,substring(client_data,16,8)     [Beneficiary Account Number]
									,substring(client_data,24,2)     [Beneficiary Type]
									,substring(client_data,26,2)     [Beneficiary Sub Type]
									,substring(client_data,28,16)    [Beneficiary Short name]
									,substring(client_data,44,2)     [Beneficiary Account Category]
									,substring(client_data,46,2)     [Beneficiary Occupation]
									,substring(client_data,48,135)   [Beneficiary First Holder Name]
									,substring(client_data,183,45)   [First Holder Father/Husband Name]
									,substring(client_data,228,36)   [First Holder Address 1]
									,substring(client_data,264,36)   [First Holder Address 2]
									,substring(client_data,300,36)   [First Holder Address 3]
									,substring(client_data,336,36)   [First Holder Address 4]
									,substring(client_data,372,7)    [First Holder Address Pincode]
									,substring(client_data,379,24)   [Beneficiary Holder Phone No]
									,substring(client_data,403,24)   [Beneficiary Holder Fax No]
									,substring(client_data,427,45)   [Beneficiary Second Holder Name]
									,substring(client_data,472,45)   [Second Holder Father/Husband Name] 
									,substring(client_data,517,45)   [Beneficiary Third Holder Name]
									,substring(client_data,562,45)   [Third Holder Father/Husband Name]
									,substring(client_data,607,8)    [Corresponding BP Id]
									,substring(client_data,615,1)    [Address preference flag]
									,substring(client_data,616,14)   [Client's Activation Date time]
									,substring(client_data,630,55)   [Filler]
									,substring(client_data,685,30)   [First Holder Financial detail]
									,substring(client_data,715,30)   [Second Holder Financial detail]
									,substring(client_data,745,30)   [Third Holder Financial detail] 
									,substring(client_data,775,1)    [Nominee/Guardian Indicator]
									,substring(client_data,776,45)   [Nominee/Guardian Name]
									,substring(client_data,821,8)    [Date of Birth (In case of Minor)]
									,substring(client_data,829,36)   [Nominee/Guardian Address Line 1]
									,substring(client_data,865,36)   [Nominee/Guardian Address Line 2]
									,substring(client_data,901,36)   [Nominee/Guardian Address Line 3] 
									,substring(client_data,937,36)   [Nominee/Guardian Address Line 4] 
									,substring(client_data,973,7)    [Nominee/Guardian Address Pincode]
									,substring(client_data,980,1)    [Standing Instruction Indicator]
									,substring(client_data,981,15)   [Filler]
									,substring(client_data,996,2)    [Beneficiary Bank Account Type]
									,substring(client_data,998,135)  [Beneficiary Bank Name]
									,substring(client_data,1133,36)  [Bank Address Line 1]
									,substring(client_data,1169,36)  [Bank Address Line 2]
									,substring(client_data,1205,36)  [Bank Address Line 3]
									,substring(client_data,1241,36)  [Bank Address Line 4]
									,substring(client_data,1277,7)   [Bank Address Pincode]
									,substring(client_data,1284,9)   [Bank Micr]
									,substring(client_data,1293,50)  [Beneficiary RBI Reference No.]
									,substring(client_data,1343,8)   [Beneficiary RBI Approval date]
									,substring(client_data,1351,24)  [Beneficiary SEBI Registration No.]
									,substring(client_data,1375,20)  [Beneficiary Tax Deduction Status]
									,substring(client_data,1395,2)   [Beneficiary Status]
									,substring(client_data,1397,50)  [Beneficiary Status Change Reason] 
									,substring(client_data,1447,8)   [Beneficiary Account Closure date]
									,substring(client_data,1455,20)  [Filler] 
									,substring(client_data,1475,36)  [First Holder Corr/Foreign Address 1]
									,substring(client_data,1511,36) [First Holder Corr/Foreign Address 2]
									,substring(client_data,1547,36) [First Holder Corr/Foreign Address 3]
									,substring(client_data,1583,36) [First Holder Corr/Foreign Address 4]
									,substring(client_data,1619,10) [First Holder Corr/Foreign Address Pin code]
									,substring(client_data,1629,24) [Beneficiary Holder Corr/Foreign Phone No]
									,substring(client_data,1653,24) [Beneficiary Holder Corr/Foreign Fax No]
									,substring(client_data,1677,1) [Nominee Minor Indicator]
									,substring(client_data,1678,8) [Minor Nominee Date of Birth]
									,substring(client_data,1686,45) [Minor Nominee Guardian Name ]
									,substring(client_data,1731,36) [Minor Nominee Guardian Addr 1]
									,substring(client_data,1767,36) [Minor Nominee Guardian Addr 2]
									,substring(client_data,1803,36) [Minor Nominee Guardian Addr 3]
									,substring(client_data,1839,36) [Minor Nominee Guardian Addr 4]
									,substring(client_data,1875,7) [Minor Nominee Guardian Pin code]
									,substring(client_data,1882,30) [Beneficiary Bank ACC No ]
									,substring(client_data,1912,50) [First Holder Email]
									,substring(client_data,1962,9) [First Holder Mapin]
									,substring(client_data,1971,12) [First Holder Mobile]
									,substring(client_data,1983,1) [SMS flag for first holder ]
									,substring(client_data,1984,1) [POA flag for first holder]
									,substring(client_data,1985,1) [PAN Flag for First holder]
									,substring(client_data,1986,12) [Fillers ]
									,substring(client_data,1998,50) [Second Holder Email]
									,substring(client_data,2048,9) [Second Holder Mapin]
									,substring(client_data,2057,12) [Second Holder Mobile]
									,substring(client_data,2069,1) [SMS flag for Second holder] 
									,substring(client_data,2070,1) [Filler]
									,substring(client_data,2071,1) [PAN Flag for Second holder]
									,substring(client_data,2072,12) [Fillers]
									,substring(client_data,2084,50) [Third Holder Email]
									,substring(client_data,2134,9) [Third Holder Mapin]
									,substring(client_data,2143,12) [Third Holder Mobile]
									,substring(client_data,2155,1) [SMS flag for Third holder]
									,substring(client_data,2156,1) [Filler]
									,substring(client_data,2157,1) [PAN Flag for Third holder]
									,substring(client_data,2158,12) [Filler ]

			       FROM  tmp_client_source   
			     */
			     
			     
			     
			    
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
                       , @L_acc_conc  VARCHAR(8000)
                        
			     set @c_client_summary  = CURSOR fast_forward FOR              
			     select ben_acct_no  from dp_client_summary where ben_status <> '10'
                 
                 select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                 select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           

			     
			     open @c_client_summary
			     
			     fetch next from @c_client_summary into @c_ben_acct_no 
			     
			     
			     
			     WHILE @@fetch_status = 0                                                                                                        
                 BEGIN --#cursor                                                                                                        
	             --
 
						  --SELECT  @L_CLIENT_VALUES = CASE WHEN ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') = '' THEN ISNULL(LTRIM(RTRIM(Ben_Short_name)),'') else ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') END + '|*~|' + '|*~||*~|'+ ISNULL(ltrim(rtrim(Ben_Short_name)),'') + '|*~||*~||*~||*~|ACTIVE|*~||*~|0|*~|' + ISNULL(ltrim(rtrim(Fst_Hld_Fin_dtls)),'') +'|*~|*|~*' FROM DP_CLIENT_SUMMARY WHERE  Ben_Acct_No = @c_ben_acct_no
                          
						  --EXEC pr_ins_upd_clim  '0','INS','MIG',@L_CLIENT_VALUES,0,'*|~*','|*~|','',''
                          select distinct @l_crn_no = clim_crn_no from client_mstr,  dp_acct_mstr  where dpam_crn_no = clim_crn_no and dpam_sba_no = @c_ben_acct_no
						

						--addresses
						 /*SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no and isnull(Fst_Hld_Addr1,'') <>''
						 SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Corr_Pin)),'')+'|*~|*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no and isnull(Fst_Hld_CorrAdr1,'') <>''

                          
                          
       
       
                          EXEC pr_ins_upd_addr @l_crn_no,'INS','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|',''	
						--addresses
						
*/
						--contact channels
						
						 
						 /*SELECT @L_CONC = 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(Fst_Hld_Email)),'')+'*|~*'+'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(Fst_Hld_Mob)),'')+'*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no
						  
						 

                        
                         EXEC pr_ins_upd_conc @L_CRN_NO,'INS','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''*/
						--contact channels
/*
						--dp_acct_mstr
                          --select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                          --select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
						  --select @l_dp_acct_values = isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no,'')+'|*~|'+ISNULL(ltrim(rtrim(Ben_Fst_Hld_Name)),'')+'|*~||*~|ACTIVE|*~|'+isnull(Ben_Acct_Ctgry,'') + '|*~|' + isnull(clicm_cd,'')+'|*~|'+isnull(ltrim(rtrim(Ben_Type)),'')+isnull(ltrim(rtrim(Ben_sub_Type)),'')+'|*~|0|*~|A|*~|*|~*' FROM DP_CLIENT_SUMMARY, sub_ctgry_mstr, client_ctgry_mstr WHERE  clicm_id = subcm_clicm_id and Ben_Acct_No = @c_ben_acct_no and isnull(ltrim(rtrim(Ben_Type)),'')+isnull(ltrim(rtrim(Ben_sub_Type)),'') = subcm_cd
                          
                          
						  exec pr_ins_upd_dpam @l_crn_no,'INS','MIG',@l_crn_no,@l_dp_acct_values,0,'*|~*','|*~|',''
						  
						  
						--dp_acct_mstr

                         SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no and isnull(Fst_Hld_Addr1,'') <> ''
						 SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no and isnull(Fst_Hld_CorrAdr1,'') <> ''
                         SELECT @L_ADR = @L_ADR  + case when nom_gua_ind = 'N' then 'NOMINEE_ADR1|*~|' else 'GUARD_ADR|*~|' end +ISNULL(ltrim(rtrim(Nom_Gua_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Corr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no and isnull(Nom_Gua_Addr1,'') <> ''
                         SELECT @L_ADR = @L_ADR  + 'NOM_GUARDIAN_ADDR|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Pin)),'')+'|*~|*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE ben_acct_no = @c_ben_acct_no and isnull(Min_Nom_Gua_Addr1,'') <> ''

                          
       
                          EXEC 	pr_dp_ins_upd_addr '0','INS','MIG',0,@c_ben_acct_no,'dp',@L_ADR,0,'*|~*','|*~|',''	
						




						--dp_holder_dtls/addresses/conctact_channels
						declare @pa_fh_dtls varchar(8000)
                               ,@pa_sh_dtls varchar(8000)
                               ,@pa_th_dtls varchar(8000)
                               ,@pa_nomgau_dtls varchar(8000)
                               ,@pa_nom_dtls varchar(8000)
                               ,@pa_gau_dtls varchar(8000)

						  select @pa_fh_dtls = ''+'|*~|'+''+'|*~|'+''+'|*~|'+isnull(ltrim(rtrim(Fst_Hld_Fth_name)),'')+'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no
						  select @pa_sh_dtls = isnull(ltrim(rtrim(Ben_Sec_Hld_Name)),'')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull(ltrim(rtrim(Sec_Hld_Fth_Name)),'')+'|*~|'++'|*~|'+isnull(ltrim(rtrim(Sec_Hld_Fin_dtls)),'')+'|*~|'++'|*~|*|~*'  FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no
						  select @pa_th_dtls = isnull(ltrim(rtrim(Ben_Thrd_Hld_Name)),'')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull(ltrim(rtrim(Thrd_Hld_Fth_Name)),'')+'|*~|'++'|*~|'+isnull(ltrim(rtrim(Thrd_Hld_Fin_dtls)),'')+'|*~|'++'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no
						  select @pa_nomgau_dtls = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no
						  select @pa_nom_dtls = case when nom_gua_ind = 'N' then isnull(ltrim(rtrim(nom_gua_name)),'')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|*|~*'  else '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  end FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no
						  select @pa_gau_dtls = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no

                          exec pr_ins_upd_dphd '0',@l_crn_no,@c_ben_acct_no,'INS','HO',@pa_fh_dtls,@pa_sh_dtls,@pa_th_dtls,@pa_nomgau_dtls,@pa_nom_dtls,@pa_gau_dtls,0,'*|~*','|*~|',''             
         
						--dp_holder_dtls/addresses/conctact_channels

                        -- entity_relationship  
                           select @l_br_sh_name  = entm_short_name from entity_mstr ,DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and entm_short_name = br_cd
                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           select @l_entr_value = convert(varchar,ISNULL(@l_compm_id,0))+'|*~|'+convert(varchar,ISNULL(@l_excsm_id,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@c_ben_acct_no,'')+'|*~|'+'01/01/1900'+'|*~|'++'HO|*~|JMF HO|*~|RE|*~||*~|AR|*~||*~|BR|*~|'+ isnull(@l_br_sh_name,'') +'|*~|SB|*~||*~|RM_BR|*~||*~|FM|*~||*~|SBFR|*~||*~|INT|*~||*~|A*|~*'
                           
                           exec pr_ins_upd_dpentr '0','','HO',@l_crn_no,@l_entr_value ,0,'*|~* ','|*~|',''
                        -- entity_relationship 

						--bank_mstr/addresses/conctact_channels
                          SELECT @L_BANK_NAME = ltrim(rtrim(Ben_Bank_Name)) , @L_BANM_BRANCH = ltrim(rtrim(Bank_Addr1)) + '('+ ltrim(rtrim(Bank_Addr_Pin)) +')' , @L_MICR_NO = Bank_Micr FROM DP_CLIENT_SUMMARY   where Ben_Acct_No = @c_ben_acct_no
 
                          SELECT @L_ADDR_VALUE = 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr4)),'')+'|*~|'+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr_PIN)),'')+'|*~|'+'*|~*' FROM DP_CLIENT_SUMMARY WHERE   Ben_Acct_No = @c_ben_acct_no 

                         set @L_BANM_ID = 0
                           IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH )
                           BEGIN
                              SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH 
                           END
                           ELSE 
                           BEGIN
                             IF @L_MICR_NO = '' 
                             BEGIN
                             EXEC pr_mak_banm  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,0,'','','',0,1,@L_ADDR_VALUE,0,'','*|~*','|*~|',''
                             END  
                             ELSE
                             BEGIN 
                             EXEC pr_mak_banm  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,'','','',0,1,@L_ADDR_VALUE,0,'','*|~*','|*~|',''
                             END
                             SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH 
                           END
                            


  


						  --pr_mak_banm 
						--bank_mstr/addresses/conctact_channels

						--client_bank_accts
                            
                           select @l_crn_no = clim_crn_no from client_mstr,  DP_CLIENT_SUMMARY  where clim_short_name =  isnull(Ben_Short_name,'') and Ben_Acct_No = @c_ben_acct_no
						   select @l_dpba_values = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no)) +'|*~|'	+ LTRIM(RTRIM(Ben_Fst_Hld_Name)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+case when Ben_Bank_Acc_Type = '10' then 'SAVINGS' when Ben_Bank_Acc_Type = '11' then 'CURRENT' else 'OTHERS' end +'|*~|' + LTRIM(RTRIM(Ben_Bank_ACC_No)) + '|*~|1|*~|0|*~|A*|~*'  FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no

						   exec pr_ins_upd_dpba '0','INS','MIG',@l_crn_no,@l_dpba_values,0,'*|~*','|*~|',''
						--client_bank_accts */

						--account_properties
                          /*SET @L_ACCP_VALUE = ''
						  SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(SMS_flg_FH)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ACCPM_PROP_CD = 'SMS_FLAG' AND ISNULL(SMS_flg_FH,'') <> ''
                          
                          SET  @L_accpd_VALUE = ''

                          SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DP_CLIENT_SUMMARY WHERE DPAM_SBA_NO = Ben_Acct_No  AND Ben_Acct_No  = @c_ben_acct_no

						  EXEC pr_ins_upd_accp '0' ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no,'DP',@L_ACCP_value,'' ,0,'*|~*','|*~|',''
                            */       
						--account_properties

						--entity_properties
						  
					/*	 
				          SET @L_ENTP_VALUE       = ''
--						    SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(ben_rbi_ref_no)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO'
                            SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(ben_tax_ded_statuS)),'') + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'TAX_DEDUCTION' AND ISNULL(ben_tax_ded_statuS,'') <>''
                            SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'') + CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +  case when LTRIM(RTRIM(Ben_Occup)) = '01' then  'Service'
																								when Ben_Occup = '02' then  'Student'
																								when Ben_Occup  = '03'  then  'Housewife'
																								when Ben_Occup  = '04' then  'Landlord'                                            
																								when Ben_Occup  =  '05'  then 'Business'
																								when Ben_Occup  = '06'  then  'Professional'
																								when Ben_Occup  = '07'  then  'Agriculture'
																								when Ben_Occup  = '08' then  'Others' else '' end + '|*~|*|~*' 	           FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'OCCUPATION' AND ISNULL(Ben_Occup,'') <> ''
                            SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'') + CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(Fst_Hld_Fin_dtls)),'') + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'PAN_GIR_NO' AND ISNULL(Fst_Hld_Fin_dtls,'') <> ''

                            SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'PAN_GIR_NO' AND ENTDM_CD = 'PAN_NAME' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID AND ISNULL(Ben_Fst_Hld_Name,'') <> ''
                          

						   EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''  
						  --
						  
						--entity_properties


						--account_documents
						
						  --pr_ins_upd_accd
						--account_documents


						--client_docuements
						
						  --pr_ins_upd_clid
						--client_docuements
*/	
set @L_acc_conc  = ''
          				 SELECT @L_acc_conc = 'SH_POA_MAIL|*~|'+ISNULL(ltrim(rtrim(Sec_Hld_Email)),'')+'*|~*' FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and Sec_Hld_Email <> ''
						 SELECT @L_acc_conc = @L_acc_conc  + 'SH_POA_MOB|*~|'+ISNULL(ltrim(rtrim(Sec_Hld_Mob)),'')+'*|~*'  FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and Sec_Hld_Mob <> ''
                         SELECT @L_acc_conc = @L_acc_conc  + 'TH_POA_MAIL|*~|'+ISNULL(ltrim(rtrim(Trd_Hld_Email)),'')+'*|~*'   FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and Trd_Hld_Email <> ''
                         SELECT @L_acc_conc = @L_acc_conc  + 'TH_POA_MOB|*~|'+ISNULL(ltrim(rtrim(Trd_Hld_Mob)),'')+'*|~*'   FROM   DP_CLIENT_SUMMARY WHERE Ben_Acct_No = @c_ben_acct_no and Trd_Hld_Mob <> ''
                         
print @L_acc_conc
                          
       if @L_acc_conc <> ''
                          EXEC 	pr_dp_ins_upd_CONC '0','INS','MIG',0,@c_ben_acct_no,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''	
						


				
				  fetch next from @c_client_summary into @c_ben_acct_no 
				--
				END
			     
			    CLOSE        @c_client_summary
				DEALLOCATE   @c_client_summary
	


		--
 	END
			
 
--  
END

GO
