-- Object: PROCEDURE citrus_usr.pr_ins_upd_dphd
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_ins_upd_dphd '101','101','IN30017510000004','EDT','HO','NULL|*~|NULL|*~|NULL|*~|DORAISWAMY NAIDU.V. MR.|*~|NULL|*~|NULL|*~|NULL|*~|*|~*','NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|M|*~|*|~*','NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|M|*~|*|~*','SSASASA|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|M|*~|*|~*','AMIRTHALAKSHMI. B|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|M|*~||*~|*|~*','NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|NULL|*~|M|*~|*|~*','0','*|~*','|*~|',''	
--begin transaction--59770
--pr_ins_upd_dphd '58*|~*','54889','','APP','HO','','','','','','',1,'*|~*','|*~|',''   
--select * from dp_holder_dtls where dphd_dpam_id in ('59771','59770')
--select * from dp_holder_dtls_mak where dphd_dpam_id in ('59771','59770') and dphd_deleted_ind in (0,4,8)
--update dp_holder_dtls_mak  set dphd_deleted_ind = 8 where dphdmak_id in (58,59)
--rollback transaction
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_dphd](@pa_id            varchar(8000)   
                                ,@pa_crn_no       numeric  
                                ,@pa_sba_no       varchar(8000)    
                                ,@pa_action       char(3)  
                                ,@pa_login_name   varchar(20)  
                                ,@pa_fh_dtls      varchar(100)     
                                ,@pa_sh_dtls      varchar(8000)  
                                ,@pa_th_dtls      varchar(8000)  
                                ,@pa_nomgau_dtls     varchar(8000)   
                                ,@pa_nom_dtls     varchar(8000)   
                                ,@pa_gau_dtls     varchar(8000)   
                                ,@pa_chk_yn       numeric  
                                ,@rowdelimiter    char(4)  = '*|~*'  
                                ,@coldelimiter    char(4)  = '|*~|'  
                                ,@pa_msg          varchar(8000) OUTPUT  
                                )  
