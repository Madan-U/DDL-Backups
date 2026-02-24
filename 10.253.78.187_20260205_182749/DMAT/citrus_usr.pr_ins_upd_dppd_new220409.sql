-- Object: PROCEDURE citrus_usr.pr_ins_upd_dppd_new220409
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*
ALTER TABLE dp_poa_dtls ADD dppd_master_id varchar(25)
ALTER TABLE dp_poa_dtls_mak ADD dppd_master_id varchar(25)
ALTER TABLE dppd_hst ADD dppd_master_id varchar(25)
*/
--	pr_ins_upd_dppd 	'1','101','	EDT','	VISHAL','	1|*~|3|*~|12345678|*~|1234567890123456|*~|FULL|*~|1ST HOLDER|*~|HETAL|*~|SACHIN|*~|DEVLEKAR|*~||*~||*~||*~||*~|01|*~|B|*~|19/10/2008|*~|19/10/2008|*~||*~|2205680000000089|*~|01|*~|E*|~*',	1,'	*|~*','	|*~|	',''
--pr_ins_upd_dppd '1',128366,'EDT','REAYMIN','1|*~|3|*~|12033300|*~|56|*~|BROKING|*~|1ST HOLDER|*~|JM FINANCIAL SERVICES PVT LTD|*~||*~|ERE|*~||*~||*~|M|*~|ERRRR1234E|*~|1|*~|B|*~|12/12/1989|*~|12/12/1989|*~||*~|1|*~|E*|~*',0,'*|~*','|*~|',''	
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_dppd_new220409](@pa_id                varchar(8000)  
                                ,@pa_crn_no            numeric  
                                ,@pa_action            char(3)  
                                ,@pa_login_name        varchar(20)  
                                ,@pa_values            varchar(8000)  
                                ,@pa_chk_yn            numeric  
                                ,@rowdelimiter         char(4)  = '*|~*'  
                                ,@coldelimiter         char(4)  = '|*~|'  
                                ,@pa_msg               varchar(8000) output  
)  
as  
/*  
*********************************************************************************  
 system         : Citrus  
 module name    : pr_ins_upd_DPPD  
 description    : this procedure will add new client details VALUES to DP_POA_DTLS  
 copyright(c)   : marketplace technologies pvt. Ltd.  
 version history: 1.0  
 vers.  author            date         reason  
 -----  -------------     ----------   ------------------------------------------  
 1.0    tushar            19-DEC-2007  initial version.  
 --------------------------------------------------------------------------------  
*********************************************************************************  
*/  
BEGIN--#1  
--  
  SET NOCOUNT ON  
  --  
  DECLARE @t_errorstr            varchar(8000)  
        , @l_error               bigint  
        , @delimeter             varchar(5)  
        , @remainingstring       varchar(8000)  
        , @currstring            varchar(8000)  
        , @remainingstring2      varchar(8000)  
        , @currstring2           varchar(8000)  
        , @foundat               integer  
        , @delimeterlength       int  
        , @l_counter             int  
        , @l_flg                 int  
        --  
        , @l_poa_fname          varchar(100)  
        , @l_poa_mname          varchar(50)   
        , @l_poa_lname          varchar(50)  
        , @l_poa_fthname        varchar(50)  
        , @l_poa_dob            varchar(20)
        , @l_poa_pan_no         varchar(15)  
        , @l_poa_gender         char(1)  
        , @l_poa_type           varchar(20)  
        , @l_holder             varchar(20)  
        ---  
        , @@l_bitrm_bit_location int  
        , @@l_deleted_ind        int  
        , @@l_clisba_id          numeric  
        , @l_action              char(1)  
        , @l_crn_no              varchar(10)       
        , @L_EDT_DEL_ID           NUMERIC  
        , @l_dpam_id             varchar(20)   
        --  
        , @poa_fname            varchar(100)  
        , @poa_mname            varchar(50)   
        , @poa_lname            varchar(50)   
        , @poa_fthname          varchar(100)  
        , @poa_dob              varchar(11)    
        , @poa_pan_no           varchar(15)   
        , @poa_gender           varchar(1)   
        , @l_action_type        varchar(20)  
        , @l_dppd_id            numeric  
        , @l_excsm_id           numeric  
        , @l_compm_id           numeric  
        , @l_dpid               varchar(25)  
        , @l_acct_no            varchar(20)   
        , @l_dppdmak_id         INT    
        , @l_dppd_deleted_ind   INT  
        , @l_dppd_id_old numeric 
        , @l_dppd_poa_id VARCHAR(16)
		, @l_dppd_setup varchar(20)
		, @l_dppd_gpabpa_flg CHAR(1)
		, @l_dppd_eff_fr_dt  varchar(20)
        , @l_dppd_eff_TO_dt  varchar(20)
         ,@l_id varchar(20)
         ,@L_dppd_master_id varchar(20)
        ,@l_int_dppd_id numeric
      /* , @l_clisba_acct_no  VARCHAR(25)   
       , @l_clisba_no          VARCHAR(25)   
       , @l_clisba_id           NUMERIC  
       , @l_clisba_crn_no    numeric  */  
        --  
  --   
  SET @l_crn_no     = @pa_crn_no  
  SET @l_flg        = 0  
   
  SET @t_errorstr  = ''        
  --  
  IF @pa_action     = 'APP' or @pa_action = 'REJ'  
  BEGIN--a  
  --    
    CREATE TABLE #dp_poa_dtls_mak  
    (dppd_id         numeric  
    ,dppd_dpam_id      numeric   
    ,dppd_hld          VARCHAR(20)  
    ,dppd_poa_type     VARCHAr(20)  
    ,dppd_poa_fname    varchar(100)   
    ,dppd_poa_mname    varchar(50)   
    ,dppd_poa_lname    varchar(50)   
    ,dppd_poa_fthname  varchar(100)   
    ,dppd_poa_dob      datetime  
    ,dppd_poa_pan_no   varchar(15)   
    ,dppd_poa_gender   varchar(1)  
    ,dppd_poa_id VARCHAR(16)
	,dppd_setup varchar(20)
	,dppd_gpabpa_flg CHAR(1)
	,dppd_eff_fr_dt varchar(20)
    ,dppd_eff_TO_dt  varchar(20)
    ,dppd_created_by   varchar(25)  
    ,dppd_created_dt   datetime   
    ,dppd_lst_upd_by   varchar(25)  
    ,dppd_lst_upd_dt   datetime   
    ,dppd_deleted_ind  smallint   
    ,dppd_master_id varchar(25)
    )  
    INSERT INTO #dp_poa_dtls_mak  
    (dppd_id          
    ,dppd_dpam_id       
    ,dppd_hld           
    ,dppd_poa_type      
    ,dppd_poa_fname     
    ,dppd_poa_mname     
    ,dppd_poa_lname     
    ,dppd_poa_fthname   
    ,dppd_poa_dob       
    ,dppd_poa_pan_no    
    ,dppd_poa_gender  
    ,dppd_poa_id 
				,dppd_setup 
				,dppd_gpabpa_flg 
				,dppd_eff_fr_dt  
    ,dppd_eff_TO_dt  
    ,dppd_created_by
    ,dppd_created_dt   
    ,dppd_lst_upd_by   
    ,dppd_lst_upd_dt   
    ,dppd_deleted_ind  
    ,dppd_master_id
    )  
    SELECT dppd_id          
    ,dppd_dpam_id       
    ,dppd_hld           
    ,dppd_poa_type      
    ,dppd_fname     
    ,dppd_mname     
    ,dppd_lname     
    ,dppd_fthname   
    ,dppd_dob       
    ,dppd_pan_no    
    ,dppd_gender 
    ,dppd_poa_id 
				,dppd_setup 
				,dppd_gpabpa_flg 
				,dppd_eff_fr_dt  
    ,dppd_eff_TO_dt 
     ,dppd_created_by
    ,dppd_created_dt   
    ,dppd_lst_upd_by   
    ,dppd_lst_upd_dt    
    ,dppd_deleted_ind  
    ,dppd_master_id
    FROM   dp_poa_dtls_mak  WITH (NOLOCK)  
    WHERE  dppd_deleted_ind IN (0,4,8)

  
  --    
  END--a  
  ELSE  
  BEGIN--b  
  --  
    CREATE TABLE #dp_poa_dtls_mstr  
    (dppd_id         numeric  
    ,dppd_dpam_id      numeric   
    ,dppd_hld          VARCHAR(20)  
    ,dppd_poa_type     VARCHAr(20)  
    ,dppd_fname    varchar(100)   
    ,dppd_mname    varchar(50)   
    ,dppd_lname    varchar(50)   
    ,dppd_fthname  varchar(100)   
    ,dppd_dob      datetime  
    ,dppd_pan_no   varchar(15)   
    ,dppd_gender   varchar(1)   
    ,dppd_poa_id VARCHAR(16)
				,dppd_setup varchar(20)
				,dppd_gpabpa_flg CHAR(1)
				,dppd_eff_fr_dt  varchar(20)
    ,dppd_eff_TO_dt  varchar(20)
    ,dppd_created_by   varchar(25)  
    ,dppd_created_dt   datetime   
    ,dppd_lst_upd_by   varchar(25)  
    ,dppd_lst_upd_dt   datetime   
    ,dppd_deleted_ind  smallint  
    ,dppd_master_id varchar(25)
    )  
    INSERT INTO #dp_poa_dtls_mstr  
    (dppd_id          
    ,dppd_dpam_id       
    ,dppd_hld           
    ,dppd_poa_type      
    ,dppd_fname     
    ,dppd_mname     
    ,dppd_lname     
    ,dppd_fthname   
    ,dppd_dob       
    ,dppd_pan_no   
    ,dppd_gender  
    ,dppd_poa_id 
				,dppd_setup 
				,dppd_gpabpa_flg 
				,dppd_eff_fr_dt  
    ,dppd_eff_TO_dt  
     ,dppd_created_by
    ,dppd_created_dt   
    ,dppd_lst_upd_by   
    ,dppd_lst_upd_dt   
    ,dppd_deleted_ind  
    ,dppd_master_id
    )  
    SELECT dppd_id  
   ,dppd_dpam_id  
   ,dppd_hld  
   ,dppd_poa_type  
   ,dppd_fname  
   ,dppd_mname  
   ,dppd_lname  
   ,dppd_fthname  
   ,dppd_dob  
   ,dppd_pan_no  
   ,dppd_gender  
   ,dppd_poa_id 
			,dppd_setup 
			,dppd_gpabpa_flg 
			,dppd_eff_fr_dt  
   ,dppd_eff_TO_dt  
    ,dppd_created_by
    ,dppd_created_dt   
    ,dppd_lst_upd_by   
    ,dppd_lst_upd_dt   
   ,dppd_deleted_ind  
   ,dppd_master_id
    FROM   dp_poa_dtls  WITH (NOLOCK)  
    WHERE  dppd_deleted_ind = 1   
  --                            
  END--b  
  --  
  IF ISNULL(@pa_id,'') <> '' AND ISNULL(@pa_login_name,'') <> ''  
  BEGIN--<>''  
  --  
    SET @l_error           = 0  
    SET @t_errorstr        = ''  
    SET @delimeter          = '%'+ @rowdelimiter + '%'  
    SET @delimeterlength   = len(@rowdelimiter)  
    SET @remainingstring2  = @pa_id  
    --  
    WHILE @remainingstring2 <> ''  
    BEGIN  
    --  
      SET @foundat        = 0  
      SET @foundat        =  patindex('%'+@delimeter+'%',@remainingstring2)  
      --  
      IF @foundat > 0  
      BEGIN  
      --  
        SET @currstring2      = substring(@remainingstring2, 0,@foundat)  
        SET @remainingstring2 = substring(@remainingstring2, @foundat+@delimeterlength,len(@remainingstring2)- @foundat+@delimeterlength)  
      --  
      END  
      ELSE  
      BEGIN  
      --  
        SET @currstring2      = @remainingstring2  
        SET @remainingstring2 = ''  
      --  
      END  
      --  
      IF @currstring2 <> ''  
      BEGIN--curr_id  
      --pa_id--  
        SET @delimeter        = '%'+ @rowdelimiter + '%'  
        SET @delimeterlength = len(@rowdelimiter)  
        SET @remainingstring = @pa_values  
        --  
        WHILE @remainingstring <> ''  
        BEGIN--VAL  
        --  
          SET @foundat       = 0  
          SET @foundat       =  patindex('%'+@delimeter+'%',@remainingstring)  
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
          BEGIN--curr_val  
      --  
            --+ Colparameterdelimeter + poaacid + Colparameterdelimeter + poagpa + Colparameterdelimeter + poasetup + Colparameterdelimeter + poefffrom + Colparameterdelimeter + poaeffto + Colparameterdelimeter + Colparameterdelimeter +'A' 
            
            SET @l_compm_id         = citrus_usr.fn_splitval(@currstring,1) 
            SET @l_excsm_id         = citrus_usr.fn_splitval(@currstring,2)  
            
            SET @l_dpid             = citrus_usr.fn_splitval(@currstring,3)  
            SET @l_acct_no          = case when left(@l_dpid,2)= 'IN' then replace(citrus_usr.fn_splitval(@currstring,4),citrus_usr.fn_splitval(@currstring,3),'') else citrus_usr.fn_splitval(@currstring,4) end 
            SET @l_poa_type         = citrus_usr.fn_splitval(@currstring,5)  
            SET @l_holder           = citrus_usr.fn_splitval(@currstring,6)  
            
            SET @l_poa_fname        = citrus_usr.fn_splitval(@currstring,7)  
            SET @l_poa_mname        = citrus_usr.fn_splitval(@currstring,8)  
            SET @l_poa_lname        = citrus_usr.fn_splitval(@currstring,9)  
            SET @l_poa_fthname      = citrus_usr.fn_splitval(@currstring,10)  
            SET @l_poa_dob          = citrus_usr.fn_splitval(@currstring,11)  
            SET @l_poa_gender       = citrus_usr.fn_splitval(@currstring,12)  
            SET @l_poa_pan_no       = citrus_usr.fn_splitval(@currstring,13)  
            set  @L_dppd_poa_id      = citrus_usr.fn_splitval(@currstring,14) 
            SET @L_dppd_gpabpa_flg  = citrus_usr.fn_splitval(@currstring,15)  
			         SET @l_dppd_setup       = citrus_usr.fn_splitval(@currstring,16)  
			         SET @L_dppd_eff_fr_dt   = citrus_usr.fn_splitval(@currstring,17)  
            SET @L_dppd_eff_TO_dt   = citrus_usr.fn_splitval(@currstring,18)
            SET @L_dppd_master_id   = citrus_usr.fn_splitval(@currstring,19)
            SET @l_id               = case when citrus_usr.fn_splitval(@currstring,14) = '' then '0' else citrus_usr.fn_splitval(@currstring,20)    end
