-- Object: PROCEDURE citrus_usr.pr_ins_upd_poam
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--	0	EDT	3	17	18	0	ASASAS	ASAS	ASAS																	3/11/2008	3/11/2008		AGRICULTURE		METROPOLITIAN	DOCTRATE	1LAKH TO 2 LAKHS	CANADA		ASSAMESE	NONE	18	BSE									INDIAN RUPEE			0	0			0	DAILY	THE|*~|LATESH|*~|WAI|*~|../CCRSDocuments/ganeshkaka.txt|*~|A*|~*	VISHAL	0	
--pr_ins_upd_poam 21,'EDT',3,21,'18',0,'ASASAS','ASAS','ASAS','','','','','','','','','','','','','','','','','3/11/2008','3/11/2008','','AGRICULTURE','','METROPOLITIAN','DOCTRATE','1LAKH TO 2 LAKHS','CANADA','','ASSAMESE','NONE','18','BSE','','','','','','','','','INDIAN RUPEE','','',0,0,'','',0,'DAILY','21|*~|THE|*~|LATESH|*~|WAI|*~|../CCRSDocuments/ganeshkaka.txt|*~|A*|~*','VISHAL',0,''
--SELECT * FROM POA_AUTH_MSTR
CREATE PROCEDURE  [citrus_usr].[pr_ins_upd_poam]( @pa_id  numeric,
	 @pa_action  varchar(25),
	 @pa_excsm_id numeric ,
	 @PA_poam_id   numeric (18, 0) ,
	 @PA_poam_ctgry   varchar (25)  ,
	 @PA_poam_product_cd   numeric (18, 0) ,
	 @PA_poam_name1   varchar (100)  ,
	 @PA_poam_name2   varchar (20)  ,
	 @PA_poam_name3   varchar (20)  ,
	 @PA_poam_title   varchar (20)  ,
	 @PA_poam_suffix   varchar (20)  ,
	 @PA_poam_fth_name   varchar (50)  ,
	 @PA_poam_adr1   varchar (30)  ,
	 @PA_poam_adr2   varchar (30)  ,
	 @PA_poam_adr3   varchar (30)  ,
	 @PA_poam_city   varchar (25)  ,
	 @PA_poam_state   varchar (25)  ,
	 @PA_poam_country   varchar (25)  ,
	 @PA_poam_zip   varchar (10)  ,
	 @PA_poam_ph1   varchar (17)  ,
	 @PA_poam_ph2   varchar (17)  ,
	 @PA_poam_fax   varchar (17)  ,
	 @PA_poam_pan_no   varchar (17)  ,
	 @PA_poam_it_circle   varchar (15)  ,
	 @PA_poam_email   varchar (50)  ,
	 @PA_poam_Date_Of_Maturity   datetime  ,
	 @PA_poam_dob   datetime  ,
	 @PA_poam_sex   char (10)  ,
	 @PA_poam_Occupation   varchar (30)  ,
	 @PA_poam_Life_Style   varchar (30)  ,
	 @PA_poam_Geo_Cd   varchar (30)  ,
	 @PA_poam_Edu   varchar (30)  ,
	 @PA_poam_Anninc   varchar (30)  ,
	 @PA_paom_nationality   varchar (30)  ,
	 @PA_poam_leg_status_cd   varchar (30)  ,
	 @PA_poam_Lan_Cd   varchar (30)  ,
	 @PA_poam_Staff   varchar (30)  ,
	 @PA_poam_BO_Ctgry   varchar (30)  ,
	 @PA_poam_BO_Sett_Plflg   varchar (30)  ,
	 @PA_poam_RBI_Ref_No   varchar (30)  ,
	 @PA_poam_RBI_App_Dt   datetime  ,
	 @PA_poam_SEBI_Regini   varchar (30)  ,
	 @PA_poam_Tax_Dedu_status   varchar (30)  ,
	 @PA_poam_Smart_Card_no   varchar (30)  ,
	 @PA_poam_Smart_Card_pin   varchar (30)  ,
	 @PA_poam_ECS   varchar (30)  ,
	 @PA_poam_ElecConf   varchar (30)  ,
	 @PA_poam_Dividend_Curr   varchar (30)  ,
	 @PA_poam_Group_Code   varchar (30)  ,
	 @PA_poam_BOSubStatus   varchar (30)  ,
	 @PA_poam_CC_ID   numeric (18, 0) ,
	 @PA_poam_cm_id   numeric (18, 0) ,
	 @PA_poam_stock_exch   varchar (20)  ,
	 @PA_poam_Conf_Waived   varchar (20)  ,
	 @PA_poam_Trading_ID   numeric (18, 0) ,
	 @PA_poam_BO_stm_Cycle_Cd   varchar (20)  ,
	 @PA_poam_aut_values varchar(8000),
  @pa_login_name  varchar(25),
  @pa_chk_yn  smallint,
  @pa_errmsg  varchar(8000) out

) 
AS
BEGIN
	
	DECLARE @L_POAM_ID NUMERIC
	,@l_counter numeric
	,@l_count numeric
	,@l_aut_fname varchar(100)
	,@l_aut_mname varchar(20)
	,@l_aut_lname varchar(20)
	,@l_aut_docpath varchar(500)
	,@l_action char(1)
	,@l_aut_values varchar(1000)
	,@l_id numeric
	,@l_dpm_id numeric
	
	SELECT @l_dpm_id = dpm_id FROM dp_mstr WHERE dpm_excsm_id = @pa_excsm_id AND isnull(dp_mstr.default_dp,'0') <> '0'
	
	IF @pa_chk_yn = 0
	BEGIN
	
		IF @pa_action =  'INS'
		BEGIN
			
			SELECT @L_POAM_ID = ISNULL(MAX(POAM_ID),0) + 1 FROM POA_MSTR
			INSERT INTO POA_MSTR
		(poam_id
		,poam_dpm_id
		,poam_ctgry
		,poam_product_cd
		,poam_name1
		,poam_name2
		,poam_name3
		,poam_title
		,poam_suffix
		,poam_fth_name
		,poam_adr1
		,poam_adr2
		,poam_adr3
		,poam_city
		,poam_state
		,poam_country
		,poam_zip
		,poam_ph1
		,poam_ph2
		,poam_fax
		,poam_pan_no
		,poam_it_circle
		,poam_email
		,poam_Date_Of_Maturity
		,poam_dob
		,poam_sex
		,poam_Occupation
		,poam_Life_Style
		,poam_Geo_Cd
		,poam_Edu
		,poam_Anninc
		,paom_nationality
		,poam_leg_status_cd
		,poam_Lan_Cd
		,poam_Staff
		,poam_BO_Ctgry
		,poam_BO_Sett_Plflg
		,poam_RBI_Ref_No
		,poam_RBI_App_Dt
		,poam_SEBI_Regini
		,poam_Tax_Dedu_status
		,poam_Smart_Card_no
		,poam_Smart_Card_pin
		,poam_ECS
		,poam_ElecConf
		,poam_Dividend_Curr
		,poam_Group_Code
		,poam_BOSubStatus
		,poam_CC_ID
		,poam_cm_id
		,poam_stock_exch
		,poam_Conf_Waived
		,poam_Trading_ID
		,poam_BO_stm_Cycle_Cd
		,poam_created_by
		,poam_created_dt
		,poam_lst_upd_by
		,poam_lst_upd_dt
		,poam_deleted_ind
		)
		VALUES(@L_POAM_ID ,
		@l_dpm_id,
	 @PA_poam_ctgry     ,
	 @PA_poam_product_cd    ,
	 @PA_poam_name1   ,
	 @PA_poam_name2  ,
	 @PA_poam_name3  ,
	 @PA_poam_title  ,
	 @PA_poam_suffix    ,
	 @PA_poam_fth_name    ,
	 @PA_poam_adr1    ,
	 @PA_poam_adr2  ,
	 @PA_poam_adr3   ,
	 @PA_poam_city  ,
	 @PA_poam_state   ,
	 @PA_poam_country   ,
	 @PA_poam_zip   ,
	 @PA_poam_ph1  ,
	 @PA_poam_ph2   ,
	 @PA_poam_fax  ,
	 @PA_poam_pan_no   ,
	 @PA_poam_it_circle   ,
	 @PA_poam_email    ,
	 @PA_poam_Date_Of_Maturity   ,
	 @PA_poam_dob   ,
	 @PA_poam_sex   ,
	 @PA_poam_Occupation    ,
	 @PA_poam_Life_Style    ,
	 @PA_poam_Geo_Cd   ,
	 @PA_poam_Edu  ,
	 @PA_poam_Anninc     ,
	 @PA_paom_nationality     ,
	 @PA_poam_leg_status_cd    ,
	 @PA_poam_Lan_Cd   ,
	 @PA_poam_Staff    ,
	 @PA_poam_BO_Ctgry    ,
	 @PA_poam_BO_Sett_Plflg    ,
	 @PA_poam_RBI_Ref_No  ,
	 @PA_poam_RBI_App_Dt     ,
	 @PA_poam_SEBI_Regini    ,
	 @PA_poam_Tax_Dedu_status   ,
	 @PA_poam_Smart_Card_no    ,
	 @PA_poam_Smart_Card_pin   ,
	 @PA_poam_ECS    ,
	 @PA_poam_ElecConf     ,
	 @PA_poam_Dividend_Curr     ,
	 @PA_poam_Group_Code    ,
	 @PA_poam_BOSubStatus   ,
	 @PA_poam_CC_ID   ,
	 @PA_poam_cm_id  ,
	 @PA_poam_stock_exch     ,
	 @PA_poam_Conf_Waived     ,
	 @PA_poam_Trading_ID    ,
	 @PA_poam_BO_stm_Cycle_Cd    ,
	 @PA_LOGIN_NAME ,
	 GETDATE(),
	 @PA_LOGIN_NAME,
	 GETDATE(),
	 1
	 
		)
		
		
		SET @pa_errmsg = @L_POAM_ID 
		
		IF @PA_poam_aut_values <> ''
		BEGIN
			 SET @l_counter = 1
			 SET @l_count = citrus_usr.ufn_CountString(@PA_poam_aut_values,'*|~*')
			 
			 WHILE @l_counter <= @l_count
			 BEGIN
			 	SET @l_aut_values = citrus_usr.FN_SPLITVAL_ROW(@PA_poam_aut_values,@l_counter)
			 	
			 	SET @l_id = citrus_usr.FN_SPLITVAL(@l_aut_values,1)
			 	SET @l_aut_fname = citrus_usr.FN_SPLITVAL(@l_aut_values,2)
					SET @l_aut_mname = citrus_usr.FN_SPLITVAL(@l_aut_values,3)
					SET @l_aut_lname = citrus_usr.FN_SPLITVAL(@l_aut_values,4)
					SET @l_aut_docpath = citrus_usr.FN_SPLITVAL(@l_aut_values,5)
					SET @l_action = citrus_usr.FN_SPLITVAL(@l_aut_values,6)
					
					IF @l_action = 'A'
					BEGIN
						
						SELECT @l_id = isnull(max(poaam_id),0)+ 1 FROM poa_auth_mstr pam 
						
						INSERT INTO poa_auth_mstr
						(
							poaam_id,
							poaam_poam_id,
							poaam_name1,
							poaam_name2,
							poaam_name3,
							poaam_created_by,
							poaam_created_dt,
							poaam_lst_upd_by,
							poaam_lst_upd_dt,
							poaam_deleted_ind,
							poaam_doc_path
						)
						VALUES
						(
							@l_id,
							@L_POAM_ID,
						 @l_aut_fname,
							@l_aut_mname,
					 	@l_aut_lname,
							@pa_login_name,
							getdATE(),
							@pa_login_name,
							getdATE(),
							1,
						 @l_aut_docpath
						)
					END
					ELSE IF @l_action ='E'
					BEGIN
						UPDATE poa_auth_mstr
						SET
							poaam_name1 = @l_aut_fname,
							poaam_name2 = @l_aut_Mname,
							poaam_name3 = @l_aut_Lname,
							poaam_lst_upd_by =	@pa_login_name,
							poaam_lst_upd_dt = GETDATE(),
							poaam_doc_path = @l_aut_docpath
						WHERE poa_auth_mstr.poaam_id	 =@L_ID
						AND   poa_auth_mstr.poaam_poam_id = @PA_ID
						AND   POAAM_DELETED_IND = 1
						
					END
					ELSE IF @l_action ='D'
					BEGIN
						UPDATE poa_auth_mstr
						SET    POAAM_LST_UPD_BY = @pa_login_name
						,POAAM_LST_UPD_DT = GETDATE()
						WHERE poa_auth_mstr.poaam_id      = @L_ID
						AND   poa_auth_mstr.poaam_poam_id = @pa_id
						AND   POAAM_DELETED_IND = 1
					END
					
					SET @L_COUNTER = @l_counter  + 1
					
			 END  
		
		  
		  
		END
			
		END
		ELSE IF @pa_action =  'EDT' OR @pa_action =  'DELAUTH'
		BEGIN
			
			IF @pa_action = 'EDT'
			BEGIN
				
	
			UPDATE POA_MSTR
			SET poam_ctgry = @PA_poam_ctgry 
		,poam_product_cd = @PA_poam_product_cd 
		,poam_name1 = @PA_poam_name1
		,poam_name2 = @PA_poam_name2
		,poam_name3 = @PA_poam_name3
		,poam_title = @PA_poam_title
		,poam_suffix = @PA_poam_suffix
		,poam_fth_name = @PA_poam_fth_name
		,poam_adr1 = @PA_poam_adr1
		,poam_adr2 = @PA_poam_adr2
		,poam_adr3 = @PA_poam_adr3
		,poam_city = @PA_poam_city
		,poam_state = @PA_poam_state
		,poam_country= @PA_poam_country
		,poam_zip= @PA_poam_zip
		,poam_ph1=@PA_poam_ph1
		,poam_ph2= @PA_poam_ph2
		,poam_fax=@PA_poam_fax
		,poam_pan_no=@PA_poam_pan_no
		,poam_it_circle=@PA_poam_it_circle
		,poam_email=@PA_poam_email
		,poam_Date_Of_Maturity=@PA_poam_Date_Of_Maturity
		,poam_dob=@PA_poam_dob
		,poam_sex=@PA_poam_sex
		,poam_Occupation=@PA_poam_Occupation
		,poam_Life_Style=@PA_poam_Life_Style
		,poam_Geo_Cd=@PA_poam_Geo_Cd
		,poam_Edu=@PA_poam_Edu
		,poam_Anninc=@PA_poam_Anninc
		,paom_nationality=@PA_paom_nationality
		,poam_leg_status_cd=@PA_poam_leg_status_cd
		,poam_Lan_Cd=@PA_poam_Lan_Cd
		,poam_Staff=@PA_poam_Staff
		,poam_BO_Ctgry=@PA_poam_BO_Ctgry
		,poam_BO_Sett_Plflg=@PA_poam_BO_Sett_Plflg
		,poam_RBI_Ref_No=@PA_poam_RBI_Ref_No
		,poam_RBI_App_Dt=@PA_poam_RBI_App_Dt
		,poam_SEBI_Regini=@PA_poam_SEBI_Regini
		,poam_Tax_Dedu_status=@PA_poam_Tax_Dedu_status
		,poam_Smart_Card_no=@PA_poam_Smart_Card_no
		,poam_Smart_Card_pin=@PA_poam_Smart_Card_pin
		,poam_ECS=@PA_poam_ECS
		,poam_ElecConf=@PA_poam_ElecConf
		,poam_Dividend_Curr=@PA_poam_Dividend_Curr
		,poam_Group_Code=@PA_poam_Group_Code
		,poam_BOSubStatus=@PA_poam_BOSubStatus
		,poam_CC_ID=@PA_poam_CC_ID
		,poam_cm_id=@PA_poam_cm_id
		,poam_stock_exch=@PA_poam_stock_exch
		,poam_Conf_Waived=@PA_poam_Conf_Waived
		,poam_Trading_ID=@PA_poam_Trading_ID
		,poam_BO_stm_Cycle_Cd=@PA_poam_BO_stm_Cycle_Cd
		,poam_lst_upd_by=@PA_LOGIN_NAME
		,poam_lst_upd_dt=GETDATE()

			WHERE poam_id =  @PA_ID
			AND POAM_DELETED_IND = 1
			
			
			END
			
			
			IF @PA_poam_aut_values <> ''  
	  BEGIN
			 SET @l_counter = 1
			 SET @l_count = citrus_usr.ufn_CountString(@PA_poam_aut_values,'*|~*')
			 
			 WHILE @l_counter <= @l_count
			 BEGIN
			 	SET @l_aut_values = citrus_usr.FN_SPLITVAL_ROW(@PA_poam_aut_values,@l_counter)
			 	
			 	SET @l_id = citrus_usr.FN_SPLITVAL(@l_aut_values,1)
			 	SET @l_aut_fname = citrus_usr.FN_SPLITVAL(@l_aut_values,2)
					SET @l_aut_mname = citrus_usr.FN_SPLITVAL(@l_aut_values,3)
					SET @l_aut_lname = citrus_usr.FN_SPLITVAL(@l_aut_values,4)
					SET @l_aut_docpath = citrus_usr.FN_SPLITVAL(@l_aut_values,5)
					SET @l_action = citrus_usr.FN_SPLITVAL(@l_aut_values,6)
					
					IF @l_action = 'A'
					BEGIN
						
						SELECT @l_id = isnull(max(poaam_id),0)+ 1 FROM poa_auth_mstr pam 
						
						INSERT INTO poa_auth_mstr
						(
							poaam_id,
							poaam_poam_id,
							poaam_name1,
							poaam_name2,
							poaam_name3,
							poaam_created_by,
							poaam_created_dt,
							poaam_lst_upd_by,
							poaam_lst_upd_dt,
							poaam_deleted_ind,
							poaam_doc_path
						)
						VALUES
						(
							@l_id,
							@pa_id,
						 @l_aut_fname,
							@l_aut_mname,
					 	@l_aut_lname,
							@pa_login_name,
							getdATE(),
							@pa_login_name,
							getdATE(),
							1,
						 @l_aut_docpath
						)
					END
					ELSE IF @l_action ='E'
					BEGIN
						UPDATE poa_auth_mstr
						SET
							poaam_name1 = @l_aut_fname,
							poaam_name2 = @l_aut_Mname,
							poaam_name3 = @l_aut_Lname,
							poaam_lst_upd_by =	@pa_login_name,
							poaam_lst_upd_dt = GETDATE(),
							poaam_doc_path = @l_aut_docpath
						WHERE poa_auth_mstr.poaam_id	 =@L_ID
						AND   poa_auth_mstr.poaam_poam_id = @PA_ID
						AND   POAAM_DELETED_IND = 1
						
					END
					ELSE IF @l_action ='D' AND @pa_action = 'DELAUTH'
					BEGIN
						UPDATE poa_auth_mstr
						SET   POAAM_DELETED_IND=0, POAAM_LST_UPD_BY = @pa_login_name
						,POAAM_LST_UPD_DT = GETDATE()
						WHERE poa_auth_mstr.poaam_id = @L_ID
						AND   poa_auth_mstr.poaam_poam_id = @pa_id
						AND   POAAM_DELETED_IND = 1
					END
					
					SET @L_COUNTER = @l_counter  + 1
					
			 END  
		
		  
		  
		END
		
		
		END
		ELSE IF @pa_action =  'DEL'
		BEGIN
			
			UPDATE poa_auth_mstr
			SET POAAM_LST_UPD_BY = @pa_login_name
			,POAAM_LST_UPD_DT =GETDATE()
			WHERE poaam_poam_id = @pa_id
			
	 	UPDATE poa_mstr
			SET POAM_LST_UPD_BY = @pa_login_name
			,POAM_LST_UPD_DT =GETDATE()
			WHERE poam_id = @pa_id
		END
	END
	ELSE IF @pa_chk_yn = 1
	BEGIN
		PRINT '1'
	END
END

GO
