-- Object: PROCEDURE citrus_usr.pr_ins_upd_entm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_entm] ( @pa_id           VARCHAR(8000)  
                                 , @pa_action       VARCHAR(20)  
	                         , @pa_login_name   VARCHAR(20)  
	                         , @pa_values       VARCHAR(8000)  
	                         , @pa_chk_yn       NUMERIC  
	                         , @rowdelimiter    CHAR(4) =  '*|~*'  
	                         , @coldelimiter    CHAR(4)  = '|*~|'  
							 --, @preappflg		int
	                         , @pa_output       VARCHAR(8000)  OUTPUT  
	                         , @pa_msg          VARCHAR(8000) OUTPUT  
	                         )  
  
AS  
/*  
*********************************************************************************  
 SYSTEM         : CLASS  
 MODULE NAME    : PR_INS_UPD_ENTM  
 DESCRIPTION    : THIS PROCEDURE WILL ADD NEW VALUES TO  ENTITY_MSTR  
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR           DATE        REASON  
 -----  -------------   ----------   -------------------------------------------------  
 1.0    HARI R         04-OCT-2006   INITIAL VERSION.  
 2.0    SUKHI/TUSHAR   20-DEC-2006   SELECT UNIQUE_ID FROM BITMAT_REF_MSTR  
 3.0    SUKHI/TUSHAR   26-FEB-2007   ADDITION OF NEW FIELD: 'ENTM_CLICM_CD'  
 4.0    TUSHAR         02-apr-2007   ADD MAKER CHECKER FUNCTIONALITY  
-----------------------------------------------------------------------------------*/  
--  
BEGIN  
--  
  SET NOCOUNT ON  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  --  
  DECLARE @@t_errorstr        VARCHAR(8000)  
        , @l_cmconcm_id       BIGINT  
        , @l_concm_id         BIGINT  
        , @@l_error           BIGINT  
        , @delimeter          VARCHAR(10)  
        , @@remainingstring   VARCHAR(8000)  
        , @@currstring        VARCHAR(8000)  
        , @@remainingstring2  VARCHAR(8000)  
        , @@currstring2       VARCHAR(8000)  
        , @@foundat           INTEGER  
        , @@delimeterlength   INT  
        , @l_counter          INT  
        , @l_entm_id          NUMERIC  
        , @@l_entm_name1      VARCHAR(50)  
        , @@l_entm_name2      VARCHAR(50)  
        , @@l_entm_name3      VARCHAR(50)  
        , @@l_entm_short_name VARCHAR(50)  
        , @@l_entm_enttm_cd   VARCHAR(20)  
        , @@l_entm_parent_id  NUMERIC  
        , @@l_entm_parent_cd  VARCHAR(20)  
        , @@l_entm_clicm_cd   VARCHAR(20)  
        , @@l_enttm_desc      VARCHAR(50)  
        , @l_pa_id            NUMERIC  
        , @l_entm_name1       VARCHAR(50)  
        , @l_entm_name2       VARCHAR(50)  
        , @l_entm_name3       VARCHAR(50)  
        , @l_enttm_desc       VARCHAR(50)  
        , @l_pa_output        VARCHAR(8000)  
        , @l_clicm_id         NUMERIC  
        , @l_enttm_id         NUMERIC  
        , @l_deleted_ind      CHAR(1)  
        , @l_entmmak_id       NUMERIC   
        , @l_action           CHAR(1)  
        , @l_id                NUMERIC  
        , @l_rmks              varchar(8000)  
        , @L_EDT_DEL_ID        NUMERIC  
        , @l_bit_on            NUMERIC 
        , @l_enttm_cur_no      VARCHAR(20)
        , @l_entpm_prop_id     NUMERIC
        , @l_values            VARCHAR(500)  
  --        
  SET @l_counter   = 1  
  SET @@l_error    = 0  
  SET @@t_errorstr = ''  
  --  
  SET @delimeter        = '%'+ @rowdelimiter + '%'  
  SET @@delimeterlength = LEN(@rowdelimiter)  
  --  
  SET @@remainingstring2 = @pa_id  
  
  --  
  WHILE @@remainingstring2 <> ''  
  BEGIN  
  --  
    SET @@foundat = 0  
    SET @@foundat =  PATINDEX('%'+@delimeter+'%',@@remainingstring2)  
    --  
    IF @@FOUNDAT > 0  
    BEGIN  
      --  
      SET @@currstring2      = SUBSTRING(@@remainingstring2, 0,@@foundat)  
      SET @@remainingstring2 = SUBSTRING(@@remainingstring2, @@FOUNDAT+@@delimeterlength,LEN(@@remainingstring2)- @@foundat+@@delimeterlength)  
      --  
    END  
    ELSE  
    BEGIN  
      --  
      SET @@currstring2      = @@remainingstring2  
      SET @@remainingstring2 = ''  
      --  
    END  
    --  
    IF @@currstring2 <> ''  
    BEGIN  
    --  
      SET @l_pa_id          = CONVERT(numeric, citrus_usr.fn_splitval(@@currstring2,1)) --@@currstring2  
      SET @delimeter        = '%'+ @rowdelimiter + '%'  
      SET @@delimeterlength = len(@rowdelimiter)  
      SET @@remainingstring = @pa_values  
      --  
      WHILE @@remainingstring <> ''  
      BEGIN  
      --  
        SET @@foundat       = 0  
        SET @@foundat       =  PATINDEX('%'+@delimeter+'%',@@remainingstring)  
        --  
        IF @@foundat > 0  
        BEGIN  
        --  
          SET @@currstring      = SUBSTRING(@@remainingstring, 0,@@foundat)  
          SET @@remainingstring = SUBSTRING(@@remainingstring, @@foundat+@@delimeterlength,LEN(@@remainingstring)- @@foundat+@@delimeterlength)  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @@currstring      = @@remainingstring  
          SET @@remainingstring = ''  
        --  
        END  
        --  
        IF @@currstring <> ''  
        BEGIN  
        --  
          SET @@l_entm_name1       = citrus_usr.FN_SPLITVAL(@@currstring,1)  
          SET @@l_entm_name2       = citrus_usr.FN_SPLITVAL(@@currstring,2)  
          SET @@l_entm_name3       = citrus_usr.FN_SPLITVAL(@@currstring,3)  
          SET @@l_entm_enttm_cd    = citrus_usr.FN_SPLITVAL(@@currstring,5)  
		  SET @@l_entm_short_name  = citrus_usr.FN_SPLITVAL(@@currstring,4) 
          SET @@l_entm_parent_cd   = citrus_usr.FN_SPLITVAL(@@currstring,6)  
          SET @@l_entm_clicm_cd    = citrus_usr.FN_SPLITVAL(@@currstring,7)  
          --  
          SET @l_clicm_id = NULL  
          SET @l_enttm_id = NULL  
          --  
          SELECT @l_clicm_id = clicm.clicm_id  
                ,@l_enttm_id = enttm.enttm_id  
          FROM   client_ctgry_mstr         clicm  
                ,entity_type_mstr          enttm  
                ,enttm_clicm_mapping       entcm  
          WHERE  clicm.clicm_id          = entcm.entcm_clicm_id  
          AND    enttm.enttm_id          = entcm.entcm_enttm_id  
          AND    clicm.clicm_deleted_ind = 1  
          AND    enttm.enttm_deleted_ind = 1  
          AND    entcm.entcm_deleted_ind = 1  
          AND    clicm.clicm_cd          = @@l_entm_clicm_cd  
          AND    enttm.enttm_cd          = @@l_entm_enttm_cd  
          --  
          IF @pa_chk_yn = 0  
          BEGIN  
          --  
            IF @pa_action = 'INS'  
            BEGIN--INS  
            --  
              BEGIN TRANSACTION  
              --  
              SELECT @@l_entm_parent_id = entm_id  
              FROM   entity_mstr        WITH(NOLOCK)  
              WHERE  entm_short_name    = @@l_entm_parent_cd  
              --  
              SELECT @l_entm_id         = bitrm_bit_location  
              FROM   bitmap_ref_mstr    WITH(NOLOCK)  
              WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
              AND    bitrm_child_cd     = 'ENTITY_ID'  
              --  
              UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
              SET    bitrm_bit_location = bitrm_bit_location+1  
              WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
              AND    bitrm_child_cd     = 'ENTITY_ID'  
              --  
              INSERT INTO entity_mstr  
              (entm_id  
              ,entm_name1  
              --,entm_name2  
              --,entm_name3  
              ,entm_short_name  
              ,entm_enttm_cd  
              ,entm_clicm_cd  
              ,entm_parent_id  
              ,entm_created_by  
              ,entm_created_dt  
              ,entm_lst_upd_by  
              ,entm_lst_upd_dt  
              ,entm_deleted_ind
			  ,entm_preapproval_flg)  
              VALUES  
              (@l_entm_id  
              ,@@l_entm_name1  
              --,@@l_entm_name2  
              --,@@l_entm_name3  
              ,@@l_entm_short_name   + '_' + @@l_entm_enttm_cd
              ,@@l_entm_enttm_cd  
              ,@@l_entm_clicm_cd  
              ,@@l_entm_parent_id  
              ,@pa_login_name  
              ,getdate()  
              ,@pa_login_name  
              ,getdate()  
              ,1
			  ,0)  
              --  
              SET @@l_error = @@error  
              --  
           IF @@l_error > 0  
              BEGIN  
              --  
                SELECT  @@t_errorstr  = '#'+ISNULL(@@t_errorstr,'')+'0'+ @coldelimiter +ISNULL(@@l_entm_name1,'') + @coldelimiter + ISNULL(@@l_entm_name2,'')+@coldelimiter+ISNULL(@@l_entm_name3,'') + @coldelimiter+ISNULL(@l_enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter    
                --  
                ROLLBACK TRANSACTION  
              --  
              END  
              ELSE  
              BEGIN  
              --
                
                SELECT  @l_pa_output          = ISNULL(CONVERT(VARCHAR,@l_entm_id),'0') + @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@coldelimiter+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                FROM    entity_mstr             entm  WITH(NOLOCK)  
                      , entity_type_mstr        enttm  WITH(NOLOCK)  
                WHERE   entm.entm_enttm_cd    = enttm.enttm_cd  
                AND     entm.entm_id          = @l_entm_id  
                AND     entm.entm_deleted_ind = 1  
                --  
                COMMIT TRANSACTION  
                --*************************************************************************           
                declare @c_sub_id cursor
                declare @l_sbum_id int
                      , @l_start_no int
                
                SET @c_sub_id = CURSOR FAST_FORWARD FOR 
				SELECT DISTINCT sbum_id,sbum_start_no
				FROM   sbu_mstr  WITH (NOLOCK)
				
				 OPEN @c_sub_id 
			     FETCH NEXT FROM @c_sub_id INTO @l_sbum_id,@l_start_no

					WHILE (@@FETCH_STATUS=0)
					BEGIN
					--
					  SELECT @l_entpm_prop_id        = entpm_prop_id 
				      FROM   entity_property_mstr      entpm 
					  WHERE  entpm.entpm_cd          = CONVERT(VARCHAR,@l_sbum_id) + '_CUR_VAL' 
				      AND    entpm_deleted_ind       = 1
					  
					  IF ISNULL(@l_entpm_prop_id,0) <> 0 
					  BEGIN 
					  --
					   
						SET @l_values  = CONVERT(VARCHAR,@l_entpm_prop_id)+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_start_no),'')+@coldelimiter+@rowdelimiter 
						
						-- 
						EXEC pr_ins_upd_entp '1', 'EDT', @pa_login_name, @l_entm_id, '', @l_values, '', @pa_chk_yn, '*|~*','|*~|','' 
					  --
				      END

					  FETCH NEXT FROM @c_sub_id INTO @l_sbum_id,@l_start_no
					--
					END
                
                
                
                SELECT @l_entpm_prop_id        = entpm_prop_id   
                FROM   entity_property_mstr      entpm  
                      ,client_ctgry_mstr         clicm  
                      ,entity_type_mstr          enttm    
                WHERE  entpm.entpm_cd          ='LC'   
                AND    entpm.entpm_clicm_id    = clicm.clicm_id  
                AND    entpm.entpm_enttm_id    = enttm.enttm_id  
                AND    enttm.enttm_cd          = @@l_entm_enttm_cd  
                AND    clicm.clicm_cd          = @@l_entm_clicm_cd  
                AND    entpm_deleted_ind       = 1  
     
                SELECT @l_enttm_cur_no = case len(convert(NUMERIC,ISNULL(enttm_cur_no,'0'))) WHEN 1 THEN  '00' +ISNULL(enttm_cur_no,'0') 
                                                                                          WHEN 2 THEN  '0'  +ISNULL(enttm_cur_no,'0')
                                                                                          ELSE ISNULL(enttm_cur_no,'0') end  
                FROM   entity_type_mstr 
                WHERE  enttm_cd          = @@l_entm_enttm_cd  
                AND    enttm_deleted_ind = 1 
                
                
                IF ISNULL(@l_entpm_prop_id,0) <> 0 AND  ISNULL(@l_enttm_cur_no,'') <> ''  
                BEGIN   
                --  
                  SET @l_values  = CONVERT(VARCHAR,@l_entpm_prop_id)+@coldelimiter+ISNULL(@l_enttm_cur_no,'')+@coldelimiter+@rowdelimiter   
                  EXEC pr_ins_upd_entp '1', 'EDT', @pa_login_name, @l_entm_id, '', @l_values, '', 0, '*|~*','|*~|',''   
                --  
                END  

                --********************************************************************************
                UPDATE entity_type_mstr SET enttm_cur_no = case len(convert(NUMERIC,ISNULL(enttm_cur_no,'0')) + 1) WHEN 1 THEN  '00' +CONVERT(VARCHAR,CONVERT(NUMERIC,ISNULL(enttm_cur_no,'0')) + 1)   
                                                                                                                   WHEN 2 THEN  '0'  +CONVERT(VARCHAR,CONVERT(NUMERIC,ISNULL(enttm_cur_no,'0')) + 1)  
                                                                                                                   ELSE convert(NUMERIC,ISNULL(enttm_cur_no,'0')) + 1 end  
                WHERE enttm_cd          = @@l_entm_enttm_cd  
                AND   enttm_deleted_ind = 1   
                  
                IF @@l_entm_enttm_cd = 'BR'  
                BEGIN  
                --  
                  SELECT @l_bit_on = bitrm_bit_location FROM bitmap_ref_mstr WHERE bitrm_child_cd = 'SUB_BROKER' AND bitrm_deleted_ind  = 1   
                  IF @l_bit_on = 1  
                  BEGIN  
                  --  
                    SET @pa_values = @@l_entm_name1 + '|*~|' + @@l_entm_name2 + '|*~|' + @@l_entm_name3 + '|*~|' + replace(@@l_entm_short_name,'_BR','_SB') + '|*~|' + 'SB' + '|*~|' + @@l_entm_enttm_cd + '|*~|' + @@l_entm_clicm_cd + '|*~|*|~*'   
                    exec pr_ins_upd_entm 1, @pa_action   , @pa_login_name , @pa_values , @pa_chk_yn , @rowdelimiter , @coldelimiter ,@pa_output ,@pa_msg    
                  --  
                  END  
                --  
                END  
              --  
              END  
            --  
            END--INS  
  
            IF @PA_ACTION = 'EDT'  
            BEGIN  
            --  
              BEGIN TRANSACTION  
              --  
              SELECT @@l_entm_parent_id = entm_id  
              FROM   entity_mstr        WITH(NOLOCK)  
              WHERE  entm_short_name    = @@l_entm_parent_cd  
              --  
              UPDATE entity_mstr          WITH(ROWLOCK)  
              SET    entm_name1           = (CASE WHEN @@l_entm_name1      <> ''   THEN @@l_entm_name1      ELSE em2.entm_name1      END)  
                    --,entm_name2           = (CASE WHEN @@l_entm_name2      <> ''   THEN @@l_entm_name2      ELSE em2.entm_name2      END)  
                    --,entm_name3           = (CASE WHEN @@l_entm_name3      <> ''   THEN @@l_entm_name3      ELSE em2.entm_name3      END)  
                    ,entm_short_name      = (CASE WHEN @@l_entm_short_name <> ''   THEN @@l_entm_short_name ELSE em2.entm_short_name END)  
                    ,entm_enttm_cd        = (CASE WHEN @@l_entm_enttm_cd   <> ''   THEN @@l_entm_enttm_cd   ELSE em2.entm_enttm_cd   END)  
                    ,entm_clicm_cd        = (CASE WHEN @@l_entm_clicm_cd   <> ''   THEN @@l_entm_clicm_cd   ELSE em2.entm_clicm_cd   END)  
                    ,entm_parent_id       = (CASE WHEN LEN(@@l_entm_parent_id) > 0 THEN @@l_entm_parent_id  ELSE em2.entm_parent_id  END)  
                    ,entm_lst_upd_by      = @pa_login_name  
                    ,entm_lst_upd_dt      = getdate()
					,entm_preapproval_flg = 0  
              FROM   entity_mstr em2  
              WHERE  em2.entm_id          = @l_pa_id  
              AND    em2.entm_deleted_ind = 1  
              --  
              SET @@l_error = @@error  
              --  
              IF @@l_error > 0  
              BEGIN  
              --  
                /*SELECT  @L_ENTM_NAME1         = ENTM_NAME1  
                      , @L_ENTM_NAME2         = ENTM_NAME2  
                      , @L_ENTM_NAME3         = ENTM_NAME3  
                      , @L_ENTTM_DESC         = ENTTM_DESC  
                FROM    ENTITY_MSTR       ENTM   WITH(NOLOCK)  
                      , ENTITY_TYPE_MSTR  ENTTM  WITH(NOLOCK)  
                WHERE   ENTM.ENTM_ENTTM_CD    = ENTTM.ENTTM_CD  
                AND     ENTM.ENTM_ID          = @PA_ID  
                AND     ENTM.ENTM_DELETED_IND = 1*/  
                SELECT  @@t_errorstr          = '#'+ISNULL(CONVERT(VARCHAR,@PA_ID),'0') + @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@coldelimiter+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                FROM    entity_mstr             entm  WITH(NOLOCK)  
                       ,entity_type_mstr        enttm WITH(NOLOCK)  
                WHERE   entm.entm_enttm_cd    = enttm.enttm_cd  
                AND     entm.entm_id          = @pa_id  
                AND     entm.entm_deleted_ind = 1  
                --  
                ROLLBACK TRANSACTION  
              --  
              END  
              ELSE  
              BEGIN  
              --  
                SELECT @l_pa_output          = ISNULL(CONVERT(VARCHAR,@pa_id),'0') + @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@coldelimiter+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@L_ENTTM_ID),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                FROM   entity_mstr             entm  WITH(NOLOCK)  
                     , entity_type_mstr        enttm WITH(NOLOCK)  
                WHERE  entm.entm_enttm_cd    = enttm.enttm_cd  
                AND    entm.entm_id          = @pa_id  
                AND    entm.entm_deleted_ind = 1  
                --  
                COMMIT TRANSACTION  
              --  
              END  
            --  
            END   --END OF EDIT  
  
            IF @pa_action = 'DEL'  
            BEGIN  
            --  
              BEGIN TRANSACTION  
              --  
              UPDATE entity_mstr      WITH(ROWLOCK)  
              SET    entm_deleted_ind = 0  
                    ,entm_lst_upd_by  = @pa_login_name  
                    ,entm_lst_upd_dt  = getdate()  
              WHERE  entm_id          = @l_pa_id  
              AND    entm_deleted_ind = 1  
              --  
              SET @@l_error = @@error  
              --  
              IF @@l_error > 0  
              BEGIN  
              --  
                SELECT  @@t_errorstr          = '#'+ISNULL(CONVERT(VARCHAR,@pa_id),'0') + @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@coldelimiter+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                FROM    entity_mstr             entm  WITH(NOLOCK)  
                      , entity_type_mstr        enttm WITH(NOLOCK)  
                WHERE  entm.entm_enttm_cd     = enttm.enttm_cd  
                AND    entm.entm_id           = @pa_id  
                AND    entm.entm_deleted_ind  = 1  
                --  
                ROLLBACK TRANSACTION  
              --  
              END  
              ELSE  
              BEGIN  
              --  
                SELECT @l_pa_output          = ISNULL(CONVERT(VARCHAR,@pa_id),'0') + @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@COLDELIMITER+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                FROM   entity_mstr             entm   WITH(NOLOCK)  
                     , entity_type_mstr        enttm  WITH(NOLOCK)  
                WHERE  entm.entm_enttm_cd    = enttm.enttm_cd  
                AND    entm.entm_id          = @pa_id  
                AND    entm.entm_deleted_ind = 0  
                --  
                COMMIT TRANSACTION  
              --  
              END  
            --  
            END   --END OF DEL  
          --  
          END  --PA_CHK_YN  
          --  
          IF @pa_chk_yn = 1 or @pa_chk_yn = 2  
          BEGIN  
          --  
            IF @pa_action = 'INS' or @pa_action = 'EDT' or @pa_action = 'DEL'  
            BEGIN--i_e_d  
            --  
              IF EXISTS(SELECT entmm.entm_id   
                        FROM   entity_mstr_mak entmm WITH (NOLOCK)  
                        WHERE  entmm.entm_deleted_ind IN (0,4,8)  
                        AND    entmm.entm_id           =  @l_pa_id  
                        )  
              BEGIN--exts  
              --  
                 BEGIN TRANSACTION  
                 --  
                   UPDATE entity_mstr_mak WITH (ROWLOCK)  
                   SET    entm_deleted_ind  = 3  
                   WHERE  entm_deleted_ind IN (0,4,8)  
                   AND    entm_id           = @l_pa_id  
                 --  
                 SET @@l_error = @@error  
                 --  
                 IF @@l_error > 0  
                 BEGIN  
                 --  
                   ROLLBACK TRANSACTION  
                 --  
                 END  
                 ELSE  
                 BEGIN  
                 --  
                   COMMIT TRANSACTION  
                 --  
                 END  
              --  
              END--exts  
              --    
                SELECT @@l_entm_parent_id = entm_id  
                FROM   entity_mstr        WITH(NOLOCK)  
                WHERE  entm_short_name    = @@l_entm_parent_cd  

              IF @pa_action = 'INS'   
              BEGIN--#1  
              --  
                BEGIN TRANSACTION  
                --  
               
                --  
                PRINT  @@l_entm_parent_id  
              
                SELECT @l_entm_id         = bitrm_bit_location  
                FROM   bitmap_ref_mstr    WITH(NOLOCK)  
                WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
                AND    bitrm_child_cd     = 'ENTITY_ID'  
                --  
                UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
                SET    bitrm_bit_location = bitrm_bit_location + 1  
                WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
                AND    bitrm_child_cd     = 'ENTITY_ID'  
                --  
                SET @@l_error = @@error  
                --  
                IF @@l_error > 0  
                BEGIN  
                --  
                  ROLLBACK TRANSACTION  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  COMMIT TRANSACTION  
          --  
                END  
              --  
              END--#1  
              --                   
              IF @PA_ACTION = 'EDT' AND EXISTS(SELECT ENTM_ID FROM ENTITY_MSTR WHERE ENTM_ID = CONVERT(NUMERIC,@l_pa_id))  
              BEGIN  
              --  
                SET @L_EDT_DEL_ID = 8  
              --  
              END  
              ELSE  
              BEGIN  
              --  
                SET @L_EDT_DEL_ID = 0  
              --  
              END  
  
              SELECT @l_entmmak_id = ISNULL(MAX(entmak_id),0) + 1   
              FROM   entity_mstr_mak WITH (NOLOCK)  
              --   
              BEGIN TRANSACTION  
              --  
              INSERT INTO entity_mstr_mak  
              (entmak_id  
              ,entm_id  
              ,entm_name1  
              --,entm_name2  
              --,entm_name3  
              ,entm_short_name  
              ,entm_enttm_cd  
              ,entm_clicm_cd  
              ,entm_parent_id  
              ,entm_created_by  
              ,entm_created_dt  
              ,entm_lst_upd_by  
              ,entm_lst_upd_dt  
              ,entm_deleted_ind  
              )  
              VALUES  
              (@l_entmmak_id  
              ,CASE @pa_action WHEN 'INS' THEN @l_entm_id  
                               WHEN 'EDT' THEN CONVERT(NUMERIC,@l_pa_id)  
                               WHEN 'DEL' THEN CONVERT(NUMERIC,@l_pa_id) END  
              ,@@l_entm_name1  
              --,@@l_entm_name2  
              --,@@l_entm_name3  
              ,@@l_entm_short_name  
              ,@@l_entm_enttm_cd  
              ,@@l_entm_clicm_cd  
              ,@@l_entm_parent_id  
              ,@pa_login_name  
              ,getdate()  
              ,@pa_login_name  
              ,getdate()  
              ,CASE @pa_action WHEN 'INS' THEN 0  
                               WHEN 'EDT' THEN @L_EDT_DEL_ID  
                               WHEN 'DEL' THEN 4 END  
               )  
               --                  
               SET @@l_error = @@ERROR  
               --  
               IF @@l_error > 0  
               BEGIN  
               --  
                 SELECT  @@t_errorstr  = '#'+ISNULL(@@t_errorstr,'')+'0'+ @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@coldelimiter+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                 FROM    entity_mstr_mak                entm   WITH(NOLOCK)  
                       , entity_type_mstr               enttm  WITH(NOLOCK)  
                 WHERE   entm.entm_enttm_cd             = enttm.enttm_cd  
                 AND     entm.entm_short_name           = @@l_entm_short_name  
                 AND     entm.entm_deleted_ind          IN(0,4,8)  
                 --  
                 ROLLBACK TRANSACTION  
               --  
               END  
               ELSE  
               BEGIN  
               --  
                 IF @pa_action='EDT' OR @pa_action='DEL' BEGIN SET @l_entm_id = @pa_id END  
                   
                 SELECT  @l_pa_output          = ISNULL(CONVERT(VARCHAR,@l_entm_id),'0') + @coldelimiter +ISNULL(entm_name1,'') + @coldelimiter + ISNULL(entm_name2,'')+@coldelimiter+ISNULL(entm_name3,'') + @coldelimiter+ISNULL(enttm_desc,'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_clicm_id),'') + @coldelimiter + ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter + ISNULL(CONVERT(VARCHAR,@@l_error),'')+@coldelimiter+@rowdelimiter  
                 FROM    entity_mstr_mak         entm  WITH(NOLOCK)  
                       , entity_type_mstr        enttm  WITH(NOLOCK)  
                 WHERE   entm.entm_enttm_cd    = enttm.enttm_cd  
                 AND     entm.entm_id          = @l_entm_id  
                 AND     entm.entm_deleted_ind in (0,4,8)  
                                 --  
 COMMIT TRANSACTION  
                 --  
                   SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END  
                 --  
                   EXEC pr_ins_upd_list @l_entm_id, @l_action,'ENTITY MSTR', @pa_login_name,'*|~*','|*~|',''   
               --  
               END  
            --  
            END--i_e_d  
              
                         
            IF @pa_action = 'APP'  
            BEGIN  
            --  
              SET @l_id     = CONVERT(numeric, citrus_usr.fn_splitval(@@currstring2,1))  
              SET @l_rmks   = CONVERT(varchar, citrus_usr.fn_splitval(@@currstring2,2))  
              --  
              SELECT @l_deleted_ind = entm_deleted_ind  
                   , @l_entm_id     = entm_id  
              FROM   entity_mstr_mak  
              WHERE  entmak_id      = CONVERT(numeric, @l_id) --CONVERT(NUMERIC,@@currstring2)  
                
              IF @l_deleted_ind = 4  
              BEGIN  
              --  
                 
                UPDATE entity_mstr_mak     WITH (ROWLOCK)  
                SET    entm_deleted_ind  = 5  
                     , entm_rmks         = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE emm.entm_rmks END  
                     , entm_lst_upd_by   = @pa_login_name  
                     , entm_lst_upd_dt   = GETDATE()  
                FROM   entity_mstr_mak     emm        
                WHERE  entm_deleted_ind  = 4  
                AND    entmak_id         = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                --  
                SET @@l_error = @@error  
                --  
                IF  @@l_error > 0  
                BEGIN  
                --  
                  SET @@t_errorstr = convert(varchar,@@l_error)  
                --  
                END  
                --  
                UPDATE entity_mstr         WITH (ROWLOCK)       
                SET    entm_deleted_ind  = 0  
                     , entm_rmks         = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE em.entm_rmks END  
                     , entm_lst_upd_by   = @pa_login_name  
                     , entm_lst_upd_dt   = GETDATE()  
                FROM   entity_mstr         em     
                WHERE  entm_deleted_ind  = 1  
                AND    entm_id           = @l_entm_id     
                --  
                SET @@l_error = @@error  
                --  
                IF  @@l_error > 0  
                BEGIN  
                --  
                  SET @@t_errorstr = convert(varchar,@@l_error)  
                  --                    
                    
                --  
                END  
              --  
              END  
              ELSE IF @l_deleted_ind = 8  
              BEGIN  
              --  
                SELECT @@l_entm_parent_id = entm_id  
                FROM   entity_mstr        WITH(NOLOCK)  
                WHERE  entm_short_name    = @@l_entm_parent_cd  
                  
                IF EXISTS(SELECT entm_id   
                          FROM entity_mstr   
                          WHERE entm_id = (SELECT entm_id   
                                           FROM   entity_mstr_mak   
                                           WHERE  entmak_id         = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)   
                                           AND    entm_deleted_ind IN (0,4,8)  
                                          )  
                         )  
                BEGIN  
                --  
                    
                    
                  UPDATE EM                       WITH(ROWLOCK)  
                  SET    EM.entm_name1          = EM2.entm_name1  
                        --,EM.entm_name2          = EM2.entm_name2  
                        --,EM.entm_name3          = EM2.entm_name3  
                        ,EM.entm_short_name     = EM2.entm_short_name  
                        ,EM.entm_enttm_cd       = EM2.entm_enttm_cd  
                        ,EM.entm_clicm_cd       = EM2.entm_clicm_cd  
                        ,EM.entm_parent_id      = EM2.entm_parent_id  
                        ,EM.entm_rmks           = (CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE EM2.entm_rmks END)    
                        ,EM.entm_lst_upd_by     = @pa_login_name  
                        ,EM.entm_lst_upd_dt     = GETDATE()  
                  FROM   entity_mstr_mak          EM2  
                        ,entity_mstr              EM    
                  WHERE  EM2.entm_id            = @l_entm_id     
                  AND    EM2.entm_deleted_ind   = 8  
                  AND    EM.entm_id             = @l_entm_id     
                  AND    EM2.entmak_id          = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                  --  
                  SET @@l_error = @@error  
                  --  
                  IF  @@l_error > 0  
                  BEGIN  
                  --  
                    SET @@t_errorstr = convert(varchar,@@l_error)  
                    --                    
                      
                  --  
                  END  
                  --  
                  UPDATE entity_mstr_mak      WITH (ROWLOCK)        
                  SET    entm_deleted_ind   = 9  
                       , entm_rmks          = (CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE emm.entm_rmks END)   
                       , entm_lst_upd_by    = @pa_login_name  
                       , entm_lst_upd_dt    = GETDATE()  
                  FROM   entity_mstr_mak      emm       
                  WHERE  entm_deleted_ind   = 8  
                  AND    entmak_id          = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                  --                      
                  SET @@l_error = @@error  
                  --  
                  IF  @@l_error > 0  
                  BEGIN  
                  --  
                    SET @@t_errorstr = convert(varchar,@@l_error)  
                    --   
                      
                  --  
                  END  
               --    
               END                   
               ELSE  
               BEGIN  
               --  
                   
                   
                 INSERT INTO entity_mstr  
                 (entm_id  
                 ,entm_name1  
                 --,entm_name2  
                 --,entm_name3  
                 ,entm_short_name  
                 ,entm_enttm_cd  
                 ,entm_clicm_cd  
                 ,entm_parent_id  
                 ,entm_created_by  
                 ,entm_created_dt  
                 ,entm_lst_upd_by  
                 ,entm_lst_upd_dt  
                 ,entm_deleted_ind  
                 ,entm_rmks  
                 )  
                 SELECT entmm.entm_id  
                      , entmm.entm_name1  
                      --, entmm.entm_name2  
                      --, entmm.entm_name3  
                      , entmm.entm_short_name  
                      , entmm.entm_enttm_cd  
                      , entmm.entm_clicm_cd  
                      , entmm.entm_parent_id  
                      , entmm.entm_created_by  
                      , entmm.entm_created_dt  
                      , @pa_login_name  
                      , GETDATE()  
                      , 1  
                      , CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE entmm.entm_rmks END  
                 FROM  entity_mstr_mak          entmm  
                 WHERE entmm.entmak_id        = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                 AND   entmm.entm_deleted_ind = 8  
                 --  
                 SET @@l_error = @@error  
                 --  
                 IF  @@l_error > 0  
                 BEGIN  
                 --  
                   SET @@t_errorstr = convert(varchar,@@l_error)  
                   --                    
                    
                 --  
                 END  
                 --  
                 UPDATE entity_mstr_mak     WITH (ROWLOCK)          
                 SET    entm_deleted_ind  = 1  
                      , entm_rmks         = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE emm.entm_rmks END  
                      , entm_lst_upd_by   = @pa_login_name  
                      , entm_lst_upd_dt   = GETDATE()  
                 FROM   entity_mstr_mak     emm       
                 WHERE  entm_deleted_ind  = 8  
                 AND    entmak_id         = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                 --  
                 SET @@l_error = @@error  
                 --  
                 IF  @@l_error > 0  
                 BEGIN  
                 --  
                   SET @@t_errorstr = convert(varchar,@@l_error)  
                   --  
                     
                 --  
                 END  
               --  
               END  
                 
              --  
              END   
              ELSE IF @l_deleted_ind = 0  
              BEGIN  
              --  
                  
                --  
                INSERT INTO entity_mstr  
                (entm_id  
                ,entm_name1  
                --,entm_name2  
                --,entm_name3  
                ,entm_short_name  
                ,entm_enttm_cd  
                ,entm_clicm_cd  
                ,entm_parent_id  
                ,entm_created_by  
                ,entm_created_dt  
                ,entm_lst_upd_by  
                ,entm_lst_upd_dt  
                ,entm_deleted_ind  
                ,entm_rmks  
                )  
                SELECT entmm.entm_id  
                     , entmm.entm_name1  
                     --, entmm.entm_name2  
                     --, entmm.entm_name3  
                     , entmm.entm_short_name  
                     , entmm.entm_enttm_cd  
                     , entmm.entm_clicm_cd  
                     , entmm.entm_parent_id  
                     , entmm.entm_created_by  
                     , entmm.entm_created_dt  
                     , @pa_login_name  
                     , GETDATE()  
                     , 1   
                     , CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE entmm.entm_rmks END  
                 FROM  entity_mstr_mak          entmm  
                 WHERE entmm.entmak_id        = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                 AND   entmm.entm_deleted_ind = 0  
                 --  
                 SET @@l_error = @@error  
                 --  
                 IF  @@l_error > 0  
                 BEGIN  
                 --  
                   SET @@t_errorstr = convert(varchar,@@l_error)  
                   --                    
                     
                 --  
                 END  
                 --                   
                 UPDATE entity_mstr_mak      WITH (ROWLOCK)          
                 SET    entm_deleted_ind   = 1  
                      , entm_rmks          = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE emm.entm_rmks END  
                      , entm_lst_upd_by    = @pa_login_name  
                      , entm_lst_upd_dt    = GETDATE()  
                 FROM   entity_mstr_mak      emm         
                 WHERE  entm_deleted_ind   = 0  
                 AND    entmak_id          = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
                 --  
                 SET @@l_error = @@error  
                 --  
                 IF @@l_error > 0  
                 BEGIN  
                 --  
                    
                   --  
                   SET @@t_errorstr = convert(varchar,@@l_error)  
                    
                 --  
                 END  
              --  
              END  
              --move to pr_app_client  
              --EXEC pr_ins_upd_list @l_entm_id, 'A','ENTITY MSTR', @pa_login_name,'*|~*','|*~|',''   
            --  
            END  
            ELSE IF @pa_action = 'REJ'  
            BEGIN  
            --  
              SET @l_id     = CONVERT(numeric, citrus_usr.fn_splitval(@@currstring2,1))  
              SET @l_rmks   = CONVERT(varchar, citrus_usr.fn_splitval(@@currstring2,2))  
              --  
               
              --  
              UPDATE entity_mstr_mak     WITH (ROWLOCK)          
              SET    entm_deleted_ind  = 3  
                   , entm_rmks         = (CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE emm.entm_rmks END)   
                   , entm_lst_upd_by   = @pa_login_name  
                   , entm_lst_upd_dt   = GETDATE()  
              FROM   entity_mstr_mak     emm       
              WHERE  entm_deleted_ind IN (0,4,8)  
              AND    entmak_id         = CONVERT(numeric, @l_id) --CONVERT(numeric,@@currstring2)  
              --  
              SET @@l_error = @@error  
              --  
              IF @@l_error > 0  
              BEGIN  
              --  
                SET @@t_errorstr = convert(varchar,@@l_error)  
                --  
                  
              --  
              END  
            --  
            END  
          --  
          END  
        --  
        END  
        --  
        IF @@t_errorstr<>''  
        BEGIN  
        --  
          SET @pa_msg    = @@t_errorstr  
          SET @pa_output = @@t_errorstr--@L_PA_OUTPUT  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @pa_output = @l_pa_output  
          SET @pa_msg    = @l_pa_output--@@T_ERRORSTR  
        --  
        END  
      --  
      END  
      --  
    END  
    --  
  END  
--  
END

GO