print citrus_usr.fn_splitval(@currstring,21)  
            SET @l_int_dppd_id      = citrus_usr.fn_splitval(@currstring,21)  
            SET @l_action_type      = citrus_usr.fn_splitval(@currstring,22)  
            SET @l_id               = CASE WHEN @l_action_type      ='D' THEN citrus_usr.fn_splitval(@currstring,20) ELSE @l_id END  
            PRINT @l_id
            --  
            --  
            IF @pa_chk_yn = 0  
            BEGIN  
            --  
              SELECT @l_dpam_id         = dpam_id  
              FROM   dp_acct_mstr         WITH (NOLOCK)  
                    ,dp_mstr             
              WHERE  dpam_crn_no        = @pa_crn_no  
              AND    dpam_dpm_id        = dpm_id  
              AND    dpm_dpid           = @l_dpid  
              AND    dpam_excsm_id      = @l_excsm_id  
              AND    dpam_sba_no                  = @l_acct_no
              AND    dpam_deleted_ind   = 1  


            --  
            END  
            ELSE  
            BEGIN  
            --  
              IF EXISTS(SELECT dpam_id  
              FROM   dp_acct_mstr         WITH (NOLOCK)  
                    ,dp_mstr             
              WHERE  dpam_crn_no        = @pa_crn_no  
              AND    dpam_dpm_id        = dpm_id  
              AND    dpm_dpid           = @l_dpid  
              AND    dpam_excsm_id      = @l_excsm_id  
			           AND    dpam_sba_no                  = @l_acct_no
              AND    dpam_deleted_ind   = 1)
              BEGIN
              --
               
                SELECT @l_dpam_id         = dpam_id  
                FROM   dp_acct_mstr         WITH (NOLOCK)  
                      ,dp_mstr             
                WHERE  dpam_crn_no        = @pa_crn_no  
                AND    dpam_dpm_id        = dpm_id  
                AND    dpm_dpid           = @l_dpid  
                AND    dpam_excsm_id      = @l_excsm_id  
                AND    dpam_deleted_ind   = 1  
				            AND    dpam_sba_no                  = @l_acct_no 
				          --
              END
              ELSE
              BEGIN
              --
                SELECT @l_dpam_id         = dpam_id  
                FROM   dp_acct_mstr_mak         WITH (NOLOCK)  
                      ,dp_mstr             
                WHERE  dpam_crn_no        = @pa_crn_no  
                AND    dpam_dpm_id        = dpm_id  
                AND    dpm_dpid           = @l_dpid  
                AND    dpam_excsm_id      = @l_excsm_id  
                AND    dpam_deleted_ind IN (0,8) 
				            AND    dpam_sba_no                  = @l_acct_no 
              --  
              END  
            END  
      --  
            IF @PA_CHK_YN = 0  
            BEGIN--CHK_YN=0  
            --  
              SELECT @l_dpam_id         = dpam_id  
              FROM   dp_acct_mstr         WITH (NOLOCK)  
                    ,dp_mstr             
              WHERE  dpam_crn_no        = @pa_crn_no  
              AND    dpam_dpm_id        = dpm_id  
              AND    dpm_dpid           = @l_dpid  
              AND    dpam_excsm_id      = @l_excsm_id  
              AND    dpam_deleted_ind   = 1  
			           AND    dpam_sba_no        = @l_acct_no
               
  
              
                
              IF @l_action_type = 'A'  
              BEGIN--A_0  
              --  
                BEGIN TRANSACTION  
                  
                SELECT @l_dppd_id = ISNULL(MAX(dppd_id),0)+ 1  
                FROM  dp_poa_dtls WITH (NOLOCK)  
              
                INSERT into dp_poa_dtls  
                (DPPD_ID  
                ,DPPD_DPAM_ID  
                ,DPPD_HLD  
                ,DPPD_POA_TYPE  
                ,DPPD_FNAME  
                ,DPPD_MNAME  
                ,DPPD_LNAME  
                ,DPPD_FTHNAME  
                ,DPPD_DOB  
                ,DPPD_PAN_NO  
                ,DPPD_GENDER 
                ,dppd_poa_id 
				,dppd_setup 
				,dppd_gpabpa_flg 
				,dppd_eff_fr_dt  
                ,dppd_eff_TO_dt  
                ,DPPD_CREATED_BY  
                ,DPPD_CREATED_DT  
                ,DPPD_LST_UPD_BY  
                ,DPPD_LST_UPD_DT  
                ,DPPD_DELETED_IND 
                ,dppd_master_id 
                )  
                VALUES  
                (@l_dppd_id   
                ,@l_dpam_id  
                ,@l_holder   
                ,@l_poa_type  
                ,@l_poa_fname  
                ,@l_poa_mname  
                ,@l_poa_lname  
                ,@l_poa_fthname  
                ,convert(datetime,@l_poa_dob,103)  
                ,@l_poa_pan_no  
                ,@l_poa_gender  
                ,@L_dppd_poa_id 
				,convert(datetime,@L_dppd_setup ,103)
				,@L_dppd_gpabpa_flg 
				,convert(datetime,@L_dppd_eff_fr_dt  ,103)
                ,convert(datetime,@L_dppd_eff_TO_dt  ,103)
                ,@pa_login_name  
                ,getdate()  
                ,@pa_login_name  
                ,getdate()  
                ,1  
                ,@L_dppd_master_id
                )  
                --  
                SET @l_error = @@error  
                --  
                IF @l_error > 0  
                BEGIN  
                --  
                  --SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')  
                  --  
                  ROLLBACK TRANSACTION  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  SET @t_errorstr = 'client poa details successfully inserted\edited '+ @rowdelimiter  
                  --  
                  COMMIT TRANSACTION  
                --  
                END  
              --  
              END--A_0  
              --  
              IF @l_action_type = 'E'  
              BEGIN--e_0  
              --  

                UPDATE dp_poa_dtls  
                SET    dppd_fname            = @l_poa_fname  
                      ,dppd_mname            = @l_poa_mname  
                      ,dppd_lname            = @l_poa_lname  
                      ,dppd_fthname          = @l_poa_fthname  
                      ,dppd_dob              = convert(datetime,@l_poa_dob ,103)  
                      ,dppd_poa_type         = @l_poa_type  
                      ,dppd_gender           = @l_poa_gender  
                      ,dppd_poa_id           = @L_dppd_poa_id           
					,dppd_setup            = convert(datetime,@L_dppd_setup  ,103 )
					,dppd_gpabpa_flg       = @L_dppd_gpabpa_flg       
					,dppd_eff_fr_dt        = convert(datetime,@L_dppd_eff_fr_dt ,103)       
                      ,dppd_eff_TO_dt        = convert(datetime,@L_dppd_eff_TO_dt ,103)       
                      ,dppd_lst_upd_dt       = getdate()  
                      ,dppd_lst_upd_by       = @pa_login_name  
                      ,dppd_master_id        = @L_dppd_master_id
                FROM   dp_acct_mstr            dpam        
                WHERE  dppd_dpam_id          = dpam.dpam_id    
                AND    dppd_DPAM_ID          = @l_dpam_id                 
                AND    dppd_poa_ID               = @l_id                 
                AND    dppd_deleted_ind      = 1
              --  
              END  --e_0  
              --  
              IF @l_action_type = 'D'  
              BEGIN--d_0  
              --  
                BEGIN TRANSACTION  
                --  
                  UPDATE dp_poa_dtls  
                  SET    dppd_deleted_ind      = 0  
                        ,dppd_lst_upd_dt       = getdate()  
                        ,dppd_lst_upd_by       = @pa_login_name  
                  FROM   dp_acct_mstr                           
                  WHERE  dppd_dpam_id          = dpam_id    
                  AND    dppd_DPAM_ID          = @l_dpam_id                  
                  AND    dppd_poa_ID               = @l_id                 
                  AND    dppd_deleted_ind      = 1   
                --  
                SET @l_error = @@error  
                --  
                IF @l_error > 0  
                BEGIN  
                --  
                  --SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')  
                  --  
                  ROLLBACK TRANSACTION  
                --  
                END  
                ELSE  
                BEGIN  
                --  
                  SET @t_errorstr = 'client poa details successfully inserted\edited '+ @rowdelimiter  
                  --  
                  COMMIT TRANSACTION  
                --  
                END  
              --  
              END  --d_0  
            --  
            END--chk_yn=0  
            IF @pa_chk_yn = 1  OR @pa_chk_yn = 2       
            BEGIN--chk_1_2  
            --  
            IF @pa_action = 'INS' or @pa_action = 'EDT' or @pa_action = 'DEL'  
            BEGIN  
            --  
              IF EXISTS(SELECT dppdm.dppd_dpam_id        dphd_id  
                        FROM   dp_poa_dtls_mak        dppdm WITH (NOLOCK)  
                        WHERE  dppdm.dppd_deleted_ind IN (0,4,8)  
                        AND    dppdm.dppd_dpam_id      = @l_dpam_id  
                        )  
              BEGIN  
              --  
                --BEGIN TRANSACTION  
                --  

                UPDATE dp_poa_dtls_mak    WITH (ROWLOCK)  
                SET    dppd_deleted_ind    = 3  
                WHERE  dppd_deleted_ind   IN (0,4,8)  
                AND    dppd_dpam_id        = @l_dpam_id 
                AND    dppd_id        = @l_int_dppd_id 
                --  
                --SET @l_error = @@ERROR  
                --  
                --IF @l_error > 0  
                --BEGIN  
                --  
                --  SET @l_errorstr = '#'+@l_errorstr+convert(varchar,'0')+@coldelimiter+isnull(@pa_sba_no,'')+@coldelimiter+convert(varchar,@l_error)+@coldelimiter+@rowdelimiter   
                  --  
                --  ROLLBACK TRANSACTION   
                --  
                --END  
                --ELSE  
                --BEGIN  
                --  
                --  COMMIT TRANSACTION  
                --  
                --END  
              --  
              END  
              --  
              IF @pa_action = 'EDT' AND EXISTS(SELECT * FROM dp_poa_dtls WHERE dppd_dpam_id = convert(numeric, @l_dpam_id))   and @l_action_type = 'E'
              BEGIN  
              --  
                SET @l_edt_del_id = 8  



				select @l_dppd_id_old = dppd_id 
				from   dp_poa_dtls 
				where  dppd_dpam_id   = @l_dpam_id
				AND    dppd_id    = @l_int_dppd_id
				AND    dppd_deleted_ind =1 




              --  
              END  
              ELSE  
              BEGIN  
              --  
                SET @l_edt_del_id = 0  
              --  
              END  
              --  
              BEGIN TRANSACTION  
              --  
              SELECT @l_dppdmak_id = isnull(max(dppd_id),0) + 1     
              FROM   dp_poa_dtls_mak  WITH (NOLOCK)    
  
              SELECT @l_dppd_id = isnull(max(dppd_id),0) + 1     
              FROM   dp_poa_dtls  WITH (NOLOCK)    
  
              if @l_dppdmak_id > @l_dppd_id  
              begin  
              --  
                set  @l_dppd_id = @l_dppdmak_id  
              --  
              end  
              --  

              SET @l_dppd_id = CASE WHEN @l_action_type = 'D' THEN @l_int_dppd_id ELSE @l_dppd_id END  

              INSERT INTO dp_poa_dtls_mak  
              (dppd_id  
              ,dppd_dpam_id  
              ,dppd_hld  
              ,dppd_poa_type  
              ,dppd_fname  
              ,dppd_mname  
              ,dppd_lname  
              ,dppd_fthname  
              ,dppd_dob  
              ,dppd_pan_no  
              ,dppd_gender  
              ,dppd_poa_id 
														,dppd_setup 
														,dppd_gpabpa_flg 
														,dppd_eff_fr_dt  
              ,dppd_eff_TO_dt  
              ,dppd_created_by  
              ,dppd_created_dt  
              ,dppd_lst_upd_by  
              ,dppd_lst_upd_dt  
              ,dppd_deleted_ind  
              ,dppd_master_id
              )  
              VALUES  
              (CASE @l_edt_del_id WHEN 0 THEN @l_dppd_id  else @l_dppd_id_old end  
              ,@l_dpam_id  
              ,@l_holder   
              ,@l_poa_type  
              ,@l_poa_fname  
              ,@l_poa_mname  
              ,@l_poa_lname  
              ,@l_poa_fthname  
              ,convert(datetime,@l_poa_dob ,103) 
              ,@l_poa_pan_no  
              ,@l_poa_gender  
              ,@L_dppd_poa_id 
				,convert(datetime,@L_dppd_setup ,103)
				,@L_dppd_gpabpa_flg 
				,convert(datetime,@L_dppd_eff_fr_dt  ,103)
              ,convert(datetime,@L_dppd_eff_TO_dt  ,103)
              ,@pa_login_name  
              ,getdate()  
              ,@pa_login_name  
              ,getdate()  
              ,CASE @l_action_type WHEN 'A' THEN 0  
                               WHEN 'E' THEN @l_edt_del_id   
                               WHEN 'D' THEN 4 END
                               ,@L_dppd_master_id  
              )  
              --  
              SET @l_error = @@ERROR  
              --  
              IF @l_error > 0  
              BEGIN  
              --  
                --SET @t_errorstr = '#'+@t_errorstr+convert(varchar,'0')+@coldelimiter+isnull(@pa_sba_no,'')+@coldelimiter+convert(varchar,@l_error)+@coldelimiter+@rowdelimiter   
                --  
                ROLLBACK TRANSACTION   
              --  
              END  
              ELSE  
              BEGIN  
              --  
                SET @t_errorstr = 'dp poa details successfully inserted\edited '+ @rowdelimiter  
                --  
                COMMIT TRANSACTION   
                --  
                SELECT @l_action = case @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END  
                SELECT @pa_id    = dpam_crn_no     FROM dp_acct_mstr_mak WHERE dpam_id = @l_dpam_id  
                --  
                EXEC pr_ins_upd_list @pa_id, @l_action,'dp poa dtls', @pa_login_name, '*|~*', '|*~|', ''   
              --  
              END  
            --    
            END  
          --  
          END--chk_1_2  
        --  
        end  
      --  
      end  
      --    
      END  --curr_id  
      IF @pa_action = 'APP'  
      BEGIN--app  
      --  
  
        SELECT @l_dppd_deleted_ind = dppd_deleted_ind  
             , @l_dpam_id          = dppd_dpam_id  
        FROM   #dp_poa_dtls_mak      WITH (NOLOCK)  
        WHERE  dppd_id             = convert(numeric, @currstring2)   
        --  
        IF @l_dppd_deleted_ind = 4  
        BEGIN--4  
        --  
  
          --  
          UPDATE dp_poa_dtls          WITH (ROWLOCK)       
          SET    dppd_deleted_ind   = 0  
               , dppd_lst_upd_by    = @pa_login_name  
               , dppd_lst_upd_dt    = GETDATE()  
          WHERE  dppd_deleted_ind   = 1  
          AND    dppd_dpam_id       = @l_dpam_id  
          AND    dppd_id            = CONVERT(numeric, @currstring2)    
          --  
  
          --  
          UPDATE dp_poa_dtls_mak   WITH (ROWLOCK)         
          SET    dppd_deleted_ind   = 5  
               , dppd_lst_upd_by    = @pa_login_name  
               , dppd_lst_upd_dt    = GETDATE()  
          WHERE  dppd_deleted_ind   = 4  
          AND    dppd_id            = CONVERT(numeric, @currstring2)    
  
  
        --  
        END--4  
        --  
        IF @l_dppd_deleted_ind = 8  
        BEGIN--8  
        --  
  
           
          UPDATE dppd                   WITH (ROWLOCK)  
          SET    dppd.dppd_fname            = dppdm.dppd_fname              
                ,dppd.dppd_mname            = dppdm.dppd_mname              
                ,dppd.dppd_lname            = dppdm.dppd_lname              
                ,dppd.dppd_fthname          = dppdm.dppd_fthname            
                ,dppd.dppd_dob              = dppdm.dppd_dob                
                ,dppd.dppd_poa_type         = dppdm.dppd_poa_type           
                ,dppd.dppd_gender           = dppdm.dppd_gender            
                ,dppd.dppd_poa_id           = dppdM.dppd_poa_id     
																,dppd.dppd_setup            = dppdM.dppd_setup            
																,dppd.dppd_gpabpa_flg       = dppdM.dppd_gpabpa_flg       
																,dppd.dppd_eff_fr_dt        = dppdM.dppd_eff_fr_dt        
                ,dppd.dppd_eff_TO_dt        = dppdM.dppd_eff_TO_dt        
                ,dppd.dppd_lst_upd_dt       = getdate()  
                ,dppd.dppd_lst_upd_by       = @pa_login_name  
                ,dppd_master_id             = dppdM.dppd_master_id
          FROM   dp_poa_dtls_mak       dppdm       
               , dp_poa_dtls           dppd   
          WHERE  dppdm.dppd_dpam_id     = @l_dpam_id  
          AND    dppd.dppd_id           = dppdm.dppd_id  
          AND    dppd.dppd_deleted_ind  = 1  
          AND    dppdm.dppd_deleted_ind = 8  
          AND    dppdm.dppd_id            = convert(numeric, @currstring2)            
            
            
          UPDATE dp_poa_dtls_mak   WITH (ROWLOCK)            
          SET    dppd_deleted_ind   = 9            
               , dppd_lst_upd_by    = @pa_login_name            
               , dppd_lst_upd_dt    = getdate()            
          WHERE  dppd_deleted_ind   = 8            
          AND    dppd_id            = convert(numeric, @currstring2)            
  
        --               
        END--8  
        --  
        IF @l_dppd_deleted_ind = 0             
        BEGIN--0            
        --  
  
          --  
          UPDATE dp_poa_dtls_mak  WITH (ROWLOCK)            
          SET    dppd_deleted_ind  = 1            
               , dppd_lst_upd_by   = @pa_login_name            
               , dppd_lst_upd_dt   = GETDATE()            
          WHERE  dppd_deleted_ind  = 0            
          AND    dppd_id        = convert(numeric, @currstring2)            
          --            
  
          INSERT INTO dp_poa_dtls  
          (dppd_id  
          ,dppd_dpam_id  
          ,dppd_hld  
          ,dppd_poa_type  
          ,dppd_fname  
          ,dppd_mname  
          ,dppd_lname  
          ,dppd_fthname  
          ,dppd_dob  
          ,dppd_pan_no  
          ,dppd_gender  
          ,dppd_poa_id 
										,dppd_setup 
										,dppd_gpabpa_flg 
										,dppd_eff_fr_dt  
          ,dppd_eff_TO_dt  
          ,dppd_created_by  
          ,dppd_created_dt  
          ,dppd_lst_upd_by  
          ,dppd_lst_upd_dt  
          ,dppd_deleted_ind  
          ,dppd_master_id
           )  
           SELECT dppd_id  
          ,dppd_dpam_id  
          ,dppd_hld  
          ,dppd_poa_type      
          ,dppd_poa_fname     
										,dppd_poa_mname     
										,dppd_poa_lname     
										,dppd_poa_fthname   
										,dppd_poa_dob       
										,dppd_poa_pan_no    
										,dppd_poa_gender  
										,dppd_poa_id 
										,dppd_setup 
										,dppd_gpabpa_flg 
										,dppd_eff_fr_dt  
          ,dppd_eff_TO_dt  
          ,dppd_created_by  
          ,dppd_created_dt  
          ,dppd_lst_upd_by  
          ,dppd_lst_upd_dt  
          ,1  
          ,dppd_master_id
          FROM   #dp_poa_dtls_mak WITH (NOLOCK)  
          WHERE  dppd_id        = convert(numeric, @currstring2)   
  
        --   
        END--0  
      --  
      END--app  
      --  
      IF @pa_action = 'REJ'            
      BEGIN--rej            
      --  
  
        UPDATE dp_poa_dtls_mak       WITH (ROWLOCK)            
        SET    dppd_deleted_ind  = 3            
             , dppd_lst_upd_by   = @pa_login_name            
             , dppd_lst_upd_dt   = getdate()             
        WHERE  dppd_id        = convert(numeric, @currstring2)            
        AND    dppd_deleted_ind IN (0,4,8)            
  
      --            
      END--rej  
    --    
    END--WHILE id    
  --  
  END  --<>''  
  --  
  SET @pa_msg = @t_errorstr  
--    
END  --#1

GO
