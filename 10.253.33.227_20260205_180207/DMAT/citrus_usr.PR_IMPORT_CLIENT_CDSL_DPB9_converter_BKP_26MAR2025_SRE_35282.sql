-- Object: PROCEDURE citrus_usr.PR_IMPORT_CLIENT_CDSL_DPB9_converter_BKP_26MAR2025_SRE_35282
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------






CREATE PROCEDURE  [citrus_usr].[PR_IMPORT_CLIENT_CDSL_DPB9_converter_BKP_26MAR2025_SRE_35282]
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

--set nocount ON  
  
set dateformat dmy


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


		   if @PA_MODE ='BULK' 
		begin 

		truncate table [CLN_MSTR_CDSL]


		DECLARE @@SSQL VARCHAR(8000)  



		declare @l_path varchar(1000)
		declare @l_fillist varchar(5000)
		 select @l_path = replace(@pa_db_source ,citrus_usr.fn_splitval_by (@pa_db_source  , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\')  ,'') --path without filename 
		 select @l_fillist = citrus_usr.fn_splitval_by (@pa_db_source  , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') -- filelist 

		 declare @l_count numeric
		 declare @l_counter numeric
		 select @l_count  = citrus_usr.ufn_CountString (@l_fillist,'*|~*')
		 set @l_counter = 1 
 
		 while @l_counter < = @l_count
		 begin 

 


 
		SET @@SSQL ='BULK INSERT [CLN_MSTR_CDSL] FROM ''' +  @l_path + citrus_usr.fn_splitval_by (@l_fillist,@l_counter,'*|~*') + ''' WITH   
		( 
								FIELDQUOTE = ''"''
								, FIELDTERMINATOR = '',''
								, ROWTERMINATOR = ''\n''
					
								,FORMAT=''CSV''
								,FIRSTROW = 2 

		)'  

		print @@SSQL 
		exec (@@SSQL)


		 set @l_counter = @l_counter + 1 

		 end 


		end  

 

		insert into [CLN_MSTR_CDSL_log]
		select *,getdate() from [CLN_MSTR_CDSL]

		exec pr_bulk_dpb9_harm 
		--dpb9_pc22
		EXEC pr_ins_upd_dps8_pc22
		--dps8_pc22
		exec pr_ins_upd_uccdtls_dpb9	
		--CDSL_UCC_DTLS_MSTR


--    
END

GO
