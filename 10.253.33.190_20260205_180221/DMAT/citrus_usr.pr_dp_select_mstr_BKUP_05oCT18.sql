-- Object: PROCEDURE citrus_usr.pr_dp_select_mstr_BKUP_05oCT18
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[pr_dp_select_mstr_BKUP_05oCT18]( @pa_id  VARCHAR(800)                          
                                   ,@pa_action         VARCHAR(100)                          
                                   ,@pa_login_name     VARCHAR(20)                          
                                   ,@pa_cd             VARCHAR(25)                          
                                   ,@pa_desc           VARCHAR(250)                          
                                   ,@pa_rmks           VARCHAR(250)                          
                                   ,@pa_values         VARCHAR(8000)                         
                                   ,@pa_roles          VARCHAR(8000)                        
                                   ,@pa_scr_id         NUMERIC                        
                                   ,@rowdelimiter      CHAR(20)                          
                                   ,@coldelimiter      CHAR(20)                          
                                   ,@pa_ref_cur        VARCHAR(8000) OUT                          
                                  )                          
AS                        
/*                        
*********************************************************************************                        
 SYSTEM         : Dp                        
 MODULE NAME    : Pr_Select_Mstr                        
 DESCRIPTION    : This Procedure Will Contain The Select Queries For Master Tables                        
 COPYRIGHT(C)   : Marketplace Technologies                         
 VERSION HISTORY: 1.0                        
 VERS.  AUTHOR            DATE          REASON                        
 -----  -------------     ------------  --------------------------------------------------                        
 1.0    TUSHAR            08-OCT-2007   VERSION.                        
-----------------------------------------------------------------------------------*/                        
BEGIN                        
--     

     
      

--select * from temptable_1010201422
--
--return 
       IF @PA_ACTION ='VALID_CLIENT'
       BEGIN 
       EXEC  [pr_dp_select_mstr_validclient] @pa_id                        
                                   ,@pa_action         
                                   ,@pa_login_name     
                                   ,@pa_cd             
                                   ,@pa_desc           
                                   ,@pa_rmks           
                                   ,@pa_values         
                                   ,@pa_roles          
                                   ,@pa_scr_id         
                                   ,@rowdelimiter      
                                   ,@coldelimiter      
                                   ,@pa_ref_cur 
                                   RETURN 
                                   END    
      
  declare @l_temp_id table(id numeric)                        
  declare @l_count numeric                        
        , @l_tot_count numeric                        
        , @L_ENTTM_CD VARCHAR(25)                        
        , @l_dpm_dpid  int                        
        , @l_entm_id numeric                        
        , @l_stam_cd varchar(20)                        
        , @@fin_id   numeric             
        , @l_sql     varchar(8000)           
                 
        set @l_stam_cd ='ACTIVE'                        
                                
        declare @l_max_date datetime                        
           ,@l_rate     int                         
                                
        SET @L_ENTTM_CD = 'CLI'                             
                    
if @pa_action<>'POA_DOC_PATH_SIGN'                    
begin
  if  isnull(@pa_id,'') <> ''  and isnumeric(@pa_id) = 1                  
  begin                    
     if  len(@pa_id) < 5                    
     begin            
      select @l_dpm_dpid = dpm_id from dp_mstr where isnull(DEFAULT_DP,0) = @pa_id and dpm_deleted_ind = 1                         
     end            
  end           
  ELSE          
  BEGIN          
    IF  CITRUS_USR.FN_SPLITVAL(@PA_ID,2) <> ''          
    begin        
    select @l_dpm_dpid = dpm_id from dp_mstr where isnull(DEFAULT_DP,0) = CITRUS_USR.FN_SPLITVAL(@PA_ID,2) and dpm_deleted_ind = 1               
    end        
        
    SET @PA_ID = CITRUS_USR.FN_SPLITVAL(@PA_ID,1)          
        
  END  
end

        
   set dateformat dmy             
      if @pa_action like '%voucher%'        
      begin            
    if (isdate(CONVERT(DATETIME,@pa_desc,103))=1 )        
    begin        
     SELECT @@fin_id = FIN_ID FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @l_dpm_dpid AND (CONVERT(DATETIME,@pa_desc,103) BETWEEN FIN_START_DT AND FIN_END_DT)AND FIN_DELETED_IND =1            
    end                    
      end        
   select @l_entm_id = logn_ent_id from login_names where logn_name = @pa_login_name and logn_deleted_ind =  1                           
      
                                
  IF @pa_action = 'compm_excsm_listing'                        
  BEGIN                        
  --                        
                        
       /*SELECT distinct compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd + '-' + dpm.dpm_dpid comp_name                          
           , excsm.excsm_id    id                        
           , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                          
       FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                          
           , company_mstr                 compm  WITH (NOLOCK)                        
           , roles_actions                rola                        
           , bitmap_ref_mstr              bitrm                        
           , dp_mstr         dpm                        
       WHERE  excsm.excsm_compm_id         = compm.compm_id                          
       AND excsm.excsm_id      = dpm.default_dp                        
       AND    convert(int,rola_access1) & power(1,bitrm_bit_location-1) = power(1,bitrm_bit_location-1)                         
       AND    rola_rol_id                  in (select id from @l_temp_id)                        
       AND    bitrm_child_cd               = excsm.excsm_desc               
       AND    bitrm_deleted_ind            = 1                         
       AND    rola_deleted_ind             = 1                         
       AND    excsm.excsm_deleted_ind      = 1                          
       AND    compm.compm_deleted_ind      = 1                          
       AND    excsm_seg_cd                 = 'DEPOSITORY'                        
       AND    excsm_exch_cd          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END   */                        
                               
       -- changed query in pr_dp_select_mstr procedure for tab = 'compm_excsm_listing'                        
                               
       SELECT distinct compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd + '-' + dpm.dpm_dpid comp_name                          
           ,  excsm.excsm_id               id                        
           ,  CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                          
       FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                          
           , company_mstr                 compm  WITH (NOLOCK)                        
           , dp_mstr         dpm                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
       WHERE  excsm.excsm_compm_id         = compm.compm_id                          
       AND    excsm.excsm_id               = dpm.default_dp                        
       AND    excsm_list.excsm_id          = excsm.excsm_id                        
       AND    excsm.excsm_deleted_ind      = 1                          
       AND    compm.compm_deleted_ind      = 1                          
       AND    excsm_seg_cd                 = 'DEPOSITORY'                        
       AND    excsm_exch_cd                LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END                        
                               
      -- changed query in pr_dp_select_mstr procedure for tab = 'compm_excsm_listing'                        
                            
                            
  --                        
  END                  
   if @pa_action = 'FINYR_CF_SEL'             
 begin        
 select * from financial_yr_mstr where fin_dpm_id=@pa_id and fin_deleted_ind=1        
 end           
  IF @pa_action = 'fin_compm_excsm_listing'                        
  BEGIN                        
  --                        
            
       /*SELECT distinct compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd + '-' + dpm.dpm_dpid comp_name                          
           , excsm.excsm_id               id                        
        , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                          
       FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                          
           , company_mstr                 compm  WITH (NOLOCK)                        
           , roles_actions                rola                        
           , bitmap_ref_mstr              bitrm                        
           , dp_mstr         dpm                        
       WHERE  excsm.excsm_compm_id         = compm.compm_id                          
       AND excsm.excsm_id      = dpm.default_dp                        
       AND    convert(int,rola_access1) & power(1,bitrm_bit_location-1) = power(1,bitrm_bit_location-1)                         
       AND    rola_rol_id                  in (select id from @l_temp_id)                        
       AND    bitrm_child_cd               = excsm.excsm_desc                        
       AND    bitrm_deleted_ind            = 1                         
       AND    rola_deleted_ind             = 1                         
       AND    excsm.excsm_deleted_ind      = 1                          
       AND    compm.compm_deleted_ind      = 1                          
       AND    excsm_seg_cd                 = 'DEPOSITORY'                        
       AND    excsm_exch_cd                LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END   */                        
                        
       -- changed query in pr_dp_select_mstr procedure for tab = 'compm_excsm_listing'                        
                        
       SELECT distinct compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd + '-' + dpm.dpm_dpid comp_name                          
           ,  CONVERT(VARCHAR,dpm_id) + '|*~|' + CONVERT(VARCHAR(11),fin_start_dt,109) + '|*~|' +  CONVERT(VARCHAR(11),fin_end_dt,109) + '|*~|' + CONVERT(VARCHAR,fin_id)  + '|*~|' + CONVERT(VARCHAR,EXCSM.EXCSM_ID)  + '|*~|'  id                        
           ,  CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                          
                                   
       FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                          
            , company_mstr                 compm  WITH (NOLOCK)                        
            --, roles_actions                rola                        
            --, bitmap_ref_mstr              bitrm                        
            , dp_mstr                      dpm                        
            , financial_yr_mstr            finy                        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
  WHERE  excsm.excsm_compm_id         = compm.compm_id                          
       AND    excsm.excsm_id               = dpm.default_dp                        
       AND    finy.fin_dpm_id              = case when FIN_DPM_ID = '999' then '999' else  dpm.dpm_id end --dpm.dpm_id                        
       --AND    convert(int,rola_access1) & power(1,bitrm_bit_location-1) = power(1,bitrm_bit_location-1)                         
                             
       --AND    bitrm_child_cd               = excsm.excsm_desc                        
       AND    excsm_list.excsm_id          = excsm.excsm_id                        
       --AND    bitrm_deleted_ind            = 1                         
       --AND    rola_deleted_ind             = 1                         
       AND    excsm.excsm_deleted_ind      = 1                          
       AND    compm.compm_deleted_ind      = 1                          
       AND    convert(datetime,@pa_values,103) BETWEEN  fin_start_dt  AND fin_end_dt                        
       AND    excsm_seg_cd          = 'DEPOSITORY'                        
       AND    excsm_exch_cd                LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END                        
                        
      -- changed query in pr_dp_select_mstr procedure for tab = 'compm_excsm_listing'                        
                  
                        
  --                        
  END                        
  IF @pa_action = 'INT_REF_NO_LISTING_NSDL'                        
  BEGIN                        
  --                        
  --select top 1 @l_max_date = clopm_dt , @l_rate = clopm_nsdl_rt from closing_price_mstr_nsdl order by 1 desc                        
    select @PA_VALUES = isnull(bitrm_bit_location,0) from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_NSDL'                        
                        
    IF @pa_cd = 'P2P'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                        ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dptd_mak                         
             left outer join                        
             closing_last_nsdl on    dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id         = @pa_id                
      and    dptd_deleted_ind     IN( 0,-1)                        
      and    dptd_internal_trastm = @pa_cd          
      order by dptd_internal_ref_no                  
                              
                              
    --                        
    END                        
    IF @pa_cd = 'C2P'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                                    ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dptd_mak                         
                   left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd           
       order by dptd_internal_ref_no                      
                        
    --                        
    END                        
    IF @pa_cd = 'P2C'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                       ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dptd_mak                         
                   left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd         
      order by dptd_internal_ref_no                        
                          
    --                        
    END                        
    IF @pa_cd = 'IDD'                        
    BEGIN                   
    --                        
    --INSTRUCT.NO.,TARGET CLIENT,SETT.TYPE,SETTNO,ISIN,QTY    
      select DPTD_INTERNAL_REF_NO        [INSTRUCTION NO]                        
            ,DPTD_COUNTER_DEMAT_ACCT_NO  [TARGET CLIENT]                        
            ,DPTD_OTHER_SETTLEMENT_TYPE  [SETTLEMENT TYPE]                        
            ,DPTD_OTHER_SETTLEMENT_NO  [SETTLEMENT NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)        QTY                        
        ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dptd_mak                         
                   left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd          
      order by dptd_internal_ref_no                                      
                         
    --                        
    END                        
    IF @pa_cd = 'IDD_R'                        
    BEGIN                        
    --                        
    --INSTRUCT.NO.,TARGET CLIENT,SETT.TYPE,SETTNO,ISIN,QTY                        
      select DPTD_INTERNAL_REF_NO        [INSTRUCTION NO]                        
            ,DPTD_COUNTER_DEMAT_ACCT_NO  [TARGET CLIENT]                        
            ,DPTD_OTHER_SETTLEMENT_TYPE  [SETTLEMENT TYPE]                        
            ,DPTD_OTHER_SETTLEMENT_NO  [SETTLEMENT NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)        QTY                        
,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dptd_mak                         
     left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd            
      order by dptd_internal_ref_no                                    
                        
    --                        
    END                        
    IF @pa_cd = 'C2C'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
     from   dptd_mak                         
                  left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd          
      order by dptd_internal_ref_no                                      
                        
    --                        
    END                        
    IF @pa_cd = 'C2C_R'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
     from   dptd_mak                         
                  left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd   
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd            
      order by dptd_internal_ref_no                                    
                        
    --                        
    END                        
    IF @pa_cd = 'C2P_R'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)           QTY                        
,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
     from   dptd_mak                         
                  left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd          
      order by dptd_internal_ref_no                                      
                        
    --                        
    END               
    IF @pa_cd = 'ATO'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                        ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dptd_mak                         
                   left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd          
      order by dptd_internal_ref_no                                      
                              
    --                        
    END                        
    IF @pa_cd = 'IDO'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                       ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
    from   dptd_mak                         
                 left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd         
      order by dptd_internal_ref_no                                       
                           
    --                        
    END                       
    IF @pa_cd = 'DO'                        
      BEGIN                        
      --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                        ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
    from   dptd_mak                         
                 left outer join                        
             closing_last_nsdl on     dptD_isin = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
     and    dptd_deleted_ind in(0,-1)                        
      and    dptd_internal_trastm = @pa_cd            
      order by dptd_internal_ref_no                                    
                        
      --                        
    END                        
                            
  --                        
  END                        
  IF @pa_action = 'INT_REF_NO_LISTING_NSDL_MSTR'                        
  BEGIN                        
  --                        
                            
     select @PA_VALUES = isnull(bitrm_bit_location,0) from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_NSDL'                        
    --select top 1 @l_max_date = clopm_dt , @l_rate = clopm_nsdl_rt from closing_price_mstr_nsdl order by 1 desc                        
                            
    IF @pa_cd = 'P2P'                        
    BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
            ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
                                        
      from   dp_trx_dtls                        
             left outer join                         
             closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
      where  dptd_dtls_id         = @pa_id             
      and    dptd_deleted_ind     = 1                        
      and    dptd_internal_trastm = @pa_cd         
      order by dptd_internal_ref_no                                       
                              
                              
    --                        
    END                        
    IF @pa_cd = 'C2P'                        
 BEGIN                        
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                                                ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dp_trx_dtls                        
                   left outer join                         
             closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind = 1                        
      and    dptd_internal_trastm = @pa_cd             
      order by dptd_internal_ref_no                                   
                            
    --                        
    END                        
    IF @pa_cd = 'C2P_R'                        
    BEGIN                      
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                                                ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
      from   dp_trx_dtls                        
                   left outer join                         
                        closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind = 1                        
      and    dptd_internal_trastm = @pa_cd             
      order by dptd_internal_ref_no                                   
                        
    --                        
    END                        
    IF @pa_cd = 'P2C'                        
    BEGIN           
    --                        
      select dptd_internal_ref_no [INSTRUCTION NO]                      
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)             QTY                        
                                                ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
     from   dp_trx_dtls                        
                  left outer join                         
             closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind = 1                        
      and    dptd_internal_trastm = @pa_cd            
      order by dptd_internal_ref_no                                    
         
    --                        
    END                        
    IF @pa_cd = 'IDD'                        
    BEGIN                        
    --                        
    --INSTRUCT.NO.,TARGET CLIENT,SETT.TYPE,SETTNO,ISIN,QTY                        
      select DPTD_INTERNAL_REF_NO        [INSTRUCTION NO]                        
            ,DPTD_COUNTER_DEMAT_ACCT_NO  [TARGET CLIENT]                        
  ,DPTD_OTHER_SETTLEMENT_TYPE  [SETTLEMENT TYPE]                        
            ,DPTD_OTHER_SETTLEMENT_NO [SETTLEMENT NO]                        
            ,dptd_isin            ISIN                        
            ,abs(dptd_qty)        QTY                        
,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
    from   dp_trx_dtls                        
                 left outer join                         
             closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
      where  dptd_dtls_id = @pa_id                        
      and    dptd_deleted_ind = 1                        
      and    dptd_internal_trastm = @pa_cd               
      order by dptd_internal_ref_no                                 
                        
    --                        
    END                        
    IF @pa_cd = 'IDD_R'                        
    BEGIN                        
    --                        
    --INSTRUCT.NO.,TARGET CLIENT,SETT.TYPE,SETTNO,ISIN,QTY                        
      select DPTD_INTERNAL_REF_NO        [INSTRUCTION NO]                        
            ,DPTD_COUNTER_DEMAT_ACCT_NO  [TARGET CLIENT]                        
            ,DPTD_OTHER_SETTLEMENT_TYPE  [SETTLEMENT TYPE]                        
            ,DPTD_OTHER_SETTLEMENT_NO  [SETTLEMENT NO]                        
   ,dptd_isin            ISIN                        
   ,abs(dptd_qty)        QTY                        
   ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
   from   dp_trx_dtls                        
   left outer join                         
   closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
   where  dptd_dtls_id = @pa_id                        
   and    dptd_deleted_ind = 1                        
   and    dptd_internal_trastm = @pa_cd           
   order by dptd_internal_ref_no                                     
                        
    --                        
    END                        
    IF @pa_cd = 'C2C'                        
    BEGIN                        
    --                        
  select dptd_internal_ref_no [INSTRUCTION NO]                        
  ,dptd_isin            ISIN                        
  ,abs(dptd_qty)             QTY                        
  ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
  from   dp_trx_dtls                        
  left outer join                         
  closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
  where  dptd_dtls_id = @pa_id                        
  and    dptd_deleted_ind = 1                        
  and    dptd_internal_trastm = @pa_cd           
  order by dptd_internal_ref_no                                     
                             
    --                        
    END                        
    IF @pa_cd = 'C2C_R'                        
    BEGIN                        
    --                        
  select dptd_internal_ref_no [INSTRUCTION NO]                        
  ,dptd_isin            ISIN                        
  ,abs(dptd_qty)             QTY                        
  ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
  from   dp_trx_dtls                        
  left outer join                         
  closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
  where  dptd_dtls_id = @pa_id              
  and    dptd_deleted_ind = 1                        
  and    dptd_internal_trastm = @pa_cd            
  order by dptd_internal_ref_no                                    
                        
    --                        
    END                        
    IF @pa_cd = 'ATO'                        
    BEGIN                        
    --                        
  select dptd_internal_ref_no [INSTRUCTION NO]                        
  ,dptd_isin            ISIN                        
  ,abs(dptd_qty)             QTY                        
  ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]       
  from   dp_trx_dtls                        
  left outer join                         
  closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
  where  dptd_dtls_id = @pa_id                        
  and    dptd_deleted_ind = 1                        
  and    dptd_internal_trastm = @pa_cd                  
  order by dptd_internal_ref_no                              
                        
    --                        
    END            
    IF @pa_cd = 'IDO'                        
    BEGIN                        
    --                        
  select dptd_internal_ref_no [INSTRUCTION NO]                        
  ,dptd_isin            ISIN                        
  ,abs(dptd_qty)             QTY                        
  ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
  from   dp_trx_dtls                        
  left outer join                         
  closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
  where  dptd_dtls_id = @pa_id                        
  and    dptd_deleted_ind = 1                        
  and    dptd_internal_trastm = @pa_cd           
  order by dptd_internal_ref_no                                     
                        
    --                        
    END                        
    IF @pa_cd = 'DO'                        
      BEGIN                        
      --                        
  select dptd_internal_ref_no [INSTRUCTION NO]                        
  ,dptd_isin            ISIN                        
  ,abs(dptd_qty)             QTY                        
  ,case WHEN abs(dptd_qty) * clopm_nsdl_rt > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                                    
  from   dp_trx_dtls                        
  left outer join                         
  closing_last_nsdl on dptd_isin            = clopm_isin_cd                         
  where  dptd_dtls_id = @pa_id                        
  and    dptd_deleted_ind = 1                        
  and    dptd_internal_trastm = @pa_cd           
  order by dptd_internal_ref_no                                     
                        
      --                        
    END                        
                        
  --                        
  END                        
  IF @pa_action = 'INT_REF_NO_LISTING_CDSL'                        
  BEGIN                        
  --                      
                          
   select @PA_VALUES = isnull(bitrm_bit_location,0) from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_CDSL'                        
                                
   -- select top 1 @l_max_date = clopm_dt , @l_rate = clopm_nsdl_rt from closing_price_mstr_nsdl order by 1 desc                        
                            
                            
  select dptdc_internal_ref_no        [TRANSACTION NO]                        
  ,dptdc_isin                   ISIN                        
  ,abs(dptdc_qty)               QTY                        
  ,case WHEN abs(dptdC_qty) * CLOPM_CDSL_RT > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                             
  from   dptdc_mak                         
  left outer join                        
  closing_last_CDSL on dptdc_isin            = clopm_isin_cd                         
  where  dptdc_dtls_id = @pa_id                        
  and    dptdc_deleted_ind in(0,-1)                        
  order by dptdc_internal_ref_no                        
                           
                            
  --                        
  END                        
  IF @pa_action = 'INT_REF_NO_LISTING_CDSL_MSTR'                        
  BEGIN                        
  --                        
                            
   select @PA_VALUES = isnull(bitrm_bit_location,0) from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_CDSL'                        
                        
    --select top 1 @l_max_date = clopm_dt , @l_rate = clopm_nsdl_rt from closing_price_mstr_nsdl order by 1 desc                        
                            
        
  select dptdc_internal_ref_no        [TRANSACTION NO]                        
  ,dptdc_isin                   ISIN                        
  ,abs(dptdc_qty)    QTY                        
  ,case WHEN abs(dptdC_qty) * CLOPM_CDSL_RT > CONVERT(INT,@PA_VALUES) then 'Y' ELSE 'N' END [HIGH VALUE]                             
  from   dp_trx_dtls_cdsl                         
  left outer join                          
  closing_last_CDSL on dptdc_isin            = clopm_isin_cd                         
  where  dptdc_dtls_id = @pa_id                        
  and    dptdc_deleted_ind = 1          
  order by dptdc_internal_ref_no                                  
                         
                              
  --                        
  END                        
 IF @pa_action = 'HOLM_SEL'                        
  BEGIN                        
  --                        
    SELECT holm.holm_id            holm_id                        
          ,holm.holm_dt            holm_dt                        
          ,holm.holm_desc          holm_desc                         
    FROM   holiday_mstr            holm                        
    WHERE  month(holm.holm_dt)   = convert(NUMERIC,@pa_cd)                        
    AND    year(holm.holm_dt)    = convert(NUMERIC,@pa_rmks)                        
AND    holm.holm_excm_id     = convert(NUMERIC,@pa_desc)                         
    AND    holm.holm_deleted_ind = 1                         
                            
                            
  --                        
  END                        
  IF @pa_action = 'BANK_CLI'                        
  BEGIN                        
  --                        
    SELECT cliba_banm_id  ID                        
     ,banm_name +'-'+ banm_branch +'-'+CONVERT(VARCHAR,banm_micr)  BANK                        
     ,cliba_ac_no         ACCOUNTNO                        
     , CASE WHEN cliba_flg & 1 = 1 THEN 'Y' ELSE 'N' END DEFACC                        
    FROM   client_bank_accts,bank_mstr                        
    WHERE  cliba_banm_id     = banm_id                        
    AND    cliba_clisba_id   = CONVERT(INT,@pa_id )                        
    AND    cliba_deleted_ind = 1                         
    AND    banm_deleted_ind  = 1                         
    AND    cliba_flg & case when @pa_cd = 'D' then  1 else 2 end = case when @pa_cd = 'D' then  1 else 2 end                        
  --                        
  END                        
  IF @pa_action = 'PROC_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct excsm_exch_cd   DEPOSITORY                        
          , brom_id        PROFILEID                        
          , brom_desc      PROFILENAME                        
          , procm.remarks  REMARKS                        
          , proc_id                        
         --, proc_dtls_id                        
                                 
    FROM   exch_seg_mstr       excsm                        
          ,excsm_prod_mstr                        
          ,brokerage_mstr                     
          ,profile_charges     procm                        
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
    where  proc_profile_id    =brom_id                        
    AND    brom_excpm_id      =excpm_id                        
    AND    excpm_excsm_id     =excsm.excsm_id                        
    AND    excsm_list.excsm_id          = excsm.excsm_id                        
    AND    brom_id         like case when @pa_id = '' then '%' else @pa_id end                        
    AND    brom_desc       like case when @pa_cd = '' then '%' else @pa_cd end                        
    AND    excsm_exch_cd   like case when @pa_rmks = '' then '%' else @pa_rmks end                        
    AND    proc_deleted_ind   =1                         
    AND    brom_deleted_ind   =1                         
    AND    excsm_deleted_ind  =1                         
    AND    excpm_deleted_ind  =1       
    order by 3 asc                   
  --                        
  END                        
  IF @pa_action = 'PROC_DTLS_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct cham_slab_no                        
          ,cham_slab_name                        
        ,proc_id                        
    FROM   profile_charges                        
          ,charge_mstr                        
    where  proc_slab_no      =cham_slab_no                        
    AND    proc_id      =@pa_id                        
    AND    proc_deleted_ind  =1                         
    AND    cham_deleted_ind  =1                         
  --                        
  END                        
  IF @pa_action = 'PROC_DTLS_SELM'                        
  BEGIN                        
  --                        
   SELECT distinct cham_slab_no        
    ,cham_slab_name                        
    ,proc_id                        
   FROM   proc_mak                        
         ,charge_mstr                        
   where  proc_slab_no      =cham_slab_no                        
   AND    proc_id      =@pa_id                        
   AND    proc_deleted_ind  =0                         
   AND    cham_deleted_ind  =1                         
  --                        
  END                        
  IF @pa_action = 'PROC_SELM'                        
  BEGIN                        
  --                        
    SELECT distinct excsm_exch_cd  DEPOSITORY                        
  , brom_id          PROFILEID                        
  , brom_desc        PROFILENAME                        
  , procm.remarks    REMARKS                        
  , proc_id                        
  --, proc_dtls_id                        
 FROM   exch_seg_mstr     excsm                         
  ,excsm_prod_mstr                        
  ,brom_mak                        
  ,proc_mak          procm                        
  ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
 where  proc_profile_id = brom_id                        
 AND    brom_excpm_id   = excpm_id                        
 AND    excsm_list.excsm_id          = excsm.excsm_id                        
 AND    excpm_excsm_id  = excsm.excsm_id                        
 AND    brom_id         like case when @pa_id = '' then '%' else @pa_id end                        
 AND    brom_desc       like case when @pa_cd = '' then '%' else @pa_cd end                        
 AND    excsm_exch_cd   like case when @pa_rmks = '' then '%' else @pa_rmks end                        
 AND    proc_deleted_ind  =0                         
 AND    brom_deleted_ind  =0                         
 AND    excsm_deleted_ind  =1                         
 AND    excpm_deleted_ind  =1                         
  --                   
  END                        
  IF @pa_action = 'PROC_SELC'                        
  BEGIN                        
--                        
    SELECT distinct excsm_exch_cd  DEPOSITORY                        
     , brom_id  PROFILEID                        
     , brom_desc PROFILENAME                        
     , remarks   REMARKS                        
     , proc_id                        
     --, proc_dtls_id                        
    FROM   exch_seg_mstr excsm                        
     ,excsm_prod_mstr                        
     ,brom_mak                        
     ,proc_mak                        
     ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
    where  proc_profile_id = brom_id                        
    AND    excsm_list.excsm_id       = excsm.excsm_id                        
    AND    brom_excpm_id   = excpm_id                        
    AND    excpm_excsm_id  = excsm.excsm_id                        
    AND    proc_deleted_ind  =0                         
    AND    brom_deleted_ind  =0                         
    AND    excsm_deleted_ind  =1                         
    AND    excpm_deleted_ind  =1                         
  --                        
  END                        
                          
  IF @pa_action = 'CHAM_SEL'                    
    BEGIN                    
    --                    
      SELECT distinct cham_slab_no SlabNo                    
       ,cham_slab_name        SlabName                    
       ,cham_charge_type      ChargeType                    
       ,cham_charge_base      ChargeBase                    
       ,cham_bill_period      BillPeriod                    
       ,cham_bill_interval    BillInterval                    
       ,cham_charge_baseon    ChargeBaseon                    
       ,cham_charge_graded    ChargeGraded                    
       ,cham_chargebitfor     Exchange             
       ,cham_remarks          Remarks                    
       ,citrus_usr.fn_merge_str('charge_subcm',cham_slab_no,'id')   subcm                    
       ,cham_post_toacct      PostToAccount                          
       --,cham_dtls_id                       
      FROM   exch_seg_mstr  excsm                    
            ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                    
       ,charge_mstr                    
        --left outer join                   
        --charge_isin on cham_slab_no      = chai_slab_no                    
      WHERE  cham_slab_name    LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd  END                    
      AND    excsm.excsm_id       = cham_chargebitfor                    
      AND    excsm_list.excsm_id  = excsm.excsm_id                    
      AND    excsm_exch_cd     = @pa_values                    
      AND    cham_deleted_ind  = 1                     
      AND    excsm_deleted_ind = 1                     
      --AND    isnull(chai_deleted_ind,1)  = 1                    
    --                    
    END                    
    IF @pa_action = 'CHAM_SELM'                    
    BEGIN                    
    --                    
      SELECT  distinct cham_slab_no SlabNo                    
       ,cham_slab_name        SlabName                    
       ,cham_charge_type      ChargeType                    
   ,cham_charge_base      ChargeBase                    
       ,cham_bill_period      BillPeriod                    
       ,cham_bill_interval    BillInterval                    
       ,cham_charge_baseon    ChargeBaseon                    
       ,cham_charge_graded    ChargeGraded                    
       ,cham_chargebitfor     Exchange                    
       ,cham_remarks          Remarks                    
       ,citrus_usr.fn_merge_str('charge_subcm',cham_slab_no,'id')   subcm                    
       ,cham_post_toacct      PostToAccount                    
       --,cham_dtls_id                       
      FROM   exch_seg_mstr excsm                    
            ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                    
            ,cham_mak                     
             --left outer join                    
             --chai_mak  on chai_slab_no      = cham_slab_no                    
      WHERE  cham_slab_name    LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd  END                    
      AND    excsm.excsm_id          = cham_chargebitfor                    
      AND    excsm_list.excsm_id          = excsm.excsm_id                    
      AND    excsm_exch_cd     = @pa_values                    
      AND    cham_deleted_ind  = 0                     
      AND    excsm_deleted_ind = 1                     
      --AND    isnull(chai_deleted_ind,0)  = 0                     
                          
    --                    
  END                    
if @pa_action = 'SUBCM_NSDL'                
    BEGIN                
    --                
   select subcm_cd, subcm_desc                 
   from sub_ctgry_mstr , client_ctgry_mstr                 
   where clicm_id = subcm_clicm_id                 
   and clicm_bit & power(2,4-1) > 0                
    --                
    END                
    if @pa_action = 'SUBCM_CDSL'                
    BEGIN                
    --                
   select subcm_cd, subcm_desc                 
   from sub_ctgry_mstr , client_ctgry_mstr                 
   where clicm_id = subcm_clicm_id                 
   and clicm_bit & power(2,6-1) > 0                
    --                
  END                
                      
  if @pa_action = 'CHAM_DTLS_SEL'                        
  begin                        
  --                        
    SELECT cham_from_factor   FromFactor                        
     ,cham_to_factor     Tofactor                        
     ,cham_val_pers      ValPer                         
     ,cham_charge_value  ChargeValue              
                        
     ,cham_charge_minval ChargeMinimumValue                        
     ,cham_dtls_id                         
     ,cham_slab_no ,isnull(CHAM_PER_MIN,0)CHAM_PER_MIN        
     ,isnull(CHAM_PER_MAX,0)  CHAM_PER_MAX                     
    FROM   charge_mstr                         
    WHERE  cham_slab_no      = @pa_id                        
    AND    cham_deleted_ind  = 1                         
  --                 
  END                        
  if @pa_action = 'CHAM_DTLS_SELM'                        
  begin                        
  --                        
    SELECT cham_from_factor   FromFactor                        
     ,cham_to_factor     Tofactor                        
     ,cham_val_pers      ValPer                         
     ,cham_charge_value  ChargeValue         
                
     ,cham_charge_minval ChargeMinimumValue                        
     ,cham_dtls_id                         
     ,cham_slab_no  ,isnull(CHAM_PER_MIN,0) CHAM_PER_MIN        
     ,isnull(CHAM_PER_MAX,0)   CHAM_PER_MAX                   
    FROM   cham_mak                         
   WHERE  cham_slab_no     = @pa_id                        
    AND    cham_deleted_ind  = 0                        
  --                        
  END                        
  if @pa_action = 'CHAM_SELC'                    
  begin                    
  --                    
                        
    SELECT distinct cham_slab_no SlabNo                    
          ,cham_slab_name        SlabName                    
          ,cham_charge_type      ChargeType                    
          ,cham_charge_base      ChargeBase                    
          ,cham_bill_period      BillPeriod                    
          ,cham_bill_interval    BillInterval                    
          ,cham_charge_baseon    ChargeBaseon                    
          ,cham_charge_graded    ChargeGraded                    
          ,cham_chargebitfor     Exchange                    
          ,cham_remarks          Remarks                    
          ,citrus_usr.fn_merge_str('charge_subcm',cham_slab_no,'id')   subcm                    
          ,cham_post_toacct      PostToAccount                    
          ,cham_deleted_ind                    
          --,cham_dtls_id                     
                              
   FROM    exch_seg_mstr excsm                    
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                    
          , cham_mak                     
           --left outer join                    
           --chai_mak  on chai_slab_no      = cham_slab_no                    
    WHERE  cham_lst_upd_by   <> @pa_login_name                     
    AND    excsm.excsm_id          = cham_chargebitfor                    
    AND    excsm_list.excsm_id          = excsm.excsm_id                    
    AND    excsm_exch_cd     = @pa_cd                    
    AND    cham_deleted_ind  = 0                     
    AND    excsm_deleted_ind = 1                     
    --AND    isnull(chai_deleted_ind,0)  = 0                     
                        
  --                    
  END   
  

IF @pa_action ='DupchkISIN'      
begin
if exists(
Select Isin_cd from TBL_DUP_ISIN where boid=@pa_rmks and isin_cd=@pa_cd
)
	begin
    Select 'Y' flag
	end
	else
	begin
	Select 'N' flag
	end
end
  
IF @pa_action ='TrxfereeAppdatetime'      
begin
if exists(
SELECT ONL_TRXFEREE_BOID FROM ONLINE_DPTRX_BEN_MSTR WHERE ONL_DELETED_IND=1 AND right(ONL_TRXFEREE_BOID,8)=right(@pa_cd,8)
AND DATEDIFF(minute,ONL_CREATED_DT,GETDATE())<=30 and isnull(ONL_TRXFEREE_BOID,'')<>''
UNION ALL
SELECT ONL_CMBPID FROM ONLINE_DPTRX_BEN_MSTR WHERE ONL_DELETED_IND=1 AND right(ONL_CMBPID,8)=right(@pa_cd,8)
AND DATEDIFF(minute,ONL_CREATED_DT,GETDATE())<=30 and isnull(ONL_CMBPID,'')<>''
)
	begin
    Select 'Y' flag
	end
	else
	begin
	Select 'N' flag
	end
end               
    
  
IF @pa_action ='CMBP_BY_BOID'      
begin
Select isnull(accp_value,'') accp_value from ACCOUNT_PROPERTIES,
 dp_acct_mstr where ACCP_CLISBA_ID=DPAM_ID and DPAM_DELETED_IND=1 and ACCP_DELETED_IND=1
and ACCP_ACCPM_PROP_CD='CMBP_ID' 
and dpam_sba_no=right(@pa_cd,16)
end  
  
IF @pa_action = 'CHK_CMBP_ONLINE'                        
BEGIN                          

if exists(
Select ONL_CMBPID from ONLINE_DPTRX_BEN_MSTR where case when left(@pa_desc,2)='IN' then ONL_TRX_BOID ELSE ONL_TRXFEREE_BOID  END =@pa_cd and ONL_CMBPID=@pa_desc)
begin 
Select 'Y' Flag
end
else
begin
Select 'N' Flag
end

end
IF @pa_action = 'Exchange_listing_Online'                        
BEGIN                          


SELECT EXCM_ID,EXCM_CD FROM ACCOUNT_PROPERTIES,EXCHANGE_MSTR WHERE ACCP_CLISBA_ID IN (
SELECT ACCP_CLISBA_ID FROM ACCOUNT_PROPERTIES WHERE  ACCP_VALUE=@pa_cd)
AND ACCP_ACCPM_PROP_CD='CMBPEXCH' 
AND EXCM_CD=ACCP_VALUE
UNION ALL
SELECT CASE WHEN LEFT(DPM_DPID,3)='IN6' THEN '4' WHEN LEFT(DPM_DPID,3)='IN5' THEN '3' ELSE DPM_EXCSM_ID END EXCM_ID,CASE WHEN LEFT(DPM_DPID,3)='IN6' THEN 'BSE' WHEN LEFT(DPM_DPID,3)='IN5' THEN 'NSE' ELSE '' END
as EXCM_CD FROM DP_MSTR WHERE DPM_DPID=@pa_cd AND DPM_DELETED_IND=1

end
                         
  IF @pa_action = 'Exchange_listing'                        
  BEGIN                        
  --                        
    IF @pa_cd = ''                        
    BEGIN                        
    --                        
      SELECT distinct excm_id                        
           , excm_cd                        
      FROM   exchange_mstr                        
           , exch_seg_mstr excsm                        
      WHERE  excsm_exch_cd = excm_cd                        
      AND    excsm_seg_cd <> 'DEPOSITORY'                        
      AND    excsm_deleted_ind = 1                        
      AND    excm_deleted_ind  = 1                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct excm.excm_id                                      
           , excm.excm_cd                        
      FROM   settlement_type_Mstr      settm                        
           , dp_acct_mstr              dpam                        
           , account_properties        accp                        
           , exchange_mstr             excm                         
      WHERE  dpam.dpam_id            = accp.accp_clisba_id                        
      AND    accp.accp_accpm_prop_cd = 'CMBPEXCH'                         
      AND    dpam.dpam_sba_no       = @pa_cd                        
      AND    accp.accp_value         = excm.excm_cd         
      AND    settm.settm_excm_id     = excm.excm_id                        
      AND    settm.settm_deleted_ind = 1                        
      AND    excm.excm_deleted_ind   = 1                        
      AND    dpam.dpam_deleted_ind   = 1                        
      AND    accp.accp_deleted_ind   = 1                        
    --                        
    END                        
  --                        
  END                        
  IF @pa_action = 'ccm_listing'                      BEGIN                        
  --                        
     declare @l_bit_location INT                         
     SELECT @l_bit_location= bitrm_bit_location                        
     FROM   Exch_Seg_Mstr excsm                        
          , exchange_mstr            
          , bitmap_ref_mstr                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
     WHERE  excm_id           = @pa_cd                        
     --AND    excsm_list.excsm_id          = excsm.excsm_id                        
     AND    excm_cd           = excsm_exch_cd                        
     AND    excsm_desc        = bitrm_child_cd                        
     AND    excsm_deleted_ind = 1                        
     AND    excm_deleted_ind  = 1                        
                             
                             
                             
     select ccm_id  ,ccm_name from cc_mstr where convert(int,ccm_excsm_bit) & power(2,@l_bit_location-1) = power(2,@l_bit_location-1) and ccm_deleted_ind = 1                        
                        
                        
  --                        
                          
  END                        
                          
                           
  IF @pa_action = 'Valid_client'                        
  BEGIN                        
  --                        
             
      if @pa_rmks = 'A'                        
      BEGIN                        
      --            
    
        SELECT ltrim(rtrim(isnull(C.CLIM_NAME1,'')))  + ' ' + ltrim(rtrim(isnull(C.CLIM_NAME2,''))) + ' ' +ltrim(rtrim(isnull(C.CLIM_NAME3,''))) CLIM_NAME1                        
              ,ltrim(rtrim(isnull(d.DPHD_SH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_SH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_sH_lNAME,''))) DPHD_SH_FNAME                        
              ,ltrim(rtrim(isnull(d.DPHD_tH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_tH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_tH_lNAME,''))) DPHD_TH_FNAME                        
              ,A.DPAM_SBA_NO                          
              ,CASE  WHEN isnull(citrus_usr.fn_acct_entp(a.dpam_id,'CMBP_ID'),'') = '' THEN 'I' ELSE 'P'END  ACCT_TYPE                           
        FROM   CLIENT_MSTR C                         
              ,(SELECT DISTINCT dpam_crn_no,dpam_id , dpam_sba_no,dpam_stam_cd                        
                FROM   entity_mstr           entm                        
                    ,entity_relationship   entr                        
                      ,exch_seg_mstr         excsm                        
                      ,excsm_prod_mstr       excpm                            
                      ,dp_acct_mstr                        
                      ,login_names                        
                WHERE (entm_id = entr_ho                                   
                       OR entm_id = entr_re                                   
                       OR entm_id = entr_ar                                  
                       OR entm_id = entr_br                                  
                       OR entm_id = entr_sb                                  
                       OR entm_id = entr_dl                                  
                       OR entm_id = entr_rm                                  
                       OR entm_id = entr_dummy1                                  
                       OR entm_id = entr_dummy2                                  
                       OR entm_id = entr_dummy3                                  
                       OR entm_id = entr_dummy4                                  
                       OR entm_id = entr_dummy5                                  
                       OR entm_id = entr_dummy6                            
                       OR entm_id = entr_dummy7                                  
                       OR entm_id = entr_dummy8                                  
                       OR entm_id = entr_dummy9                                  
                       OR entm_id = entr_dummy10)                                  
               AND entr_crn_no   = dpam_crn_no                        
                AND entm_id = logn_ent_id                        
                AND logn_name = @pa_login_name                        
                AND dpam_sba_no   = @pa_cd                         
                AND entr.entr_excpm_id = excpm.excpm_id                        
  AND excpm.excpm_excsm_id = excsm.excsm_id                        
                AND excsm.excsm_exch_cd IN ('CDSL','NSDL')                        
                and dpam_dpm_id  = @l_dpm_dpid) A                          
               LEFT OUTER JOIN                         
               DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID                          
        WHERE  C.CLIM_CRN_NO = A.DPAM_CRN_NO                        
        AND    A.DPAM_SBA_NO =@pa_cd                         
        AND    c.clim_deleted_ind = 1                        
        AND    isnull(d.dphd_deleted_ind,1) = 1                        
        AND    a.dpam_stam_cd = @l_stam_cd                        
          
       --                        
       END                        
       ELSE IF @pa_rmks = 'I'                        
       BEGIN                        
       --                        
          select ltrim(rtrim(isnull(C.CLIM_NAME1,'')))  + ' ' + ltrim(rtrim(isnull(C.CLIM_NAME2,''))) + ' ' +ltrim(rtrim(isnull(C.CLIM_NAME3,''))) CLIM_NAME1                       
           ,ltrim(rtrim(isnull(d.DPHD_SH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_SH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_sH_lNAME,''))) DPHD_SH_FNAME                        
              ,ltrim(rtrim(isnull(d.DPHD_tH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_tH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_tH_lNAME,'') )) DPHD_TH_FNAME                        
                                
          ,DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
    FROM   client_mstr C                        
          ,(SELECT dpam_crn_no,dpam_id , dpam_sba_no,dpam_stam_cd                        
          FROM   entity_mstr           entm                        
          ,entity_relationship   entr                        
          ,exch_seg_mstr         excsm                        
          ,excsm_prod_mstr       excpm                            
          ,dp_acct_mstr                         
          ,login_names                        
          WHERE (entm_id = entr_ho                                   
          OR entm_id = entr_re                                   
          OR entm_id = entr_ar                                  
          OR entm_id = entr_br                              
          OR entm_id = entr_sb                                  
          OR entm_id = entr_dl                         
          OR entm_id = entr_rm                                  
          OR entm_id = entr_dummy1                                  
          OR entm_id = entr_dummy2                                  
          OR entm_id = entr_dummy3                                  
          OR entm_id = entr_dummy4                                  
          OR entm_id = entr_dummy5                                  
          OR entm_id = entr_dummy6                                  
          OR entm_id = entr_dummy7                                  
          OR entm_id = entr_dummy8                                  
          OR entm_id = entr_dummy9                                  
          OR entm_id = entr_dummy10)                                  
          AND entr_crn_no   = dpam_crn_no                        
          AND entm_id = logn_ent_id                        
          AND logn_name = @pa_login_name                        
          AND dpam_sba_no   = @pa_cd                         
          AND entr.entr_excpm_id = excpm.excpm_id                        
          AND excpm.excpm_excsm_id = excsm.excsm_id                        
          AND excsm.excsm_exch_cd IN ('CDSL','NSDL')                        
          and dpam_dpm_id  = @l_dpm_dpid) dpam                        
          left outer join                                                  
          DP_HOLDER_DTLS D  on dpam.DPAM_ID = D.DPHD_DPAM_ID                        
          left outer join                           
          account_properties accp on dpam.DPAM_ID = accp.accp_clisba_id and accp.accp_accpm_prop_cd = 'CMBP_iD'                          
          WHERE C.CLIM_CRN_NO = dpam.DPAM_CRN_NO                          
          AND   dpam.DPAM_SBA_NO =@pa_cd                        
          AND   isnull(accp.accp_value,'') = ''                         
          and   dpam.dpam_stam_cd = @l_stam_cd                        
         /*SELECT details.CLIM_NAME1                        
                        ,details.DPHD_SH_FNAME                        
                        ,details.DPHD_TH_FNAME                         
                        ,details.DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
         FROM   (select hd.CLIM_CRN_NO                        
                       ,ISNULL(hd.CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(hd.DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(hd.DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(hd.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(hd.dpam_id ,0)   dpam_id                         
                       from                         
                      (SELECT CLIM_CRN_NO                        
                       ,ISNULL(CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(a.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(a.dpam_id ,0)       dpam_id                         
                 FROM CLIENT_MSTR C                         
                    , DP_ACCT_MSTR A                         
                      LEFT OUTER JOIN                         
                      DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID                          
                    , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                
         WHERE C.CLIM_CRN_NO = A.DPAM_CRN_NO                        
         AND   A.DPAM_SBA_NO =dpam.dpam_sba_no                        
         AND   A.DPAM_SBA_NO =@pa_cd                        
         AND   A.DPAM_EXCSM_ID=@pa_id) HD)  details                        
         left outer join                        
         account_properties accp               
         on accp.accp_clisba_id = details.dpam_id                         
         and accp.accp_accpm_prop_cd = 'CMBP_iD'                        
         where isnull(accp.accp_value,'') = ''*/                        
       --                        
       END                        
       ELSE IF @pa_rmks = 'P'                        
       BEGIN                        
       --                        
        select ltrim(rtrim(isnull(C.CLIM_NAME1,'')))  + ' ' + ltrim(rtrim(isnull(C.CLIM_NAME2,''))) + ' ' +ltrim(rtrim(isnull(C.CLIM_NAME3,''))) CLIM_NAME1                        
               ,ltrim(rtrim(isnull(d.DPHD_SH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_SH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_sH_lNAME,''))) DPHD_SH_FNAME                        
              ,ltrim(rtrim(isnull(d.DPHD_tH_FNAME,'')))  + ' ' + ltrim(rtrim(isnull(d.DPHD_tH_mNAME,''))) + ' ' +ltrim(rtrim(isnull(d.DPHD_tH_lNAME,''))) DPHD_TH_FNAME                        
                                  
              ,DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
        FROM   client_mstr C                        
              ,(SELECT dpam_crn_no,dpam_id , dpam_sba_no,dpam_stam_cd                        
                FROM   entity_mstr           entm                        
                      ,entity_relationship   entr                        
                      ,exch_seg_mstr         excsm                        
                      ,excsm_prod_mstr       excpm                            
                      ,dp_acct_mstr                         
                      ,login_names                        
                WHERE (entm_id = entr_ho                               
                       OR entm_id = entr_re                                   
                       OR entm_id = entr_ar                                  
                       OR entm_id = entr_br                                  
                       OR entm_id = entr_sb                                  
                       OR entm_id = entr_dl                                  
                       OR entm_id = entr_rm                                  
                       OR entm_id = entr_dummy1                          
                       OR entm_id = entr_dummy2                                  
                       OR entm_id = entr_dummy3                                  
                       OR entm_id = entr_dummy4                                  
                       OR entm_id = entr_dummy5                                  
                       OR entm_id = entr_dummy6                                  
                       OR entm_id = entr_dummy7             
                       OR entm_id = entr_dummy8                                  
                       OR entm_id = entr_dummy9                                  
                       OR entm_id = entr_dummy10)                                  
                AND entr_crn_no   = dpam_crn_no                        
                AND entm_id = logn_ent_id                        
                AND logn_name = @pa_login_name                        
                AND dpam_sba_no   = @pa_cd                         
                AND entr.entr_excpm_id = excpm.excpm_id                        
                AND excpm.excpm_excsm_id = excsm.excsm_id                        
                AND excsm.excsm_exch_cd IN ('CDSL','NSDL')                         
                and dpam_dpm_id  = @l_dpm_dpid) dpam                        
               left outer join                                                  
               DP_HOLDER_DTLS D  on dpam.DPAM_ID = D.DPHD_DPAM_ID                  
               ,account_properties accp                           
        WHERE C.CLIM_CRN_NO = dpam.DPAM_CRN_NO                          
        --AND   dpam.DPAM_SBA_NO           LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd END                        
        AND   dpam.DPAM_SBA_NO           = @pa_cd                         
        and   dpam.DPAM_ID = accp.accp_clisba_id                         
        and   accp.accp_accpm_prop_cd = 'CMBP_iD'                        
        and   accp.accp_value            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END                        
        and   dpam.dpam_stam_cd       = @l_stam_cd                        
                                 
                               
        /* SELECT details.CLIM_NAME1                        
            ,details.DPHD_SH_FNAME                        
               ,details.DPHD_TH_FNAME         
                ,details.DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
                                       
         FROM   (select hd.CLIM_CRN_NO                        
                       ,ISNULL(hd.CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(hd.DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(hd.DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(hd.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(hd.dpam_id ,0)       dpam_id                         
                       from                         
                      (SELECT CLIM_CRN_NO                        
                       ,ISNULL(CLIM_NAME1,'')    CLIM_NAME1                        
                       ,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                       ,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                       ,ISNULL(a.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                       ,isnull(a.dpam_id ,0)       dpam_id                         
                 FROM CLIENT_MSTR C                         
                    , DP_ACCT_MSTR A                         
                      LEFT OUTER JOIN                         
                      DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID                          
                    , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                          
         WHERE C.CLIM_CRN_NO = A.DPAM_CRN_NO                                 AND   A.DPAM_EXCSM_ID=@pa_id                        
         and   dpam.dpam_sba_no = a.dpam_sba_no) HD )  details                        
       ,account_properties accp                        
        WHERE accp.accp_clisba_id = details.dpam_id                         
        and accp.accp_accpm_prop_cd = 'CMBP_iD'                        
        and accp.accp_value            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))     = '' THEN '%' ELSE @pa_desc  END                        
        and details.DPAM_SBA_NO        LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd END*/                        
         
                               
     --                        
     END                        
     ELSE IF @pa_desc <> ''                        
     BEGIN                        
     --                        
       SELECT details.CLIM_NAME1                        
             ,details.DPHD_SH_FNAME                        
             ,details.DPHD_TH_FNAME                        
              ,details.DPAM_SBA_NO + @coldelimiter + @pa_rmks DPAM_ACCT_NO                        
                                     
       FROM   (select hd.CLIM_CRN_NO                        
                     ,ISNULL(hd.CLIM_NAME1,'')    CLIM_NAME1                        
     ,ISNULL(hd.DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                     ,ISNULL(hd.DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                     ,ISNULL(hd.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                     ,isnull(hd.dpam_id ,0)       dpam_id                         
                     from                         
    (SELECT CLIM_CRN_NO                        
                     ,ISNULL(CLIM_NAME1,'')    CLIM_NAME1                        
                     ,ISNULL(DPHD_SH_FNAME,'') DPHD_SH_FNAME                        
                     ,ISNULL(DPHD_TH_FNAME,'') DPHD_TH_FNAME                        
                     ,ISNULL(a.DPAM_SBA_NO,0)   DPAM_SBA_NO                         
                     ,isnull(a.dpam_id ,0)       dpam_id                         
               FROM CLIENT_MSTR C                         
                  , DP_ACCT_MSTR A                         
                    LEFT OUTER JOIN                         
                    DP_HOLDER_DTLS D ON  A.DPAM_ID = D.DPHD_DPAM_ID            
                  , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                          
       WHERE C.CLIM_CRN_NO = A.DPAM_CRN_NO                        
       AND   A.DPAM_SBA_NO =dpam.dpam_sba_no                        
       AND   A.DPAM_SBA_NO =@pa_cd                         
       AND   A.DPAM_EXCSM_ID=@pa_id) HD ) details                        
        ,account_properties accp                        
        WHERE accp_clisba_id = details.dpam_id                         
        and accp_accpm_prop_cd = 'CMBP_iD'                        
          and accp_value <> ''                        
     --                        
     END                        
                             
  --                        
  END                        
  ELSE IF @pa_action = 'VALID_CLIENT_ALL_STATUS'                        
  BEGIN                        
   select DPAM_ID,DPAM_SBA_NAME                        
   FROM DP_ACCT_MSTR                        
   WHERE DPAM_SBA_NO =@pa_cd and DPAM_STAM_CD <> '05'                        
                        
  END                        
  ELSE IF @pa_action = 'HOLM_SELM'                        
  BEGIN                        
  --                       
    SELECT holmm.holm_id            holm_id                        
          ,holmm.holm_dt            holm_dt                        
          ,holmm.holm_desc          holm_desc                        
    FROM   holm_mak                 holmm                        
    WHERE  month(holmm.holm_dt)   = convert(NUMERIC,@pa_cd)                        
    AND    year(holmm.holm_dt)    = convert(NUMERIC,@pa_rmks)                        
    AND    holmm.holm_excm_id     = convert(NUMERIC,@pa_desc)                         
    AND    holmm.holm_deleted_ind   IN (0,4)                        
                            
    UNION                        
                            
    SELECT holm.holm_id            holm_id                        
          ,holm.holm_dt            holm_dt                  
          ,holm.holm_desc          holm_desc                        
    FROM   holiday_mstr            holm                        
    WHERE  month(holm.holm_dt)   = convert(NUMERIC,@pa_cd)                        
    AND    year(holm.holm_dt)    = convert(NUMERIC,@pa_rmks)                        
    AND    holm.holm_excm_id     = convert(NUMERIC,@pa_desc)                         
    AND    holm.holm_deleted_ind = 1                        
    AND    holm_id NOT IN (SELECT holm_id from holm_mak )--where holm_deleted_ind = 0)                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'HOLM_SELC'                        
  BEGIN                        
  --                        
    SELECT holmm.holm_id            holm_id                        
          ,holmm.holm_dt            holm_dt                        
          ,holmm.holm_desc          holm_desc                        
          ,excm_short_name          excm_desc                        
    FROM   holm_mak                 holmm                        
          ,exchange_mstr            excm                        
    WHERE  holmm.holm_deleted_ind   IN (0,4)                        
    AND    holmm.holm_lst_upd_by  <>@pa_login_name                        
    AND    holmm.holm_excm_id     = excm.excm_id                        
  --                        
  END                      
  ELSE IF @pa_action = 'ISINM_SEARCH'                        
  BEGIN                        
  --                        
    SELECT isinm.isin_cd               isin_cd                        
         , isinm.isin_name             isin_name                        
         , isinm.isin_reg_cd           isin_reg_cd                        
         , isinm.isin_conv_dt          isin_conv_dt                        
         , isinm.isin_status           isin_status                        
         , isinm.isin_bit              isin_bit                        
    FROM   isin_mstr                   isinm                        
    WHERE  isinm.isin_deleted_ind   = 1                          
  --                      
  END                        
  ELSE IF @pa_action = 'ISINM_SEARCHM'                        
  BEGIN                        
  --                        
    SELECT isinm.isin_cd               isin_cd                        
         , isinm.isin_name             isin_name                        
         , isinm.isin_reg_cd           isin_reg_cd                        
         , isinm.isin_conv_dt          isin_conv_dt                        
         , isinm.isin_status           isin_status                        
         , isinm.isin_bit              isin_bit                        
    FROM   isinm_mak isinm                        
    WHERE  isinm.isin_deleted_ind    = 0                        
    AND    isinm.isin_lst_upd_by     = @pa_login_name                         
               
  --                        
  END                        
  ELSE IF @pa_action = 'ISINM_SEARCHC'                        
  BEGIN                        
  --                        
    SELECT isinm.isin_cd               isin_cd                        
         , isinm.isin_name             isin_name                        
         , isinm.isin_reg_cd           isin_reg_cd                        
         , isinm.isin_conv_dt          isin_conv_dt                        
         , isinm.isin_status           isin_status                        
         , isinm.isin_bit              isin_bit                        
    FROM   isinm_mak                   isinm               
    WHERE  isinm.isin_deleted_ind    = 0                        
    AND    isinm.isin_lst_upd_by     <>@pa_login_name                         
  --                        
  END                        
  ELSE IF @pa_action = 'ISINM_SEL'                        
  BEGIN                        
  --                        
    SELECT isinm.isin_cd               isin_cd                        
         , isinm.isin_name             isin_name                        
         , isinm.isin_reg_cd           isin_reg_cd                        
         , isinm.isin_conv_dt          isin_conv_dt                        
         , isinm.isin_status           isin_status                   
         , isinm.isin_bit              isin_bit                        
    FROM   isin_mstr                   isinm                        
    WHERE  isinm.isin_cd             = @pa_cd                        
    AND    isinm.isin_name           = @pa_desc                        
    AND    isinm.isin_deleted_ind    = 1                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'ISINM_SELM'                        
  BEGIN                        
 --                        
    SELECT isinmm.isin_cd               isin_cd                        
         , isinmm.isin_name             isin_name                        
         , isinmm.isin_reg_cd           isin_reg_cd                        
         , isinmm.isin_conv_dt          isin_conv_dt                        
         , isinmm.isin_status           isin_status                        
         , isinmm.isin_bit              isin_bit                        
    FROM   isin_mak                     isinmm                        
    WHERE  isinmm.isin_cd             = @pa_cd                        
    AND    isinmm.isin_name           = @pa_desc                        
    AND    isinmm.isin_deleted_ind    IN (0,4)                        
    AND    isinmm.isin_created_by     = @pa_login_name                        
  --                        
  END                        
  ELSE IF @pa_action = 'ISINM_SELC'                        
  BEGIN                        
  --                        
    SELECT isinmm.isin_cd               isin_cd                        
         , isinmm.isin_name             isin_name                        
         , isinmm.isin_reg_cd           isin_reg_cd                        
         , isinmm.isin_conv_dt          isin_conv_dt                        
         , isinmm.isin_status           isin_status                        
         , isinmm.isin_bit              isin_bit                        
    FROM   isin_mak                     isinmm                        
    WHERE  isinmm.isin_name           = @pa_desc                        
    AND    isinmm.isin_deleted_ind    IN (0,4)                        
    AND    isinmm.isin_lst_upd_by     <>@pa_login_name                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETTM_SEARCH'                        
  BEGIN                        
  --                        
    SELECT DISTINCT settm.settm_type    settm_type                        
         , settm.settm_desc             settm_desc                 
                                
 FROM   settlement_type_mstr         settm                        
    WHERE  settm.settm_deleted_ind    = 1                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETTM_SEARCHM'                        
  BEGIN                        
  --                        
 SELECT DISTINCT settm.settm_type    settm_type                        
         , settm.settm_desc             settm_desc                        
                                
    FROM   settm_mak                    settm                        
    WHERE  settm.settm_deleted_ind      IN(0,8)                        
    AND    settm.settm_lst_upd_by     = @pa_login_name                   
  --                        
  END                        
  ELSE IF @pa_action = 'SETTM_SEARCHC'                        
  BEGIN                        
  --                        
    SELECT DISTINCT settm.settm_type    settm_type                        
         , settm.settm_desc             settm_desc                        
                                 
    FROM   settm_mak                    settm                        
    WHERE  settm.settm_deleted_ind      IN(0,8)                        
    AND    settm.settm_lst_upd_by    <> @pa_login_name                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETTM_SEL'                        
  BEGIN                        
  --                        
    SELECT settm.settm_id               settm_id                        
         , settm.settm_excm_id          settm_excm_id                        
         , settm.settm_type             settm_type                        
         , settm.settm_type_cdsl        settm_type_cdsl                        
         , settm.settm_desc             settm_desc                        
         , ''                           errmsg                        
    FROM   settlement_type_mstr         settm                        
    WHERE  settm.settm_desc         LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                        
    AND    settm.settm_deleted_ind    = 1          
                            
  --                        
  END                        
  ELSE IF @pa_action = 'SETTM_SELM'                        
  BEGIN                        
  --                        
    SELECT settmm.settm_id               settm_id                        
         , settmm.settm_excm_id          settm_excm_id                        
         , settmm.settm_type             settm_type                        
         , settmm.settm_type_cdsl        settm_type_cdsl                        
         , settmm.settm_desc             settm_desc                        
         , ''                            errmsg                        
    FROM   settm_mak                    settmm                        
    WHERE  settmm.settm_desc          LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                        
    AND    settmm.settm_deleted_ind      IN(0,4)                        
    AND    settmm.settm_created_by     = @pa_login_name                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'SETTM_SELC'                        
  BEGIN                        
  --                        
    SELECT settmm.settm_id               settm_id                        
         , settmm.settm_excm_id          settm_excm_id                        
         , settmm.settm_type             settm_type                        
         , settmm.settm_type_cdsl        settm_type_cdsl                        
         , settmm.settm_desc             settm_desc                        
   , settm_deleted_ind                                     
         , ''                           errmsg                        
    FROM   settm_mak                    settmm                        
    WHERE  settmm.settm_desc          LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                        
    AND    settmm.settm_deleted_ind      IN(0,4)                        
    AND    settmm.settm_lst_upd_by     <>@pa_login_name                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'SETM_SEARCH'                        
  BEGIN                        
  --                        
    SELECT DISTINCT setm_settm_id                           
          ,settm_desc                          
    FROM   settlement_mstr             setm                          
       ,   settlement_type_mstr  settm                           
    WHERE  setm.setm_deleted_ind     = 1                         
    AND    settm.settm_id            = setm.setm_settm_id                          
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETM_SEARCHM'                        
  BEGIN                        
  --                        
    SELECT DISTINCT setm_settm_id                           
          ,settm_desc                          
    FROM   setm_mak                    setm                        
       ,   settlement_type_mstr        settm                    
    WHERE  setm.setm_deleted_ind     = 0                        
    AND    settm.settm_id            = setm.setm_settm_id                        
    AND    setm.setm_lst_upd_by      = @pa_login_name                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETM_SEARCHC'                        
  BEGIN                        
  --                        
    SELECT DISTINCT setm_settm_id                           
          ,settm_desc                          
    FROM   setm_mak                    setm                        
       ,   settlement_type_mstr         settm                   
    WHERE  setm.setm_deleted_ind     = 0                        
    AND    settm.settm_id            = setm.setm_settm_id                        
    AND    setm.setm_lst_upd_by      <>@pa_login_name                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETM_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct settm_desc   settlement                         
    ,setm_no    settmno              
    ,excm_cd    exchange                        
    ,ccm_name    clearingcorp                        
     , CONVERT(VARCHAR(11),setm.setm_start_dt,103)          startdate                            
     , CONVERT(VARCHAR(11),setm.setm_end_dt,103)            enddate                            
     , CONVERT(VARCHAR(11),setm.setm_deadline_dt,103)  deadlinedate                             
     , setm.setm_deadline_time             deadlinetime                        
     , CONVERT(VARCHAR(11),setm.setm_payin_dt,103)          payindate                            
     , CONVERT(VARCHAR(11),setm.setm_payout_dt,103)         payoutdate                            
     , CONVERT(VARCHAR(11),setm.setm_auction_dt,103)        auctiondate                           
    ,setm_id                              
    ,''                              errmsg                          
    FROM                         
    settlement_type_mstr     settm                        
    ,settlement_mstr       setm                        
    ,exchange_mstr          exch                        
    ,cc_mstr      cc                        
    WHERE setm.setm_settm_id = settm.settm_id                         
    AND  exch.excm_id = setm.setm_excm_id                          
    AND cc.ccm_id = setm.setm_ccm_id                        
    AND  setm.setm_settm_id       LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END                            
    AND    setm.setm_no             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                            
    AND    setm.setm_deleted_ind     = 1                  
  --                        
  END                        
  ELSE IF @pa_action = 'SETM_SELM'                        
  BEGIN                        
  --                        
     IF @pa_values <> ''                          
     BEGIN                        
     --                          
     SELECT distinct settm_desc        settlement                         
    ,setm_no   settmno                        
    ,excm_cd   exchange                        
    ,ccm_name   clearingcorp                        
    , CONVERT(VARCHAR(11),setm.setm_start_dt,103)          startdate                            
    , CONVERT(VARCHAR(11),setm.setm_end_dt,103)            enddate                            
    , CONVERT(VARCHAR(11),setm.setm_deadline_dt,103)       deadlinedate                             
    , setm.setm_deadline_time             deadlinetime                        
    , CONVERT(VARCHAR(11),setm.setm_payin_dt,103)          payindate                            
    , CONVERT(VARCHAR(11),setm.setm_payout_dt,103)         payoutdate                            
    , CONVERT(VARCHAR(11),setm.setm_auction_dt,103)        auctiondate                           
    ,setm_id                              
    ,''                              errmsg                          
   FROM                         
   settlement_type_mstr           settm                        
   ,setm_mak         setm                        
   ,exchange_mstr           exch                        
   ,cc_mstr      cc                        
   WHERE setm.setm_settm_id = settm.settm_id                         
   AND  exch.excm_id = setm.setm_excm_id                          
   AND cc.ccm_id = setm.setm_ccm_id                        
   AND  setm.setm_id = @pa_values                         
   AND  setm.setm_deleted_ind    in (0,4,6)                        
   AND  exch.excm_deleted_ind     = 1                         
   AND  cc.ccm_deleted_ind     = 1                         
  --                         
  END                         
   ELSE                        
   BEGIN                        
--                        
   SELECT distinct settm_desc        settlement                         
   ,setm_no   settmno                        
   ,excm_cd   exchange                        
   ,ccm_name   clearingcorp                        
    , CONVERT(VARCHAR(11),setm.setm_start_dt,103)          startdate                            
    , CONVERT(VARCHAR(11),setm.setm_end_dt,103)            enddate                            
    , CONVERT(VARCHAR(11),setm.setm_deadline_dt,103)       deadlinedate                             
    , setm.setm_deadline_time             deadlinetime                        
    , CONVERT(VARCHAR(11),setm.setm_payin_dt,103)          payindate                            
    , CONVERT(VARCHAR(11),setm.setm_payout_dt,103)         payoutdate                            
    , CONVERT(VARCHAR(11),setm.setm_auction_dt,103)        auctiondate                           
   ,setm_id                              
   ,''                              errmsg                          
   FROM                         
   settlement_type_mstr            settm                        
   ,setm_mak         setm                        
   ,exchange_mstr           exch                        
   ,cc_mstr      cc                        
   where setm.setm_settm_id = settm.settm_id                         
   AND  exch.excm_id = setm.setm_excm_id                          
   AND cc.ccm_id = setm.setm_ccm_id                        
   AND  setm.setm_settm_id       LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END                         
   AND  setm.setm_no             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                            
   AND  setm.setm_deleted_ind     in (0,4,6)                        
   AND  exch.excm_deleted_ind     = 1                         
   AND  cc.ccm_deleted_ind     = 1                         
                           
END                        
  --                        
  END                        
  ELSE IF @pa_action = 'SETM_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct settm_desc        settlement                         
    ,setm_no   settmno                        
    ,excm_cd   exchange                        
    ,ccm_name   clearingcorp                        
     , CONVERT(VARCHAR(11),setm.setm_start_dt,103)         startdate                            
     , CONVERT(VARCHAR(11),setm.setm_end_dt,103)            enddate                            
     , CONVERT(VARCHAR(11),setm.setm_deadline_dt,103)       deadlinedate                             
     , setm.setm_deadline_time             deadlinetime                        
     , CONVERT(VARCHAR(11),setm.setm_payin_dt,103)          payindate                            
     , CONVERT(VARCHAR(11),setm.setm_payout_dt,103)         payoutdate                            
     , CONVERT(VARCHAR(11),setm.setm_auction_dt,103)        auctiondate                           
    ,setm_id                         
    ,setm_deleted_ind                            
    ,''                              errmsg                          
    FROM                         
    settlement_type_mstr            settm                        
    ,setm_mak         setm                        
    ,exchange_mstr           exch                        
    ,cc_mstr   cc                        
    WHERE setm.setm_settm_id = settm.settm_id                         
    AND  exch.excm_id = setm.setm_excm_id                          
    AND cc.ccm_id = setm.setm_ccm_id                        
    AND    setm.setm_lst_upd_by     <> @pa_login_name                          
    AND  setm.setm_deleted_ind  in (0,4,6)                        
    AND  exch.excm_deleted_ind     = 1                         
    AND  cc.ccm_deleted_ind     = 1                         
  --                        
  END                        
  ELSE IF @pa_action = 'SLIBM_SEARCH'                        
  BEGIN                        
  --                        
    SELECT slibm.slibm_series_type   slibm_series_type                     
    FROM   slip_book_mstr             slibm                            
    WHERE  slibm.slibm_deleted_ind  = 1            
  --         
  END                        
  ELSE IF @pa_action = 'SLIBM_SEARCHM'                        
    BEGIN                        
    --                        
      SELECT slibm.slibm_series_type   slibm_series_type                        
      FROM   slibm_mak                  slibm                            
      WHERE  slibm.slibm_deleted_ind  = 0                        
      AND    slibm.slibm_lst_upd_by   = @pa_login_name                        
                          
    --                        
  END                        
  ELSE IF @pa_action = 'SLIBM_SEARCHC'                        
    BEGIN                        
    --e                        
      SELECT slibm.slibm_series_type   slibm_series_type                        
      FROM   slibm_mak                 slibm                            
      WHERE  slibm.slibm_deleted_ind = 0                         
      AND    slibm.slibm_lst_upd_by  <>@pa_login_name                        
    --                        
  END                        
  ELSE IF @pa_action = 'SLIBM_SEL'                        
  BEGIN                        
  --                        
    IF @pa_desc = ''                        
    BEGIN                        
    --                        
      SET @pa_desc = null                        
    --                        
    END                        
                             
    SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPNAME                        
          ,dpm_name             DepositoryName                         
          ,trastm_desc          TransactionType                        
          ,dpm_dpid             Depository                        
          ,slibm_series_type    SeriesType                        
          ,slibm_from_no        FromNo                        
          ,slibm_to_no          ToNo                        
          ,slibm_no_of_slips    NoOfSlips                        
          ,slibm_reorder_no     ReOrderNO                        
          ,convert(varchar(11),slibm_reorder_dt,103)     ReOrderDate                        
          ,slibm_rmks           Remarks                        
          ,slibm_id             ID          
    FROM   slip_book_mstr                        
          ,transaction_sub_type_mstr                        
          ,dp_mstr                        
          ,company_mstr                               
          ,exch_seg_mstr excsm                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
    WHERE  slibm_dpm_id       = dpm_id                        
    AND    slibm_tratm_id     = trastm_id                        
    AND    dpm_dpid           = @pa_cd                        
    AND    excsm_list.excsm_id          = excsm.excsm_id                        
    AND    trastm_id          = CASE WHEN LTRIM(RTRIM(@pa_id)) = '' THEN trastm_id ELSE convert(numeric, @pa_id) END                         
    AND    dpm_excsm_id       = excsm.excsm_id                          
    AND    excsm_compm_id     = compm_id                         
    AND    slibm_series_type  LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks))     = '' THEN '%' ELSE @pa_rmks  END                        
    AND    isnull(@pa_desc,slibm_from_no)  between slibm_from_no  and slibm_to_no                         
    AND    trastm_deleted_ind = 1                        
    AND    dpm_deleted_ind    = 1                        
    AND    slibm_deleted_ind = 1                        
  --                        
  END                        
  ELSE IF @pa_action = 'SLIBM_SELM'                        
  BEGIN                        
  --                        
    IF @pa_desc = ''                        
    BEGIN                        
    --                        
      set @pa_desc = null                        
    --                        
    END                        
                            
    IF @pa_values <> ''                        
    BEGIN                        
    --                        
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPNAME                        
            ,dpm_name             DepositoryName                         
            ,trastm_desc          TransactionType                        
            ,dpm_dpid             Depository                        
            ,slibm_series_type    SeriesType                        
            ,slibm_from_no        FromNo                        
            ,slibm_to_no          ToNo                        
            ,slibm_no_of_slips    NoOfSlips                        
            ,slibm_reorder_no     ReOrderNO                        
,convert(varchar(11),slibm_reorder_dt,103)     ReOrderDate                        
            ,slibm_rmks           Remarks                        
            ,slibm_id             ID                        
      FROM   slibm_mak                        
            ,transaction_sub_type_mstr                        
            ,dp_mstr                        
            ,company_mstr                               
            ,exch_seg_mstr excsm                        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  slibm_dpm_id       = dpm_id                        
      AND    slibm_tratm_id     = trastm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    dpm_excsm_id       = excsm.excsm_id                          
      AND    excsm_compm_id     = compm_id                         
      AND    trastm_deleted_ind = 1                        
      AND    slibm_id           = @pa_values                        
      AND    dpm_deleted_ind    = 1                        
      AND    slibm_deleted_ind  IN (0,4,6)                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPNAME                        
            ,dpm_name             DepositoryName                         
            ,trastm_desc          TransactionType                        
            ,dpm_dpid             Depository                        
            ,slibm_series_type    SeriesType                        
            ,slibm_from_no        FromNo                        
            ,slibm_to_no         ToNo                        
            ,slibm_no_of_slips    NoOfSlips                        
            ,slibm_reorder_no     ReOrderNO                        
            ,convert(varchar(11),slibm_reorder_dt,103)     ReOrderDate                        
            ,slibm_rmks           Remarks                        
            ,slibm_id             ID                        
      FROM   slibm_mak                        
            ,transaction_sub_type_mstr                        
            ,dp_mstr                        
            ,company_mstr                               
            ,exch_seg_mstr excsm                        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  slibm_dpm_id       = dpm_id                        
      AND    slibm_tratm_id     = trastm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    dpm_dpid           = @pa_cd                        
      AND    trastm_id          = CASE WHEN LTRIM(RTRIM(@pa_id)) = '' THEN trastm_id ELSE convert(numeric, @pa_id) END                         
      AND    dpm_excsm_id       = excsm.excsm_id                          
      AND    excsm_compm_id     = compm_id                          
      AND    slibm_series_type  LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks))     = '' THEN '%' ELSE @pa_rmks END                        
      AND    isnull(@pa_desc,slibm_from_no)  between slibm_from_no  and slibm_to_no                         
      AND    trastm_deleted_ind = 1                        
      AND    dpm_deleted_ind    = 1                        
      AND    slibm_deleted_ind  IN (0,4,6)                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'SLIBM_SELC'                        
  BEGIN                        
  --                        
    SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPNAME                        
          ,trastm_desc   TransactionType                        
     ,dpm_dpid             Depository                        
          ,slibm_series_type    SeriesType                        
          ,slibm_from_no        FromNo                        
          ,slibm_to_no          ToNo                        
          ,slibm_no_of_slips    NoOfSlips                        
          ,slibm_reorder_no     ReOrderNO                        
          ,convert(varchar(11),slibm_reorder_dt,103)     ReOrderDate                        
          ,slibm_rmks           Remarks                        
          ,slibm_id             ID                        
  ,slibm_deleted_ind    slibm_deleted_ind                        
                                  
    FROM   slibm_mak                        
          ,transaction_sub_type_mstr                        
          ,dp_mstr                        
          ,company_mstr                               
          ,exch_seg_mstr excsm                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
    WHERE  slibm_dpm_id       = dpm_id                        
    AND    slibm_tratm_id     = trastm_id                        
    AND    excsm_list.excsm_id          = excsm.excsm_id                        
    AND    dpm_excsm_id       = excsm.excsm_id                          
    AND    excsm_compm_id     = compm_id                          
    AND    trastm_deleted_ind = 1                        
    AND    dpm_deleted_ind    = 1                        
    AND    dpm_excsm_id       =CONVERT(INT,@pa_cd)                        
    AND    slibm_lst_upd_by   <> @pa_login_name                        
    AND    slibm_deleted_ind  IN (0,4,6)                        
  --                        
  END                        
  /*ELSE IF @pa_action = 'ENTSBIM_SEARCH'                        
  BEGIN                        
  --                        
    SELECT entsbim_entm_id                        
         --, entsbim_excm_id                        
         , entsbim_dpam_sba_no                        
         , entsbim_dpm_id                        
         , entsbim_series_type                        
         , entsbim_from_no                        
         , entsbim_to_no                        
    FROM   entity_slip_book_issue_mstr                            
    WHERE  entsbim_deleted_ind  = 1                          
  --                        
  END                        
  ELSE IF @pa_action = 'ENTSBIM_SEARCHM'                        
  BEGIN                        
  --                        
    SELECT entsbim_id                        
         , entsbim_entm_id                        
         --, entsbim_excm_id                        
         , entsbim_dpam_sba_no                        
         , entsbim_dpm_id                        
         , entsbim_series_type                        
         , entsbim_from_no                        
         , entsbim_to_no                        
    FROM   entsbim_mak                                            
    WHERE  entsbim_deleted_ind  = 0                          
    AND    entsbim_lst_upd_by   = @pa_login_name                        
  --                        
  END                        
  ELSE IF @pa_action = 'ENTSBIM_SEARCHC'                        
  BEGIN                        
  --                        
    SELECT entsbim_id                        
         , entsbim_entm_id                        
         --, entsbim_excm_id                        
         , entsbim_dpam_sba_no                        
         , entsbim_dpm_id                        
         , entsbim_series_type                        
         , entsbim_from_no                        
     , entsbim_to_no                        
    FROM   entsbim_mak                                            
    WHERE  entsbim_deleted_ind  = 0                          
    AND    entsbim_lst_upd_by   <> @pa_login_name                        
  --                        
  END*/                        
  ELSE IF @pa_action = 'ENTSBIM_SEL'                        
  BEGIN                        
  --                        
    IF @pa_rmks <> ''                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                       DpID                        
       , enttm_desc                     EntityType                        
           , entm_short_name                EntityName                        
           , entsbim_dpam_sba_no            AccountNo                        
           , entsbim_series_type            SeriesType                        
           , entsbim_from_no                FromBookNo                        
           , entsbim_to_no                  ToBookNo                        
           , entsbim_id                                     
           , entm_id              
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                             errmsg                        
      FROM   entity_slip_book_issue_mstr    entsbim                        
          , dp_mstr                        dpm                         
           , entity_mstr                    entm                        
           , entity_type_mstr               enttm                        
           , company_mstr                   compm                        
           , exch_seg_mstr                  excsm                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  entsbim.entsbim_deleted_ind  = 1                          
      AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
      AND    entsbim.entsbim_entm_id      = entm.entm_id                        
      AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entsbim_series_type            LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    @PA_RMKS                       BETWEEN entsbim_from_no AND entsbim_to_no                        
      AND    convert(varchar,excsm_id)      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC    END                        
      AND    dpm_excsm_id                 = excsm_id                        
      AND    excsm_compm_id               = compm_id                          
      AND    excsm_deleted_ind            = 1                          
      AND    compm_deleted_ind            = 1                          
      AND    entm.entm_deleted_ind        = 1                         
      AND    enttm.enttm_deleted_ind      = 1                         
      AND    dpm.dpm_deleted_ind          = 1                         
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                       DpID                        
           , enttm_desc                     EntityType                        
           , entm_short_name                EntityName                        
           , entsbim_dpam_sba_no            AccountNo                        
           , entsbim_series_type            SeriesType                        
           , entsbim_from_no                FromBookNo                        
           , entsbim_to_no                  ToBookNo                        
           , entsbim_id                                     
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                             errmsg                        
      FROM   entity_slip_book_issue_mstr    entsbim                        
           , dp_mstr                        dpm                         
           , entity_mstr                    entm                        
           , entity_type_mstr               enttm                        
           , company_mstr                   compm                        
           , exch_seg_mstr                  excsm                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
   WHERE  entsbim.entsbim_deleted_ind  = 1                          
      AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
      AND    entsbim.entsbim_entm_id      = entm.entm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
      AND    entsbim_series_type          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    convert(varchar,excsm_id)      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC    END                        
  AND    dpm_excsm_id      = excsm_id                        
      AND    excsm_compm_id               = compm_id                          
      AND    excsm_deleted_ind            = 1                          
      AND    compm_deleted_ind            = 1                          
      AND    entm.entm_deleted_ind        = 1         
      AND    enttm.enttm_deleted_ind   = 1                         
      AND    dpm.dpm_deleted_ind          = 1                          
    --                        
    END                  
                        
                        
--                        
  END                        
  ELSE IF @pa_action = 'ENTSBIM_SELM'                        
  BEGIN                        
  --                   
    IF @PA_ID <> ''                        
    BEGIN                        
    --                        
      SELECT dpm_dpid              DpID                        
           , enttm_desc                     EntityType                        
           , entm_short_name                EntityName                        
           , entsbim_dpam_sba_no            AccountNo                        
           , entsbim_series_type            SeriesType                        
           , entsbim_from_no                FromBookNo                        
        , entsbim_to_no                  ToBookNo                        
           , entsbim_id                                     
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                             errmsg                        
      FROM   entsbim_mak                    entsbim                        
           , dp_mstr                        dpm                         
           , entity_mstr                    entm                        
           , entity_type_mstr               enttm                        
           , company_mstr                   compm                         
           , exch_seg_mstr                  excsm                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  entsbim.entsbim_deleted_ind  = 0                        
      AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entsbim.entsbim_entm_id      = entm.entm_id                        
      AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
      AND    dpm_excsm_id            = excsm.excsm_id                        
      AND    excsm_compm_id          = compm_id                          
      AND    excsm_deleted_ind       = 1                          
      AND    compm_deleted_ind       = 1                          
      AND    entsbim.entsbim_id           = convert(numeric,@pa_id)                        
      AND    entm.entm_deleted_ind        = 1                         
      AND    enttm.enttm_deleted_ind      = 1                         
      AND    dpm.dpm_deleted_ind          = 1                         
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      IF @pa_rmks <> ''                        
      BEGIN                        
      --                        
        SELECT dpm_dpid                       DpID                        
             , enttm_desc                     EntityType                        
             , entm_short_name   EntityName                        
             , entsbim_dpam_sba_no            AccountNo          
             , entsbim_series_type            SeriesType                        
             , entsbim_from_no                FromBookNo                        
             , entsbim_to_no                  ToBookNo                        
             , entsbim_id                                     
             , entm_id                        
             , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
             , ''                             errmsg                        
        FROM   entsbim_mak            entsbim                        
             , dp_mstr                        dpm                         
             , entity_mstr                    entm                                   , entity_type_mstr               enttm                        
             , company_mstr      compm                        
             , exch_seg_mstr                  excsm                          
             , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        WHERE  entsbim.entsbim_deleted_ind  = 0                        
        AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
        AND    entsbim.entsbim_entm_id      = entm.entm_id                        
        AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
        AND    excsm_list.excsm_id          = excsm.excsm_id                        
        AND    dpm_excsm_id         = excsm.excsm_id                        
        AND    excsm_compm_id               = compm_id                          
AND    excsm_deleted_ind            = 1                          
AND    compm_deleted_ind            = 1                         
        AND    entsbim_series_type            LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END                        
        AND    @PA_RMKS                       BETWEEN entsbim_from_no AND entsbim_to_no                        
        AND    convert(varchar,excsm.excsm_id)      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC    END                        
        AND    entm.entm_deleted_ind        = 1                         
        AND    enttm.enttm_deleted_ind      = 1                         
        AND    dpm.dpm_deleted_ind          = 1                         
      --                        
      END                        
      ELSE                         
      BEGIN                        
      --                        
        SELECT dpm_dpid                       DpID                        
             , enttm_desc                     EntityType                        
             , entm_short_name                EntityName                        
             , entsbim_dpam_sba_no            AccountNo                        
             , entsbim_series_type            SeriesType                        
             , entsbim_from_no                FromBookNo                        
             , entsbim_to_no                  ToBookNo                        
             , entsbim_id                                     
             , entm_id                        
             , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
             , ''                             errmsg                        
        FROM   entsbim_mak                    entsbim                        
             , dp_mstr                        dpm                         
             , entity_mstr                    entm                        
             , entity_type_mstr               enttm                        
             , company_mstr                   compm                        
             , exch_seg_mstr                  excsm                          
             , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        WHERE  entsbim.entsbim_deleted_ind  = 0                        
        AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
        AND    entsbim.entsbim_entm_id      = entm.entm_id                        
        AND    excsm_list.excsm_id          = excsm.excsm_id                      
        AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
        AND    dpm_excsm_id                 = excsm.excsm_id                        
        AND    excsm_compm_id               = compm_id                          
        AND    excsm_deleted_ind            = 1                          
        AND    compm_deleted_ind            = 1                         
        AND    entsbim_series_type            LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
        AND    convert(varchar,excsm.excsm_id)      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC    END                        
        AND    entm.entm_deleted_ind        = 1                         
        AND    enttm.enttm_deleted_ind      = 1                         
        AND    dpm.dpm_deleted_ind          = 1                         
      --                        
      END                        
    --                        
    END                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'ENTSBIM_SELC'                        
  BEGIN                        
  --                        
    IF  @pa_rmks <> ''                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                       DpID                        
           , enttm_desc                     EntityType                        
           , entm_short_name                EntityName                        
           , entsbim_dpam_sba_no            AccountNo                        
           , entsbim_series_type            SeriesType                        
           , entsbim_from_no                FromBookNo                        
           , entsbim_to_no                  ToBookNo                        
           , entsbim_id                                     
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                             errmsg                        
      FROM   entsbim_mak                    entsbim                        
           , dp_mstr                        dpm                         
           , entity_mstr                    entm                        
           , entity_type_mstr               enttm                        
           , company_mstr                   compm                        
           , exch_seg_mstr                  excsm                         
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  entsbim.entsbim_deleted_ind  = 0                          
      AND    entsbim.entsbim_lst_upd_by  <> @pa_login_name                        
      AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
      AND    excsm_list.excsm_id  = excsm.excsm_id                        
      AND    entsbim.entsbim_entm_id      = entm.entm_id                        
      AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
      AND    dpm_excsm_id                 = excsm.excsm_id                        
      AND    excsm_compm_id               = compm_id                          
      AND    excsm_deleted_ind            = 1                          
      AND    compm_deleted_ind            = 1                          
      AND    entsbim_series_type            LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    @PA_RMKS                       BETWEEN entsbim_from_no AND entsbim_to_no                        
      AND    convert(varchar,excsm.excsm_id)      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC    END                        
      AND    entm.entm_deleted_ind        = 1                         
      AND    enttm.enttm_deleted_ind      = 1                         
      AND    dpm.dpm_deleted_ind          = 1                         
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --          
      SELECT dpm_dpid                       DpID                        
           , enttm_desc                     EntityType              
           , entm_short_name                EntityName                        
           , entsbim_dpam_sba_no            AccountNo                        
           , entsbim_series_type            SeriesType                        
           , entsbim_from_no         FromBookNo                        
           , entsbim_to_no                  ToBookNo        
           , entsbim_id             
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                             errmsg                        
      FROM   entsbim_mak                    entsbim                        
           , dp_mstr                        dpm                         
           , entity_mstr                    entm                        
           , entity_type_mstr               enttm                        
           , company_mstr                   compm                        
           , exch_seg_mstr                  excsm                          
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  entsbim.entsbim_deleted_ind  = 0                          
      AND    entsbim.entsbim_lst_upd_by  <> @pa_login_name                        
      AND    entsbim.entsbim_dpm_id       = dpm.dpm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entsbim.entsbim_entm_id      = entm.entm_id                        
      AND    entm.entm_enttm_cd           = enttm.enttm_cd                        
      AND    dpm_excsm_id                 = excsm.excsm_id                        
      AND    excsm_compm_id               = compm_id                          
      AND    excsm_deleted_ind            = 1                          
      AND    compm_deleted_ind            = 1                          
      AND    entsbim_series_type            LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    convert(varchar,excsm.excsm_id)      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC    END                        
      AND    entm.entm_deleted_ind        = 1                         
      AND    enttm.enttm_deleted_ind      = 1                         
      AND    dpm.dpm_deleted_ind          = 1                         
    --                        
    END                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_SEL'                        
  BEGIN                        
  --                        
    SELECT ccm_id                        
         , ccm_cd                        
         , ccm_name                        
         , citrus_usr.fn_merge_str('cc_mstr',ccm_id,'id') ccm_excm_id                        
, citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd') ccm_excm_cd                        
         , '' errmsg                        
    FROM   cc_mstr                        
    WHERE  ccm_deleted_ind  = 1                        
    AND    ccm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END                        
    AND    ccm_name        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                               
                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_SELM'                        
  BEGIN                        
  --                        
    SELECT ccm_id                        
      , ccm_cd                        
         , ccm_name                        
         , citrus_usr.fn_merge_str('cc_mstr',ccm_id,'id') ccm_excm_id                        
         , citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd')      ccm_excm_cd                        
         , '' errmsg                        
    FROM   ccm_mak                        
    WHERE  ccm_deleted_ind  =  0                        
    AND    ccm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END                        
    AND    ccm_name        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                               
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_SELC'                        
  BEGIN                        
  --     
    SELECT ccm_id                        
         , ccm_cd                        
         , ccm_name                        
         , citrus_usr.fn_merge_str('cc_mstr',ccm_id,'id')     ccm_excm_id                        
         , citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd')      ccm_excm_cd                        
         , '' errmsg                        
    FROM   ccm_mak                        
    WHERE  ccm_deleted_ind  = 0                        
    AND    ccm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END                        
    AND    ccm_name        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END                               
    AND    ccm_lst_upd_by  <> @pa_login_name                        
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_SEARCH'                        
  BEGIN                        
  --                        
    SELECT ccm_cd                        
         , ccm_name                        
    FROM   cc_mstr                        
    WHERE  ccm_deleted_ind  = 1                        
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_SEARCHM'                        
  BEGIN                        
  --                        
    SELECT ccm_cd                        
         , ccm_name                        
    FROM   ccm_mak                        
    WHERE  ccm_deleted_ind  = 0                        
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_SEARCHC'                        
  BEGIN                        
  --                        
    SELECT ccm_cd                        
         , ccm_name                        
    FROM   ccm_mak                        
    WHERE  ccm_deleted_ind  = 0                        
    AND    ccm_lst_upd_by   <> @pa_login_name                        
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_CHK'                        
  BEGIN                  
  --                        
    SELECT DISTINCT EXCM_CD                        
         , EXCM_ID                        
         , CASE WHEN CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) =0 THEN 0 ELSE 1 END                         
    FROM   CC_MSTR                        
         , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         , EXCH_SEG_MSTR  excsm                        
           RIGHT OUTER JOIN EXCHANGE_MSTR                          
           ON                         
           EXCM_CD = EXCSM_EXCH_CD                           
           and  CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) > 0                        
    WHERE  ccm_deleted_ind = 1                            
    AND    excsm_list.excsm_id          = excsm.excsm_id                        
  --                        
  END                        
  ELSE IF @pa_action = 'CCM_CHKM'                        
  BEGIN                        
  --                        
    SELECT DISTINCT EXCM_CD                        
         , EXCM_ID                        
         , CASE WHEN CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) =0 THEN 0 ELSE 1 END                         
    FROM   CCM_MAK                        
         , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         , EXCH_SEG_MSTR  excsm                        
           RIGHT OUTER JOIN EXCHANGE_MSTR                         
           ON                         
           EXCM_CD = EXCSM_EXCH_CD                           
           and  CITRUS_USR.FN_GET_ACCESS(EXCSM_DESC,@pa_id) > 0                        
    WHERE  ccm_deleted_ind = 1                            
    AND    excsm_list.excsm_id          = excsm.excsm_id                        
  --                        
  END                        
  ELSE IF @pa_action = 'LOOSM_SEL'                        
  BEGIN                        
  --                        
    IF @PA_RMKS <> ''                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                  DpId               
           , enttm_desc                EntityType                        
           , entm_short_name           EntityName                         
           , loosm_dpam_sba_no         AccountNo           
           , loosm_series_type         SeriesType                        
           , loosm_slip_book_no        BookNo                    
           , loosm_slip_no_from        FromBookNo                        
           , loosm_slip_no_to          ToBookNo                        
           , loosm_id                         
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                        errmsg                        
     FROM    loose_slip_mstr                        
           , dp_mstr                        
           , entity_mstr                        
           , entity_type_mstr                        
           , company_mstr                             
           , exch_seg_mstr                         
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  loosm_deleted_ind       = 1                        
      AND    loosm_series_type         LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    loosm_slip_book_no        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC  END                        
      AND    @PA_RMKS                  BETWEEN loosm_slip_no_from AND loosm_slip_no_to                        
      AND    convert(varchar,excsm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))     = '' THEN '%' ELSE @PA_VALUES END                        
      AND    dpm_id                  = loosm_dpm_id                        
      AND    entm_id                 = loosm_entm_id                        
      AND    entm_enttm_cd           = enttm_cd                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    dpm_excsm_id            = excsm_id                        
      AND    excsm_compm_id          = compm_id                          
      AND    excsm_deleted_ind       = 1                          
      AND    compm_deleted_ind = 1                          
      AND    dpm_deleted_ind         = 1                         
      AND    entm_deleted_ind        = 1                        
  AND    enttm_deleted_ind       = 1                        
                              
                              
                              
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                  DpId                        
           , enttm_desc                EntityType                        
           , entm_short_name           EntityName                         
           , loosm_dpam_sba_no         AccountNo                        
           , loosm_series_type         SeriesType                        
           , loosm_slip_book_no        BookNo                        
           , loosm_slip_no_from        FromBookNo                        
           , loosm_slip_no_to          ToBookNo                        
           , loosm_id                         
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , ''                        errmsg                        
     FROM    loose_slip_mstr                                   , dp_mstr                        
           , entity_mstr                        
           , entity_type_mstr                        
           , company_mstr                             
           , exch_seg_mstr excsm                        
     , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  loosm_deleted_ind   = 1                        
      AND    loosm_series_type         LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    loosm_slip_book_no        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC  END                  
      AND    convert(varchar,excsm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))     = '' THEN '%' ELSE @PA_VALUES END                        
      AND    dpm_id                  = loosm_dpm_id                        
      AND    entm_id                 = loosm_entm_id            
AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entm_enttm_cd           = enttm_cd                        
      AND    dpm_excsm_id            = excsm_id                        
      AND    excsm_compm_id          = compm_id                          
      AND    excsm_deleted_ind       = 1                          
      AND    compm_deleted_ind       = 1                          
      AND    dpm_deleted_ind         = 1                         
      AND    entm_deleted_ind        = 1                        
      AND    enttm_deleted_ind       = 1                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'LOOSM_SELM'                        
  BEGIN                        
  --                        
      IF @PA_ID <> ''                        
      BEGIN                        
      --                        
        SELECT dpm_dpid                 DpId                        
             , enttm_desc               EntityType                        
             , entm_short_name          EntityName                         
             , loosm_dpam_sba_no        AccountNo                        
             , loosm_series_type        SeriesType                        
             , loosm_slip_book_no       BookNo                        
             , loosm_slip_no_from       FromBookNo                        
             , loosm_slip_no_to         ToBookNo                        
             , loosm_id                         
             , entm_id                        
             , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
             , ''                       errmsg                        
        FROM   loosm_mak                        
             , dp_mstr                        
             , entity_mstr                        
             , entity_type_mstr                        
             , company_mstr                             
             , exch_seg_mstr  excsm                        
             , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        WHERE  loosm_deleted_ind       = 0                        
        AND    dpm_id                  = loosm_dpm_id                        
        AND    entm_id                 = loosm_entm_id           
        AND    entm_enttm_cd           = enttm_cd                        
        AND    excsm_list.excsm_id          = excsm.excsm_id                        
        AND    dpm_excsm_id            = excsm.excsm_id                        
        AND    excsm_compm_id          = compm_id                          
        AND    excsm_deleted_ind       = 1                          
        AND    compm_deleted_ind       = 1                          
        AND    loosm_id                = CONVERT(NUMERIC,@pa_id)                        
        AND    dpm_deleted_ind         = 1                         
        AND    entm_deleted_ind        = 1                        
        AND    enttm_deleted_ind       = 1                        
      --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      IF @PA_RMKS <> ''                         
      BEGIN                        
      --                        
        SELECT dpm_dpid                DpId                        
             , enttm_desc              EntityType                        
             , entm_short_name         EntityName                         
             , loosm_dpam_sba_no       AccountNo                        
             , loosm_series_type       SeriesType                        
             , loosm_slip_book_no      BookNo                        
             , loosm_slip_no_from      FromBookNo                        
         , loosm_slip_no_to        ToBookNo                        
    , loosm_id                         
             , entm_id                        
             , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
             , ''                      errmsg                        
        FROM   loosm_mak                        
             , dp_mstr                        
             , entity_mstr                        
             , entity_type_mstr                        
             , company_mstr                             
             , exch_seg_mstr excsm                        
             , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        WHERE  loosm_deleted_ind       = 0                        
        AND    loosm_lst_upd_by        = @pa_login_name                        
        AND    loosm_series_type         LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
        AND    loosm_slip_book_no        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC  END                        
        AND    @PA_RMKS                  BETWEEN loosm_slip_no_from and loosm_slip_no_to                        
        AND    convert(varchar,excsm.excsm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))     = '' THEN '%' ELSE @PA_VALUES END                        
        AND    dpm_id                  = loosm_dpm_id                        
        AND  excsm_list.excsm_id          = excsm.excsm_id                        
        AND    entm_id                 = loosm_entm_id                        
        AND    entm_enttm_cd           = enttm_cd                        
        AND    dpm_excsm_id            = excsm.excsm_id                        
        AND    excsm_compm_id          = compm_id                          
        AND    excsm_deleted_ind       = 1                          
        AND    compm_deleted_ind       = 1                          
        AND    dpm_deleted_ind         = 1                         
        AND    entm_deleted_ind        = 1                        
        AND    enttm_deleted_ind       = 1                        
      --                        
      END                        
      ELSE IF @pa_rmks = ''                        
      BEGIN                        
      --                        
        SELECT dpm_dpid                DpId                        
             , enttm_desc              EntityType                        
             , entm_short_name         EntityName                         
             , loosm_dpam_sba_no   AccountNo                        
             , loosm_series_type       SeriesType                        
             , loosm_slip_book_no      BookNo                        
             , loosm_slip_no_from      FromBookNo                        
             , loosm_slip_no_to        ToBookNo                        
             , loosm_id                         
             , entm_id                        
             , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
             , ''                      errmsg                        
        FROM   loosm_mak                        
             , dp_mstr                        
             , entity_mstr                        
             , entity_type_mstr                        
             , company_mstr                             
             , exch_seg_mstr excsm                        
             , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        WHERE  loosm_deleted_ind = 0                        
        AND    loosm_lst_upd_by  = @pa_login_name                        
        AND    loosm_series_type   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
        AND    loosm_slip_book_no  LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC  END                        
        AND    convert(varchar,excsm.excsm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))     = '' THEN '%' ELSE @PA_VALUES END                        
        AND    dpm_id            = loosm_dpm_id                        
        AND    excsm_list.excsm_id          = excsm.excsm_id                        
        AND    entm_id           = loosm_entm_id                        
        AND    entm_enttm_cd     = enttm_cd                        
        AND    dpm_excsm_id      = excsm.excsm_id                        
        AND    excsm_compm_id    = compm_id                          
        AND    excsm_deleted_ind = 1                          
        AND    compm_deleted_ind = 1                          
        AND    dpm_deleted_ind   = 1                         
        AND    entm_deleted_ind  = 1                
        AND    enttm_deleted_ind = 1                        
      --                        
      END                        
    --                        
    END                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'LOOSM_SELC'                        
  BEGIN                        
  --                        
    IF @PA_RMKS <> ''                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                DpId                        
           , enttm_desc              EntityType                        
           , entm_short_name         EntityName                         
           , loosm_dpam_sba_no       AccountNo                        
           , loosm_series_type       SeriesType                        
           , loosm_slip_book_no      BookNo                        
           , loosm_slip_no_from      FromBookNo                        
           , loosm_slip_no_to        ToBookNo                        
           , loosm_id                         
           , entm_id                        
          , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                          
           , loosm_deleted_ind                        
           , ''                      errmsg                        
      FROM   loosm_mak                        
           , dp_mstr                         
           , entity_mstr                        
           , entity_type_mstr                        
           , company_mstr                             
           , exch_seg_mstr excsm                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
      WHERE  loosm_deleted_ind IN (0,4,6)                        
      AND    loosm_lst_upd_by  <> @pa_login_name                        
      AND    loosm_series_type   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    loosm_slip_book_no  LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC  END                        
      AND    @PA_RMKS            BETWEEN loosm_slip_no_from and loosm_slip_no_to    
      AND    convert(varchar,excsm.excsm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))     = '' THEN '%' ELSE @PA_VALUES END                        
      AND    dpm_id            = loosm_dpm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entm_id           = loosm_entm_id                        
      AND    entm_enttm_cd     = enttm_cd                        
      AND    dpm_excsm_id    = excsm.excsm_id                        
      AND    excsm_compm_id    = compm_id                          
      AND    excsm_deleted_ind = 1                          
      AND    compm_deleted_ind = 1                          
      AND    dpm_deleted_ind   = 1                         
      AND    entm_deleted_ind  = 1                        
AND    enttm_deleted_ind = 1                        
    --                      
    END                        
    ELSE IF @pa_RMKS = ''                        
    BEGIN                        
    --                        
      SELECT dpm_dpid                DpId                        
           , enttm_desc              EntityType              
           , entm_short_name         EntityName                         
           , loosm_dpam_sba_no       AccountNo                        
           , loosm_series_type       SeriesType                        
           , loosm_slip_book_no      BookNo                        
           , loosm_slip_no_from      FromBookNo                        
           , loosm_slip_no_to        ToBookNo                        
           , loosm_id                         
           , entm_id                        
           , compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd comp_name                        
           , loosm_deleted_ind                        
           , ''                      errmsg                        
      FROM   loosm_mak                        
           , dp_mstr                         
           , entity_mstr                        
      , entity_type_mstr                        
           , company_mstr                             
           , exch_seg_mstr  excsm                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
                                   
      WHERE  loosm_deleted_ind IN (0,4,6)                    AND    loosm_lst_upd_by  <> @pa_login_name                        
      AND    loosm_series_type   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD    END                        
      AND    loosm_slip_book_no  LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))     = '' THEN '%' ELSE @PA_DESC  END                        
      AND    convert(varchar,excsm.excsm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))     = '' THEN '%' ELSE @PA_VALUES END                        
      AND    dpm_id            = loosm_dpm_id                        
      AND    excsm_list.excsm_id          = excsm.excsm_id                        
      AND    entm_id           = loosm_entm_id                        
      AND    entm_enttm_cd     = enttm_cd                        
      AND    dpm_excsm_id      = excsm.excsm_id                        
      AND    excsm_compm_id    = compm_id                          
      AND    excsm_deleted_ind = 1                          
      AND    compm_deleted_ind = 1                          
      AND    dpm_deleted_ind   = 1                         
      AND    entm_deleted_ind  = 1                        
      AND    enttm_deleted_ind = 1                        
    --                        
    END                        
    /*                        
    ELSE IF @pa_action = 'LOOSM_SEARCH'                        
    BEGIN                        
    --                        
      SELECT loosm_series_type                        
           , loosm_entm_id                        
           , loosm_dpm_id                        
           , loosm_slip_book_no                        
      FROM   loose_slip_mstr                                  
      WHERE  loosm_deleted_ind  = 1                         
                        
    --                        
    END                        
    ELSE IF @pa_action = 'LOOSM_SEARCHM'                        
    BEGIN                        
    --                        
      SELECT loosm_series_type                        
           , loosm_entm_id                        
           , loosm_dpm_id                        
           , loosm_slip_book_no                        
      FROM   loose_slip_mstr                                  
      WHERE  loosm_deleted_ind  = 0                         
    --                        
    END                        
    ELSE IF @pa_action = 'LOOSM_SEARCHC'                        
    BEGIN                        
    --                        
      SELECT loosm_series_type                        
           , loosm_entm_id                        
           , loosm_dpm_id                        
           , loosm_slip_book_no                        
      FROM   loose_slip_mstr                   
     WHERE  loosm_deleted_ind  = 0                        
      AND    loosm_lst_upd_by   <> @pa_login_name                        
    --                        
    END                        
    */                        
  --                          
  END                          
  ---instrument_mstr--                        
  ELSE IF @pa_action = 'INSM_SEL'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc     Depository                        
         , insm.insm_code     InstrumentCode                        
         , insm.insm_desc     InstrumentDesc                        
         , insm.insm_id       insm_id                        
         , insm.insm_excm_id  excm_id                        
    FROM   instrument_mstr    insm                        
         , exchange_mstr      excm                        
    WHERE  insm.insm_code     LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
    AND    insm.insm_desc     LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc  END                        
    AND    convert(varchar, insm_excm_id)    LIKE CASE WHEN isnull(@pa_rmks,'') = '' THEN '%' ELSE @pa_rmks END                        
    AND    excm.excm_id          = insm.insm_excm_id                        
    AND    insm.insm_deleted_ind = 1                        
    AND    excm.excm_deleted_ind = 1                         
  --                        
  END                        
  --            
  ELSE IF @pa_action = 'INSM_SELM'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc     Depository                        
         , insm.insm_code     InstrumentCode                        
         , insm.insm_desc     InstrumentDesc                        
         , insm.insm_id       insm_id                         
         , insm.insm_excm_id  excm_id                        
    FROM   insm_mak           insm                        
         , exchange_mstr      excm                        
    WHERE  insm.insm_code        LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
    AND    insm.insm_desc        LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc  END                        
    AND    convert(varchar, insm_excm_id)    LIKE CASE WHEN isnull(@pa_rmks,'') = '' THEN '%' ELSE @pa_rmks END                        
    AND    convert(varchar, insm_id)    LIKE CASE WHEN isnull(@pa_id,'') = '' THEN '%' ELSE @pa_id END                        
    AND    excm.excm_id          = insm.insm_excm_id                        
    AND    insm.insm_deleted_ind IN (0,4)                        
    AND    excm.excm_deleted_ind = 1                        
    /*                        
    UNION                        
    SELECT excm.excm_desc     Depository                        
         , insm.insm_code     InstrumentCode                        
         , insm.insm_desc     InstrumentDesc                        
         , insm.insm_id       id                         
         , insm.insm_excm_id  excm_id                        
    FROM   instrument_mstr    insm                        
         , exchange_mstr      excm                        
    WHERE  insm.insm_code        LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
    AND    insm.insm_desc        LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc  END                        
    AND    insm.insm_deleted_ind = 1                              
    AND    excm.excm_deleted_ind = 1                        
    AND    insm.insm_id     NOT IN (SELECT insm_id FROM insm_mak)                        
    */                        
  --                        
  END                        
  --                        
  ELSE IF @pa_action = 'INSM_SELC'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc     Depository          
         , insm.insm_code     InstrumentCode                        
         , insm.insm_desc     InstrumentDesc                        
         , insm.insm_id       insm_id                         
         , insm.insm_excm_id  excm_id                        
         , insm.insm_deleted_ind insm_deleted_ind                        
    FROM   insm_mak           insm                         
         , exchange_mstr      excm                        
    WHERE  insm.insm_code        LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd END                  
    AND    insm.insm_desc        LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @PA_desc END                        
    AND    convert(varchar, insm_excm_id)    LIKE CASE WHEN isnull(@pa_rmks,'') = '' THEN '%' ELSE @pa_rmks END                        
    AND    excm.excm_id          = insm.insm_excm_id                        
    AND    insm.insm_lst_upd_by  <> @pa_login_name                        
    AND    insm.insm_deleted_ind IN (0,4,6)                        
    AND    excm.excm_deleted_ind = 1                         
  --                        
  END          
                        
  --Narration_Mstr                        
  ELSE IF @pa_action = 'NARM_SEL'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc         Depositroy                          
         , trantm.trantm_code     TransactionType                         
         , narm.narm_short_desc   ShortDesc                        
         , narm.narm_long_desc    LongDesc                        
         , narm.narm_id           id                        
         , narm.narm_excm_id      excm_id                        
         , narm.narm_trantm_id    trantm_id                         
    FROM   narration_mstr         narm           
         , exchange_mstr          excm                        
         , transaction_type_mstr  trantm                        
    WHERE  convert(varchar, narm.narm_excm_id)   LIKE CASE WHEN isnull(@pa_id,'') = '' THEN '%' ELSE @pa_id END                        
    AND    convert(varchar, trantm.trantm_code)  LIKE CASE WHEN isnull(@pa_cd,'') = '' THEN '%' ELSE @pa_cd END                        
    AND    narm.narm_short_desc                  LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    narm.narm_long_desc                   LIKE CASE WHEN ltrim(rtrim(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks + '%' END                        
    AND    narm.narm_excm_id         = excm.excm_id                         
    AND    trantm.trantm_id          = narm.narm_trantm_id                            
    AND    narm.narm_deleted_ind     = 1                        
    AND    excm.excm_deleted_ind     = 1                        
    AND    trantm.trantm_deleted_ind = 1                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'NARM_SELM'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc         Depositroy                          
         , trantm.trantm_code     TransactionType                         
         , narm.narm_short_desc   ShortDesc                        
         , narm.narm_long_desc    LongDesc                        
         , narm.narm_id           id                        
         , narm.narm_excm_id      excm_id                        
         , narm.narm_trantm_id    trantm_id                         
    FROM   narm_mak               narm                        
         , exchange_mstr          excm                        
         , transaction_type_mstr  trantm                        
    WHERE  convert(varchar, narm.narm_excm_id)   LIKE CASE WHEN isnull(@pa_id,'') = '' THEN '%' ELSE @pa_id END                        
    AND    convert(varchar, trantm.trantm_code) LIKE CASE WHEN isnull(@pa_cd,'') = '' THEN '%' ELSE @pa_cd END                        
 AND    narm.narm_short_desc                  LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    narm.narm_long_desc                   LIKE CASE WHEN ltrim(rtrim(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks + '%' END                        
    AND    narm.narm_deleted_ind                 IN (0,4)                        
    AND    narm.narm_excm_id         = excm.excm_id                         
    AND    trantm.trantm_id          = narm.narm_trantm_id                        
    AND    excm.excm_deleted_ind     = 1                        
    AND    trantm.trantm_deleted_ind = 1                        
    /*                        
    UNION                        
    SELECT narm_excm_id     excm_id                        
         , narm_trantm_id   trantm_id                         
         , narm_short_desc  short_desc                        
         , narm_long_desc   long_desc            
         , narm_id          id                        
    FROM   narration_mstr                        
    WHERE  convert(varchar, narm_excm_id)   LIKE CASE WHEN isnull(@pa_id,'') = '' THEN '%' ELSE @pa_id END                        
    AND    convert(varchar, narm_trantm_id) LIKE CASE WHEN isnull(@pa_cd,'') = '' THEN '%' ELSE @pa_cd END                        
    AND    narm_short_desc    LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    narm_long_desc                   LIKE CASE WHEN ltrim(rtrim(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks + '%' END                        
    AND    narm_deleted_ind = 1                              
    AND    narm_id                          NOT IN (SELECT narm_id FROM narm_mak)                        
    */                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'NARM_SELC'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc        Depositroy                          
         , trantm.trantm_code    TransactionType                         
         , narm.narm_short_desc  ShortDesc                        
         , narm.narm_long_desc   LongDesc                        
         , narm.narm_id          id                        
         , narm.narm_excm_id     excm_id                        
         , narm.narm_trantm_id   trantm_id                         
         , narm.narm_deleted_ind narm_deleted_ind                         
    FROM   narm_mak              narm                        
         , exchange_mstr         excm                        
         , transaction_type_mstr trantm                        
    WHERE  convert(varchar, narm.narm_excm_id)   LIKE CASE WHEN isnull(@pa_id,'') = '' THEN '%' ELSE @pa_id END   
    AND    convert(varchar, trantm.trantm_code) LIKE CASE WHEN isnull(@pa_cd,'') = '' THEN '%' ELSE @pa_cd END                        
    AND    narm.narm_short_desc                  LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    narm.narm_long_desc                   LIKE CASE WHEN ltrim(rtrim(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks + '%' END               
    AND    narm.narm_excm_id      = excm.excm_id                         
    AND    narm.narm_deleted_ind                 IN (0,4)                        
    AND    excm.excm_deleted_ind  = 1                        
    AND    narm.narm_lst_upd_by  <> @pa_login_name                        
  --                        
  END                        
                        
  --reason_mstr--                        
  ELSE IF @pa_action = 'REAM_SEL'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc         Depository                        
         , trantm.trantm_code     TransactionType                         
         , ream.ream_code         ReasonCode                        
         , ream.ream_desc         ReasonDesc                        
         , ream.ream_id           Ream_Id                        
         , ream.ream_excm_id      excm_id                        
         , ream.ream_trantm_id    trantm_id                        
    FROM   reason_mstr            ream                        
         , exchange_mstr          excm                        
         , transaction_type_mstr  trantm                        
    WHERE  convert(varchar, trantm.trantm_code) LIKE CASE WHEN isnull(@pa_values,'') = '' THEN '%' ELSE @pa_values END                        
    AND    ream.ream_desc                        LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    convert(varchar, ream_excm_id)        LIKE CASE WHEN isnull(@pa_rmks,'') = '' THEN '%' ELSE @pa_rmks END                        
    AND    excm.excm_id           = ream.ream_excm_id                         
    AND    ream.ream_trantm_id    = trantm.trantm_id                        
    AND    ream.ream_deleted_ind  = 1                        
    AND    excm.excm_deleted_ind  = 1                        
    AND    trantm_deleted_ind     = 1                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'REAM_SELM'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc         Depository                        
         , trantm.trantm_code     TransactionType                         
         , ream.ream_code         ReasonCode                        
         , ream.ream_desc         ReasonDesc                        
         , ream.ream_id           Ream_Id                        
         , ream.ream_excm_id      excm_id                        
         , ream.ream_trantm_id    trantm_id                        
    FROM   ream_mak               ream                        
         , exchange_mstr          excm                        
         , transaction_type_mstr  trantm                                 
    WHERE  convert(varchar, trantm.trantm_code) LIKE CASE WHEN isnull(@pa_values,'') = '' THEN '%' ELSE @pa_values END                        
    AND    ream.ream_desc                        LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    convert(varchar, ream_excm_id)        LIKE CASE WHEN isnull(@pa_rmks,'') = '' THEN '%' ELSE @pa_rmks END                        
    AND    convert(varchar, ream_id)     LIKE CASE WHEN isnull(@pa_id,'') = '' THEN '%' ELSE @pa_id END                        
    AND    excm.excm_id          = ream.ream_excm_id                         
    AND    ream.ream_trantm_id   = trantm.trantm_id                        
    AND    ream.ream_deleted_ind IN (0,4)                       
    AND    excm.excm_deleted_ind = 1                        
    AND    trantm_deleted_ind    = 1                        
    /*                        
    UNION                        
    SELECT ream_excm_id   excm_id                        
         , ream_trantm_id trantm_id                        
         , ream_code      code                        
         , ream_desc      des                        
         , ream_id        id                        
    FROM   reason_mstr                        
    WHERE  ream_code     LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
    AND    ream_desc     LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc  END                        
    AND    ream_deleted_ind = 1                              
    AND    ream_id     NOT IN (SELECT ream_id FROM ream_mak)                        
    */                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'REAM_SELC'                        
  BEGIN                        
  --                        
    SELECT excm.excm_desc         Depository                        
         , trantm.trantm_code     TransactionType                         
         , ream.ream_code         ReasonCode                        
         , ream.ream_desc         ReasonDesc                        
         , ream.ream_id           Ream_Id                        
         , ream.ream_excm_id      excm_id                        
         , ream.ream_trantm_id    trantm_id                        
    FROM   ream_mak               ream                        
         , exchange_mstr          excm                        
         , transaction_type_mstr  trantm                                 
    WHERE  convert(varchar, trantm.trantm_code) LIKE CASE WHEN isnull(@pa_values,'') = '' THEN '%' ELSE @pa_values END                        
    AND    ream.ream_desc                        LIKE CASE WHEN ltrim(rtrim(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END                        
    AND    convert(varchar, ream_excm_id)        LIKE CASE WHEN isnull(@pa_rmks,'') = '' THEN '%' ELSE @pa_rmks END                        
    AND    excm.excm_id          = ream.ream_excm_id                         
    AND    ream.ream_trantm_id   = trantm.trantm_id                        
AND    ream.ream_lst_upd_by  <> @pa_login_name                        
    AND    ream.ream_deleted_ind IN (0,4)                        
    AND    excm.excm_deleted_ind = 1                        
    AND    trantm_deleted_ind    = 1                        
  --                        
  END                        
                          
  --transaction_type_mstr--                        
  ELSE IF @pa_action = 'TRANTM_SEL'                        
  BEGIN                        
  --                        
    SELECT excm_desc         EXCHANGE                        
         , trantm_code       CODE                        
      , trantm_desc       DESCRIPTION                        
         , trantm_id         ID                        
    FROM   transaction_type_Mstr                        
         , exchange_mstr                        
    WHERE  trantm_desc           LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
    AND    trantm_excm_id        LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    trantm_excm_id      = excm_id                        
    AND    trantm_deleted_ind  = 1                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'TRANTM_SELM'                        
  BEGIN                        
  --                        
    if @pa_id <> ''                        
    BEGIN                        
    --                        
      SELECT excm_desc         EXCHANGE                        
           , trantm_code   CODE                        
           , trantm_desc       DESCRIPTION                        
           , trantm_id     ID                        
      FROM   trantm_mak                        
           , exchange_mstr                        
      WHERE  trantm_id           =convert(int,@pa_id)                        
      AND    trantm_excm_id      = excm_id                        
      AND    trantm_deleted_ind IN (0,4,6)                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT excm_desc         EXCHANGE                        
           , trantm_code       CODE                        
           , trantm_desc       DESCRIPTION                        
           , trantm_id         ID                        
      FROM   trantm_mak                        
           , exchange_mstr                        
      WHERE  trantm_desc      LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
      AND    trantm_excm_id        LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    trantm_excm_id      = excm_id                        
      AND    trantm_deleted_ind IN (0,4,6)                        
    --                        
    END                        
    /*                        
    UNION                        
    SELECT trantm_excm_id   excm_id                        
         , trantm_id        trantm_id                        
         , trantm_code      code                        
       , trantm_desc      des                        
         , trantm_id        id                        
    FROM   transaction_type_Mstr                        
    WHERE  trantm_code     LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd  END                        
    AND    trantm_desc     LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc  END                        
    AND    trantm_deleted_ind = 1                              
    AND    trantm_id     NOT IN (SELECT ream_id FROM ream_mak)                        
    */                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'TRANTM_SELC'                        
  BEGIN                        
  --                        
    SELECT excm_desc         EXCHANGE                        
         , trantm_code       CODE                        
         , trantm_desc       DESCRIPTION                        
         , trantm_id         ID                        
         , trantm_deleted_ind                
    FROM   trantm_mak                        
         , exchange_mstr                        
    WHERE  trantm_deleted_ind IN (0,4)                        
    AND    trantm_excm_id      = excm_id                        
    AND    trantm_lst_upd_by  <> @pa_login_name                        
  --                        
  END                        
  --                        
  IF @pa_action = 'SETTM_DESC'                        
  BEGIN                        
  --                        
    IF @pa_cd <> ''                        
    BEGIN                        
    --                        
      IF LEFT(@pa_cd,2) = 'IN'           
      BEGIN                        
      --                        
        SELECT settm.settm_id            id                        
             , settm.settm_desc          des                        
        FROM   settlement_type_Mstr      settm                        
              ,entity_mstr entm                        
        WHERE  entm.entm_short_name = convert(varchar,@pa_cd)                        
        and    entm.entm_name2      = convert(varchar,settm_excm_id)                   
        AND    settm.settm_deleted_ind = 1                        
                  
                                
                                
      --          
      END                        
      ELSE                        
      BEGIN                        
      --                        
        SELECT settm.settm_id            id                        
             , settm.settm_desc          des                        
        FROM   settlement_type_Mstr      settm                        
             , dp_acct_mstr              dpam                        
             , account_properties        accp                        
             , exchange_mstr             excm                         
        WHERE  dpam.dpam_id            = accp.accp_clisba_id                        
        AND    accp.accp_accpm_prop_cd = 'CMBPEXCH'                         
        AND    dpam.dpam_SBA_no       = @pa_cd                        
        AND    accp.accp_value         = excm.excm_cd                        
        AND    settm.settm_excm_id     = excm.excm_id                        
        AND    settm.settm_deleted_ind = 1                        
        AND    excm.excm_deleted_ind   = 1                        
        AND    dpam.dpam_deleted_ind   = 1                        
        AND    accp.accp_deleted_ind   = 1                        
      --                        
      END                        
    --                        
    END                        
    ELSE IF @pa_desc <> ''                        
    BEGIN                        
    --                        
      SELECT settm.settm_id   id                        
      , settm.settm_desc   des                        
      FROM   settlement_type_Mstr  settm                        
      , exchange_mstr    excm                        
      WHERE  settm_deleted_ind = 1                        
      AND    excm_id  = settm_excm_id                        
      AND    excm_deleted_ind  = 1                        
      AND    excm_id  = @pa_desc                         
    --                        
    END                        
    IF @PA_CD ='' AND @PA_DESC=''                        
    BEGIN                        
    --                        
    SELECT settm.settm_id            id                        
    ,      isnull(settm.settm_desc,'') + ' - ' + isnull(excm_cd,'')          des                         
    FROM   settlement_type_Mstr settm,Exchange_mstr Ex                        
    WHERE  settm_excm_id = excm_id                        
    and settm_deleted_ind       = 1 and Excm_deleted_ind =1          
    and isnull(settm.settm_desc,'') + ' - ' + isnull(excm_cd,'')  like '%' + @pa_id + '%'  
	--and excm_cd like '%' + @pa_rmks + '%'                
    order by settm.settm_desc,excm_cd                        
    --                        
    END                         
                           
  --                        
  END                        
  /*                        
  IF @pa_action = 'SETTM_DESC_CDSL'                        
  BEGIN                  
  --                        
    IF @pa_cd <> ''                        
    BEGIN                        
    --                        
      SELECT settm.settm_id            id                        
           , settm.settm_desc          des                        
      FROM   settlement_type_Mstr      settm                        
           , dp_acct_mstr              dpam                        
           , account_properties        accp                        
           , exchange_mstr             excm                         
      WHERE  dpam.dpam_id            = accp.accp_clisba_id                        
      AND    accp.accp_accpm_prop_cd = 'CMBPEXCH'                         
      AND    dpam.dpam_acct_no       = @pa_cd                        
      AND    accp.accp_value         = excm.excm_cd                        
      AND    settm.settm_excm_id     = excm.excm_id                        
      AND    settm.settm_deleted_ind = 1                        
      AND    excm.excm_deleted_ind   = 1                        
      AND    dpam.dpam_deleted_ind   = 1                        
      AND    accp.accp_deleted_ind   = 1                        
    --                        
    END                        
    ELSE IF @pa_desc <> ''                        
    BEGIN                        
    --                        
     SELECT settm.settm_id            id                        
           , settm.settm_desc          des                        
      FROM   settlement_type_Mstr      settm                        
           , exchange_mstr             excm                        
      WHERE  settm_deleted_ind       = 1                        
      AND    excm_id                 = settm_excm_id                        
      AND    excm_deleted_ind        = 1                        
      AND    excm_id                 = @pa_desc                         
    --                        
    END                        
                            
                            
                        
  --                        
  END                         
  */                        
                          
  --                        
  IF @pa_action = 'SETM_NO_CHK'                        
  BEGIN                      
  --                  
    /*                        
    SELECT setm.setm_id              id                        
    FROM   exch_seg_mstr             excsm                        
         , exchange_mstr             excm                        
         , settlement_Mstr           setm                        
    WHERE  excsm.excsm_id          = convert(numeric, @pa_id)                        
    --AND    excsm.excsm_exch_cd     = @pa_cd                        
    AND    excsm.excsm_exch_cd     = excm.excm_cd                        
    AND    excm.excm_id            = setm_excm_id                        
    AND    excm.excm_deleted_ind   = 1                        
    AND    excsm.excsm_deleted_ind = 1                        
    AND    setm.setm_deleted_ind   = 1                        
    */                        
    --                 
                            
    SELECT setm.setm_id      id                        
    FROM settlement_Mstr   setm                        
    WHERE setm.setm_deleted_ind   = 1                         
    AND   setm.setm_settm_id      = convert(numeric,@pa_cd)                        
    AND   setm.setm_no            = @pa_desc                         
   -- AND   CONVERT(DATETIME,CONVERT(VARCHAR(11),SETM_PAYIN_DT,103) + ' ' + LEFT(REPLACE(SETM_DEADLINE_TIME,':',''),2) + ':' + RIGHT(REPLACE(SETM_DEADLINE_TIME,':',''),2),103) > GETDATE()                        
  --                        
  END                        
  IF @pa_action = 'SETM_NO_CHK_DATEWISE'                        
  BEGIN                        
  --                        
    /*                        
    SELECT setm.setm_id              id                        
    FROM   exch_seg_mstr             excsm                        
         , exchange_mstr             excm                        
         , settlement_Mstr           setm                        
    WHERE  excsm.excsm_id          = convert(numeric, @pa_id)                        
    --AND    excsm.excsm_exch_cd     = @pa_cd                        
    AND    excsm.excsm_exch_cd     = excm.excm_cd                        
    AND    excm.excm_id            = setm_excm_id                        
    AND    excm.excm_deleted_ind   = 1                        
    AND    excsm.excsm_deleted_ind = 1                        
    AND    setm.setm_deleted_ind   = 1                        
    */                        
    --                        
    if @pa_cd='51'
    begin
     SELECT setm.setm_id      id                        
    FROM settlement_Mstr   setm                        
    WHERE setm.setm_deleted_ind   = 1                         
    AND   setm.setm_settm_id      = convert(numeric,@pa_cd)                        
    AND   setm.setm_no            = @pa_desc   
    end 
    else
    begin                             
    SELECT setm.setm_id      id                        
    FROM settlement_Mstr   setm                        
    WHERE setm.setm_deleted_ind   = 1                         
    AND   setm.setm_settm_id      = convert(numeric,@pa_cd)                        
    AND   setm.setm_no            = @pa_desc                         
    AND   CONVERT(DATETIME,CONVERT(VARCHAR(11),SETM_PAYIN_DT,103) + ' ' + LEFT(REPLACE(SETM_DEADLINE_TIME,':',''),2) + ':' + substring(replACE(setm.setm_deadline_time,':',''),3,2),103) > GETDATE()                        
	end
  --                        
  END                        
                          
  IF @pa_action = 'TRANS_COMP'                        
  BEGIN                        
  --                        
    SELECT compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd  comp_name                            
         , excsm.excsm_id              id                            
         , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID) COMPEXCHANGE_ID                            
         , entac.entac_concm_cd        cd                        
         , dpm.dpm_name                DpName                        
         , dpm.dpm_dpid                dpId                        
         , addr.adr_1                  adr1                        
         , addr.adr_2                  adr2                        
         , addr.adr_3                  adr3                         
         , addr.adr_city               city                        
         , addr.adr_state              state            
         , addr.adr_country            country                          
         , addr.adr_zip                zip                          
    FROM   exch_seg_mstr               excsm  WITH (NOLOCK)                            
         , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         , company_mstr                compm  WITH (NOLOCK)                          
         , dp_mstr                     dpm    WITH (NOLOCK)                        
         , entity_adr_conc             entac  WITH (NOLOCK)                        
         , addresses                   addr   WITH (NOLOCK)                        
    WHERE  excsm.EXCSM_EXCH_CD      IN ('CDSL','NSDL')                        
    AND    excsm.excsm_compm_id      = compm.compm_id                            
    AND    excsm.excsm_id        = dpm.dpm_excsm_id                        
    AND    dpm.dpm_id = entac.entac_ent_id                        
    AND    excsm_list.excsm_id          = excsm.excsm_id                        
    AND    entac.entac_adr_conc_id   = addr.adr_id                        
    AND    excsm.excsm_deleted_ind   = 1                            
    AND    compm.compm_deleted_ind   = 1                        
    AND    dpm.dpm_deleted_ind       = 1                        
    AND    adr_deleted_ind           = 1                        
    AND    entac.entac_deleted_ind   = 1                         
  --                          
  END                        
  --                        
  IF @pa_action = 'GETTRANSTYPE'                        
  BEGIN                        
  --                        
    /*SELECT DISTINCT trantm_id                        
         , trantm_desc                        
         , trantm_code                         
    FROM   transaction_type_mstr                          
    WHERE  trantm_excm_id     = @pa_id                        
    AND    trantm_deleted_ind = 1*/                        
                            
                            
    select trastm_id                           
          ,trastm_cd  code                        
          ,trastm_desc  description                        
    from   transaction_type_mstr      trantm                        
          ,transaction_sub_type_mstr  trastm                        
          ,exchange_mstr              excm                        
          ,exch_seg_mstr              exsegm                     
    where  trantm.trantm_excm_id    = excm.excm_id                        
    AND    trantm.trantm_id         = trastm.trastm_tratm_id                        
    AND    trantm.trantm_code       = case when excsm_exch_cd = 'CDSL' then 'SLIP_TYPE_CDSL'                         
                                           when excsm_exch_cd = 'NSDL' then 'SLIP_TYPE_NSDL' end                        
    and    excm.excm_cd         = exsegm.excsm_exch_cd                        
    and    exsegm.excsm_id          = @pa_id                        
    --and    trastm.trastm_cd         not in ('901','902','912','925')                           
 and    trastm.trastm_cd         not in ('901','902','912')                           
    and    trantm.trantm_deleted_ind= 1                        
                            
  --                          
  END                        
  IF @pa_action = 'GETLOCKINCD'                        
  BEGIN                        
  --                        
    /*SELECT DISTINCT trantm_id                        
         , trantm_desc                        
         , trantm_code                         
    FROM   transaction_type_mstr                          
    WHERE  trantm_excm_id     = @pa_id                        
    AND    trantm_deleted_ind = 1*/                        
                        
                        
    select trastm_id                           
          ,trastm_cd  code                        
          ,trastm_desc  description                        
    from   transaction_type_mstr      trantm                        
          ,transaction_sub_type_mstr  trastm                        
          ,exchange_mstr              excm                        
          ,exch_seg_mstr              exsegm                        
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
    where  trantm.trantm_excm_id    = excm.excm_id                        
    AND    trantm.trantm_id         = trastm.trastm_tratm_id                        
    AND    trantm.trantm_code       = case when excsm_exch_cd = 'CDSL' then 'DEMAT_LOCK_CD_CDSL'                         
        when excsm_exch_cd = 'NSDL' then 'DEMAT_LOCK_CD_NSDL' end                        
    and    excm.excm_cd             = exsegm.excsm_exch_cd                        
    AND    excsm_list.excsm_id          = exsegm.excsm_id                        
    and    exsegm.excsm_id          = @pa_id                        
    and    trantm.trantm_deleted_ind= 1                        
                        
  --                          
  END                
  IF @pa_action = 'GETINTERNALTRANSTYPE'                        
  BEGIN                        
  --                      
                        
    declare @l_excsm_exch_cd varchar(20)                    
                        
    /*SELECT DISTINCT trantm_id                        
         , trantm_desc                        
         , trantm_code                         
    FROM   transaction_type_mstr                          
    WHERE  trantm_excm_id     = @pa_id                        
    AND    trantm_deleted_ind = 1*/         
                     
    select @l_excsm_exch_cd = excsm_Exch_cd from exch_seg_mstr    where excsm_id = @pa_id                    
                    
    if @l_excsm_exch_cd  = 'CDSL'                    
    begin                    
   select trastm_id                           
      ,trastm_cd  code                        
      ,trastm_desc  description                        
   from   transaction_sub_type_mstr                         
     , transaction_type_mstr                         
   where  trastm_tratm_id          = trantm_id                        
   and    trantm_code              = 'INT_TRANS_TYPE_CDSL'                     
   and    trantm_deleted_ind       = 1  and TRASTM_DELETED_IND=1                  
        
   Union      
 Select 0,'O', 'ONE TIME CHARGE'      
    Union      
 Select 0,'F', 'FIXED CHARGE'      
    --Union      
 --Select 0,'A', 'ACCOUNT CLOSURE'      
    Union      
 Select 0,'H', 'HOLDING CHARGES'      
    Union      
 Select 0,'AMT', 'BASED ON CHARGE AMOUNT'      
    Union      
 Select 0,'AMCPRO', 'AMC PRO RATA'      
 Union      
 Select 0,'DEMAT', 'DEMAT PER CERTIFICATE'      
 Union      
 Select 0,'F', 'DOCUMENT CHARGES'  
Union      
 Select 0,'OVERDUEDEBIT', 'OVERDUE DEBIT' 
 Union
 Select 0,'POA_CHARGE', 'POA CHARGES'    
 Union 
 select 0,'DISBOOK' , 'DISBOOK'    
    order by 3         
    end                    
    else  if @l_excsm_exch_cd  = 'NSDL'                    
    begin                    
   select trastm_id                           
      ,trastm_cd  code                        
      ,trastm_desc  description                        
   from   transaction_sub_type_mstr                         
     , transaction_type_mstr                         
   where  trastm_tratm_id          = trantm_id                        
   and    trantm_code              = 'INT_TRANS_TYPE_NSDL'                     
   and    trantm_deleted_ind       = 1                    
   and    TRASTM_CD     in ('202','042','033','011','012','021','022','052','071','212','091','092','093','062')                    
        
    Union      
 Select 0,'O', 'ONE TIME CHARGE'      
    Union      
 Select 0,'F', 'FIXED CHARGE'      
    --Union      
 --Select 0,'A', 'ACCOUNT CLOSURE'      
    Union      
 Select 0,'H', 'HOLDING CHARGES'      
    Union      
 Select 0,'AMT', 'BASED ON CHARGE AMOUNT'      
    Union      
 Select 0,'AMCPRO', 'AMC PRO RATA'       
     order by trastm_cd                   
    end                    
                       
                    
                    
                        
                        
  --                          
  END                        
  /*IF @pa_action = 'GETTRANSTYPE'                        
    BEGIN                        
    --                        
                             
      select trantm_id                           
            ,trantm_code  code                        
            ,trantm_desc description                        
      from   transaction_type_mstr      trantm                        
            ,exchange_mstr              excm                        
            ,exch_seg_mstr              exsegm                        
      where  trantm.trantm_excm_id    = excm.excm_id                        
      and    excm.excm_cd             = exsegm.excsm_exch_cd                        
      and    exsegm.excsm_id          = @pa_id                        
      and    trantm.trantm_deleted_ind= 1                        
                              
    --                          
  END*/                        
  --                        
  IF @pa_action = 'GETCLIENTVAL'                        
  BEGIN                        
  --                        
    SELECT isnull(clim_name1,'')     clim_name1                        
         , isnull(dphd_sh_fname,'')  dphd_sh_fname                        
         , isnull(dphd_th_fname,'')  dphd_th_fname                         
         , isnull(dpam_SBA_no,0) dpam_acct_no                         
    FROM   client_mstr  c                         
         , dp_acct_mstr a                         
           LEFT OUTER JOIN                         
           dp_holder_dtls d  on (a.dpam_id = d.dphd_dpam_id AND  d.dphd_deleted_ind=1 )                         
    WHERE  a.dpam_SBA_no     = @pa_cd                          
    AND    c.clim_crn_no      = a.dpam_crn_no                        
    AND    c.clim_deleted_ind = 1                        
    AND    a.dpam_deleted_ind = 1                        
  --                        
  END                        
  --                        
  IF @pa_action = 'GETCLIENTVAL'                        
  BEGIN                    --                        
    SELECT isnull(clim_name1,'')     clim_name1                        
         , isnull(dphd_sh_fname,'')  dphd_sh_fname                        
         , isnull(dphd_th_fname,'')  dphd_th_fname                         
         , isnull(dpam_SBA_no,0) dpam_acct_no                         
    FROM   client_mstr  c                         
         , dp_acct_mstr a                         
           LEFT OUTER JOIN                         
           dp_holder_dtls d  on (a.dpam_id = d.dphd_dpam_id AND  d.dphd_deleted_ind=1 )                         
    WHERE  a.dpam_SBA_no     = @pa_cd                          
    AND    c.clim_crn_no      = a.dpam_crn_no                        
    AND    c.clim_deleted_ind = 1               
    AND    a.dpam_deleted_ind = 1                        
  --                        
  END                        
  ELSE IF @pa_action = 'GETISINVAL'                        
  BEGIN                        
  --                        
SELECT *                         
   FROM   isin_mstr                         
   WHERE  isin_cd          = @pa_cd                        
   AND    isin_deleted_ind = 1                        
  --                        
  END                        
  ELSE IF @pa_action = 'ENTM_NM'                        
  BEGIN                        
  --                        
                        
   SELECT entm_name1                                                                    cm_nm                         
        , clim_name1 + ' ' + isnull(clim_name2,'') + ' ' + isnull(clim_name3,'')          fh_name                        
        , dphd_sh_fname + ' ' + isnull(dphd_sh_mname,'') + ' ' + isnull(dphd_sh_lname,'') sh_name                        
        , dphd_th_fname + ' ' + isnull(dphd_th_mname,'') + ' ' + isnull(dphd_th_lname,'') th_name                        
        , isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'nm_of_cc',''),'') name_of_cc                          
   FROM   client_mstr                         
        , dp_acct_mstr                        
        , dp_holder_dtls                        
        , entity_mstr                         
        , ACCOUNT_PROPERTIES                        
   WHERE  clim_crn_no                               = dpam_crn_no                         
   AND    dpam_id                                   = dphd_dpam_id                        
   AND    DPAM_ID                                   = ACCP_CLISBA_ID                        
   AND    ACCP_ACCPM_PROP_CD                        = 'cmbp_id'                        
   AND    ACCP_VALUE                                = @pa_cd                         
   --AND    citrus_usr.fn_ucc_accp(clim_crn_no,'cmbp_id','') = @pa_cd                         
   AND    entm_short_name                        = @pa_cd                        
   AND    clim_deleted_ind                          = 1                        
   AND    dpam_deleted_ind                          = 1                        
   AND    dphd_deleted_ind                          = 1                        
   AND    entm_deleted_ind                          = 1                        
   AND     ACCP_DELETED_IND                         = 1                        
                           
  --                  
  END              
  ELSE IF @pa_action = 'ENTM_NM_OTHER'                        
  BEGIN                        
  --                        
                        
   SELECT entm_name1                                                                    cm_nm                         
   FROM   entity_mstr                         
   WHERE  entm_short_name                        = @pa_cd                        
   AND    entm_deleted_ind                          = 1                        
                           
  --                        
  END                      
  ELSE IF @pa_action = 'CMBP_VALID'                        
  BEGIN                        
  --                        
       SELECT entm_name1                                             cm_nm                                                
    FROM   entity_mstr                         
    WHERE  entm_short_name                           = @pa_cd                        
    AND    entm_deleted_ind                          = 1                         
       AND    ENTM_ENTTM_CD                             = '03'                         
                        
          
  --                        
  END                                               
                        
  ELSE IF @pa_action = 'POA_DOC_PATH'                        
  BEGIN                        
  --                        
   SELECT distinct accdocm_desc                         
       , isnull(accd_doc_path,'') doc_path              		
--,isnull(ACCD_BINARY_IMAGE,null) doc_path
   FROM   account_document_mstr                        
        , account_documents                        
        , dp_acct_mstr                        
   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
    AND    accdocm_cd    IN ('SIGN_BO','SIGN_POA')                        
   AND    dpam_id          = accd_clisba_id                        
   AND    dpam_sba_no     = @pa_id                        
   AND    accd_deleted_ind = 1                        
   AND    accdocm_deleted_ind = 1                
  --                        
  END                        


                     

  ELSE IF @pa_action = 'POA_DOC_PATH_SIGN'                        
  BEGIN                        
  --                        
--print citrus_usr.fn_splitval(@pa_id,1)
--print citrus_usr.fn_splitval(@pa_id,2)
if (isnull(citrus_usr.fn_splitval(@pa_id,1),'')<>'' and isnull(citrus_usr.fn_splitval(@pa_id,2),'')='')
begin
--  SELECT distinct accdocm_desc                         
--        --, isnull(accd_doc_path,'') doc_path              
--		,isnull(ACCD_BINARY_IMAGE,null) doc_path
--   FROM   account_document_mstr                        
--        , account_documents                        
--        , dp_acct_mstr                        
--   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
--   AND    accdocm_cd    IN ('SIGN_BO','SIGN_POA')                        
--   AND    dpam_id          = accd_clisba_id                        
--   AND    dpam_sba_no     = isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
--   --and    ISNULL(CITRUS_USR.FN_UCC_ACCP(DPAM_id,'BBO_CODE',''),'') like  (citrus_usr.fn_splitval(@pa_id,2)) + '%'                  
--   AND    accd_deleted_ind = 1                        
--   AND    accdocm_deleted_ind = 1      
--   order by  accdocm_desc 

  SELECT distinct accdocm_desc                         
        --, isnull(accd_doc_path,'') doc_path              
		,isnull(ACCD_BINARY_IMAGE,null) doc_path
   FROM   account_document_mstr                         with(nolock)
        , account_documents                        with(nolock)
        , dp_acct_mstr                        with(nolock)
   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
   AND    accdocm_cd    IN ('SIGN_BO')                        
   AND    dpam_id          = accd_clisba_id                        
   AND    dpam_sba_no     = isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
   --and    ISNULL(CITRUS_USR.FN_UCC_ACCP(DPAM_id,'BBO_CODE',''),'') like  (citrus_usr.fn_splitval(@pa_id,2)) + '%'                  
   AND    accd_deleted_ind = 1                        
   AND    accdocm_deleted_ind = 1  
   and not exists(select 1 from ACCD_MAK,dp_acct_mstr where  dpam_id= accd_clisba_id and  dpam_sba_no = isnull(citrus_usr.fn_splitval(@pa_id,1),'') AND ACCD_DELETED_IND ='8' )   
union all
   SELECT distinct accdocm_desc                         
        --, isnull(accd_doc_path,'') doc_path              
		,isnull(ACCD_BINARY_IMAGE,null) doc_path
   FROM   account_document_mstr                    with(nolock)    
        , account_documents                        with(nolock)
        , dp_acct_mstr                        with(nolock)
   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
   AND    accdocm_cd    IN ('SIGN_POA')     and ACCDOCM_DESC='POA SIGNATURE'                   
   AND    dpam_id          = accd_clisba_id                        
   AND    dpam_sba_no     = isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
   --and    ISNULL(CITRUS_USR.FN_UCC_ACCP(DPAM_id,'BBO_CODE',''),'') like  (citrus_usr.fn_splitval(@pa_id,2)) + '%'                  
   AND    accd_deleted_ind = 1                        
   --AND    accdocm_deleted_ind = 1 
   --and  exists (select 1 from dps8_pc5 where boid =isnull(citrus_usr.fn_splitval(@pa_id,1),'')  and TypeOfTrans in ('1','2','4',''))
  -- union all
--SELECT distinct accdocm_desc                         
--        --, isnull(accd_doc_path,'') doc_path              
--		,isnull(ACCD_BINARY_IMAGE,null) doc_path
--   FROM   account_document_mstr                        
--        , accd_mak                        
--        , dp_acct_mstr_mak                        
--   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
--   AND    accdocm_cd    IN ('SIGN_BO')                        
--   AND    dpam_id          = accd_clisba_id                        
--   AND    DPAM_ACCT_NO     = isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
--   --and    ISNULL(CITRUS_USR.FN_UCC_ACCP(DPAM_id,'BBO_CODE',''),'') like  (citrus_usr.fn_splitval(@pa_id,2)) + '%'                  
--   AND    accd_deleted_ind in (0,4,6)                       
--   AND    accdocm_deleted_ind = 1  
union all
SELECT distinct accdocm_desc                         
        --, isnull(accd_doc_path,'') doc_path              
		,isnull(ACCD_BINARY_IMAGE,null) doc_path
   FROM   account_document_mstr                        
        , accd_mak                        
        , dp_acct_mstr                        
   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
   AND    accdocm_cd    IN ('SIGN_BO')                        
   AND    dpam_id          = accd_clisba_id                        
   AND    DPAM_sba_NO     = isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
   --and    ISNULL(CITRUS_USR.FN_UCC_ACCP(DPAM_id,'BBO_CODE',''),'') like  (citrus_usr.fn_splitval('1203320001872755',2)) + '%'                  
   AND    accd_deleted_ind in (0,4,6,8)                       
   AND    accdocm_deleted_ind = 1   
union all
   SELECT distinct accdocm_desc                         
        --, isnull(accd_doc_path,'') doc_path              
		,isnull(ACCD_BINARY_IMAGE,null) doc_path
   FROM   account_document_mstr                        
        , accd_mak                        
        , dp_acct_mstr_mak                        
   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
   AND    accdocm_cd    IN ('SIGN_POA')       and ACCDOCM_DESC='POA SIGNATURE'                 
   AND    dpam_id          = accd_clisba_id                        
   AND    DPAM_ACCT_NO     = isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
   --and    ISNULL(CITRUS_USR.FN_UCC_ACCP(DPAM_id,'BBO_CODE',''),'') like  (citrus_usr.fn_splitval(@pa_id,2)) + '%'                  
   AND    accd_deleted_ind  in (0,4,6)
   AND    accdocm_deleted_ind = 1 
   --and  exists (select 1 from dps8_pc5 where boid =isnull(citrus_usr.fn_splitval(@pa_id,1),'')  and TypeOfTrans in ('1','2','4',''))   
   union all
select distinct 'POA SIGNATURE' accdocm_desc,IMAGEpathbinary doc_path 
from mosl_bulk_binary_poa,dp_acct_mstr,dp_poa_dtls p where dpam_sba_no=isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
and dppd_dpam_id=dpam_id 
and dppd_master_id=substring(imagepath,2,16)--replace(replace(replace(imagepath,'.BMP',''),'P',''),'SIG','')--replace(imagepath,'.BMP','')
and  exists
(select 1 from dps8_pc5 where boid =isnull(citrus_usr.fn_splitval(@pa_id,1),'') 
and TypeOfTrans in ('1','2','4',''))

   order by  accdocm_desc 
end
else if (isnull(citrus_usr.fn_splitval(@pa_id,2),'')<>'' and isnull(citrus_usr.fn_splitval(@pa_id,1),'')='')
begin
  SELECT distinct accdocm_desc                         
        --, isnull(accd_doc_path,'') doc_path              
		,isnull(ACCD_BINARY_IMAGE,null) doc_path
   FROM   account_document_mstr                    with(nolock)    
        , account_documents                        with(nolock)
        , dp_acct_mstr with(nolock) ,account_properties                     with(nolock)  
   WHERE  accdocm_doc_id   = accd_accdocm_doc_id                        
   AND    accdocm_cd    IN ('SIGN_BO','SIGN_POA')                        
   AND    dpam_id          = accd_clisba_id   and accp_clisba_id=dpam_id and    ACCP_ACCPM_PROP_CD='BBO_CODE'                  
   --AND    dpam_sba_no     like (isnull(citrus_usr.fn_splitval(@pa_id,1),'')) + '%'
   and    ACCP_VALUE = citrus_usr.fn_splitval(@pa_id,2) 
   AND    accd_deleted_ind = 1                        
   AND    accdocm_deleted_ind = 1      
   order by  accdocm_desc 
end
      
        
        END                        
  ELSE IF @pa_action = 'TRASTM_SEL'                        
  BEGIN                        
  --                        
    SELECT excm_desc            exchange                        
         , trantm_desc          ctgry_desc                        
         , trastm_cd            sub_ctgry_code                        
         , trastm_desc          sub_ctgry_desc                        
         , trastm_id    sub_ctgry_id                        
         , trastm_tratm_id      ctgry_id                        
    FROM   transaction_sub_type_Mstr                        
         , transaction_type_mstr                        
         , exchange_mstr                        
    WHERE  trastm_cd            LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd+'%'  END                        
    AND    trastm_desc          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc+'%'  END                        
    AND    trastm_excm_id     = CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN trastm_excm_id ELSE convert(numeric, @pa_rmks) END                        
    AND    trantm_id          = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trantm_id ELSE convert(numeric, @pa_values) END                          
    AND    trantm_id          = trastm_tratm_id                        
    AND    trantm_excm_id     = excm_id                         
    AND    trastm_deleted_ind = 1                        
    AND    trantm_deleted_ind = 1                        
  --                        
  END                        
                        
  ELSE IF @pa_action = 'TRASTM_SELM'                        
  BEGIN                        
  --                        
    IF @pa_id <> ''                        
    BEGIN                        
    --                        
      SELECT excm_desc            exchange                        
           , trantm_desc          ctgry_desc                        
           , trastm_cd            sub_ctgry_code                        
           , trastm_desc          sub_ctgry_desc       
        , trastm_id            sub_ctgry_id                        
           , trastm_tratm_id      ctgry_id                        
      FROM   trastm_mak                        
           , transaction_type_mstr                        
           , exchange_mstr                        
      WHERE  trastm_cd            LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd+'%'  END                        
      AND    trastm_desc          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc+'%'  END                        
      AND    trastm_excm_id      = CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN trastm_excm_id ELSE convert(numeric, @pa_rmks) END                        
      AND    trantm_id           = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trantm_id ELSE convert(numeric, @pa_values) END                          
      AND    trastm_id           = CASE WHEN LTRIM(RTRIM(@pa_id)) = ''THEN trastm_id ELSE convert(numeric, @pa_id) END                             
      AND    trantm_id           = trastm_tratm_id                        
      AND    trantm_excm_id      = excm_id                         
      AND    trastm_deleted_ind IN (0,4,6)                        
      AND    trantm_deleted_ind  = 1                        
    --                        
    END                        
    ELSE    
    BEGIN                        
    --                        
    SELECT excm_desc            exchange                        
           , trantm_desc          ctgry_desc                        
           , trastm_cd            sub_ctgry_code                        
           , trastm_desc          sub_ctgry_desc                        
           , trastm_id            sub_ctgry_id                        
           , trastm_tratm_id      ctgry_id                        
      FROM   trastm_mak                        
           , transaction_type_mstr                        
           , exchange_mstr                        
      WHERE  trastm_cd            LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd+'%'  END                        
AND    trastm_desc          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc+'%'  END                        
      AND    trastm_excm_id      = CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN trastm_excm_id ELSE convert(numeric, @pa_rmks) END                        
      AND    trantm_id           = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trantm_id ELSE convert(numeric, @pa_values) END                          
      --AND    trastm_id           = CASE WHEN LTRIM(RTRIM(@pa_id)) = ''THEN trastm_id ELSE convert(numeric, @pa_id) END                             
      AND    trantm_id           = trastm_tratm_id                        
      AND    trantm_excm_id      = excm_id                         
      AND    trastm_deleted_ind IN (0,6,4)                        
      AND    trantm_deleted_ind  = 1                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'TRASTM_SELC'                        
  BEGIN                        
  --                   
    SELECT excm_desc            exchange                         
         , trantm_desc          ctgry_desc                        
         , trastm_cd            sub_ctgry_code                        
         , trastm_desc          sub_ctgry_desc                        
         , trastm_id            sub_ctgry_id                        
         , trastm_tratm_id      ctgry_id                        
         , trastm_deleted_ind   trastm_deleted_ind                        
    FROM   trastm_mak                        
         , transaction_type_mstr                        
         , exchange_mstr                        
    WHERE  trastm_cd              LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd+'%' END        AND    trastm_desc            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc+'%' END                        
    AND    trastm_excm_id       = CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN trastm_excm_id ELSE convert(numeric, @pa_rmks) END                        
    AND    trantm_id            = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trantm_id ELSE convert(numeric, @pa_values) END                          
    AND    trantm_id            = trastm_tratm_id                        
    AND    trantm_excm_id       = excm_id                         
    AND    trastm_lst_upd_by  <> @pa_login_name                        
    AND    trastm_deleted_ind IN (0,4,6)                        
    AND  excm_deleted_ind     = 1                        
                           
  --                        
  END                        
  ELSE IF @pa_action = 'DEMRM_SEL'                    
  BEGIN                    
  --                    
    SELECT DISTINCT @l_dpm_dpid                    DPID                    
          ,dpam_sba_no                ACCOUNTNO                                    
          ,demrm_isin                  ISIN                    
          ,demrm_drf_no                INTID          
          ,isnull(DEMRM_TRANSACTION_NO,'')   DRNNO                  
          ,demrm_slip_serial_no        SLIPSERIALNO                    
          ,convert(varchar,demrm_request_dt,103) REQUESTDATE                     
          ,demrm_qty   QUANTITY                    
          ,a.cd    DEMRM_INTERNAL_REJ            
		  ,b.cd   DEMRM_COMPANY_OBJ 
          ,DEMRM_CREDIT_RECD                  
          ,demrm_free_lockedin_yn      FREELOOKEDIN                    
          ,isnull(demrm_lockin_reason_cd,'')  REASONCODE                     
         -- ,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
		 ,CASE WHEN ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),demrm_lockin_release_dt,103),'') END RELEASEDATE
		 ,@pa_id                   EXCHANGE                     
          ,demrm_id                    ID                     
          ,demttd_hld1                    
          ,demttd_hld2                    
          ,demttd_hld3                    
          ,demttd_surv1                    
          ,demttd_surv2                    
          ,demttd_surv3                    
          ,demrm_rmks                    
          ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]        
		,demrm.demrm_request_dt
		, case when DEMRM_DELETED_IND = 1 then 'APPROVED' else '' end  status1
,demrm_typeofsec
    FROM   demat_request_mstr      demrm                    
           left outer join                     
           demat_tran_tranm_dtls       demttd on demttd.demttd_demrm_id    = demrm.demrm_id              
           LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd                      = demrm.DEMRM_INTERNAL_REJ                
           LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd                      = demrm.DEMRM_COMPANY_OBJ                        
          , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                    
                     
    WHERE  dpam.dpam_id  = demrm.demrm_dpam_id                    
    AND    convert(datetime,demrm.demrm_request_dt,103)      LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN convert(datetime,demrm.demrm_request_dt,103)  ELSE convert(datetime,@pa_cd,103)  END                    
    AND    demrm.demrm_slip_serial_no  LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                    
    AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                    
    AND    demrm_deleted_ind   = 1          
    order by demrm.demrm_request_dt desc          
  --                    
  END                    
  ELSE IF @pa_action = 'DEMRM_SELM'                    
  BEGIN                    
  --        
    IF @pa_values <> ''                    
    BEGIN                    
    --   
                 
      SELECT DISTINCT @l_dpm_dpid                    DPID                    
            ,dpam_sba_no                ACCOUNTNO                                    
            ,demrm_isin                  ISIN                    
            ,demrm_drf_no                INTID            
			,''   DRNNO                          
            ,demrm_slip_serial_no        SLIPSERIALNO                    
            ,convert(varchar,demrm_request_dt,103)            REQUESTDATE                     
            ,demrm_qty                   QUANTITY                    
           ,a.cd    DEMRM_INTERNAL_REJ            
		   ,b.cd    DEMRM_COMPANY_OBJ            
                    
            ,DEMRM_CREDIT_RECD                   
            ,demrm_free_lockedin_yn      FREELOOKEDIN                    
            ,isnull(demrm_lockin_reason_cd,'')      REASONCODE                     
            --,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
            ,CASE WHEN ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar,demrm_lockin_release_dt,103),'') END RELEASEDATE
            ,@pa_id                    EXCHANGE                     
            ,demrm_id                    ID                     
            ,demttd_hld1                   
            ,demttd_hld2                    
            ,demttd_hld3                    
            ,demttd_surv1                    
            ,demttd_surv2                    
            ,demttd_surv3                    
            --,demrm_rmks        
--   ,'Inernal Rejection:' + isnull(demrm_rmks,'') + isnull(demrm_res_desc_intobj,0) + ' ' +               
--            'Company Objection:' + isnull(demrm_res_desc_compobj,0) demrm_rmks               
   , isnull(demrm_res_desc_intobj,'') + ' ' + isnull(demrm_res_desc_compobj,'') + ' ' + isnull(demrm_rmks,'')  demrm_rmks                   
            ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]     
,demrm.demrm_request_dt  
,case when DEMRM_DELETED_IND = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <> '') then 'REJECTED' end status1
      --when DEMRM_DELETED_IND = 0 and isnull(demrm_res_cd_intobj,'') = '' and isnull(demrm_res_cd_compobj,'') = '' then 'APPROVED' end status1
   ,demrm_typeofsec
      FROM   demrm_mak                   demrm                    
             left outer join                     
             demat_tran_tranm_dtls_mak       demttd on demttd.demttd_demrm_id    = demrm.demrm_id               
              LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd                      = demrm.DEMRM_INTERNAL_REJ                
          LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd                      = demrm.DEMRM_COMPANY_OBJ                       
            , citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam                    
                       
      WHERE  dpam.dpam_id              = demrm.demrm_dpam_id                    
               
      AND    demrm_id                  = @pa_values                    
      AND    demrm_deleted_ind         IN(0,6)      
    order by demrm.demrm_request_dt desc                        
    --                    
    END                    
   ELSE                    
    BEGIN                    
    --                    
      SELECT DISTINCT @l_dpm_dpid                    DPID                    
            ,dpam_sba_no                ACCOUNTNO                                    
            ,demrm_isin                  ISIN                    
            ,demrm_drf_no                INTID         
			,''   DRNNO                             
            ,demrm_slip_serial_no        SLIPSERIALNO                    
            ,convert(varchar,demrm_request_dt,103)            REQUESTDATE                     
            ,demrm_qty                   QUANTITY                    
           ,a.cd    DEMRM_INTERNAL_REJ            
		   ,b.cd    DEMRM_COMPANY_OBJ            
                    
			,DEMRM_CREDIT_RECD                    
            ,demrm_free_lockedin_yn      FREELOOKEDIN                    
            ,isnull(demrm_lockin_reason_cd,'')      REASONCODE                    
            --,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
			,CASE WHEN ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar,demrm_lockin_release_dt,103),'') END RELEASEDATE
            ,@pa_id     EXCHANGE                     
            ,demrm_id                    ID                     
            ,demttd_hld1                    
            ,demttd_hld2                    
            ,demttd_hld3                    
            ,demttd_surv1                    
            ,demttd_surv2                    
            ,demttd_surv3                    
           -- ,demrm_rmks             
--      ,'Inernal Rejection:' + isnull(demrm_rmks,'') + isnull(demrm_res_desc_intobj,0) + ' ' +               
--            'Company Objection:' + isnull(demrm_res_desc_compobj,0) demrm_rmks        
      ,isnull(demrm_res_desc_intobj,'') + ' ' + isnull(demrm_res_desc_compobj,'') + ' ' + isnull(demrm_rmks,'') demrm_rmks                       
            ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]               
,demrm.demrm_request_dt
,case when DEMRM_DELETED_IND = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <> '') then 'REJECTED' end status1
     -- when DEMRM_DELETED_IND = 0 and isnull(demrm_res_cd_intobj,'') = '' and isnull(demrm_res_cd_compobj,'') = '' then 'APPROVED' end status1  -- do not change status desc
     ,demrm_typeofsec
      FROM   demrm_mak                   demrm                    
             left outer join                     
             demat_tran_tranm_dtls_mak       demttd on demttd.demttd_demrm_id    = demrm.demrm_id             
              LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd                      = demrm.DEMRM_INTERNAL_REJ                
          LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd                      = demrm.DEMRM_COMPANY_OBJ                         
           , citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0)  dpam                    
                     
      WHERE  dpam.dpam_id              = demrm.demrm_dpam_id                    
   and demrm.demrm_request_dt like case when isnull(@pa_cd,'') = '' then '%' else '%' + @pa_cd + '%' end         
      AND    demrm.demrm_slip_serial_no  LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                    
      AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                    
      AND    demrm_deleted_ind         IN(0,6)       
  order by demrm.demrm_request_dt desc                                    
    --                    
    END                    
  --                    
  END                    
 ELSE IF @pa_action = 'DEMRM_SELC'                    
  BEGIN                    
  --         
    if @pa_rmks <> ''       
 begin                 

    IF @pa_id='--ALL--'
    BEGIN 
		SELECT DISTINCT DPM_ID DPID -- @l_dpm_dpid                    DPID                    
          ,dpam_sba_no                ACCOUNTNO                                    
          ,demrm_isin                  ISIN                    
          ,demrm_drf_no                DRFNO        
		  ,'' DRNNO                              
          ,demrm_slip_serial_no        SLIPSERIALNO                    
          ,convert(varchar,demrm_request_dt,103)            REQUESTDATE                     
          ,demrm_qty                   QUANTITY                    
          ,a.cd                     DEMRM_INTERNAL_REJ             
          ,b.cd                     DEMRM_COMPANY_OBJ            
          ,DEMRM_CREDIT_RECD                   
          ,demrm_free_lockedin_yn      FREELOOKEDIN                    
          ,isnull(demrm_lockin_reason_cd,'')      REASONCODE                     
         -- ,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
          ---,yogesh--CASE WHEN ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') END RELEASEDATE
		  ,case convert(varchar,isnull(demrm_lockin_release_dt,''),103) when '01/01/1900' then '' else convert(varchar,isnull(demrm_lockin_release_dt,''),103) end RELEASEDATE   
          ,DPM_ID EXCHANGE --@pa_id                    EXCHANGE                     
          ,demrm_id                    ID                     
          ,demttd_hld1                    
          ,demttd_hld2             
          ,demttd_hld3                    
          ,demttd_surv1                    
          ,demttd_surv2                    
          ,demttd_surv3                    
          ,demrm_deleted_ind             
          ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]        
          ,[citrus_usr].[fn_demrd_value](DEMRM_ID) as  DEMRD_DISTINCTIVE_NO_FR      
		  ,DEMRM_CREATED_DT
		  ,DEMRM_CREATED_BY

         FROM   demrm_mak                   demrm                    
           left outer join                     
           demat_tran_tranm_dtls       demttd on demttd.demttd_demrm_id    = demrm.demrm_id                     
          LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd                      = demrm.DEMRM_INTERNAL_REJ                
          LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd                      = demrm.DEMRM_COMPANY_OBJ                 
          --, citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
              ,dp_mstr                     dpm                         
              ,dp_acct_mstr                dpam                          
              ,exch_seg_mstr               excsm                        
              , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        

		WHERE  dpam.dpam_id              = demrm.demrm_dpam_id  
        AND    dpm_excsm_id              = excsm.excsm_id                        
        AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    dpm_excsm_id              = convert(int,@pa_cd)            
		and    demrm_slip_serial_no = case when @pa_rmks <> '' then @pa_rmks  end             
		AND    demrm_lst_upd_by          <> @pa_login_name                    
		AND    demrm_deleted_ind         in(0,4,6)  
		AND isnull(demrm_res_desc_intobj,'') = ''  
		AND isnull(demrm_res_desc_compobj,'')=''     
		and DEMRM_REQUEST_DT = case when isnull(@pa_values,'') = '' then DEMRM_REQUEST_DT else @pa_values end
    	order by DEMRM_CREATED_DT desc
    END 
    ELSE
    BEGIN 

	
    SELECT DISTINCT @l_dpm_dpid                    DPID                    
          ,dpam_sba_no                ACCOUNTNO                                    
          ,demrm_isin                  ISIN                    
          ,demrm_drf_no                DRFNO        
    ,'' DRNNO                              
          ,demrm_slip_serial_no        SLIPSERIALNO                    
          ,convert(varchar,demrm_request_dt,103)            REQUESTDATE                     
          ,demrm_qty                   QUANTITY                    
          ,a.cd                     DEMRM_INTERNAL_REJ             
          ,b.cd                     DEMRM_COMPANY_OBJ            
          ,DEMRM_CREDIT_RECD                   
          ,demrm_free_lockedin_yn      FREELOOKEDIN                    
          ,isnull(demrm_lockin_reason_cd,'')      REASONCODE                     
         -- ,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
          --,yogesh-CASE WHEN ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') END RELEASEDATE
          ,case convert(varchar,isnull(demrm_lockin_release_dt,''),103) when '01/01/1900' then '' else convert(varchar,isnull(demrm_lockin_release_dt,''),103) end RELEASEDATE   
		  ,@pa_id                    EXCHANGE                     
          ,demrm_id                    ID                     
          ,demttd_hld1                    
          ,demttd_hld2             
          ,demttd_hld3                    
          ,demttd_surv1                    
          ,demttd_surv2                    
          ,demttd_surv3                    
          ,demrm_deleted_ind             
          ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]        
          ,[citrus_usr].[fn_demrd_value](DEMRM_ID) as  DEMRD_DISTINCTIVE_NO_FR      
		  ,DEMRM_CREATED_DT
		  ,DEMRM_CREATED_BY  + ' ( ' + isnull(replace(citrus_usr.fn_find_relations_Acctlvl(dpam.dpam_id,'BR'),'_BR',''),'')   + '-' + ltrim(rtrim(isnull(replace(citrus_usr.[fn_find_relations_ACCT_nm](dpam_sba_no,'BR'),'_BR',''),''))) + ' )' as  DEMRM_CREATED_BY
    FROM   demrm_mak                   demrm                    
           left outer join                     
           demat_tran_tranm_dtls       demttd on demttd.demttd_demrm_id    = demrm.demrm_id                     
          LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd                      = demrm.DEMRM_INTERNAL_REJ                
          LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd                      = demrm.DEMRM_COMPANY_OBJ                 
          ,citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam                         
            
		WHERE  dpam.dpam_id              = demrm.demrm_dpam_id         
		and    demrm_slip_serial_no = case when @pa_rmks <> '' then @pa_rmks  end             
		AND    demrm_lst_upd_by          <> @pa_login_name                    
		AND    demrm_deleted_ind         in(0,4,6)  
		AND isnull(demrm_res_desc_intobj,'') = ''  
		AND isnull(demrm_res_desc_compobj,'')=''     
		and DEMRM_REQUEST_DT = case when isnull(@pa_values,'') = '' then DEMRM_REQUEST_DT else @pa_values end
    	order by DEMRM_CREATED_DT desc
     END -- ALL

   -- and    (case when demrm_res_cd_intobj <> '' then demrm_res_cd_intobj else demrm_res_cd_compobj end) like case when @pa_desc ='' then '%' else @pa_desc end      
      
--    if  demrm_res_cd_intobj <> ''      
--begin         
--    and isnull(demrm_res_cd_intobj,'') like case when @pa_desc = '' then '%' else @pa_desc end          
--end      
          
    end       
    else      
 begin    

    IF @pa_id='--ALL--'
    BEGIN 

		SELECT DISTINCT DPM_ID DPID-- @l_dpm_dpid                    DPID                    
          ,dpam_sba_no                ACCOUNTNO                                    
          ,demrm_isin                  ISIN                    
          ,demrm_drf_no                DRFNO        
		  ,'' DRNNO                              
          ,demrm_slip_serial_no        SLIPSERIALNO                    
          ,convert(varchar,demrm_request_dt,103)            REQUESTDATE                     
          ,demrm_qty                   QUANTITY                    
          ,a.cd                     DEMRM_INTERNAL_REJ             
          ,b.cd                     DEMRM_COMPANY_OBJ            
          ,DEMRM_CREDIT_RECD                   
          ,demrm_free_lockedin_yn      FREELOOKEDIN                    
          ,isnull(demrm_lockin_reason_cd,'')      REASONCODE                     
         -- ,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
          --,yogseh-CASE WHEN ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') ='01 Jan 1900' THEN '' ELSE ISNULL(convert(varchar(11),demrm_lockin_release_dt,106),'') END RELEASEDATE
          ,case convert(varchar,isnull(demrm_lockin_release_dt,''),103) when '01/01/1900' then '' else convert(varchar,isnull(demrm_lockin_release_dt,''),103) end RELEASEDATE   
		  ,DPM_ID EXCHANGE --@pa_id                    EXCHANGE                     
          ,demrm_id                    ID                     
          ,demttd_hld1                    
          ,demttd_hld2             
          ,demttd_hld3                    
          ,demttd_surv1                    
          ,demttd_surv2                    
          ,demttd_surv3                    
          ,demrm_deleted_ind             
          ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]        
          ,[citrus_usr].[fn_demrd_value](DEMRM_ID) as  DEMRD_DISTINCTIVE_NO_FR      
		  ,DEMRM_CREATED_DT
          ,DEMRM_CREATED_BY   + ' (  ' + isnull(replace(citrus_usr.fn_find_relations_Acctlvl(dpam.dpam_id,'BR'),'_BR',''),'')   + ' - ' + ltrim(rtrim(isnull(replace(citrus_usr.[fn_find_relations_ACCT_nm](dpam_sba_no,'BR'),'_BR',''),''))) + ' ) ' as  DEMRM_CREATED_BY
         FROM   demrm_mak                   demrm                    
           left outer join                     
           demat_tran_tranm_dtls       demttd on demttd.demttd_demrm_id    = demrm.demrm_id                     
          LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd = demrm.DEMRM_INTERNAL_REJ                
          LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd = demrm.DEMRM_COMPANY_OBJ                 
          --, citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
              ,dp_mstr                     dpm                         
              ,dp_acct_mstr                dpam                          
              ,exch_seg_mstr               excsm                        
              , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        

		WHERE  dpam.dpam_id              = demrm.demrm_dpam_id  
        AND    dpm_excsm_id              = excsm.excsm_id                        
        AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    dpm_excsm_id              = convert(int,@pa_cd)            
		
		AND    demrm_lst_upd_by          <> @pa_login_name                    
		AND    demrm_deleted_ind         in(0,4,6)  
		AND isnull(demrm_res_desc_intobj,'') = ''  
		AND isnull(demrm_res_desc_compobj,'')=''     
		and DEMRM_REQUEST_DT = case when isnull(@pa_values,'') = '' then DEMRM_REQUEST_DT else @pa_values end
    	order by DEMRM_CREATED_DT desc
    END 
    ELSE -- all
    BEGIN 
	
	print @l_dpm_dpid
	print @l_entm_id  
 SELECT DISTINCT @l_dpm_dpid                    DPID                    
          ,dpam_sba_no                ACCOUNTNO                                    
          ,demrm_isin                  ISIN                    
          ,demrm_drf_no                DRFNO        
    ,'' DRNNO                              
          ,demrm_slip_serial_no        SLIPSERIALNO                    
          ,convert(varchar,demrm_request_dt,103)            REQUESTDATE                     
          ,demrm_qty                   QUANTITY                    
          ,a.cd                     DEMRM_INTERNAL_REJ             
          ,b.cd                     DEMRM_COMPANY_OBJ            
          ,DEMRM_CREDIT_RECD                   
          ,demrm_free_lockedin_yn      FREELOOKEDIN                    
          ,isnull(demrm_lockin_reason_cd,'')      REASONCODE                     
          --yogesh-,convert(varchar,demrm_lockin_release_dt,103)     RELEASEDATE                    
          ,case convert(varchar,isnull(demrm_lockin_release_dt,''),103) when '01/01/1900' then '' else convert(varchar,isnull(demrm_lockin_release_dt,''),103) end RELEASEDATE   
		  ,@pa_id                    EXCHANGE                     
          ,demrm_id                    ID                     
          ,demttd_hld1                    
          ,demttd_hld2                    
          ,demttd_hld3                    
          ,demttd_surv1                    
          ,demttd_surv2                    
          ,demttd_surv3                    
          ,demrm_deleted_ind             
          ,isnull(DEMRM_TOTAL_CERTIFICATES,0) [NO OF CERTIFICATE]        
          ,[citrus_usr].[fn_demrd_value](DEMRM_ID) as  DEMRD_DISTINCTIVE_NO_FR      
,DEMRM_CREATED_DT
,DEMRM_CREATED_BY  +  ' ( ' + isnull(replace(citrus_usr.fn_find_relations_Acctlvl(dpam.dpam_id,'BR'),'_BR',''),'')   + '- ' + ltrim(rtrim(isnull(replace(citrus_usr.[fn_find_relations_ACCT_nm](dpam_sba_no,'BR'),'_BR',''),''))) + ' ) ' as DEMRM_CREATED_BY
    FROM   demrm_mak                   demrm                    
           left outer join                     
           demat_tran_tranm_dtls       demttd on demttd.demttd_demrm_id    = demrm.demrm_id                     
          LEFT OUTER JOIN  [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   a    ON  a.cd                      = demrm.DEMRM_INTERNAL_REJ                
          LEFT OUTER JOIN [FN_GETSUBTRANSDTLS]('DEMAT_REJ_CD_NSDL')   b    on    b.cd                      = demrm.DEMRM_COMPANY_OBJ                 
          ,citrus_usr.fn_acct_list_disdrf(@l_dpm_dpid,@l_entm_id,0) dpam                         
            
    WHERE  dpam.dpam_id              = demrm.demrm_dpam_id         
    AND    demrm_lst_upd_by          <> @pa_login_name                    
    AND    demrm_deleted_ind         in(0,4,6)     
   AND isnull(demrm_res_desc_intobj,'') = ''  
AND isnull(demrm_res_desc_compobj,'')=''      
and DEMRM_REQUEST_DT = case when isnull(@pa_values,'') = '' then DEMRM_REQUEST_DT else @pa_values end
order by DEMRM_CREATED_DT desc

    end --- all
    --and    (case when demrm_res_cd_intobj <> '' then demrm_res_cd_intobj else demrm_res_cd_compobj end) like case when @pa_desc ='' then '%' else @pa_desc end      
           
 end      
  --                    
  END                              
  ELSE IF @pa_action = 'REMRM_SEL'                        
  BEGIN                        
  --                        
    IF @pa_cd <> ''                        
    BEGIN                        
    --                       
      SELECT distinct @l_dpm_dpid                  DPID                         
            ,dpam_sba_no              ACCOUNTNO                        
            ,remrm_isin                ISIN                        
            ,remrm_slip_serial_no      SLIPNO            
            ,CONVERT(VARCHAR,remrm_request_dt,103)          REQUESTDATE                        
            ,remrm_qty                 QUANTITY                     
            ,remrm_free_lockedin_yn    LOCKED                        
            ,CONVERT(VARCHAR,remrm_lockin_reason_dt,103) REASONDATE                        
            ,remrm_lockin_qty          LOCKINQUANTITY                        
            ,@pa_id                 EXCHANGEID                        
            ,remrm_lot_type            LOTTYPE                        
            ,remrm_rrf_no              RRFNO                        
            ,remrm_lockin_reason_cd    REASONCODE                         
            ,remrm_id                  ID                         
            ,remrm_rmks                REMARKS          
   ,remrm_certificate_no      NOOFCERTIFICATES        
         ,ISNULL(REMRM_TRANSACTION_NO,'')    RRN            
   ,REMRM_INTERNAL_REJ     
   ,REMRM_COMPANY_OBJ                         
   ,REMRM_CREDIT_RECD               
      FROM   remat_request_mstr          remrm                                              
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = remrm.remrm_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert( varchar,remrm.remrm_request_dt,103)    = @pa_cd                        
      AND    remrm.remrm_slip_serial_no LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    remrm_deleted_ind         = 1                        
                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                  DPID                         
            ,dpam_sba_no              ACCOUNTNO                        
            ,remrm_isin                ISIN                        
            ,remrm_slip_serial_no      SLIPNO                        
            ,CONVERT(VARCHAR,remrm_request_dt,103)          REQUESTDATE                        
            ,remrm_qty                 QUANTITY                         
            ,remrm_free_lockedin_yn    LOCKED                        
            ,CONVERT(VARCHAR,remrm_lockin_reason_dt,103)    REASONDATE                        
    ,remrm_lockin_qty          LOCKINQUANTITY                        
            ,@pa_id                 EXCHANGEID                        
            ,remrm_lot_type            LOTTYPE                        
            ,remrm_rrf_no              RRFNO                        
            ,remrm_lockin_reason_cd    REASONCODE                         
            ,remrm_id                  ID                         
            ,remrm_rmks                REMARKS          
   ,remrm_certificate_no      NOOFCERTIFICATES          
   ,ISNULL(REMRM_TRANSACTION_NO,'')    RRN               
   ,REMRM_INTERNAL_REJ            
   ,REMRM_COMPANY_OBJ                         
   ,REMRM_CREDIT_RECD                   
      FROM   remat_request_mstr          remrm                        
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = remrm.remrm_dpam_id                 
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpm_excsm_id            = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    remrm.remrm_slip_serial_no LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    remrm_deleted_ind         = 1                        
    --       
    END                        
                        
                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'REMRM_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                  
      SELECT distinct @l_dpm_dpid                  DPID           
            ,dpam_sba_no              ACCOUNTNO                        
            ,remrm_isin                ISIN                        
            ,remrm_slip_serial_no      SLIPNO                        
            ,CONVERT(VARCHAR,remrm_request_dt,103)          REQUESTDATE                        
            ,remrm_qty                 QUANTITY                         
            ,remrm_free_lockedin_yn    LOCKED                        
            ,CONVERT(VARCHAR,remrm_lockin_reason_dt,103)    REASONDATE                        
            ,remrm_lockin_qty          LOCKINQUANTITY                        
            ,@pa_id                  EXCHANGEID                        
            ,remrm_lot_type            LOTTYPE                        
            ,remrm_rrf_no              RRFNO                        
            ,remrm_lockin_reason_cd    REASONCODE                         
            ,remrm_id                  ID                         
            ,remrm_rmks                REMARKS            
   ,remrm_certificate_no      NOOFCERTIFICATES          
   ,''    RRN                    
   ,REMRM_INTERNAL_REJ            
   ,REMRM_COMPANY_OBJ                         
   ,REMRM_CREDIT_RECD            
      FROM   remrm_mak                   remrm                        
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = remrm.remrm_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
   --AND    excsm.excsm_id            = @pa_id                        
      AND    convert( varchar,remrm.remrm_request_dt,103)    LIKE  CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN convert( varchar,remrm.remrm_request_dt,103) ELSE @pa_cd END                        
      AND    remrm.remrm_slip_serial_no LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    remrm_deleted_ind         IN (0,6)                        
                        
    --                        
    END                        
    ELSE                         
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                  DPID                         
            ,dpam_sba_no              ACCOUNTNO                        
            ,remrm_isin                ISIN                        
            ,remrm_slip_serial_no      SLIPNO                        
            ,CONVERT(VARCHAR,remrm_request_dt,103)          REQUESTDATE                        
            ,remrm_qty                 QUANTITY                         
            ,remrm_free_lockedin_yn    LOCKED                        
            ,CONVERT(VARCHAR,remrm_lockin_reason_dt,103)    REASONDATE                        
            ,remrm_lockin_qty          LOCKINQUANTITY                        
            ,@pa_id                  EXCHANGEID                        
            ,remrm_lot_type            LOTTYPE                        
            ,remrm_rrf_no        RRFNO                        
            ,remrm_lockin_reason_cd    REASONCODE                         
            ,remrm_id      ID                         
            ,remrm_rmks                REMARKS           
   ,remrm_certificate_no      NOOFCERTIFICATES          
   ,''    RRN              
   ,REMRM_INTERNAL_REJ      
   ,REMRM_COMPANY_OBJ                         
   ,REMRM_CREDIT_RECD                   
      FROM   remrm_mak                   remrm                        
            --,dp_mstr                     dpm                         --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = remrm.remrm_dpam_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    remrm.remrm_id    = @pa_values                        
      AND    remrm_deleted_ind         IN (0,6)                        
                              
    --                        
    END                        
                        
                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'REMRM_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct @l_dpm_dpid                  DPID                         
          ,dpam_sba_no            ACCOUNTNO                        
          ,remrm_isin                ISIN                        
          ,remrm_slip_serial_no      SLIPNO                        
          ,CONVERT(VARCHAR,remrm_request_dt,103)          REQUESTDATE                        
          ,remrm_qty                 QUANTITY                         
          ,remrm_free_lockedin_yn    LOCKED                        
          ,CONVERT(VARCHAR,remrm_lockin_reason_dt,103)    REASONDATE                        
          ,remrm_lockin_qty          LOCKINQUANTITY                        
          ,@pa_id                  EXCHANGEID                        
          ,remrm_lot_type            LOTTYPE                        
          ,remrm_rrf_no              RRFNO                        
          ,remrm_lockin_reason_cd    REASONCODE                         
          ,remrm_deleted_ind                        
          ,remrm_id                        
          ,remrm_rmks  REMARKS            
          ,remrm_certificate_no      NOOFCERTIFICATES                        
          ,remrm_deleted_ind           
    ,REMRM_INTERNAL_REJ            
    ,REMRM_COMPANY_OBJ                         
    ,REMRM_CREDIT_RECD                                      
    FROM   remrm_mak  remrm                        
      --    ,dp_mstr                     dpm                         
      --    ,dp_acct_mstr                dpam                          
      --    ,exch_seg_mstr               excsm                        
      --    ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = remrm.remrm_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    dpm_excsm_id              =CONVERT(INT,@pa_cd)                        
    AND    remrm_lst_upd_by          <> @pa_login_name                         
    AND    remrm_deleted_ind         IN (0,4,6)                        
  --                        
  END                        
  ELSE IF @pa_action = 'DEMRD_SEL'                        
  BEGIN                        
  --                        
    SELECT isnull(demrd_folio_no ,'')            demrd_folio_no                        
          ,isnull(demrd_cert_no,'')              demrd_cert_no                         
          ,isnull(demrd_distinctive_no_fr ,'')   demrd_distinctive_no_fr                         
          ,isnull(demrd_distinctive_no_to,'')    demrd_distinctive_no_to                        
          ,isnull(demrd_qty,0)                   demrd_qty                        
          ,demrd_id                        
    FROM   demat_request_dtls                         
    WHERE  demrd_demrm_id    =  @pa_id                          
    AND    demrd_deleted_ind =  1                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'DEMRD_SELM'                        
  BEGIN                        
  --                        
    SELECT isnull(demrd_folio_no ,'')            demrd_folio_no                        
          ,isnull(demrd_cert_no,'')              demrd_cert_no                         
          ,isnull(demrd_distinctive_no_fr ,'')   demrd_distinctive_no_fr                         
          ,isnull(demrd_distinctive_no_to,'')    demrd_distinctive_no_to                        
          ,isnull(demrd_qty,0)                   demrd_qty                        
          ,demrd_id                        
    FROM demrd_mak                        
    WHERE  demrd_demrm_id    =  @pa_id                          
    AND    demrd_deleted_ind IN(0,6)                                   
                            
    UNION                         
                            
    SELECT isnull(demrd_folio_no ,'')            demrd_folio_no                        
          ,isnull(demrd_cert_no,'')              demrd_cert_no                         
          ,isnull(demrd_distinctive_no_fr ,'')   demrd_distinctive_no_fr                         
          ,isnull(demrd_distinctive_no_to,'')    demrd_distinctive_no_to                        
          ,isnull(demrd_qty,0)                   demrd_qty                        
          ,demrd_id                        
    FROM demat_request_dtls                        
    WHERE  demrd_demrm_id    =  @pa_id                          
    AND    demrd_deleted_ind =  1                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SLIP_LISTING'                        
  begin                        
  --                        
    select dpm_dpid                 DpId                        
          ,trastm_desc              CATEGORY                             
          ,SLIBM_SERIES_TYPE        SERIESTYPE                        
          ,SLIBM_FROM_NO                        
          ,SLIBM_TO_NO                        
          ,slibm_book_type                        
    FROM  slip_book_mstr                        
         ,transaction_sub_type_mstr                        
         ,dp_mstr                        
    WHERE slibm_dpm_id = dpm_id                          
    and   slibm_tratm_id = trastm_id                          
    and   dpm_dpid    = @pa_values                        
    and   trastm_id   = @pa_id                        
    and   SLIBM_SERIES_TYPE       = @pa_desc                        
    and   slibm_book_name <= @pa_cd and  slibm_book_name >= @pa_rmks                         
  --                        
  end                        
  ELSE IF @pa_action = 'BOOK_NO_LISTING'                        
  begin                        
  --                        
if @pa_id='999'
begin -- for all DP
set @l_dpm_dpid='999'
end     

    select dpm_dpid                 DpId                        
     ,trastm_desc              CATEGORY                             
     ,SLIBM_SERIES_TYPE        SERIESTYPE                        
     ,SLIBM_FROM_NO                        
     ,SLIBM_TO_NO            
     ,slibm_book_type         
     ,convert(varchar(11),isnull(slibm_dt,''),103) slibm_dt         
     ,slibm_book_name                      
    FROM  slip_book_mstr                        
         ,transaction_sub_type_mstr                        
         ,dp_mstr                        
    WHERE slibm_dpm_id = dpm_id                          
    and   slibm_tratm_id = trastm_id                          
    and   dpm_id    =@l_dpm_dpid --case when @l_dpm_dpid                        ='3' then '999' else @l_dpm_dpid end
    and   trastm_id   = @pa_values                        
    and   SLIBM_SERIES_TYPE        = @pa_desc --like case when LTRIM(RTRIM(@pa_desc)) = '' then '%' else LTRIM(RTRIM(@pa_desc))  end                          
    and   slibm_book_name >= @pa_cd and  slibm_book_name <= @pa_rmks                         
    and slibm_deleted_ind = 1                        
    and   not exists(select sliim_id from slip_issue_mstr where sliim_series_type = SLIBM_SERIES_TYPE and sliim_slip_no_fr = SLIBM_FROM_NO and sliim_slip_no_to = SLIBM_TO_NO and sliim_tratm_id = @pa_values and sliim_deleted_ind = 1)                      
    and   not exists(select sliim_id from slip_issue_mstr_poa where sliim_series_type = SLIBM_SERIES_TYPE and sliim_slip_no_fr = SLIBM_FROM_NO and sliim_slip_no_to = SLIBM_TO_NO and sliim_tratm_id = @pa_values and sliim_deleted_ind = 1)                      
     order by  SLIBM_FROM_NO                     
  --                        
  end                        
  ELSE IF @pa_action = 'SLIIM_SEL'                        
  BEGIN                        
  --                        
    IF @pa_rmks = ''  --                      
    BEGIN                        
    --                        
      SET @pa_rmks  = null                        
    --                        
    END                        
                               
                            
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                           
              ,dpm_dpid                 DpId                         
              ,trastm_desc              CATEGORY                             
              ,sliim_series_type        SERIESTYPE                                    
              ,sliim_slip_no_fr         SLIPNOFROM                          
              ,sliim_slip_no_to         SLIPNOTO                                     
              ,enttm_desc               EntityType                          
              ,entm_name1          EntityName                           
              --,entm_name1               NAME                          
              ,sliim_dpam_acct_no       ACCOUNTNO                          
              ,sliim_id                 ID                          
              ,entm_id               ENTITY_ID                          
              ,sliim_loose_y_n          LOOSE                        
              ,dpm_name                 DPNAME                        
              ,''                       ERRMSG   
			  ,sliim_dt                       
        FROM   slip_issue_mstr                          
              ,transaction_sub_type_mstr                          
              ,entity_mstr                           
              ,entity_type_mstr                          
              ,company_mstr                               
              ,exch_seg_mstr   EXCSM                        
              ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dp_mstr                          
              ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
                                      
        WHERE  entm_id                 = sliim_entm_id                          
        AND    trastm_id               = sliim_tratm_id                          
        AND    dpam.dpam_sba_no        = sliim_dpam_acct_no           
        AND    trastm_id               = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trastm_id ELSE convert(numeric, @pa_values) END                          
        AND    entm_enttm_cd           = enttm_cd                          
        AND    dpm_excsm_id            = excsm.excsm_id                          
        AND    excsm_list.excsm_id      = excsm.excsm_id                        
        AND    excsm_compm_id          = compm_id                            
        AND    dpm_id                  = sliim_dpm_id                          
        AND    dpm_excsm_id            = convert(numeric,@pa_id)                        
        AND    sliim_series_type       = @pa_cd                        
       AND    isnull(@pa_rmks,0)  between CONVERT(BIGINT,sliim_slip_no_fr)  and CONVERT(BIGINT,sliim_slip_no_to)                                   
        AND    sliim_deleted_ind = 1                          
                                
        union                        
                                
        SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                           
                  ,dpm_dpid                 DpId                         
                  ,trastm_desc              CATEGORY                             
                  ,sliim_series_type        SERIESTYPE                                    
                  ,sliim_slip_no_fr         SLIPNOFROM                          
                  ,sliim_slip_no_to   SLIPNOTO                                      
                  ,'CLIENT'                 EntityType                          
                  ,dpam.dpam_sba_name          EntityName                           
                  --,entm_name1               NAME                          
                  ,sliim_dpam_acct_no       ACCOUNTNO                          
                  ,sliim_id                 ID                          
                  ,clim_crn_no              ENTITY_ID                          
                  ,sliim_loose_y_n          LOOSE                        
                  ,dpm_name                 DPNAME                        
                  ,''                       ERRMSG    
					,sliim_dt                      
            FROM   slip_issue_mstr                          
                  ,transaction_sub_type_mstr                          
                  ,client_mstr                           
                  ,dp_acct_mstr     dpacm                        
                  ,company_mstr                               
                  ,exch_seg_mstr EXCSM                           
                  ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
                  ,dp_mstr                          
                  ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            WHERE  clim_crn_no             = sliim_entm_id                          
            AND    clim_crn_no             = dpacm.dpam_crn_no                        
            AND    trastm_id               = sliim_tratm_id                          
            AND    dpam.dpam_sba_no        = sliim_dpam_acct_no                        
            AND    trastm_id               = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trastm_id ELSE convert(numeric, @pa_values) END                          
            AND    excsm_list.excsm_id      = excsm.excsm_id                        
            AND    dpm_excsm_id            = excsm.excsm_id                          
            AND    excsm_compm_id          = compm_id                            
            AND    dpm_id                  = sliim_dpm_id                          
          AND    dpm_excsm_id            = convert(numeric,@pa_id)                        
            AND    sliim_series_type     =@pa_cd                     
            AND    isnull(@pa_rmks,0)  between CONVERT(BIGINT,sliim_slip_no_fr)  and CONVERT(BIGINT,sliim_slip_no_to)                       
            AND    sliim_deleted_ind = 1                          
                                
                            
                            
                        
  --                        
  END           
  ELSE IF @pa_action = 'SLIIM_SELM'                        
  BEGIN                        
  --                        
    IF @pa_rmks = ''                        
    BEGIN                        
    --                        
      SET @pa_rmks  = null                        
    --                        
    END                        
    IF @pa_values <> ''                        
    BEGIN                        
    --                        
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                           
            ,dpm_dpid                 DpId                         
            ,trastm_desc              CATEGORY                             
            ,sliim_series_type        SERIESTYPE                                    
            ,sliim_slip_no_fr         SLIPNOFROM                          
            ,sliim_slip_no_to         SLIPNOTO                                     
            ,enttm_desc               EntityType                          
            ,entm_short_name          EntityName                           
            --,entm_name1               NAME                          
            ,sliim_dpam_acct_no       ACCOUNTNO                          
            ,sliim_id                 ID                          
            ,entm_id                  ENTITY_ID                          
            ,sliim_loose_y_n          LOOSE                        
            ,dpm_name                 DPNAME                        
            ,''                       ERRMSG                          
      FROM   sliim_mak                        
            ,transaction_sub_type_mstr                          
            ,entity_mstr                           
            ,entity_type_mstr                          
            ,company_mstr                               
            ,exch_seg_mstr    EXCSM                  ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dp_mstr                          
,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  entm_id                 = sliim_entm_id                          
      AND    trastm_id               = sliim_tratm_id                         
      AND    dpam.dpam_sba_no        = sliim_dpam_acct_no                        
      AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    entm_enttm_cd           = enttm_cd                          
      AND    dpm_excsm_id            = excsm.excsm_id                          
      AND    excsm_compm_id          = compm_id                            
      AND    dpm_id                  = sliim_dpm_id                        
      AND    sliim_id                = @pa_values                        
      AND    sliim_deleted_ind       IN (0,6)                        
                              
      union                        
                              
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                           
            ,dpm_dpid                 DpId                         
            ,trastm_desc              CATEGORY                             
            ,sliim_series_type        SERIESTYPE                                    
            ,sliim_slip_no_fr         SLIPNOFROM                          
            ,sliim_slip_no_to         SLIPNOTO                                     
             ,'CLIENT'                 EntityType                          
            ,dpam.dpam_sba_name          EntityName                           
            --,entm_name1               NAME                          
            ,sliim_dpam_acct_no       ACCOUNTNO                          
            ,sliim_id                 ID                          
            ,clim_crn_no              ENTITY_ID                          
            ,sliim_loose_y_n          LOOSE                        
            ,dpm_name                 DPNAME                        
            ,''                       ERRMSG                          
      FROM   sliim_mak                        
            ,transaction_sub_type_mstr                          
            ,client_mstr                          
            ,company_mstr                               
            ,exch_seg_mstr   EXCSM                        
            ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dp_mstr                          
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  clim_crn_no             = sliim_entm_id                          
      AND    trastm_id               = sliim_tratm_id                         
      AND    dpam.dpam_sba_no        = sliim_dpam_acct_no                        
      AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    dpm_excsm_id            = excsm.excsm_id                        
      AND    excsm_compm_id          = compm_id                            
      AND    dpm_id                  = sliim_dpm_id                        
      AND    sliim_id                = @pa_values                        
      AND    sliim_deleted_ind       IN (0,6)                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                            
            ,dpm_dpid                 DpId                         
            ,trastm_desc              CATEGORY                             
            ,sliim_series_type        SERIESTYPE                                    
            ,sliim_slip_no_fr         SLIPNOFROM                          
            ,sliim_slip_no_to         SLIPNOTO                                     
            ,enttm_desc               EntityType                          
            ,entm_short_name          EntityName                           
            --,entm_name1               NAME                          
            ,sliim_dpam_acct_no       ACCOUNTNO                          
            ,sliim_id                 ID                          
            ,entm_id                  ENTITY_ID                          
            ,sliim_loose_y_n          LOOSE                        
            ,dpm_name                 DPNAME                        
            ,''                       ERRMSG                          
      FROM   sliim_mak                        
            ,transaction_sub_type_mstr                          
            ,entity_mstr                           
            ,entity_type_mstr                          
            ,company_mstr                               
            ,exch_seg_mstr   EXCSM                        
            ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dp_mstr                          
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  entm_id                 = sliim_entm_id                          
      AND    trastm_id               = sliim_tratm_id                          
      AND    dpam.dpam_sba_no        = sliim_dpam_acct_no                        
      AND    trastm_id               = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trastm_id ELSE convert(numeric, @pa_values) END                           
      AND    entm_enttm_cd           = enttm_cd                          
      AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    dpm_excsm_id            = excsm.excsm_id                          
      AND    excsm_compm_id          = compm_id                            
      AND    dpm_id                  = sliim_dpm_id                        
      AND    dpm_excsm_id            = @pa_desc                        
      AND    sliim_series_type       = @pa_cd                   
      AND    isnull(@pa_rmks,0)  between CONVERT(BIGINT,sliim_slip_no_fr)  and CONVERT(BIGINT,sliim_slip_no_to)                             
      AND    sliim_deleted_ind       IN (0,6)                        
                              
      union                        
                              
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                            
            ,dpm_dpid                 DpId                         
            ,trastm_desc      CATEGORY                             
            ,sliim_series_type        SERIESTYPE                                    
            ,sliim_slip_no_fr         SLIPNOFROM                          
            ,sliim_slip_no_to         SLIPNOTO                                     
            ,'CLIENT'                 EntityType                          
            ,dpam.dpam_sba_name          EntityName       
            --,entm_name1               NAME                          
            ,sliim_dpam_acct_no       ACCOUNTNO                          
         ,sliim_id                 ID                          
            ,clim_crn_no     ENTITY_ID                          
            ,sliim_loose_y_n          LOOSE                        
            ,dpm_name                 DPNAME                        
            ,''    ERRMSG                          
      FROM   sliim_mak                        
            ,transaction_sub_type_mstr                          
            ,client_mstr                           
            ,company_mstr                               
            ,exch_seg_mstr   EXCSM                        
            ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dp_mstr                          
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  clim_crn_no                 = sliim_entm_id                          
      AND    trastm_id               = sliim_tratm_id                          
      AND    dpam.dpam_sba_no        = sliim_dpam_acct_no                        
      AND    trastm_id               = CASE WHEN LTRIM(RTRIM(@pa_values)) = '' THEN trastm_id ELSE convert(numeric, @pa_values) END                           
                        
      AND    dpm_excsm_id            = excsm.excsm_id                          
      AND    excsm_compm_id          = compm_id                            
      AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    dpm_id                  = sliim_dpm_id                        
      AND    dpm_excsm_id            = @pa_desc                        
      AND    sliim_series_type       = @pa_cd               
      AND    isnull(@pa_rmks,0)  between CONVERT(BIGINT,sliim_slip_no_fr)  and CONVERT(BIGINT,sliim_slip_no_to)                                        
      AND    sliim_deleted_ind       IN (0,6)                        
    --                        
    END                        
                        
                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'SLIIM_SELC'                        
    BEGIN                        
    --                        
      IF @pa_rmks = ''                        
      BEGIN                        
      --                        
        SET @pa_rmks  = null                        
      --                        
      END                        
                          
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                            
            ,dpm_dpid                 DpId                         
            ,trastm_desc              CATEGORY                             
            ,sliim_series_type        SERIESTYPE                     
            ,sliim_slip_no_fr         SLIPNOFROM                          
            ,sliim_slip_no_to         SLIPNOTO                                     
            ,enttm_desc               EntityType                          
            ,entm_short_name          EntityName                           
            --,entm_name1               NAME                          
            ,sliim_dpam_acct_no       ACCOUNTNO                          
            ,sliim_id                 ID                          
            ,entm_id                  ENTITY_ID                          
            ,sliim_loose_y_n          LOOSE                        
  ,dpm_name                 DPNAME                        
            ,sliim_deleted_ind        SLIIM_DELETED_IND                         
            ,''                       ERRMSG                          
      FROM sliim_mak                        
            ,transaction_sub_type_mstr                          
            ,entity_mstr                           
            ,entity_type_mstr                          
            ,company_mstr                               
            ,exch_seg_mstr   excsm                        
   ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dp_mstr                          
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  entm_id                 = sliim_entm_id                          
      AND    trastm_id               = sliim_tratm_id       
      and dpam.dpam_sba_no        = sliim_dpam_acct_no                               
      AND    entm_enttm_cd           = enttm_cd                          
      AND    dpm_excsm_id            = excsm.excsm_id                          
      AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    excsm_compm_id          = compm_id                            
      and    dpm_id                  = sliim_dpm_id                          
      AND    sliim_lst_upd_by        <> @pa_login_name                        
      AND    sliim_deleted_ind       IN (0,4,6)                        
      AND    dpm_excsm_id =CONVERT(INT,@pa_cd)                        
                              
      UNION                        
                              
      SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd COMPANY                            
            ,dpm_dpid                 DpId                      
            ,trastm_desc              CATEGORY                             
            ,sliim_series_type        SERIESTYPE                                    
            ,sliim_slip_no_fr         SLIPNOFROM                          
            ,sliim_slip_no_to         SLIPNOTO                                     
           ,'CLIENT'                 EntityType                          
            ,dpam.dpam_sba_name          EntityName                           
            --,entm_name1               NAME                          
            ,sliim_dpam_acct_no       ACCOUNTNO                          
            ,sliim_id                 ID                          
            ,clim_crn_no              ENTITY_ID                          
            ,sliim_loose_y_n          LOOSE                        
            ,dpm_name                 DPNAME                        
            ,sliim_deleted_ind        SLIIM_DELETED_IND                         
            ,''                       ERRMSG                          
      FROM   sliim_mak                        
            ,transaction_sub_type_mstr                          
            ,client_mstr                           
                                   
            ,company_mstr                               
            ,exch_seg_mstr   excsm                        
            ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dp_mstr                          
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  clim_crn_no             = sliim_entm_id                          
      AND    trastm_id               = sliim_tratm_id                          
      and    dpam.dpam_sba_no        = sliim_dpam_acct_no                        
      AND    excsm_list.excsm_id      = excsm.excsm_id                        
                              
      AND    dpm_excsm_id            = excsm.excsm_id                          
      AND    excsm_compm_id          = compm_id                            
      and    dpm_id                  = sliim_dpm_id                          
 AND    sliim_lst_upd_by        <> @pa_login_name                        
      AND    sliim_deleted_ind       IN (0,4,6)                        
      AND    dpm_excsm_id =CONVERT(INT,@pa_cd)                        
                          
                          
                          
    --                        
  END                        
  IF @pa_action = 'GETSERIES'                        
  BEGIN                        
  --         
    SELECT distinct slibm_series_type                         
    FROM   transaction_type_mstr                        
           ,slip_book_mstr                         
           ,transaction_sub_type_mstr               
    WHERE  slibm_tratm_id = trastm_id                         
    AND    trastm_tratm_id = trantm_id                        
    AND    trantm_deleted_ind = 1                        
    AND    trastm_deleted_ind = 1                        
    AND    slibm_deleted_ind = 1                        
    AND    trastm_id         = @pa_id          --                        
  END                        
  IF @pa_action = 'GETCTGRY'                        
  BEGIN                        
  --                
    SELECT trantm_id                         
          ,trantm_desc                        
    FROM   transaction_type_mstr                        
    WHERE  trantm_deleted_ind = 1                        
    AND    trantm_excm_id     = @pa_id                        
  --                        
  END                        
  IF @pa_action = 'INT_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                      
          ,ISNULL(settm_desc,'')                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_rmks                   REMARKS                         
    FROM   dp_trx_dtls                 dptd                
           LEFT OUTER JOIN           settlement_type_mstr        settm ON                         
           settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           = '925'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'INT_DP_TRX_SEL_DTLS'                
  BEGIN                        
  --                        
    SELECT  dptd_counter_dp_id                                    
     ,dptd_other_settlement_type                        
     ,dptd_other_settlement_no                        
     ,dptd_counter_demat_acct_no                          
     ,dptd_isin                        
     ,abs(dptd_qty)    dptd_qty                        
     ,dptd_id                        
    FROM   dp_trx_dtls                 dptd                         
    WHERE  dptd_dtls_id               = @pa_id                        
    AND    dptd_deleted_ind           = 1                        
    AND    dptd_trastm_cd             = '925'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                                          
                        
  --                        
  END                        
  ELSE IF @pa_action = 'INT_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                    DPID                               ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                   REMARKS                        
      FROM   dptd_mak                 dptd                         
             LEFT OUTER JOIN           settlement_type_mstr        settm ON                         
             settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
          --  ,dp_mstr            dpm                         
          --  ,dp_acct_mstr                dpam                          
          --  ,exch_seg_mstr               excsm                        
          --  ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          --  ,settlement_type_mstr        settm                              
        ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END           
      AND    dptd_deleted_ind          IN (0,6,-1)                        
      AND    dptd_trastm_cd           = '925'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
   ,dpam_sba_no          ACCOUNTNO                        
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                   REMARKS                        
      FROM   dptd_mak                    dptd                         
             LEFT OUTER JOIN           settlement_type_mstr        settm ON                         
              settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam            
           -- ,settlement_type_mstr        settm                              
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
      AND    dptd_dtls_id              = @pa_values                        
      AND    dptd_deleted_ind          IN (0,6,-1)                        
      AND    dptd_trastm_cd           = '925'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
                            
                            
                            
  --                        
  END                        
  ELSE IF @pa_action = 'INT_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_counter_dp_id                                    
     ,dptd_other_settlement_type                        
     ,dptd_other_settlement_no                   ,dptd_counter_demat_acct_no                          
     ,dptd_isin                        
     ,abs(dptd_qty)       dptd_qty                        
     ,dptd_id                        
  FROM    dptd_mak                    dptd                         
    WHERE   dptd_dtls_id            = @pa_id                        
    AND     dptd_deleted_ind           IN (0,4,6,-1)                        
    AND    dptd_trastm_cd           = '925'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                            
    union                        
                            
    SELECT  dptd_counter_dp_id                                    
           ,dptd_other_settlement_type                        
           ,dptd_other_settlement_no                        
        ,dptd_counter_demat_acct_no               
           ,dptd_isin                        
           ,abs(dptd_qty)       dptd_qty                        
           ,dptd_id                        
    FROM    dp_trx_dtls               dptd                         
    WHERE   dptd_dtls_id            = @pa_id                        
    AND     dptd_deleted_ind        = 1                        
    AND     dptd_trastm_cd          = '925'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'INT_DP_TRX_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct   @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)      EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                 [FROMACCOUNTNO]                        
          ,@pa_id                  EXCHANGEID                        
      ,dptd_dtls_id                DTLSID                         
          ,'0' dptd_deleted_ind                                    
          ,dptd_rmks                   REMARKS                        
          --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
          -- when dptd_deleted_ind = -1 then dptd_created_by end chk         
                                        ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD and dptdm.DPTD_EXECUTION_DT =
  
    
      
      
        
          
          
 dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
          ,''                    QUANTITY                        
          ,'' [TOACCOUNTNO]               --          
    FROM   dptd_mak                    dptd                         
           LEFT OUTER JOIN           settlement_type_mstr       settm ON                         
                       settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
     --     ,dp_mstr                     dpm                         
     --     ,dp_acct_mstr                dpam                          
     --     ,exch_seg_mstr               excsm                        
     --     ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
     --     ,settlement_type_mstr        settm                        
           ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
    AND    dptd_deleted_ind          IN (0,4,6,-1)                        
    AND    dptd_trastm_cd   = '925'                        
    --AND    dpm_excsm_id              = CONVERT(INT,@pa_cd)                        
    AND    dptd_lst_upd_by           <> @pa_login_name                        
    and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  IF @pa_action = 'INT_DP_R_TRX_SEL'                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid   DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,ISNULL(settm_desc,'')                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks            REMARKS                         
      FROM   dp_trx_dtls                 dptd                         
             LEFT OUTER JOIN           settlement_type_mstr        settm ON                         
             settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                     
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         = 1                        
      AND    dptd_trastm_cd           = '926'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE IF @pa_action = 'INT_DP_R_TRX_SEL_DTLS'                        
    BEGIN                        
    --                        
      SELECT  dptd_counter_dp_id                                    
       ,dptd_other_settlement_type                        
       ,dptd_other_settlement_no                        
       ,dptd_counter_demat_acct_no                          
       ,dptd_isin                        
       ,abs(dptd_qty)    dptd_qty                        
       ,dptd_id                        
      FROM   dp_trx_dtls                 dptd                         
      WHERE  dptd_dtls_id               = @pa_id                        
      AND    dptd_deleted_ind           = 1                        
      AND    dptd_trastm_cd             = '926'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                                      
                          
    --                        
    END                        
    ELSE IF @pa_action = 'INT_DP_R_TRX_SELM'                        
    BEGIN                        
    --                        
      IF @pa_values = ''                        
      BEGIN                        
      --                        
        SELECT distinct @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
              ,dptd_slip_no                SLIPNO                         
              ,settm_desc                  MARKETTYPE                        
              ,dptd_settlement_no          SETTLEMENTNO                        
              ,dpam_sba_no                ACCOUNTNO                        
              ,@pa_id                    EXCHANGEID                        
              ,dptd_dtls_id                DTLSID                         
              ,dptd_rmks                   REMARKS                        
        FROM   dptd_mak                    dptd                         
               LEFT OUTER JOIN           settlement_type_mstr        settm ON                         
               settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
              --,dp_mstr                     dpm                         
 --,dp_acct_mstr                dpam                          
              --,exch_seg_mstr               excsm                        
              --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            --  ,settlement_type_mstr        settm                              
              ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
        WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
        --AND    excsm.excsm_id            = @pa_id                        
        AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
   AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
        AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind          IN (0,6,-1)                        
        AND    dptd_trastm_cd           = '926'                        
        and    isnull(dptd_brokerbatch_no,'') = ''                        
      --                        
      END                        
      ELSE                        
      BEGIN                        
      --                        
        SELECT distinct @l_dpm_dpid                    DPID                         
              ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
              ,dptd_slip_no                SLIPNO                         
              ,settm_desc                  MARKETTYPE                        
              ,dptd_settlement_no          SETTLEMENTNO                        
              ,dpam_sba_no                ACCOUNTNO                        
              ,@pa_id                   EXCHANGEID                        
              ,dptd_dtls_id                DTLSID                   
              ,dptd_rmks                   REMARKS                        
        FROM   dptd_mak                    dptd                         
               LEFT OUTER JOIN           settlement_type_mstr        settm ON                         
                settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
              --,dp_mstr                     dpm                         
              --,dp_acct_mstr                dpam                          
              --,exch_seg_mstr               excsm                        
              --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
             -- ,settlement_type_mstr        settm                              
              ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
        WHERE  dpam.dpam_id    = dptd.dptd_dpam_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
        AND    dptd_dtls_id              = @pa_values                        
        AND    dptd_deleted_ind          IN (0,6,-1)                        
        AND    dptd_trastm_cd           = '926'                        
        and    isnull(dptd_brokerbatch_no,'') = ''                        
      --                        
      END                        
                              
                              
                              
    --                        
    END                        
    ELSE IF @pa_action = 'INT_DP_R_TRX_SELM_DTLS'                        
    BEGIN                        
    --                        
      SELECT  dptd_counter_dp_id                                    
       ,dptd_other_settlement_type                        
       ,dptd_other_settlement_no                        
       ,dptd_counter_demat_acct_no                    
       ,dptd_isin                        
       ,abs(dptd_qty)       dptd_qty                        
       ,dptd_id                        
      FROM    dptd_mak                    dptd                         
      WHERE   dptd_dtls_id            = @pa_id                        
      AND     dptd_deleted_ind           IN (0,6,-1)                        
      AND    dptd_trastm_cd           = '926'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
                              
      union                        
                              
    SELECT  dptd_counter_dp_id                                    
             ,dptd_other_settlement_type                        
             ,dptd_other_settlement_no                        
             ,dptd_counter_demat_acct_no                          
             ,dptd_isin                        
             ,abs(dptd_qty)       dptd_qty                        
             ,dptd_id                        
      FROM    dp_trx_dtls               dptd                   
      WHERE   dptd_dtls_id            = @pa_id                        
      AND     dptd_deleted_ind        = 1                        
      AND     dptd_trastm_cd          = '926'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                        
                              
    --                     
    END                        
    ELSE IF @pa_action = 'INT_DP_R_TRX_SELC'                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
    ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                FROMACCOUNTNO                        
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,'0' dptd_deleted_ind                                
            ,dptd_rmks                   REMARKS                        
            --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
            -- when dptd_deleted_ind = -1 then dptd_created_by end chk                        
,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD                   
and dptdm.DPTD_EXECUTION_DT = dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
            ,''                    QUANTITY                        
            ,dptd_counter_demat_acct_no  [TOACCOUNTNO]                        
      FROM   dptd_mak                    dptd                         
             LEFT OUTER JOIN           settlement_type_mstr    settm ON                         
             settm.settm_id            = CASE WHEN dptd_mkt_type = '' THEN 0 ELSE dptd_mkt_type END                         
       --     ,dp_mstr         dpm                         
       --     ,dp_acct_mstr                dpam                          
       --     ,exch_seg_mstr               excsm                        
       --     ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                
       --     ,settlement_type_mstr        settm                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    settm.settm_id            = case when isnull(dptd_mkt_type,'')  = ''  then settm.settm_id else dptd_mkt_type end                         
      AND    dptd_deleted_ind          IN (0,4,6,-1)         
      AND    dptd_trastm_cd            = '926'                        
      --AND    dpm_excsm_id              = CONVERT(INT,@pa_cd)                        
      AND    dptd_lst_upd_by           <> @pa_login_name                        
      and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
      and    isnull(dptd_brokerbatch_no,'') = ''                        
   --                        
  END                        
  ELSE IF @pa_action = 'P2P_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm.settm_desc            MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
      ,settm1.settm_desc           TARGETSETLLEMENTTYPE                        
          ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
          ,dptd_counter_cmbp_id        TARGETCMBPID                         
          ,@pa_id                   EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_rmks                        
    FROM   dp_trx_dtls                 dptd                         
    --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                        
          ,settlement_type_mstr        settm1                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    and    settm.settm_id            = dptd.dptd_mkt_type                        
    and    settm1.settm_id           = convert(int,isnull(dptd.dptd_other_settlement_type,'0'))                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           = '934'                 
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --           
  END                        
  ELSE IF @pa_action = 'P2P_DP_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
     ,abs(dptd_qty)     dptd_qty                        
     ,dptd_id                        
    FROM   dp_trx_dtls                 dptd                         
    WHERE  dptd_dtls_id              = @pa_id                        
    AND    dptd_deleted_ind          = 1                        
    AND    dptd_trastm_cd           = '934'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'P2P_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)    REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm.settm_desc            MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm1.settm_desc           TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID          
            ,@pa_id   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
                                  
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                        
            ,settlement_type_mstr        settm1                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                     
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      AND    settm1.settm_id           = convert(int,isnull(dptd.dptd_other_settlement_type,'0'))                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind          IN (0,6,-1)                        
      AND    dptd_trastm_cd           = '934'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)  EXECUTIONDATE                        
       ,dptd_slip_no                SLIPNO                         
            ,settm.settm_desc            MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm1.settm_desc           TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
                  
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                        
            ,settlement_type_mstr        settm1                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id         
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      AND    settm1.settm_id      = convert(int,isnull(dptd.dptd_other_settlement_type,'0'))                        
      AND    dptd_deleted_ind          IN (0,6,-1)                        
      AND    dptd_dtls_id             = @pa_values                        
      AND    dptd_trastm_cd           = '934'                         
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'P2P_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
     ,abs(dptd_qty)    dptd_qty                        
     ,dptd_id                        
    FROM    dptd_mak              dptd                         
    WHERE   dptd_dtls_id        = @pa_id                        
    AND    dptd_deleted_ind       IN (0,6,-1)                        
    AND    dptd_trastm_cd           = '934'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'P2P_DP_TRX_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE        
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
 ,settm.settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
          ,settm1.settm_desc           TARGETSETLLEMENTTYPE                        
          ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
          ,dptd_counter_cmbp_id        TARGETCMBPID                         
          ,@pa_id              EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,'0' deleted_ind                         
          ,dptd_rmks                        
          --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
          --      when dptd_deleted_ind = -1 then dptd_created_by end chk                        
                                  ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD and dptdm.DPTD_EXECUTION_DT = dptd.
  
    
      
      
        
          
            
              
                
                  
                    
DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
         ,''                    QUANTITY              
    FROM   dptd_mak               dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
  ,settlement_type_mstr        settm                        
          ,settlement_type_mstr        settm1                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    AND    settm1.settm_id           = convert(int,isnull(dptd.dptd_other_settlement_type,'0'))                        
    --AND    dpm_excsm_id              = convert(int,@pa_cd)                        
    AND    dptd_deleted_ind          IN (0,4,6,-1)                        
    AND    dptd_trastm_cd            = '934'                        
    AND    dptd_created_by           <> @pa_login_name                        
    and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
    and    isnull(dptd_brokerbatch_no,'') = ''                        
      --                        
  END                        
        ELSE IF @pa_action = 'ONC2P_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
   --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                        
            ,dptd_rmks                   REMARKS                        
    FROM   dp_trx_dtls                 dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr            settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    settm_id                  = dptd_other_settlement_type                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         = 1                        
      AND    dptd_trastm_cd            = '904'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''          
      and    dptd_internal_trastm = 'C2P'                        
      and isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)          EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                    EXCHANGEID                   
            ,dptd_dtls_id  DTLSID                        
            ,dptd_rmks                   REMARKS                        
      FROM   dp_trx_dtls                 dptd                         
           --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id       
      AND    settm_id                  = dptd_other_settlement_type                        
 AND    dptd_dtls_id              = @pa_values                        
      AND    dptd_deleted_ind         = 1                        
      AND    dptd_trastm_cd            = '904'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONC2P_DP_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
     ,abs(dptd_qty)   dptd_qty                        
     ,dptd_id                        
    FROM   dp_trx_dtls                 dptd                         
    WHERE  dptd_dtls_id              = @pa_id                        
    AND    dptd_deleted_ind          = 1                        
    AND    dptd_trastm_cd            = '904'                        
and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONC2P_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
                            
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
       ,dpam_sba_no                ACCOUNTNO       
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id              EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list              
            ,settlement_type_mstr        settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    settm_id                  = dptd_other_settlement_type                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                      
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd            = '904'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
           --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    settm_id                  = dptd_other_settlement_type                        
      AND    dptd_dtls_id              = @pa_values                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd            = '904'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'ONC2P_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
     ,abs(dptd_qty)     dptd_qty                        
     ,dptd_id                        
    FROM   dptd_mak                    dptd                         
    WHERE  dptd_dtls_id              = @pa_id                        
    AND    dptd_deleted_ind          IN(0,6,-1)                        
    AND    dptd_trastm_cd            = '904'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
    order by dptd_id                         
                    
                        
  --                        
  END                        
                        
 /* ELSE IF @pa_action = 'ONC2P_DP_TRX_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct  dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,dpam_acct_no                ACCOUNTNO                        
          ,settm_desc                  TARGETSETLLEMENTTYPE                        
          ,dptd_other_settlement_no    TRAGETSETTLEMENTNO_TARGETACCOUNTNO                        
          ,dptd_counter_cmbp_id        TARGETCMBPID_TARGETDPID                        
          ,excsm_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_deleted_ind                         
          ,dptd_rmks                        
    FROM   dptd_mak                    dptd                         
          ,dp_mstr                     dpm                         
          ,dp_acct_mstr                dpam                          
          ,exch_seg_mstr               excsm                        
                                  
          ,settlement_type_mstr        settm                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    AND    dpm_excsm_id              = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    settm_id                  = dptd_other_settlement_type                        
    AND    dptd_deleted_ind         IN (0,4,6)                        
    AND    dptd_lst_upd_by           <> @pa_login_name                        
    AND    dptd_trastm_cd            = '904'                        
    AND    isnull(dptd_other_settlement_type,'') <> ''                        
  --                        
  END*/                        
ELSE IF @pa_action = 'ONC2P_R_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID      
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
   ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO              ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                        
            ,dptd_rmks                   REMARKS                        
      FROM   dp_trx_dtls                 dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr            settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    settm_id                  = dptd_other_settlement_type                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         = 1                        
      AND    dptd_trastm_cd            = '905'                
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P_R'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
  END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                             ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                        
            ,dptd_rmks                   REMARKS                        
      FROM   dp_trx_dtls                 dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm               
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list         
            ,settlement_type_mstr        settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    settm_id                  = dptd_other_settlement_type                        
      AND    dptd_dtls_id              = @pa_values                  
      AND    dptd_deleted_ind         = 1                        
      AND    dptd_trastm_cd            = '905'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P_R'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONC2P_R_DP_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
     ,abs(dptd_qty)   dptd_qty                        
     ,dptd_id                        
    FROM   dp_trx_dtls                 dptd                         
    WHERE  dptd_dtls_id              = @pa_id                        
    AND    dptd_deleted_ind          = 1                        
    AND    dptd_trastm_cd            = '905'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONC2P_R_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
                            
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
        ,settm_desc                  TARGETSETLLEMENTTYPE               
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id DTLSID                         
            ,dptd_rmks                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                         
   ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    settm_id                  = dptd_other_settlement_type                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd            = '905'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P_R'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm_desc                  TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,dptd_counter_cmbp_id        TARGETCMBPID                         
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                         
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id            
      AND    settm_id                  = dptd_other_settlement_type                        
      AND    dptd_dtls_id              = @pa_values                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd            = '905'                        
      AND    isnull(dptd_other_settlement_type,'') <> ''                        
      and    dptd_internal_trastm = 'C2P_R'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'ONC2P_R_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
     ,abs(dptd_qty)     dptd_qty                        
     ,dptd_id                        
    FROM   dptd_mak                    dptd                         
    WHERE  dptd_dtls_id              = @pa_id                        
    AND    dptd_deleted_ind          IN(0,6,-1)                        
    AND    dptd_trastm_cd            = '905'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                         
                        
  --                        
  END                
  ELSE IF @pa_action = 'ONP2C_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,accp_value                  CMBPID                         
          ,@pa_id                   EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_rmks                        
          ,dpam_sba_no                ACCOUNTNO                        
    FROM   dp_trx_dtls                 dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr            dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                         
          ,account_properties          accp                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    accp_clisba_id            = dpam.dpam_id                        
    and    settm.settm_id            = dptd.dptd_mkt_type                        
    AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd            = '904'                        
  AND    isnull(dptd_other_settlement_type,'') = ''                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONP2C_DP_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_counter_demat_acct_no                        
           ,dptd_counter_dp_id                                    
           ,isnull(dptd_others_cl_name,'') dptd_others_cl_name                        
           ,dptd_isin                        
           ,abs(dptd_qty)    dptd_qty                        
           ,dptd_id                        
    FROM   dp_trx_dtls                  dptd                         
    WHERE  dptd_dtls_id               = @pa_id                        
    AND    dptd_deleted_ind           = 1                        
    AND    dptd_trastm_cd            = '904'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONP2C_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''     
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,accp_value                  CMBPID                         
  ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
            ,dpam_sba_no                ACCOUNTNO                         
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                        
            ,account_properties          accp                        
      ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                       
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    accp_clisba_id            = dpam.dpam_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      --AND    excsm.excsm_id      = @pa_id                        
      AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd            = '904'                        
      AND    isnull(dptd_other_settlement_type,'') = ''                        
      and    isnull(dptd_brokerbatch_no,'') = ''                     
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                     
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,accp_value                  CMBPID                          
            ,@pa_id                    EXCHANGEID               
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
            ,dpam_sba_no                ACCOUNTNO                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr        settm                        
            ,account_properties          accp                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id             
      AND    accp_clisba_id            = dpam.dpam_id                        
      AND settm.settm_id            = dptd.dptd_mkt_type                        
      AND    dptd_dtls_id              = @pa_values                        
      AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd            = '904'                        
      AND    isnull(dptd_other_settlement_type,'') = ''                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'ONP2C_DP_TRX_SELM_DTLS'        BEGIN                        
  --                        
    SELECT  dptd_counter_demat_acct_no            
           ,dptd_counter_dp_id                                    
           ,isnull(dptd_others_cl_name,'') dptd_others_cl_name                        
           ,dptd_isin                        
           ,abs(dptd_qty)    dptd_qty                        
           ,dptd_id                        
    FROM   dptd_mak                     dptd                         
    WHERE  dptd_dtls_id               = @pa_id                        
    AND    dptd_deleted_ind           IN (0,6,-1)                        
    AND    dptd_trastm_cd            = '904'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
    order by dptd_id                         
  --                        
  END                        
  ELSE IF @pa_action = 'ONP2C_DP_TRX_SELC'                 
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no   SETTLEMENTNO                        
          ,accp_value                  CMBPID                          
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,'0' dptd_deleted_ind                         
          ,dptd_rmks                        
          ,dpam_sba_no                ACCOUNTNO                        
          --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
          --      when dptd_deleted_ind = -1 then dptd_created_by end chk                        
                                        ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD and dptdm.DPTD_EXECUTION_DT =
  
    
      
      
        
          
            
              
                
                  
                     
                
 dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
          ,'' QUANTITY                        
    FROM   dptd_mak                    dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                        
          ,account_properties          accp                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                 
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    AND    dptd_deleted_ind         IN (0,4,6,-1)                        
    AND    accp_clisba_id            = dpam.dpam_id                        
    AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
    --AND    dpm_excsm_id = convert(int,@pa_cd)                        
    AND    dptd_lst_upd_by           <> @pa_login_name                        
    AND    dptd_trastm_cd            = '904'                        
    AND    isnull(dptd_other_settlement_type,'') = ''                        
    and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                 
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,dpam_sba_no                ACCOUNTNO                        
          ,dptd_counter_dp_id          TARGETCMBPID_TARGETDPID                        
          ,dptd_counter_demat_acct_no  TRAGETSETTLEMENTNO_TARGETACCOUNTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
    ,dptd_rmks       REMARKS                        
          ,dptd_reason_cd              REASONCODE                        
    FROM   dp_trx_dtls                 dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
 ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    convert(varchar,dptd.dptd_request_dt,103)     LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end              
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           = '904'                        
    AND    isnull(dptd_other_settlement_type,'') = ''                        
    and    dptd_internal_trastm = 'C2C'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_DP_TRX_SEL_DTLS'                        
  BEGIN                       
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)   dptd_qty                        
           ,dptd_id                        
    FROM   dp_trx_dtls                 dptd                         
    WHERE  dptd_dtls_id               = @pa_id                        
    AND     dptd_deleted_ind          = 1                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_DP_TRX_SELM'                        
  BEGIN                        
  --                        
     IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
      ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                       
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID      CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                  DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                          
            ,dptdc_rmks                        
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
    ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
          --   ,dptdc_created_by Makerid                         
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr       excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
 left outer join                          
            settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )            
           left outer join                          
           settlement_type_mstr          settm2                          
            on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind         in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM')                               
      and    isnull(dptdc_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                         TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                         DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                      
            ,dptdc_rmks                        
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD            
            ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
            , (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]             
,dptdc_created_by Makerid                    
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr  dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
             left outer join                          
             settlement_type_mstr          settm1                          
             on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                 
             left outer join                          
             settlement_type_mstr          settm2                          
              on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id   = @pa_values                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                  
      AND    dptdc_deleted_ind         in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM')                        
      and    isnull(dptdc_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                         
  ELSE IF @pa_action = 'OFFM_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)  dptd_qty                        
           ,dptd_id                        
    FROM   dptd_mak                     dptd          
    WHERE  dptd_dtls_id               = @pa_id                   
    AND    dptd_deleted_ind            in (0,6,-1)                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by  dptd_id                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_DP_TRX_SELC'                        
  BEGIN                        
  --                        
     SELECT distinct  @l_dpm_dpid                    DPID                         
              ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
              ,dptd_slip_no                SLIPNO        
              ,dpam_sba_no                ACCOUNTNO                        
              ,settm_desc                  TARGETSETLLEMENTTYPE                        
              ,case when dptd_internal_trastm = 'C2C' then dptd_counter_dp_id  WHEN dptd_internal_trastm = 'C2P' then  dptd_counter_cmbp_id end  DP_CMBPID                        
              ,case when dptd_internal_trastm = 'C2C' then dptd_counter_demat_acct_no when dptd_internal_trastm = 'C2p' then dptd_other_settlement_no END TARGETACCOUNTNO                        
              ,@pa_id                   EXCHANGEID                        
              ,dptd_dtls_id                DTLSID                         
              ,dptd_internal_trastm        mktype                        
              ,'0' deleted_ind                         
              ,dptd_rmks                   REMARKS                        
              --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
              -- when dptd_deleted_ind = -1 then dptd_created_by end chk                        
,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD                   
and dptdm.DPTD_EXECUTION_DT = dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
              ,''                    QUANTITY                        
        FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
              -- dp_mstr       dpm                         
              --,dp_acct_mstr                dpam                          
              --,exch_seg_mstr            excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptd_mak                    dptd                         
               left outer join                          
               settlement_type_mstr        settm  on settm_id = dptd_other_settlement_type                        
        WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    dpm_excsm_id              = convert(int,@pa_cd)                        
        AND    dptd_deleted_ind          in (0,4,6,-1)                        
        AND    dptd_lst_upd_by          <> @pa_login_name          AND    dptd_trastm_cd           = '904'                        
        and    dptd_internal_trastm in ('C2C','C2P')                        
        and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
        and isnull(dptd_brokerbatch_no,'') = ''                        
                        
                            
  --                        
  END                        
ELSE IF @pa_action = 'OFFM_R_DP_TRX_SEL'                        
  BEGIN       
  --                        
    SELECT distinct @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,dpam_sba_no       ACCOUNTNO                        
          ,dptd_counter_dp_id          TARGETCMBPID_TARGETDPID                        
          ,dptd_counter_demat_acct_no  TRAGETSETTLEMENTNO_TARGETACCOUNTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_rmks       REMARKS                        
        ,dptd_reason_cd              REASONCODE                        
    FROM   dp_trx_dtls                 dptd                         
        --  ,dp_mstr                     dpm                         
        --  ,dp_acct_mstr                dpam                          
        --  ,exch_seg_mstr               excsm                        
        --  , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           = '905'                        
    AND    isnull(dptd_other_settlement_type,'') = ''                        
    and    dptd_internal_trastm = 'C2C_R'                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_R_DP_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)   dptd_qty                        
           ,dptd_id                        
    FROM   dp_trx_dtls                 dptd                         
    WHERE  dptd_dtls_id               = @pa_id                        
    AND     dptd_deleted_ind          = 1                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_R_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO              
            ,dpam_sba_no      ACCOUNTNO                        
            ,dptd_counter_dp_id          TARGETDPID                         
            ,dptd_counter_demat_acct_no  TARGETACCOUNTNO                        
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks        REMARKS                        
            ,dptd_reason_cd REASONCODE                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr     dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                      
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         in (0,6,-1)                        
      AND    dptd_trastm_cd           = '905'               
      AND    isnull(dptd_other_settlement_type,'') = ''                        
      and    dptd_internal_trastm = 'C2C_R'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,dpam_sba_no                ACCOUNTNO                        
            ,dptd_counter_dp_id          TARGETDPID                         
            ,dptd_counter_demat_acct_no  TARGETACCOUNTNO                        
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                   REMARKS                        
                                                ,dptd_reason_cd              REASONCODE                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    dptd.dptd_dtls_id         = @pa_values                        
      AND    dptd_deleted_ind         in (0,6,-1)                        
      AND    dptd_trastm_cd           = '905'                        
      AND    isnull(dptd_other_settlement_type,'') = ''                        
      and    dptd_internal_trastm = 'C2C_R'                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_R_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)  dptd_qty                        
           ,dptd_id                        
    FROM   dptd_mak                     dptd                         
    WHERE  dptd_dtls_id               = @pa_id                        
    AND    dptd_deleted_ind            in (0,6,-1)                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                        
             
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_R_DP_TRX_SELC'                        
  BEGIN                        
  --                        
     SELECT distinct  @l_dpm_dpid                    DPID                         
              ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
           ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
              ,dptd_slip_no                SLIPNO                         
              ,dpam_sba_no                ACCOUNTNO                        
              ,settm_desc                  TARGETSETLLEMENTTYPE                        
              ,case when dptd_internal_trastm = 'C2C' then dptd_counter_dp_id  WHEN dptd_internal_trastm = 'C2P' then  dptd_counter_cmbp_id end  DP_CMBPID         
              ,case when dptd_internal_trastm = 'C2C' then dptd_counter_demat_acct_no when dptd_internal_trastm = 'C2p' then dptd_other_settlement_no END TARGETACCOUNTNO                        
              ,@pa_id                    EXCHANGEID                   
              ,dptd_dtls_id               DTLSID                         
              ,dptd_internal_trastm        mktype                        
              ,'0' dptd_deleted_ind                         
              ,dptd_rmks                   REMARKS                        
              --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
              -- when dptd_deleted_ind = -1 then dptd_created_by end chk                        
,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD                   
and dptdm.DPTD_EXECUTION_DT = dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
              ,''                    QUANTITY                        
        FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
              --,dp_mstr                     dpm                         
              --,dp_acct_mstr                dpam                          
              --,exch_seg_mstr               excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptd_mak                    dptd                         
               left outer join                          
               settlement_type_mstr        settm  on settm_id = dptd_other_settlement_type                        
                                       
        WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    dpm_excsm_id              = convert(int,@pa_cd)                        
        AND    dptd_deleted_ind          in (0,4,6,-1)                        
        AND    dptd_lst_upd_by          <> @pa_login_name                        
        AND    dptd_trastm_cd           = '905'                        
        and    dptd_internal_trastm in ('C2C_R','C2P_R')                        
        and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                          
        and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
                            
  --                        
  END                        
  ELSE IF @pa_action = 'DELOUT_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc      MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no   ACCOUNTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,case when dptd_trastm_cd = '906' THEN 'R' ELSE 'I' end STATUS                        
          ,dptd_rmks                   REMARKS                         
    FROM   dp_trx_dtls              dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
       --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  IF @pa_action = 'DELOUT_DP_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)   dptd_qty                        
           ,dptd_id                        
    FROM    dp_trx_dtls                 dptd                         
    WHERE   dptd_dtls_id              = @pa_id                        
    AND     dptd_deleted_ind          = 1                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
   --                        
  END                        
  ELSE IF @pa_action = 'DELOUT_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
    ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no       SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,case when dptd_trastm_cd = '906' THEN 'R' ELSE 'I' end STATUS                        
            ,dptd_rmks                   REMARKS                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr         settm                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id        
  --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd           in ('906','912')                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,@pa_id                  EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,case when dptd_trastm_cd = '906' THEN 'R' ELSE 'I' end STATUS                        
            ,dptd_rmks                   REMARKS                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
           --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr         settm                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_dtls_id   = @pa_values                        
      AND    dptd_trastm_cd           IN ('906','912')                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'DELOUT_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)   dptd_qty                        
           ,dptd_id                        
    FROM    dptd_mak                    dptd                         
    WHERE   dptd_dtls_id              = @pa_id                        
    AND     dptd_deleted_ind          IN (0,6,-1)                        
    AND    dptd_trastm_cd           in ('906','912')       
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                        
  --                        
  END                        
 ELSE IF @pa_action = 'DELOUT_DP_TRX_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,'0' dptd_deleted_ind                            
          ,dptd_rmks                   REMARKS                        
          --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
          -- when dptd_deleted_ind = -1 then dptd_created_by end chk                        
                                       ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD and dptdm.DPTD_EXECUTION_DT = 
  
    
      
      
        
          
            
              
                
                   
                   
                      
dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
        ,''                    QUANTITY                        
    FROM   dptd_mak                    dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                         
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    --AND    dpm_excsm_id          = CONVERT(INT,@pa_cd)                        
    AND    dptd_deleted_ind         IN (0,4,6,-1)                        
    AND    dptd_lst_upd_by           <> @pa_login_name                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'CDSL_DP_TRX_SEL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no       ACCOUNTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id    DTLSID                         
          ,case when dptd_trastm_cd = '906' THEN 'R' ELSE 'I' end STATUS                        
    FROM   dp_trx_dtls                 dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                 
  END                        
  IF @pa_action = 'CDSL_DP_TRX_SEL_DTLS'             
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)                           
           ,dptd_id                        
    FROM    dp_trx_dtls                 dptd                         
    WHERE   dptd_dtls_id              = @pa_id                        
    AND     dptd_deleted_ind          = 1                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
   --                        
  END                        
  ELSE IF @pa_action = 'CDSL_DP_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,@pa_id                   EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,case when dptd_trastm_cd = '906' THEN 'R' ELSE 'I' end STATUS                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr         settm                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id   = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id      = dpm.dpm_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
     AND    dptd_trastm_cd           in ('906','912')                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                    DPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,case when dptd_trastm_cd = '906' THEN 'R' ELSE 'I' end STATUS                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,settlement_type_mstr         settm                        
           ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_dtls_id              = @pa_values                        
      AND    dptd_trastm_cd           IN ('906','912')                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'CDSL_DP_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)  dptd_qty                        
           ,dptd_id                        
    FROM    dptd_mak dptd                         
    WHERE   dptd_dtls_id              = @pa_id                        
    AND     dptd_deleted_ind          IN (0,6,-1)                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
                        
       
  --                        
  END                        
  ELSE IF @pa_action = 'CDSL_DP_TRX_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
          ,@pa_id                   EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,'0' dptd_deleted_ind                         
          --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
   -- when dptd_deleted_ind = -1 then dptd_created_by end chk                        
       ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD and dptdm.DPTD_EXECUTION_DT =                  
                    
                       
dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
          ,''                    QUANTITY                        
    FROM   dptd_mak                    dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,settlement_type_mstr        settm                         
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    AND    dptd_deleted_ind         IN (0,4,6,-1)                        
    AND    dptd_lst_upd_by           <> @pa_login_name                        
    AND    dptd_trastm_cd           in ('906','912')                        
    and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'INTERSETM_TRX_SEL'                        
 BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                    DPID                         
          ,accp_value                  CMBPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)          EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm.settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
          ,settm1.settm_desc            TARGETSETLLEMENTTYPE                        
          ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
          ,@pa_id EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_rmks                        
    FROM   dp_trx_dtls                 dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,account_properties          accp                        
          ,settlement_type_mstr        settm                        
          ,settlement_type_mstr        settm1                        
          ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    accp_clisba_id            = dpam.dpam_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    AND    convert(varchar,settm1.settm_id)           = dptd.dptd_other_settlement_type                        
    AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
    --AND    excsm.excsm_id            = @pa_desc                        
    AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
    AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dptd_deleted_ind         = 1                        
    AND    dptd_trastm_cd           in ('907')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
  ELSE IF @pa_action = 'INTERSETM_TRX_SEL_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)   dptd_qty                        
           ,dptd_id                        
    FROM    dp_trx_dtls                 dptd                         
    WHERE   dptd_dtls_id              = @pa_id                        
    AND     dptd_deleted_ind          = 1                        
    AND    dptd_trastm_cd           in ('907')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
  END                        
  ELSE IF @pa_action = 'INTERSETM_TRX_SELM'                        
  BEGIN                        
  --                        
    IF @PA_VALUES = ''                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                    DPID                         
            ,accp_value                  CMBPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm.settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no      SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm1.settm_desc            TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
      FROM   dptd_mak                    dptd                         
--,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
   --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,account_properties          accp                        
            ,settlement_type_mstr        settm                        
        ,settlement_type_mstr        settm1                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      AND    accp_clisba_id            = dpam.dpam_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      AND    convert(varchar,settm1.settm_id)          = dptd.dptd_other_settlement_type                        
      AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
      --AND    excsm.excsm_id            = @pa_desc                        
      AND    convert(varchar,dptd.dptd_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptd.dptd_request_dt,103) else @pa_cd end                        
      AND    dptd.dptd_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd           in ('907')                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct @l_dpm_dpid                    DPID                         
            ,accp_value                  CMBPID                         
            ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
            ,dptd_slip_no                SLIPNO                         
            ,settm.settm_desc                  MARKETTYPE                        
            ,dptd_settlement_no          SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,settm1.settm_desc            TARGETSETLLEMENTTYPE                        
            ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
            ,@pa_id                    EXCHANGEID                        
            ,dptd_dtls_id                DTLSID                         
            ,dptd_rmks                        
      FROM   dptd_mak                    dptd                         
            --,dp_mstr                     dpm                         
            --,dp_acct_mstr                dpam                          
            --,exch_seg_mstr               excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,account_properties accp                        
            ,settlement_type_mstr        settm                        
            ,settlement_type_mstr        settm1                        
            ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
      WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
 --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id             
      AND    accp_clisba_id            = dpam.dpam_id                        
      AND    settm.settm_id            = dptd.dptd_mkt_type                        
      AND    convert(varchar,settm1.settm_id)           = dptd.dptd_other_settlement_type          AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
      AND    DPTD.DPTD_DTLS_ID         = @PA_VALUES                        
      AND    dptd_deleted_ind         IN (0,6,-1)                        
      AND    dptd_trastm_cd in ('907')                        
      and    isnull(dptd_brokerbatch_no,'') = ''                        
    --               
    END                        
  --                        
  END                        
  ELSE IF @pa_action = 'INTERSETM_TRX_SELM_DTLS'                        
  BEGIN                        
  --                        
    SELECT  dptd_isin                        
           ,abs(dptd_qty)  dptd_qty                        
           ,dptd_id                        
    FROM    dptd_mak                    dptd                         
    WHERE   dptd_dtls_id      = @pa_id                        
    AND     dptd_deleted_ind          IN (0,6,-1)                        
    AND    dptd_trastm_cd           in ('907')                        
    and    isnull(dptd_brokerbatch_no,'') = ''                        
order by dptd_id                        
    --                        
  END                        
  ELSE IF @pa_action = 'INTERSETM_TRX_SELC'                        
  BEGIN                        
  --                        
    SELECT distinct @l_dpm_dpid                    DPID                         
          ,accp_value                  CMBPID                         
          ,convert(varchar,dptd_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptd_execution_dt,103)           EXECUTIONDATE                        
          ,dptd_slip_no                SLIPNO                         
          ,settm.settm_desc                  MARKETTYPE                        
          ,dptd_settlement_no          SETTLEMENTNO                        
          ,dpam_sba_no                ACCOUNTNO                        
          ,settm1.settm_desc            TARGETSETLLEMENTTYPE                        
          ,dptd_other_settlement_no    TRAGETSETTLEMENTNO                        
          ,@pa_id                    EXCHANGEID                        
          ,dptd_dtls_id                DTLSID                         
          ,dptd_rmks                        
          ,'0' dptd_deleted_ind                         
          --,case when dptd_deleted_ind in (0,4,6) then case when isnull(dptd_mid_chk,'') = '' then  'NOT APPLICABLE'  else isnull(dptd_mid_chk,'')  end                        
          -- when dptd_deleted_ind = -1 then dptd_created_by end chk                        
                                        ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptd_mak dptdm where dptdm.dptd_slip_no = dptd.dptd_slip_no  and  dptdm.DPTD_TRASTM_CD = dptd.DPTD_TRASTM_CD and dptdm.DPTD_EXECUTION_DT =
  
                     
dptd.DPTD_EXECUTION_DT and (dptd_deleted_ind = -1 or isnull(ltrim(rtrim(dptd_mid_chk)),'') <> '' ) ),'NO')                        
        ,''                    QUANTITY                        
    FROM   dptd_mak                    dptd                         
          --,dp_mstr                     dpm                         
          --,dp_acct_mstr                dpam                          
          --,exch_seg_mstr               excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,account_properties          accp                        
          ,settlement_type_mstr        settm                        
          ,settlement_type_mstr        settm1                        
    ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
    WHERE  dpam.dpam_id              = dptd.dptd_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    accp_clisba_id            = dpam.dpam_id                        
    AND    settm.settm_id            = dptd.dptd_mkt_type                        
    AND    convert(varchar,settm1.settm_id)          = dptd.dptd_other_settlement_type                        
    AND    accp.accp_accpm_prop_cd   = 'CMBP_ID'                        
    --AND    dpm_excsm_id              = CONVERT(INT,@pa_cd)                        
    AND    dptd_deleted_ind    IN (0,4,6,-1)                        
    AND    dptd_lst_upd_by           <>@pa_login_name                        
    AND    dptd_trastm_cd           in ('907')                        
    and    @pa_login_name <> case when (dptd_deleted_ind  = 0 and isnull(dptd_mid_chk,'') <> '') then isnull(dptd_mid_chk,'') else dptd_lst_upd_by        end                           
    and    isnull(dptd_brokerbatch_no,'') = ''                        
  --                        
  END                        
                         
  ELSE IF @pa_action = 'OFFM_TRX_SEL_CDSL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no            SLIPNO                         
          ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                     CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                     EXCHANGEID                        
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                           
          ,dptdc_rmks                        
          ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD           
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO           
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE          
          ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end  as Targetsettype             --   ,dptdc_created_by Makerid                         
--,dptdc_id       
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dp_trx_dtls_cdsl             dptdc                         
  left outer join                          
           settlement_type_mstr          settm1                          
                                
           on (convert(varchar,settm1.settm_id          )  = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id            ) = dptdc.dptdc_other_settlement_type)             
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id           
    AND    dptdc_deleted_ind         = 1                        
    AND    convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
--AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
    AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptdc_deleted_ind         = 1                        
    AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM','ID')                                 
    AND    dptdc_internal_trastm            = @rowdelimiter      
    and    isnull(dptdc_brokerbatch_no,'') = ''                 
  --                        
  END                        
  ELSE IF @pa_action = 'OFFM_TRX_SELC_CDSL'                        
  BEGIN                        
  --                       
IF LTRIM(RTRIM(@ColDelimiter))='S'
BEGIN

if (@pa_cd='--ALL--')
BEGIN 

SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval 
from

(
    SELECT distinct  
          --@l_dpm_dpid                                DPID                         
          dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,DPM_EXCSM_ID  DEPOSITORY -- @pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          ,dptdc_created_by Makerid              
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         

    FROM   --citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm                         
          ,dp_acct_mstr                 dpam                          
          ,exch_seg_mstr                excsm                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc          
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    --AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name 
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name                
    and    DPTDC_CREATED_BY <> @pa_login_name                
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name   
	
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
    and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = '' --  and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO  IN (SELECT SLIP_NO FROM MAKER_SCANCOPY)
    and    isnull(dptdc_res_desc,'')        = ''
	and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'

) t

group by DPID                       
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   


END
ELSE --- AS IT IS FOR ELSE ALL
BEGIN 
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval 
from

(
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          ,dptdc_created_by Makerid              
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))

    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc          
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id                  = excsm.excsm_id                      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    --AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name 
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name                
    and    DPTDC_CREATED_BY <> @pa_login_name    
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                            
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
	and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = '' --  and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO  IN (SELECT SLIP_NO FROM MAKER_SCANCOPY)
	and    isnull(dptdc_res_desc,'')        = ''
	and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'

) t

group by DPID                       
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   


END -- ALL

END 

ELSE if LTRIM(RTRIM(@ColDelimiter))='WS'
BEGIN -- WITH OUT SCAN

if (@pa_cd='--ALL--')
BEGIN 

SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval 
from

(

 SELECT distinct  
--@l_dpm_dpid                                DPID                         
dpm_dpid DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,DPM_EXCSM_ID DEPOSITORY --@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          ,dptdc_created_by Makerid              
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         

    FROM   --citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm                         
          ,dp_acct_mstr                 dpam                          
          ,exch_seg_mstr                excsm                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc          
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
   -- AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name    
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name   
     and    DPTDC_CREATED_BY <> @pa_login_name                 
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                         
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
 and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''   --and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO NOT IN (SELECT SLIP_NO FROM MAKER_SCANCOPY)
and    isnull(dptdc_res_desc,'')        = ''
and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   

end 

ELSE -- AS IT IS FOR ALL
BEGIN 

SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(highval) highval 
from

(

 SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          ,dptdc_created_by Makerid              
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         

    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc          
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id                  = excsm.excsm_id                      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
   -- AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name  
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name 
     and    DPTDC_CREATED_BY <> @pa_login_name                   
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                           
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
 and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end        
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''   --and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                         
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)         
    AND DPTDC_SLIP_NO NOT IN (SELECT SLIP_NO FROM MAKER_SCANCOPY)
and    isnull(dptdc_res_desc,'')        = ''
and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid   

END -- ALL
END
ELSE 
BEGIN 

-- new condition for 'ALL'  
if (@pa_cd='--ALL--')
BEGIN 

PRINT '2434343'
print @l_dpm_dpid
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(isnull(highval,0)) highval 
,slip_no
from

(
 SELECT distinct  
          --@l_dpm_dpid                                DPID                         
          dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,DPM_EXCSM_ID                                         DEPOSITORY --@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          ,dptdc_created_by Makerid              
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))
		,isnull(slip_no,'')   slip_no
    FROM   --citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          dp_mstr                      dpm                         
          ,dp_acct_mstr                 dpam                          
          ,exch_seg_mstr                excsm                        
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc          
left outer join maker_scancopy on slip_no = DPTDC_SLIP_NO 
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    AND    dpm_excsm_id                  = excsm.excsm_id                      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
    --AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name    
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name                
    and    DPTDC_CREATED_BY <> @pa_login_name    
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name     	                   
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
    and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end  
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)               
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''    and isnull(dptdc_res_cd,'') ='' 

and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'                      
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid ,slip_no  
order by slip_no desc


END
ELSE
BEGIN -- AS IT IS 
print 'latesh'
SELECT 
distinct DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid              
          ,sum(isnull(highval,0)) highval 
,slip_no
from

(
 SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                         DEPOSITORY                        
          ,dptdc_excm_id                                   EXCHANGEID                    
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                             INTERNAL_CD                         
          ,'0'                                 DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                      
 
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
          --,dptdc_isin                        
          ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end     OTHERSETTLEMENTNO          
          ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
          ,dptdc_created_by Makerid              
          ,highval = convert(numeric,((select top 1 CLOPM_CDSL_RT from closing_last_cdsl where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO like case when @pa_rmks = '' then '%' else @pa_rmks end) * abs(dptdc_qty)))         
		,isnull(slip_no,'')   slip_no
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc          
left outer join maker_scancopy on slip_no = DPTDC_SLIP_NO 
           LEFT OUTER JOIN                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)                            
    WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id                  = excsm.excsm_id                      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
   -- AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name    
    AND    case when dptdc.dptdc_mid_chk <> '' then dptdc.dptdc_mid_chk else dptdc.DPTDC_LST_UPD_BY end  <> @pa_login_name     
    and    DPTDC_CREATED_BY <> @pa_login_name               
	AND    case when dptdc.DPTDC_LST_UPD_BY <> '' then dptdc.DPTDC_LST_UPD_BY  end  <> @pa_login_name                         
    --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
    AND    dptdc_deleted_ind             in (0,4,6,-1)                        
    AND    dptdc_internal_trastm         in ('BOBO','BOCM','CMBO','CMCM','ID','EP','NP')                
    --AND    dptdc_internal_trastm            = @rowdelimiter      
    and    dptdc_slip_no like case when @pa_rmks = '' then '%' else @pa_rmks end         
    and    DPTDC_CREATED_BY like case when @pa_desc = '' then '%'  else @pa_desc end  
    and    dptdc_internal_trastm LIKE (case when LTRIM(RTRIM(@RowDelimiter)) = '' then '%' else LTRIM(RTRIM(@RowDelimiter)) end)               
    and   convert(varchar,DPTDC_REQUEST_DT,103)  = case when @pa_values = '' then convert(varchar,DPTDC_REQUEST_DT,103) else @pa_values end          
  --AND convert(datetime,convert(varchar(11),dptdc_execution_dt,109))    like case when @pa_values = '' then '%'  else @pa_values end                           
    and    isnull(dptdc_brokerbatch_no,'') = ''   and isnull(dptdc_res_cd,'') =''   
and  citrus_usr.fn_chk_app_level_cdsl (0,DPTDC_DTLS_ID,@pa_login_name,DPTDC_REQUEST_DT) = 'Y'                     
) t
group by DPID                         
          ,REQUESTDATE                         
          ,EXECUTIONDATE                        
          ,SLIPNO                         
          ,SETTLEMENT_TYPE                        
          , SETTLEMENTNO                        
          ,ACCOUNTNO                        
          ,TARGERDPID                         
          ,TARGERCMBPID                        
          ,TARGERACCOUNTNO                        
          ,CMID                         
          ,CASH                                            
          ,DEPOSITORY                        
          ,EXCHANGEID                    
          ,DTLSID                        
          ,INTERNAL_CD                         
          ,DELETED_IND                        
          --,abs(dptdc_qty)                                    dptdc_qty                        
          ,chk  
          --,dptdc_isin                        
          ,    OTHERSETTLEMENTNO          
          ,OTHERSETTLEMENTTYPE         
          ,Makerid ,slip_no  
order by slip_no desc

END -- ALL

END

  --                        
  END                       
  ELSE IF @pa_action = 'OFFM_TRX_SELM_CDSL'                        
  BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --             
           PRINT @l_dpm_dpid      
PRINT @l_entm_id      
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
      ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                       
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID      CMID         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                  DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                          
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                         
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
           ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
      ,dptdc_created_by Makerid          
, case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end DPTDC_MKT_TYPE         
,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end           --   ,dptdc_created_by Makerid                         
--,'' dptdc_ID      
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr       excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
             left outer join                          
            settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )            
           left outer join                          
           settlement_type_mstr          settm2                          
            on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind           in (0,4,6,-1)                        
      AND    dptdc_internal_trastm       in ('BOBO','BOCM','CMBO','CMCM','ID')                               
      AND    dptdc_internal_trastm     =  @rowdelimiter     
      and    isnull(dptdc_brokerbatch_no,'') = '' 
--order by dptdc_dtls_id         
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                    
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                         TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                         DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                         
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                          
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD            
            ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end      OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
            , (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]             
,dptdc_created_by Makerid          
          
,case when  DPTDC_MKT_TYPE = '' then DPTDC_OTHER_SETTLEMENT_TYPE  else DPTDC_MKT_TYPE end  DPTDC_MKT_TYPE       
--,'' dptdc_ID        
,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end       
FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr  dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
             left outer join                          
             settlement_type_mstr          settm1                          
   on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                 
             left outer join                          
             settlement_type_mstr          settm2                          
              on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id   = @pa_values                       
      --AND    excsm_list.excsm_id      = excsm.excsm_id                  
      AND    dptdc_deleted_ind         in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('BOBO','BOCM','CMBO','CMCM','ID')                        
      AND    dptdc_internal_trastm            = @rowdelimiter      
      and    isnull(dptdc_brokerbatch_no,'') = ''   
--order by dptdc_dtls_id                    
    --                        
    END                        
  --                        
  END                         
  ELSE IF @pa_action = 'OFFM_TRX_SEL_CDSL_DTLS'                        
  BEGIN                        
  --                        
   SELECT  dptdc_isin                        
     ,abs(dptdc_qty)     dptdc_qty                        
     ,dptdc_id         
    -- ,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO        
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END  DPTDC_TRANS_NO            
, CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'      --do not change  
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        --do not change
                         
             
  --  FROM    dp_trx_dtls_cdsl            dptd                         
    FROM    dptdc_mak                    dptd                         
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind          = 1                         
    AND    dptdc_internal_trastm       = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''  order by dptdc_id           
  END                       
  ELSE IF @pa_action = 'OFFM_TRX_SELM_CDSL_DTLS'                        
 BEGIN                        
  --  
      
    SELECT  dptdc_isin                        
          ,abs(dptdc_qty)     dptdc_qty                        
           ,dptdc_id         
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END  DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS                       
    , CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE' 
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'          
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        

    FROM dptdc_mak                   dptdc                         
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind          in (0,4,6,-1)                        
    AND     dptdc_internal_trastm       = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''   order by dptdc_id   
                    
  --                        
  END               
  ELSE IF @pa_action = 'INTERDP_TRX_SEL_CDSL'                        
    BEGIN                        
    --                        
     SELECT distinct  @l_dpm_dpid   DPID                         
     ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
     ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
     ,dptdc_slip_no                                     SLIPNO                         
     ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
     ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                       
     ,dpam_sba_no                                      ACCOUNTNO                        
     ,dptdc_counter_dp_id                    TARGERDPID                         
     ,dptdc_counter_cmbp_id                             TARGERCMBPID               
     ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
     ,DPTDC_CM_ID                                       CMID             
     ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                         
     ,@pa_id                                         DEPOSITORY                        
     ,dptdc_excm_id                                     EXCHANGEID                        
     ,dptdc_dtls_id                                     DTLSID                        
     ,dptdc_internal_trastm                           
     ,dptdc_rmks                        
     ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                 
     ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end       OTHERSETTLEMENTNO             
     ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
      ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]         
  ,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
, case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end                         
--,dptdc_id       
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr          excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dp_trx_dtls_cdsl             dptdc                         
           left outer join                          
           settlement_type_mstr          settm1                          
           on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                    
           left outer join                          
           settlement_type_mstr          settm2                          
           on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)              
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id          = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id        = dpm.dpm_id                        
    --AND    excsm.excsm_id          = @pa_id                        
    --AND    excsm_list.excsm_id     = excsm.excsm_id                        
    AND    dptdc_deleted_ind         = 1                        
    AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
    --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
    AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no            LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptdc_deleted_ind         = 1                        
    AND    dptdc_internal_trastm    in ('ID')        
    AND    dptdc_internal_trastm            = @rowdelimiter                         
    and    isnull(dptdc_brokerbatch_no,'') = ''                        
    --                        
    END                        
    ELSE IF @pa_action = 'INTERDP_TRX_SELC_CDSL'                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm1.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no                ACCOUNTNO                        
            ,''  TARGERDPID --dptdc_counter_dp_id                                                        
            ,'' TARGERCMBPID --dptdc_counter_cmbp_id                                            
            ,'' TARGERACCOUNTNO --dptdc_counter_demat_acct_no                                               
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                         DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id           DTLSID                        
            ,dptdc_internal_trastm                             INTERNAL_CD                         
            ,dptdc_deleted_ind                                 DELETED_IND                        
           -- ,abs(dptdc_qty)                                    dptdc_qty                        
            --,dptdc_isin                        
            ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                    
  
   
             dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
            ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
            ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE           
          ,highval = ((select top 1 CLOPM_CDSL_RT from closing_last_cdsl,dptdc_mak where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO = @pa_rmks) * abs(dptdc_qty))         
      
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
             left outer join                          
             settlement_type_mstr          settm1                          
             on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                   
             left outer join                          
             settlement_type_mstr          settm2                          
             on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)              
      WHERE  dpam.dpam_id                  = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id                  = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id              = dpm.dpm_id                        
      AND    dptdc.dptdc_lst_upd_by        <> @pa_login_name                        
      --AND    dpm_excsm_id                  = convert(int,@pa_cd)                        
      AND    dptdc_deleted_ind             in (0,4,6,-1)                        
      AND    dptdc_internal_trastm         in ('ID')        
      and    isnull(dptdc_res_desc,'')        = ''
      AND    dptdc_internal_trastm            = @rowdelimiter                               
      and    isnull(dptdc_brokerbatch_no,'') = ''      and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                    
    --                        
    END                        
    ELSE IF @pa_action = 'INTERDP_TRX_SELM_CDSL'                        
    BEGIN                        
    --                        
      IF @pa_values = ''                        
      BEGIN                        
      --                     
select  @pa_cd = citrus_usr.fn_splitval(@pa_cd,1)

        SELECT distinct  @l_dpm_dpid                                DPID                         
              ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
              ,dptdc_slip_no                                     SLIPNO                         
              ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
              ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
              ,dpam_sba_no        ACCOUNTNO                        
              ,dptdc_counter_dp_id                               TARGERDPID                         
              ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
              ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
              ,DPTDC_CM_ID                                       CMID                         
              ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
              ,@pa_id                                          DEPOSITORY                        
              ,dptdc_excm_id                                     EXCHANGEID                                    ,dptdc_dtls_id                                     DTLSID                        
              ,dptdc_internal_trastm                          
              ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                      
                                     
              ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
              ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end      OTHERSETTLEMENTNO             
              ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
             ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]        
			,dptdc_created_by Makerid          
			,DPTDC_MKT_TYPE         
			--,dptdc_ID               
			 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end         FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
              --,dp_mstr                      dpm                        
              --,dp_acct_mstr                 dpam                          
              --,exch_seg_mstr                excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptdc_mak                    dptdc                         
               left outer join                          
                settlement_type_mstr          settm1                                    on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )             
               left outer join                          
               settlement_type_mstr          settm2                          
               on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)            
            
        WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
        --AND    dpm_excsm_id              = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
        --AND    excsm_list.excsm_id      = excsm.excsm_id                        
        --AND    excsm.excsm_id            = @pa_id                        
        AND     convert(varchar,dptdc.dptdc_request_dt,103) LIKE CASE WHEN ISNULL(@pa_cd,'') = '%' then  convert(varchar,dptdc.dptdc_request_dt,103) else case when @pa_cd = '' then '%' else @pa_cd end end              
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
        AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
        AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
        AND    dptdc_deleted_ind         in (0,4,6,-1)                        
        AND    dptdc_internal_trastm            in ('ID')       
        AND    dptdc_internal_trastm            = @rowdelimiter                              
        and    isnull(dptdc_brokerbatch_no,'') = ''    
		--order by dptdc_dtls_id                      
      --                        
      END                        
      ELSE                        
      BEGIN                        
      --                        
select  @pa_cd = citrus_usr.fn_splitval(@pa_cd,1)

        SELECT distinct  @l_dpm_dpid                                DPID                         
              ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
              ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
              ,dptdc_slip_no                 SLIPNO                         
              ,CASE WHEN dptdc_settlement_no = '' then settm2.settm_desc else settm1.settm_desc end SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
              ,dpam_sba_no                                      ACCOUNTNO                        
              ,dptdc_counter_dp_id                               TARGERDPID                         
              ,dptdc_counter_cmbp_id               TARGERCMBPID                        
              ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                    ,DPTDC_CM_ID                                       CMID                         
              ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
              ,@pa_id                                         DEPOSITORY                        
              ,dptdc_excm_id                                     EXCHANGEID                        
              ,dptdc_dtls_id                                     DTLSID                        
              ,dptdc_internal_trastm                         
              ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                       
--              ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD          
--              ,isnull(dptdc_other_settlement_no,'')       OTHERSETTLEMENTNO             
--              ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE                
                ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
               ,case when dptdc_settlement_no = '' then '' else isnull(dptdc_other_settlement_no,'') end        OTHERSETTLEMENTNO             
               ,isnull(settm2.settm_desc,'')               OTHERSETTLEMENTTYPE         
               ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]          
,dptdc_created_by Makerid          
,DPTDC_MKT_TYPE         
--,dptdc_ID      
 ,case when  DPTDC_MKT_TYPE = '' then DPTDC_MKT_TYPE else DPTDC_OTHER_SETTLEMENT_TYPE end         
FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
              --,dp_mstr                      dpm                         
              --,dp_acct_mstr                 dpam                          
              --,exch_seg_mstr                excsm                        
              --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
              ,dptdc_mak                    dptdc                         
               left outer join                          
              settlement_type_mstr          settm1                          
              on (convert(varchar,settm1.settm_id)            = dptdc.dptdc_mkt_type     )                     
               left outer join                          
               settlement_type_mstr          settm2                          
                on (convert(varchar,settm2.settm_id)            = dptdc.dptdc_other_settlement_type)             
            
        WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
        --AND    dpm_excsm_id            = excsm.excsm_id                        
        --AND    dpam.dpam_dpm_id        = dpm.dpm_id                        
        AND    dptdc_dtls_id             = @pa_values                        
        --AND    excsm_list.excsm_id     = excsm.excsm_id                        
        AND    dptdc_deleted_ind         in (0,4,6,-1)                        
        AND    dptdc_internal_trastm            in ('ID')       
        AND    dptdc_internal_trastm            = @rowdelimiter                       
        and    isnull(dptdc_brokerbatch_no,'') = ''     
		order by dptdc_dtls_id                     
      --                        
      END                        
    --                        
    END         
    ELSE IF @pa_action = 'INTERDP_TRX_SEL_CDSL_DTLS'                        
   BEGIN                        
    --                        
      SELECT  dptdc_isin                        
       ,abs(dptdc_qty)     dptdc_qty                        
       ,dptdc_id         
       --,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO           
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END  DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' 
--AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS      
, CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'  
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'          
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        
 
                   
      --FROM    dp_trx_dtls_cdsl            dptd                         
	 FROM    dptdc_mak            dptd                         
      WHERE   dptdc_dtls_id              = @pa_id                        
      AND     dptdc_deleted_ind          = 1                         
      AND    dptdc_internal_trastm       = @pa_cd                          
      and    isnull(dptdc_brokerbatch_no,'') = ''    order by dptdc_id        
           
      --                        
      END                       
    ELSE IF @pa_action = 'INTERDP_TRX_SELM_CDSL_DTLS'                        
    BEGIN                        
    --                        
      SELECT  dptdc_isin                        
             ,abs(dptdc_qty)     dptdc_qty                        
             ,dptdc_id          
            --,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO           
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END  DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS        
    , CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'    
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'       
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        
                     
              
      FROM    dptdc_mak                 dptdc                         
      WHERE   dptdc_dtls_id              = @pa_id                        
      AND     dptdc_deleted_ind          in (0,4,6,-1)                        
      AND     dptdc_internal_trastm       = @pa_cd                          
      and    isnull(dptdc_brokerbatch_no,'') = ''   order by dptdc_id     
    --                        
      END                        
  ELSE IF @pa_action = 'ONM_TRX_SEL_CDSL'                     
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no       SLIPNO                         
          ,settm.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                          DEPOSITORY                        
          ,dptdc_excm_id                              EXCHANGEID                        
          ,dptdc_dtls_id                                     DTLSID                        
          ,dptdc_internal_trastm                         
          ,dptdc_rmks                        
          ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD         
             ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE               
          ,(Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)[TARGERDPNAME]        
  -- ,dptdc_id                           
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dp_trx_dtls_cdsl             dptdc                         
           left outer join                          
        settlement_type_mstr          settm                          
           on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                
  
    
      
      
        
                                   
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id ONM_TRX_SELM_CDSL            = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    excsm.excsm_id            = @pa_id                        
    AND    dptdc_deleted_ind         = 1                        
    AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
    --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
    AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
    AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
    AND    dptdc_deleted_ind = 1                        
    AND    dptdc_internal_trastm            in ('EP','NP')                          
    AND    dptdc_internal_trastm            = @rowdelimiter      
    and    isnull(dptdc_brokerbatch_no,'') = ''                        
                             --                        
  END                         
  ELSE IF @pa_action = 'ONM_TRX_SELC_CDSL'                        
  BEGIN                        
  --                        
    SELECT distinct  @l_dpm_dpid                                DPID                         
          ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
          ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
          ,dptdc_slip_no                                     SLIPNO                         
          ,settm.settm_desc                                  SETTLEMENT_TYPE                        
          ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
          ,dpam_sba_no                                      ACCOUNTNO                        
          ,dptdc_counter_dp_id                               TARGERDPID                         
          ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
          ,dptdc_counter_demat_acct_no               TARGERACCOUNTNO                        
          ,DPTDC_CM_ID                                       CMID                         
          ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
          ,@pa_id                                        DEPOSITORY                        
          ,dptdc_excm_id                                     EXCHANGEID                        
          ,dptdc_dtls_id                                     DTLSID                      
          ,dptdc_deleted_ind                                    
          --,abs(dptdc_qty)                                   dptdc_qty                        
          --,dptdc_isin                        
          ,chk = isnull((select case when count(*) >= 1 then 'YES' else 'NO' end from dptdc_mak dptdm where dptdm.dptdc_slip_no = dptdc.dptdc_slip_no  and  dptdm.DPTDc_TRASTM_CD = dptdc.DPTDc_TRASTM_CD and dptdm.DPTDc_EXECUTION_DT =                       
           dptdc.DPTDc_EXECUTION_DT and (dptdc_deleted_ind = -1 or isnull(ltrim(rtrim(dptdc_mid_chk)),'') <> '' ) ),'NO')                        
  ,highval = ((select top 1 CLOPM_CDSL_RT from closing_last_cdsl,dptdc_mak where  CLOPM_ISIN_CD = dptdc_isin and DPTDC_SLIP_NO = @pa_rmks) * abs(dptdc_qty))         
      
    FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
          --,dp_mstr                      dpm                         
          --,dp_acct_mstr                 dpam                          
          --,exch_seg_mstr                excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,dptdc_mak                    dptdc                         
left outer join                          
           settlement_type_mstr          settm                          
           on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                 
  
    
      
      
       
    WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
    --AND    dpm_excsm_id              = excsm.excsm_id                        
    --AND    excsm_list.excsm_id      = excsm.excsm_id                        
    --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
    AND    dptdc_deleted_ind         in (0,4,6,-1)                        
    AND    dptdc_internal_trastm            in ('EP','NP')                          
    AND    dptdc_internal_trastm            = @rowdelimiter      
    and    isnull(dptdc_brokerbatch_no,'') = ''    and isnull(dptdc_res_cd,'') like case when @pa_desc = '' then '%' else @pa_desc end                      
  --                        
  END                        
  ELSE IF @pa_action = 'ONM_TRX_SELM_CDSL'                        
 BEGIN                        
  --                        
    IF @pa_values = ''                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no                                      ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID                         
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                          DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm        
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                          
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                         
            ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE                                     
            ,[TARGERDPNAME] = (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)                                        ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD                        
,dptdc_created_by Makerid        
--,dptdc_ID 
,DPTDC_MKT_TYPE     
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
  --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
             left outer join                          
             settlement_type_mstr          settm                          
             on (settm.settm_id            = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)               
  
    
      
      
       
          
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
  --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    excsm.excsm_id            = @pa_id                        
      AND     convert(varchar,dptdc.dptdc_request_dt,103)      LIKE CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end                        
      --AND     convert(varchar,dptdc.dptdc_request_dt,103) between CASE WHEN ISNULL(@pa_cd,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @pa_cd end  and  CASE WHEN ISNULL(@coldelimiter,'') = '' then  convert(varchar,dptdc.dptdc_request_dt,103) else @coldelimiter end                       
      AND    dptdc.dptdc_slip_no         LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
      AND    dpam.dpam_sba_no           LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END                        
      AND    dptdc_deleted_ind        in (0,4,6,-1)                        
      AND    dptdc_internal_trastm            in ('EP','NP')       
      AND   dptdc_internal_trastm            = @rowdelimiter                         
      and isnull(dptdc_brokerbatch_no,'') = ''     
  --order by dptdc_dtls_id                   
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT distinct  @l_dpm_dpid                                DPID                         
            ,convert(varchar,dptdc_request_dt,103)             REQUESTDATE                         
            ,convert(varchar,dptdc_execution_dt,103)           EXECUTIONDATE                        
            ,dptdc_slip_no                                     SLIPNO                         
            ,settm.settm_desc                                  SETTLEMENT_TYPE                        
            ,case when dptdc_settlement_no = '' then dptdc_other_settlement_no else dptdc_settlement_no end SETTLEMENTNO                        
            ,dpam_sba_no          ACCOUNTNO                        
            ,dptdc_counter_dp_id                               TARGERDPID             
            ,dptdc_counter_cmbp_id                             TARGERCMBPID                        
            ,dptdc_counter_demat_acct_no                       TARGERACCOUNTNO                        
            ,DPTDC_CM_ID                                       CMID                         
            ,case when DPTDC_CASH_TRF ='X'  then 'NA' else  DPTDC_CASH_TRF  end CASH                                            
            ,@pa_id                                          DEPOSITORY                        
            ,dptdc_excm_id                                     EXCHANGEID                        
            ,dptdc_dtls_id                                     DTLSID                        
            ,dptdc_internal_trastm                         
            ,isnull(dptdc_rmks,'') + isnull(DPTDC_RES_desc,'')  dptdc_rmks                         
            ,isnull(DPTDC_REASON_CD,0) DPTDC_REASON_CD        
              ,''      OTHERSETTLEMENTNO           
           ,''          OTHERSETTLEMENTTYPE                                     
            ,[TARGERDPNAME] = (Select DPM_NAME from dp_mstr where DPM_DPID = dptdc_counter_dp_id)                            
,dptdc_created_by Makerid        
--,dptdc_ID    
,DPTDC_MKT_TYPE     
      FROM   citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
            --,dp_mstr                      dpm                         
            --,dp_acct_mstr                 dpam                          
            --,exch_seg_mstr                excsm                        
            --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
            ,dptdc_mak                    dptdc                         
             left outer join                          
             settlement_type_mstr          settm                          
             on (settm.settm_id       = case when dptdc.dptdc_mkt_type = ''  then  0  else dptdc.dptdc_mkt_type end or settm.settm_id = case when dptdc.dptdc_other_settlement_type = '' then 0 else dptdc.dptdc_other_settlement_type end)                   
   
   
     
      
      
      WHERE  dpam.dpam_id              = dptdc.dptdc_dpam_id                        
      --AND    dpm_excsm_id              = excsm.excsm_id                        
      --AND    excsm_list.excsm_id      = excsm.excsm_id                        
      --AND    dpam.dpam_dpm_id          = dpm.dpm_id                        
      AND    dptdc_dtls_id             = @pa_values                        
      AND   dptdc_deleted_ind           in (0,4,6,-1)                        
      AND    dptdc_internal_trastm        in ('EP','NP')         
      AND    dptdc_internal_trastm            = @rowdelimiter                      
      and    isnull(dptdc_brokerbatch_no,'') = ''                        
	--order by dptdc_dtls_id  
    --                        
    END                   
  --                        
  END          
                          
  ELSE IF @pa_action = 'ONM_TRX_SEL_CDSL_DTLS'                        
   BEGIN            --                        
     SELECT  dptdc_isin                        
           ,abs(dptdc_qty)      dptdc_qty             
           ,dptdc_id         
        --   ,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO            
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END  DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS        
, CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE' 
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'           
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        

               
    --FROM    dp_trx_dtls_cdsl                    dptdc                        
    from dptdc_mak			dptdc
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind          = 1                        
    AND     dptdc_internal_trastm       = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''        
    order by dptdc_id                      
    --                        
  END                        
  ELSE IF @pa_action = 'ONM_TRX_SELM_CDSL_DTLS'                        
   BEGIN                        
  --                        
   SELECT  dptdc_isin                        
           ,abs(dptdc_qty)               dptdc_qty                        
           ,dptdc_id          
         --  ,ISNULL(DPTDC_TRANS_NO,'')  DPTDC_TRANS_NO            
 ,CASE WHEN ISNULL(DPTDC_TRANS_NO,'')='' THEN DPTDC_INTERNAL_REF_NO ELSE ISNULL(DPTDC_TRANS_NO,'') END  DPTDC_TRANS_NO            
--,CASE WHEN DPTDC_DELETED_IND IN (0,6,-1)  THEN 'MAKER ENTERED'        
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
--  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
--  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER APPROVED' END  STATUS        
   , CASE WHEN DPTDC_DELETED_IND IN (0,6,-1) AND DPTDC_CREATED_BY = DPTDC_LST_UPD_BY  THEN 'MAKER ENTERED' 
  WHEN DPTDC_DELETED_IND = 0  AND DPTDC_CREATED_BY <> DPTDC_LST_UPD_BY AND ISNULL(dptdc_res_cd,'')  = '' THEN '1ST CHECKER DONE'   
  WHEN DPTDC_DELETED_IND  = 0 AND ISNULL(dptdc_res_cd,'')  <> '' THEN 'REJECTED'        
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') <> ''  THEN 'BATCH UPLOADED'         
  WHEN ISNULL(DPTDC_BATCH_NO,'') <> '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'BATCH GENERATED'        
  WHEN DPTDC_DELETED_IND = 1 AND ISNULL(DPTDC_BATCH_NO,'') = '' AND ISNULL(DPTDC_TRANS_NO,'') =  ''  THEN 'CHECKER DONE' END  STATUS        
                      
                     
    FROM    dptdc_mak                    dptdc                         
    WHERE   dptdc_dtls_id              = @pa_id                        
    AND     dptdc_deleted_ind            IN (0,4,6,-1)                        
    AND     dptdc_internal_trastm    = @pa_cd                          
    and    isnull(dptdc_brokerbatch_no,'') = ''           
    order by dptdc_id                    
  --                        
  END                        
  end                  
                  
IF @pa_action ='FRZUFRZ_SEL'                
  BEGIN                
  --                
  if len(@pa_rmks) = 2 
	set @pa_rmks =''
	
  IF @pa_desc <> ''                
  BEGIN                
  --     
    PRINT 'YOGESH'
  SELECT distinct dpm.dpm_excsm_id      Depository                
  ,isnull(dpam.dpam_sba_no,'') AcctNo                
  ,ISNULL(fre_isin_code,'')     ISIN                
  ,fre_qty    Qty                 
  ,CASE WHEN  fre_action = 'F' THEN 'FREEZE' END        FrzAction                
  ,CASE WHEN  fre_type   = 'D' THEN 'Susp. for Debit' ELSE case when fre_type = 'A' THEN 'Susp. for All' else 'Account Closure' End END          FrzType                         
  --,case when  fre_req_int_by ='01' then 'Request by Investor' else case when fre_req_int_by ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
  ,case when  fre_for ='01' then 'Request by Investor' else case when fre_for ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
  ,ISNULL(fre_rmks,'') fre_rmks                 
  ,CONVERT(VARCHAR(11),fre_exec_date,103)   Executiondt                
  ,fre_id     id                 
  FROM   freeze_unfreeze_dtls  frz left outer join dp_acct_mstr      dpam                
         on frz.fre_dpam_id=dpam.dpam_id and   dpam.dpam_deleted_ind =1                
         ,dp_mstr      dpm                 
  WHERE  frz.fre_dpmid=dpm.dpm_id                
  and    dpm.dpm_deleted_ind =1                      
  and    frz.fre_deleted_ind =1                
  and    frz.fre_status='A'                
  and    frz.fre_action = 'F'                
  and    dpm.dpm_dpid = @pa_cd                
  and    dpam.dpam_sba_no = @pa_desc                
  and    frz.fre_isin_code LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                   
  order by fre_id                
  --                
  END                
  ELSE IF @pa_desc =''                
  BEGIN                
  --                
  SELECT distinct dpm.dpm_excsm_id      Depository                
  ,isnull(dpam.dpam_sba_no,'') AcctNo                
  ,isnull(fre_isin_code,'')     ISIN                
  ,fre_qty    Qty                 
  ,CASE WHEN  fre_action = 'F' THEN 'FREEZE' END        FrzAction                
  ,CASE WHEN  fre_type   = 'D' THEN 'Susp. for Debit' ELSE case when fre_type = 'A' THEN 'Susp. for All' else 'Account Closure' End END          FrzType                         
  --,case when  fre_req_int_by ='01' then 'Request by Investor' else case when fre_req_int_by ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
  ,case when  fre_for ='01' then 'Request by Investor' else case when fre_for ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
  ,isnull(fre_rmks,'')  fre_rmks               
  ,CONVERT(VARCHAR(11),fre_exec_date,103)   Executiondt                
  ,fre_id     id                 
  FROM   freeze_unfreeze_dtls  frz left outer join dp_acct_mstr      dpam                
         on frz.fre_dpam_id=dpam.dpam_id and   dpam.dpam_deleted_ind =1                
        ,dp_mstr      dpm                 
  WHERE  frz.fre_dpmid=dpm.dpm_id                
  and    dpm.dpm_deleted_ind =1                      
  and    frz.fre_deleted_ind =1                
  and    frz.fre_status='A'                
  AND    frz.fre_action ='F'                
  and    dpm.dpm_dpid = @pa_cd                
  and    frz.fre_isin_code LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                   
  --                
  END                
END                
                
IF @pa_action ='FRZUFRZ_SELM'                
BEGIN                
  --                
  IF @pa_values <> ''                
  BEGIN                
    --                
   SELECT distinct dpm.dpm_excsm_id      Depository                
   ,isnull(dpam.dpam_sba_no,'') AcctNo                
   ,isnull(fre_isin_cd,'')    ISIN                
   ,fre_qty    Qty                 
   ,CASE WHEN  fre_action = 'F' THEN 'FREEZE'  END        FrzAction                
   ,CASE WHEN  fre_type   = 'D' THEN 'Susp. for Debit' ELSE case when fre_type = 'A' THEN 'Susp. for All' else 'Account Closure' End END          FrzType                         
   --,case when  fre_req_int_by ='01' then 'Request by Investor' else case when fre_req_int_by ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
,case when  fre_for ='01' then 'Request by Investor' else case when fre_for ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
   ,isnull(fre_rmks,'') fre_rmks                
   ,CONVERT(VARCHAR(11),fre_exec_dt,103)   Executiondt                
   ,fre_id     id                 
   FROM   freeze_unfreeze_dtls_mak   frzm  left outer join dp_acct_mstr      dpam                
   on frzm.fre_dpam_id=dpam.dpam_id and   dpam.dpam_deleted_ind =1                
   ,dp_mstr      dpm                 
   WHERE  frzm.fre_dpm_id=dpm.dpm_id                
   AND    dpm.dpm_deleted_ind =1                      
   AND    frzm.fre_status='A'                 
   AND    frzm.fre_action ='F'                
   AND    frzm.fre_id= @pa_values                
   AND    frzm.fre_deleted_ind in (0,6)                
    --                 
  END                
  ELSE                
  BEGIN                
  IF @pa_desc <> ''                
    BEGIN                
    --                
    SELECT distinct dpm.dpm_excsm_id      Depository                
    ,isnull(dpam.dpam_sba_no,'') AcctNo                
    ,isnull(fre_isin_cd,'')    ISIN                
    ,fre_qty    Qty                 
    ,CASE WHEN  fre_action = 'F' THEN 'FREEZE'  END        FrzAction                
    ,CASE WHEN  fre_type   = 'D' THEN 'Susp. for Debit' ELSE case when fre_type = 'A' THEN 'Susp. for All' else 'Account Closure' End END          FrzType                         
    --,case when  fre_req_int_by ='01' then 'Request by Investor' else case when fre_req_int_by ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
,case when  fre_for ='01' then 'Request by Investor' else case when fre_for ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
    ,isnull(fre_rmks,'') fre_rmks                  
    ,CONVERT(VARCHAR(11),fre_exec_dt,103)   Executiondt                
    ,fre_id     id                 
    FROM   freeze_unfreeze_dtls_mak  frz left outer join dp_acct_mstr      dpam                
           on frz.fre_dpam_id=dpam.dpam_id and   dpam.dpam_deleted_ind =1                
           ,dp_mstr      dpm                 
    WHERE  frz.fre_dpm_id=dpm.dpm_id                
    AND    dpm.dpm_deleted_ind =1                      
    AND    frz.fre_deleted_ind in (0,6)                
    AND    frz.fre_status='A'                
    AND    frz.fre_action ='F'                
    and    dpm.dpm_dpid = @pa_cd                
    AND    dpam.dpam_sba_no = @pa_desc                
    AND    frz.fre_isin_cd LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                   
   order by fre_id                
    --                
    END                
    ELSE IF @pa_desc =''                
    BEGIN                
    --                
    SELECT distinct dpm.dpm_excsm_id      Depository                
    ,isnull(dpam.dpam_sba_no,'') AcctNo        ,isnull(fre_isin_cd,'')     ISIN                
    ,fre_qty    Qty                 
    ,CASE WHEN  fre_action = 'F' THEN 'FREEZE'  END        FrzAction                
    ,CASE WHEN  fre_type   = 'D' THEN 'Susp. for Debit' ELSE case when fre_type = 'A' THEN 'Susp. for All' else 'Account Closure' End END          FrzType                         
   -- ,case when  fre_req_int_by ='01' then 'Request by Investor' else case when fre_req_int_by ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
 ,case when  fre_for ='01' then 'Request by Investor' else case when fre_for ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
    ,isnull(fre_rmks,'') fre_rmks                  
    ,CONVERT(VARCHAR(11),fre_exec_dt,103)   Executiondt                
    ,fre_id     id                 
    FROM   freeze_unfreeze_dtls_mak  frz left outer join dp_acct_mstr      dpam                
           on frz.fre_dpam_id=dpam.dpam_id and   dpam.dpam_deleted_ind =1                
          ,dp_mstr      dpm                 
    WHERE  frz.fre_dpm_id=dpm.dpm_id                
    and    dpm.dpm_deleted_ind =1                      
    and    frz.fre_deleted_ind in (0,6)                
    and    frz.fre_status='A'                
    and    frz.fre_action ='F'                 
    and    dpm.dpm_dpid = @pa_cd                
    and    frz.fre_isin_cd LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                   
    --                
  END                
  END                
  --                
END                 
                
IF @pa_action ='FRZUFRZ_SELC'                
BEGIN                
  --                
  SELECT distinct  compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd   Depository                
  ,isnull(dpam.dpam_sba_no,'') AcctNo                
  ,fre_isin_cd     ISIN                
  ,fre_qty    Qty                 
  ,CASE WHEN  fre_action = 'F' THEN 'FREEZE' ELSE 'UNFREEZE'  END       FrzAction                
  ,CASE WHEN  fre_type   = 'D' THEN 'Susp. for Debit' ELSE case when fre_type = 'A' THEN 'Susp. for All' else 'Account Closure' End END          FrzType                         
  --,case when  fre_req_int_by ='01' then 'Request by Investor' else case when fre_req_int_by ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
   ,case when  fre_for ='01' then 'Request by Investor' else case when fre_for ='02' THEN 'Other Reasons' else 'Request by Statutory Authority' end end REQ_INT_BY                    
  ,fre_rmks                  
  ,CONVERT(VARCHAR(11),fre_exec_dt,103)   Executiondt                
  ,fre_deleted_ind                 
  ,fre_id     id                 
  FROM   freeze_unfreeze_dtls_mak  frz left outer join dp_acct_mstr      dpam                
  on frz.fre_dpam_id=dpam.dpam_id and   dpam.dpam_deleted_ind =1                
  ,dp_mstr      dpm                 
  ,company_mstr                       
            ,exch_seg_mstr excsm                
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                
  WHERE  frz.fre_dpm_id=dpm.dpm_id        
  AND    dpm_excsm_id       = excsm.excsm_id                  
  AND    excsm_compm_id     = compm_id                 
  AND    excsm_list.excsm_id      = excsm.excsm_id                
  AND    dpm.dpm_deleted_ind =1                      
  AND    frz.fre_status='A'                
  AND    dpm_excsm_id       = convert(numeric,@pa_cd)            
  AND    frz.fre_deleted_ind in(0,4,6)                
  AND    frz.fre_lst_upd_by <>@pa_login_name                
  --                
END                    
                        
IF @pa_action ='INWSR_SEL'                    
BEGIN                    
--                    
  IF @pa_cd ='NSDL'                  
  BEGIN                  
  --                  
     SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd  Depository                    
            ,dpam.dpam_sba_no    AccountNo                    
            ,ttype.descp          TransactionType                    
            ,INWSR_SLIP_NO        SlipNo                    
            ,CONVERT(VARCHAR(11),INWSR_RECD_DT,103)   ReceivedDate                    
            ,CONVERT(VARCHAR(11),INWSR_EXEC_DT,103)   executionDate                    
            ,INWSR_NO_OF_TRANS                        TotalEntries                    
            ,INWSR_RECEIVED_MODE                      ReceiptMode                    
            ,INWSR_ID            InwardNo                  
            ,INWSR_RMKS     
   ,dpm.dpm_excsm_id     
   ,inwsr_transubtype_cd    
   ,convert(numeric(18,2),inwsr_ufcharge_collected)    
   ,FINA_ACC_NAME   BankName    
   ,inwsr_pay_mode    
   ,inwsr_cheque_no     
   ,inwsr_clibank_accno     
   ,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') CMBPID     
   ,ISNULL(FINA_ACC_ID,'0')    
      FROM INWARD_SLIP_REG inwsr     
   LEFT OUTER JOIN FIN_ACCOUNT_MSTR ON    FINA_ACC_ID = INWSR_BANKID AND    FINA_DELETED_IND = 1                    
           ,  dp_acct_mstr     dpam                     
           ,  dp_mstr dpm                     
           , citrus_usr.FN_Fetch_inward_types_NSDL() ttype                   
           , company_mstr                           
           , exch_seg_mstr excsm                    
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                    
      WHERE inwsr.inwsr_dpam_id = dpam.dpam_id             
      AND    inwsr.inwsr_dpm_id = dpm.dpm_id                    
      AND     inwsr.inwsr_trastm_cd = ttype.cd     
   AND    dpm_excsm_id       = excsm.excsm_id                      
      AND     excsm_compm_id     = compm_id                     
      AND    excsm_list.excsm_id      = excsm.excsm_id                    
      AND    dpm.dpm_deleted_ind =1                          
      AND    INWSR.INWSR_deleted_ind =1                    
      AND    dpam.dpam_deleted_ind =1      
      AND    dpm.dpm_excsm_id  = CONVERT(NUMERIC,@pa_id)                    
      AND    inwsr.inwsr_trastm_cd = CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN ttype.cd ELSE  @pa_desc END                     
      AND    INWSR_SLIP_NO LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks))     = '' THEN '%' ELSE @pa_rmks  END                    
      AND    INWSR.INWSR_RECD_DT   LIKE CASE WHEN ISNULL(@pa_values,'') = '' then INWSR.INWSR_RECD_DT else convert(datetime,@pa_values,103) end                    
                         
  --                  
  END                  
  ELSE IF @pa_cd ='CDSL'                  
  BEGIN                  
  --                  
    -- SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd  Depository                    
    --             ,dpam.dpam_sba_no    AccountNo                    
    --             ,ttype.descp          TransactionType                    
    --             ,INWSR_SLIP_NO        SlipNo                    
    --             ,CONVERT(VARCHAR(11),INWSR_RECD_DT,103)   ReceivedDate                    
    --             ,CONVERT(VARCHAR(11),INWSR_EXEC_DT,103)   executionDate                    
    --             ,INWSR_NO_OF_TRANS                        TotalEntries                    
    --             ,INWSR_RECEIVED_MODE                      ReceiptMode                   
    --             ,INWSR_ID            InwardNo                  
    --             ,INWSR_RMKS      
    -- ,dpm.dpm_excsm_id      
    -- ,inwsr_transubtype_cd    
    -- ,convert(numeric(18,2),inwsr_ufcharge_collected)                    
    --             ,FINA_ACC_NAME   BankName    
    --,inwsr_pay_mode    
    --,inwsr_cheque_no     
    --,inwsr_clibank_accno     
    --,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') CMBPID     
    --,ISNULL(FINA_ACC_ID,'0')    
    SELECT DISTINCT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd  Depository                  
            ,dpam.dpam_sba_no    AccountNo                  
            , ttype.descp  TransactionType                  
            ,INWSR_SLIP_NO        SlipNo                  
            ,CONVERT(VARCHAR(11),INWSR_RECD_DT,103)   ReceivedDate                  
            ,CONVERT(VARCHAR(11),INWSR_EXEC_DT,103)   executionDate                  
            ,INWSR_NO_OF_TRANS                        TotalEntries                  
            ,INWSR_RECEIVED_MODE                      ReceiptMode                  
            ,INWSR_ID            InwardNo                
            ,INWSR_RMKS   
   ,dpm.dpm_excsm_id   
   ,inwsr_transubtype_cd  
   ,convert(numeric(18,2),inwsr_ufcharge_collected)  
   ,FINA_ACC_NAME   BankName  
   ,inwsr_pay_mode  
   ,inwsr_cheque_no   
   ,inwsr_clibank_accno  
    ,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') CMBPID   
   ,ISNULL(FINA_ACC_ID,'0')
   , inwsr_clibank_name 
   , CONVERT(VARCHAR(11),inwsr_cheque_dt,103) inwsr_cheque_dt, inwsr_bank_branch,Inwsr_fax_scan_status  
   , INWSR_NO_OF_IMAGES 
   , INWSR_IMAGE_FLG
   , inwsr_doc_path       
           FROM INWARD_SLIP_REG inwsr     
    LEFT OUTER JOIN FIN_ACCOUNT_MSTR ON    FINA_ACC_ID = INWSR_BANKID AND    FINA_DELETED_IND = 1                                   
                ,  dp_acct_mstr     dpam                     
                ,  dp_mstr dpm                     
                , citrus_usr.FN_Fetch_inward_types_CDSL() ttype                    
                , company_mstr                           
                , exch_seg_mstr excsm         
                , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list    
           WHERE inwsr.inwsr_dpam_id = dpam.dpam_id                    
           AND    inwsr.inwsr_dpm_id = dpm.dpm_id      
     AND     inwsr.inwsr_trastm_cd = ttype.cd                  
           AND    dpm_excsm_id       = excsm.excsm_id                      
           AND     excsm_compm_id     = compm_id                     
           AND    excsm_list.excsm_id      = excsm.excsm_id                    
           AND    dpm.dpm_deleted_ind =1                          
           AND    INWSR.INWSR_deleted_ind =1                    
           AND    dpam.dpam_deleted_ind =1     
     AND    dpm.dpm_excsm_id  = CONVERT(NUMERIC,@pa_id)                    
           AND    inwsr.inwsr_trastm_cd = CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN ttype.cd ELSE  @pa_desc END                     
           AND    INWSR_SLIP_NO LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks))     = '' THEN '%' ELSE @pa_rmks  END                    
      AND    INWSR.INWSR_RECD_DT   LIKE CASE WHEN ISNULL(@pa_values,'') = '' then INWSR.INWSR_RECD_DT else convert(datetime,@pa_values,103) end                    
  --                  
  END                  
 --                    
END                        
                 
 IF @pa_action ='FILLPARENTGROUP'                         
 BEGIN                        
 --                        
   SELECT distinct fingm_group_code   cd                        
         ,fingm_group_name            gname                        
   FROM  fin_group_mstr                        
   WHERE  fingm_deleted_ind = 1                          
 --                        
 END                        
                         
 IF @pa_action ='FINGM_SEL'                        
 BEGIN                        
 --                        
   SELECT DISTINCT FINGM_GROUP_NAME   GROUPNAME                        
         ,FINGT_GROUP_NAME            PARENTGROUP                        
         ,FINGM_GROUP_CODE            GCD                        
         ,FINGT_GROUP_CODE            PGCD                        
                           
   FROM  FIN_GROUP_MSTR    FGM                        
        ,fin_group_trans   FGT                        
   WHERE FGM.FINGM_GROUP_CODE = FGT.FINGT_SUB_GROUP_CODE                        
   AND   FGM.FINGM_DELETED_IND =1                        
   AND   FGT.FINGT_DELETED_IND = 1         
   AND   FINGM_GROUP_NAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))  = '' THEN '%' ELSE @pa_cd + '%'  END                        
 --                        
 END                        
                         
 IF @pa_action ='ACC_SEL'                        
 BEGIN                        
 --                        
   SELECT distinct CASE WHEN fina_acc_type ='G' THEN 'GENERAL LEDGER' ELSE CASE WHEN fina_acc_type ='B' THEN 'BANK' ELSE 'CASH' END END   AccountType                        
    --fingm_group_name AccountGroup                                 
        , fina_acc_code  AccountCode                        
        , fina_acc_name  AccountName                        
        , ISNULL(entm_short_name,0)  BranchName                        
        --, dpm_excsm_id   Depository                        
		, case when FINA_DPM_ID = '999' then '999' else  dpm_excsm_id end   Depository
        , fina_Acc_ID                        
        , fina_branch_id Branch                        
        , fina_group_id                        
                                
   FROM   fin_account_mstr left outer join ENTITY_MSTR on ISNULL(fina_branch_id,0) =entm_id                         
          AND fina_deleted_ind in (0,4,6) and entm_deleted_ind = 1                         
          LEFT OUTER JOIN dp_mstr  ON dpm_id = ISNULL(fina_dpm_id,0)                         
         ,fin_group_mstr                          
   WHERE  fina_acc_type    = @pa_id                        
  -- AND fingm_group_code = fina_group_id                               
   AND    fina_acc_name    LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))  = '' THEN '%' ELSE @pa_desc +'%'  END                        
   --AND    fingm_group_code    LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))  = '' THEN '%' ELSE @pa_cd  END                        
   AND    fina_deleted_ind = 1                         
   AND    fingm_deleted_ind = 1                         
--sp_help fin_group_mstr                        
   /*                
   FINA_ACC_CODE                        
   FINA_ACC_NAME                        
   FINA_ACC_TYPE                        
   FINA_GROUP_ID                        
   FINA_BRANCH_ID                        
FINA_DPM_ID                        
   */                        
                           
 --                        
 END                        
                         
 IF @pa_action ='ACC_SELM'                        
 BEGIN                        
 --                        
  IF @pa_values <> ''                        
  BEGIN                        
  --                        
    SELECT distinct CASE WHEN fina_acc_type ='G' THEN 'GENERAL LEDGER' ELSE CASE WHEN fina_acc_type ='B' THEN 'BANK' ELSE 'CASH' END END   AccountType                        
    --fingm_group_name AccountGroup                     
    , fina_acc_code  AccountCode                         
    , fina_acc_name  AccountName                        
    , ISNULL(entm_short_name,0)  BranchName                        
    , dpm_excsm_id Depository                        
    , fina_Acc_ID                        
    , fina_branch_id Branch                        
    , fina_group_id                        
    FROM  fin_account_mstr_mak left outer join ENTITY_MSTR on ISNULL(fina_branch_id,0) =entm_id                         
      AND fina_deleted_ind in (0,4,6) and entm_deleted_ind = 1                         
      LEFT OUTER JOIN dp_mstr  ON dpm_id = ISNULL(fina_dpm_id,0)                         
      ,fin_group_mstr                          
    WHERE  fina_deleted_ind IN(0,6)                        
    --AND fingm_group_code   = fina_group_id                               
    AND    fingm_deleted_ind = 1                         
     AND    fina_acc_id = CONVERT(INT,@pa_values)                        
  --                        
  END                        
  ELSE                        
  BEGIN                        
  --                        
   SELECT distinct CASE WHEN fina_acc_type ='G' THEN 'GENERAL LEDGER' ELSE CASE WHEN fina_acc_type ='B' THEN 'BANK' ELSE 'CASH' END END   AccountType      
   --fingm_group_name AccountGroup                                
        , fina_acc_code  AccountCode                         
        , fina_acc_name  AccountName                        
        ,ISNULL(entm_short_name,0)  BranchName                        
        , dpm_excsm_id   Depository                        
        , fina_Acc_ID                        
        , fina_branch_id Branch                        
        , fina_group_id                        
   FROM  fin_account_mstr_mak left outer join ENTITY_MSTR on ISNULL(fina_branch_id,0) =entm_id                         
      AND fina_deleted_ind in (0,6) and entm_deleted_ind = 1                         
   LEFT OUTER JOIN dp_mstr  ON dpm_id = ISNULL(fina_dpm_id,0)                         
      ,fin_group_mstr                          
   WHERE  fina_acc_type    = @pa_id                        
   -- AND  fingm_group_code   = fina_group_id                              
   AND    fina_acc_name    LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))  = '' THEN '%' ELSE @pa_desc  END                        
   --AND    fingm_group_code    LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))  = '' THEN '%' ELSE @pa_cd  END                        
   AND    fina_deleted_ind IN(0,6)                        
   AND    fingm_deleted_ind = 1                         
  --                        
  END                        
 --                        
 END                        
 IF @pa_action ='ACC_SELC'                        
 BEGIN                        
 --                        
   SELECT distinct CASE WHEN fina_acc_type ='G' THEN 'GENERAL LEDGER' ELSE CASE WHEN fina_acc_type ='B' THEN 'BANK' ELSE 'CASH' END END   AccountType                        
   --fingm_group_name AccountGroup                           
   , fina_acc_name  AccountName                        
   , fina_branch_id Branch                        
   , dpm_dpid       Depository                        
   , fina_Acc_ID                 
   , fina_deleted_ind                        
   FROM   fin_account_mstr_mak left outer join ENTITY_MSTR on ISNULL(fina_branch_id,0) =entm_id                         
          AND fina_deleted_ind in (0,4,6) and entm_deleted_ind = 1                         
          LEFT OUTER JOIN dp_mstr  ON isnull(dpm_id,0) = ISNULL(fina_dpm_id,0)                         
         ,fin_group_mstr                     
   WHERE  fina_deleted_ind  IN(0,4,6)                        
   --AND fingm_group_code     = fina_group_id                               
  AND    isnull(dpm_deleted_ind,1) = 1                         
   AND    fingm_deleted_ind = 1                         
   AND    fina_lst_upd_by <> @pa_login_name                        
                        
 --                        
 END                        
 IF @pa_action ='DPC_SEL'                        
 BEGIN                        
 --                        
   SELECT distinct dpm_dpid DpmId                        
         ,brom_desc         Profile                        
         ,convert(varchar(11),dpc_eff_from_dt,103) EffectiveFrom                        
         ,convert(varchar(11),dpc_eff_to_dt,103)   EffectiveTo            
         ,brom_id             BroID                        
         ,dpc_post_toacct     PostToAcct                        
         ,dpc_id             DpcID                        
   FROM   dp_charges_mstr                        
   ,      dp_mstr                        
   ,      brokerage_mstr                         
   WHERE  dpm_id           = dpc_dpm_id                        
   AND    dpc_profile_id   = brom_id                        
   AND    dpm_dpid         = @pa_cd                         
   AND    dpm_deleted_ind   = 1                         
   AND    dpc_deleted_ind   = 1                         
   AND    brom_deleted_ind  = 1                         
                           
                        
 --                        
 END                      
                         
 IF @pa_action ='FINYRDEF_SEL'                  
 BEGIN                  
 --        
   IF @pa_cd <> ''
	BEGIN
          
   SELECT compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd+'-'+dpm.dpm_dpid  Depository                  
         ,convert(varchar(11),fin_start_dt,103)  StartDate                  
         ,convert(varchar(11),fin_end_dt,103)   EndDate                  
         ,fin_id                                          
   FROM Financial_Yr_Mstr                  
        ,dp_mstr dpm                  
        ,company_mstr                  
       , exch_seg_mstr excsm                   
   WHERE fin_dpm_id = dpm.dpm_id                  
   AND   dpm_excsm_id       = excsm.excsm_id                  
   AND   excsm_compm_id     = compm_id                   
   AND   dpm.dpm_deleted_ind =1                   
   AND   fin_deleted_ind = 1                   
   AND   excsm_deleted_ind = 1                   
   AND   dpm.dpm_dpid = case when isnull(@pa_cd,'')='' then dpm.dpm_dpid else @pa_cd end                  
  END
ELSE
BEGIN
	SELECT '<--------FOR ALL DP-------->'  Depository                  
         ,convert(varchar(11),fin_start_dt,103)  StartDate                  
         ,convert(varchar(11),fin_end_dt,103)   EndDate                  
         ,fin_id                                          
   FROM Financial_Yr_Mstr                  
   WHERE fin_deleted_ind = 1 
   AND   FIN_DPM_ID = '999'                
END
END                         
                         
 IF @pa_action ='VOUCHERCONTRA_SEL'                          
  BEGIN                          
   --           
    set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
           --,ldg_voucher_type   VOUCHERTYPE                        
           --,ldg_book_type_cd   BOOKTYPECODE                        
           ,ldg_ref_no          REFERENCENO                          
           ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
           ,dpam_sba_no     ACCOUNTCODE                          
           ,dpam_sba_name     ACCOUNTNAME                        
           ,ldg_amount         CREDITAMOUNT                        
           ,ldg_id             id                          
           ,ldg_dpm_id         DPMID                        
           , dpam_id  ACCOUNTID                                  
   FROM    ledger' + convert(varchar(20),@@fin_id)              + '           
   ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                          
   WHERE ldg_voucher_type = 4                    
   AND ldg_sr_no = 1                        
   AND dpam_id   = ldg_account_id                        
 AND ldg_account_type = acct_type                        
   AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd + ''' END                        
   AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
   AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+@pa_rmks+''' END                         
   AND ldg_deleted_ind = 1            
   ORDER BY  ldg_id              '          
        
   exec (@l_sql)          
  --                          
 END                         
                         
 IF @pa_action ='VOUCHERPAY_SEL'                          
 BEGIN                          
  --             
        
   set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
          --,ldg_voucher_type   VOUCHERTYPE                 
          --,ldg_book_type_cd   BOOKTYPECODE                        
          ,ldg_ref_no          REFERENCENO                          
          ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
          ,dpam_sba_no        ACCOUNTCODE                          
    ,dpam_sba_name      ACCOUNTNAME                        
    ,ldg_amount         CREDITAMOUNT                        
          ,ldg_id             id                          
          ,ldg_dpm_id         DPMID                        
          ,dpam_id            ACCOUNTID                             
          ,ldg_account_type                           
  FROM    ledger' + convert(varchar(20),@@fin_id)   + '                        
    ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks +','+ @pa_id+',0)                          
  WHERE ldg_voucher_type =1                        
  AND ldg_sr_no = 1                        
  AND dpam_id    = ldg_account_id                        
  AND ldg_account_type = acct_type                        
  AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd + ''' END                          
  AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
  AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+  @pa_rmks  + ''' END                         
  AND ldg_deleted_ind = 1           
  ORDER BY  ldg_id              '          
  exec(@l_sql)          
 --                          
 END                          
                         
                         
 IF @pa_action ='VOUCHERREC_SEL'                          
  BEGIN                          
   --                          
    set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
           --,ldg_voucher_type   VOUCHERTYPE                        
           --,ldg_book_type_cd   BOOKTYPECODE                        
           ,ldg_ref_no          REFERENCENO                          
           ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
           ,dpam_sba_no      ACCOUNTCODE                          
     ,dpam_sba_name      ACCOUNTNAME                        
     ,-1*ldg_amount        DEBITAMOUNT                        
     ,ldg_account_no     ACCOUNTNO                        
     ,ldg_id             id                          
     ,ldg_dpm_id         DPMID                        
     ,dpam_id     ACCOUNTID                           
     ,ldg_account_type                                 
   FROM    ledger' + convert(varchar(20),@@fin_id) + '                         
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                          
   WHERE ldg_voucher_type =2                         
   AND ldg_sr_no = 1                        
   AND dpam_id    = ldg_account_id                        
   AND ldg_account_type = acct_type                        
   AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd +''' END                          
   AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
   AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+@pa_rmks+''' END                         
   AND ldg_deleted_ind = 1                          
   ORDER BY  ldg_id              '          
PRINT(@l_sql)        
   exec(@l_sql)          
  --                          
 END                                      
 IF @pa_action ='VOUCHERJV_SEL'                          
  BEGIN                          
   --                          
    set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                                   
           ,ldg_ref_no REFERENCENO                          
           ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                             
           ,ldg_dpm_id         DPMID                         
           ,ldg_id             ID                        
   FROM     ledger' + convert(varchar(20),@@fin_id)              + '                             
   WHERE ldg_voucher_type = 3                        
   AND ldg_sr_no = 1                          
   AND ldg_voucher_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE ''' + @pa_cd + ''' END                          
   AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
   AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks +''' END                         
   AND ldg_deleted_ind = 1                            
   ORDER BY  ldg_id              '          
        
   exec(@l_sql)          
   print (@l_sql)
  --                          
 END                         
                         
 IF @pa_action ='VOUCHERCONTRA_SELM'                          
   BEGIN                          
    --                          
    IF @pa_values <> ''                        
      BEGIN                        
         --                        
      set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
       --,ldg_voucher_type   VOUCHERTYPE                        
       --,ldg_book_type_cd   BOOKTYPECODE                        
       ,ldg_ref_no          REFERENCENO                          
       ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
       ,dpam_sba_no      ACCOUNTCODE                         
       ,dpam_sba_name      ACCOUNTNAME                        
       ,ldg_amount         CREDITAMOUNT                        
       ,ldg_id             id                          
       ,ldg_dpm_id         DPMID                        
       ,dpam_id         ACCOUNTID                                  
       FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                       
        ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                          
       WHERE ldg_voucher_type = 4                           
       AND ldg_sr_no = 1                     
       AND dpam_id    = ldg_account_id                        
       AND ldg_account_type = acct_type                        
       AND ldg_id         = ''' + @pa_values           +'''             
       AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
    AND ldg_deleted_ind IN (0,6)             
        ORDER BY  ldg_id              '          
        
       exec(@l_sql)          
         --                        
      END                        
   ELSE                           
      BEGIN                        
      --                        
       set @l_sql ='   SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
      --,ldg_voucher_type   VOUCHERTYPE                        
      --,ldg_book_type_cd   BOOKTYPECODE                        
      ,ldg_ref_no          REFERENCENO                         
      ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
    ,dpam_sba_no      ACCOUNTCODE                          
      ,dpam_sba_name      ACCOUNTNAME                        
      ,ldg_amount         CREDITAMOUNT                        
      ,ldg_id             id                          
      ,ldg_dpm_id         DPMID                        
      ,dpam_id     ACCOUNTID                                  
      FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)           
      WHERE  ldg_voucher_type = 4                          
      AND ldg_sr_no = 1                        
      AND dpam_id    = ldg_account_id                
      AND ldg_account_type = acct_type                        
      AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
   AND ldg_deleted_ind IN (0,6)         
       ORDER BY  ldg_id      '          
          exec(@l_sql)            
        --                        
      END                        
   --                          
  END                          
                         
 IF @pa_action ='VOUCHERPAY_SELM'                          
  BEGIN                          
   --                          
   IF @pa_values <> ''                        
     BEGIN                        
        --                        
     set @l_sql ='    SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
      --,ldg_voucher_type   VOUCHERTYPE                        
      --,ldg_book_type_cd   BOOKTYPECODE                        
      ,ldg_ref_no          REFERENCENO                          
      ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
      ,dpam_sba_no      ACCOUNTCODE                          
      ,dpam_sba_name    ACCOUNTNAME                        
      ,ldg_amount       CREDITAMOUNT                        
      ,ldg_id           id                          
      ,ldg_dpm_id       DPMID                        
      ,dpam_id          ACCOUNTID                          
      ,ldg_account_type                              
       FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                      
      WHERE ldg_voucher_type =1                                        
      AND ldg_sr_no = 1        
      AND dpam_id        = ldg_account_id                        
      AND ldg_account_type = acct_type                        
      AND ldg_id         = ''' + @pa_values              +'''          
      AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
      /*AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END*/                           
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
  AND ldg_deleted_ind IN (0,6)          
      ORDER BY  ldg_id       '          
        
      exec(@l_sql)                 
        --                        
     END                        
  ELSE                           
     BEGIN                        
     --                        
       set @l_sql ='      SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
     --,ldg_voucher_type   VOUCHERTYPE                        
     --,ldg_book_type_cd   BOOKTYPECODE                        
     ,ldg_ref_no          REFERENCENO                          
     ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
     ,dpam_sba_no      ACCOUNTCODE                          
     ,dpam_sba_name      ACCOUNTNAME                        
     ,ldg_amount CREDITAMOUNT                        
     ,ldg_id             id                          
     ,ldg_dpm_id         DPMID                 
     ,dpam_id     ACCOUNTID                         
     ,ldg_account_type                            
        FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                          
     WHERE ldg_voucher_type =1                          
     AND ldg_sr_no = 1                        
     AND dpam_id    = ldg_account_id                         
     AND ldg_account_type = acct_type                        
      AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
       /*AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END */        
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
   AND ldg_deleted_ind IN (0,4,6)         
      ORDER BY  ldg_id '          
    exec(@l_sql)                       
       --                        
     END                        
  --                          
  END                          
                          
                          
                          
  IF @pa_action ='VOUCHERREC_SELM'                  
    BEGIN                          
     --                          
     IF @pa_values <> ''                        
       BEGIN                        
          --                        
        set @l_sql ='      SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
        --,ldg_voucher_type   VOUCHERTYPE                        
        --,ldg_book_type_cd   BOOKTYPECODE                        
        ,ldg_ref_no          REFERENCENO                          
        ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
        ,dpam_sba_no      ACCOUNTCODE                          
        ,dpam_sba_name      ACCOUNTNAME                        
        ,-1* ldg_amount        DEBITAMOUNT                        
        ,ldg_account_no     ACCOUNTNO                        
        ,ldg_id             id                          
        ,ldg_dpm_id         DPMID                        
        ,dpam_id            ACCOUNTID                         
        ,ldg_account_type                                   
          FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                     
        WHERE  ldg_voucher_type =2                           
        AND ldg_sr_no = 1                        
        AND dpam_id    = ldg_account_id                        
        AND ldg_account_type = acct_type                        
        AND ldg_id         = ''' +  @pa_values              + '''          
        AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
    AND ldg_deleted_ind IN (0,6)           
      ORDER BY  ldg_id           '          
      exec(@l_sql)             
          --                        
       END                        
    ELSE                           
       BEGIN                        
       --                        
       set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                         
       --,ldg_voucher_type   VOUCHERTYPE                        
       --,ldg_book_type_cd   BOOKTYPECODE                        
       ,ldg_ref_no          REFERENCENO                          
       ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
       ,dpam_sba_no      ACCOUNTCODE                          
       ,dpam_sba_name      ACCOUNTNAME                        
       ,-1* ldg_amount         DEBITAMOUNT                        
       ,ldg_account_no     ACCOUNTNO                        
       ,ldg_id             id                          
       ,ldg_dpm_id         DPMID                        
       ,dpam_id     ACCOUNTID                          
       ,ldg_account_type                                
       FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                   
       WHERE  ldg_voucher_type =2                             
    AND ldg_sr_no = 1                        
       AND dpam_id    = ldg_account_id                        
       AND ldg_account_type = acct_type                        
       AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
    AND ldg_deleted_ind IN (0,4,6)              
       ORDER BY  ldg_id       '          
       exec(@l_sql)                 
   --                        
       END                        
    --                          
  END                          
                          
  IF @pa_action ='VOUCHERJV_SELM'                          
      BEGIN                          
       --                          
       IF @pa_values <> ''                        
         BEGIN                        
      --                        
    set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                              
      ,ldg_ref_no          REFERENCENO                          
      ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                         
      ,ldg_dpm_id         DPMID                        
      ,ldg_id             ID                        
       FROM     ledger'+ convert(varchar(20),@@fin_id) +'_mak                         
       WHERE  ldg_voucher_type =3                      
       AND ldg_sr_no = 1                        
       AND ldg_id         = ''' + @pa_values               + '''          
       AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
    AND ldg_deleted_ind IN (0,6)                
       ORDER BY  ldg_id    '          
       exec(@l_sql)                    
         --                        
         END                        
      ELSE                           
         BEGIN                        
         --                        
         set @l_sql ='         SELECT DISTINCT ldg_voucher_no       VOUCHERNO                             
                     ,ldg_ref_no          REFERENCENO                          
                     ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                          
                     ,ldg_dpm_id         DPMID                        
                     ,ldg_id             ID                         
                     FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                               
                     WHERE  ldg_voucher_type =3                             
                     AND ldg_sr_no = 1                        
                     AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                          
                     AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                           
                     AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                         
      AND ldg_deleted_ind IN (0,4,6)           
                     ORDER BY  ldg_id       '          
         exec(@l_sql)                 
         --                        
         END                        
      --                          
  END                          
         
  IF @pa_action ='VOUCHERCN_SEL'                        
  BEGIN                        
   --                        
    set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                       
           ,ldg_ref_no          REFERENCENO                        
           ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                           
           ,ldg_dpm_id         DPMID                       
           ,ldg_id             ID                      
   FROM     ledger' + convert(varchar(20),@@fin_id)              + '                           
   WHERE ldg_voucher_type = 6                      
   AND ldg_sr_no = 1                        
   AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE ''' + @pa_cd + ''' END                        
   AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                         
   AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks +''' END                       
   AND ldg_deleted_ind = 1                          
   ORDER BY  ldg_id              '        
      
   exec(@l_sql)        
  --                        
 END         
IF @pa_action ='VOUCHERDN_SEL'                        
  BEGIN                        
   --                        
    set @l_sql =' SELECT DISTINCT ldg_voucher_no   VOUCHERNO                                 
           ,ldg_ref_no          REFERENCENO                        
           ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                           
           ,ldg_dpm_id         DPMID                       
           ,ldg_id             ID                      
   FROM     ledger' + convert(varchar(20),@@fin_id)              + '                           
   WHERE ldg_voucher_type = 7                      
   AND ldg_sr_no = 1                        
   AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE ''' + @pa_cd + ''' END                        
   AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                         
   AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks +''' END                       
   AND ldg_deleted_ind = 1                          
   ORDER BY  ldg_id              '        
      
   exec(@l_sql)        
  --                        
 END         
      
IF @pa_action ='VOUCHERCN_SELM'                        
      BEGIN                        
       --                        
       IF @pa_values <> ''                      
         BEGIN                      
      --                      
    set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                            
      ,ldg_ref_no          REFERENCENO                        
      ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                       
      ,ldg_dpm_id         DPMID                      
      ,ldg_id             ID                      
       FROM     ledger'+ convert(varchar(20),@@fin_id) +'_mak                       
       WHERE  ldg_voucher_type =6                    
       AND ldg_sr_no = 1                      
       AND ldg_id         = ''' + @pa_values               + '''        
       AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                        
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                         
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                       
    AND ldg_deleted_ind IN (0,6)              
       ORDER BY  ldg_id    '        
      
       exec(@l_sql)                  
         --                      
         END                      
      ELSE                         
         BEGIN                      
         --                      
       set @l_sql ='         SELECT DISTINCT ldg_voucher_no       VOUCHERNO                           
                     ,ldg_ref_no          REFERENCENO                        
   ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                        
                     ,ldg_dpm_id         DPMID                      
                     ,ldg_id             ID                       
                     FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                             
                     WHERE  ldg_voucher_type =6                      
                     AND ldg_sr_no = 1                      
                     AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                        
                     AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                         
                     AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                       
      AND ldg_deleted_ind IN (0,4,6)         
                     ORDER BY  ldg_id       '        
      
         exec(@l_sql)               
         --                      
         END                      
      --                        
  END       
IF @pa_action ='VOUCHERDN_SELM'                        
      BEGIN                        
       --                        
       IF @pa_values <> ''                      
         BEGIN                      
      --                      
    set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                            
      ,ldg_ref_no          REFERENCENO                        
      ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                       
      ,ldg_dpm_id         DPMID                      
      ,ldg_id             ID                      
       FROM     ledger'+ convert(varchar(20),@@fin_id) +'_mak                       
       WHERE  ldg_voucher_type =7                    
       AND ldg_sr_no = 1                      
       AND ldg_id         = ''' + @pa_values               + '''        
       AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                        
       AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                         
       AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                       
    AND ldg_deleted_ind IN (0,6)              
       ORDER BY  ldg_id    '        
      
       exec(@l_sql)                 
       
         --                      
         END                      
      ELSE                         
         BEGIN                      
         --                      
         set @l_sql ='         SELECT DISTINCT ldg_voucher_no       VOUCHERNO                           
                     ,ldg_ref_no          REFERENCENO                        
                     ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                        
                     ,ldg_dpm_id         DPMID                      
                     ,ldg_id             ID                       
                     FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                             
                     WHERE  ldg_voucher_type =7                           
                     AND ldg_sr_no = 1                      
                     AND ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+@pa_cd+''' END                        
                     AND ldg_voucher_dt LIKE CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                         
                     AND ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+ @pa_rmks+''' END                       
      AND ldg_deleted_ind IN (0,4,6)         
                     ORDER BY  ldg_id       '        
         exec(@l_sql)        
         --                      
         END                      
      --                        
  END                        
     
                        
IF @pa_action ='VOUCHERCN_SELC'                        
  BEGIN                        
   --       
                       
     set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                          
    ,ldg_ref_no          REFERENCENO                        
    ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                 
    ,dpam_sba_no      ACCOUNTCODE                        
    ,dpam_sba_name      ACCOUNTNAME                      
    ,ldg_amount         CREDITAMOUNT                      
    ,ldg_id             id                        
    ,ldg_dpm_id         DPMID                      
    ,ldg_voucher_type                      
    ,ldg_book_type_cd                      
    ,dpam_id     ACCOUNTID              
    ,ldg_deleted_ind                      
  FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                 
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
   WHERE ldg_sr_no = 1                      
   AND dpam_id    = ldg_account_id                      
   AND ldg_account_type = acct_type                      
   AND ldg_voucher_type =6                      
   AND ldg_deleted_ind IN (0,4,6)                       
   AND ldg_lst_upd_by <> ''' + @pa_login_name               + '''         
   AND ldg_dpm_id = '''+ convert(varchar,@pa_values)              + '''               
   ORDER BY  ldg_id      '        
   exec(@l_sql)                    
  --                        
 END          
IF @pa_action ='VOUCHERDN_SELC'                        
  BEGIN                        
   --                        
     set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                          
    ,ldg_ref_no          REFERENCENO                        
    ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                 
    ,dpam_sba_no      ACCOUNTCODE                        
    ,dpam_sba_name      ACCOUNTNAME                      
    ,ldg_amount         CREDITAMOUNT                      
    ,ldg_id             id                        
    ,ldg_dpm_id         DPMID                      
    ,ldg_voucher_type                      
    ,ldg_book_type_cd                      
    ,dpam_id     ACCOUNTID              
    ,ldg_deleted_ind                      
  FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                 
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
   WHERE ldg_sr_no = 1                      
   AND dpam_id    = ldg_account_id                      
   AND ldg_account_type = acct_type                      
   AND ldg_voucher_type =7                      
   AND ldg_deleted_ind IN (0,4,6)                       
   AND ldg_lst_upd_by <> ''' + @pa_login_name               + '''         
   AND ldg_dpm_id = '''+ convert(varchar,@pa_values)              + '''               
   ORDER BY  ldg_id      '        
   exec(@l_sql)                    
  --                        
 END        
      
IF @pa_action ='VOUCHERCN_DTLS_SEL'                        
    BEGIN                        
    --                        
      set @l_sql ='        SELECT DISTINCT ldg_account_id = dpam_id                      
      ,fina_acc_code = dpam_sba_no                      
      ,fina_acc_name = dpam_sba_name                      
    --,ldg_branch_id                      
    --,entm_short_name                      
    --,ldg_instrument_no                      
    ,ldg_cost_cd_id                      
    ,ldg_amount                        
    ,ldg_narration                      
    ,fina_acc_type = acct_type                      
    ,ldg_account_no        ,ldg_id                      
    ,ldg_sr_no                   
     FROM    ledger'+ convert(varchar(20),@@fin_id) +'                
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                         
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''                   
   --  AND   ldg_branch_id    = entm_id                      
     AND  ldg_voucher_type = 6                          
     AND   dpam_id      = ldg_account_id        
     AND   ldg_account_type = acct_type        
     AND   ldg_sr_no >= 1                      
     AND ldg_deleted_ind  = 1                       
     ORDER BY  ldg_sr_no  ,acct_type  DESC        '        
    exec(@l_sql)          
    --                      
 END        
IF @pa_action ='VOUCHERDN_DTLS_SEL'                        
    BEGIN                        
    --                        
      set @l_sql ='        SELECT DISTINCT ldg_account_id = dpam_id                      
      ,fina_acc_code = dpam_sba_no                      
      ,fina_acc_name = dpam_sba_name                      
    --,ldg_branch_id                      
    --,entm_short_name                      
    --,ldg_instrument_no                      
    ,ldg_cost_cd_id                      
    ,ldg_amount                        
    ,ldg_narration                      
    ,fina_acc_type = acct_type                      
    ,ldg_account_no        ,ldg_id                      
    ,ldg_sr_no                   
     FROM    ledger'+ convert(varchar(20),@@fin_id) +'                
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                         
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''                   
   --  AND   ldg_branch_id    = entm_id                      
     AND  ldg_voucher_type = 7                          
     AND   dpam_id      = ldg_account_id        
     AND   ldg_account_type = acct_type        
     AND   ldg_sr_no >= 1                      
     AND   ldg_deleted_ind  = 1                       
     ORDER BY  ldg_sr_no  ,acct_type  DESC        '        
    exec(@l_sql)          
    --                      
 END                          
                          
  IF @pa_action ='VOUCHERCONTRA_SELC'                          
     BEGIN                          
      --            
                        
        set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                                   
              ,ldg_ref_no          REFERENCENO                          
              ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
              ,dpam_sba_no      ACCOUNTCODE                          
         ,dpam_sba_name      ACCOUNTNAME                        
         ,ldg_amount         CREDITAMOUNT                        
              ,ldg_id             id                          
              ,ldg_dpm_id         DPMID                        
              ,ldg_voucher_type                        
     ,ldg_book_type_cd                        
              ,dpam_id     ACCOUNTID                         
              ,ldg_deleted_ind                        
      FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                             
      WHERE ldg_voucher_type = 4          
   AND ldg_sr_no = 1                        
      AND dpam_id    = ldg_account_id                        
      AND ldg_account_type = acct_type                        
      AND ldg_deleted_ind IN (0,4,6)                         
      AND ldg_lst_upd_by <> ''' + @pa_login_name               + ' ''          
      AND ldg_dpm_id = '''+ convert(varchar,@pa_values)              + '''           
      ORDER BY  ldg_id              '          
        
      exec(@l_sql)             
     --                          
 END                         
                          
                         
 IF @pa_action ='VOUCHERPAY_SELC'                          
   BEGIN                          
    --                          
     set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                                   
            ,ldg_ref_no          REFERENCENO                          
            ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
            ,dpam_sba_no      ACCOUNTCODE                          
     ,dpam_sba_name      ACCOUNTNAME                        
     ,ldg_amount         CREDITAMOUNT                        
            ,ldg_id             id                          
            ,ldg_dpm_id         DPMID                        
 ,ldg_voucher_type                        
   ,ldg_book_type_cd                        
            ,dpam_id     ACCOUNTID                         
            ,ldg_deleted_ind                        
   ,ldg_account_type                      
   FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                                
    WHERE ldg_sr_no = 1                        
    AND dpam_id        = ldg_account_id                        
    AND ldg_account_type = acct_type                        
    AND ldg_voucher_type =1                        
    AND ldg_deleted_ind IN (0,4,6)                         
    AND ldg_lst_upd_by <> ''' + @pa_login_name               + '''           
      AND ldg_dpm_id = '''+ convert(varchar,@pa_values)              + '''                 
    ORDER BY  ldg_id    '          
        
    exec(@l_sql)                       
   --                          
 END                         
                         
                         
                         
                         
 IF @pa_action ='VOUCHERREC_SELC'                          
 BEGIN                          
  --                          
   set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                           
   ,ldg_ref_no          REFERENCENO                          
   ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
   ,dpam_sba_no      ACCOUNTCODE                          
   ,dpam_sba_name      ACCOUNTNAME                        
   ,ldg_amount         CREDITAMOUNT                      
   ,ldg_id             id                          
   ,ldg_dpm_id         DPMID                        
   ,ldg_voucher_type                        
   ,ldg_book_type_cd                        
   ,dpam_id     ACCOUNTID                         
   ,ldg_deleted_ind                        
  FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                    
  WHERE ldg_sr_no = 1                        
  AND dpam_id    = ldg_account_id                        
  AND ldg_account_type = acct_type                        
  AND ldg_voucher_type =2                        
  AND ldg_deleted_ind IN (0,4,6)                         
  AND ldg_lst_upd_by <> ''' + @pa_login_name               + '''           
      AND ldg_dpm_id = '''+ convert(varchar,@pa_values)              + '''                 
             
  ORDER BY  ldg_id                '          
  exec(@l_sql)          
 --                          
 END                          
                         
 IF @pa_action ='VOUCHERJV_SELC'                          
  BEGIN                          
   --                          
     set @l_sql ='         SELECT DISTINCT ldg_voucher_no   VOUCHERNO                            
    ,ldg_ref_no          REFERENCENO                          
    ,convert(varchar(11),ldg_voucher_dt,103) VOUCHERDATE                                   
    ,dpam_sba_no      ACCOUNTCODE                          
    ,dpam_sba_name      ACCOUNTNAME                        
    ,ldg_amount         CREDITAMOUNT                        
    ,ldg_id             id                          
    ,ldg_dpm_id         DPMID                        
    ,ldg_voucher_type                        
    ,ldg_book_type_cd                        
    ,dpam_id     ACCOUNTID                
    ,ldg_deleted_ind                        
  FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                             
   WHERE ldg_sr_no = 1                        
   AND dpam_id    = ldg_account_id                        
   AND ldg_account_type = acct_type                        
   AND ldg_voucher_type =3                        
   AND ldg_deleted_ind IN (0,4,6)                         
   AND ldg_lst_upd_by <> ''' + @pa_login_name               + '''           
   AND ldg_dpm_id = '''+ convert(varchar,@pa_values)              + '''                 
   ORDER BY  ldg_id      '          
   exec(@l_sql)               
  --                          
 END                          
                         
 IF @pa_action ='VOUCHERCONTRA_DTLS_SEL'                          
   BEGIN                          
   --                          
     set @l_sql ='        SELECT distinct ldg_account_id = dpam_id                        
     ,fina_acc_code  = dpam_sba_no                        
     ,fina_acc_name = dpam_sba_name                   
   --,ldg_branch_id                        
   --,entm_short_name                        
   ,ldg_instrument_no            
   ,ldg_cost_cd_id                        
   ,-1*ldg_amount ldg_amount                        
   ,ldg_narration                        
   ,fina_acc_type = acct_type                        
   ,ldg_sr_no                        
    FROM    ledger'+ convert(varchar(20),@@fin_id) +'                  
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                     
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''           
   -- AND   ldg_branch_id    = entm_id                        
    AND   ldg_voucher_type = 4                        
    AND   dpam_id      = ldg_account_id                        
    AND   ldg_account_type = acct_type                        
    AND   ldg_sr_no >= 1                        
    AND   ldg_deleted_ind  = 1                         
    ORDER BY  ldg_sr_no          '          
    exec(@l_sql)              
          
 --                        
 END                        
                         
 IF @pa_action ='VOUCHERPAY_DTLS_SEL'                          
  BEGIN                          
  --                          
    set @l_sql ='        SELECT DISTINCT ldg_account_id = dpam_id                        
    ,fina_acc_code = dpam_sba_no                        
    ,fina_acc_name = dpam_sba_name                        
  --,ldg_branch_id                        
  --,entm_short_name                        
  ,ldg_instrument_no                        
  ,ldg_cost_cd_id                        
  ,-1*ldg_amount ldg_amount                        
  ,ldg_narration                        
  ,fina_acc_type = acct_type                        
  ,ldg_sr_no                        
 FROM    ledger'+ convert(varchar(20),@@fin_id) +'                 
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                   
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''           
  -- AND   ldg_branch_id    = entm_id                        
   AND   ldg_voucher_type = 1                        
   AND   dpam_id          = ldg_account_id                        
   AND   ldg_account_type = acct_type                        
   AND   ldg_sr_no > 1                        
   AND   ldg_deleted_ind  = 1                         
   ORDER BY  ldg_sr_no,acct_type DESC       '          
        
   exec(@l_sql)                 
  --                        
 END                        
                         
                         
 IF @pa_action ='VOUCHERREC_DTLS_SEL'                          
   BEGIN                          
   --                          
     set @l_sql ='        SELECT distinct ldg_account_id = dpam_id                        
     ,fina_acc_code = dpam_sba_no                        
     ,fina_acc_name = dpam_sba_name                        
   --,ldg_branch_id                       
   --,entm_short_name                        
   ,ldg_instrument_no       
   ,ldg_cost_cd_id                        
   ,ldg_amount                          
   ,ldg_narration                        
   ,fina_acc_type = acct_type                        
   ,ldg_account_no                         
   ,ldg_sr_no                        
  FROM    ledger'+ convert(varchar(20),@@fin_id) +'                  
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''               
   -- AND   ldg_branch_id    = entm_id                        
    AND  ldg_voucher_type = 2                  
    AND   dpam_id      = ldg_account_id                        
    AND   ldg_account_type = acct_type                        
    AND   ldg_sr_no > 1            
    AND   ldg_deleted_ind  = 1                         
    ORDER BY  ldg_sr_no  ,acct_type DESC        '          
    exec(@l_sql)              
   --                        
 END                        
                         
 IF @pa_action ='VOUCHERJV_DTLS_SEL'                          
    BEGIN                          
    --                          
      set @l_sql ='        SELECT DISTINCT ldg_account_id = dpam_id                        
      ,fina_acc_code = dpam_sba_no                        
      ,fina_acc_name = dpam_sba_name                        
    --,ldg_branch_id                        
    --,entm_short_name                        
    --,ldg_instrument_no                        
    ,ldg_cost_cd_id                        
    ,ldg_amount                          
    ,ldg_narration                        
    ,fina_acc_type = acct_type                        
    ,ldg_account_no        ,ldg_id                        
    ,ldg_sr_no                     
     FROM    ledger'+ convert(varchar(20),@@fin_id) +'                  
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''                     
   --  AND   ldg_branch_id    = entm_id                        
     AND  ldg_voucher_type = 3                            
     AND   dpam_id      = ldg_account_id          
     AND   ldg_account_type = acct_type          
     AND   ldg_sr_no >= 1                        
     AND   ldg_deleted_ind  = 1                         
     ORDER BY  ldg_sr_no  ,acct_type  DESC        '          
    exec(@l_sql)            
    --                        
 END                        
                         
 IF @pa_action ='VOUCHERCONTRA_DTLS_SELM'                          
    BEGIN                          
    --                          
      set @l_sql ='        SELECT distinct ldg_account_id                        
      ,fina_acc_code = dpam_sba_no                        
      ,fina_acc_name = dpam_sba_name                        
    --,ldg_branch_id                        
    --,entm_short_name                        
    ,ldg_instrument_no                        
    ,ldg_cost_cd_id                        
    ,-1*ldg_amount ldg_amount                        
    ,ldg_narration                        
    ,fina_acc_type = acct_type                        
    ,ldg_sr_no                        
      FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
    WHERE ldg_voucher_no   = ' + @pa_cd               + '                
    -- AND   ldg_branch_id    = entm_id                        
     AND  ldg_voucher_type = 4                        
     AND   dpam_id      = ldg_account_id                        
     AND   ldg_account_type = acct_type                        
     AND   ldg_sr_no >= 1                        
     AND   ldg_deleted_ind  IN (0,6)                          
     ORDER BY  ldg_sr_no ,acct_type DESC '          
    exec(@l_sql)                     
    --                        
 END                        
                         
 IF @pa_action ='VOUCHERPAY_DTLS_SELM'                             BEGIN                          
   --                          
      set @l_sql ='        SELECT DISTINCT ldg_account_id = dpam_id                        
     ,fina_acc_code = dpam_sba_no                        
    ,fina_acc_name = dpam_sba_name                        
   --,ldg_branch_id                        
   --,entm_short_name                        
   ,ldg_instrument_no                        
   ,ldg_cost_cd_id                        
   ,-1*ldg_amount ldg_amount                        
   ,ldg_narration                        
   ,fina_acc_type = acct_type                        
   ,ldg_sr_no                  
      FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''                     
   -- AND   ldg_branch_id  = entm_id                  
    AND   ldg_account_type = acct_type                        
    AND  ldg_voucher_type = 1                        
    AND   dpam_id      = ldg_account_id                        
    AND   ldg_sr_no > 1                        
    AND   ldg_deleted_ind  IN (0,6)                          
    ORDER BY  ldg_sr_no , acct_type  DESC'          
    exec(@l_sql)                     
   --                        
 END                        
                         
                         
 IF @pa_action ='VOUCHERREC_DTLS_SELM'                          
    BEGIN                          
    --                          
       set @l_sql ='        SELECT distinct ldg_account_id = dpam_id                        
      ,fina_acc_code = dpam_sba_no                   
     ,fina_acc_name = dpam_sba_name                 
    --,ldg_branch_id                        
    --,entm_short_name                
    ,ldg_instrument_no                        
    ,ldg_cost_cd_id                        
    ,ldg_amount                        
    ,ldg_narration                        
    ,fina_acc_type = acct_type                    
    ,ldg_account_no                         
    ,ldg_sr_no                        
      FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''                 
     --AND   ldg_branch_id    = entm_id                        
     AND   ldg_account_type = acct_type                        
     AND  ldg_voucher_type = 2                          
     AND   dpam_id      = ldg_account_id                        
     AND   ldg_sr_no > 1                        
     AND   ldg_deleted_ind  IN (0,6)                         
     ORDER BY  ldg_sr_no  ,acct_type  DESC  '          
     exec(@l_sql)                  
    --                        
 END                        
                         
 IF @pa_action ='VOUCHERJV_DTLS_SELM'                          
     BEGIN                          
     --                          
       set @l_sql ='        SELECT distinct ldg_account_id = dpam_id                        
       ,fina_acc_code = dpam_sba_no                        
       ,fina_acc_name = dpam_sba_name                        
     --,ldg_branch_id                        
     --,entm_short_name                        
     --,ldg_instrument_no                        
     ,ldg_cost_cd_id                        
     ,ldg_amount                         
     ,ldg_narration                        
     ,fina_acc_type = acct_type                        
     ,ldg_account_no                         
     ,ldg_id                        
     ,ldg_sr_no                        
     FROM    ledger'+ convert(varchar(20),@@fin_id) +'_mak                   
     ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                           
    WHERE ldg_voucher_no   = ''' + @pa_cd               + '''                     
             
     -- AND   ldg_branch_id    = entm_id                        
    AND  ldg_voucher_type = 3                          
      AND   dpam_id      = ldg_account_id                        
      AND   ldg_account_type = acct_type                        
      AND   ldg_sr_no >= 1                    
      AND   ldg_deleted_ind  IN (0,6)                         
      ORDER BY  ldg_sr_no  ,acct_type  DESC    '          
        
      exec(@l_sql)                
     --                        
 END                          
                         
 IF @pa_action ='CLSR_CHKR'                            
 BEGIN                            
 --                            
  SELECT CLSR_ID,CLSR_DPM_ID,CLSR_BO_ID,CLSR_NEW_BO_ID,CLSR_RMKS,CLSR_DELETED_IND                        
  FROM CLOSURE_ACCT_MAK                           
  WHERE CLSR_LST_UPD_BY <> @pa_login_name                          
  AND CLSR_DELETED_IND IN (0,4,6)                           
 --                          
 END          
       
 IF @pa_action ='CLSR_CHKR_CDSL'                          
 BEGIN                          
 --                          
  SELECT CLSR_ID,CLSR_DPM_ID,CLSR_BO_ID,CLSR_NEW_BO_ID,CLSR_RMKS,CLSR_DELETED_IND                      
  FROM CLOSURE_ACCT_CDSL_MAK                         
  WHERE CLSR_LST_UPD_BY <> @pa_login_name                        
  AND CLSR_DELETED_IND IN (0,4,6)                         
 --                        
 END         
       
 IF @pa_action ='CLSR_CDSL_MAK'                            
 BEGIN                            
 --           
  if @pa_values = ''      
  begin      
   SELECT CLSR_REASON_CD,@pa_id Exch,CLSR_BO_ID,CLSR_NEW_BO_ID,CLSR_RMKS,CLSR_ID ,CLSR_TRX_TYPE,CLSR_INI_BY,CLSR_REASON_CD,CLSR_REMAINING_BAL,CONVERT(VARCHAR(11),CLSR_DATE,103)       
   FROM CLOSURE_ACCT_CDSL_MAK                             
   WHERE CLSR_DELETED_IND IN (0,4,6)              
   and CLSR_DPM_ID =  @l_dpm_dpid       
   AND   CLSR_BO_ID LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd END       
  end      
  ELSE IF @pa_values <> ''       
  begin      
   SELECT CLSR_REASON_CD,@pa_id Exch,CLSR_BO_ID,CLSR_NEW_BO_ID,CLSR_RMKS,CLSR_ID ,CLSR_TRX_TYPE,CLSR_INI_BY,CLSR_REASON_CD,CLSR_REMAINING_BAL,CONVERT(VARCHAR(11),CLSR_DATE,103)       
   FROM CLOSURE_ACCT_CDSL_MAK                             
   WHERE CLSR_DELETED_IND IN (0,4,6)              
   and CLSR_DPM_ID =  @l_dpm_dpid       
   AND   CLSR_ID = @pa_values      
  end        
  --                          
 END       
       
 IF @pa_action ='CLSR_CDSL'                            
 BEGIN                            
 --           
 print @l_dpm_dpid      
  print @pa_cd      
  SELECT CLSR_REASON_CD,@pa_id Exch,CLSR_BO_ID,CLSR_NEW_BO_ID,CLSR_RMKS,CLSR_ID ,CLSR_TRX_TYPE,CLSR_INI_BY,CLSR_REASON_CD,CLSR_REMAINING_BAL,CONVERT(VARCHAR(11),CLSR_DATE,103)       
  FROM CLOSURE_ACCT_CDSL                           
  WHERE CLSR_DELETED_IND IN (1)              
  and CLSR_DPM_ID =  @l_dpm_dpid       
  AND   CLSR_BO_ID LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd END       
 end                     
                         
 IF @PA_ACTION ='MANCLICHARGE_CDSL_SEL'                        
 BEGIN                        
 --                        
   SELECT dpam.dpam_sba_no    AccountNo                   
           ,fina_acc_code  PostToAcct                        
           ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
           ,clic_charge_name  ChargeType                        
           ,clic_charge_amt   ChargeValue                        
           ,@pa_id                         
           ,clic_id                        
           ,fina_acc_id                        
   FROM client_charges_cdsl cliccdsl                        
         --,dp_mstr             dpm                        
         --,dp_acct_mstr        dpam                        
         --,exch_seg_mstr  excsm                        
         --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         ,fin_account_mstr                        
         , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
WHERE cliccdsl.clic_dpam_id = dpam.dpam_id                        
   --AND cliccdsl.clic_dpm_id = dpm.dpm_id                        
   --AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   --AND excsm_list.excsm_id      = excsm.excsm_id                         
   AND cliccdsl.clic_post_toacct =  fina_acc_id                        
   --AND dpm.dpm_deleted_ind =1                             
   --AND dpam.dpam_deleted_ind =1                        
   AND cliccdsl.clic_deleted_ind = 1                        
   AND fina_deleted_ind = 1                        
   --AND dpm.dpm_excsm_id  = convert(numeric,@pa_cd)                        
   AND cliccdsl.clic_trans_dt LIKE CASE WHEN ISNULL(@pa_desc,'')='' THEN cliccdsl.clic_trans_dt ELSE convert(datetime,@pa_desc,103) END                        
 --                        
 END                        
                         
 IF @PA_ACTION ='MANCLICHARGE_CDSL_SELM'                        
 BEGIN                        
 --                        
   IF @pa_values = ''                        
   BEGIN                       
   --                        
    SELECT dpam.dpam_sba_no    AccountNo                        
      ,fina_acc_code  PostToAcct                        
          ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
          ,clic_charge_name  ChargeType                        
          ,clic_charge_amt   ChargeValue                        
          ,@pa_id                         
          ,clic_id                        
          ,fina_acc_id                        
    FROM  client_charges_cdsl_mak cliccdsl                        
          --,dp_mstr             dpm                        
          --,dp_acct_mstr        dpam                        
          --,exch_seg_mstr  excsm                        
          --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,fin_account_mstr                        
          , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE cliccdsl.clic_dpam_id = dpam.dpam_id                        
    --AND cliccdsl.clic_dpm_id = dpm.dpm_id                        
    --AND dpm.dpm_excsm_id   = excsm.excsm_id                        
    --AND excsm_list.excsm_id      = excsm.excsm_id                          
    AND cliccdsl.clic_post_toacct =  fina_acc_id                        
    --AND dpm.dpm_deleted_ind =1                             
    --AND dpam.dpam_deleted_ind =1                        
    AND fina_deleted_ind = 1                        
    AND cliccdsl.clic_deleted_ind in (0,6)                        
    --AND dpm.dpm_excsm_id  = convert(numeric,@pa_cd)                        
    AND cliccdsl.clic_trans_dt LIKE CASE WHEN ISNULL(@pa_desc,'')='' THEN cliccdsl.clic_trans_dt ELSE convert(datetime,@pa_desc,103) END                        
  --                        
  END                        
  ELSE IF @pa_values <> ''                        
  BEGIN                        
  --                        
    SELECT dpam.dpam_sba_no    AccountNo                        
           ,fina_acc_code  PostToAcct                        
           ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
           ,clic_charge_name  ChargeType                        
           ,clic_charge_amt   ChargeValue                        
           ,@pa_id                            
           ,clic_id                        
           ,fina_acc_id                        
    FROM  client_charges_cdsl_mak cliccdsl                        
          --,dp_mstr             dpm                        
          --,dp_acct_mstr        dpam                        
          --,exch_seg_mstr  excsm                        
     --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          , fin_account_mstr      
          , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
    WHERE cliccdsl.clic_dpam_id = dpam.dpam_id                        
    --AND cliccdsl.clic_dpm_id = dpm.dpm_id                        
    --AND dpm.dpm_excsm_id   = excsm.excsm_id                        
    --AND excsm_list.excsm_id      = excsm.excsm_id                        
    AND cliccdsl.clic_post_toacct =  fina_acc_id                        
    --AND dpm.dpm_deleted_ind =1                             
    --AND dpam.dpam_deleted_ind =1                        
    AND fina_deleted_ind = 1                        
    AND cliccdsl.clic_deleted_ind in (0,4,6)                        
    AND cliccdsl.clic_id = convert(numeric,@pa_values)                         
                            
  --                        
  END                        
 --                        
 END                        
                         
 IF @PA_ACTION ='MANDPCHARGE_CDSL_SEL'                        
 BEGIN                        
 --                        
   SELECT fina_acc_code    PostToAcct                        
         ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
         ,dpch_charge_name    ChargeType                        
         ,dpch_charge_amt     ChargeValue                        
         ,dpm_excsm_id        excsmid             
         ,dpch_id                        
         ,fina_acc_id                        
   FROM dp_charges_cdsl dpchcdsl                        
        ,dp_mstr        dpm                         
        ,exch_seg_mstr  excsm                        
        ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        ,fin_account_mstr                        
   WHERE dpchcdsl.dpch_dpm_id = dpm.dpm_id                        
   AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   AND excsm_list.excsm_id      = excsm.excsm_id                
   AND dpchcdsl.dpch_post_toacct =  fina_acc_id                        
   AND dpchcdsl.dpch_deleted_ind =1                        
   AND dpm.dpm_deleted_ind =1                        
   AND fina_deleted_ind = 1                        
   AND dpm.dpm_excsm_id = convert(int,@pa_cd)                  
   AND dpchcdsl.dpch_tranc_dt  LIKE CASE WHEN ISNULL(@pa_desc,'') ='' THEN dpchcdsl.dpch_tranc_dt ELSE convert(datetime,@pa_desc,103) END                        
 --                        
 END                        
                         
 IF @PA_ACTION ='MANDPCHARGE_CDSL_SELM'                        
 BEGIN                    
 --       
   IF @pa_values =''                        
   BEGIN                        
   --                        
     SELECT fina_acc_code    PostToAcct         
           ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
           ,dpch_charge_name    ChargeType                        
           ,dpch_charge_amt     ChargeValue                        
           ,dpm_excsm_id        excsmid                        
           ,dpch_id                        
           ,fina_acc_id                        
     FROM dp_charges_cdsl_mak dpchcdsl                        
          ,dp_mstr        dpm                         
          ,exch_seg_mstr  excsm                        
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,fin_account_mstr                        
     WHERE dpchcdsl.dpch_dpm_id = dpm.dpm_id                        
     AND dpm.dpm_excsm_id   = excsm.excsm_id                        
     AND excsm_list.excsm_id      = excsm.excsm_id                        
     AND dpchcdsl.dpch_post_toacct =  fina_acc_id                        
     AND dpchcdsl.dpch_deleted_ind in (0,6)                        
     AND dpm.dpm_deleted_ind =1                        
     AND fina_deleted_ind = 1                        
     AND dpm.dpm_excsm_id = convert(int,@pa_cd)                        
     AND dpchcdsl.dpch_tranc_dt  LIKE CASE WHEN ISNULL(@pa_desc,'') ='' THEN dpchcdsl.dpch_tranc_dt ELSE convert(datetime,@pa_desc,103) END                        
   --                        
   END                        
   IF @pa_values <> ''                        
   BEGIN                        
   --                        
     SELECT fina_acc_code    PostToAcct                        
            ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
            ,dpch_charge_name    ChargeType                        
            ,dpch_charge_amt     ChargeValue                        
            ,dpm_excsm_id        excsmid                        
            ,dpch_id                        
            ,fina_acc_id                        
     FROM dp_charges_cdsl_mak dpchcdsl                        
          ,dp_mstr        dpm                         
          ,exch_seg_mstr  excsm                        
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,fin_account_mstr                        
     WHERE dpchcdsl.dpch_dpm_id = dpm.dpm_id                        
     AND dpm.dpm_excsm_id   = excsm.excsm_id                        
     AND excsm_list.excsm_id      = excsm.excsm_id                        
     AND dpchcdsl.dpch_post_toacct =  fina_acc_id                        
     AND fina_deleted_ind = 1                        
     AND dpchcdsl.dpch_deleted_ind in (0,4,6)                        
     AND dpm.dpm_deleted_ind =1     
     AND dpchcdsl.dpch_lst_upd_by <> @pa_login_name                        
   --                        
   END                        
 --                        
 END                        
                          
 IF @PA_ACTION ='MANCLICHARGE_NSDL_SEL'                        
 BEGIN                        
 --                        
   SELECT dpam.dpam_sba_no    AccountNo                        
         ,fina_acc_code  PostToAcct                        
         ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
         ,clic_charge_name  ChargeType                        
         ,clic_charge_amt   ChargeValue                        
         ,@pa_id                            
         ,clic_id                        
         ,fina_acc_id                        
   FROM client_charges_nsdl clicnsdl                        
       --,dp_mstr             dpm                        
       --,dp_acct_mstr        dpam                        
       --,exch_seg_mstr  excsm                        
       --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
       ,fin_account_mstr                        
       , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam              
   WHERE clicnsdl.clic_dpam_id = dpam.dpam_id                        
   --AND clicnsdl.clic_dpm_id = dpm.dpm_id                  
   --AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   --AND excsm_list.excsm_id      = excsm.excsm_id                          
   AND clicnsdl.clic_post_toacct =  fina_acc_id                          
   --AND dpm.dpm_deleted_ind =1                             
   --AND dpam.dpam_deleted_ind =1                        
   AND clicnsdl.clic_deleted_ind = 1                        
   AND fina_deleted_ind = 1                        
   --AND dpm.dpm_excsm_id  = convert(numeric,@pa_cd)                        
   AND clicnsdl.clic_trans_dt LIKE CASE WHEN ISNULL(@pa_desc,'')='' THEN clicnsdl.clic_trans_dt ELSE convert(datetime,@pa_desc,103) END                        
 --                        
 END                        
                         
                         
 IF @PA_ACTION ='MANCLICHARGE_NSDL_SELM'                        
 BEGIN                        
 --                        
   IF @pa_values =''                        
   BEGIN                        
   --                        
     SELECT dpam.dpam_sba_no    AccountNo                        
            ,fina_acc_code  PostToAcct                        
           ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
            ,clic_charge_name  ChargeType                        
            ,clic_charge_amt   ChargeValue                        
            ,@pa_id                            
            ,clic_id                        
            ,fina_acc_id                        
     FROM client_charges_nsdl_mak clicnsdl                        
         --,dp_mstr             dpm                        
         --,dp_acct_mstr        dpam                        
         --,exch_seg_mstr  excsm                        
         --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         ,fin_account_mstr                        
         ,citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                            
     WHERE clicnsdl.clic_dpam_id = dpam.dpam_id                        
     --AND clicnsdl.clic_dpm_id = dpm.dpm_id                        
     --AND dpm.dpm_excsm_id   = excsm.excsm_id                        
     --AND excsm_list.excsm_id      = excsm.excsm_id                          
     AND clicnsdl.clic_post_toacct =  fina_acc_id                         
     --AND dpm.dpm_deleted_ind =1                             
     --AND dpam.dpam_deleted_ind =1                        
     AND fina_deleted_ind = 1                        
     AND clicnsdl.clic_deleted_ind in (0,6)                        
     --AND dpm.dpm_excsm_id  = convert(numeric,@pa_cd)                        
     AND clicnsdl.clic_trans_dt LIKE CASE WHEN ISNULL(@pa_desc,'')='' THEN clicnsdl.clic_trans_dt ELSE convert(datetime,@pa_desc,103) END                        
   --                        
   END                        
   IF @pa_values <> ''                        
   BEGIN                        
   --                        
     SELECT dpam.dpam_sba_no    AccountNo                        
      ,fina_acc_code  PostToAcct                        
           ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
           ,clic_charge_name  ChargeType                        
           ,clic_charge_amt   ChargeValue                        
           ,@pa_id                            
           ,clic_id                        
           ,fina_acc_id                        
     FROM client_charges_nsdl_mak clicnsdl                        
         --,dp_mstr             dpm                        
         --,dp_acct_mstr        dpam                        
         --,exch_seg_mstr  excsm                        
         --, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         , fin_account_mstr                        
         , citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                        
     WHERE clicnsdl.clic_dpam_id = dpam.dpam_id                        
     --AND clicnsdl.clic_dpm_id = dpm.dpm_id                        
     --AND dpm.dpm_excsm_id   = excsm.excsm_id                        
     --AND excsm_list.excsm_id      = excsm.excsm_id                        
     AND clicnsdl.clic_post_toacct =  fina_acc_id                         
     --AND dpm.dpm_deleted_ind =1                             
     --AND dpam.dpam_deleted_ind =1                        
     AND fina_deleted_ind = 1                        
     AND clicnsdl.clic_deleted_ind in (0,4,6)                        
     AND clicnsdl.clic_lst_upd_by <> @pa_login_name                        
   --                        
  END                        
 --                        
 END                        
                         
 IF @PA_ACTION ='MANDPCHARGE_NSDL_SEL'                        
 BEGIN                        
 --                        
   SELECT fina_acc_code    PostToAcct                        
         ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
         ,dpch_charge_name    ChargeType                        
         ,dpch_charge_amt     ChargeValue                        
        ,dpm_excsm_id        excsmid                        
         ,dpch_id                        
         ,fina_acc_id                        
   FROM dp_charges_nsdl dpchnsdl                        
        ,dp_mstr        dpm                   
        ,exch_seg_mstr  excsm                        
        ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        ,fin_account_mstr                        
   WHERE dpchnsdl.dpch_dpm_id = dpm.dpm_id                        
   AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   AND excsm_list.excsm_id      = excsm.excsm_id                        
   AND dpchnsdl.dpch_post_toacct =  fina_acc_id                         
   AND dpchnsdl.dpch_deleted_ind =1                        
   AND dpm.dpm_deleted_ind =1                        
   AND fina_deleted_ind = 1                        
   AND dpm.dpm_excsm_id = convert(int,@pa_cd)                        
 AND dpchnsdl.dpch_tranc_dt  LIKE CASE WHEN ISNULL(@pa_desc,'') ='' THEN dpchnsdl.dpch_tranc_dt ELSE convert(datetime,@pa_desc,103) END                        
 --                        
 END                        
                         
 IF @PA_ACTION ='MANDPCHARGE_NSDL_SELM'                        
 BEGIN                        
 --                        
   IF @pa_values = ''                        
   BEGIN                        
   --                        
     SELECT  fina_acc_code    PostToAcct                        
             ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
             ,dpch_charge_name    ChargeType                        
             ,dpch_charge_amt     ChargeValue                        
             ,dpm_excsm_id        excsmid                        
      ,dpch_id                        
             ,fina_acc_id                        
     FROM dp_charges_nsdl_mak dpchnsdl                        
          ,dp_mstr        dpm                         
          ,exch_seg_mstr  excsm                        
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,fin_account_mstr                        
     WHERE dpchnsdl.dpch_dpm_id = dpm.dpm_id                        
     AND dpm.dpm_excsm_id   = excsm.excsm_id                        
     AND excsm_list.excsm_id      = excsm.excsm_id                        
     AND dpchnsdl.dpch_post_toacct =  fina_acc_id                         
     AND dpchnsdl.dpch_deleted_ind in (0,6)                        
     AND dpm.dpm_deleted_ind =1                        
     AND fina_deleted_ind = 1                        
     AND dpm.dpm_excsm_id = convert(int,@pa_cd)                        
     AND dpchnsdl.dpch_tranc_dt  LIKE CASE WHEN ISNULL(@pa_desc,'') ='' THEN dpchnsdl.dpch_tranc_dt ELSE convert(datetime,@pa_desc,103) END                        
   --                        
   END                        
   IF @pa_values <> ''                        
   BEGIN                        
   --                        
     SELECT fina_acc_code    PostToAcct                        
            ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
            ,dpch_charge_name    ChargeType                        
            ,dpch_charge_amt     ChargeValue                        
            ,dpm_excsm_id        excsmid                        
            ,dpch_id                        
            ,fina_acc_id                        
     FROM  dp_charges_nsdl_mak dpchnsdl                        
          ,dp_mstr        dpm                         
        ,exch_seg_mstr  excsm                        
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
          ,fin_account_mstr                        
     WHERE dpchnsdl.dpch_dpm_id = dpm.dpm_id                        
     AND dpm.dpm_excsm_id   = excsm.excsm_id                        
     AND excsm_list.excsm_id      = excsm.excsm_id                        
     AND dpchnsdl.dpch_post_toacct =  fina_acc_id                        
     AND dpchnsdl.dpch_deleted_ind in (0,4,6)                        
     AND fina_deleted_ind = 1                        
     AND dpm.dpm_deleted_ind =1                        
     AND dpchnsdl.dpch_lst_upd_by <> @pa_login_name                
   --                        
   END                        
 --                        
 END                        
                         
 IF @PA_ACTION ='MANDPCHARGE_NSDL_SELC'                        
 BEGIN                        
 --                        
   SELECT   ''                  AccountNo                        
            ,fina_acc_code    PostToAcct                        
            ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
            ,dpch_charge_name    ChargeType                        
            ,abs(dpch_charge_amt)     ChargeValue                        
            ,dpch_id             id                        
            ,dpch_deleted_ind    deleted_ind                        
   FROM dp_charges_nsdl_mak dpchnsdl                        
        ,dp_mstr        dpm                         
        ,exch_seg_mstr  excsm                        
        ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        ,fin_account_mstr                        
   WHERE dpchnsdl.dpch_dpm_id = dpm.dpm_id                        
   AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   AND excsm_list.excsm_id      = excsm.excsm_id                        
   AND dpchnsdl.dpch_post_toacct =  fina_acc_id                        
   AND dpchnsdl.dpch_deleted_ind in (0,4,6)                        
   AND dpm.dpm_deleted_ind =1                        
   AND fina_deleted_ind = 1                        
   AND dpm.dpm_excsm_id = convert(int,@pa_cd)                        
   AND dpchnsdl.dpch_lst_upd_by <> @pa_login_name                         
 --                        
 END                        
                         
 IF @PA_ACTION ='MANCLICHARGE_NSDL_SELC'                        
 BEGIN                        
 --                        
   SELECT dpam.dpam_sba_no    AccountNo                        
            ,fina_acc_code  PostToAcct                 
            ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
            ,clic_charge_name  ChargeType                        
            ,abs(clic_charge_amt)   ChargeValue                        
            ,clic_id           id                        
            ,clic_deleted_ind    deleted_ind                        
   FROM  client_charges_nsdl_mak cliccdsl                        
         ,dp_mstr             dpm                        
         ,dp_acct_mstr        dpam                        
         ,exch_seg_mstr  excsm                        
         , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         ,fin_account_mstr                        
   WHERE cliccdsl.clic_dpam_id = dpam.dpam_id                        
   AND cliccdsl.clic_dpm_id = dpm.dpm_id                        
   AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   AND excsm_list.excsm_id      = excsm.excsm_id                         
   AND cliccdsl.clic_post_toacct =  fina_acc_id                        
   AND fina_deleted_ind = 1                        
   AND dpm.dpm_deleted_ind =1                             
   AND dpam.dpam_deleted_ind =1                        
   AND cliccdsl.clic_deleted_ind in (0,4,6)                        
   AND dpm.dpm_excsm_id  = convert(numeric,@pa_cd)                        
   AND  cliccdsl.clic_lst_upd_by <> @pa_login_name                         
 --                        
 END                        
                         
 IF @PA_ACTION ='MANDPCHARGE_CDSL_SELC'                        
 BEGIN                        
 --                        
   SELECT  ''                  AccountNo                        
           ,fina_acc_code    PostToAcct                        
           ,convert(varchar(11),dpch_tranc_dt,103) ChargeAppDate                        
           ,dpch_charge_name    ChargeType                        
           ,abs(dpch_charge_amt)     ChargeValue                        
           ,dpch_id             id                        
           ,dpch_deleted_ind    deleted_ind                        
   FROM dp_charges_cdsl_mak dpchnsdl                        
        ,dp_mstr        dpm                         
        ,exch_seg_mstr  excsm                        
        ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
        ,fin_account_mstr                        
   WHERE dpchnsdl.dpch_dpm_id = dpm.dpm_id                        
   AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   AND excsm_list.excsm_id      = excsm.excsm_id                        
   AND dpchnsdl.dpch_post_toacct =  fina_acc_id                        
   AND dpchnsdl.dpch_deleted_ind in (0,4,6)                        
   AND dpm.dpm_deleted_ind =1                        
   AND fina_deleted_ind = 1                        
   AND dpm.dpm_excsm_id = convert(int,@pa_cd)                        
   AND dpchnsdl.dpch_lst_upd_by <> @pa_login_name                         
 --                        
 END                        
                         
 IF @PA_ACTION ='MANCLICHARGE_CDSL_SELC'                        
 BEGIN                        
 --                        
   SELECT dpam.dpam_sba_no    AccountNo                        
            ,fina_acc_code  PostToAcct                        
            ,convert(varchar(11),clic_trans_dt,103) ChargeAppDate                        
            ,clic_charge_name  ChargeType                        
  ,abs(clic_charge_amt)   ChargeValue                        
            ,clic_id           id                        
            ,clic_deleted_ind    deleted_ind                        
   FROM  client_charges_cdsl_mak cliccdsl                        
         ,dp_mstr             dpm                     
         ,dp_acct_mstr        dpam                        
         ,exch_seg_mstr  excsm                        
         , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
         ,fin_account_mstr                        
   WHERE cliccdsl.clic_dpam_id = dpam.dpam_id                        
   AND cliccdsl.clic_dpm_id = dpm.dpm_id                        
   AND dpm.dpm_excsm_id   = excsm.excsm_id                        
   AND excsm_list.excsm_id      = excsm.excsm_id                         
   AND cliccdsl.clic_post_toacct =  fina_acc_id                        
   AND dpm.dpm_deleted_ind =1                             
   AND dpam.dpam_deleted_ind =1                        
   AND fina_deleted_ind = 1                        
   AND cliccdsl.clic_deleted_ind in (0,4,6)                        
   AND dpm.dpm_excsm_id  = convert(numeric,@pa_cd)                        
   AND cliccdsl.clic_lst_upd_by <> @pa_login_name                         
 --                        
 END                        
                         
                         
                         
 IF @PA_ACTION = 'CHECKSLIPNO'                        
 BEGIN                        
 --                        
   declare @l_dpmid numeric                        
   SELECT @l_dpmid = dpm_id from dp_mstr  where dpm_dpid= @pa_id and dpm_deleted_ind = 1                        
                           
  IF @pa_desc <> ''                        
  BEGIN                        
  --                        
                        
    SELECT  sliim_id                         
    FROM slip_issue_mstr                        
    WHERE sliim_dpm_id =@l_dpmid                         
    AND sliim_tratm_id=@pa_cd                        
    AND sliim_dpam_acct_no = @pa_desc                        
    AND isnull(@pa_rmks,sliim_series_type) =  sliim_series_type                        
    AND CONVERT(NUMERIC,@pa_values)  between sliim_slip_no_fr  and sliim_slip_no_to                         
    AND sliim_deleted_ind = 1                             
 --                        
 END                        
 ELSE         
 BEGIN                        
 --       
                
   SELECT  sliim_id                         
   FROM slip_issue_mstr                        
   WHERE sliim_dpm_id =@l_dpmid                         
   AND sliim_tratm_id=@pa_cd                        
   AND isnull(@pa_rmks,sliim_series_type) =  sliim_series_type                        
   AND CONVERT(NUMERIC,@pa_values)  between sliim_slip_no_fr  and sliim_slip_no_to                         
   AND sliim_deleted_ind = 1                             
 --                        
  END                        
                          
 --                        
END                        
                        
IF @PA_ACTION = 'DESTRSLIP_SEL'                        
BEGIN                        
--      
----added by mayur 
if @pa_desc = '1'
begin
set  @pa_desc = @pa_values
end
-----added by mayur as per req

print @l_dpm_dpid      
  print @l_entm_id      
   SELECT distinct compm_short_name +'-'+ excsm_exch_cd+'-'+excsm_seg_cd+'-'+dpm_dpid COMPANY                         
   ,FORTYPE=case when uses_used_destr='b' then 'BLOCK' else 'DESTROY' END                        
   ,trastm_desc           CATEGORY                         
   ,uses_dpam_acct_no       ACCOUNTNO                            
   ,uses_series_type        SERIESTYPE                                    
   ,uses_slip_no            SLIPNO                        
   ,uses_id           
   ,uses_slipremarks                                  
   FROM   used_slip left outer join citrus_usr.fn_acct_list(@l_dpm_dpid,@l_entm_id,0) dpam                         
   on uses_dpam_acct_no = dpam.dpam_sba_no                        
   ,transaction_sub_type_mstr                          
   ,company_mstr                               
   ,exch_seg_mstr   EXCSM                        
   ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                        
   ,dp_mstr                          
                        
   WHERE uses_trantm_id = trastm_cd                        
   AND    dpm_excsm_id       = excsm.excsm_id                          
   AND    excsm_list.excsm_id      = excsm.excsm_id                    
   AND    excsm_compm_id          = compm_id                            
   AND    dpm_id                  = uses_dpm_id                        
   and    dpm_excsm_id   = @pa_id                        
   and    uses_used_destr = @pa_cd                        
   and    trastm_id = convert(numeric,@rowdelimiter)                        
   AND    uses_deleted_ind = 1                        
   and    dpm_deleted_ind = 1                        
   and    trastm_deleted_ind = 1                        
   and    excsm_deleted_ind = 1                        
   and    compm_deleted_ind = 1                        
   AND    uses_series_type LIKE CASE WHEN LTRIM(RTRIM(@pa_rmks)) = '' THEN '%' ELSE @pa_rmks END                        
   and    uses_slip_no between convert(numeric,@pa_desc) and convert(numeric,@pa_values)                                  
   and    right(USES_DPAM_ACCT_NO,8) like case when @coldelimiter <> '' then @coldelimiter else '%' end      
                  
--                        
END                        
                        
IF @PA_ACTION = 'ISINEXCEPTION_SEL'                             
BEGIN                            
--                            
 SELECT isinem_isin_cd ISINCODE                            
  ,EXCEPTIONTYPE = case when isinem_excep_type='B' THEN 'BARRED' ELSE 'LONG PENDING' END                            
  ,isinem_id                            
 FROM  isin_exception_mstr                            
 WHERE isinem_isin_cd LIKE CASE WHEN LTRIM(RTRIM(@pa_id)) = '' THEN '%' ELSE @pa_id END                              
 AND   isinem_excep_type LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE @pa_cd END                              
 AND isinem_deleted_ind = 1                          
                         
--              
END                           
if @PA_ACTION = 'GETREASONCD'                            
  BEGIN                          
  --                          
    SELECT trastm_id                               
          ,trastm_cd  code                            
          ,trastm_desc  description               
    FROM   transaction_type_mstr      trantm                            
          ,transaction_sub_type_mstr  trastm                            
          ,exchange_mstr              excm                            
          ,exch_seg_mstr              exsegm                            
          ,citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                            
    WHERE  trantm.trantm_excm_id     = excm.excm_id                            
    AND    trantm.trantm_id          = trastm.trastm_tratm_id                            
    AND    trantm.trantm_code        = 'OFFM_RSN_CD'                           
    and  excm.excm_cd              = exsegm.excsm_exch_cd                            
    AND    excsm_list.excsm_id       = exsegm.excsm_id                            
    AND    trantm.trantm_deleted_ind = 1                            
  --                          
  END                           
                          
  IF @PA_ACTION = 'SLIPNO_SEL'                        
  BEGIN                        
  --                        
    DECLARE @slipno numeric                        
    SELECT @slipno = slibm_no_of_slips                        
    FROM slip_book_mstr                        
    WHERE isnull(@pa_cd,slibm_series_type) =  slibm_series_type                        
    AND slibm_tratm_id = convert(numeric,@pa_id)                        
    --AND slibm_id = convert(numeric,@pa_desc)                        
    AND slibm_deleted_ind = 1                        
                            
    IF exists(select top 1 sliim_slip_no_to from slip_issue_mstr where sliim_tratm_id = convert(numeric,@pa_id)  and sliim_series_type = @pa_cd and sliim_deleted_ind = 1 )                        
    BEGIN                        
    --                        
                            
      SELECT MAX(sliim_slip_no_to) + 1 slipnofrom                        
          ,@slipno                         
      FROM slip_issue_mstr                         
      WHERE sliim_series_type = @pa_cd                        
      AND sliim_tratm_id = convert(numeric,@pa_id)                              
      AND sliim_deleted_ind = 1                        
    --                        
    END                        
    ELSE                        
    BEGIN                        
    --                        
      SELECT slibm_from_no  slipnofrom                        
            ,@slipno                         
      FROM slip_book_mstr                        
      WHERE slibm_series_type = @pa_cd                        
      AND slibm_tratm_id = convert(numeric,@pa_id)            
      --AND slibm_id = convert(numeric,@pa_desc)                     
      AND slibm_deleted_ind = 1                        
    --                        
    END                        
  --                        
  END                        
  IF @PA_ACTION = 'GETDORMANTCLTMSG'                        
  BEGIN                        
  --                        
 /*                       
      SELECT TOP 1 * FROM NSDL_HOLDING_DTLS                         
           WHERE NSDHM_BEN_ACCT_NO = @pa_id                        
           AND                         
           NSDHM_TRANSACTION_DT <= DATEADD(m,-6,@pa_values)          
*/        
        
   if isnull(@pa_cd,'') <> '0'        
   begin        
      if not exists(SELECT TOP 1 NSDHM_BEN_ACCT_NO FROM NSDL_HOLDING_DTLS         
      WHERE NSDHM_BEN_ACCT_NO = @pa_id        
      and NSDHM_TRANSACTION_DT >= DATEADD(m,-6,@pa_values) and NSDHM_TRANSACTION_DT <= @pa_values)        
      begin        
       select @pa_id accno        
      end        
      else        
      begin        
       select top 1 accno='' from DMAT_SETTING where 1=2        
      end        
   END        
   else        
   begin        
      if not exists(SELECT TOP 1 CDSHM_BEN_ACCT_NO FROM CDSL_HOLDING_DTLS         
      WHERE right(CDSHM_BEN_ACCT_NO,8) = right(@pa_id,8)        
      and CDSHM_TRAS_DT >= DATEADD(m,-6,@pa_values) and CDSHM_TRAS_DT <= @pa_values)        
      begin        
       select @pa_id accno        
      end        
      else        
      begin        
       select top 1 accno='' from DMAT_SETTING where 1=2        
      end        
        
   end        
        
                       
  --                        
     END                        
                        
 IF @PA_ACTION = 'CLT_LOGN_DEMAT_DTLS'                        
  BEGIN                        
  --                        
    SELECT DPM_NAME + '-' + DPM_DPID DP, DPAM_SBA_NO FROM DP_ACCT_MSTR,DP_MSTR WHERE                         
    DPAM_CRN_NO         = @PA_ID                        
    AND DPAM_EXCSM_ID   = DPM_EXCSM_ID                        
    AND DEFAULT_DP      = DPM_EXCSM_ID                        
  --                        
     END                        
                        
 IF @PA_ACTION = 'CLT_LOGN_BANK_DTLS'                        
  BEGIN                        
  --                        
   SELECT CLIBA_AC_NAME,CLIBA_AC_NO,CLIBA_AC_TYPE FROM CLIENT_MSTR,DP_ACCT_MSTR,DP_MSTR,CLIENT_BANK_ACCTS WHERE                         
   CLIM_CRN_NO         = DPAM_CRN_NO                        
   AND DPAM_EXCSM_ID   = DPM_EXCSM_ID                        
   AND DEFAULT_DP      = DPM_EXCSM_ID                        
   AND CLIBA_CLISBA_ID = DPAM_ID                      
   AND DPAM_CRN_NO     = @PA_ID                        
  --                        
     END                        
                        
 IF @PA_ACTION = 'CLT_LOGN_DP_FILL'                        
  BEGIN                        
  --                        
   SELECT COMPM_SHORT_NAME + '-' + EXCSM_EXCH_CD + '-' + EXCSM_SUB_SEG_CD + '-' + DPM_DPID + '-' + DPAM_SBA_NO AS COMP , EXCSM_ID  ID                        
            FROM EXCH_SEG_MSTR,COMPANY_MSTR,DP_MSTR,DP_ACCT_MSTR  WHERE EXCSM_EXCH_CD IN ('CDSL','NSDL')                        
            AND EXCSM_COMPM_ID   = COMPM_ID                        
            AND DPM_EXCSM_ID  = EXCSM_ID                        
            AND DPM_EXCSM_ID     = DEFAULT_DP                        
            AND DPAM_CRN_NO      = @PA_ID                        
            AND DPAM_EXCSM_ID    = EXCSM_ID      
            AND DPAM_DELETED_IND = 1                        
  --                        
     END                        
                        
 IF @PA_ACTION = 'CLT_LOGN_LDGR_DP_FILL'                        
 BEGIN                        
 --                        
  SELECT COMPM_SHORT_NAME + '-' + EXCSM_EXCH_CD + '-' + EXCSM_SUB_SEG_CD + '-' + DPM_DPID + '-' + DPAM_SBA_NO AS COMP                      
,  CONVERT(VARCHAR,dpm_id) + '|*~|' + CONVERT(VARCHAR(11),fin_start_dt,109) + '|*~|' +  CONVERT(VARCHAR(11),fin_end_dt,109) + '|*~|' + CONVERT(VARCHAR,fin_id)  + '|*~|' + CONVERT(VARCHAR,EXCSM_ID)  + '|*~|'  id                       
  FROM EXCH_SEG_MSTR,COMPANY_MSTR,DP_MSTR,FINANCIAL_YR_MSTR FINY,DP_ACCT_MSTR  WHERE EXCSM_EXCH_CD IN ('CDSL','NSDL')                        
  AND EXCSM_COMPM_ID = COMPM_ID                        
  AND DPM_EXCSM_ID = EXCSM_ID                        
  AND DPM_EXCSM_ID = DEFAULT_DP                        
  AND FINY.FIN_DPM_ID = DPM_ID                        
  AND CONVERT(DATETIME,@PA_VALUES,103) BETWEEN  FIN_START_DT  AND FIN_END_DT                        
  AND DPAM_CRN_NO = @PA_ID                        
  AND DPAM_EXCSM_ID = EXCSM_ID                        
  AND DPAM_DELETED_IND = 1                        
 --                        
 END             
                       
 IF @PA_ACTION = 'CLIENT_INFO'                        
 BEGIN                        
 --                        
   declare @l_adr varchar(8000)                        
    ,@l_crn_no numeric                        
          ,@l_acc_adr varchar(8000)                        
             ,@l_dpm_id  numeric                        
             ,@l_dpm varchar(20)     ,@l_brom_desc varchar(50)                      
                                  
   select @l_crn_no  = dpam_crn_no ,@l_dpm_id = dpam_dpm_id from dp_acct_mstr where dpam_id =@pa_cd and dpam_deleted_ind = 1                         
      select @l_dpm = left(ltrim(rtrim(dpm_dpid)),2) from dp_mstr where dpm_id = @l_dpm_id and dpm_deleted_ind = 1                        
   select @l_acc_adr  = citrus_usr.[fn_acct_addr_value](@pa_cd,'ACC_COR_ADR1')                        
                           
   if @l_acc_adr  = ''                         
   begin                        
   set @l_adr = citrus_usr.fn_addr_value(@l_crn_no,'COR_ADR1')                      if @l_adr = ''                        
        begin                        
           set @l_adr = citrus_usr.fn_addr_value(@l_crn_no,'PER_ADR1')                        
        end                        
   end                        
   else                        
   begin                        
set @l_adr = @l_acc_adr                        
   end                        
                           

 
   select top 1 @l_brom_desc= isnull(brom_desc,'') from BROKERAGE_MSTR,CLIENT_DP_BRKG where CLIDB_BROM_ID=BROM_ID and CLIDB_DELETED_IND=1
   and BROM_DELETED_IND=1 and CLIDB_DPAM_ID=@pa_cd and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100')
   
   if(@pa_desc = 'NOCLOSE')
   begin
		select stam_desc [STATUS]                        
			 ,case when @l_dpm = 'IN' then enttm_desc else clicm_desc end  [Category]                        
			 ,case when @l_dpm = 'IN' then citrus_usr.fn_getnsdltypedtls(subcm_cd,'S') else subcm_desc end  [Sub-Category]                        
			 ,case when @l_dpm = 'IN' then citrus_usr.fn_getnsdltypedtls(subcm_cd,'T') else enttm_desc end   [Type]                        
			 , Isnull(citrus_usr.fn_splitval(@l_adr,1),'')   [ADDRESS1]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,2),'') [ADDRESS2]                
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,3),'') [ADDRESS3]                         
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,4),'') [CITY]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,5),'') [STATE]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,6),'') [COUNTRY]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,7),'') [PIN CODE]        
			 ,isnull(dphd_sh_fname,'') + ' '+ isnull(dphd_sh_mname,'') +' '+ isnull(dphd_sh_lname,'') [Second Holder Name]                        
			 ,isnull(dphd_th_fname,'') + ' '+isnull(dphd_th_mname,'') + ' '+isnull(dphd_th_lname,'') [Third Holder Name]               
			 ,isnull(dphd_sh_fname,'') + ' '+isnull(dphd_sh_mname,'') + ' '+isnull(dphd_sh_lname,'') [Second Holder Name]                        
			--,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]        
			-- ,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]        
	--,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'res_PH1'),'')  [res_ph1]       
	,case when PriPhInd <> 'M' then isnull(PriPhNum,'') else '' end [off_ph]
	,case when PriPhInd = 'M' then isnull(PriPhNum,'') when AltPhInd = 'M' then isnull(AltPhNum,'') else '' end [mobile]    
	, isnull(AltPhNum,'') [res_ph1] 
	,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') cmbpid 
	,isnull(DPAM_BBO_CODE,'') bbocode
	,'' branch     ,isnull(@l_brom_desc,'') template
	, isnull(citrus_usr.fn_ucc_accp(dpam_id,'CLIENT GST',''),'') GST_no
	   from dps8_pc1,dp_acct_mstr                         
	   left outer join                         
	   dp_holder_dtls on dphd_dpam_id = dpam_id and dphd_deleted_ind = 1                        
	   ,client_ctgry_mstr                        
	   ,entity_type_mstr            
	   ,status_mstr                        
	   ,sub_ctgry_mstr                         
	   where dpam_id  = convert(numeric,@pa_cd) 

	and boid = dpam_sba_no                       
	   and   dpam_clicm_cd = clicm_cd                         
	   and   dpam_enttm_cd = enttm_Cd                        
	   and   dpam_stam_cd  = stam_cd                        
	   and   dpam_subcm_cd  = subcm_cd                        
	   and   clicm_id = subcm_clicm_id  
	   and   dpam_stam_cd ='05'   
   end
   else
   begin                           
	   select stam_desc [STATUS]                        
			 ,case when @l_dpm = 'IN' then enttm_desc else clicm_desc end  [Category]                        
			 ,case when @l_dpm = 'IN' then citrus_usr.fn_getnsdltypedtls(subcm_cd,'S') else subcm_desc end  [Sub-Category]                        
			 ,case when @l_dpm = 'IN' then citrus_usr.fn_getnsdltypedtls(subcm_cd,'T') else enttm_desc end   [Type]                        
			 , Isnull(citrus_usr.fn_splitval(@l_adr,1),'')   [ADDRESS1]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,2),'') [ADDRESS2]                
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,3),'') [ADDRESS3]                         
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,4),'') [CITY]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,5),'') [STATE]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,6),'') [COUNTRY]                        
			 ,Isnull(citrus_usr.fn_splitval(@l_adr,7),'') [PIN CODE]        
			 ,isnull(dphd_sh_fname,'') + ' '+ isnull(dphd_sh_mname,'') +' '+ isnull(dphd_sh_lname,'') [Second Holder Name]                        
			 ,isnull(dphd_th_fname,'') + ' '+isnull(dphd_th_mname,'') + ' '+isnull(dphd_th_lname,'') [Third Holder Name]               
			 ,isnull(dphd_sh_fname,'') + ' '+isnull(dphd_sh_mname,'') + ' '+isnull(dphd_sh_lname,'') [Second Holder Name]                        
			--,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]        
			-- ,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]        
	--,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'res_PH1'),'')  [res_ph1]       
	,case when PriPhInd <> 'M' then isnull(PriPhNum,'') else '' end [off_ph]
	,case when PriPhInd = 'M' then isnull(PriPhNum,'') when AltPhInd = 'M' then isnull(AltPhNum,'') else '' end [mobile]    
	, isnull(AltPhNum,'') [res_ph1] 
	,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') cmbpid 
	,isnull(DPAM_BBO_CODE,'') bbocode
	,'' branch     ,isnull(@l_brom_desc,'') template
	, isnull(citrus_usr.fn_ucc_accp(dpam_id,'CLIENT GST',''),'') GST_no
	   from dps8_pc1,dp_acct_mstr                         
	   left outer join                         
	   dp_holder_dtls on dphd_dpam_id = dpam_id and dphd_deleted_ind = 1                        
	   ,client_ctgry_mstr                        
	   ,entity_type_mstr            
	   ,status_mstr                        
	   ,sub_ctgry_mstr                         
	   where dpam_id  = convert(numeric,@pa_cd) 

	and boid = dpam_sba_no                       
	   and   dpam_clicm_cd = clicm_cd                         
	   and   dpam_enttm_cd = enttm_Cd                        
	   and   dpam_stam_cd  = stam_cd                        
	   and   dpam_subcm_cd  = subcm_cd                        
	   and   clicm_id = subcm_clicm_id   
   end                     
 --                        
 END                        
 IF @PA_ACTION = 'SETM_DEADLN_TIME'                        
 BEGIN                        
 --                        
      if isnumeric(@pa_cd) = 1                        
      begin                        
  SELECT case when datediff(n,getdate(),convert(varchar(11),setm.setm_deadline_dt,109) + ' ' + left(replACE(setm.setm_deadline_time,':',''),2) + ':' + substring(replACE(setm.setm_deadline_time,':',''),3,2)) < 0 then 'N'                         
        else case when datediff(n,getdate(),convert(varchar(11),setm.setm_deadline_dt,109) + ' ' + left(replACE(setm.setm_deadline_time,':',''),2) + ':' + substring(replACE(setm.setm_deadline_time,':',''),3,2)) > 30 then 'N'                         
        else convert(varchar,datediff(n,getdate(),convert(varchar(11),setm.setm_deadline_dt,109) + ' ' + left(replACE(setm.setm_deadline_time,':',''),2) + ':' + substring(replACE(setm.setm_deadline_time,':',''),3,2))) end end       DeadLineDate          
  
    
      
      
              
         
  FROM  settlement_mstr     setm                        
       ,settlement_type_mstr  settm                              
  WHERE settm.settm_id = setm.setm_settm_id                        
  AND setm.setm_excm_id = settm.settm_excm_id                        
        AND settm.settm_id = @pa_cd                        
  AND setm.setm_no = @pa_desc                        
      end                        
                                
 --                       
 END                         
 IF @PA_ACTION = 'STATREPOTRAN_NSDL'                        
 BEGIN                        
 --                        
  SELECT cd                
        ,descp                        
  FROM citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL')                          
 --                        
 END                        
 IF @PA_ACTION = 'STATREPOTRAN_CDSL'                        
  BEGIN                        
  --                        
   SELECT cd,descp FROM citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_CDSL')                         
   UNION                        
   SELECT cd,descp FROM citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_CDSL')                        
   ORDER BY CD,DESCP                        
  --                        
 END                        
 IF @PA_ACTION = 'TRANREPOSTATUS'                        
 BEGIN                        
 --                        
  DECLARE @l_temp table(ttype_cd varchar(5),status_cd varchar(5),status_descp varchar(50))                                       
                                
  INSERT INTO @l_temp                                      
  SELECT  Ttype_cd=ltrim(rtrim(Replace(trantm_code, 'TRANS_STAT_NSDL_',''))),TRASTM_CD AS status_cd,TRASTM_DESC AS status_descp                                         
  FROM  TRANSACTION_TYPE_MSTR,                                        
  TRANSACTION_SUB_TYPE_MSTR                                        
  WHERE TRANTM_CODE like  'TRANS_STAT_NSDL_%'                                      
  AND TRANTM_ID   =  TRASTM_TRATM_ID                               
                                
  INSERT INTO @l_temp                                      
  SELECT ttype.cd,stat.* from citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_NSDL') stat,                                      
  citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') ttype                          
                          
                          
  SELECT STATUS_CD,STATUS_DESCP from @l_temp t, citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') ttype                          
  WHERE ttype_cd=ttype.cd                         
  AND TTYPE_CD = @pa_cd                        
 --                        
 END                        
 IF @PA_ACTION = 'Inst_Main'                        
 BEGIN                        
 --                        
  declare @@dpmid int                                        
                                        
  select @@dpmid = INWSR_DPM_ID from INWARD_SLIP_REG where INWSR_ID = @pa_cd                           
                          
  select Excsm_id=default_dp,Acct_no=case  when  INWSR_TRASTM_CD not in ('904_P2C','907') then dpam_sba_no else citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') end,slip_no=INWSR_SLIP_NO,Request_dt=convert(varchar(11),INWSR_RECD_DT,103),Exec_dt=convert(varchar 
 
    
      
(      
        
11),INWSR_EXEC_DT,103),Trans_cnt=INWSR_NO_OF_TRANS,scr_cd = INWSR_TRASTM_CD,Scr_id= citrus_usr.Fn_GetSlipScreens(INWSR_TRASTM_CD,'2') ,UPPER(isnull(inwsr_transubtype_cd,'')) inwsr_transubtype_cd                       
  from INWARD_SLIP_REG,dp_mstr,                        
  CITRUS_USR.FN_ACCT_LIST(@@dpmid,1,0)  ACCT                        
  WHERE                         
  INWSR_DPM_ID = @@dpmid                      
  AND INWSR_DPM_ID = DPM_ID                        
  AND INWSR_DPAM_ID = ACCT.DPAM_ID                         
  AND INWSR_ID = @pa_cd                        
 --                        
 END                        
                         
 IF @PA_ACTION = 'CLIENT_EMAIL'                        
 BEGIN                        
 --                        
   Select distinct conc_value                        
   from entity_adr_conc, contact_channels, client_mstr, dp_acct_mstr                        
   where entac_concm_cd = 'email1'                        
   and entac_adr_conc_id = conc_id       and clim_crn_no = entac_ent_id                        
   and clim_crn_no = dpam_crn_no                         
   and entac_deleted_ind = 1                        
   and conc_deleted_ind = 1                         
   and clim_deleted_ind = 1                         
   and dpam_deleted_ind = 1                         
   and dpam_sba_no = @pa_cd                        
 --                        
 END                        
 if @pa_action ='REPORT_MSG'                        
 BEGIN                        
--                        
    select page_spl_msg                        
    from report_message       
    where report_name =@PA_CD                        
    and repmsg_deleted_ind =1                        
   --                        
  END                        
  if @pa_action ='SLIP_BOOK_SEARCH'                        
  BEGIN                        
  --                        
   select ors_id                        
       ,ors_po_no [Order No]                        
       ,ors_book_type [Book Type]                        
       ,ors_no_of_books [No of Books]                        
       ,ors_size_of_books [Book Size]                        
       ,ors_from_no  [From Book]                        
       ,ors_to_no [To Book]                        
       ,ors_from_slip [From Slip]                        
       ,ors_to_slip [To Slip]                        
       ,trastm_desc [Slip Type]                        
       ,default_dp                        
       ,trastm_id                        
       ,ors_series_type [Series]         
       ,convert(varchar(11),ors_po_dt,103)                       
       from order_slip                        
           ,transaction_sub_type_mstr                         
           ,dp_mstr                        
       where ors_po_no =@pa_cd                        
       and  trastm_id  = ors_tratm_id                    
       and  ors_dpm_id = dpm_id                        
       and  ord_deleted_ind = 1                        
       and  not exists (select slibm_id from slip_book_mstr where SLIBM_TRATM_ID =ors_tratm_id and slibm_deleted_ind = 1 and ((SLIBM_FROM_NO between ors_from_slip and ors_to_slip) or (SLIBM_TO_NO between ors_from_slip and ors_to_slip)) )                  
 
   
               
                           
                        
  --                        
  END                        
  if @pa_action ='SLIP_BOOK_SEARCH_DTLS'                        
  BEGIN                        
  --                        
          
select ors_id                         
       ,ors_po_no [Order No]                        
       ,ors_book_type [Book Type]                        
       ,ors_no_of_books [No of Books]                        
       ,ors_size_of_books [Book Size]                        
       ,ors_from_no [From Book]                        
       ,ors_to_no   [To Book]                        
       ,ors_from_slip [From Slip]                        
   ,ors_to_slip [To Slip]                        
       ,trastm_desc [Slip Type]                        
       ,ors_dpm_id                          
       ,default_dp                          
       ,ltrim(rtrim(trastm_id))  trastm_id                          
       ,ors_series_type [Series]                        
       from order_slip                        
           ,transaction_sub_type_mstr                         
           , dp_mstr                        
       where ors_id =@pa_cd                        
       and  trastm_id = ors_tratm_id                        
       and  ors_dpm_id = dpm_id                        
       and  ord_deleted_ind = 1                 
       and  not exists (select sliim_id from slip_issue_mstr where ((sliim_slip_no_fr between ors_from_slip and ors_to_slip) or (sliim_slip_no_to between ors_from_slip and ors_to_slip )) and ors_series_type=sliim_series_type )                        
             
                          
/*       select ors_id                         
              ,ors_po_no                         
              ,ors_book_type                         
              ,ors_no_of_books                         
              ,ors_size_of_books                 
              ,ors_from_no                         
              ,ors_to_no                           
              ,ors_from_slip                         
              ,ors_to_slip                         
              ,trastm_desc                         
              ,ors_dpm_id                          
              ,default_dp                          
              ,trastm_id                            
              ,ors_series_type                         
              from order_slip                        
                  ,transaction_sub_type_mstr              
                  , dp_mstr                        
              where ors_id =@pa_cd                        
              and  trastm_id = ors_tratm_id                        
          and  ors_dpm_id = dpm_id                        
              and  ord_deleted_ind = 1                        
       and  not exists (select sliim_id from slip_issue_mstr where (sliim_slip_no_fr between ors_from_slip and ors_to_slip) or (sliim_slip_no_to between ors_from_slip and ors_to_slip ) )*/                        
                        
                        
  --                        
  END                        
  if @pa_action ='MAX_SLIP_BOOK_NO'                        
  BEGIN                        
  --                        
    /*select isnull(max(convert(numeric,slibm_book_name)),0)+1  book_no                        
    from slip_book_mstr                         
    where slibm_tratm_id = @pa_cd*/       
    /* COMMENT BY LATESH TO GET MAX FROM SLIP ISSUE INSTEAD OF ORDER SLIP AS PER MOSL                 
    select top 1 convert(numeric,ors_to_no)+1 book_no,ors_to_slip+ 1 slip_no                        
    from order_slip                        
    where ors_tratm_id = @pa_cd  AND ors_series_type=@pa_values                       
    order by ors_id desc                        
    COMMENT BY LATESH TO GET MAX FROM SLIP ISSUE INSTEAD OF ORDER SLIP AS PER MOSL*/


--    SELECT top 1 convert(numeric,sliim_book_name)+1 book_no,SLIIM_SLIP_NO_TO+ 1 slip_no 
--    FROM SLIP_ISSUE_MSTR WHERE SLIIM_TRATM_ID=@pa_cd AND SLIIM_SERIES_TYPE=@pa_values
--    order by SLIIM_ID desc  

		DECLARE @L1 int
		DECLARE @L2 int
		DECLARE @L3 int
		DECLARE @L4 int
		  
		select @L1 =  max(convert(numeric,sliim_slip_no_to))+ 1  from slip_issue_mstr where SLIIM_DELETED_IND = 1  and isnumeric(sliim_slip_no_to)=1   
		select @L3 =  max(convert(numeric,sliim_book_name))+ 1  from slip_issue_mstr where SLIIM_DELETED_IND = 1    and isnumeric(sliim_book_name)=1 
		PRINT @L1
		--  
		select @L2 =  max(convert(numeric,ors_to_slip))+ 1  from ORDER_SLIP where ord_deleted_ind = 1    
		select @L4 =  max(convert(numeric,ors_to_no))+ 1  from ORDER_SLIP where ord_deleted_ind = 1    
		PRINT @L2
		--  
		IF @L1>@L2  
		BEGIN   
		select @L3 book_no, @L1  slip_no
		END  
		--  
		IF @L2>@L1  
		BEGIN   
		select @L4 book_no, @L2  slip_no
		END  
		IF @L2=@L1  
		BEGIN   
		select @L4 book_no, @L2  slip_no
		END  

                                    
                            
  --                        
  END                        
  if @pa_action ='Validate_slip_book'                        
  BEGIN                        
  --                        
          declare @l_ss bigint                        
         set @l_ss  = 0                         
    select @l_ss   = sliim_id                         
        from slip_issue_mstr                         
                 where sliim_tratm_id = @pa_cd                         
                 and sliim_deleted_ind =1                         
                 and ((convert(numeric,@pa_desc) between convert(numeric,sliim_slip_no_fr) and convert(numeric,sliim_slip_no_to))  or (convert(numeric,@pa_rmks) between convert(numeric,sliim_slip_no_fr) and convert(numeric,sliim_slip_no_to))) and sliim_series_type=@pa_values                 
           
           
           if @l_ss <> 0                        
     begin                         
    select 1                        
      end                        
           else                         
           begin                         
    select 0                        
           end                            
  --                        
  END                        
  if @pa_action ='Report_Names'                        
 BEGIN                        
 --                        
  SELECT reportid = msg_id                        
        ,report_code = report_name                         
        ,report_name = replace (report_name,'_','')                         
  FROM   report_message                         
  WHERE  report_name like '%' + isnull(@pa_cd ,'') + '%'                        
 --                        
 END                        
  /* if @pa_action ='Report_Message'                        
    BEGIN                         
    --                        
   SELECT page_spl_msg                         
   FROM report_message                         
   WHERE msg_id = CONVERT(NUMERIC,@pa_cd)                           
    --                        
    END  */                        
  if @pa_action ='DEMAT_REMAT_SLIP_VALIDATION'                        
  BEGIN                        
  --                        
    Declare @l_yn char(1)                        
    , @l_dpam_id numeric                        
                            
    if @pa_cd = 'DEMAT'                        
    begin                        
    --                        
      set @l_dpam_id  = 0                         
                       
      select @l_dpam_id = dpam_id from (                        
      select dpam_id from dp_acct_mstr , demat_request_mstr where demrm_dpam_id = dpam_id  and dpam_sba_no = @pa_desc and DEMRM_SLIP_SERIAL_NO = @pa_rmks                          
      union                        
      select dpam_id from dp_acct_mstr , demrm_mak where demrm_dpam_id = dpam_id  and dpam_sba_no = @pa_desc   and demrm_deleted_ind in (0,4,6) and DEMRM_SLIP_SERIAL_NO = @pa_rmks  ) a                        
                              
      if @l_dpam_id = 0                        
      begin         
      set @pa_ref_cur = '0'                        
      end                        
      else                         
      begin                        
      set @pa_ref_cur = 'Slip Issued to Same Client. Please Verify'                        
      end                        
    --                        
    end                
    else if  @pa_cd = 'REMAT'                        
    begin                        
    --                        
      set @l_dpam_id  = 0                         
                                    
      select @l_dpam_id = dpam_id from (                        
      select dpam_id from dp_acct_mstr , remat_request_mstr where remrm_dpam_id = dpam_id  and dpam_sba_no = @pa_desc and remrm_slip_serial_no = @pa_rmks                          
      union                        
      select dpam_id from dp_acct_mstr , remrm_mak where remrm_dpam_id = dpam_id  and dpam_sba_no = @pa_desc   and remrm_deleted_ind in (0,4,6) and remrm_slip_serial_no = @pa_rmks  ) a                        
                        
      if @l_dpam_id = 0                        
      begin                         
    set @pa_ref_cur = '0'                        
      end                        
      else                         
      begin                        
      set @pa_ref_cur = 'Slip Issued to Same Client. Please Verify'                        
      end                        
    --                        
    end        
--        
END        
              
 if @pa_action = 'BLOCKCLIENTS'             
    BEGIN          
   --          
   IF @pa_values = 'E'        
   BEGIN         
   --            
    IF @pa_desc='E'          
    BEGIN          
      --          
      SELECT  BLKCE_RPTNAME   rptname        
       ,'ENTITY' ENTITY          
       ,ENTM_NAME1 SHORTNAME           
       ,blkce_id  intid        
      from  BLK_CLIENT_EMAIL          
       ,ENTITY_MSTR      
      where blkce_entity_id = entm_id          
      and entm_deleted_ind =1          
      and  blkce_deleted_ind =1          
      and  blkce_dpmdpid = @pa_rmks          
      and     BLKCE_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
             
      --          
    END          
    ELSE if @pa_desc='C'          
    BEGIN          
      --          
      SELECT BLKCE_RPTNAME  rptname        
       ,'CLIENT' ENTITY           
       ,isnull(CLIM_NAME1,'') + ' ' + isnull(CLIM_NAME2,'') + ' ' + isnull(CLIM_NAME3,'')  SHORTNAME          
       ,blkce_id  intid        
      FROM    BLK_CLIENT_EMAIL          
       ,CLIENT_MSTR          
      WHERE  blkce_entity_id = CLIM_CRN_NO          
      AND CLIM_DELETED_IND=1          
      AND  blkce_deleted_ind =1          
      and  blkce_dpmdpid = @pa_rmks          
      and     BLKCE_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
      --          
    END           
    ELSE          
    BEGIN          
      --          
     SELECT  BLKCE_RPTNAME  rptname        
       ,'ENTITY' ENTITY          
       ,ENTM_NAME1 SHORTNAME           
       ,blkce_id  intid        
      from  BLK_CLIENT_EMAIL          
       ,ENTITY_MSTR          
      where blkce_entity_id = entm_id          
      and entm_deleted_ind =1          
      and  blkce_deleted_ind =1          
      and  blkce_dpmdpid = @pa_rmks          
      and     BLKCE_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
      UNION          
      SELECT BLKCE_RPTNAME  rptname        
       ,'CLIENT' ENTITY           
       ,isnull(CLIM_NAME1,'') + ' ' + isnull(CLIM_NAME2,'') + ' ' + isnull(CLIM_NAME3,'')  SHORTNAME          
       ,blkce_id  intid        
      FROM    BLK_CLIENT_EMAIL          
       ,CLIENT_MSTR          
      WHERE  blkce_entity_id = CLIM_CRN_NO          
      AND CLIM_DELETED_IND=1          
      AND  blkce_deleted_ind =1          
      and  blkce_dpmdpid = @pa_rmks          
      and     BLKCE_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
              
      --          
    END          
  --        
  END        
  ELSE        
  BEGIN        
  --        
   IF @pa_desc='E'          
    BEGIN          
      --          
      SELECT  BLKCP_RPTNAME  rptname        
       ,'ENTITY' ENTITY          
       ,ENTM_NAME1 SHORTNAME           
       ,blkcP_id  intid        
      from  BLK_CLIENT_PRINT        
       ,ENTITY_MSTR          
      where blkcP_entity_id = entm_id          
      and entm_deleted_ind =1          
      and  blkcP_deleted_ind =1          
      and  blkcP_dpmdpid = @pa_rmks          
      and     BLKCP_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
             
      --          
    END          
    ELSE if @pa_desc='C'          
    BEGIN          
      --          
      SELECT BLKCP_RPTNAME  rptname        
       ,'CLIENT' ENTITY           
       ,isnull(CLIM_NAME1,'') + ' ' + isnull(CLIM_NAME2,'') + ' ' + isnull(CLIM_NAME3,'')  SHORTNAME            
       ,blkcP_id  intid        
      FROM    BLK_CLIENT_PRINT        
       ,CLIENT_MSTR          
      WHERE  blkcP_entity_id = CLIM_CRN_NO          
      AND CLIM_DELETED_IND=1          
      AND  blkcP_deleted_ind =1          
      and  blkcP_dpmdpid = @pa_rmks          
      and     BLKCP_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
      --          
    END           
    ELSE          
    BEGIN          
      --          
     SELECT  BLKCP_RPTNAME  rptname        
       ,'ENTITY' ENTITY          
       ,ENTM_NAME1 SHORTNAME           
       ,blkcP_id  intid        
      from  BLK_CLIENT_PRINT          
       ,ENTITY_MSTR          
      where blkcP_entity_id = entm_id          
      and entm_deleted_ind =1          
      and  blkcP_deleted_ind =1          
      and  blkcP_dpmdpid = @pa_rmks          
      and     BLKCP_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
      UNION          
      SELECT BLKCP_RPTNAME  rptname        
       ,'CLIENT' ENTITY           
       ,isnull(CLIM_NAME1,'') + ' ' + isnull(CLIM_NAME2,'') + ' ' + isnull(CLIM_NAME3,'')  SHORTNAME           
       ,blkcP_id  intid        
      FROM    BLK_CLIENT_PRINT          
       ,CLIENT_MSTR          
      WHERE  blkcP_entity_id = CLIM_CRN_NO          
      AND CLIM_DELETED_IND=1          
      AND  blkcP_deleted_ind =1          
      and  blkcP_dpmdpid = @pa_rmks          
      and     BLKCP_RPTNAME LIKE CASE WHEN LTRIM(RTRIM(@pa_cd)) = '' then '%' else @pa_cd end          
              
      --          
    END         
  --        
  END         
  --                        
 END                        
--

GO
