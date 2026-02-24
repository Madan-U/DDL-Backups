-- Object: PROCEDURE citrus_usr.pr_auto_blgl
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE  [citrus_usr].[pr_auto_blgl] 
(@pa_entm_id numeric,@PA_SOURCE VARCHAR(100) )
as 
begin 

declare @L_short_name varchar (50),
@L_name varchar (250),
@l_glcode varchar (100),
@l_dpmid varchar (12) ,
@l_glcode_CGST varchar (100),
@l_glcode_SGST varchar (100),
@l_glcode_IGST varchar (100),
@l_glcode_UGST varchar (100) ,
@L_CGSTAMT NUMERIC,
@L_SGSTAMT NUMERIC,
@L_IGSTAMT NUMERIC,
@L_UGSTAMT NUMERIC,
@L_name_CGST VARCHAR(100),
@L_name_SGST VARCHAR(100),
@L_name_IGST VARCHAR(100),
@L_name_UGST VARCHAR(100)

SET @L_CGSTAMT = 0
SET @L_SGSTAMT = 0
SET @L_IGSTAMT = 0
SET @L_UGSTAMT = 0


 
declare @l_UT_flg char(10)
set @l_UT_flg = 'NO'
select @l_UT_flg  = entp_value from entity_properties where entp_ent_id = @pa_entm_id and entp_deleted_ind = 1 
 and entp_entpm_cd = 'UT'



