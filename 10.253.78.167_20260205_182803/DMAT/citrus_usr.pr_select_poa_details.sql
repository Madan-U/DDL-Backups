-- Object: PROCEDURE citrus_usr.pr_select_poa_details
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--EXEC [pr_select_poa_details] '0','POA_DETAILS','','','','3','','','','CLIENTS'
--	0	POA_DETAILS			AHPPK1195C 	3				CLIENTS
CREATE PROCEDURE [citrus_usr].[pr_select_poa_details](@pa_id numeric
                                      ,@pa_action varchar(25)
                                      ,@pa_search1 varchar(50)
                                      ,@pa_search2 varchar(50)
									,@pa_search3 varchar(50)
									,@pa_search4 varchar(50)
									,@pa_search5 varchar(50)
									,@pa_search6 varchar(50)
									,@pa_search7 varchar(50)
									,@pa_out     varchar(8000) output
)
AS
BEGIN
	DECLARE @L_DPM_ID NUMERIC
	
	SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @pa_search4 AND DP_MSTR.default_dp = DP_MSTR.dpm_excsm_id AND DPM_DELETED_IND = 1
	print @L_DPM_ID
	
	IF @pa_action = 'POA_DETAILS'
	BEGIN
		 SELECT '' poam_id --poam_id
									,'' poam_ctgry --isnull(poam_ctgry,'') poam_ctgry
									,'' poam_product_cd --isnull(poam_product_cd,'0') poam_product_cd
									,isnull(dpam_sba_name,'') poam_name1
									,isnull(poam_name2,'') poam_name2
									,isnull(poam_name3,'') poam_name3
									,'' poam_title --isnull(poam_title,'') poam_title
									,'' poam_suffix --isnull(poam_suffix,'') poam_suffix
									,'' poam_fth_name --isnull(poam_fth_name,'') poam_fth_name
									,isnull(poam_adr1,'') poam_adr1
									,isnull(poam_adr2,'') poam_adr2
									,isnull(poam_adr3,'') poam_adr3
									,isnull(poam_city,'') poam_city
									,isnull(poam_state,'') poam_state
									,isnull(poam_country,'') poam_country
									,isnull(poam_zip,'') poam_zip
									,'' poam_ph1 --isnull(poam_ph1,'') poam_ph1
									,'' poam_ph2 --isnull(poam_ph2,'') poam_ph2
									,'' poam_fax -- isnull(poam_fax,'') poam_fax
									,'' poam_pan_no --isnull(poam_pan_no,'') poam_pan_no
									,'' poam_it_circle --isnull(poam_it_circle,'') poam_it_circle
									,'' poam_email --isnull(poam_email,'') poam_email
									,'' poam_Date_Of_Maturity--isnull(poam_Date_Of_Maturity,'') poam_Date_Of_Maturity
									,'' poam_dob --isnull(poam_dob,'') poam_dob
									,'' poam_sex --isnull(poam_sex,'') poam_sex
									,'' poam_Occupation -- isnull(poam_Occupation,'') poam_Occupation
									,'' poam_Life_Style --isnull(poam_Life_Style,'') poam_Life_Style
									,'' poam_Geo_Cd --isnull(poam_Geo_Cd,'') poam_Geo_Cd
									,'' poam_Edu --isnull(poam_Edu,'') poam_Edu
									,'' poam_Anninc --isnull(poam_Anninc,'') poam_Anninc
									,'' paom_nationality --isnull(paom_nationality,'') paom_nationality
								    ,'' poam_leg_status_cd --isnull(poam_leg_status_cd,'') poam_leg_status_cd
									,'' poam_Lan_Cd --isnull(poam_Lan_Cd,'') poam_Lan_Cd
									,'' poam_Staff --isnull(poam_Staff,'') poam_Staff
									,'' poam_BO_Ctgry-- isnull(subcm_clicm_id,'0') poam_BO_Ctgry								
									,'' poam_BO_Sett_Plflg --isnull(poam_BO_Sett_Plflg,'') poam_BO_Sett_Plflg
									,'' poam_RBI_Ref_No--isnull(poam_RBI_Ref_No,'') poam_RBI_Ref_No
									,'' poam_RBI_App_Dt --isnull(poam_RBI_App_Dt,'') poam_RBI_App_Dt
									,'' poam_SEBI_Regini --isnull(poam_SEBI_Regini,'') poam_SEBI_Regini
									,'' poam_Tax_Dedu_status --isnull(poam_Tax_Dedu_status,'') poam_Tax_Dedu_status
									,'' poam_Smart_Card_no --isnull(poam_Smart_Card_no,'') poam_Smart_Card_no
									,'' poam_Smart_Card_pin --isnull(poam_Smart_Card_pin,'') poam_Smart_Card_pin
									,'' poam_ECS --isnull(poam_ECS,'') poam_ECS
									,'' poam_ElecConf --isnull(poam_ElecConf,'') poam_ElecConf
									,'' poam_Dividend_Curr --isnull(poam_Dividend_Curr,'') poam_Dividend_Curr
									,'' poam_Group_Code --isnull(poam_Group_Code,'') poam_Group_Code
								--	,isnull(subcm_cd,'') poam_BOSubStatus
									,'' poam_BOSubStatus --isnull(poam_BOSubStatus , '') poam_BOSubStatus
									,'' poam_CC_ID --isnull(poam_CC_ID,'0') poam_CC_ID
									,'' poam_cm_id --isnull(poam_cm_id,'0') poam_cm_id
									,'' poam_stock_exch --isnull(poam_stock_exch,'') poam_stock_exch
									,'' poam_Conf_Waived --isnull(poam_Conf_Waived,'') poam_Conf_Waived
									,'' poam_Trading_ID --isnull(poam_Trading_ID,'0') poam_Trading_ID
									,'' poam_BO_stm_Cycle_Cd-- isnull(poam_BO_stm_Cycle_Cd,'') poam_BO_stm_Cycle_Cd
									,isnull(poam_master_id,'') poam_master_id
									,'' poam_dpm_id  --isnull(poam_dpm_id ,'0') poam_dpm_id
		       FROM poam pm 
		       --left outer join client_ctgry_mstr on   Upper(clicm_desc)  =  Upper(poam_BO_Ctgry)
         --      left outer join sub_ctgry_mstr on   Upper(SUBCM_desc) = Upper(poam_BOSubStatus) and   SUBCM_CLICM_ID = clicm_id
		       where isnull(poam_master_id,'') LIKE CASE WHEN @pa_search1 <> '' THEN '%' + @pa_search1 + '%' ELSE '%' END 
		       AND  poam_name1 + ' ' + isnull(pm.poam_name2,'') + ' '+ isnull(pm.poam_name3,'')  LIKE CASE WHEN @pa_search2 <> '' THEN '%' + @pa_search2 + '%' ELSE '%' END 
               --AND  POAM_DPM_ID 	= @L_DPM_ID	       
		       --AND  poam_pan_no LIKE CASE WHEN @pa_search3 <> '' THEN '%' + @pa_search3 + '%' ELSE '%' END 
		       --AND  poam_deleted_ind = 1
               
               
                
		      
		      
	END
	IF @pa_action = 'POA_AUTH_DETAILS'
	BEGIN
		SELECT poaam_id
								,isnull(poaam_poam_id,'0') poaam_poam_id
								,isnull(poaam_name1,'') poaam_name1
								,isnull(poaam_name2,'') poaam_name2
								,isnull(poaam_name3,'') poaam_name3
								,isnull(poaam_doc_path ,'') poaam_doc_path
		FROM poa_auth_mstr pam
		WHERE pam.poaam_poam_id = @pa_id and poaam_deleted_ind=1
		
	END
END

GO