AS  
/*  
*********************************************************************************  
 SYSTEM         : Citrus  
 MODULE NAME    : pr_ins_upd_dphd  
 DESCRIPTION    : this procedure will add new client dp holder details values to dp_holder_dtls  
 COPYRIGHT(C)   : Marketplace Technologies Pvt.Ltd.  
 VERSION HISTORY:  
 VERS.  AUTHOR            DATE         REASON  
 -----  -------------     ----------   ------------------------------------------  
 1.0    Sukhvinder        08-AUG-2006  INITIAL VERSION.  
---------------------------------------------------------------------------------  
*********************************************************************************  
*/  
BEGIN--#1  
--  
  DECLARE @delimeter            char(4)  
        , @delimeterlength      int  
        , @remainingstring_id   varchar(8000)  
        , @currstring_id        varchar(8000)  
        , @foundat_id           integer  
        --  
        , @remainingstring      varchar(8000)  
        , @currstring           varchar(8000)  
        , @foundat              integer  
        --  
        , @l_errorstr           varchar(8000)   
        , @l_error              numeric  
        , @l_dpam_id            numeric  
        , @l_form_no            varchar(20)  
        --  
        , @l_fh_name            varchar(100)    
        --  
        , @l_sh_fname           varchar(100)  
        , @l_sh_mname           varchar(50)  
        , @l_sh_lname           varchar(50)  
        , @l_sh_fthname         varchar(50)  
        , @l_sh_dob             varchar(12)  
        , @l_sh_pan_no          varchar(15)  
        , @l_sh_gender          char(1)  
        --  
        , @l_th_fname           varchar(100)  
        , @l_th_mname           varchar(50)  
        , @l_th_lname           varchar(50)  
        , @l_th_fthname         varchar(50)  
        , @l_th_dob             varchar(12)  
        , @l_th_pan_no          varchar(15)  
        , @l_th_gender          char(1)  
        --  
        , @l_nomgau_fname          varchar(100)  
        , @l_nomgau_mname          varchar(50)   
        , @l_nomgau_lname          varchar(50)  
        , @l_nomgau_fthname        varchar(50)  
        , @l_nomgau_dob            varchar(12)  
        , @l_nomgau_pan_no         varchar(15)  
        , @l_nomgau_gender         char(1)  
        --  
        , @l_nom_fname          varchar(100)  
        , @l_nom_mname          varchar(50)  
        , @l_nom_lname          varchar(50)   
        , @l_nom_fthname        varchar(50)  
        , @l_nom_dob            varchar(12)     
        , @l_nom_pan_no         varchar(15)  
        , @l_nom_gender         char(1)  
        , @L_NOM_NRN_NO         VARCHAR(20)
        --  
        , @l_gau_fname          varchar(100)  
        , @l_gau_mname          varchar(50)   
        , @l_gau_lname          varchar(50)  
        , @l_gau_fthname        varchar(50)  
        , @l_gau_dob            varchar(12)   
        , @l_gau_pan_no         varchar(15)  
        , @l_gau_gender         char(1)  
        --  
        , @l_entpm_prop_id      numeric  
        , @l_enttm_cd           varchar(25)  
        , @l_clicm_cd           varchar(20)  
        , @l_values             varchar(250)  
        , @l_crn_no             numeric  
        , @l_dphd_dpam_sba_no   varchar(20)  
        , @l_dphdmak_id         numeric  
        , @l_edt_del_id         numeric  
        , @l_action             char(1)  
        , @l_dphd_deleted_ind   numeric  
        --  
        , @mak_id               numeric(10)  
        , @dpam_id              numeric(10)  
        , @dpam_sba_no          varchar(20)   
        , @sh_fname             varchar(100)  
        , @sh_mname             varchar(50)   
        , @sh_lname             varchar(50)   
        , @sh_fthname           varchar(100)  
        , @sh_dob               varchar(11)   
        , @sh_pan_no            varchar(15)   
        , @sh_gender            varchar(1)   
        , @th_fname             varchar(100)  
        , @th_mname             varchar(50)   
        , @th_lname             varchar(50)   
        , @th_fthname           varchar(100)  
        , @th_dob               varchar(11)    
        , @th_pan_no            varchar(15)   
        , @th_gender            varchar(1)   
        , @nomgau_fname            varchar(100)  
        , @nomgau_mname            varchar(50)   
        , @nomgau_lname            varchar(50)   
        , @nomgau_fthname          varchar(100)  
        , @nomgau_dob              varchar(11)    
        , @nomgau_pan_no           varchar(15)   
        , @nomgau_gender           varchar(1)   
        , @nom_fname            varchar(100)  
        , @nom_mname            varchar(50)   
        , @nom_lname            varchar(50)   
        , @nom_fthname          varchar(100)  
        , @nom_dob              varchar(11)   
        , @nom_pan_no           varchar(15)   
        , @nom_gender           varchar(1)   
        , @gau_fname            varchar(100)  
        , @gau_mname            varchar(50)   
        , @gau_lname            varchar(50)   
        , @gau_fthname          varchar(100)  
        , @gau_dob              varchar(11)    
        , @gau_pan_no           varchar(15)   
        , @gau_gender           varchar(1)   
        , @lst_upd_by           varchar(25)   
        , @lst_upd_dt           varchar(11)   
        , @deleted_ind          smallint  
        , @fh_fthname           varchar(100)  
        , @l_chk_in             char(2)  
  --  
  IF @pa_action = 'APP'   
  BEGIN  
  --  
    CREATE TABLE #dp_holder_dtls_mak  
    (dphdmak_id        numeric  
    ,dphd_dpam_id      numeric   
    ,dphd_dpam_sba_no  varchar(20)  
    ,dphd_sh_fname     varchar(100)   
    ,dphd_sh_mname     varchar(50)   
    ,dphd_sh_lname     varchar(50)   
    ,dphd_sh_fthname   varchar(100)   
    ,dphd_sh_dob       datetime  
    ,dphd_sh_pan_no    varchar(15)   
    ,dphd_sh_gender    varchar(1)   
    ,dphd_th_fname     varchar(100)   
    ,dphd_th_mname     varchar(50)   
    ,dphd_th_lname     varchar(50)   
    ,dphd_th_fthname   varchar(100)   
    ,dphd_th_dob       datetime  
    ,dphd_th_pan_no    varchar(15)   
    ,dphd_th_gender    varchar(1)   
    ,dphd_nomgau_fname    varchar(100)   
    ,dphd_nomgau_mname    varchar(50)   
    ,dphd_nomgau_lname    varchar(50)   
    ,dphd_nomgau_fthname  varchar(100)   
    ,dphd_nomgau_dob      datetime  
    ,dphd_nomgau_pan_no   varchar(15)   
    ,dphd_nomgau_gender   varchar(1)   
    ,dphd_nom_fname    varchar(100)   
    ,dphd_nom_mname    varchar(50)   
    ,dphd_nom_lname    varchar(50)   
    ,dphd_nom_fthname  varchar(100)   
    ,dphd_nom_dob      datetime  
    ,dphd_nom_pan_no   varchar(15)   
    ,dphd_nom_gender   varchar(1)   
    ,dphd_gau_fname    varchar(100)   
    ,dphd_gau_mname    varchar(50)   
    ,dphd_gau_lname    varchar(50)   
    ,dphd_gau_fthname  varchar(100)   
    ,dphd_gau_dob      datetime  
    ,dphd_gau_pan_no   varchar(15)   
    ,dphd_gau_gender   varchar(1)   
    ,dphd_created_by   varchar(25)  
    ,dphd_created_dt   datetime   
    ,dphd_lst_upd_by   varchar(25)  
    ,dphd_lst_upd_dt   datetime   
    ,dphd_deleted_ind  smallint   
    ,dphd_fh_fthname   varchar(100)  
    ,NOM_NRN_NO   varchar(100)
    )  
    --  
    INSERT INTO #dp_holder_dtls_mak  
    (dphdmak_id        
    ,dphd_dpam_id      
    ,dphd_dpam_sba_no   
    ,dphd_sh_fname      
    ,dphd_sh_mname      
    ,dphd_sh_lname      
    ,dphd_sh_fthname    
    ,dphd_sh_dob        
    ,dphd_sh_pan_no     
    ,dphd_sh_gender     
    ,dphd_th_fname      
    ,dphd_th_mname      
    ,dphd_th_lname      
    ,dphd_th_fthname    
    ,dphd_th_dob        
    ,dphd_th_pan_no     
    ,dphd_th_gender     
    ,dphd_nomgau_fname     
    ,dphd_nomgau_mname     
    ,dphd_nomgau_lname     
    ,dphd_nomgau_fthname   
    ,dphd_nomgau_dob       
    ,dphd_nomgau_pan_no    
    ,dphd_nomgau_gender    
    ,dphd_nom_fname     
    ,dphd_nom_mname     
    ,dphd_nom_lname     
    ,dphd_nom_fthname   
    ,dphd_nom_dob        
    ,dphd_nom_pan_no   
    ,dphd_nom_gender      
    ,dphd_gau_fname      
    ,dphd_gau_mname      
    ,dphd_gau_lname      
    ,dphd_gau_fthname    
    ,dphd_gau_dob        
    ,dphd_gau_pan_no      
    ,dphd_gau_gender  
    ,dphd_created_by   
    ,dphd_created_dt   
    ,dphd_lst_upd_by     
    ,dphd_lst_upd_dt     
    ,dphd_deleted_ind    
    ,dphd_fh_fthname   
    ,NOM_NRN_NO   
    )    
    SELECT dphd.dphdmak_id        
         , dphd.dphd_dpam_id      
         , dphd.dphd_dpam_sba_no   
         , dphd.dphd_sh_fname      
         , dphd.dphd_sh_mname      
         , dphd.dphd_sh_lname      
         , dphd.dphd_sh_fthname    
         , dphd.dphd_sh_dob        
         , dphd.dphd_sh_pan_no     
         , dphd.dphd_sh_gender     
         , dphd.dphd_th_fname      
         , dphd.dphd_th_mname      
         , dphd.dphd_th_lname      
         , dphd.dphd_th_fthname    
         , dphd.dphd_th_dob        
         , dphd.dphd_th_pan_no     
         , dphd.dphd_th_gender     
         , dphd.dphd_nomgau_fname     
         , dphd.dphd_nomgau_mname     
         , dphd.dphd_nomgau_lname     
         , dphd.dphd_nomgau_fthname   
         , dphd.dphd_nomgau_dob       
         , dphd.dphd_nomgau_pan_no    
         , dphd.dphd_nomgau_gender    
         , dphd.dphd_nom_fname     
         , dphd.dphd_nom_mname     
         , dphd.dphd_nom_lname     
         , dphd.dphd_nom_fthname   
         , dphd.dphd_nom_dob        
         , dphd.dphd_nom_pan_no   
         , dphd.dphd_nom_gender      
         , dphd.dphd_gau_fname      
         , dphd.dphd_gau_mname      
         , dphd.dphd_gau_lname      
         , dphd.dphd_gau_fthname    
         , dphd.dphd_gau_dob        
         , dphd.dphd_gau_pan_no      
         , dphd.dphd_gau_gender   
         , dphd.dphd_created_by  
         , dphd.dphd_created_dt  
         , dphd.dphd_lst_upd_by     
         , dphd.dphd_lst_upd_dt     
         , dphd.dphd_deleted_ind    
         , dphd.dphd_fh_fthname   
         , DPHD.NOM_NRN_NO   
    FROM   dp_holder_dtls_mak       dphd  WITH (NOLOCK)  
         , dp_acct_mstr             dpam  WITH (NOLOCK)   
    WHERE  dpam.dpam_crn_no       = @pa_crn_no  
    AND    dpam.dpam_id           = dphd.dphd_dpam_id  
    AND    dpam.dpam_deleted_ind  = 1  
    AND    dphd.dphd_deleted_ind in (0,4,8)  


    select * from #dp_holder_dtls_mak
  --  
  END  
  --  
  SET nocount on  
  SET @delimeter              = '%'+@rowdelimiter+'%'  
  SET @delimeterlength        = LEN(@rowdelimiter)  
  SET @remainingstring_id     = @pa_id  
  --  
  SET @l_chk_in = LEFT(@pa_sba_no,2)  
  --  
  IF rtrim(ltrim(@l_chk_in)) = 'IN'   
  BEGIN  
  --  
    SET @pa_sba_no = RIGHT(@pa_sba_no,len(@pa_sba_no)-8)   
  --  
  END  
  --sp_help dp_holder_dtls  
  IF @pa_chk_yn = 0    BEGIN  
  --  
    SELECT @dpam_id               = dphd_dpam_id       
         , @dpam_sba_no           = dphd_dpam_sba_no   
         , @sh_fname              = dphd_sh_fname      
         , @sh_mname              = dphd_sh_mname      
         , @sh_lname              = dphd_sh_lname      
         , @sh_fthname            = dphd_sh_fthname    
         , @sh_dob                = convert(varchar(12),isnull(dphd_sh_dob,null), 103)        
         , @sh_pan_no             = dphd_sh_pan_no     
         , @sh_gender             = dphd_sh_gender     
         , @th_fname              = dphd_th_fname      
         , @th_mname              = dphd_th_mname      
         , @th_lname              = dphd_th_lname      
         , @th_fthname            = dphd_th_fthname    
         , @th_dob                = convert(varchar(12),isnull(dphd_th_dob,null), 103)              
         , @th_pan_no             = dphd_th_pan_no     
         , @th_gender             = dphd_th_gender     
         , @nomgau_fname          = dphd_nomgau_fname     
         , @nomgau_mname          = dphd_nomgau_mname     
         , @nomgau_lname          = dphd_nomgau_lname     
         , @nomgau_fthname        = dphd_nomgau_fthname   
         , @nomgau_dob            = convert(varchar(12),isnull(dphd_nomgau_dob,null), 103)             
         , @nomgau_pan_no         = dphd_nomgau_pan_no    
         , @nomgau_gender         = dphd_nomgau_gender    
         , @nom_fname             = dphd_nom_fname     
         , @nom_mname             = dphd_nom_mname     
         , @nom_lname             = dphd_nom_lname     
         , @nom_fthname           = dphd_nom_fthname   
         , @nom_dob               = convert(varchar(12),isnull(dphd_nom_dob,null), 103)             
         , @nom_pan_no            = dphd_nom_pan_no    
         , @nom_gender            = dphd_nom_gender    
         , @gau_fname             = dphd_gau_fname     
         , @gau_mname             = dphd_gau_mname     
         , @gau_lname             = dphd_gau_lname     
         , @gau_fthname           = dphd_gau_fthname   
         , @gau_dob               = convert(varchar(12),isnull(dphd_gau_dob,null), 103)             
         , @gau_pan_no            = dphd_gau_pan_no    
         , @gau_gender            = dphd_gau_gender    
         , @lst_upd_by            = dphd_lst_upd_by    
         , @lst_upd_dt            = dphd_lst_upd_dt    
         , @deleted_ind           = isnull(dphd_deleted_ind,0)   
         , @fh_fthname            = dphd_fh_fthname    
         ,@L_NOM_NRN_NO           = NOM_NRN_NO   
    FROM   dp_holder_dtls           WITH (NOLOCK)  
    WHERE  dphd_dpam_sba_no       = convert(varchar, @pa_sba_no)  
    AND    dphd_deleted_ind       = 1  
  --  
  END  
  ELSE  
  BEGIN  
  --  
    SELECT @mak_id                = dphdmak_id        
         , @dpam_id               = dphd_dpam_id       
         , @dpam_sba_no           = dphd_dpam_sba_no   
         , @sh_fname              = dphd_sh_fname      
         , @sh_mname              = dphd_sh_mname      
         , @sh_lname              = dphd_sh_lname      
         , @sh_fthname            = dphd_sh_fthname    
         , @sh_dob                = convert(varchar(12),isnull(dphd_sh_dob,null), 103)              
         , @sh_pan_no             = dphd_sh_pan_no     
         , @sh_gender             = dphd_sh_gender     
         , @th_fname              = dphd_th_fname      
         , @th_mname              = dphd_th_mname      
         , @th_lname              = dphd_th_lname      
         , @th_fthname            = dphd_th_fthname    
         , @th_dob                = convert(varchar(12),isnull(dphd_th_dob,null), 103)              
         , @th_pan_no             = dphd_th_pan_no     
         , @th_gender             = dphd_th_gender     
         , @nomgau_fname          = dphd_nomgau_fname     
         , @nomgau_mname          = dphd_nomgau_mname     
         , @nomgau_lname          = dphd_nomgau_lname     
         , @nomgau_fthname        = dphd_nomgau_fthname   
         , @nomgau_dob    = convert(varchar(12),isnull(dphd_nomgau_dob,null), 103)             
         , @nomgau_pan_no         = dphd_nomgau_pan_no    
         , @nomgau_gender         = dphd_nomgau_gender    
         , @nom_fname             = dphd_nom_fname     
         , @nom_mname             = dphd_nom_mname     
         , @nom_lname             = dphd_nom_lname     
         , @nom_fthname           = dphd_nom_fthname   
         , @nom_dob               = convert(varchar(12),isnull(dphd_nom_dob,null), 103)             
         , @nom_pan_no            = dphd_nom_pan_no    
         , @nom_gender            = dphd_nom_gender    
         , @gau_fname             = dphd_gau_fname     
         , @gau_mname             = dphd_gau_mname     
         , @gau_lname             = dphd_gau_lname     
         , @gau_fthname           = dphd_gau_fthname   
         , @gau_dob               = convert(varchar(12),isnull(dphd_gau_dob,null), 103)             
         , @gau_pan_no            = dphd_gau_pan_no    
         , @gau_gender            = dphd_gau_gender    
         , @lst_upd_by            = dphd_lst_upd_by    
         , @lst_upd_dt            = dphd_lst_upd_dt    
         , @deleted_ind           = isnull(dphd_deleted_ind,0)   
         , @fh_fthname            = dphd_fh_fthname    
         , @L_NOM_NRN_NO          = NOM_NRN_NO    
    FROM   dp_holder_dtls_mak       WITH (NOLOCK)  
    WHERE  dphd_dpam_sba_no       = convert(varchar, @pa_sba_no)  
      
    AND    dphd_deleted_ind      IN (0,8)   
  --  
  END  
  --  
  WHILE isnull(@remainingstring_id,'') <> ''  
  BEGIN--wpa_id  
  --  
    SET @foundat_id           = 0  
    SET @foundat_id           =  patindex('%'+@delimeter+'%',@remainingstring_id)  
    --  
    IF @foundat_id > 0  
    BEGIN  
    --  
      SET @currstring_id      = substring(@remainingstring_id, 0,@foundat_id)  
      SET @remainingstring_id = substring(@remainingstring_id, @foundat_id+@delimeterlength,len(@remainingstring_id)- @foundat_id+@delimeterlength)  
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
    IF isnull(@currstring_id,'') <> ''  
    BEGIN--if_curid  
    --  
      SET @l_fh_name          = CASE WHEN convert(varchar(100), citrus_usr.fn_splitval(@pa_fh_dtls, 4)) = 'NULL' THEN @fh_fthname ELSE convert(varchar(100), citrus_usr.fn_splitval(@pa_fh_dtls, 4)) END  
      --        
      SET @currstring         = ''  
      SET @remainingstring    = @pa_sh_dtls  
      --  
      WHILE isnull(@remainingstring,'') <> ''  
      BEGIN--sh_rem  
      --  
        SET @foundat          = 0  
        SET @foundat          = patindex('%'+@delimeter+'%',@remainingstring)  
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
          SET @currstring       = @remainingstring  
          SET @remainingstring  = ''  
        --    
        END    
        --  
        IF isnull(@currstring,'') <> ''  
        BEGIN--if_sh  
        --  
          SELECT @l_sh_fname    = convert(varchar(100),CASE WHEN citrus_usr.fn_splitval(@currstring, 1) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 1) END)   
               , @l_sh_mname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 2) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 2) END)   
               , @l_sh_lname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 3) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 3) END)   
               , @l_sh_fthname  = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 4) = 'NULL' THEN '' ELSE citrus_usr.fn_splitval(@currstring, 4) END)   
               , @l_sh_dob      = convert(varchar(12), CASE WHEN citrus_usr.fn_splitval(@currstring, 5) = 'NULL' THEN ''     ELSE citrus_usr.fn_splitval(@currstring, 5) END)   
               , @l_sh_pan_no   = convert(varchar(15), CASE WHEN citrus_usr.fn_splitval(@currstring, 6) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 6) END)   
               , @l_sh_gender   = convert(char(1),     CASE WHEN citrus_usr.fn_splitval(@currstring, 7) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 7) END)   
         

         /* SELECT @l_sh_fname    = ISNULL(convert(varchar(100),citrus_usr.fn_splitval(@currstring, 1) ),'')   
               , @l_sh_mname    = ISNULL(convert(varchar(50), citrus_usr.fn_splitval(@currstring, 2) ) ,'')  
               , @l_sh_lname    = ISNULL(convert(varchar(50), Citrus_usr.fn_splitval(@currstring, 3) ),'')   
               , @l_sh_fthname  = ISNULL(convert(varchar(50),citrus_usr.fn_splitval(@currstring, 4) ) ,'')  
               , @l_sh_dob      = ISNULL(convert(varchar(50),citrus_usr.fn_splitval(@currstring, 5) ) ,'')  
               , @l_sh_pan_no   = ISNULL(convert(varchar(15),citrus_usr.fn_splitval(@currstring, 6) ),'')   
               , @l_sh_gender   = ISNULL(convert(char(1), citrus_usr.fn_splitval(@currstring, 7) ) ,'')  
*/



        --  
        END  --if_sh  
      --  
      END--sh_rem  
      --  
      SET @currstring           = ''  
      SET @remainingstring      = @pa_th_dtls  
      --  
      WHILE isnull(@remainingstring,'') <> ''  
      BEGIN--th_rem  
      --  
        SET @foundat            = 0  
        SET @foundat            =  patindex('%'+@delimeter+'%',@remainingstring)  
        --  
        IF @foundat > 0  
        BEGIN  
        --  
          SET @currstring       = substring(@remainingstring, 0,@foundat)  
          SET @remainingstring  = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @currstring       = @remainingstring  
          SET @remainingstring  = ''  
        --    
        END    
        --  
        IF isnull(@currstring,'') <> ''  
        BEGIN--if_th  
        --  
            
               
          SELECT @l_th_fname    = convert(varchar(100),CASE WHEN citrus_usr.fn_splitval(@currstring, 1) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 1) END)   
               , @l_th_mname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 2) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 2) END)   
               , @l_th_lname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 3) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 3) END)   
               , @l_th_fthname  = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 4) = 'NULL' THEN '' ELSE citrus_usr.fn_splitval(@currstring, 4) END)   
               , @l_th_dob      = convert(varchar(12), CASE WHEN citrus_usr.fn_splitval(@currstring, 5) = 'NULL' THEN ''     ELSE citrus_usr.fn_splitval(@currstring, 5) END)   
               , @l_th_pan_no   = convert(varchar(15), CASE WHEN citrus_usr.fn_splitval(@currstring, 6) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 6) END)   
               , @l_th_gender   = convert(char(1),     CASE WHEN citrus_usr.fn_splitval(@currstring, 7) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 7) END)  
          
        --  
        END  --if_th  
      --  
      END--th_rem  
      --  
      SET @currstring           = ''  
      SET @remainingstring      = @pa_nomgau_dtls  
      --  
      WHILE isnull(@remainingstring,'') <> ''  
      BEGIN--poa_rem  
      --  
        SET @foundat            = 0  
        SET @foundat            =  patindex('%'+@delimeter+'%',@remainingstring)  
        --  
        IF @foundat > 0  
        BEGIN  
        --  
          SET @currstring       = substring(@remainingstring, 0,@foundat)  
          SET @remainingstring  = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @currstring       = @remainingstring  
          SET @remainingstring  = ''  
        --    
        END    
        --  
        IF isnull(@currstring,'') <> ''  
        BEGIN--if_poa  
        --  
            
                 
          SELECT @l_nomgau_fname    = convert(varchar(100),CASE WHEN citrus_usr.fn_splitval(@currstring, 1) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 1) END)   
               , @l_nomgau_mname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 2) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 2) END)   
               , @l_nomgau_lname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 3) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 3) END)   
               , @l_nomgau_fthname  = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 4) = 'NULL' THEN '' ELSE citrus_usr.fn_splitval(@currstring, 4) END)   
               , @l_nomgau_dob      = convert(varchar(12), CASE WHEN citrus_usr.fn_splitval(@currstring, 5) = 'NULL' THEN ''     ELSE citrus_usr.fn_splitval(@currstring, 5) END)   
               , @l_nomgau_pan_no   = convert(varchar(15), CASE WHEN citrus_usr.fn_splitval(@currstring, 6) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 6) END)   
               , @l_nomgau_gender   = convert(char(1),     CASE WHEN citrus_usr.fn_splitval(@currstring, 7) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 7) END)        
        --         
        END--if_poa   
      --                       
      END--poa_rem  
      --  
      SET @currstring           = ''  
      SET @remainingstring      = @pa_nom_dtls  
      --  
      WHILE isnull(@remainingstring,'') <> ''  
      BEGIN--nom_rem  
      --  
        SET @foundat            = 0  
        SET @foundat            =  patindex('%'+@delimeter+'%',@remainingstring)  
        --  
        IF @foundat > 0  
        BEGIN  
        --  
          SET @currstring       = substring(@remainingstring, 0,@foundat)  
          SET @remainingstring  = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @currstring       = @remainingstring  
          SET @remainingstring  = ''  
        --    
        END    
        --  
        IF isnull(@currstring,'') <> ''  
        BEGIN--if_nom  
        --  
          

          SELECT @l_nom_fname    = convert(varchar(100),CASE WHEN citrus_usr.fn_splitval(@currstring, 1) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 1) END)   
               , @l_nom_mname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 2) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 2) END)   
               , @l_nom_lname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 3) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 3) END)   
               , @l_nom_fthname  = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 4) = 'NULL' THEN '' ELSE citrus_usr.fn_splitval(@currstring, 4) END)   
               , @l_nom_dob      = convert(varchar(12), CASE WHEN citrus_usr.fn_splitval(@currstring, 5) = 'NULL' THEN ''     ELSE citrus_usr.fn_splitval(@currstring, 5) END)   
               , @l_nom_pan_no   = convert(varchar(15), CASE WHEN citrus_usr.fn_splitval(@currstring, 6) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 6) END)   
               , @l_nom_gender   = convert(char(1),     CASE WHEN citrus_usr.fn_splitval(@currstring, 7) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 7) END)        
               , @L_NOM_NRN_NO   = convert(char(20),     CASE WHEN citrus_usr.fn_splitval(@currstring, 8) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 8) END)   



        --  
        END--if_nom  
      --    
      END--nom_rem  
      --  
      SET @currstring            = ''  
      SET @remainingstring       = @pa_gau_dtls  
      WHILE isnull(@remainingstring,'') <> ''  
      BEGIN--gad_rem  
      --  
        SET @foundat             = 0  
        SET @foundat             = patindex('%'+@delimeter+'%',@remainingstring)  
        --  
        IF @foundat > 0  
        BEGIN  
        --  
          SET @currstring        = substring(@remainingstring, 0,@foundat)  
          SET @remainingstring   = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)  
        --  
        END  
        ELSE  
        BEGIN  
        --  
          SET @currstring        = @remainingstring  
          SET @remainingstring   = ''  
        --    
        END    
        --  
        IF isnull(@currstring,'') <> ''  
        BEGIN--if_gau  
        --  
           
          SELECT @l_gau_fname    = convert(varchar(100),CASE WHEN citrus_usr.fn_splitval(@currstring, 1) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 1) END)   
               , @l_gau_mname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 2) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 2) END)   
               , @l_gau_lname    = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 3) = 'NULL' THEN ''   ELSE citrus_usr.fn_splitval(@currstring, 3) END)   
               , @l_gau_fthname  = convert(varchar(50), CASE WHEN citrus_usr.fn_splitval(@currstring, 4) = 'NULL' THEN '' ELSE citrus_usr.fn_splitval(@currstring, 4) END)   
               , @l_gau_dob      = convert(varchar(12), CASE WHEN citrus_usr.fn_splitval(@currstring, 5) = 'NULL' THEN ''     ELSE citrus_usr.fn_splitval(@currstring, 5) END)   
               , @l_gau_pan_no   = convert(varchar(15), CASE WHEN citrus_usr.fn_splitval(@currstring, 6) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 6) END)   
               , @l_gau_gender  = convert(char(1),     CASE WHEN citrus_usr.fn_splitval(@currstring, 7) = 'NULL' THEN ''  ELSE citrus_usr.fn_splitval(@currstring, 7) END)        
           

        --  
        END--if_gau  
      --    
      END--gad_rem  
      --  
      IF @pa_chk_yn = 0  
      BEGIN  
      --  
        SELECT @l_dpam_id        = dpam_id  
             , @l_enttm_cd       = dpam_enttm_cd  
             , @l_clicm_cd       = dpam_clicm_cd  
             , @l_crn_no         = dpam_crn_no  
        FROM   dp_acct_mstr        WITH (NOLOCK)   
        WHERE  dpam_sba_no       = @pa_sba_no  
        AND    dpam_deleted_ind  = 1  
      --  
      END  
      ELSE  
      BEGIN  
      --
      
        IF EXISTS(SELECT dpam_id  
             , dpam_enttm_cd  
             , dpam_clicm_cd  
             , dpam_crn_no  
        FROM   dp_acct_mstr_mak    WITH (NOLOCK)   
        WHERE  dpam_sba_no       = @pa_sba_no  
        AND    dpam_deleted_ind IN (0,8))
        BEGIN
        --  
          SELECT @l_dpam_id        = dpam_id  
               , @l_enttm_cd       = dpam_enttm_cd  
               , @l_clicm_cd       = dpam_clicm_cd  
               , @l_crn_no         = dpam_crn_no  
          FROM   dp_acct_mstr_mak    WITH (NOLOCK)   
          WHERE  dpam_sba_no       = @pa_sba_no  
          AND    dpam_deleted_ind IN (0,8)  
        --
        END
        ELSE
        BEGIN
        --
          SELECT @l_dpam_id        = dpam_id  
               , @l_enttm_cd       = dpam_enttm_cd  
               , @l_clicm_cd       = dpam_clicm_cd  
               , @l_crn_no         = dpam_crn_no  
          FROM   dp_acct_mstr        WITH (NOLOCK)   
          WHERE  dpam_sba_no       = @pa_sba_no  
          AND    dpam_deleted_ind  = 1  
        --
        END     

         
      --  
      END  
      --  
      IF @pa_chk_yn = 0  
      BEGIN--chk_0  
      --  
        IF @pa_action = 'INS'  
        BEGIN--ins_0  
        --  
          IF isnull(@l_dpam_id,0) <> 0  
          BEGIN--neq1_0  
          --  
            BEGIN TRANSACTION  
            --  
            INSERT INTO dp_holder_dtls  
            (dphd_dpam_id  
            ,dphd_dpam_sba_no  
            ,dphd_sh_fname  
            ,dphd_sh_mname  
            ,dphd_sh_lname  
            ,dphd_sh_fthname  
            ,dphd_sh_dob  
            ,dphd_sh_pan_no  
            ,dphd_sh_gender  
            ,dphd_th_fname  
            ,dphd_th_mname  
            ,dphd_th_lname  
            ,dphd_th_fthname  
            ,dphd_th_dob  
            ,dphd_th_pan_no  
            ,dphd_th_gender  
            ,dphd_nomgau_fname  
            ,dphd_nomgau_mname  
            ,dphd_nomgau_lname  
            ,dphd_nomgau_fthname  
            ,dphd_nomgau_dob  
            ,dphd_nomgau_pan_no  
            ,dphd_nomgau_gender  
            ,dphd_nom_fname  
            ,dphd_nom_mname  
            ,dphd_nom_lname  
            ,dphd_nom_fthname  
            ,dphd_nom_dob  
            ,dphd_nom_pan_no  
            ,dphd_nom_gender  
            ,dphd_gau_fname  
            ,dphd_gau_mname  
            ,dphd_gau_lname  
            ,dphd_gau_fthname  
            ,dphd_gau_dob  
            ,dphd_gau_pan_no  
            ,dphd_gau_gender  
            ,dphd_created_by  
            ,dphd_created_dt  
            ,dphd_lst_upd_by  
            ,dphd_lst_upd_dt  
            ,dphd_deleted_ind  
            ,dphd_fh_fthname  
            ,NOM_NRN_NO   
            )  
            VALUES  
            (@l_dpam_id      
            ,@pa_sba_no  
            ,@l_sh_fname     
            ,@l_sh_mname     
            ,@l_sh_lname     
            ,@l_sh_fthname   
            ,convert(datetime, @l_sh_dob, 103)       
            ,@l_sh_pan_no    
            ,@l_sh_gender    
            ,@l_th_fname     
            ,@l_th_mname     
            ,@l_th_lname     
            ,@l_th_fthname   
            ,convert(datetime,@l_th_dob,103)       
            ,@l_th_pan_no    
            ,@l_th_gender    
            ,@l_nomgau_fname    
            ,@l_nomgau_mname    
            ,@l_nomgau_lname    
            ,@l_nomgau_fthname  
            ,convert(datetime, @l_nomgau_dob, 103)  
            ,@l_nomgau_pan_no   
            ,@l_nomgau_gender   
            ,@l_nom_fname    
            ,@l_nom_mname    
            ,@l_nom_lname    
            ,@l_nom_fthname  
            ,convert(datetime,@l_nom_dob, 103)      
            ,@l_nom_pan_no   
            ,@l_nom_gender   
            ,@l_gau_fname    
            ,@l_gau_mname    
            ,@l_gau_lname    
            ,@l_gau_fthname  
            ,convert(datetime,@l_gau_dob, 103)      
            ,@l_gau_pan_no   
            ,@l_gau_gender  
            ,@pa_login_name  
            ,getdate()  
            ,@pa_login_name  
            ,getdate()  
            ,1  
            ,@l_fh_name  
            ,@L_NOM_NRN_NO   
            )  
            --  
         SET @l_error = @@error  
            --  
            IF @l_error <> 0  
            BEGIN  
            --  
              ROLLBACK TRANSACTION  
              --  
              --SET @l_errorstr = isnull(@l_errorstr,'') + 'Error '+ convert(varchar(10), @l_error)  
              SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @pa_sba_no) + isnull(@l_errorstr,'')  
              --  
              RETURN  
            --  
            END  
            ELSE  
            BEGIN  
            --  
              SET @l_errorstr = 'dp holder details successfully inserted\edited '+ @rowdelimiter  
              --  
              COMMIT TRANSACTION  
            --  
            END  
          --  
          END--neq1_0  
          ELSE  
          BEGIN--eq1_0  
          --  
            SET @pa_msg = isnull(@l_errorstr,'') + convert(varchar, @pa_sba_no) + ' form/demat id does exist'  
            --  
            RETURN  
          --  
          END--eq1_0  
        --  
        END--ins_0  
        --  
        IF @pa_action = 'EDT'  
        BEGIN--edt_0  
        --  
          IF EXISTS(SELECT dphd_dpam_id FROM dp_holder_dtls WHERE dphd_dpam_sba_no = @pa_sba_no and dphd_deleted_ind = 1)  
          BEGIN--exts  
          --  
            BEGIN TRANSACTION  
            --  

            UPDATE dp_holder_dtls     WITH (ROWLOCK)  
            SET    dphd_sh_fname    = @l_sh_fname   
                 , dphd_sh_mname    = @l_sh_mname  
                 , dphd_sh_lname    = @l_sh_lname  
                 , dphd_sh_fthname  = @l_sh_fthname  
                 , dphd_sh_dob      = convert(datetime,@l_sh_dob,103)  
                 , dphd_sh_pan_no   = @l_sh_pan_no  
                 , dphd_sh_gender   = @l_sh_gender  
                 , dphd_th_fname    = @l_th_fname  
                 , dphd_th_mname    = @l_th_mname  
                 , dphd_th_lname    = @l_th_lname  
                 , dphd_th_fthname  = @l_th_fthname  
                 , dphd_th_dob      = convert(datetime,@l_th_dob,103)  
                 , dphd_th_pan_no   = @l_th_pan_no  
                 , dphd_th_gender   = @l_th_gender  
                 , dphd_nomgau_fname   = @l_nomgau_fname  
                 , dphd_nomgau_mname   = @l_nomgau_mname  
                 , dphd_nomgau_lname   = @l_nomgau_lname  
                 , dphd_nomgau_fthname = @l_nomgau_fthname  
                 , dphd_nomgau_dob     = convert(datetime,@l_nomgau_dob,103)  
                 , dphd_nomgau_pan_no  = @l_nomgau_pan_no  
                 , dphd_nomgau_gender  = @l_nomgau_gender  
                 , dphd_nom_fname   = @l_nom_fname  
                 , dphd_nom_mname   = @l_nom_mname  
                 , dphd_nom_lname   = @l_nom_lname  
                 , dphd_nom_fthname = @l_nom_fthname  
                 , dphd_nom_dob     = convert(datetime,@l_nom_dob,103)  
                 , dphd_nom_pan_no  = @l_nom_pan_no  
                 , dphd_nom_gender  = @l_nom_gender  
                 , dphd_gau_fname   = @l_gau_fname  
                 , dphd_gau_mname   = @l_gau_mname  
                 , dphd_gau_lname   = @l_gau_lname  
                 , dphd_gau_fthname = @l_gau_fthname  
                 , dphd_gau_dob     = convert(datetime,@l_gau_dob,103)  
                 , dphd_gau_pan_no  = @l_gau_pan_no   
                 , dphd_gau_gender  = @l_gau_gender  
                 , dphd_fh_fthname  = @l_fh_name  
                 , dphd_lst_upd_by  = @pa_login_name  
                 , dphd_lst_upd_dt  = getdate()  
                 , NOM_NRN_NO       = @L_NOM_NRN_NO   
            WHERE  dphd_dpam_sba_no = @pa_sba_no  
            AND    dphd_deleted_ind = 1  
            --  
            SET @l_error = @@error  
            --  
            IF @l_error <> 0  
            BEGIN  
            --  
              ROLLBACK TRANSACTION  
              --  
              SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @pa_sba_no) + isnull(@l_errorstr,'')  
              --  
              RETURN  
            --  
            END  
            ELSE  
            BEGIN  
            --  
   SET @l_errorstr = 'dp holder details successfully inserted\edited '+ @rowdelimiter  
              --  
              COMMIT TRANSACTION  
            --    
            END    
          --  
          END  --exts  
          ELSE  
          BEGIN--nexts  
          --  
            BEGIN TRANSACTION  
            --  
            SELECT @l_dpam_id       = dpam_id  
            FROM   dp_acct_mstr       WITH (NOLOCK)   
            WHERE  dpam_sba_no      = @pa_sba_no  
            AND    dpam_deleted_ind = 1  
            --  
            IF isnull(@l_dpam_id,0) <> 0  
            BEGIN--neq2_0  
            --  
              INSERT INTO dp_holder_dtls  
              (dphd_dpam_id  
              ,dphd_dpam_sba_no  
              ,dphd_sh_fname  
              ,dphd_sh_mname  
              ,dphd_sh_lname  
              ,dphd_sh_fthname  
              ,dphd_sh_dob  
              ,dphd_sh_pan_no  
              ,dphd_sh_gender  
              ,dphd_th_fname  
              ,dphd_th_mname  
              ,dphd_th_lname  
              ,dphd_th_fthname  
              ,dphd_th_dob  
              ,dphd_th_pan_no  
              ,dphd_th_gender  
              ,dphd_nomgau_fname  
              ,dphd_nomgau_mname  
              ,dphd_nomgau_lname  
              ,dphd_nomgau_fthname  
              ,dphd_nomgau_dob  
              ,dphd_nomgau_pan_no  
              ,dphd_nomgau_gender  
              ,dphd_nom_fname  
              ,dphd_nom_mname  
              ,dphd_nom_lname  
              ,dphd_nom_fthname  
              ,dphd_nom_dob  
              ,dphd_nom_pan_no  
              ,dphd_nom_gender  
              ,dphd_gau_fname  
              ,dphd_gau_mname  
              ,dphd_gau_lname  
              ,dphd_gau_fthname  
              ,dphd_gau_dob  
              ,dphd_gau_pan_no  
              ,dphd_gau_gender  
              ,dphd_created_by  
              ,dphd_created_dt  
              ,dphd_lst_upd_by  
              ,dphd_lst_upd_dt  
              ,dphd_deleted_ind  
              ,dphd_fh_fthname  
              ,NOM_NRN_NO   
              )  
              VALUES  
              (@l_dpam_id      
              ,@pa_sba_no  
              ,@l_sh_fname     
              ,@l_sh_mname     
              ,@l_sh_lname     
              ,@l_sh_fthname   
              ,@l_sh_dob       
              ,@l_sh_pan_no    
              ,@l_sh_gender    
              ,@l_th_fname     
              ,@l_th_mname     
              ,@l_th_lname     
              ,@l_th_fthname   
              ,@l_th_dob       
              ,@l_th_pan_no    
              ,@l_th_gender    
              ,@l_nomgau_fname    
              ,@l_nomgau_mname    
              ,@l_nomgau_lname    
              ,@l_nomgau_fthname  
              ,@l_nomgau_dob      
              ,@l_nomgau_pan_no   
              ,@l_nomgau_gender   
              ,@l_nom_fname    
              ,@l_nom_mname    
              ,@l_nom_lname    
              ,@l_nom_fthname  
              ,@l_nom_dob      
              ,@l_nom_pan_no   
              ,@l_nom_gender   
              ,@l_gau_fname    
              ,@l_gau_mname    
              ,@l_gau_lname    
              ,@l_gau_fthname  
              ,@l_gau_dob      
              ,@l_gau_pan_no   
              ,@l_gau_gender  
              ,@pa_login_name  
              ,getdate()  
              ,@pa_login_name  
              ,getdate()  
              ,1  
              ,@l_fh_name  
              ,@L_NOM_NRN_NO   
              )  
              --  
              SET @l_error = @@error  
              --  
              IF @l_error <> 0  
              BEGIN  
              --  
                ROLLBACK TRANSACTION  
                --  
                SET @pa_msg = '#'+'could not change access for ' + convert(varchar, @pa_sba_no) + isnull(@l_errorstr,'')  
                --SET @l_errorstr = isnull(@l_errorstr,'') + 'Error '+ convert(varchar(10), @l_error)  
                RETURN  
              --  
              END  
              ELSE  
              BEGIN  
              --  
                SET @l_errorstr = 'dp holder details successfully inserted\edited '+ @rowdelimiter  
                --  
                COMMIT TRANSACTION  
              --    
              END    
            --  
            END--neq2_0  
            ELSE  
            BEGIN--eq2_0  
            --  
              SET @pa_msg = isnull(@l_errorstr,'') + convert(varchar, @pa_sba_no) + ' form/demat id does exist'  
              --  
              RETURN  
            --  
            END--eq2_0  
          --  
          END--nexts  
        --  
        END--edt_0  
      --      
      END--chk_0  
      --  
      IF @pa_chk_yn = 1  OR @pa_chk_yn = 2       
      BEGIN--chk_1_2  
      --  
        IF @pa_action = 'INS' or @pa_action = 'EDT' or @pa_action = 'DEL'  
        BEGIN  
        --  
          IF EXISTS(SELECT dphdm.dphd_dpam_id        dphd_id  
                    FROM   dp_holder_dtls_mak        dphdm WITH (NOLOCK)  
                    WHERE  dphdm.dphd_deleted_ind IN (0,4,8)  
                    AND    dphdm.dphd_dpam_id      = @l_dpam_id  
                    )  
          BEGIN  
          --  
            --BEGIN TRANSACTION  
            --  
            UPDATE dp_holder_dtls_mak    WITH (ROWLOCK)  
            SET    dphd_deleted_ind    = 3  
            WHERE  dphd_deleted_ind   IN (0,4,8)  
            AND    dphd_dpam_id        = @l_dpam_id  
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
          IF @pa_action = 'EDT' AND EXISTS(SELECT * FROM dp_holder_dtls WHERE dphd_dpam_id = convert(numeric, @l_dpam_id))   
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
          --  
          BEGIN TRANSACTION  
          --  
          SELECT @l_dphdmak_id = isnull(max(dphdmak_id),0) + 1   
          FROM   dp_holder_dtls_mak  WITH (NOLOCK)  
          --  

          INSERT INTO dp_holder_dtls_mak  
          (dphdmak_id  
          ,dphd_dpam_id  
          ,dphd_dpam_sba_no  
          ,dphd_sh_fname  
          ,dphd_sh_mname  
          ,dphd_sh_lname  
          ,dphd_sh_fthname  
          ,dphd_sh_dob  
          ,dphd_sh_pan_no  
          ,dphd_sh_gender  
          ,dphd_th_fname  
          ,dphd_th_mname  
          ,dphd_th_lname  
          ,dphd_th_fthname  
          ,dphd_th_dob  
          ,dphd_th_pan_no  
          ,dphd_th_gender  
          ,dphd_nomgau_fname  
          ,dphd_nomgau_mname  
          ,dphd_nomgau_lname  
          ,dphd_nomgau_fthname  
          ,dphd_nomgau_dob  
          ,dphd_nomgau_pan_no  
          ,dphd_nomgau_gender  
          ,dphd_nom_fname  
          ,dphd_nom_mname  
          ,dphd_nom_lname  
          ,dphd_nom_fthname  
          ,dphd_nom_dob  
          ,dphd_nom_pan_no  
          ,dphd_nom_gender  
          ,dphd_gau_fname  
          ,dphd_gau_mname  
          ,dphd_gau_lname  
          ,dphd_gau_fthname  
          ,dphd_gau_dob  
          ,dphd_gau_pan_no  
          ,dphd_gau_gender  
          ,dphd_created_by  
          ,dphd_created_dt  
          ,dphd_lst_upd_by  
          ,dphd_lst_upd_dt  
          ,dphd_deleted_ind  
          ,dphd_fh_fthname  
          ,NOM_NRN_NO   
          )  
          VALUES  
          (@l_dphdmak_id  
          ,@l_dpam_id      
          ,@pa_sba_no  
          ,@l_sh_fname     
          ,@l_sh_mname     
          ,@l_sh_lname     
          ,@l_sh_fthname   
          ,convert(datetime,@l_sh_dob,103)       
          ,@l_sh_pan_no    
          ,@l_sh_gender    
          ,@l_th_fname     
          ,@l_th_mname     
          ,@l_th_lname     
          ,@l_th_fthname   
          ,convert(datetime,@l_th_dob,103)            
          ,@l_th_pan_no    
          ,@l_th_gender    
          ,@l_nomgau_fname    
          ,@l_nomgau_mname    
          ,@l_nomgau_lname    
          ,@l_nomgau_fthname  
          ,convert(datetime,@l_nomgau_dob,103)           
          ,@l_nomgau_pan_no   
          ,@l_nomgau_gender   
          ,@l_nom_fname    
          ,@l_nom_mname    
          ,@l_nom_lname    
          ,@l_nom_fthname  
          ,convert(datetime,@l_nom_dob,103)           
          ,@l_nom_pan_no   
          ,@l_nom_gender   
          ,@l_gau_fname    
          ,@l_gau_mname    
          ,@l_gau_lname    
          ,@l_gau_fthname  
          ,convert(datetime,@l_gau_dob,103)           
          ,@l_gau_pan_no   
          ,@l_gau_gender  
          ,@pa_login_name  
          ,getdate()  
          ,@pa_login_name  
          ,getdate()  
          ,CASE @pa_action WHEN 'INS' THEN 0  
                           WHEN 'EDT' THEN @l_edt_del_id   
                           WHEN 'DEL' THEN 4 END  
          ,@l_fh_name                   
          ,@L_NOM_NRN_NO   
          )  
          --  
          SET @l_error = @@ERROR  
          --  
          IF @l_error > 0  
          BEGIN  
          --  
            SET @l_errorstr = '#'+@l_errorstr+convert(varchar,'0')+@coldelimiter+isnull(@pa_sba_no,'')+@coldelimiter+convert(varchar,@l_error)+@coldelimiter+@rowdelimiter   
            --  
            ROLLBACK TRANSACTION   
          --  
          END  
          ELSE  
          BEGIN  
          --  
            SET @l_errorstr = 'dp holder details successfully inserted\edited '+ @rowdelimiter  
            --  
            COMMIT TRANSACTION   
            --  
            SELECT @l_action = case @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END  
            SELECT @pa_id    = dpam_crn_no     FROM dp_acct_mstr_mak WHERE dpam_id = @l_dpam_id  
            --  
            EXEC pr_ins_upd_list @pa_id, @l_action,'dp holder dtls', @pa_login_name, '*|~*', '|*~|', ''   
          --  
          END  
        --    
        END  
      --  
      END--chk_1_2  
    --  
    END  --if_curid  
    --  
    IF @pa_action = 'APP'  
    BEGIN--app  
    --  
        
      SELECT @l_dphd_deleted_ind = dphd_deleted_ind  
           , @l_dpam_id          = dphd_dpam_id  
           , @l_dphd_dpam_sba_no = dphd_dpam_sba_no  
      FROM   #dp_holder_dtls_mak   WITH (NOLOCK)  
      WHERE  dphdmak_id          = convert(numeric, @currstring_id)   
      --  
      IF @l_dphd_deleted_ind = 4  
      BEGIN--4  
      --  
        --BEGIN TRANSACTION  
        --  
        UPDATE dp_holder_dtls       WITH (ROWLOCK)       
        SET    dphd_deleted_ind   = 0  
             , dphd_lst_upd_by    = @pa_login_name  
             , dphd_lst_upd_dt    = GETDATE()  
        WHERE  dphd_deleted_ind   = 1  
        AND    dphd_dpam_id       = @l_dpam_id  
        --  
        --SET @l_error = @@error  
        --  
        --IF @l_error > 0  
        --BEGIN  
        --  
        --  SET @l_errorstr = convert(varchar, @l_error)  
          --  
        --  ROLLBACK TRANSACTION  
        --  
        --END  
        --  
        UPDATE dp_holder_dtls_mak   WITH (ROWLOCK)         
        SET    dphd_deleted_ind   = 5  
             , dphd_lst_upd_by    = @pa_login_name  
             , dphd_lst_upd_dt    = GETDATE()  
        WHERE  dphd_deleted_ind   = 4  
        AND    dphdmak_id         = CONVERT(numeric, @currstring_id)    
          
        --SET @l_error = @@error  
        --  
        --IF @l_error > 0  
        --BEGIN  
        --  
        --  SET @l_errorstr = convert(varchar, @l_error)  
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
      END--4  
      --  
      IF @l_dphd_deleted_ind = 8  
      BEGIN--8  
      --  
        --BEGIN TRANSACTION  
        --  
        UPDATE dp_holder_dtls_mak   WITH (ROWLOCK)            
        SET    dphd_deleted_ind   = 9            
             , dphd_lst_upd_by    = @pa_login_name            
             , dphd_lst_upd_dt    = getdate()            
        WHERE  dphd_deleted_ind   = 8            
        AND    dphdmak_id         = convert(numeric, @currstring_id)            
        --            
        --SET @l_error = @@ERROR            
        --            
        --IF @l_error > 0            
        --BEGIN            
        --            
        --  SET @l_errorstr = convert(varchar(10), @l_error)            
          --  
        --  ROLLBACK TRANSACTION  
        --            
        --END            
        -- 
        
        UPDATE dp                    WITH (ROWLOCK)  
        SET    dp.dphd_sh_fname    = dm.dphd_sh_fname  
             , dp.dphd_sh_mname    = dm.dphd_sh_mname       
             , dp.dphd_sh_lname    = dm.dphd_sh_lname       
             , dp.dphd_sh_fthname  = dm.dphd_sh_fthname     
             , dp.dphd_sh_dob      = dm.dphd_sh_dob         
             , dp.dphd_sh_pan_no   = dm.dphd_sh_pan_no      
             , dp.dphd_sh_gender   = dm.dphd_sh_gender      
             , dp.dphd_th_fname    = dm.dphd_th_fname       
             , dp.dphd_th_mname    = dm.dphd_th_mname       
             , dp.dphd_th_lname    = dm.dphd_th_lname       
             , dp.dphd_th_fthname  = dm.dphd_th_fthname     
             , dp.dphd_th_dob      = dm.dphd_th_dob         
             , dp.dphd_th_pan_no   = dm.dphd_th_pan_no      
             , dp.dphd_th_gender   = dm.dphd_th_gender      
             , dp.dphd_nomgau_fname   = dm.dphd_nomgau_fname      
             , dp.dphd_nomgau_mname   = dm.dphd_nomgau_mname      
             , dp.dphd_nomgau_lname   = dm.dphd_nomgau_lname      
             , dp.dphd_nomgau_fthname = dm.dphd_nomgau_fthname    
             , dp.dphd_nomgau_dob     = dm.dphd_nomgau_dob        
             , dp.dphd_nomgau_pan_no  = dm.dphd_nomgau_pan_no     
             , dp.dphd_nomgau_gender  = dm.dphd_nomgau_gender    
             , dp.dphd_nom_fname   = dm.dphd_nom_fname      
             , dp.dphd_nom_mname   = dm.dphd_nom_mname      
             , dp.dphd_nom_lname   = dm.dphd_nom_lname      
             , dp.dphd_nom_fthname = dm.dphd_nom_fthname    
             , dp.dphd_nom_dob     = dm.dphd_nom_dob        
             , dp.dphd_nom_pan_no  = dm.dphd_nom_pan_no     
             , dp.dphd_nom_gender  = dm.dphd_nom_gender     
             , dp.dphd_gau_fname   = dm.dphd_gau_fname      
             , dp.dphd_gau_mname   = dm.dphd_gau_mname      
             , dp.dphd_gau_lname   = dm.dphd_gau_lname      
             , dp.dphd_gau_fthname = dm.dphd_gau_fthname    
             , dp.dphd_gau_dob     = dm.dphd_gau_dob        
             , dp.dphd_gau_pan_no  = dm.dphd_gau_pan_no     
             , dp.dphd_gau_gender  = dm.dphd_gau_gender   
             , dp.dphd_fh_fthname  = dm.dphd_fh_fthname      
             , DP.NOM_NRN_NO       = DM.NOM_NRN_NO     
        FROM   dp_holder_dtls_mak   dm       
             , dp_holder_dtls        dp   
        WHERE  dp.dphd_dpam_id     = @l_dpam_id  
        AND    dp.dphd_dpam_id     = dm.dphd_dpam_id
        AND    dm.dphdmak_id         = convert(numeric, @currstring_id)     
        AND    dp.dphd_deleted_ind = 1  
        --            
        --SET @l_error = @@ERROR            
        --            
        --IF @l_error > 0            
        --BEGIN            
        --            
        --  SET @l_errorstr = convert(varchar(10), @l_error)            
          --  
        --  ROLLBACK TRANSACTION  
        --            
        --END  
        --  
        --COMMIT TRANSACTION  
      --               
      END--8  
      --  
      IF @l_dphd_deleted_ind = 0             
      BEGIN--0            
      --  
        --BEGIN TRANSACTION  
        --  
        UPDATE dp_holder_dtls_mak  WITH (ROWLOCK)            
        SET    dphd_deleted_ind  = 1            
             , dphd_lst_upd_by   = @pa_login_name            
             , dphd_lst_upd_dt   = GETDATE()            
        WHERE  dphd_deleted_ind  = 0            
        AND    dphdmak_id        = convert(numeric, @currstring_id)            
        --          
        --SET @l_error = @@ERROR            
        --            
        --IF @l_error > 0            
        --BEGIN            
        --            
        --   SET @l_errorstr = convert(varchar(10), @l_error)            
           --  
        --   ROLLBACK TRANSACTION  
        --            
        --END  
        --  
        INSERT INTO dp_holder_dtls  
        (dphd_dpam_id  
        ,dphd_dpam_sba_no  
        ,dphd_sh_fname  
        ,dphd_sh_mname  
        ,dphd_sh_lname  
        ,dphd_sh_fthname  
        ,dphd_sh_dob  
        ,dphd_sh_pan_no  
        ,dphd_sh_gender  
        ,dphd_th_fname  
        ,dphd_th_mname  
        ,dphd_th_lname  
        ,dphd_th_fthname  
        ,dphd_th_dob  
        ,dphd_th_pan_no  
        ,dphd_th_gender  
        ,dphd_nomgau_fname  
        ,dphd_nomgau_mname  
        ,dphd_nomgau_lname  
        ,dphd_nomgau_fthname  
        ,dphd_nomgau_dob  
        ,dphd_nomgau_pan_no  
        ,dphd_nomgau_gender  
        ,dphd_nom_fname  
        ,dphd_nom_mname  
        ,dphd_nom_lname  
        ,dphd_nom_fthname  
        ,dphd_nom_dob  
        ,dphd_nom_pan_no  
        ,dphd_nom_gender  
        ,dphd_gau_fname  
        ,dphd_gau_mname  
        ,dphd_gau_lname  
        ,dphd_gau_fthname  
        ,dphd_gau_dob  
        ,dphd_gau_pan_no  
        ,dphd_gau_gender  
        ,dphd_created_by  
        ,dphd_created_dt  
        ,dphd_lst_upd_by  
        ,dphd_lst_upd_dt  
        ,dphd_deleted_ind  
        ,dphd_fh_fthname  
        ,NOM_NRN_NO   
        )  
        SELECT dphd_dpam_id  
             , dphd_dpam_sba_no  
             , dphd_sh_fname  
             , dphd_sh_mname  
             , dphd_sh_lname  
             , dphd_sh_fthname  
             , dphd_sh_dob  
             , dphd_sh_pan_no  
             , dphd_sh_gender  
             , dphd_th_fname  
             , dphd_th_mname  
             , dphd_th_lname  
             , dphd_th_fthname  
             , dphd_th_dob  
             , dphd_th_pan_no  
             , dphd_th_gender  
             , dphd_nomgau_fname  
             , dphd_nomgau_mname  
             , dphd_nomgau_lname  
             , dphd_nomgau_fthname  
             , dphd_nomgau_dob  
             , dphd_nomgau_pan_no  
             , dphd_nomgau_gender  
             , dphd_nom_fname  
             , dphd_nom_mname  
             , dphd_nom_lname  
             , dphd_nom_fthname  
             , dphd_nom_dob  
             , dphd_nom_pan_no  
             , dphd_nom_gender  
             , dphd_gau_fname  
             , dphd_gau_mname  
             , dphd_gau_lname  
             , dphd_gau_fthname  
             , dphd_gau_dob  
             , dphd_gau_pan_no  
             , dphd_gau_gender  
             , dphd_created_by  
             , dphd_created_dt  
             , dphd_lst_upd_by  
             , dphd_lst_upd_dt  
             , 1  
             , dphd_fh_fthname  
             ,NOM_NRN_NO   
        FROM   #dp_holder_dtls_mak WITH (NOLOCK)  
        WHERE  dphdmak_id        = convert(numeric, @currstring_id)   
        --  
        --SET @l_error = @@ERROR            
        --            
        --IF @l_error > 0            
        --BEGIN            
        --            
        --  SET @l_errorstr = convert(varchar(10), @l_error)            
          --  
        --  ROLLBACK TRANSACTION  
        --            
        --END  
        --  
        --COMMIT TRANSACTION  
      --   
      END--0  
    --  
    END--app  
    --  
    IF @pa_action = 'REJ'            
    BEGIN--rej            
    --  
      --BEGIN TRANSACTION  
      --  
      UPDATE dp_holder_dtls_mak       WITH (ROWLOCK)            
      SET    dphd_deleted_ind  = 3            
           , dphd_lst_upd_by   = @pa_login_name            
           , dphd_lst_upd_dt   = getdate()             
      WHERE  dphdmak_id        = convert(numeric, @currstring_id)            
      AND    dphd_deleted_ind IN (0,4,8)            
      --            
      --SET @l_error = @@ERROR            
      --            
      --IF @l_error > 0            
      --BEGIN            
      --            
      --  SET @l_errorstr = convert(varchar(10), @l_error)            
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
    END--rej  
  --  
  END  --wpa_id  
  --  
  SET @pa_msg = @l_errorstr  
--  
END  --#1

GO
