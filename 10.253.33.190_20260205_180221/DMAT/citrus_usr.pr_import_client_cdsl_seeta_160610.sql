-- Object: PROCEDURE citrus_usr.pr_import_client_cdsl_seeta_160610
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin tran
--exec pr_import_client_cdsl 'CDSL','HO','normal','','*|~*','|*~|',''  
--select * from bitmap_ref_mstr  
--pr_delete_client 146380  
--begin transaction  
--[pr_import_client_cdsl] 'CDSL','HO','normal','','*|~*','|*~|',''  
--SELECT * FROM DP_CLIENT_SUMMARY where isnull(bank_micr,'') = ''  
--select distinct entpm_cd  from entity_property_mstr  
--SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL  
--select * from account_properties order by 1 desc  
--select * from dp_acct_mstr order  by 1 desc   
--select * from client_bank_accts order  by 2 desc   
--COMMIT transaction  
--rollback   
--|*~||*~||*~|10000158|*~|SHYLA  V MRS|*~||*~|ACTIVE|*~|02|*~|01|*~|0101|*~|0|*~|A|*~|*|~*  
CREATE PROCEDURE  [citrus_usr].[pr_import_client_cdsl_seeta_160610]
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
set nocount ON  
  
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
                         
 
         
      
   
          declare @c_client_summary1  cursor  
                 ,@c_ben_acct_no1  varchar(20)  
  
                 set @c_client_summary1  = CURSOR fast_forward FOR                
                 select TMPCLI_BOID    from TMP_CLIENT_DTLS_MSTR_CDSL   
                 where TMPCLI_BOID in (select dpam_sba_no from dp_Acct_mstr) and TMPCLI_ACCT_STAT <> '10'  
          
          open @c_client_summary1  
          
          fetch next from @c_client_summary1 into @c_ben_acct_no1   
          
          
          
        WHILE @@fetch_status = 0                                                                                                          
        BEGIN --#cursor                                                                                                          
        --  
          select @l_crn_no = clim_crn_no from client_mstr,  DP_ACCT_MSTR where DPAM_CRN_NO = CLIM_CRN_NO AND DPAM_SBA_NO =  @c_ben_acct_no1  
                            
                           
           set @L_ADR   = ''  
  
           SET @L_acc_conc = ''  
  
                 SELECT @L_acc_conc = 'ACCOFF_PH1|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPH_NO)),'')+'*|~*'+'ACCOFF_PH2|*~|'+ISNULL(ltrim(rtrim(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'   FROM   TMP_CLIENT_DTLS_MSTR_CDSL WHERE TMPCLI_BOID = @c_ben_acct_no1 and isnull(TMPCLI_BO_ADDP_LIN1,'') <> ''  
                  
                   
  
                 EXEC  pr_dp_ins_upd_CONC @l_crn_no,'EDT','MIG',0,@c_ben_acct_no1,'dp',@L_ACC_CONC,0,'*|~*','|*~|',''   
                 set @L_acc_conc = ''  
                  
                          fetch next from @c_client_summary1 into @c_ben_acct_no1   
                     
                     
                 --  
                 end  
      
                 close @c_client_summary1    
                 deallocate  @c_client_summary1    
  
    
  
     
   
--    
END

GO
