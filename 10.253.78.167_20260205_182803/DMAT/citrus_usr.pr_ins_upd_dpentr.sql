-- Object: PROCEDURE citrus_usr.pr_ins_upd_dpentr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin transaction
--pr_ins_upd_dpentr '101','','HO',101,'1|*~|4|*~|IN300175|*~|IN30017510000004|*~|21/06/2008|*~|HO|*~|HO|*~|BR|*~|TJRA|*~|A*|~*',0,'*|~*','|*~|','' 
--	101		HO	101	1|*~|4|*~|IN300175|*~|IN30017510000004|*~|21/06/2008|*~|HO|*~|HO|*~|BR|*~|TJRA|*~|A*|~*	0	*|~*	|*~|	
--select * from entity_relationship where entr_sba= '10000004'
--delete from entity_relationship where entr_sba= '10000004'
--rollback transaction

CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_dpentr]
								  (
								   @pa_id             varchar(8000)
                                  ,@pa_action         varchar(20)
                                  ,@pa_login_name     varchar(20)
                                  ,@pa_crn_no         numeric
                                  ,@pa_values         varchar(max)
                                  ,@pa_chk_yn         numeric
                                  ,@rowdelimiter      char(4) = '*|~*'
                                  ,@coldelimiter      char(4) = '|*~|'
                                  ,@pa_msg            varchar(8000) output
                                  )
AS
 /*
 ********************************************************************************
 system          : Citrus
 module name     : pr_ins_upd_dpentr
 description     : this procedure will add new values to  entity relationship
 copyright(c)    : Marketplace Technologies Pvt.Ltd
 version history :
 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   ---------------------------------------------
 1.0    Sukhvinder      20-08-2007   initial version.
 ---------------------------------------------------------------------------------
 *********************************************************************************
 */
 --
 DECLARE @totalfld   int
       , @l_cnt      int
       , @l_counter  int
       , @l_val1     varchar(20)
       , @l_val2     varchar(50)
 --
 DECLARE @t_entem TABLE(enttm_cd  varchar(20)
                       ,col_name  varchar(50)
                       ,value     varchar(25)
                       )
 --                      
 DECLARE @t_abc   TABLE(colname   varchar(25)
                       ,coldesc   varchar(50)
                       )
 --
 SET @totalfld   = 0
 SET @l_cnt      = 1
 SET @l_counter  = 0
 --
 INSERT INTO @t_entem
 ( enttm_cd
 , col_name
 , value
 )
 SELECT ISNULL(entem_enttm_cd, '|*~|') enttm_cd
      , entem_entr_col_name  col_name
      , '0'                  value
 FROM   enttm_entr_mapping  with (nolock)
 WHERE  entem_deleted_ind  = 1
 ORDER BY 1 DESC