select top 1  @l_dpmid = DPM_DPID from dp_mstr where default_dp = dpm_excsm_id and dpm_deleted_ind = '1' order by DPM_DPID  
select @L_short_name = entm_short_name, @L_name = isnull(ENTM_NAME1,'')+' '+isnull (ENTM_NAME2,'')+' '+isnull (ENTM_NAME3,'')
from entity_mstr where entm_id =@pa_entm_id and entm_deleted_ind = '1' and ENTM_ENTTM_CD = 'BL'

 set @l_glcode = convert(varchar(100),@pa_entm_id)+'_'+@L_short_name
 
 SET  @l_glcode_CGST  =@l_glcode+'_CGST'
 SET  @l_glcode_SGST  =@l_glcode+'_SGST'
 SET  @l_glcode_IGST  =@l_glcode+'_IGST'
 SET  @l_glcode_UGST  =@l_glcode+'_UGST'
 
	SET @L_name_CGST = @L_name +' CGST'
	SET @L_name_SGST = @L_name +' SGST'
	SET @L_name_IGST = @L_name +' IGST'
	SET @L_name_UGST = @L_name +' UGST'
	
	print @L_short_name
	
	if @L_short_name <> ''
	begin 
	IF   @PA_SOURCE = 'ENTITY'
		BEGIN 
	
		--if @l_UT_flg   = 'NO'
		--begin  

			if exists (select 1 from fin_account_mstr where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
			AND @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_') and fina_Acc_code like '%CGST%' )
			begin

		
				update  fin_account_mstr set fina_Acc_code = @l_glcode_CGST,
				FINA_ACC_NAME = @L_name_CGST  
				  where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
				  and @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_') and fina_Acc_code like '%CGST%'

			end 
			else 
			begin 

			declare @p13 varchar(8000)
				set @p13=''
				exec pr_ins_upd_finaccm @pa_id='0',@pa_action='INS',@pa_login_name='MIG',@pa_acc_code=@l_glcode_CGST,@pa_acc_name=@L_name_CGST,@pa_acc_type='G',@pa_group_id=7,@pa_branch_id=0,@pa_DPM_ID=@l_dpmid,@pa_chk_yn=0,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p13 output
				--select @p13
		

			end 

		    if exists (select 1 from fin_account_mstr where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
			AND @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_') and fina_Acc_code like '%SGST%' )
			begin

		
			   update  fin_account_mstr set fina_Acc_code = @l_glcode_SGST,
			  FINA_ACC_NAME = @L_name_SGST
			  where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
			  and @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_')and fina_Acc_code like '%SGST%'

			  end 
			  else
			  begin
			  	declare @p14 varchar(8000)
				set @p14=''
				exec pr_ins_upd_finaccm @pa_id='0',@pa_action='INS',@pa_login_name='MIG',@pa_acc_code=@l_glcode_SGST,@pa_acc_name=@L_name_SGST,@pa_acc_type='G',@pa_group_id=7,@pa_branch_id=0,@pa_DPM_ID=@l_dpmid,@pa_chk_yn=0,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p14 output
				--select @p14
		

			  end 
			    if exists (select 1 from fin_account_mstr where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
				AND @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_') and fina_Acc_code like '%IGST%' )
				begin
					  
				  update  fin_account_mstr set fina_Acc_code = @l_glcode_IGST,
				  FINA_ACC_NAME = @L_name_IGST
				  where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
				  and @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_')and fina_Acc_code like '%IGST%'

				  end 
				  else 
				  begin

			  
					declare @p15 varchar(8000)
					set @p15=''
					exec pr_ins_upd_finaccm @pa_id='0',@pa_action='INS',@pa_login_name='MIG',@pa_acc_code=@l_glcode_IGST,@pa_acc_name=@L_name_IGST,@pa_acc_type='G',@pa_group_id=7,@pa_branch_id=0,@pa_DPM_ID=@l_dpmid,@pa_chk_yn=0,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p15 output
					--select @p15

				 end 

		--end 
		   
		  --if @l_UT_flg   = 'YES'
		  --begin

		    if exists (select 1 from fin_account_mstr where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
			AND @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_') and fina_Acc_code like '%UGST%' )
			begin

			  update  fin_account_mstr set fina_Acc_code = @l_glcode_UGST,
			  FINA_ACC_NAME = @L_name_UGST
			  where ISNUMERIC (citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_'))= 1 
			  and @pa_entm_id = citrus_usr.Fn_splitval_by (FINA_ACC_CODE, 1 ,'_')and fina_Acc_code like '%UGST%'
			 end 
			 else 
			 begin 
			 	declare @p16 varchar(8000)
				set @p16=''
				exec pr_ins_upd_finaccm @pa_id='0',@pa_action='INS',@pa_login_name='MIG',@pa_acc_code=@l_glcode_UGST,@pa_acc_name=@L_name_UGST,@pa_acc_type='G',@pa_group_id=7,@pa_branch_id=0,@pa_DPM_ID=@l_dpmid,@pa_chk_yn=0,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p16 output
				--select @p16

			 end 
		--  end 
	
end
		 
		SELECT @L_CGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'CGST'
		SELECT @L_SGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'SGST'
		SELECT @L_IGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'IGST'
		SELECT @L_UGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'UGST'
		

				--if @l_UT_flg   = 'NO'
				--begin 
		 
					if NOT exists (select 1 from SERVICETAX_MSTR  where @pa_entm_id = SERM_ENTM_ID  and tax_desc='CGST') AND @PA_SOURCE = 'PROP'
					BEGIN 

					insert into servicetax_mstr
					select @L_CGSTAMT/100,'2017-07-01 00:00:00.000','2100-01-01 00:00:00.000','A',getdate(),'A',getdate(),1,'CGST',@pa_entm_id
					
					end
					else 
					begin
							UPDATE A SET amount = @L_CGSTAMT/100
						FROM SERVICETAX_MSTR  A , ENTITY_MSTR WHERE SERM_ENTM_ID = ENTM_ID AND Tax_Desc = 'CGST'
						and ENTM_ENTTM_CD = 'BL' and SERM_ENTM_ID = @pa_entm_id 
				
					end  
					if NOT exists (select 1 from SERVICETAX_MSTR  where @pa_entm_id = SERM_ENTM_ID  and tax_desc='SGST') AND @PA_SOURCE = 'PROP'
					BEGIN 

					insert into servicetax_mstr
					select @L_SGSTAMT/100,'2017-07-01 00:00:00.000','2100-01-01 00:00:00.000','A',getdate(),'A',getdate(),1,'SGST',@pa_entm_id
					
					end 
					else
					begin
						UPDATE A SET amount = @L_SGSTAMT/100
					FROM SERVICETAX_MSTR  A , ENTITY_MSTR WHERE SERM_ENTM_ID = ENTM_ID AND Tax_Desc = 'SGST'
					and ENTM_ENTTM_CD = 'BL' and SERM_ENTM_ID = @pa_entm_id
		
					end 
					if NOT exists (select 1 from SERVICETAX_MSTR  where @pa_entm_id = SERM_ENTM_ID  and tax_desc='IGST') AND @PA_SOURCE = 'PROP'
					BEGIN 
				
					insert into servicetax_mstr
					select @L_IGSTAMT/100,'2017-07-01 00:00:00.000','2100-01-01 00:00:00.000','A',getdate(),'A',getdate(),1,'IGST',@pa_entm_id
					end 
					else 
					begin 
						UPDATE A SET amount = @L_IGSTAMT/100
						FROM SERVICETAX_MSTR  A , ENTITY_MSTR WHERE SERM_ENTM_ID = ENTM_ID AND Tax_Desc = 'IGST'
						and ENTM_ENTTM_CD = 'BL' and SERM_ENTM_ID = @pa_entm_id 
				

					end 
			--	end 
				
				--if @l_UT_flg   = 'YES'
				--begin 
					if NOT exists (select 1 from SERVICETAX_MSTR  where @pa_entm_id = SERM_ENTM_ID  and tax_desc='UGST') AND @PA_SOURCE = 'PROP'
					BEGIN 
						
					insert into servicetax_mstr
					select @L_UGSTAMT/100,'2017-07-01 00:00:00.000','2100-01-01 00:00:00.000','A',getdate(),'A',getdate(),1,'UGST',@pa_entm_id
					end 
					else
					begin 
					
					SELECT @L_UGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'UGST'
		
		
					UPDATE A SET amount = @L_UGSTAMT/100
					FROM SERVICETAX_MSTR  A , ENTITY_MSTR WHERE SERM_ENTM_ID = ENTM_ID AND Tax_Desc = 'UGST'
					and ENTM_ENTTM_CD = 'BL' and SERM_ENTM_ID = @pa_entm_id

			
					end 
				--END
		
	

				--SELECT @L_CGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'CGST'
				--SELECT @L_SGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'SGST'
				--SELECT @L_IGSTAMT = ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENT_ID = @pa_entm_id AND ENTP_ENTPM_CD = 'IGST'

				
		
				
				
				
	
		
		

	END
END

GO
