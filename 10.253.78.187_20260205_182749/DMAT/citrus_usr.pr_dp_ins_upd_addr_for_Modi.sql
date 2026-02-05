-- Object: PROCEDURE citrus_usr.pr_dp_ins_upd_addr_for_Modi
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin transaction
--PR_DP_INS_UPD_ADDR 	'54894','EDT','REAYMIN',0,'43443','DP','GUARD_ADR|*~|SDF111|*~|SDF|*~||*~||*~||*~||*~|*|~*NOMINEE_ADR1|*~|E4343|*~|234234|*~||*~||*~||*~||*~||*~|NOMINEE ADDRESS|*~|*|~*NOM_GUARDIAN_ADDR|*~||*~||*~||*~||*~||*~||*~||*~|NOMINEE GUARDIAN ADDRESS|*~|*|~*POA_ADR1|*~||*~||*~||*~||*~||*~||*~||*~|POA ADDRESS|*~|*|~*SH_ADR1|*~|WER|*~|WER|*~|WER|*~|WERW|*~|ER|*~||*~||*~|SECOND HOLDER ADDRESS|*~|*|~*SH_POA_ADR|*~||*~||*~||*~||*~||*~||*~||*~|SECOND POA HOLDER ADDRESS|*~|*|~*TH_ADR1|*~||*~||*~||*~||*~||*~||*~||*~|THIRD HOLDER ADDRESS|*~|*|~*TH_POA_ADR|*~||*~||*~||*~||*~||*~||*~||*~|THIRD POA HOLDER ADDRESS|*~|*|~*',2,'*|~*','|*~|',''	
--select * FROM addr_ACCT_MAK WHERE ADR_CLISBA_ID = 59777 AND ISNULL(ADR_1,'') <> '' 
--SELECT * FROM account_adr_conc WHERE accac_CLISBA_ID = 59777
--select * from addresses where adr_id in(611 ,614)
--rollback transaction
--select * from dp_Acct_mstr where dpam_crn_no = 54894
--SELECT * FROM conc_ACCT_MAK WHERE conc_CLISBA_ID = 59776 AND ISNULL(ADR_1,'') <> '' 
--SELECT * FROM ACCOUNT_ADR_CONC WHERE ACCAC_CLISBA_ID = 59775 AND ACCAC_CONCM_ID = 41
--SELECT * FROM ADDRESSES WHERE ADR_ID = 608
CREATE PROCEDURE [citrus_usr].[pr_dp_ins_upd_addr_for_Modi] (@pa_id           varchar(8000)  
                                    ,@pa_action       varchar(20)  
                                    ,@pa_login_name   varchar(20)  
                                    ,@pa_clisba_id    numeric
                                    ,@pa_demat_no     varchar(20)  
                                    ,@pa_acct_type    varchar(20)
                                    ,@pa_values       varchar(8000)  
                                    ,@pa_chk_yn       int  
                                    ,@rowdelimiter    char(4)  
                                    ,@coldelimiter    char(4)  
                                    ,@pa_msg          varchar(8000) OUTPUT  
)  
AS
/*
************************************************************************************
 system         : citrus
 module name    : pr_ins_upd_dp_addr
 description    : this procedure will add new values to account_adr_conc & addresses
 copyright(c)   : MarketPlace Technolgies Pvt. Ltd.
 version history: 1.0
 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   -----------------------------------------------
 1.0    Sukhvinder      17-Aug-2007   Initial version.
 -----------------------------------------------------------------------------------
 ************************************************************************************
*/
BEGIN  
--  
  SET NOCOUNT ON
  --
  DECLARE @remainingstring_id      varchar(8000)  
        , @currstring_id           varchar(8000)  
        , @remainingstring_val     varchar(8000)  
        , @currstring_val          varchar(8000)
        , @foundat                 int  
        , @delimeterlength         int 
        , @delimeter               char(4)
        , @l_errorstr              varchar(8000)
        , @l_error                 numeric
        , @l_concm_desc            varchar(50)
                      --Cursor--
        , @c_access_cursor         cursor
        , @c_accac_clisba_id       numeric
        , @c_accac_acct_no         varchar(25)
        , @c_accac_acct_type       varchar(20)
        , @c_accac_concm_id        numeric 
        , @c_adr_id                numeric 
        , @c_adr_1                 varchar(50)
        , @c_adr_2                 varchar(50)
        , @c_adr_3                 varchar(50)
        , @c_adr_city              varchar(50)
        , @c_adr_state             varchar(50)
        , @c_adr_country           varchar(50)
        , @c_adr_zip               varchar(50)
                     --Addresses--
        , @l_adr_id                varchar(20)
        , @l_adr_1                 varchar(50)
        , @l_adr_2                 varchar(50)
        , @l_adr_3                 varchar(50)
        , @l_adr_city              varchar(50)
        , @l_adr_state             varchar(50)
        , @l_adr_country           varchar(50)
        , @l_adr_zip               varchar(50)
        , @l_old_addr_value        varchar(8000) 
        , @l_old_adr_id            numeric
        , @l_adrm_id               numeric
        , @l_clisba_id             numeric
        , @l_concm_id              numeric
        , @l_concm_cd              varchar(20)
        , @l_acct_no               varchar(25)
        , @l_acct_type             varchar(20)
        , @l_deleted_ind           smallint
        , @l_accac_adr_conc_id     numeric
        , @l_dpam_id               numeric
        , @l_chk_in                varchar(5)  
  --
 
  --
  SET @l_error             = 0       
  SET @l_errorstr          = ''
  SET @delimeter           = '%'+@rowdelimiter+'%'  
  SET @delimeterlength     = LEN(@rowdelimiter) 
  SET @remainingstring_val = @pa_values
  SET @remainingstring_id  = @pa_id
  --
  WHILE @remainingstring_id <> ''  
  BEGIN--w_id  
  --  
    SET @foundat = 0  
    SET @foundat = PATINDEX('%'+@delimeter+'%',@remainingstring_id)  
    --
    IF @foundat > 0  
    BEGIN  
    --  
      SET @currstring_id      = SUBSTRING(@remainingstring_id, 0,@foundat)  
      SET @remainingstring_id = SUBSTRING(@remainingstring_id, @foundat+@delimeterlength,LEN(@remainingstring_id)- @foundat+@delimeterlength)  
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
    BEGIN--cur_id
    --
      IF @pa_action <> 'APP' AND @pa_action <> 'REJ'
      BEGIN--not_app_rej
      --
        WHILE @remainingstring_val <> ''  
        BEGIN--w_val  
        --  
          SET @foundat = 0  
          SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring_val)  
          --
          IF @foundat > 0  
          BEGIN  
          --  
            SET @currstring_val      = SUBSTRING(@remainingstring_val, 0,@foundat)  
            SET @remainingstring_val = SUBSTRING(@remainingstring_val, @foundat+@delimeterlength,LEN(@remainingstring_val)- @foundat+@delimeterlength)  
          --  
          END  
          ELSE  
          BEGIN  
          --  
            SET @currstring_val      = @remainingstring_val  
            SET @remainingstring_val = ''  
          --  
          END
          --
          IF @currstring_val <> ''
          BEGIN--cur_val
          --
            SET @l_concm_cd       = citrus_usr.fn_splitval(@currstring_val,1)  
            SET @l_adr_1          = citrus_usr.fn_splitval(@currstring_val,2)
            SET @l_adr_2          = citrus_usr.fn_splitval(@currstring_val,3)
            SET @l_adr_3          = citrus_usr.fn_splitval(@currstring_val,4)
            SET @l_adr_city       = citrus_usr.fn_splitval(@currstring_val,5)
            SET @l_adr_state      = citrus_usr.fn_splitval(@currstring_val,6)
            SET @l_adr_country    = citrus_usr.fn_splitval(@currstring_val,7)
            SET @l_adr_zip        = CONVERT(varchar, citrus_usr.fn_splitval(@currstring_val,8))
            --
            SELECT @l_concm_id       = concm_id
            FROM   conc_code_mstr      WITH (NOLOCK)
            WHERE  concm_cd          = @l_concm_cd
            AND    concm_deleted_ind = 1
            --
          
            --
            IF ISNULL(@l_concm_id,0) <> 0
            BEGIN--conc_id<>0  
            --
              
              IF @pa_action = 'EDT'
              BEGIN--edt  
              --
               
                IF @pa_chk_yn = 1 or @pa_chk_yn = 2
                BEGIN--edt_1_2
                --
                  IF ISNULL(@pa_values,'') <> ''
                  BEGIN--null
                  --

						  SELECT @l_adrm_id = ISNULL(MAX(adrm_id),0) + 1 
                          FROM addr_acct_mak WITH (NOLOCK)
                          --
                          SELECT @l_concm_id= concm_id , @l_concm_cd     = concm_cd
                          FROM   conc_code_mstr     WITH (NOLOCK)
                          WHERE  concm_cd         = @l_concm_cd
                          AND    concm_deleted_ind = 1