--
BEGIN
--
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  --
  SET nocount on
  --
  DECLARE @l_errorstr           varchar(8000)
         ,@delimeter            varchar(10)
         ,@delimeter1           varchar(10)
         ,@delimeterlength      int
         ,@delimeterlength1     int
         ,@delimeterlength_id   int
         ,@remainingstring      varchar(8000)
         ,@remainingstring1     varchar(8000)
         ,@remainingstring_id   varchar(8000)
         ,@foundat_id           integer
         ,@foundat              integer
         ,@foundat1             integer
         ,@currstring           varchar(8000)
         ,@currstring1          varchar(8000)
         ,@currstring_id        varchar(8000)
         ,@l_entr_crn_no        numeric
         ,@l_comp_id            varchar(10)
         ,@l_excsm_id           varchar(10)
         ,@l_accountno          varchar(25)
         ,@l_subaccountno       varchar(25)
         ,@l_from_dt            datetime
         ,@l_prev_from_dt       datetime
         ,@l_next_from_dt       datetime
         ,@l_ho                 numeric
         ,@l_re                 numeric
         ,@l_ar                 numeric
         ,@l_br                 numeric
         ,@l_sb                 numeric
         ,@l_dl                 numeric
         ,@l_rm                 numeric
         ,@l_dummy1             numeric
         ,@l_dummy2             numeric
         ,@l_dummy3             numeric
         ,@l_dummy4             numeric
         ,@l_dummy5             numeric
         ,@l_dummy6             numeric
         ,@l_dummy7             numeric
         ,@l_dummy8             numeric
         ,@l_dummy9             numeric
         ,@l_dummy10            numeric
         ,@l_action_type        varchar(2)
         ,@c_cursor             cursor
         ,@l_entname            varchar(25)
         ,@l_entval             varchar(25)
         ,@l_ent_id             numeric
         ,@l_error              bigint
         ,@l_exists_flg         int
         ,@l_deleted_ind        int 
         ,@l_entr_id            int
         ,@l_crn_no             varchar(10)
         ,@l_action             char(4)
         ,@l_edt_del_id         numeric
         ,@@l_excpm_id          numeric  
         ,@l_product            VARCHAR(20)
  --
  SET @l_crn_no            = convert(varchar, @pa_crn_no)
  SET @delimeter1          = '%'+@rowdelimiter+'%'
  SET @delimeterlength1    = 4
  SET @delimeterlength_id  = 4
  SET @remainingstring1    = @pa_values
  SET @remainingstring_id  = @pa_id
  SET @l_errorstr          = ''  
  SET @l_product           = '01' 
  SET nocount on
  --
  WHILE @remainingstring1 <> ''
  BEGIN--#01 
  --
    SET @foundat1       = 0
    SET @currstring1    = ''
    SET @foundat1       =  patindex('%'+@delimeter1+'%',@remainingstring1)
    --
    IF @foundat1 > 0
    BEGIN
    --
      SET @currstring1        = substring(@remainingstring1, 0, @foundat1)
      SET @remainingstring1   = substring(@remainingstring1, @foundat1+@delimeterlength1, len(@remainingstring1)- @foundat1+@delimeterlength1)
    --
    END
    ELSE
    BEGIN
    --
      SET @currstring1        = @remainingstring1
      SET @remainingstring1   = ''
    --
    END

    IF @currstring1 <> ''
    BEGIN--#02
    --
      SET @delimeter           = '%'+@coldelimiter+'%'
      SET @delimeterlength    = 4
      SET @remainingstring    = @currstring1
      SET @foundat            = 0
      set @l_counter  = 0
      --
      WHILE @remainingstring <> ''
      BEGIN --#03
      --
        SET @foundat           =  patindex('%'+@delimeter+'%',@remainingstring)
        --
        IF @foundat > 0
        BEGIN--1
        --
          SET @currstring      = substring(@remainingstring, 0,@foundat)
          SET @remainingstring = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)
          SET @l_counter       = @l_counter + 1
        --
        END  --1
        ELSE
        BEGIN--2
        --
          SET @currstring      = @remainingstring
          SET @remainingstring = ''
        --
        END  --2
      --
      END --#03
      --
      SET @totalfld            = 0 
      SET @totalfld            = @l_counter
      SET @l_counter           = 6
      SET @delimeter           = '%'+ @rowdelimiter + '%'
      SET @delimeterlength     = len(@rowdelimiter)
      SET @remainingstring     = @currstring1 --@pa_values 
      --
      WHILE @remainingstring  <> ''
      BEGIN--04
      --
        SET @foundat           = 0
        SET @foundat           =  PATINDEX('%'+@delimeter+'%',@remainingstring)
        --
        IF @foundat > 0
        BEGIN
        --
          SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)
          SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)
        --
        END
        ELSE
        BEGIN
        --
          SET @currstring      = @remainingstring
          SET @remainingstring = ''
        --
        END
        --
        IF @currstring <> ''
        BEGIN--#05
        --
          WHILE @l_counter <= @totalfld
          BEGIN--#06
          --
            IF @l_cnt = 1
            BEGIN
            --
              SET @l_val1  = citrus_usr.fn_splitval(@currstring,@l_counter)
              SET @l_cnt   = @l_cnt + 1
            --
            END
            ELSE
            BEGIN
            --
              SET @l_val2  =  citrus_usr.fn_splitval(@currstring,@l_counter)
              --
              INSERT INTO @t_abc VALUES(convert(varchar(25), @l_val1)
                                       ,convert(varchar(50), @l_val2)
                                       )
              --
              SET @l_cnt   = 1
            --
            END
            --
            SET @l_counter = @l_counter + 1
          --
          END--#06
        --
        END --#05
        --
        SET @delimeter        = '%'+ @rowdelimiter + '%'
        SET @delimeterlength = len(@rowdelimiter)
        SET @remainingstring = @currstring1--@pa_values
        --
        WHILE @remainingstring <> ''
        BEGIN--#07
        --**--
          SET @foundat = 0
          SET @foundat =  patindex('%'+@delimeter+'%',@remainingstring)
          --
          IF @foundat > 0
          BEGIN
          --
            SET @currstring      = substring(@remainingstring, 0,@foundat)
            SET @remainingstring = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)
          --
          END
          ELSE
          BEGIN
          --
            SET @currstring      = @remainingstring
            SET @remainingstring = ''
          --
          END
          --
          IF @currstring <> ''
          BEGIN--@currstring<>''
          --
            SET @l_comp_id       = citrus_usr.fn_splitval(@currstring,1)
            SET @l_excsm_id      = citrus_usr.fn_splitval(@currstring,2)
            SET @l_accountno     = citrus_usr.fn_splitval(@currstring,3)
            SET @l_subaccountno  = citrus_usr.fn_splitval(@currstring,4)
            SET @l_from_dt       = convert(datetime, citrus_usr.fn_splitval(@currstring, 5), 103)
            SET @l_action_type   = citrus_usr.fn_splitval(@currstring, @totalfld+1)
            --
            SELECT @@L_EXCPM_ID    = EXCPM_ID 
            FROM   EXCSM_PROD_MSTR
                  ,PRODUCT_MSTR 
            WHERE  EXCPM_EXCSM_ID  = @l_excsm_id      
            AND    PROM_ID         = EXCPM_PROM_ID
            AND    PROM_CD         = @l_product           

            DECLARE @l_chk_in  char(2)
            --
            SET @l_chk_in              = LEFT(@l_subaccountno,2)
            --
            IF rtrim(ltrim(@l_chk_in)) = 'IN' 
            BEGIN
            --
             SET @l_subaccountno       = SUBSTRING(@l_subaccountno,9,LEN(@l_subaccountno)-8)
            --
            END
            --
            IF @pa_chk_yn = 0
            BEGIN
            --
              SELECT @l_accountno       = dpam_acct_no
              FROM   dp_acct_mstr         WITH (NOLOCK)
              WHERE  dpam_crn_no        = @pa_crn_no
              AND    dpam_sba_no        = @l_subaccountno
              AND    dpam_deleted_ind   = 1
            --  
            END
            ELSE
            BEGIN
            --
              IF EXISTS(SELECT  dpam_acct_no
              FROM   dp_acct_mstr         WITH (NOLOCK)
              WHERE  dpam_crn_no        = @pa_crn_no
              AND    dpam_sba_no        = @l_subaccountno
              AND    dpam_deleted_ind   = 1)
              BEGIN
              --
                SELECT @l_accountno       = dpam_acct_no
                FROM   dp_acct_mstr         WITH (NOLOCK)
                WHERE  dpam_crn_no        = @pa_crn_no
                AND    dpam_sba_no        = @l_subaccountno
                AND    dpam_deleted_ind   = 1
            	
              --
              END
              ELSE
    		  BEGIN
			  --
                  SELECT @l_accountno       = dpam_acct_no
				  FROM   dp_acct_mstr_mak     WITH (NOLOCK)
				  WHERE  dpam_crn_no        = @pa_crn_no
				  AND    dpam_sba_no        = @l_subaccountno
				  AND    dpam_deleted_ind   = 0
			  --
			  END
 
            --
            END
            --
            IF @l_action_type <> 'Q'
            BEGIN--N_Q
            --
              --SET @c_cursor      = NULL
              --
              SET @c_cursor      = CURSOR fast_forward FOR SELECT colname, coldesc FROM @t_abc ORDER BY 1 DESC
              --
              OPEN @c_cursor
              --
              FETCH next FROM @c_cursor INTO @l_entname, @l_entval
              --
              WHILE @@fetch_status      = 0
              BEGIN --#cursor
              --
                SELECT @l_ent_id        = entm_id
                FROM   entity_mstr        with (nolock)
                WHERE  entm_short_name  = @l_entval
                AND    entm_deleted_ind = 1
                --
                IF ISNULL(@l_ent_id,0) = 0
                BEGIN
                --
                  SET @l_ent_id        = 0
                --
                END
                --
                UPDATE @t_entem  
                SET    value     =  convert(varchar(25), @l_ent_id)
                WHERE  enttm_cd  =  convert(varchar(25),@l_entname)
                --
                SET @l_ent_id   = NULL
                --
                FETCH next FROM @c_cursor INTO @l_entname,@l_entval
              --
              END  --#cursor
              --
              CLOSE @c_cursor
              DEALLOCATE @c_cursor
              --
              SELECT @l_ho      = value FROM @t_entem WHERE col_name = 'ENTR_HO'
              SELECT @l_re      = value FROM @t_entem WHERE col_name = 'ENTR_RE'
              SELECT @l_ar      = value FROM @t_entem WHERE col_name = 'ENTR_AR'
              SELECT @l_br      = value FROM @t_entem WHERE col_name = 'ENTR_BR'
              SELECT @l_sb      = value FROM @t_entem WHERE col_name = 'ENTR_SB'
              SELECT @l_dl      = value FROM @t_entem WHERE col_name = 'ENTR_DL'
              SELECT @l_rm      = value FROM @t_entem WHERE col_name = 'ENTR_RM'
              SELECT @l_dummy1  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY1'
              SELECT @l_dummy2  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY2'
              SELECT @l_dummy3  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY3'
              SELECT @l_dummy4  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY4'
              SELECT @l_dummy5  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY5'
              SELECT @l_dummy6  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY6'
              SELECT @l_dummy7  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY7'
              SELECT @l_dummy8  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY8'
              SELECT @l_dummy9  = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY9'
              SELECT @l_dummy10 = value FROM @t_entem WHERE col_name = 'ENTR_DUMMY10'
              --
              
              
              SELECT @l_prev_from_dt = max(entr_from_dt)
              FROM   entity_relationship   with (nolock)
              WHERE  entr_crn_no         = @pa_crn_no
              AND    entr_acct_no        = @l_accountno
              AND    entr_sba            =@l_subaccountno
              AND    convert(datetime, entr_from_dt, 103) < convert(datetime,@l_from_dt, 103)
              AND    entr_deleted_ind    = 1
              --
              IF rtrim(ltrim(@l_prev_from_dt)) IS NULL
              BEGIN
              --
                SET @l_prev_from_dt  = NULL
              --
              END
              --
              SELECT @l_next_from_dt = MIN(entr_from_dt)
              FROM   entity_relationship  WITH (NOLOCK)
              WHERE  entr_crn_no        = @pa_crn_no
              AND    entr_acct_no       = @l_accountno
              AND    entr_sba           = @l_subaccountno
              AND    convert(datetime, entr_from_dt, 103)  <  convert(datetime, @l_from_dt, 103)
              AND    entr_deleted_ind = 1
              --
              IF rtrim(ltrim(@l_next_from_dt)) IS NULL
              BEGIN
              --
                SET  @l_next_from_dt = NULL
              --
              END
              --
              /*
              DECLARE @l_chk_in   char(2)
              --
              SET @l_chk_in = LEFT(@l_subaccountno,2)
              --
              IF rtrim(ltrim(@l_chk_in)) = 'IN' 
              BEGIN
              --
               SET @l_subaccountno = convert(varchar(20), right(@l_subaccountno,len(@l_subaccountno)-8)) 
              --
              END
              */
              --
              IF @pa_chk_yn = 0
              BEGIN--@pa_chk_yn = 0
              --##--   
                IF ISNULL(@pa_action,'') = ''
                BEGIN--null_0
                --
                  IF @l_action_type = 'E'
                  BEGIN--e_0
                  --
                    SELECT @l_exists_flg        = count(*)
                    FROM   entity_relationship    WITH (NOLOCK)
                    WHERE  entr_crn_no          = @pa_crn_no
                    AND    entr_acct_no         = @l_accountno
                    AND    entr_sba             = @l_subaccountno
                    AND    entr_from_dt  LIKE  convert(varchar(11), @l_from_dt) + '%'
                    AND    entr_deleted_ind     = 1
                    --
                    IF @l_exists_flg > 0
                    BEGIN--exists
                    --
                      BEGIN TRANSACTION
                      --
                      UPDATE entity_relationship   WITH (ROWLOCK)
                      SET    entr_ho             = @l_ho
                           , entr_re             = @l_re
                           , entr_ar             = @l_ar
                           , entr_br             = @l_br
                           , entr_sb             = @l_sb
                           , entr_dl             = @l_dl
                           , entr_rm             = @l_rm
                           , entr_dummy1         = @l_dummy1
                           , entr_dummy2         = @l_dummy2
                           , entr_dummy3         = @l_dummy3
                           , entr_dummy4         = @l_dummy4
                           , entr_dummy5         = @l_dummy5
                           , entr_dummy6         = @l_dummy6
                           , entr_dummy7         = @l_dummy7
                           , entr_dummy8         = @l_dummy8
                           , entr_dummy9         = @l_dummy9
                           , entr_dummy10        = @l_dummy10
                           , entr_lst_upd_by     = @pa_login_name
                           , entr_lst_upd_dt     = GETDATE()
                      WHERE  entr_crn_no         = @pa_crn_no
                      AND    entr_acct_no        = @l_accountno
                      AND    entr_sba            = @l_subaccountno
                      AND    entr_excpm_id       = @@l_excpm_id
                      AND    entr_from_dt LIKE   convert(varchar(11), @l_from_dt) + '%'
                      AND    entr_deleted_ind    = 1
                      --
                      SET @l_error = @@ERROR
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      ELSE
                      BEGIN
                      --
                        SET @l_errorstr = 'entity relationship ruccessfuly inserted/edited'+@ROWDELIMITER
                        --
                        COMMIT TRANSACTION
                      --
                      END
                    --
                    END  --exists
                    ELSE
                    BEGIN--NOT exists
                    --
                      SET @l_action_type = 'A'
                    --
                    END--NOT exists
                  --
                  END--e_0
                  --
                  IF @l_action_type     = 'A'
                  BEGIN --a_0
                  --
                    BEGIN TRANSACTION
                    --
                    IF (@l_prev_from_dt is NULL) AND (@l_next_from_dt is NULL)
                    BEGIN--##1
                    --
                      INSERT INTO entity_relationship
                      (entr_crn_no
                      ,entr_acct_no
                      ,entr_sba
                      ,entr_excpm_id
                      ,entr_ho
                      ,entr_re
                      ,entr_ar
                      ,entr_br
                      ,entr_sb
                      ,entr_dl
                      ,entr_rm
                      ,entr_dummy1
                      ,entr_dummy2
                      ,entr_dummy3
                      ,entr_dummy4
                      ,entr_dummy5
                      ,entr_dummy6
                      ,entr_dummy7
                      ,entr_dummy8
                      ,entr_dummy9
                      ,entr_dummy10
                      ,entr_FROM_dt
                      ,entr_created_by
                      ,entr_created_dt
                      ,entr_lst_upd_by
                      ,entr_lst_upd_dt
                      ,entr_deleted_ind
                      )
                      VALUES
                      (@pa_crn_no
                      ,@l_accountno
                      ,@l_subaccountno
                      ,@@l_excpm_id
                      ,@l_ho
                      ,@l_re
                      ,@l_ar
                      ,@l_br
                      ,@l_sb
                      ,@l_dl
                      ,@l_rm
                      ,@l_dummy1
                      ,@l_dummy2
                      ,@l_dummy3
                      ,@l_dummy4
                      ,@l_dummy5
                      ,@l_dummy6
                      ,@l_dummy7
                      ,@l_dummy8
                      ,@l_dummy9
                      ,@l_dummy10
                      ,convert(datetime, @l_from_dt, 103)
                      ,@pa_login_name
                      ,GETDATE()
                      ,@pa_login_name
                      ,GETDATE()
                      ,1
                      )
                      --
                      SET @l_error = @@error
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      ELSE
                      BEGIN
                      --
                        SET @l_errorstr = 'entity relationship ruccessfuly inserted/edited'+@ROWDELIMITER
                        --
                        COMMIT TRANSACTION
                      --
                      END
                    --
                    END   --##1
                    ELSE IF (@l_prev_from_dt is NOT NULL) AND (@l_next_from_dt is NOT NULL)
                    BEGIN --##2
                    --
                      UPDATE entity_relationship  with (rowlock)
                      SET    entr_to_dt         = dateadd(dd, -1, @l_from_dt)
                      WHERE  entr_crn_no        = @pa_crn_no
                      AND    entr_acct_no       = @l_accountno
                      AND    entr_sba           = @l_subaccountno
                      AND    entr_excpm_id      = @@l_excpm_id
                      AND    entr_FROM_dt       = @l_prev_from_dt
                      AND    entr_deleted_ind   = 1
                      --
                      SET @l_error = @@ERROR
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      --
                      INSERT INTO entity_relationship
                      (entr_crn_no
                      ,entr_acct_no
                      ,entr_sba
                      ,entr_excpm_id
                      ,entr_ho
                      ,entr_re
                      ,entr_ar
                      ,entr_br
                      ,entr_sb
                      ,entr_dl
                      ,entr_rm
                      ,entr_dummy1
                      ,entr_dummy2
                      ,entr_dummy3
                      ,entr_dummy4
                      ,entr_dummy5
                      ,entr_dummy6
                      ,entr_dummy7
                      ,entr_dummy8
                      ,entr_dummy9
                      ,entr_dummy10
                      ,entr_from_dt
                      ,entr_to_dt
                      ,entr_created_by
                      ,entr_created_dt
                      ,entr_lst_upd_by
                      ,entr_lst_upd_dt
                      ,entr_deleted_ind
                      )
                      VALUES
                      (@pa_crn_no
                      ,@l_accountno
                      ,@l_subaccountno
                      ,@@l_excpm_id 
                      ,@l_ho
                      ,@l_re
                      ,@l_ar
                      ,@l_br
                      ,@l_sb
                      ,@l_dl
                      ,@l_rm
                      ,@l_dummy1
                      ,@l_dummy2
                      ,@l_dummy3
                      ,@l_dummy4
                      ,@l_dummy5
                      ,@l_dummy6
                      ,@l_dummy7
                      ,@l_dummy8
                      ,@l_dummy9
                      ,@l_dummy10
                      ,convert(datetime, @l_from_dt, 103)
                      ,null--dateadd(dd, -1, @l_next_from_dt)
                      ,@pa_login_name
                      ,GETDATE()
                      ,@pa_login_name
                      ,GETDATE()
                      ,1
                      )
                      --
                      SET @l_error = @@error
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      --
                      SET @l_errorstr = 'entity relationship ruccessfuly inserted/edited'+@ROWDELIMITER
                      --
                      COMMIT TRANSACTION
                    --                      
                    END --##2
                    ELSE IF (@l_next_from_dt is NULL) --##3
                    BEGIN
                    --
                      UPDATE entity_relationship  with (rowlock)
                      SET    entr_to_dt         = dateadd(dd, -1, @l_from_dt)
                      WHERE  entr_crn_no        = @pa_crn_no
                      AND    entr_acct_no       = @l_accountno
                      AND    entr_sba           = @l_subaccountno
                      AND    entr_excpm_id      = @@l_excpm_id
                      AND    entr_from_dt       = @l_next_from_dt
                      AND    entr_deleted_ind   = 1
                      --
                      SET @l_error = @@error
                      --
                      IF @l_error > 0
                      BEGIN--r
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END--r
                      --
                      INSERT INTO entity_relationship
                      ( entr_crn_no
                      , entr_acct_no
                      , entr_sba
                     , entr_excpm_id
                      , entr_ho
                      , entr_re
                      , entr_ar
                      , entr_br
                      , entr_sb
                      , entr_dl
                      , entr_rm
                      , entr_dummy1
                      , entr_dummy2
                      , entr_dummy3
                      , entr_dummy4
                      , entr_dummy5
                      , entr_dummy6
                      , entr_dummy7
                      , entr_dummy8
                      , entr_dummy9
                      , entr_dummy10
                      , entr_FROM_dt
                      , entr_created_by
                      , entr_created_dt
                      , entr_lst_upd_by
                      , entr_lst_upd_dt
                      , entr_deleted_ind
                      )
                      VALUES
                      ( @pa_crn_no
                      , @l_accountno
                      , @l_subaccountno
                      , @@l_excpm_id
                      , @l_ho
                      , @l_re
                      , @l_ar
                      , @l_br
                      , @l_sb
                      , @l_dl
                      , @l_rm
                      , @l_dummy1
                      , @l_dummy2
                      , @l_dummy3
                      , @l_dummy4
                      , @l_dummy5
                      , @l_dummy6
                      , @l_dummy7
                      , @l_dummy8
                      , @l_dummy9
                      , @l_dummy10
                      , convert(datetime, @l_from_dt, 103)
                      , @pa_login_name
                      , GETDATE()
                      , @pa_login_name
                      , GETDATE()
                      ,1
                      )
                      --
                      SET @l_error = @@error
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      --
                      SET @l_errorstr = 'entity relationship ruccessfuly inserted/edited'+@ROWDELIMITER
                      --
                      COMMIT TRANSACTION
                    --
                    END --##3
                    ELSE IF (@l_prev_from_dt is NULL)
                    BEGIN--##4
                    --
                      INSERT INTO entity_relationship
                      (entr_crn_no
                      ,entr_acct_no
                      ,entr_sba
                      ,entr_excpm_id
                      ,entr_ho
                      ,entr_re
                      ,entr_ar
                      ,entr_br
                      ,entr_sb
                      ,entr_dl
                      ,entr_rm
                      ,entr_dummy1
                      ,entr_dummy2
                      ,entr_dummy3
                      ,entr_dummy4
                      ,entr_dummy5
                      ,entr_dummy6
                      ,entr_dummy7
                      ,entr_dummy8
                      ,entr_dummy9
                      ,entr_dummy10
                      ,entr_from_dt
                      ,entr_to_dt
                      ,entr_created_by
                      ,entr_created_dt
                      ,entr_lst_upd_by
                      ,entr_lst_upd_dt
                      ,entr_deleted_ind
                      )
                      VALUES
                      (@pa_crn_no
                      ,@l_accountno
                      ,@l_subaccountno
                      ,@@l_excpm_id
                      ,@l_ho
                      ,@l_re
                      ,@l_ar
                      ,@l_br
                      ,@l_sb
                      ,@l_dl
                      ,@l_rm
                      ,@l_dummy1
                      ,@l_dummy2
                      ,@l_dummy3
                      ,@l_dummy4
                      ,@l_dummy5
                      ,@l_dummy6
                      ,@l_dummy7
                      ,@l_dummy8
                      ,@l_dummy9
                      ,@l_dummy10
                      ,convert(datetime, @l_from_dt, 103)
                      ,dateadd(dd, -1, @l_next_from_dt)
                      ,@pa_login_name
                      ,GETDATE()
                      ,@pa_login_name
                      ,GETDATE()
                      ,1
                      )
                      --
                      SET @l_error = @@error
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      ELSE
                      BEGIN
                      --
                        SET @l_errorstr = 'entity relationship ruccessfuly inserted/edited'+@ROWDELIMITER
                        --
                        COMMIT TRANSACTION
                      --
                      END  
                    --  
                    END --##4
                  --
                  END   --a_0
                  --
                  IF @l_action_type = 'D'
                  BEGIN--d_0
                  --
                    BEGIN TRANSACTION
                    --
                    UPDATE entity_relationship   with (rowlock)
                    SET    entr_deleted_ind    = 0
                    WHERE  entr_crn_no         = @pa_crn_no
                    AND    entr_acct_no        = @l_accountno
                    AND    entr_sba            = @l_subaccountno
                    AND    entr_excpm_id       = @@l_excpm_id
                    AND    entr_from_dt        like convert(varchar(11), @l_from_dt) + '%'
                    AND    entr_deleted_ind    = 1
                    --
                    SET @l_error = @@error
                    --
                    IF @l_error > 0
                    BEGIN
                    --
                      SET @l_errorstr = '#'+'could not be inserted/edited'+@ROWDELIMITER
                      --
                      ROLLBACK TRANSACTION
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      SET @l_errorstr = 'entity relationship ruccessfuly inserted/edited'+@ROWDELIMITER
                      --
                      COMMIT TRANSACTION
                    --  
                    END  
                  --
                  END--d_0
                --
                END--null_0
              --
              END --@pa_chk_yn = 0
              ELSE
              BEGIN--@pa_chk_yn=1_2
              --
                IF ISNULL(@pa_action,'') = ''
                BEGIN--null_1
                --
                  IF @l_action_type IN ('A','D','E')
                  BEGIN--a_d_e
                  --
                    IF EXISTS(SELECT entr_id
                              FROM   entity_relationship_mak WITH (NOLOCK)
                              WHERE  entr_crn_no      = @pa_crn_no
                              AND    entr_acct_no     = @l_accountno
                              AND    entr_sba         = @l_subaccountno
                              AND    entr_excpm_id       = @@l_excpm_id
                              AND    CONVERT(datetime, entr_FROM_dt, 103) <= CONVERT(DATETIME, @l_from_dt, 103)
                              AND    entr_deleted_ind IN (0,4,8)
                             )
                    BEGIN--exists
                    --
                      BEGIN TRANSACTION
                      --
                      UPDATE entity_relationship_mak
                      SET    entr_deleted_ind         = 3
                      WHERE  entr_crn_no              = @pa_crn_no
                      AND    entr_acct_no             = @l_accountno
                      AND    entr_sba                 = @l_subaccountno
                      AND    entr_excpm_id            = @@l_excpm_id
                      AND    CONVERT(datetime, entr_FROM_dt, 103) <= CONVERT(DATETIME, @l_from_dt, 103)
                      AND    entr_deleted_ind IN (0,8)
                      --
                      SET @l_error = @@ERROR
                      --
                      IF @l_error > 0
                      BEGIN
                      --
                        SET @l_errorstr = '#'+'Could NOT Be Inserted/Edited ' + @ROWDELIMITER
                        --
                        ROLLBACK TRANSACTION
                      --
                      END
                      ELSE
                      BEGIN
                      --
                        SET @l_errorstr = 'Entity Relationship Ruccessfuly Inserted/Edited ' + @ROWDELIMITER
                        --
                        COMMIT TRANSACTION
                      --  
                      END  
                    --
                    END--exists
                    --
                    BEGIN TRANSACTION
                    --
                    IF EXISTS(SELECT entr_crn_no
                              FROM   entity_relationship WITH (NOLOCK)
                              WHERE  entr_crn_no      = @pa_crn_no
                              AND    entr_acct_no     = @l_accountno
                              AND    entr_sba         = @l_subaccountno
                              AND    entr_excpm_id    = @@l_excpm_id
                              AND    entr_deleted_ind = 1
                              )
                    BEGIN
                    --
                      SET @l_edt_del_id = 8  
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      SET @l_edt_del_id = 0                        
                    --
                    END  



                    SELECT @l_entr_id = ISNULL(MAX(entr_id),0) + 1 
                    FROM entity_relationship_mak WITH (NOLOCK)  
                    --

                    INSERT INTO entity_relationship_mak
                    (entr_id
                    ,entr_crn_no
                    ,entr_acct_no
                    , entr_excpm_id
                    ,entr_sba
                    ,entr_ho
                    ,entr_re
                    ,entr_ar
                    ,entr_br
                    ,entr_sb
                    ,entr_dl
                    ,entr_rm
                    ,entr_dummy1
                    ,entr_dummy2
                    ,entr_dummy3
                    ,entr_dummy4
                    ,entr_dummy5
                    ,entr_dummy6
                    ,entr_dummy7
                    ,entr_dummy8
                    ,entr_dummy9
                    ,entr_dummy10
                    ,entr_FROM_dt
                    ,entr_created_by
                    ,entr_created_dt
                    ,entr_lst_upd_by
                    ,entr_lst_upd_dt
                    ,entr_deleted_ind
                    )
                    VALUES
                    (@l_entr_id
                    ,@pa_crn_no
                    ,@l_accountno
                    ,@@l_excpm_id
                    ,@l_subaccountno
                    ,@l_ho
                    ,@l_re
                    ,@l_ar
                    ,@l_br
                    ,@l_sb
                    ,@l_dl
                    ,@l_rm
                    ,@l_dummy1
                    ,@l_dummy2
                    ,@l_dummy3
                    ,@l_dummy4
                    ,@l_dummy5
                    ,@l_dummy6
                    ,@l_dummy7
                    ,@l_dummy8
                    ,@l_dummy9
                    ,@l_dummy10
                    ,convert(datetime, @l_from_dt, 103)
                    ,@pa_login_name
                    ,getdate()
                    ,@pa_login_name
                    ,getdate()
                    ,CASE @l_action_type WHEN 'A' then 0
                                         WHEN 'E' then @l_edt_del_id                    
                                         WHEN 'D' then 4
                                         END
                    )

                    --
                    SET @l_error = @@ERROR
                    --
                    IF @l_error > 0
                    BEGIN
                    --
                      SET @l_errorstr = '#'+'Could NOT Be Inserted/Edited ' + @ROWDELIMITER
                      --
                      ROLLBACK TRANSACTION
                    --
                    END
                    ELSE
                    BEGIN
                    --
                      SET @l_errorstr = 'Entity Relationship Ruccessfuly Inserted/Edited ' + @ROWDELIMITER
                      --
                      COMMIT TRANSACTION
                    --  
                    END  
                  --
                  END--a_d_e
                  --
                  SELECT @l_action = CASE @l_action_type WHEN 'A' THEN 'I' WHEN 'E' THEN 'E' WHEN 'D' THEN 'D' END
                  --
                  --EXEC pr_ins_upd_list @l_crn_no, @l_action,'ENTITY RELATIONSHIP MSTR', @pa_login_name, '*|~*', '|*~|', ''  
                  EXEC pr_ins_upd_list @pa_crn_no, @l_action,'ENTITY RELATIONSHIP', @pa_login_name, '*|~*', '|*~|', ''  
                --
                END--null_1
              --
              END
            --  
            END--N_Q
          --
          END--@currstring<>''
        --
        END --#07
     --
     END --04
   --
   END  --#02
 --
 END--#01
 --
 IF @pa_action = 'APP' or @pa_action = 'REJ'
