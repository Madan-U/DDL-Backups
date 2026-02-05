-- Object: PROCEDURE citrus_usr.pr_daily_status_update
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
--rollback
--begin transaction
--[pr_daily_status_update] 'NSDL','HO','BULK','d:\BulkInsDbfolder\CLIENT MASTER IMPORT\10000000000045_CLNTDWLD_20101111121948_F_DONE.txt','*|~*','|*~|',''
--select count(*) from entity_relationship--61033
--select count(*) from entity_relationship
--SELECT  BANM_ID FROM BANK_MSTR WHERE BANM_NAME = 'HDFC BANK LTD' AND BANM_BRANCH = '65,SONAWALA BLDG,(400021)' 
--commit
--SET ROWCOUNT 0
--select * from dp_acct_mstr order by 1 desc
--select * from tmp_client_source where dpam_sba_name  like '%sajag%'
--select * from dp_client_summary where ben_acct_no not in (select dpam_sba_no from dp_acct_mstr)
--select count(*) from client_mstr--60830--60840
--select count(*) from dp_acct_mstr--60825--60835
*/

CREATE PROCEDURE  [citrus_usr].[pr_daily_status_update](@pa_exch          VARCHAR(20)  
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
 -----  -------------     ------------  ------------------------------------------
 1.0    TUSHAR            08-OCT-2007   VERSION.  
----------------------------------------------------------------------------------*/  
BEGIN  
--
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
                       , @temp_crn_no NUMERIC
                       , @l_tot_client numeric
                       , @l_country    varchar(50)
                       , @l_state      varchar(50)


  IF @pa_mode = 'BULK'
		BEGIN
		--

							declare @@l_count integer
							TRUNCATE TABLE  tmp_client_source
                            TRUNCATE TABLE  DP_CLIENT_SUMMARY
							DECLARE @@ssql varchar(8000)
							SET @@ssql ='BULK INSERT tmp_client_source from ''' + @pa_db_source + ''' WITH 
							(
											FIELDTERMINATOR = ''\n'',
											ROWTERMINATOR = ''\n''

							)'

							EXEC(@@ssql)
							
							delete from tmp_client_source where left(client_data,2) = '01'
						
select * from tmp_client_source
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
							select   substring(client_data,10,6)     [Branch Code]
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

						    


                            Update dpam 
							set    dpam_stam_cd = case when ben_status = '01' then 'ACTIVE' when ben_status = '02_BILLSTOP' then '02_BILLSTOP'  else ben_status end
                                ,  DPAM_SUBCM_CD = SUBCM_CD
                                ,  DPAM_CLICM_CD = CLICM_CD
                                ,  dpam_lst_upd_dt = GETDATE()
                            from   dp_acct_mstr dpam
							     , dp_client_summary
                                 , CLIENT_CTGRY_MSTR
                                 , SUB_CTGRY_MSTR 
							where  dpam_sba_no =  CONVERT(VARCHAR,Ben_Acct_No)
                            AND    CLICM_ID    = SUBCM_CLICM_ID
                            AND    SUBCM_CD    = LTRIM(RTRIM(ISNULL(Ben_Type,'')))+LTRIM(RTRIM(ISNULL(Ben_SUB_Type,''))) 
                             


                            update dphd
                            set    DPHD_FH_FTHNAME = Fst_Hld_Fth_name
						          ,DPHD_SH_FNAME   = isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Ben_Sec_Hld_Name)),'1') ,'')
								  ,DPHD_SH_MNAME   = isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Ben_Sec_Hld_Name)),'2') ,'')
								  ,DPHD_SH_LNAME   = isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Ben_Sec_Hld_Name)),'3') ,'')
                                  ,DPHD_SH_FTHNAME = isnull(ltrim(rtrim(Sec_Hld_Fth_Name)),'')
                                  ,DPHD_SH_PAN_NO  = isnull(ltrim(rtrim(Sec_Hld_Fin_dtls)),'')
                                  ,DPHD_TH_FNAME   = isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Ben_Thrd_Hld_Name)),'1') ,'')
								  ,DPHD_TH_MNAME   = isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Ben_Thrd_Hld_Name)),'2') ,'')
								  ,DPHD_TH_LNAME   = isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Ben_Thrd_Hld_Name)),'3') ,'')
                                  ,DPHD_TH_FTHNAME = isnull(ltrim(rtrim(Thrd_Hld_Fth_Name)),'')
                                  ,DPHD_TH_PAN_NO  = isnull(ltrim(rtrim(Thrd_Hld_Fin_dtls)),'')
                                  ,DPHD_NOM_FNAME  = CASE WHEN Nom_Gua_Ind = 'N' THEN isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Nom_Gua_Name)),'1') ,'') ELSE '' END 
                                  ,DPHD_NOM_MNAME  = CASE WHEN Nom_Gua_Ind = 'N' THEN isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Nom_Gua_Name)),'2') ,'') ELSE '' END 
                                  ,DPHD_NOM_LNAME  = CASE WHEN Nom_Gua_Ind = 'N' THEN isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Nom_Gua_Name)),'3') ,'') ELSE '' END 
                                  ,DPHD_GAU_FNAME  = CASE WHEN Nom_Gua_Ind = 'G' THEN isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Nom_Gua_Name)),'1') ,'') ELSE '' END 
								  ,DPHD_GAU_MNAME  = CASE WHEN Nom_Gua_Ind = 'G' THEN isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Nom_Gua_Name)),'2') ,'') ELSE '' END 
								  ,DPHD_GAU_LNAME  = CASE WHEN Nom_Gua_Ind = 'G' THEN isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Nom_Gua_Name)),'3') ,'') ELSE '' END 
                                  ,dphd_nomgau_fname = CASE WHEN Nom_Min_ind = 'N' THEN '' ELSE isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Min_Nom_Gua_Name)),'1') ,'') END 
								  ,dphd_nomgau_mname = CASE WHEN Nom_Min_ind = 'N' THEN '' ELSE isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Min_Nom_Gua_Name)),'2') ,'') END 
								  ,dphd_nomgau_lname = CASE WHEN Nom_Min_ind = 'N' THEN '' ELSE isnull(CITRUS_USR.inside_trim(LTRIM(RTRIM(Min_Nom_Gua_Name)),'3') ,'') END 
                                  ,dphd_lst_upd_dt   = getdate()
						    from dp_holder_dtls dphd
                            ,    dp_acct_mstr 
                            ,    DP_CLIENT_SUMMARY
                            where dphd_dpam_sba_no  = dpam_sba_no
                            and   dphd_dpam_id = dpam_id 
                            and   CONVERT(VARCHAR,Ben_Acct_No) = dpam_sba_no




                            

declare @c_client_summary1  cursor

,@c_ben_acct_no1  varchar(20)

                 set @c_client_summary1  = CURSOR fast_forward FOR              
			     select CONVERT(VARCHAR,Ben_Acct_No)   from DP_CLIENT_SUMMARY 
                 where CONVERT(VARCHAR,Ben_Acct_No) in (select dpam_sba_no from dp_Acct_mstr) and ben_status <> '10' 
			     
			     open @c_client_summary1
			     
			     fetch next from @c_client_summary1 into @c_ben_acct_no1 
			     
			     
			     
			     WHILE @@fetch_status = 0                                                                                                        
                 BEGIN --#cursor                                                                                                        
	             --
                    select @l_crn_no = clim_crn_no from client_mstr,  DP_ACCT_MSTR where DPAM_CRN_NO = CLIM_CRN_NO AND DPAM_SBA_NO =  @c_ben_acct_no1



                        IF EXISTS(SELECT ENTP_VALUE FROM    ENTITY_PROPERTIES ENTP 
                      , DP_ACCT_MSTR 
                      , DP_CLIENT_SUMMARY 
                        WHERE DPAM_CRN_NO = ENTP_ENT_ID 
                        AND DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No) 
                        AND DPAM_SBA_NO =  @c_ben_acct_no1 
                        AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_DELETED_IND = 1)
                        BEGIN
                        	
							UPDATE ENTP SET ENTP_VALUE = Fst_Hld_Fin_dtls FROM 
							ENTITY_PROPERTIES ENTP 
							, DP_ACCT_MSTR 
							, DP_CLIENT_SUMMARY 
							WHERE DPAM_CRN_NO = ENTP_ENT_ID 
							AND DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No) 
							AND DPAM_SBA_NO =  @c_ben_acct_no1 
							AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_DELETED_IND = 1
						END 
						ELSE 
						BEGIN

							SET @L_ENTP_VALUE = '' 
							SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Fst_Hld_Fin_dtls)),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR 
							WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ENTPM_CD = 'PAN_GIR_NO'
							PRINT @L_ENTP_VALUE
							PRINT @L_ENTPD_VALUE
							EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''  
							SET @L_ENTP_VALUE = ''
						END		
                        
                        UPDATE accp SET accp_VALUE = RIGHT(CONVERT(varchar(8),Cli_Act_Dt_tm),2) +'/'+ substring(CONVERT(varchar(8),Cli_Act_Dt_tm),5,2) + '/' + LEFT(CONVERT(varchar(8),Cli_Act_Dt_tm),4) FROM 
                        account_properties accp 
                      , DP_ACCT_MSTR 
                      , DP_CLIENT_SUMMARY 
                        WHERE DPAM_id = accp_clisba_id
                        AND DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No) 
                        AND DPAM_SBA_NO =  @c_ben_acct_no1 
                        AND accp_accpm_prop_cd = 'BILL_START_DT' AND accp_DELETED_IND = 1
                        
                        UPDATE accp SET accp_VALUE = RIGHT(CONVERT(varchar(8),Ben_Acct_Closure_date),2) +'/'+ substring(CONVERT(varchar(8),Ben_Acct_Closure_date),5,2) + '/' + LEFT(CONVERT(varchar(8),Ben_Acct_Closure_date),4) FROM 
                        account_properties accp 
                      , DP_ACCT_MSTR 
                      , DP_CLIENT_SUMMARY 
                        WHERE DPAM_id = accp_clisba_id
                        AND DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No) 
                        AND DPAM_SBA_NO =  @c_ben_acct_no1 
                        AND accp_accpm_prop_cd = 'ACC_CLOSE_DT' AND accp_DELETED_IND = 1
                        AND isnull(Ben_Acct_Closure_date,'') <> ''


                    
                    select @l_state = adr_state, @l_country = adr_country from addresses , entity_Adr_conc , dp_acct_mstr where entac_adr_conc_id = adr_id and dpam_crn_no = entac_ent_id and dpam_sba_no  = @c_ben_acct_no1 and ENTAC_CONCM_CD = 'PER_ADR1' and entac_deleted_ind = 1 and adr_deleted_ind = 1

		                  SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'') <> ''

                    set @l_state = '' 
                    set @l_country = ''
					 
                    if EXISTS(SELECT CONVERT(VARCHAR,Ben_Acct_No)  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'') = '')
                    BEGIN 
                      PRINT 'exists'
                       
                      select @l_state = adr_state, @l_country = adr_country from addresses , entity_Adr_conc , dp_acct_mstr where entac_adr_conc_id = adr_id and dpam_crn_no = entac_ent_id and dpam_sba_no  = @c_ben_acct_no1 and ENTAC_CONCM_CD = 'COR_ADR1' and entac_deleted_ind = 1 and adr_deleted_ind = 1

 
                      SELECT @L_ADR = @L_ADR + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY 
                      WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'') <> ''                      

                      set @l_state = '' 
                      set @l_country = ''

                      PRINT @L_ADR
                    END
                    ELSE
                    BEGIN
                      select @l_state = adr_state, @l_country = adr_country from addresses , entity_Adr_conc , dp_acct_mstr where entac_adr_conc_id = adr_id and dpam_crn_no = entac_ent_id and dpam_sba_no  = @c_ben_acct_no1 and ENTAC_CONCM_CD = 'COR_ADR1' and entac_deleted_ind = 1 and adr_deleted_ind = 1

                      SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Corr_Pin)),'')+'|*~|*|~*'
                      FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'') <> ''

                      set @l_state = '' 
                      set @l_country = ''

                    END  
                     
                     SELECT @temp_crn_no = dpam_crn_no FROM dp_acct_mstr , DP_CLIENT_SUMMARY  WHERE  dpam_sba_no = CONVERT(VARCHAR,Ben_Acct_No) AND CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND dpam_deleted_ind = 1 
                     SELECT @l_tot_client = COUNT(*) FROM dp_acct_mstr WHERE dpam_crn_no = @temp_crn_no AND dpam_deleted_ind = 1
                     
                     PRINT @l_tot_client
                     
                     IF @l_tot_client = 1
                     BEGIN
                     PRINT @l_crn_no
                     PRINT @L_CRN_NO
                     PRINT @L_ADR
                     
                     EXEC pr_ins_upd_addr @l_crn_no,'EDT','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|',''	
                     END 
					--addresses
						
                        
						--contact channels
						
						 SELECT @L_CONC = 'RES_PH1|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_Ph_No)),''),1,',')+'*|~*'+'RES_PH2|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_Ph_No)),''),2,',')+'*|~*'+'FAX1|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_fax_No)),''),1,',')+'*|~*'+'FAX2|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_fax_No)),''),2,',')+'*|~*'
       FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1
       
       SELECT @L_CONC = isnull(@L_CONC,'') + 'OFF_PH1|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Fst_Hld_Corr_Ph1)),''),1,',')+'*|~*'+'OFF_PH2|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Fst_Hld_Corr_Ph1)),''),2,',')+'*|~*'
       FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1


                         SELECT @L_CONC = isnull(@L_CONC,'') + 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(Fst_Hld_Email)),'')+'*|~*'+'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(Fst_Hld_Mob)),'')+'*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1

                     IF @l_tot_client = 1
                     begin
                         EXEC pr_ins_upd_conc @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''
                     END
                     SET @temp_crn_no = 0
                     SET @l_tot_client = 0
                     
				                     set @L_CONC  = ''
                         SET @L_ADR  = ''


                         select @l_state = adr_state, @l_country = adr_country from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr where accac_concm_id = concm_id and  accac_adr_conc_id = adr_id and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 and accac_concm_id = concm_id and concm_cd = 'AC_PER_ADR1' and accac_deleted_ind = 1 and adr_deleted_ind =1 

                         SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and isnull(Fst_Hld_Addr1,'') <> ''


if EXISTS(SELECT CONVERT(VARCHAR,Ben_Acct_No)  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'') <> '')
BEGIN 
                        
                         set @l_state = '' 
                         set @l_country = ''

                         select @l_state = adr_state, @l_country = adr_country from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr where accac_concm_id = concm_id and  accac_adr_conc_id = adr_id and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 and accac_concm_id = concm_id and concm_cd = 'AC_COR_ADR1'  and accac_deleted_ind = 1 and adr_deleted_ind =1 
 
						                   SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and isnull(Fst_Hld_CorrAdr1,'') <> ''
end 
else 
begin
                         set @l_state = '' 
                         set @l_country = ''

                         select @l_state = adr_state, @l_country = adr_country from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr where accac_concm_id = concm_id and  accac_adr_conc_id = adr_id and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 and accac_concm_id = concm_id and concm_cd = 'AC_COR_ADR1'  and accac_deleted_ind = 1 and adr_deleted_ind =1 
 
						                    SELECT @L_ADR = @L_ADR + 'AC_COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and isnull(Fst_Hld_Addr1,'') <> ''

end 
                         set @l_state = '' 
                         set @l_country = ''

                         select @l_state = adr_state, @l_country = adr_country from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr where accac_concm_id = concm_id and  accac_adr_conc_id = adr_id and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 and accac_concm_id = concm_id and concm_cd in ('GUARD_ADR' ,'NOMINEE_ADR1')  and accac_deleted_ind = 1 and adr_deleted_ind =1 



                         SELECT @L_ADR = @L_ADR  + case when nom_gua_ind = 'N' then 'NOMINEE_ADR1|*~|' else 'GUARD_ADR|*~|' end +ISNULL(ltrim(rtrim(Nom_Gua_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and isnull(Nom_Gua_Addr1,'') <> ''

                         set @l_state = '' 
                         set @l_country = ''

                         select @l_state = adr_state, @l_country = adr_country from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr where accac_concm_id = concm_id and accac_adr_conc_id = adr_id and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 and accac_concm_id = concm_id and concm_cd = 'NOM_GUARDIAN_ADDR' and accac_deleted_ind = 1 and adr_deleted_ind =1 

                         SELECT @L_ADR = @L_ADR  + 'NOM_GUARDIAN_ADDR|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr4)),'')+'|*~|'+ISNULL(@l_state,'')+'|*~|'+ISNULL(@l_country,'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Pin)),'')+'|*~|*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 and isnull(Min_Nom_Gua_Addr1,'') <> ''
                         

                         select @L_ADR = @L_ADR  + 'SH_ADR1|*~|'++ISNULL(ltrim(rtrim(ADR_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_2)),'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_3)),'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_CITY)),'')+'|*~|'+ISNULL(ADR_STATE,'')+'|*~|'+ISNULL(ADR_COUNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_ZIP)),'')+'|*~|*|~*' 
                         from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr 
                         where accac_concm_id = concm_id and  accac_adr_conc_id = adr_id 
                         and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 
                         and accac_concm_id = concm_id and concm_cd = 'SH_ADR1'  
                         and accac_deleted_ind = 1 and adr_deleted_ind =1 
 
                         select @L_ADR = @L_ADR  + 'TH_ADR1|*~|'++ISNULL(ltrim(rtrim(ADR_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_2)),'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_3)),'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_CITY)),'')+'|*~|'+ISNULL(ADR_STATE,'')+'|*~|'+ISNULL(ADR_COUNTRY,'')+'|*~|'+ISNULL(ltrim(rtrim(ADR_ZIP)),'')+'|*~|*|~*' 
                         from addresses , account_Adr_conc , dp_acct_mstr , conc_code_mstr 
                         where accac_concm_id = concm_id and  accac_adr_conc_id = adr_id 
                         and dpam_id = accac_clisba_id and dpam_sba_no  = @c_ben_acct_no1 
                         and accac_concm_id = concm_id and concm_cd = 'TH_ADR1'  
                         and accac_deleted_ind = 1 and adr_deleted_ind =1 



                         set @l_state = '' 
                         set @l_country = ''

                         EXEC 	pr_dp_ins_upd_addr @l_crn_no,'EDT','MIG',0,@c_ben_acct_no1,'dp',@L_ADR,0,'*|~*','|*~|',''	
						                   set @L_ADR   = ''





                         
                         SELECT @L_acc_conc = 'SH_EMAIL1|*~|'+ISNULL(ltrim(rtrim(Sec_Hld_Email)),'')+'*|~*'+'SH_MOBILE|*~|'+ISNULL(ltrim(rtrim(Sec_Hld_Mob)),'')+'*|~*'   FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1
						                   SELECT @L_acc_conc = @L_acc_conc  + 'TH_EMAIL1|*~|'+ISNULL(ltrim(rtrim(Trd_Hld_Email)),'')+'*|~*'+'TH_MOBILE|*~|'+ISNULL(ltrim(rtrim(Trd_Hld_Mob)),'')+'*|~*'   FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1
                         

                          
       
                          EXEC 	pr_dp_ins_upd_CONC @l_crn_no,'EDT','MIG',0,@c_ben_acct_no1,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''	
                          set @L_acc_conc = ''



                           SELECT @L_BANK_NAME = ltrim(rtrim(Ben_Bank_Name)) 
                               , @L_BANM_BRANCH = ltrim(rtrim(Bank_Addr1)) + '('+ ltrim(rtrim(Bank_Addr_Pin)) +')' 
                               , @L_MICR_NO = Bank_Micr FROM DP_CLIENT_SUMMARY  WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1
 
                           
                          SELECT @L_ADDR_VALUE = 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr4)),'')+'|*~|'+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr_PIN)),'')+'|*~|'+'*|~*' FROM DP_CLIENT_SUMMARY WHERE   CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 
 
                          IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE banm_micr =  @L_MICR_NO and banm_deleted_ind = 1)
                           BEGIN
                              SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE 
                              --(BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or 
                              banm_micr =  @L_MICR_NO
                           END
                           ELSE 
                           BEGIN
                             
                             EXEC pr_mak_banm  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,'','','',0,1,@L_ADDR_VALUE,0,'','*|~*','|*~|',''
                             SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO
                           END
                       

                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                            
                           select @l_crn_no = dpam_crn_no from dp_acct_mstr,  DP_CLIENT_SUMMARY  where dpam_sba_no =  ben_acct_no and CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1
						   select @l_dpba_values = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no1)) +'|*~|'	+ LTRIM(RTRIM(Ben_Fst_Hld_Name)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+case when Ben_Bank_Acc_Type = '10' then 'SAVINGS' when Ben_Bank_Acc_Type = '11' then 'CURRENT' else 'OTHERS' end +'|*~|' + LTRIM(RTRIM(Ben_Bank_ACC_No)) + '|*~|1|*~|0|*~|A*|~*'  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1
 
                           if not exists (select dpam_id from dp_acct_mstr, DP_CLIENT_SUMMARY , client_bank_accts where dpam_id = cliba_clisba_id and dpam_sba_no = ben_acct_no and ben_acct_no = @c_ben_acct_no1)
						   exec pr_ins_upd_dpba 0,'INS','MIG',@l_crn_no,@l_dpba_values,0,'*|~*','|*~|',''
						

                            SET @L_ENTP_VALUE       = ''
						    SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(Fst_Hld_Fin_dtls)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ENTPM_CD = 'pan_gir_no'
                            SELECT DISTINCT @L_ENTP_VALUE = @L_ENTP_VALUE + CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM([citrus_usr].[fn_reverse_mapping]('CDSL','TAX_DEDUCTION',ben_tax_ded_statuS))),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ENTPM_CD = 'TAX_DEDUCTION'
                            SELECT DISTINCT @L_ENTP_VALUE = @L_ENTP_VALUE + CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +  case when LTRIM(RTRIM(Ben_Occup)) = '01' then  upper('Service')
																								when Ben_Occup  = '02' then  upper('Student')
																								when Ben_Occup  = '03'  then  upper('Housewife')
																								when Ben_Occup  = '04' then  upper('Landlord'  )                                          
																								when Ben_Occup  = '05'  then upper('Business')
																								when Ben_Occup  = '06'  then  upper('Professional')
																								when Ben_Occup  = '07'  then  upper('Agriculture')
																								when Ben_Occup  = '08' then  upper('Others') else '' end + '|*~|*|~*' 	           FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ENTPM_CD = 'OCCUPATION'
 
                           SET @L_ENTPD_VALUE = ''
                           --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID
             
						   EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''  
						   SET @L_ENTP_VALUE       =  ''
         SET @L_ENTPD_VALUE     =  ''
         
         
            SET @L_ACCP_VALUE = ''
						      SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Ben_SEBI_Reg_No)),'')) + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD = 'SEBI_REG_NO'
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'CMBP_ID'
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(ben_rbi_ref_no)),'')) + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR  WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD   = 'RBI_REF_NO'
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Fst_Hld_Mapin)),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'MAPIN_ID'
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN ISNULL(LTRIM(RTRIM(Stan_Inst_Ind)),'') = 'Y' THEN '1' END + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'STAN_INS_IND' AND ISNULL(LTRIM(RTRIM(Stan_Inst_Ind)),'') = 'Y' 
            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'') + CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN upper(ISNULL(LTRIM(RTRIM(SMS_flg_FH)),'')) = 'Y' THEN '1' ELSE '0' END  + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD = 'SMS_FLAG' AND ISNULL(SMS_flg_FH,'N') <> 'N'
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN ISNULL(LTRIM(RTRIM(PAN_Flg_FH)),'') = 'Y' THEN '1' END + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'FH_PAN_YN' AND ISNULL(LTRIM(RTRIM(PAN_Flg_FH)),'') = 'Y' 
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN ISNULL(LTRIM(RTRIM(PAN_Flg_SH)),'') = 'Y' THEN '1' END + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'SH_PAN_YN' AND ISNULL(LTRIM(RTRIM(PAN_Flg_SH)),'') = 'Y' 
            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + RIGHT(CONVERT(varchar(8),Cli_Act_Dt_tm),2) +'/'+ substring(CONVERT(varchar(8),Cli_Act_Dt_tm),5,2) + '/' + LEFT(CONVERT(varchar(8),Cli_Act_Dt_tm),4)  + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'BILL_START_DT' 
            SELECT DISTINCT  @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN ISNULL(LTRIM(RTRIM(PAN_Flag_TH)),'') = 'Y' THEN '1' END + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'TH_PAN_YN' AND ISNULL(LTRIM(RTRIM(PAN_Flag_TH)),'') = 'Y' 
            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + RIGHT(CONVERT(varchar(8),Ben_Acct_Closure_date),2) +'/'+ substring(CONVERT(varchar(8),Ben_Acct_Closure_date),5,2) + '/' + LEFT(CONVERT(varchar(8),Ben_Acct_Closure_date),4)  + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'ACC_CLOSE_DT' 
            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' +  case when left(upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')),3) ='IN6' then 'BSE' when left(upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')),3) ='IN5'  then  'NSE' end + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'CMBPEXCH' and left(upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')),3) in ('IN5','IN6')
                          
												SET @L_accpd_VALUE = ''

												SELECT DISTINCT @L_accpd_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + RIGHT(ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),''),4)  + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD = 'RBI_REF_NO' AND ACCDM_CD = 'RBI_APP_DT' AND ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID AND Ben_RBI_App_date <> ''

            SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DP_CLIENT_SUMMARY WHERE DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No)  AND CONVERT(VARCHAR,Ben_Acct_No)  = @c_ben_acct_no1

						      EXEC pr_ins_upd_accp '0' ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,@L_accpd_VALUE ,0,'*|~*','|*~|',''
                       SET @L_accpd_VALUE = ''            
                       SET @L_ACCP_VALUE = ''


                   
                   fetch next from @c_client_summary1 into @c_ben_acct_no1 
                 --
                 end
    
                 close @c_client_summary1  
                 deallocate  @c_client_summary1  

                 

                            update cliba
                            set    CLIBA_AC_TYPE = case when Ben_Bank_Acc_Type = '10' then 'SAVINGS' when Ben_Bank_Acc_Type ='11' then 'CURRENT' else 'OTHERS' end
                            ,      CLIBA_AC_NO   = Ben_Bank_Acc_No
                            ,      cliba_banm_id = BANM_ID , cliba_lst_upd_dt = getdate()
						    from client_bank_accts cliba
                            ,    dp_acct_mstr 
                            ,    DP_CLIENT_SUMMARY
                            ,    BANK_MSTR 
                            where cliba_clisba_id = dpam_id 
                            and   CONVERT(VARCHAR,Ben_Acct_No) = dpam_sba_no
                            AND   BANM_NAME = ltrim(rtrim(Ben_Bank_Name)) 
                            AND   BANM_BRANCH =  ltrim(rtrim(Bank_Addr1)) + '('+ ltrim(rtrim(Bank_Addr_Pin)) +')' 


                            update cliba
                            set    CLIBA_AC_NO   = Ben_Bank_Acc_No , cliba_lst_upd_dt = getdate()
                            from client_bank_accts cliba
                            ,    dp_acct_mstr 
                            ,    DP_CLIENT_SUMMARY
                            where cliba_clisba_id = dpam_id 
                            and   CONVERT(VARCHAR,Ben_Acct_No) = dpam_sba_no
                            


                      
set @l_crn_no  = 0                        
set @L_ADR  = ''
set @L_CONC  = ''
set @L_acc_conc  = ''
SET @L_BANK_NAME  = ''
SET @L_BANM_BRANCH  = ''
SET @L_BANM_ID  =0


                  
			     set @c_client_summary  = CURSOR fast_forward FOR              
			     select CONVERT(VARCHAR,Ben_Acct_No)   from DP_CLIENT_SUMMARY 
                 where CONVERT(VARCHAR,Ben_Acct_No) not in (select dpam_sba_no from dp_Acct_mstr) and ben_status <> '10'
			     
			     open @c_client_summary
			     
			     fetch next from @c_client_summary into @c_ben_acct_no 
			     
			     
			     
			     WHILE @@fetch_status = 0                                                                                                        
                 BEGIN --#cursor                                                                                                        
	             --
                          set @l_crn_no = 0
						  SELECT  @L_CLIENT_VALUES = CASE WHEN ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') = '' THEN ISNULL(LTRIM(RTRIM(Ben_Short_name)),'') else ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') END + '|*~|' + '|*~||*~|'+ ISNULL(ltrim(rtrim(Ben_Short_name)),'')+'_'+ISNULL(LTRIM(RTRIM(@c_ben_acct_no)),'') + '|*~||*~||*~||*~|ACTIVE|*~||*~|0|*~|' + ISNULL(ltrim(rtrim(Fst_Hld_Fin_dtls)),'') +'|*~|*|~*' FROM DP_CLIENT_SUMMARY WHERE  CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no

                          IF NOT EXISTS(SELECT entp_ent_id FROM client_mstr,entity_properties , TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no AND clim_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = TMPCLI_FRST_HLDR_PAN_N0 AND entp_deleted_ind = 1)
                          begin
                          set @l_cli_exists_yn = 'N'
                          end
                          else
                          begin
                          set @l_cli_exists_yn = 'Y'
                          end
print @l_cli_exists_yn
 
                          IF NOT EXISTS(SELECT entp_ent_id FROM client_mstr,entity_properties , DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND clim_crn_no = entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value = Fst_Hld_Fin_dtls AND entp_deleted_ind = 1)
						  EXEC pr_ins_upd_clim  '0','INS','MIG',@L_CLIENT_VALUES,0,'*|~*','|*~|','',''
                          
                          select @l_crn_no = clim_crn_no from client_mstr,  DP_CLIENT_SUMMARY  where citrus_usr.fn_ucc_entp(clim_crn_no,'PAN_GIR_NO','')=  Fst_Hld_Fin_dtls  and CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						

						--addresses

                          SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'') <> ''
					 
							if EXISTS(SELECT CONVERT(VARCHAR,Ben_Acct_No)  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'') = '')
							BEGIN 
							  PRINT 'exists' 
							  SELECT @L_ADR = @L_ADR + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY 
							  WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'') <> ''                      
							  PRINT @L_ADR
							END
							ELSE
							BEGIN
		                      
							  SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Corr_Pin)),'')+'|*~|*|~*'
							  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'') <> ''
							END 


						 --SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'') <> ''
						 --SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Corr_Pin)),'')+'|*~|*|~*'
                         --FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'') <> ''
                         
                         if @l_cli_exists_yn = 'N'
                         begin
                         EXEC pr_ins_upd_addr @l_crn_no,'INS','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|',''	
                         end
						--addresses
						

						--contact channels
						
					                   SELECT @L_CONC = 'RES_PH1|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_Ph_No)),''),1,',')+'*|~*'+'RES_PH2|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_Ph_No)),''),2,',')+'*|~*'+'FAX1|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_fax_No)),''),1,',')+'*|~*'+'FAX2|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Ben_Hld_fax_No)),''),2,',')+'*|~*'
																								FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
																	       
																								SELECT @L_CONC = isnull(@L_CONC,'') + 'OFF_PH1|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Fst_Hld_Corr_Ph1)),''),1,',')+'*|~*'+'OFF_PH2|*~|'+citrus_usr.FN_SPLITVAL_BY(ISNULL(ltrim(rtrim(Fst_Hld_Corr_Ph1)),''),2,',')+'*|~*'
																								FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
	     

                         SELECT @L_CONC = isnull(@L_CONC,'') + 'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(Fst_Hld_Email)),'')+'*|~*'+'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(Fst_Hld_Mob)),'')+'*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						  
						 
                         if @l_cli_exists_yn = 'N'
                         begin
                          EXEC pr_ins_upd_conc @L_CRN_NO,'INS','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''
                         end
						--contact channels

						--dp_acct_mstr
                          select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                          select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
						  select @l_dp_acct_values = isnull(convert(varchar,@l_compm_id),'')+'|*~|'+ isnull(convert(varchar,@l_excsm_id),'')+'|*~|'+isnull(convert(varchar,@l_dpm_dpid),'')+'|*~|'+isnull(@c_ben_acct_no,'')+'|*~|'+ISNULL(ltrim(rtrim(Ben_Fst_Hld_Name)),'')+'|*~||*~|ACTIVE|*~|'+isnull(Ben_Acct_Ctgry,'') + '|*~|' + isnull(clicm_cd,'')+'|*~|'+isnull(ltrim(rtrim(Ben_Type)),'')+isnull(ltrim(rtrim(Ben_sub_Type)),'')+'|*~|0|*~|A|*~|*|~*' FROM DP_CLIENT_SUMMARY, sub_ctgry_mstr, client_ctgry_mstr WHERE  clicm_id = subcm_clicm_id and CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and isnull(ltrim(rtrim(Ben_Type)),'')+isnull(ltrim(rtrim(Ben_sub_Type)),'') = subcm_cd
        
        print 'DPAM'                  
                          print @l_dp_acct_values
						  exec pr_ins_upd_dpam @l_crn_no,'INS','MIG',@l_crn_no,@l_dp_acct_values,0,'*|~*','|*~|',''

						  UPDATE DP_ACCT_MSTR SET DPAM_BATCH_NO = 1,dpam_acct_no = 'A'+ dpam_acct_no WHERE DPAM_SBA_NO = @c_ben_acct_no
						  
						--dp_acct_mstr
                         SET @L_ADR  = ''
                         
                         SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and isnull(Fst_Hld_Addr1,'') <> ''
						 SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_CorrAdr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and isnull(Fst_Hld_CorrAdr1,'') <> ''
                         SELECT @L_ADR = @L_ADR  + case when nom_gua_ind = 'N' then 'NOMINEE_ADR1|*~|' else 'GUARD_ADR|*~|' end +ISNULL(ltrim(rtrim(Nom_Gua_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Nom_Gua_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Fst_Hld_Corr_Pin)),'')+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and isnull(Nom_Gua_Addr1,'') <> ''
                         SELECT @L_ADR = @L_ADR  + 'NOM_GUARDIAN_ADDR|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr1)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr2)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr3)),'')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Addr4)),'')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(ltrim(rtrim(Min_Nom_Gua_Pin)),'')+'|*~|*|~*'
                         FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and isnull(Min_Nom_Gua_Addr1,'') <> ''

                          

                          
       
                          EXEC 	pr_dp_ins_upd_addr '0','INS','MIG',0,@c_ben_acct_no,'dp',@L_ADR,0,'*|~*','|*~|',''	
						


                           SELECT @L_acc_conc = 'SH_EMAIL1|*~|'+ISNULL(ltrim(rtrim(Sec_Hld_Email)),'')+'*|~*'+'SH_MOBILE|*~|'+ISNULL(ltrim(rtrim(Sec_Hld_Mob)),'')+'*|~*'   FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						   SELECT @L_acc_conc = @L_acc_conc  + 'TH_EMAIL1|*~|'+ISNULL(ltrim(rtrim(Trd_Hld_Email)),'')+'*|~*'+'TH_MOBILE|*~|'+ISNULL(ltrim(rtrim(Trd_Hld_Mob)),'')+'*|~*'   FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
                        

                          
       
                          EXEC 	pr_dp_ins_upd_CONC '0','INS','MIG',0,@c_ben_acct_no,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''	
						




						--dp_holder_dtls/addresses/conctact_channels
						declare @pa_fh_dtls varchar(8000)
                               ,@pa_sh_dtls varchar(8000)
                               ,@pa_th_dtls varchar(8000)
                               ,@pa_nomgau_dtls varchar(8000)
                               ,@pa_nom_dtls varchar(8000)
                               ,@pa_gau_dtls varchar(8000)

						  select @pa_fh_dtls = ''+'|*~|'+''+'|*~|'+''+'|*~|'+isnull(ltrim(rtrim(Fst_Hld_Fth_name)),'')+'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						  select @pa_sh_dtls = isnull(ltrim(rtrim(Ben_Sec_Hld_Name)),'')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull(ltrim(rtrim(Sec_Hld_Fth_Name)),'')+'|*~|'++'|*~|'+isnull(ltrim(rtrim(Sec_Hld_Fin_dtls)),'')+'|*~|'++'|*~|*|~*'  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						  select @pa_th_dtls = isnull(ltrim(rtrim(Ben_Thrd_Hld_Name)),'')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull(ltrim(rtrim(Thrd_Hld_Fth_Name)),'')+'|*~|'++'|*~|'+isnull(ltrim(rtrim(Thrd_Hld_Fin_dtls)),'')+'|*~|'++'|*~|*|~*' FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						  select @pa_nomgau_dtls = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						  select @pa_nom_dtls = case when nom_gua_ind = 'N' then isnull(ltrim(rtrim(nom_gua_name)),'')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|'+isnull('','')+'|*~|*|~*'  else '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  end FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						  select @pa_gau_dtls = case when nom_gua_ind = 'G' then isnull(ltrim(rtrim(nom_gua_name)),'') +'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' else '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  end FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no

                          exec pr_ins_upd_dphd '0',@l_crn_no,@c_ben_acct_no,'INS','HO',@pa_fh_dtls,@pa_sh_dtls,@pa_th_dtls,@pa_nomgau_dtls,@pa_nom_dtls,@pa_gau_dtls,0,'*|~*','|*~|',''             
         
						--dp_holder_dtls/addresses/conctact_channels

                        -- entity_relationship 
                           DECLARE @l_activation_dt varchar(20)   
                           SELECT @l_activation_dt = RIGHT(CONVERT(varchar(8),Cli_Act_Dt_tm),2) +'/'+ substring(CONVERT(varchar(8),Cli_Act_Dt_tm),5,2) + '/' + LEFT(CONVERT(varchar(8),Cli_Act_Dt_tm),4) FROM DP_CLIENT_SUMMARY tcdmc WHERE Ben_Acct_No = @c_ben_acct_no  AND Cli_Act_Dt_tm <> ''
                           select @l_br_sh_name  = entm_short_name from entity_mstr ,DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no and entm_short_name = br_cd
                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           select @l_entr_value = convert(varchar,ISNULL(@l_compm_id,0))+'|*~|'+convert(varchar,ISNULL(@l_excsm_id,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@c_ben_acct_no,'')+'|*~|'+ISNULL(@l_activation_dt,'')+'|*~|'++'HO|*~|HO|*~|RE|*~||*~|AR|*~||*~|BR|*~|'+ isnull(@l_br_sh_name,'') +'|*~|SB|*~||*~|RM_BR|*~||*~|FM|*~||*~|SBFR|*~||*~|INT|*~||*~|A*|~*'
                           print @l_entr_value 
                           print @l_crn_no
--select count(*) from entity_relationship--61033
                           exec pr_ins_upd_dpentr '0','','HO',@l_crn_no,@l_entr_value ,0,'*|~* ','|*~|',''
--select count(*) from entity_relationship--61033
                        -- entity_relationship 

						--bank_mstr/addresses/conctact_channels
                          SELECT @L_BANK_NAME = ltrim(rtrim(Ben_Bank_Name)) , @L_BANM_BRANCH = ltrim(rtrim(Bank_Addr1)) + '('+ ltrim(rtrim(Bank_Addr_Pin)) +')' , @L_MICR_NO = Bank_Micr FROM DP_CLIENT_SUMMARY   where CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
 
                          SELECT @L_ADDR_VALUE = 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr4)),'')+'|*~|'+'|*~|'+ISNULL(LTRIM(RTRIM(Bank_Addr_PIN)),'')+'|*~|'+'*|~*' FROM DP_CLIENT_SUMMARY WHERE   CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no 

                           IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH )
                           BEGIN
                              SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH ) or banm_micr = @L_MICR_NO
                           END
                           ELSE 
                           BEGIN
                           

                             EXEC pr_mak_banm  '0','INS','MIG',@L_BANK_NAME,@L_BANM_BRANCH,@l_micr_no,'','','',0,1,@L_ADDR_VALUE,0,'','*|~*','|*~|',''
                           
                             SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) or banm_micr = @L_MICR_NO

                           END
                         


  


						  --pr_mak_banm 
						--bank_mstr/addresses/conctact_channels*/

						--client_bank_accts
                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                            
                           select @l_crn_no = entp_ent_id from entity_properties ,  DP_CLIENT_SUMMARY  where entp_value =  Fst_Hld_Fin_dtls and entp_entpm_cd = 'PAN_GIR_NO' and CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no
						   select @l_dpba_values = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no)) +'|*~|'	+ LTRIM(RTRIM(Ben_Fst_Hld_Name)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+case when Ben_Bank_Acc_Type = '10' then 'SAVINGS' when Ben_Bank_Acc_Type = '11' then 'CURRENT' else 'OTHERS' end +'|*~|' + LTRIM(RTRIM(Ben_Bank_ACC_No)) + '|*~|1|*~|0|*~|A*|~*'  FROM   DP_CLIENT_SUMMARY WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no

						   exec pr_ins_upd_dpba '0','INS','MIG',@l_crn_no,@l_dpba_values,0,'*|~*','|*~|',''
						--client_bank_accts 
                        --brokerage
                           select @l_dpm_dpid = dpm_dpid , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'
                           select @l_compm_id = excsm_compm_id from exch_seg_mstr where excsm_id = @l_excsm_id 
                           

							declare @l_brom_id varchar(100), @l_brkg_val varchar(1000)
							set @l_brom_id  = ''
                            SELECT @l_activation_dt = RIGHT(CONVERT(varchar(8),Cli_Act_Dt_tm),2) +'/'+ substring(CONVERT(varchar(8),Cli_Act_Dt_tm),5,2) + '/' + LEFT(CONVERT(varchar(8),Cli_Act_Dt_tm),4) FROM DP_CLIENT_SUMMARY tcdmc WHERE Ben_Acct_No = @c_ben_acct_no  AND Cli_Act_Dt_tm <> ''
                            select @l_brom_id = brom_id from brokerage_mstr where BROM_DESC = 'GENERAL'
                            set @l_brkg_val = convert(varchar,@l_compm_id)  +'|*~|'+convert(varchar,@l_excsm_id) +'|*~|'+ isnull(@l_dpm_dpid,'') + '|*~|'+ LTRIM(RTRIM(@c_ben_acct_no)) +'|*~|' + @l_activation_dt+'|*~|'+ @l_brom_id +'|*~|A*|~*'
		
							if @l_brom_id  <> ''
							exec pr_ins_upd_client_brkg @l_crn_no,'','MIG',@L_crn_no,@l_brkg_val,0,'*|~*','|*~|',''
                        --brokerage
						--account_properties
                          SET @L_ACCP_VALUE = ''
						  SELECT @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Ben_SEBI_Reg_No)),'')) + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD = 'SEBI_REG_NO'
                          SELECT @L_ACCP_VALUE = @L_ACCP_VALUE+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD  = 'CMBP_ID'
                          SELECT @L_ACCP_VALUE = @L_ACCP_VALUE+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(ben_rbi_ref_no)),'')) + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR  WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD   = 'RBI_REF_NO'
                          SELECT @L_ACCP_VALUE = @L_ACCP_VALUE+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(Fst_Hld_Mapin)),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD  = 'MAPIN_ID'
                          SELECT @L_ACCP_VALUE = @L_ACCP_VALUE+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN ISNULL(LTRIM(RTRIM(Stan_Inst_Ind)),'') = 'Y' THEN '1' END + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD  = 'STAN_INS_IND' AND ISNULL(LTRIM(RTRIM(Stan_Inst_Ind)),'') = 'Y' 
                          SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' +  case when left(upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')),3) ='IN6' then 'BSE' when left(upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')),3) ='IN5'  then  'NSE' end + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD  = 'CMBPEXCH' and left(upper(ISNULL(LTRIM(RTRIM(Corr_BP_Id)),'')),3) in ('IN5','IN6')
                          SELECT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + RIGHT(CONVERT(varchar(8),Cli_Act_Dt_tm),2) +'/'+ substring(CONVERT(varchar(8),Cli_Act_Dt_tm),5,2) + '/' + LEFT(CONVERT(varchar(8),Cli_Act_Dt_tm),4)  + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD  = 'BILL_START_DT' 
                         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'') + CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN upper(ISNULL(LTRIM(RTRIM(SMS_flg_FH)),'')) = 'Y' THEN '1' ELSE '0' END  + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD = 'SMS_FLAG' AND ISNULL(SMS_flg_FH,'N') <> 'N'
SET @L_accpd_VALUE = ''

SELECT DISTINCT @L_accpd_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + RIGHT(ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),''),4)  + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ACCPM_PROP_CD = 'RBI_REF_NO' AND ACCDM_CD = 'RBI_APP_DT' AND ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID

                          SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DP_CLIENT_SUMMARY WHERE DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No)  AND CONVERT(VARCHAR,Ben_Acct_No)  = @c_ben_acct_no

						  EXEC pr_ins_upd_accp '0' ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no,'DP',@L_ACCP_value,@L_accpd_VALUE ,0,'*|~*','|*~|',''
                                   
						--account_properties

						--entity_properties
						  
						 
				          SET @L_ENTP_VALUE       = ''
--						    SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(ben_rbi_ref_no)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO'
                            SELECT DISTINCT @L_ENTP_VALUE = @L_ENTP_VALUE + CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM([citrus_usr].[fn_reverse_mapping]('CDSL','TAX_DEDUCTION',ben_tax_ded_statuS))),'')) + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ENTPM_CD = 'TAX_DEDUCTION'
                            SELECT DISTINCT @L_ENTP_VALUE = @L_ENTP_VALUE + CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +  case when LTRIM(RTRIM(Ben_Occup)) = '01' then  upper('Service')
																								when Ben_Occup = '02' then  upper('Student')
																								when Ben_Occup  = '03'  then  upper('Housewife')
																								when Ben_Occup  = '04' then  upper('Landlord'  )                                          
																								when Ben_Occup  =  '05'  then upper('Business')
																								when Ben_Occup  = '06'  then  upper('Professional')
																								when Ben_Occup  = '07'  then  upper('Agriculture')
																								when Ben_Occup  = '08' then  upper('Others') else '' end + '|*~|*|~*' 	           FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no AND ENTPM_CD = 'OCCUPATION'
 
SET @L_ENTPD_VALUE = ''
                           --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(Ben_RBI_App_date)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE Ben_Acct_No = @c_ben_acct_no AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID
                            


                           
					       
						   

						   EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''  
						  --
						  
						--entity_properties


						--account_documents
						
						  --pr_ins_upd_accd
						--account_documents


						--client_docuements
						
						  --pr_ins_upd_clid
						--client_docuements
	
				
				
				  fetch next from @c_client_summary into @c_ben_acct_no 
				--
				END
			     
			    CLOSE        @c_client_summary
				DEALLOCATE   @c_client_summary
	


                                      
							
		--
 	END
	

	update filetask set status = 'COMPLETED', TASK_END_DATE = getdate() where status = 'running' AND TASK_NAME = 'CLIENT MASTER IMPORT - NSDL'

--  
END

GO
