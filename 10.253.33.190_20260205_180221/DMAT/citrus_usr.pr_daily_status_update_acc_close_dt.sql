-- Object: PROCEDURE citrus_usr.pr_daily_status_update_acc_close_dt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
--rollback
--begin transaction
--[pr_daily_status_update] 'NSDL','HO','','','*|~*','|*~|',''
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

CREATE PROCEDURE  [citrus_usr].[pr_daily_status_update_acc_close_dt](@pa_exch          VARCHAR(20)  
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

						    
end 

       
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
         
         
            SET @L_ACCP_VALUE = ''
						      
            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + RIGHT(CONVERT(varchar(8),Ben_Acct_Closure_date),2) +'/'+ substring(CONVERT(varchar(8),Ben_Acct_Closure_date),5,2) + '/' + LEFT(CONVERT(varchar(8),Ben_Acct_Closure_date),4)  + '|*~|*|~*' 	FROM DP_CLIENT_SUMMARY ,ACCOUNT_PROPERTY_MSTR WHERE CONVERT(VARCHAR,Ben_Acct_No) = @c_ben_acct_no1 AND ACCPM_PROP_CD  = 'ACC_CLOSE_DT' 
            
			SET @L_accpd_VALUE = ''

            SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DP_CLIENT_SUMMARY WHERE DPAM_SBA_NO = CONVERT(VARCHAR,Ben_Acct_No)  AND CONVERT(VARCHAR,Ben_Acct_No)  = @c_ben_acct_no1

						      EXEC pr_ins_upd_accp '0' ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,@L_accpd_VALUE ,0,'*|~*','|*~|',''
                       SET @L_accpd_VALUE = ''            
                       SET @L_ACCP_VALUE = ''


                   
                   fetch next from @c_client_summary1 into @c_ben_acct_no1 
                 --
                 end
    
                 close @c_client_summary1  
                 deallocate  @c_client_summary1  


--  
END

GO
