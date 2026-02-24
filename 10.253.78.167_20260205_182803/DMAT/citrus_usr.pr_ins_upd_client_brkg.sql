-- Object: PROCEDURE citrus_usr.pr_ins_upd_client_brkg
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_client_brkg]
(			  @pa_id             varchar(8000)  
             ,@pa_action         varchar(20)  
             ,@pa_login_name     varchar(20)  
             ,@pa_crn_no         numeric  
             ,@pa_values         varchar(8000)  
             ,@pa_chk_yn         numeric  
             ,@rowdelimiter      char(4) = '*|~*'  
             ,@coldelimiter      char(4) = '|*~|'  
             ,@pa_msg            varchar(8000) output  
  )  
AS  
 /*  
 ********************************************************************************  
 system          : Citrus  
 module name     : pr_ins_upd_client_brkg  
 description     : this procedure will add new values to client_dp_brkg  
 copyright(c)    : Marketplace Technologies Pvt.Ltd  
 version history :  
 VERS.  AUTHOR          DATE         REASON  
 -----  -------------   ----------   ---------------------------------------------  
 1.0    Tushar          25-02-2008   Initial Version.  
 ---------------------------------------------------------------------------------  
 *********************************************************************************  
 */  
 --  
BEGIN  
--
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
           ,@l_brom_id int  
           ,@l_dpam_id int  
           ,@l_counter_flg int   
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
              --54735  HO 54735 1|*~|3|*~|1111111111|*~|1111111111|*~|01/01/1900|*~||*~|D*|~*1|*~|3|*~|1111111111|*~|1111111111|*~|13/02/2008|*~||*~|D*|~*1|*~|3|*~|1111111111|*~|1111111111|*~|15/02/2008|*~||*~|D*|~* 0 *|~* |*~|   
              SET @l_comp_id       = citrus_usr.fn_splitval(@currstring,1)  
              SET @l_excsm_id      = citrus_usr.fn_splitval(@currstring,2)  
              SET @l_accountno     = citrus_usr.fn_splitval(@currstring,3)  
              SET @l_subaccountno  = citrus_usr.fn_splitval(@currstring,4)  
              SET @l_from_dt       = convert(datetime, citrus_usr.fn_splitval(@currstring, 5), 103)  
              SET @l_brom_id       = citrus_usr.fn_splitval(@currstring, 6)  
              SET @l_action_type   = citrus_usr.fn_splitval(@currstring, 7)  
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
               SET @l_subaccountno       = substring(@l_subaccountno,9,len(@l_subaccountno))    
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
              IF exists(select dpam_id from dp_acct_mstr  where dpam_acct_no = @l_accountno and dpam_sba_no = @l_subaccountno and dpam_excsm_id = @l_excsm_id and dpam_deleted_ind = 1 )  
              BEGIN  
              --  
                select @l_dpam_id = dpam_id from dp_acct_mstr  where dpam_acct_no = @l_accountno and dpam_sba_no = @l_subaccountno and dpam_excsm_id = @l_excsm_id and dpam_deleted_ind = 1   
              --  
              END  
              ELSE  
              BEGIN  
              --  
                select @l_dpam_id = dpam_id from dp_acct_mstr_mak  where dpam_acct_no = @l_accountno and dpam_sba_no = @l_subaccountno and dpam_excsm_id = @l_excsm_id and dpam_deleted_ind in (0,4,8)  
              --  
              END  
                
                
              IF @l_action_type <> 'Q'  
              BEGIN--N_Q  
              --  
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
                      FROM   client_dp_brkg       WITH (NOLOCK)  
                      WHERE  clidb_dpam_id        = @l_dpam_id  
                      AND    clidb_eff_from_dt      LIKE  convert(varchar(11), @l_from_dt) + '%'  
                      AND    clidb_deleted_ind    = 1  
                      --  
                      IF @l_exists_flg > 0  
                      BEGIN--exists  
                      --  
                        BEGIN TRANSACTION  
                        --  
                          UPDATE client_dp_brkg   
                          SET    clidb_eff_to_dt      = @l_from_dt  
                          WHERE  clidb_dpam_id        = @l_dpam_id  
                          AND    clidb_deleted_ind    = 1  
                            
                          insert into client_dp_brkg   
                          (clidb_dpam_id            
        ,clidb_brom_id            
        ,clidb_eff_from_dt        
        ,clidb_eff_to_dt          
        ,clidb_created_by         
        ,clidb_created_dt         
        ,clidb_lst_upd_by         
        ,clidb_lst_upd_dt         
        ,clidb_deleted_ind        
                          )  
                          values  
                          (@l_dpam_id  
                          ,@l_brom_id  
                          ,@l_from_dt  
                          ,'01/01/2900'  
                          ,@pa_login_name  
                          ,getdate()  
                          ,@pa_login_name  
                          ,getdate()  
                          ,1  
                          )  
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
                          SET @l_errorstr = 'Tarrif Mapping successfuly inserted/edited'+@ROWDELIMITER  
                          --  
                          COMMIT TRANSACTION  
                        --  
                        END  
                      --  
                      END  --exists  
                    --  
                    END--e_0  
                    --  
                    IF @l_action_type     = 'A'  
                    BEGIN --a_0  
                    --  
                      BEGIN TRANSACTION  
                      --  
                        
                      SELECT @l_exists_flg        = count(*)  
       FROM   client_dp_brkg       WITH (NOLOCK)  
       WHERE  clidb_dpam_id        = @l_dpam_id  
       --AND    clidb_eff_from_dt      LIKE  convert(varchar(11), @l_from_dt) + '%'  
       AND    clidb_deleted_ind    = 1  
                      --  
                        
                       IF @l_exists_flg > 0  
       BEGIN--exists  
       --  
         UPDATE client_dp_brkg   
         SET    clidb_eff_to_dt      = DATEadd(DD,-1,@l_from_dt)  
         WHERE  clidb_dpam_id        = @l_dpam_id  
         AND    clidb_deleted_ind    = 1 
		and clidb_eff_to_dt in ('2900-01-01 00:00:00.000','2100-12-31 00:00:00.000',NULL) 
       --  
       END  
                             
                          insert into client_dp_brkg   
        (clidb_dpam_id            
        ,clidb_brom_id            
        ,clidb_eff_from_dt        
        ,clidb_eff_to_dt          
        ,clidb_created_by         
        ,clidb_created_dt         
        ,clidb_lst_upd_by         
        ,clidb_lst_upd_dt         
        ,clidb_deleted_ind        
        )  
        values  
        (@l_dpam_id  
        ,@l_brom_id  
        ,@l_from_dt  
        ,'01/01/2900'  
        ,@pa_login_name  
        ,getdate()  
        ,@pa_login_name  
        ,getdate()  
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
                        SET @l_errorstr = 'Tarrif Mapping  uccessfuly inserted/edited'+@ROWDELIMITER  
                        --  
                        COMMIT TRANSACTION  
                      --  
                        
                    --  
                    END   --a_0  
                    --  
                    IF @l_action_type = 'D'  
                    BEGIN--d_0  
                    --  
                      BEGIN TRANSACTION  
                      --  
                      UPDATE client_dp_brkg   with (rowlock)  
                      SET    clidb_deleted_ind    = 0  
                      WHERE  clidb_dpam_id        = @l_dpam_id  
                      AND    clidb_brom_id        = @l_brom_id  
                      AND    clidb_deleted_ind    = 1  
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
                        SET @l_errorstr = 'Tarrif Mapping successfuly inserted/edited'+@ROWDELIMITER  
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
                  IF EXISTS(select clidb_brom_id , clidb_dpam_id from clib_mak where CONVERT(varchar,clidb_eff_from_dt,103) = CONVERT(varchar,@l_from_dt,103) AND clidb_dpam_id = @l_dpam_id  and clidb_deleted_ind in (0,4,8))  
                  BEGIN  
                  --  
                    UPDATE clib_mak   
                    SET    clidb_deleted_ind = 3  
                    WHERE  clidb_dpam_id = @l_dpam_id    
                          and    CONVERT(varchar,clidb_eff_from_dt,103) = @l_from_dt  
                    and    clidb_deleted_ind in (0,4,8)  
                  --  
                  END  
                    
                  
                  
                  IF @l_action_type in ('A','D','E')  
                  BEGIN  
                  --  
                    insert into clib_mak  
       (clidb_dpam_id            
       ,clidb_brom_id            
       ,clidb_eff_from_dt        
       ,clidb_eff_to_dt          
       ,clidb_created_by         
       ,clidb_created_dt         
       ,clidb_lst_upd_by         
       ,clidb_lst_upd_dt         
       ,clidb_deleted_ind        
       )  
       values  
       (@l_dpam_id  
       ,@l_brom_id  
       ,@l_from_dt  
       ,'01/01/2900'  
       ,@pa_login_name  
       ,getdate()  
       ,@pa_login_name  
       ,getdate()  
       ,case when @l_action_type = 'A' then 0   
          when @l_action_type = 'E' then 8   
          when @l_action_type = 'D' then 4 end  
                     )  
                  --  
                  END  
                    
                   SET @l_errorstr = 'Tarrif Mapping successfuly inserted/edited'+@ROWDELIMITER  
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
        DECLARE @l_eff_from_dt datetime  
        select @l_deleted_ind = clidb_deleted_ind , @l_eff_from_dt = clidb_eff_from_dt from clib_mak where clidb_dpam_id =  convert(int,@currstring_id) and clidb_deleted_ind in (0,4,8)  
          
        IF @pa_action = 'APP'  
        BEGIN  
        --  
          if @l_deleted_ind = 0  
          begin  
          --  
            
          SELECT @l_counter_flg = count(*)  
       FROM   clib_mak clibm  
      ,client_dp_brkg clidb  
    WHERE  clidb.clidb_dpam_id = clibm.clidb_dpam_id   
    --AND    clidb.clidb_brom_id = clibm.clidb_brom_id  
    AND    clibm.clidb_dpam_id = convert(int,@currstring_id)  
    AND    clibm.clidb_deleted_ind = 0  
                AND    clidb.clidb_deleted_ind = 1  
              
              
            if @l_counter_flg > 0   
            begin  
            -- 




              UPDATE clidb  
              SET    clidb.clidb_eff_to_dt = DATEadd(DD,-1,clibm.clidb_eff_from_dt)
              FROM   clib_mak clibm  
     ,client_dp_brkg clidb  
              WHERE  clidb.clidb_dpam_id = clibm.clidb_dpam_id   
     --AND    clidb.clidb_brom_id = clibm.clidb_brom_id  
     AND    clibm.clidb_dpam_id = convert(int,@currstring_id)  
     and    clidb.clidb_eff_to_dt in ('2900-01-01 00:00:00.000','2100-12-31 00:00:00.000',NULL)
     AND    clibm.clidb_deleted_ind = 0  
     AND    clidb.clidb_deleted_ind = 1  
       
     END   
       
            insert into client_dp_brkg   
     (clidb_dpam_id            
     ,clidb_brom_id            
     ,clidb_eff_from_dt        
     ,clidb_eff_to_dt          
     ,clidb_created_by         
     ,clidb_created_dt         
     ,clidb_lst_upd_by         
     ,clidb_lst_upd_dt         
     ,clidb_deleted_ind        
     )  
            select clidb_dpam_id            
     ,clidb_brom_id            
     ,clidb_eff_from_dt        
     ,clidb_eff_to_dt          
     ,clidb_created_by         
     ,clidb_created_dt         
     ,clidb_lst_upd_by         
     ,clidb_lst_upd_dt         
     ,1  
     from clib_mak   
     where clidb_dpam_id =  convert(int,@currstring_id)  
     AND   clidb_deleted_ind = 0   
  
  
  
                   UPDATE CLIB_MAK   
                   SET    CLIDB_DELETED_IND = 1   
                   where clidb_dpam_id =  convert(int,@currstring_id)  
       AND   clidb_deleted_ind = 0   
              
          --  
          end  
          else if @l_deleted_ind = 4  
          begin  
          --  
            update a  
            set    clidb_deleted_ind = 0  
                  from   client_dp_brkg a  
                        ,clib_mak  b  
            where  a.clidb_dpam_id = b.clidb_dpam_id   
                  and    a.clidb_brom_id = b.clidb_brom_id   
                  and    a.clidb_dpam_id =  convert(int,@currstring_id)  
            AND    a.clidb_eff_from_dt = @l_eff_from_dt   
                  AND    a.clidb_deleted_ind = 1  
                  and    b.clidb_deleted_ind = 4    
                            
  
  
                   UPDATE CLIB_MAK   
                   SET    CLIDB_DELETED_IND = 5   
                   where clidb_dpam_id =  convert(int,@currstring_id)  
                   AND   clidb_eff_from_dt = @l_eff_from_dt   
       AND   clidb_deleted_ind = 4   
              
          --  
          end  
          else if @l_deleted_ind = 8  
          begin  
          --  
       SELECT @l_counter_flg = count(*)  
       FROM   clib_mak clibm  
      ,client_dp_brkg clidb  
    WHERE  clidb.clidb_dpam_id = clibm.clidb_dpam_id   
    AND    clidb.clidb_brom_id = clibm.clidb_brom_id  
    AND    clibm.clidb_dpam_id = convert(int,@currstring_id)  
    AND    clibm.clidb_deleted_ind = 8  
                AND    clidb.clidb_deleted_ind = 1  
              
              
            if @l_counter_flg > 1  
            begin  
            --  
              UPDATE clidb  
              SET    clidb.clidb_eff_to_dt = DATEadd(DD,-1,clibm.clidb_eff_from_dt )
              FROM   clib_mak clibm  
     ,client_dp_brkg clidb  
              WHERE  clidb.clidb_dpam_id = clibm.clidb_dpam_id   
     AND    clidb.clidb_brom_id = clibm.clidb_brom_id  
     AND    clibm.clidb_dpam_id = convert(int,@currstring_id)  
     and    clidb.clidb_eff_to_dt in ('2900-01-01 00:00:00.000','2100-12-31 00:00:00.000',NULL)
     AND    clibm.clidb_deleted_ind = 8  
     AND    clidb.clidb_deleted_ind = 1  
                
                
   insert into client_dp_brkg   
   (clidb_dpam_id            
   ,clidb_brom_id            
   ,clidb_eff_from_dt        
   ,clidb_eff_to_dt          
   ,clidb_created_by         
   ,clidb_created_dt         
   ,clidb_lst_upd_by         
   ,clidb_lst_upd_dt         
   ,clidb_deleted_ind        
   )  
   select clidb_dpam_id            
   ,clidb_brom_id            
   ,clidb_eff_FROM_dt    
   ,null        
   ,clidb_created_by         
   ,clidb_created_dt         
   ,clidb_lst_upd_by         
   ,clidb_lst_upd_dt         
   ,1  
   from clib_mak   
   where clidb_dpam_id =  convert(int,@currstring_id)  
         AND   clidb_deleted_ind = 8  
  
 --  
            end  
            else   
            begin   
              UPDATE clidb  
              SET   clidb.clidb_brom_id = clibm.clidb_brom_id  
              FROM   clib_mak clibm  
     ,client_dp_brkg clidb  
              WHERE  clidb.clidb_dpam_id = clibm.clidb_dpam_id   
     --AND    clidb.clidb_brom_id = clibm.clidb_brom_id  
              and    clidb.clidb_eff_from_dt = clibm.clidb_eff_from_dt   
     AND    clibm.clidb_dpam_id = convert(int,@currstring_id)  
     AND    clibm.clidb_deleted_ind = 8  
     AND    clidb.clidb_deleted_ind = 1  
            end  
                   UPDATE CLIB_MAK   
                   SET    CLIDB_DELETED_IND = 9   
                   where clidb_dpam_id =  convert(int,@currstring_id)  
       AND   clidb_deleted_ind = 8   
              
    
          --  
          end  
        --  
        END  
        IF @pa_action = 'REJ'  
        BEGIN  
        --  
          update clib_mak   
          set    clidb_deleted_ind = 3  
          where clidb_dpam_id      =  convert(int,@currstring_id)  
          AND   clidb_deleted_ind in (0,4,8)  
        --  
        END  
          
      --  
      END  --@currstring_id  
    --    
    END--@@remainingstring_id    
  --  
  END--app_rej_1  
  --  
  end  
    
  SET @pa_msg = ISNULL(@l_errorstr, '')  
  --  
    
--  
END --MAIN BEGIN

GO