BEGIN --app_rej_1 
--
  WHILE @remainingstring_id <> ''
  BEGIN--@@remainingstring_id 
  --
    SET @foundat_id           = 0
    SET @currstring_id        = ''
    SET @foundat_id           =  PATINDEX('%'+@delimeter1+'%',@remainingstring_id)
    --
    IF @foundat_id > 0
    BEGIN
      --
      SET @currstring_id      = SUBSTRING(@remainingstring_id, 0, @foundat_id)
      SET @remainingstring_id = SUBSTRING(@remainingstring_id, @foundat_id+@delimeterlength_id, LEN(@remainingstring_id)- @foundat_id+@delimeterlength_id)
      --
    END
    ELSE
    BEGIN
      --
      SET @currstring_id      = @remainingstring_id
      SET @remainingstring_id = ''
      --
    END
    -- 
    IF @currstring_id <> ''
    BEGIN--@currstring_id
    --
      IF @pa_action = 'APP'
      BEGIN --APP
      --
        SELECT @l_entr_crn_no  =  convert(varchar, entr_crn_no)
             , @l_accountno    =  convert(varchar, entr_acct_no)
             , @l_subaccountno =  convert(varchar, entr_sba)
             , @l_ho           =  entr_ho
             , @l_re           =  entr_re
             , @l_ar           =  entr_ar
             , @l_br           =  entr_br
             , @l_sb           =  entr_sb
             , @l_dl           =  entr_dl
             , @l_rm           =  entr_rm
             , @l_dummy1       =  entr_dummy1
             , @l_dummy2       =  entr_dummy2
             , @l_dummy3       =  entr_dummy3
             , @l_dummy4       =  entr_dummy4
             , @l_dummy5       =  entr_dummy5
             , @l_dummy6       =  entr_dummy6
             , @l_dummy7       =  entr_dummy7
             , @l_dummy8       =  entr_dummy8
             , @l_dummy9       =  entr_dummy9
             , @l_dummy10      =  entr_dummy10
             , @l_from_dt      =  entr_FROM_dt
             , @l_deleted_ind  =  entr_deleted_ind
             , @@l_excpm_id    =  entr_excpm_id
        FROM   entity_relationship_mak 
        WHERE  entr_id          = CONVERT(numeric, @currstring_id) 


             SELECT @l_prev_from_dt = max(entr_from_dt)
              FROM   entity_relationship   with (nolock)
              WHERE  entr_crn_no         = @l_entr_crn_no
              AND    entr_acct_no        = @l_accountno
              AND    entr_sba            =@l_subaccountno
              AND    convert(datetime, entr_from_dt, 103) < convert(datetime,@l_from_dt, 103)
              AND    entr_deleted_ind    = 1
              --
              IF rtrim(ltrim(@l_prev_from_dt)) IS NULL
              BEGIN
              --
                SET @l_prev_from_dt  = NULL
              --
              END
              --
              SELECT @l_next_from_dt =  min(entr_from_dt)
              FROM   entity_relationship   with (nolock)
              WHERE  entr_crn_no         = @l_entr_crn_no
              AND    entr_acct_no        = @l_accountno
              AND    entr_sba            =@l_subaccountno
              AND    convert(datetime, entr_from_dt, 103) < convert(datetime,@l_from_dt, 103)
              AND    entr_deleted_ind    = 1
              --
              --
              IF rtrim(ltrim(@l_next_from_dt)) IS NULL
              BEGIN
              --
                SET  @l_next_from_dt = NULL
              --
              END

        --
        IF @l_deleted_ind = 4 
        BEGIN--4
        --
          UPDATE entity_relationship_mak WITH (ROWLOCK)
          SET    entr_deleted_ind      = 5
               , entr_lst_upd_by       = @pa_login_name
               , entr_lst_upd_dt       = GETDATE()
          WHERE  entr_deleted_ind      = 4
          AND    entr_id               = CONVERT(numeric, @currstring_id)
          --
          SET @l_error = @@ERROR
          --
          IF @l_error > 0
          BEGIN
          --
            SET @l_errorstr = convert(varchar(10), @l_error)
          --
          END
          --
          UPDATE entity_relationship               WITH (ROWLOCK)
          SET    entr_deleted_ind                = 0
               , entr_lst_upd_by                 = @pa_login_name
               , entr_lst_upd_dt                 = GETDATE()
          WHERE  entr_deleted_ind                = 1
          AND    entr_crn_no                     = @pa_crn_no
          AND    entr_acct_no                    = @l_accountno
          AND    entr_sba                        = @l_subaccountno
          AND    entr_excpm_id       = @@l_excpm_id
          AND    convert(datetime, entr_from_dt) = CONVERT(datetime, @l_from_dt, 103)
          --
          SET @l_error = @@ERROR
          --
          IF @l_error > 0
          BEGIN
          --
            SET @l_errorstr = convert(varchar(10), @l_error)
          --
          END
        --  
        END--4
        ELSE IF @l_deleted_ind    = 8
        BEGIN--8
        --
          UPDATE entity_relationship_mak  WITH (ROWLOCK)
          SET    entr_deleted_ind       = 9
               , entr_lst_upd_by        = @pa_login_name
               , entr_lst_upd_dt        = GETDATE()
          WHERE  entr_deleted_ind       = 8
          AND    entr_id                = CONVERT(numeric, @currstring_id)
          --
          SET @l_error = @@ERROR
          --
          IF @l_error > 0
          BEGIN
          --
            SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
          --
          END
          --
          UPDATE entity_relationship               WITH (ROWLOCK)
          SET    entr_ho                         = @l_ho
               , entr_re                         = @l_re
               , entr_ar                         = @l_ar
               , entr_br                         = @l_br
               , entr_sb                         = @l_sb
               , entr_dl                         = @l_dl
               , entr_rm                         = @l_rm
               , entr_dummy1                     = @l_dummy1
               , entr_dummy2                     = @l_dummy2
               , entr_dummy3                     = @l_dummy3
               , entr_dummy4                     = @l_dummy4
               , entr_dummy5                     = @l_dummy5
               , entr_dummy6                     = @l_dummy6
               , entr_dummy7                     = @l_dummy7
               , entr_dummy8                     = @l_dummy8
               , entr_dummy9                     = @l_dummy9
               , entr_dummy10                    = @l_dummy10
               , entr_lst_upd_by                 = @pa_login_name
               , entr_lst_upd_dt                 = GETDATE()
               , entr_excpm_id                   = @@l_excpm_id
          WHERE  entr_deleted_ind                = 1
          AND    entr_crn_no                     = @pa_crn_no
          AND    entr_acct_no                    = @l_accountno
          AND    entr_sba                        = @l_subaccountno
          AND    convert(datetime, entr_from_dt) = convert(datetime, @l_from_dt, 103)
          AND    entr_excpm_id                   = @@l_excpm_id
          --
          SET @l_error = @@ERROR
          --
          IF @l_error > 0
          BEGIN
          --
            SET @l_errorstr = convert(varchar(10), @l_error)

          END
        --
        END--8
        ELSE IF @l_deleted_ind = 0 
        BEGIN--0
        --
       
          UPDATE entity_relationship_mak  WITH (ROWLOCK)
          SET    entr_deleted_ind       = 1
               , entr_lst_upd_by        = @pa_login_name
               , entr_lst_upd_dt        = GETDATE()
          WHERE  entr_deleted_ind       = 0
          AND    entr_id                = CONVERT(numeric, @currstring_id)
          --
          SET @l_error = @@ERROR
          --
          IF @l_error > 0
          BEGIN
          --
            SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
          --
          END
          --
 
          IF (@l_prev_FROM_dt is NULL) AND (@l_next_from_dt is NULL)
          BEGIN--##1
          --



            INSERT INTO entity_relationship
            (entr_crn_no
            ,entr_acct_no
            ,entr_sba
            ,entr_excpm_id
            ,entr_ho
            ,entr_re
            ,entr_ar
            ,entr_br
            ,entr_sb
            ,entr_dl
            ,entr_rm
            ,entr_dummy1
            ,entr_dummy2
            ,entr_dummy3
            ,entr_dummy4
            ,entr_dummy5
            ,entr_dummy6
            ,entr_dummy7
            ,entr_dummy8
            ,entr_dummy9
            ,entr_dummy10
            ,entr_FROM_dt
            ,entr_created_by
            ,entr_created_dt
            ,entr_lst_upd_by
            ,entr_lst_upd_dt
            ,entr_deleted_ind
            )
            VALUES
            (@l_entr_crn_no
            ,@l_accountno
            ,@l_subaccountno
            ,@@l_excpm_id
            ,@l_ho
            ,@l_re
            ,@l_ar
            ,@l_br
            ,@l_sb
            ,@l_dl
            ,@l_rm
            ,@l_dummy1
            ,@l_dummy2
            ,@l_dummy3
            ,@l_dummy4
            ,@l_dummy5
            ,@l_dummy6
            ,@l_dummy7
            ,@l_dummy8
            ,@l_dummy9
            ,@l_dummy10
            ,CONVERT(datetime, @l_from_dt, 103)
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )
            --
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
            --
            END
          -- 
          END   --##1
          ELSE IF (@l_prev_FROM_dt is NOT NULL) AND (@l_next_from_dt is NOT NULL)
          BEGIN --##2
          --


            UPDATE entity_relationship WITH (ROWLOCK)
            SET    entr_to_dt        = dateadd(dd, -1, @l_from_dt)
                 , entr_lst_upd_by   = @pa_login_name
                 , entr_lst_upd_dt   = GETDATE()
            WHERE  entr_crn_no       = @pa_crn_no
            AND    entr_acct_no      = @l_accountno
            AND    entr_sba          = @l_subaccountno
            AND    entr_FROM_dt      = @l_prev_FROM_dt
            AND    entr_excpm_id       = @@l_excpm_id
            AND    entr_deleted_ind  = 1
            --
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
            --
            END
            --

            INSERT INTO entity_relationship
            (entr_crn_no
            ,entr_acct_no
            ,entr_sba
            ,entr_excpm_id
            ,entr_ho
            ,entr_re
            ,entr_ar
            ,entr_br
            ,entr_sb
            ,entr_dl
            ,entr_rm
            ,entr_dummy1
            ,entr_dummy2
            ,entr_dummy3
            ,entr_dummy4
            ,entr_dummy5
            ,entr_dummy6
            ,entr_dummy7
            ,entr_dummy8
            ,entr_dummy9
            ,entr_dummy10
            ,entr_FROM_dt
            ,entr_to_dt
            ,entr_created_by
            ,entr_created_dt
            ,entr_lst_upd_by
            ,entr_lst_upd_dt
            ,entr_deleted_ind
            )
            VALUES
            (@pa_crn_no
            ,@l_accountno
            ,@l_subaccountno
            ,@@l_excpm_id
            ,@l_ho
            ,@l_re
            ,@l_ar
            ,@l_br
            ,@l_sb
            ,@l_dl
            ,@l_rm
            ,@l_dummy1
            ,@l_dummy2
            ,@l_dummy3
            ,@l_dummy4
            ,@l_dummy5
            ,@l_dummy6
            ,@l_dummy7
            ,@l_dummy8
            ,@l_dummy9
            ,@l_dummy10
            ,convert(datetime, @l_from_dt, 103)
            ,'DEC 31 2900'
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )
            --
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
            --
            END
          --                      
          END --##2
          ELSE IF (@l_prev_FROM_dt is NULL)
          BEGIN--##3
          --


            INSERT INTO entity_relationship
            ( entr_crn_no
            , entr_acct_no
            , entr_sba
            , entr_excpm_id
            , entr_ho
            , entr_re
            , entr_ar
            , entr_br
            , entr_sb
            , entr_dl
            , entr_rm
            , entr_dummy1
            , entr_dummy2
            , entr_dummy3
            , entr_dummy4
            , entr_dummy5
            , entr_dummy6
            , entr_dummy7
            , entr_dummy8
            , entr_dummy9
            , entr_dummy10
            , entr_FROM_dt
            , entr_to_dt
            , entr_created_by
            , entr_created_dt
            , entr_lst_upd_by
            , entr_lst_upd_dt
            , entr_deleted_ind
            )
            VALUES
            ( @pa_crn_no
            , @l_accountno
            , @l_subaccountno
            , @@l_excpm_id
            , @l_ho
            , @l_re
            , @l_ar
            , @l_br
            , @l_sb
            , @l_dl
            , @l_rm
            , @l_dummy1
            , @l_dummy2
            , @l_dummy3
            , @l_dummy4
            , @l_dummy5
            , @l_dummy6
            , @l_dummy7
            , @l_dummy8
            , @l_dummy9
            , @l_dummy10
            , CONVERT(datetime, @l_from_dt, 103)
            , dateadd(dd, -1, @l_next_from_dt)
            , @pa_login_name
            , GETDATE()
            , @pa_login_name
            , GETDATE()
            ,1
            )
            --
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
            --
            END
          --
          END --##3
          ELSE IF (@l_next_from_dt is NULL)
          BEGIN--##4
          --


            UPDATE entity_relationship WITH (ROWLOCK)
            SET    entr_to_dt        = dateadd(dd, -1, @l_from_dt)
                 , entr_lst_upd_by   = @pa_login_name
                 , entr_lst_upd_dt   = GETDATE()
            WHERE  entr_crn_no       = @pa_crn_no
            AND    entr_acct_no      = @l_accountno
            AND    entr_sba          = @l_subaccountno
            AND    entr_FROM_dt      = @l_prev_FROM_dt
            AND    entr_excpm_id       = @@l_excpm_id
            AND    entr_deleted_ind  = 1
            --
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @l_errorstr = CONVERT(VARCHAR(10), @l_error)
            --
            END
            --

            INSERT INTO entity_relationship
            (entr_crn_no
            ,entr_acct_no
            ,entr_sba
            ,entr_excpm_id
            ,entr_ho
            ,entr_re
            ,entr_ar
            ,entr_br
            ,entr_sb
            ,entr_dl
            ,entr_rm
            ,entr_dummy1
            ,entr_dummy2
            ,entr_dummy3
            ,entr_dummy4
            ,entr_dummy5
            ,entr_dummy6
            ,entr_dummy7
            ,entr_dummy8
            ,entr_dummy9
            ,entr_dummy10
            ,entr_FROM_dt
            ,entr_created_by
            ,entr_created_dt
            ,entr_lst_upd_by
            ,entr_lst_upd_dt
            ,entr_deleted_ind
            )
            VALUES
            (@pa_crn_no
            ,@l_accountno
            ,@l_subaccountno
            ,@@l_excpm_id
            ,@l_ho
            ,@l_re
            ,@l_ar
            ,@l_br
            ,@l_sb
            ,@l_dl
            ,@l_rm
            ,@l_dummy1
            ,@l_dummy2
            ,@l_dummy3
            ,@l_dummy4
            ,@l_dummy5
            ,@l_dummy6
            ,@l_dummy7
            ,@l_dummy8
            ,@l_dummy9
            ,@l_dummy10
            ,CONVERT(datetime, @l_from_dt, 103)
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )
            --
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN 
            --
              SET @l_errorstr = convert(varchar(10), @l_error)
            --
            END
          --  
          END --##4
        --  
        END --0
      --
      END--app_1
      --
      IF @pa_action = 'REJ'
      BEGIN --rej_1
      --
        UPDATE entity_relationship_mak  WITH (ROWLOCK)
        SET    entr_deleted_ind       = 3
             , entr_lst_upd_by        = @pa_login_name
             , entr_lst_upd_dt        = GETDATE()
        WHERE  entr_id                = CONVERT(numeric, @currstring_id)
        AND    entr_deleted_ind      IN (0,4,8) 
        --
        SET @l_error = @@ERROR
        --
        IF @l_error > 0
        BEGIN
        --
         SET @l_errorstr = CONVERT(VARCHAR(10), @l_error) 
        --
        END
      --
      END --rej_1
    --
    END  --@currstring_id
  --  
  END--@@remainingstring_id  
--
END--app_rej_1
--
SET @pa_msg = ISNULL(@l_errorstr, '')
--
END --MAIN BEGIN

GO