select @l_dpam_id = dpam_id from (select dpam_id from dp_acct_mstr where (dpam_sba_no  = @pa_demat_no or dpam_acct_no  = @pa_demat_no ) and dpam_deleted_ind = 1
union 
select dpam_id from dp_acct_mstr_mak where (dpam_sba_no  = @pa_demat_no or dpam_acct_no  = @pa_demat_no ) and dpam_deleted_ind in (0,8)) a 


update addr_acct_mak set adr_deleted_ind = 3 
where ADR_CLISBA_ID = @l_dpam_id 
and ADR_CONCM_ID= @l_concm_id
and adr_deleted_ind in (0,4,8)

						  


INSERT INTO addr_acct_mak
                          (adrm_id
                          ,adr_clisba_id
                          ,adr_acct_no
                          ,adr_acct_type
                          ,adr_concm_id
                          ,adr_concm_cd
                          ,adr_id
                          ,adr_1
                          ,adr_2
                          ,adr_3
                          ,adr_city
                          ,adr_state
                          ,adr_country
                          ,adr_zip
                          ,adr_created_by
                          ,adr_created_dt
                          ,adr_lst_upd_by
                          ,adr_lst_upd_dt
                          ,adr_deleted_ind
                          )
                          
                          select @l_adrm_id
                          ,@l_dpam_id--@pa_clisba_id
                          ,@pa_demat_no
                          ,@pa_acct_type
                          ,@l_concm_id
                          ,@l_concm_cd
                          ,0
                          ,@l_adr_1
                          ,@l_adr_2
                          ,@l_adr_3
                          ,@l_adr_city
                          ,@l_adr_state
                          ,@l_adr_country
                          ,@l_adr_zip
                          ,@pa_login_name
                          ,GETDATE()
                          ,@pa_login_name
                          ,GETDATE()
                          ,8
							where  exists (select adr_id from addresses,account_adr_conc
												where accac_adr_conc_id = adr_id and accac_clisba_id = @l_dpam_id 
												AND ACCAC_CONCM_ID =@l_concm_id AND ADR_DELETED_IND = 1 AND ACCAC_DELETED_IND = 1)

						INSERT INTO addr_acct_mak
                          (adrm_id
                          ,adr_clisba_id
                          ,adr_acct_no
                          ,adr_acct_type
                          ,adr_concm_id
                          ,adr_concm_cd
                          ,adr_id
                          ,adr_1
                          ,adr_2
                          ,adr_3
                          ,adr_city
                          ,adr_state
                          ,adr_country
                          ,adr_zip
                          ,adr_created_by
                          ,adr_created_dt
                          ,adr_lst_upd_by
                          ,adr_lst_upd_dt
                          ,adr_deleted_ind
                          )
                          
                          select @l_adrm_id
                          ,@l_dpam_id--@pa_clisba_id
                          ,@pa_demat_no
                          ,@pa_acct_type
                          ,@l_concm_id
                          ,@l_concm_cd
                          ,0
                          ,@l_adr_1
                          ,@l_adr_2
                          ,@l_adr_3
                          ,@l_adr_city
                          ,@l_adr_state
                          ,@l_adr_country
                          ,@l_adr_zip
                          ,@pa_login_name
                          ,GETDATE()
                          ,@pa_login_name
                          ,GETDATE()
                          ,0
							where not exists (select adr_id from addresses,account_adr_conc
												where accac_adr_conc_id = adr_id and accac_clisba_id = @l_dpam_id 
												AND ACCAC_CONCM_ID =@l_concm_id AND ADR_DELETED_IND = 1 AND ACCAC_DELETED_IND = 1)
                          


					
					insert into client_list
					select @pa_id,'E','ADDRESSES',@pa_login_name,GETDATE (),@pa_login_name,GETDATE (),1,0,3
                  --
                  END--null
                  
                --
                END--edt_1_2
                --
               
              --
              END --edt
            --
            END--cur_val
          -- 
          END--conc_id<>0
          ELSE
          BEGIN--conc_id=0
          --
             SET @l_errorstr = @l_concm_cd+' could not be Inserted/Edited'+@rowdelimiter+ISNULL(@l_errorstr,'')
          --
          END--conc_id=0
        --
        END--w_val
      --
      END--not_app_rej
	  IF @pa_action = 'APP'
      BEGIN--app
      --
        SELECT @l_deleted_ind    = adr_deleted_ind
             --, @l_clisba_id      = adr_clisba_id
             , @l_acct_no        = adr_acct_no
             , @l_acct_type      = adr_acct_type
             , @l_concm_id       = adr_concm_id                  
             , @l_concm_cd       = adr_concm_cd                 
             --, @l_adr_id         = adr_id
             , @l_adr_1          = adr_1          
             , @l_adr_2          = adr_2        
             , @l_adr_3          = adr_3
             , @l_adr_city       = adr_city
             , @l_adr_state      = adr_state
             , @l_adr_country    = adr_country
             , @l_adr_zip        = adr_zip
        FROM   addr_acct_mak        WITH (NOLOCK)
        WHERE  adrm_id            = CONVERT(numeric,@currstring_id)  
        AND    adr_deleted_ind   IN (0,4,8)
        
		
		set @l_adr_id = 0
        set @l_dpam_id = 0 
		select @l_dpam_id = dpam_id from (select dpam_id from dp_acct_mstr where (dpam_sba_no  = @l_acct_no or dpam_acct_no  = @l_acct_no ) and dpam_deleted_ind = 1
		union 
		select dpam_id from dp_acct_mstr_mak where (dpam_sba_no  = @l_acct_no or dpam_acct_no  = @l_acct_no ) and dpam_deleted_ind in (0,8)) a 

        if exists (select 1 from addresses where ltrim(rtrim(adr_1)) = ltrim(rtrim(@l_adr_1))
				   and ltrim(rtrim(adr_2)) = ltrim(rtrim(@l_adr_2))
				   and ltrim(rtrim(adr_3)) = ltrim(rtrim(@l_adr_3))
				   and ltrim(rtrim(adr_city)) = ltrim(rtrim(@l_adr_city))
			       and ltrim(rtrim(adr_state)) = ltrim(rtrim(@l_adr_state))
				   and ltrim(rtrim(adr_country)) = ltrim(rtrim(@l_adr_country))
				   and ltrim(rtrim(adr_zip)) = ltrim(rtrim(@l_adr_zip))
				   and adr_deleted_ind = 1 ) 
		begin 

				   select @l_adr_id = adr_id  from addresses where ltrim(rtrim(adr_1)) = ltrim(rtrim(@l_adr_1))
				   and ltrim(rtrim(adr_2)) = ltrim(rtrim(@l_adr_2))
				   and ltrim(rtrim(adr_3)) = ltrim(rtrim(@l_adr_3))
				   and ltrim(rtrim(adr_city)) = ltrim(rtrim(@l_adr_city))
			       and ltrim(rtrim(adr_state)) = ltrim(rtrim(@l_adr_state))
				   and ltrim(rtrim(adr_country)) = ltrim(rtrim(@l_adr_country))
				   and ltrim(rtrim(adr_zip)) = ltrim(rtrim(@l_adr_zip))
				   and adr_deleted_ind = 1 


		end 
		else 
		begin
			
			SELECT @l_adr_id         = bitrm_bit_location
            FROM   bitmap_ref_mstr      WITH(NOLOCK)
            WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
            AND    bitrm_child_cd     = 'ADR_CONC_ID'

            UPDATE bitmap_ref_mstr      WITH(ROWLOCK)
            SET    bitrm_bit_location = bitrm_bit_location + 1
            WHERE  bitrm_parent_cd    = 'ADR_CONC_ID'
            AND    bitrm_child_cd     = 'ADR_CONC_ID'
            --
            INSERT INTO addresses
            (adr_id
            ,adr_1
            ,adr_2
            ,adr_3
            ,adr_city
            ,adr_state
            ,adr_country
            ,adr_zip
            ,adr_created_by
            ,adr_created_dt
            ,adr_lst_upd_by
            ,adr_lst_upd_dt
            ,adr_deleted_ind
            )
            VALUES
            (@l_adr_id
            ,@l_adr_1
            ,@l_adr_2
            ,@l_adr_3
            ,@l_adr_city
            ,@l_adr_state
            ,@l_adr_country
            ,@l_adr_zip
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )


		end 
		if exists (select 1 from account_adr_conc where accac_clisba_id = @l_dpam_id and ACCAC_CONCM_ID = @l_concm_id and accac_deleted_ind = 1)
		begin 

			update account_adr_conc set accac_adr_conc_id = @l_adr_id
			where accac_clisba_id = @l_dpam_id and ACCAC_CONCM_ID = @l_concm_id and accac_deleted_ind = 1

		end 
		else 
		begin 
			INSERT INTO account_adr_conc
            (accac_clisba_id
            ,accac_acct_no
            ,accac_acct_type
            ,accac_concm_id
            ,accac_adr_conc_id
            ,accac_created_by
            ,accac_created_dt
            ,accac_lst_upd_by
            ,accac_lst_upd_dt
            ,accac_deleted_ind
            )
			VALUES
            (@l_dpam_id
            ,@l_acct_no
            ,@l_acct_type 
            ,@l_concm_id 
            ,@l_adr_id
            ,@pa_login_name
            ,GETDATE()
            ,@pa_login_name
            ,GETDATE()
            ,1
            )
		end 
		
       
          --
          UPDATE addr_acct_mak     WITH (ROWLOCK)
          SET    adr_deleted_ind = case when adr_deleted_ind  = 8 then 9 when adr_deleted_ind  = 0 then 1 else adr_deleted_ind   end 
               , adr_lst_upd_by  = @pa_login_name
               , adr_lst_upd_dt  = GETDATE()
          WHERE  adr_deleted_ind in (0,8)
          AND    adrm_id         = CONVERT(numeric,@currstring_id)  
        --
        
        --
        EXEC pr_ins_upd_list @pa_clisba_id, 'A','ADDRESSES', @pa_login_name,'*|~*','|*~|',''
      --
      END--app
      --
      IF @pa_action = 'REJ'
      BEGIN--rej
      --
        UPDATE addr_acct_mak       WITH (ROWLOCK)
        SET    adr_deleted_ind   = 3
             , adr_lst_upd_by    = @pa_login_name
             , adr_lst_upd_dt    = GETDATE()
        WHERE  adr_deleted_ind  IN(0,4,8)
        AND    adrm_id           = CONVERT(numeric, @currstring_id)
      --
      END--rej
     
    --
    END--cur_id
  --
  END--w_id
  --
 
  --
  IF @l_errorstr=''  
  BEGIN  
  --  
    SET @pa_msg = 'Contact Channels Successfully Inserted/Edited'+ @rowdelimiter  
  --  
  END  
  ELSE  
  BEGIN  
  --  
    SET @pa_msg = @l_errorstr  
  --  
  END  
--
END

GO
