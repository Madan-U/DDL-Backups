-- Object: PROCEDURE citrus_usr.pr_select_blacm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--alter table BLACKLISTED_CLIENT_MSTR alter column BLACM_NAME_OF_SCRIPT varchar(1000)
CREATE procedure [citrus_usr].[pr_select_blacm](@pa_id numeric
                                ,@pa_action varchar(50)
                                ,@pa_search_c1  varchar(50)
                                ,@pa_search_c2  varchar(50)
                                ,@pa_search_c3  varchar(50)
                                ,@pa_search_c4  varchar(50)
                                ,@pa_search_c5  varchar(50)
                                ,@pa_search_c6  varchar(50)
                                ,@pa_search_c7  varchar(50)
                                ,@pa_search_c8  varchar(50)
                                ,@pa_search_c9  varchar(50)
                                ,@pa_search_c10 varchar(50)
                                ,@pa_login_name varchar(50)
								,@pa_ref_cur  varchar(100) output
                                )
as
begin
--
  if @pa_action = 'BLACM_SEARCH'
  begin
  --
    SELECT BLACM_ID,BLACM_FIRST_NM
			,BLACM_MIDDLE_NM
			,BLACM_LAST_NM
			,BLACM_ENTITY_TYPE
			,BLACM_PAN
			FROM BLACKLISTED_CLIENT_MSTR
			WHERE BLACM_FIRST_NM LIKE CASE WHEN  @pa_search_c1 <> '' THEN @pa_search_c1+'%' ELSE '%' END 
			AND BLACM_MIDDLE_NM LIKE CASE WHEN  @pa_search_c2 <> '' THEN @pa_search_c2+'%' ELSE '%' END 
			AND BLACM_LAST_NM LIKE CASE WHEN  @pa_search_c3 <> '' THEN @pa_search_c3+'%' ELSE '%' END 
			AND BLACM_PAN LIKE CASE WHEN  @pa_search_c4 <> '' THEN @pa_search_c4+'%' ELSE '%' END 
			AND BLACM_DELETED_IND = 1
  --
  end
  ELSE if @pa_action = 'BLACM_MAIN_SELECT'
  begin
  --
    SELECT BLACM_ID
			,BLACM_SALUTATION
			,BLACM_FIRST_NM
			,BLACM_MIDDLE_NM
			,BLACM_LAST_NM
			,BLACM_SUFFIX
			,BLACM_ENTITY_TYPE
			,BLACM_PAN
			,BLACM_ADR_1
			,BLACM_ADR_2
			,BLACM_ADR_3
			,BLACM_CITY
			,BLACM_STATE
			,BLACM_COUNTRY
			,BLACM_PIN
			,BLACM_RES_NO
			,BLACM_OFF_NO
			,BLACM_MOB
			,convert(varchar(11),BLACM_DT_OF_ORD,103) BLACM_DT_OF_ORD
			,BLACM_ORD_ISS_AUTH
			,BLACM_ORD_REF
			,BLACM_BAN_PERIOD
			,BLACM_ORD_DESC
			,BLACM_RMKS
			,BLACM_MAPIN
			,BLACM_PASSPORT_NO
			,BLACM_VOTERID_NO
			,BLACM_REGS_NO
			,BLACM_OTH_UNIQ_IDTY
			,convert(varchar(11),BLACM_BAN_FRM_DT,103) BLACM_BAN_FRM_DT
			,convert(varchar(11),BLACM_BAN_TO_DT,103) BLACM_BAN_TO_DT
			,citrus_usr.fn_splitval(BLACM_NAME_OF_SCRIPT,1) [BSE_BLACM_NAME_OF_SCRIPT]
            ,citrus_usr.fn_splitval(BLACM_NAME_OF_SCRIPT,2) [NSE_BLACM_NAME_OF_SCRIPT]
			,BLACM_REVOKED_STATUS
			,convert(varchar(11),BLACM_RVK_ORD_DT,103) BLACM_RVK_ORD_DT
			,BLACM_RVK_ORD_ISS_AUTH
			,BLACM_RVK_ORD_REF
			,BLACM_RVK_ORD_DESC
			,BLACM_RVK_RMKS
			,convert(varchar(11),BLACM_ORD_EXP_DATE,103) BLACM_ORD_EXP_DATE
			,BLACM_PENALTIY_LVLD
				FROM BLACKLISTED_CLIENT_MSTR
			WHERE BLACM_ID = @PA_ID
			AND BLACM_DELETED_IND = 1
  --
  end
  else if @pa_action = 'BLACM_DIR_SELECT'
  begin
  --
    SELECT BLADM_ID
			,BLADM_BLACM_ID
			,BLADM_SALUTATION
			,BLADM_FIRST_NM
			,BLADM_MIDDLE_NM
			,BLADM_LAST_NM
			,BLADM_SUFFIX
			,BLADM_PAN
			,BLADM_ADR_1
			,BLADM_ADR_2
			,BLADM_ADR_3
			,BLADM_CITY
			,BLADM_STATE
			,BLADM_COUNTRY
			,BLADM_PIN
			,BLADM_RES_NO
			,BLADM_OFF_NO
			,BLADM_MOB
			,BLADM_RMKS
    FROM BLACM_DIR_MSTR
    WHERE BLADM_BLACM_ID = @pa_id
    AND   BLADM_DELETED_IND = 1
  --
  end
  else if @pa_action = 'BLACM_BANK_SELECT'
  begin
  --
      SELECT BLABD_ID
					,BLABD_BLACM_ID
					,BLABD_BANK_NAME
					,BLABD_BRANCH_NAME
					,BLABD_AC_NO
					,BLABD_AC_TYPE
						FROM BLACM_BANK_DETAILS
      WHERE BLABD_BLACM_ID = @pa_id
      AND   BLABD_DELETED_IND = 1
  --
  end
  else if @pa_action = 'BLACM_DP_SELECT'
  begin
  --
      SELECT BLADD_ID
					,BLADD_BLACM_ID
					,BLADD_DP_NAME
					,BLADD_DPID
					,BLADD_DP_AC_NO

      FROM BLACM_DP_DETAILS
      WHERE BLADD_BLACM_ID = @pa_id
      AND   BLADD_DELETED_IND = 1
  --
  end
  
  
  
--
end

GO
