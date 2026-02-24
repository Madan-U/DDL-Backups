-- Object: PROCEDURE citrus_usr.pr_select_dp_paging_Online
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



   
CREATE PROCEDURE [citrus_usr].[pr_select_dp_paging_Online] (@pa_startRowIndex int,                                                      
                                    @pa_maximumRows int  ,                                                
                                    @pa_action as varchar(20),                                                     
                                    @pa_cd varchar(20),                                                
                                    @pa_desc varchar(20),                                           
                                    @pa_code varchar(20),                                               
                                    @pa_value varchar(100),                        
                                    @pa_rmks varchar(20),          
									@pa_stat varchar(10)='Y',  
									@pa_boid varchar(20),       
                                    @pa_ref_cur varchar(20) OUTPUT          
                                   )                                                    
AS                                                      
BEGIN          


--(select 'PARESH MAHENDRA SHAH' Client_Name, '1203320000051111' Acct_no, '5931905' Client_Id ,'I'ACCT_TYPE ,'' CMBPID, 1 totalrecords
--union

--select 'PARESHKUMAR MAHENDRAKUMAR SHAH(HUF)' Client_Name, '1203320005206311' Acct_no, '5931913' Client_Id ,'I'ACCT_TYPE ,'' CMBPID, 1 totalrecords) return


                                        
                   
   DECLARE @first_id BIGINT                                                    
          , @startRow BIGINT                        
          ,@l_count  BIGINT                        
          ,@@SSQL    VARCHAR(8000)                        
          ,@@SSQLFSTID    VARCHAR(8000)                        
          ,@@SSQLCNT    VARCHAR(8000)                        
          ,@@SSQLREC     VARCHAR(8000)                        
          ,@l_bank   VARCHAR(10)                         
          ,@l_client   VARCHAR(10)                         
          ,@l_gl   VARCHAR(10)                        
          ,@l_dpmid  VARCHAR(20)                        
          ,@l_brcd    VARCHAR(20)                        
          ,@l_inputstring        varchar(100)                         
          ,@l_currstring         varchar(25)                         
          ,@@l_acct_chk           varchar(10)                        
          ,@@l_gl_chk                 varchar(10)                        
          ,@l_tblacctbal_id      VARCHAR(10)                      
          ,@l_entityid           BIGINT                 
          ,@FSTRec BIGINT                
          ,@LSTRec BIGINT             
          ,@ll_dpmid    VARCHAR(20)            
                      
                                           
                          
   SET @l_count  = 0                   
   SET ROWCOUNT 0                
                                                       
   IF @pa_action ='ISIN'                                        
   BEGIN                                                
   --                 
     SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
     IF @pa_startRowIndex = 0                                  
     SET @pa_startRowIndex = 1                                                      
     SET ROWCOUNT @pa_startRowIndex                 
                     
     DECLARE @l_isin_bit NUMERIC                
                     
     IF @pa_rmks = 'CDSL'                 
     BEGIN                
     --                
       SET @l_isin_bit = 2                
     --                
     END                
     ELSE IF @pa_rmks = 'NSDL'                
     BEGIN                
     --                
       SET @l_isin_bit = 1                
     --                
     END                
                       
     IF @pa_value <> ''                      
     BEGIN                      
       --                   
       SELECT @first_id = isin_id                                                 
       FROM isin_mstr                                                   
       WHERE ISNULL(isin_name,'')    LIKE @pa_cd + '%'                  
       AND ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                  
       AND isin_status = 01             
       AND ISNULL(isin_filler,'') <>'B'            
       AND isin_bit IN (0,@l_isin_bit)                 
       ORDER BY isin_id                                                
                         
       IF @pa_startRowIndex =1                        
       BEGIN                        
       --                        
        SELECT @l_count = COUNT(isin_id)                        
         FROM isin_mstr                                                   
         WHERE ISNULL(isin_name,'')    LIKE @pa_cd + '%'                  
         AND ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'             
         AND ISNULL(isin_filler,'') <>'B'            
         AND ISIN_STATUS = 01                 
        AND isin_bit IN (0,@l_isin_bit)                
       --                        
       END                          
                       
       SET ROWCOUNT @pa_maximumRows                                  
                       
       SELECT isin_id                        
              ,isin_cd                        
              ,isin_name                        
              ,isin_comp_name                                                 
              ,@l_count  totalrecord              
              ,isin_filler            
       FROM isin_mstr                                     
       WHERE ISNULL(isin_name,'') like @pa_cd +'%'                  
       AND ISNULL(ISIN_COMP_NAME,'') LIKE @PA_DESC + '%'                  
       AND ISIN_STATUS = 01                 
       AND ISNULL(isin_filler,'') <>'B'            
       AND isin_bit IN (0,@l_isin_bit)                
       AND isin_id >= @first_id                                         
       ORDER BY isin_id                                                 
                      
       SET ROWCOUNT 0                        
       --                   
    END                      
    ELSE IF @pa_value = ''                      
    BEGIN                      
    --                     
      IF @pa_code = ''            
      BEGIN            
      --            
print @l_isin_bit
       SELECT @first_id = isin_id                                                 
       FROM isin_mstr                                                   
       WHERE ISNULL(isin_name,'')   LIKE @pa_cd + '%'                  
       AND ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                 
       AND isin_bit IN (0,@l_isin_bit)                
       ORDER BY isin_cd                                                
    print @first_id                  
       IF @pa_startRowIndex =1                        
       BEGIN                        
       --                        
          SELECT @l_count = COUNT(isin_id)                        
          FROM isin_mstr                                                   
          WHERE ISNULL(isin_name,'')    LIKE @pa_cd + '%'                  
          AND ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                  
          AND isin_bit IN (0,@l_isin_bit)                
       --                        
       END                          
                      
       SET ROWCOUNT @pa_maximumRows                                                   
                      
       SELECT isin_id                        
             ,isin_cd                        
             ,isin_name                        
             ,isin_comp_name                                                 
             ,@l_count  totalrecord             
             ,isin_filler            
       FROM  isin_mstr                                                     
       WHERE ISNULL(isin_name,'') like @pa_cd +'%'                  
       AND   ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                 
       AND   isin_bit IN (0,@l_isin_bit)                
       --AND   isin_id >= @first_id        -- comment by latesh on mar 04 2013 to get like search                                           
  ORDER BY isin_cd                                                 
                              
       SET ROWCOUNT 0                   
                              
     --                      
     END            
     ELSE            
     BEGIN            
     --            
       SELECT @first_id = isin_id                                                 
       FROM isin_mstr                    
       WHERE ISNULL(isin_name,'')   LIKE @pa_cd + '%'                  
       AND ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                 
       AND isin_bit IN (0,@l_isin_bit)               
       AND ISNULL(isin_filler,'') not in ('B','P')            
       ORDER BY isin_cd                                                
            
       IF @pa_startRowIndex =1                        
BEGIN                        
       --                        
          SELECT @l_count = COUNT(isin_id)                        
          FROM isin_mstr                                                   
          WHERE ISNULL(isin_name,'')    LIKE @pa_cd + '%'                  
          AND ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                  
          AND isin_bit IN (0,@l_isin_bit)              
          AND ISNULL(isin_filler,'') not in ('B','P')            
       --                        
       END                          
            
       SET ROWCOUNT @pa_maximumRows                                                   
            
       SELECT isin_id                        
             ,isin_cd                        
             ,isin_name                        
  ,isin_comp_name                                                 
             ,@l_count  totalrecord             
             ,isin_filler            
       FROM  isin_mstr                                                     
       WHERE ISNULL(isin_name,'') like @pa_cd +'%'                  
       AND   ISNULL(isin_comp_name,'') LIKE @pa_desc + '%'                 
       AND   isin_bit IN (0,@l_isin_bit)             
       AND   ISNULL(isin_filler,'') not in ('B','P')            
       AND   isin_id >= @first_id                                                   
       ORDER BY isin_cd                                                 
                                     
       SET ROWCOUNT 0                   
     --            
     END            
    END                      
 --                                              
 END                                
                 
 /*DP HELP*/                
 IF @pa_action='DP'                                                 
 BEGIN                         
 --                  
   SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
   IF @pa_startRowIndex = 0                                  
   SET @pa_startRowIndex = 1                                                      
   SET ROWCOUNT @pa_startRowIndex                 
                       
   IF @pa_desc <> ''                        
   BEGIN                        
   --   
                        
      DECLARE @l_excsm_id  INT                        
                
      SELECT @l_excsm_id = excsm_id                         
      FROM   exch_seg_mstr                         
      WHERE   excsm_exch_cd = @pa_desc                        
     -- ORDER by 1 desc                        
                
      SELECT @first_id =dpm_id                          
      FROM   dp_mstr  WITH (NOLOCK)                        
      WHERE  dpm_deleted_ind  = 1                        
     -- AND    default_dp = @l_excsm_id 
	  AND    dpm_excsm_id     = @l_excsm_id                              
      AND    dpm_dpid like  @pa_code +'%'                  
      AND    dpm_name like  @pa_cd +'%'                  
      ORDER BY dpm_id                                                
                
      IF @pa_startRowIndex = 1                           
      BEGIN                        
         --                        
         SELECT @l_count = COUNT(dpm_id)                          
         FROM   dp_mstr  WITH (NOLOCK)                        
         WHERE  dpm_deleted_ind  = 1                        
       --  AND    default_dp = @l_excsm_id       
		 AND   dpm_excsm_id     = @l_excsm_id                        
         AND    dpm_dpid like @pa_code +'%'                  
         AND    dpm_name like @pa_cd +'%'                  
         --                        
      END                           
                
      SET ROWCOUNT @pa_maximumRows                            
              print @l_excsm_id  
      SELECT  replace(dpm.dpm_name,'''','') dpm_name           
            , case when LEFT(dpm.dpm_dpid,2)='IN' then  right(dpm.dpm_dpid,6)  else dpm.dpm_dpid end         dpm_dpid                                                    
            , dpm.dpm_id             dpm_id                                                    
            , excm.excm_cd           dpm_type                                                  
            , dpm.dpm_short_name     dpm_short_name                                
            , @l_count               totalrecord                        
      FROM   dp_mstr                  dpm   WITH (NOLOCK)                                                    
           , exchange_mstr           excm  WITH (NOLOCK)                                                    
           , exch_seg_mstr           excsm WITH (NOLOCK)                                                    
      WHERE dpm.dpm_deleted_ind  = 1                                                    
      AND   excsm.excsm_id      = dpm.dpm_excsm_id                                 
      AND   excsm.excsm_exch_cd = excm.excm_cd                          
      --AND   dpm.default_dp     = @l_excsm_id   
      --AND   dpm_excsm_id     = @l_excsm_id                  
      AND   dpm.dpm_dpid like @pa_code +'%'                  
      AND   dpm.dpm_name like @pa_cd +'%'                  
      --AND   dpm.dpm_id   >= @first_id        
      and DPM_DPID in (Select ONL_TRXFEREE_DPID from ONLINE_DPTRX_BEN_MSTR where ONL_DELETED_IND=1 and ONL_TRX_BOID=@pa_value
      --and len(ONL_TRXFEREE_BOID)=case when @pa_desc='NSDL' then 8 else 16 end 
      and ISNUMERIC(ONL_TRXFEREE_DPID)=case when @pa_desc='NSDL' then 0 else 1 end 
      )                
      
      ORDER BY 1 DESC                        
                
      SET ROWCOUNT  0                        
                                 
   --                        
   END                        
   ELSE IF @pa_desc = ''                        
   BEGIN                        
      --                        
      SELECT @first_id = dpm.dpm_id                                                             
      FROM    dp_mstr    dpm   WITH (NOLOCK)                                                    
            , exchange_mstr   excm  WITH (NOLOCK)                                                    
            , exch_seg_mstr   excsm WITH (NOLOCK)                                                    
      WHERE dpm.dpm_deleted_ind = 1                                                    
      AND   excsm.excsm_id  = dpm.dpm_excsm_id                                                  
      AND   excsm.excsm_exch_cd  = excm.excm_cd                                                  
      AND   DPM.DPM_DPID like @pa_value +'%'                 
      AND   dpm_name like @pa_cd +'%'                  
      ORDER BY dpm.dpm_id                                                
                
      IF  @pa_startRowIndex = 1                           
      BEGIN                        
         --                        
         SELECT @l_count =COUNT(dpm.dpm_id)                         
         FROM    dp_mstr    dpm   WITH (NOLOCK)                                                    
               , exchange_mstr   excm  WITH (NOLOCK)                                                    
               , exch_seg_mstr   excsm WITH (NOLOCK)                                                    
         WHERE dpm.dpm_deleted_ind = 1                                                    
         AND   excsm.excsm_id  = dpm.dpm_excsm_id                                                  
         AND   excsm.excsm_exch_cd  = excm.excm_cd                                                  
         AND   DPM.DPM_DPID like @pa_value +'%'                 
         AND   dpm_name like @pa_cd +'%'                  
         --                        
      END                           
                
      SET ROWCOUNT @pa_maximumRows                                                
                
      SELECT   replace(dpm.dpm_name ,'''','')     dpm_name                                                    
             , right(dpm.dpm_dpid,6)          dpm_dpid                                                    
             , dpm.dpm_id             dpm_id                                                    
             , excm.excm_cd           dpm_type                                                  
             , dpm.dpm_short_name     dpm_short_name                         
             , @l_count               totalrecord                        
      FROM    dp_mstr         dpm   WITH (NOLOCK)                                                    
            , exchange_mstr           excm  WITH (NOLOCK)                                                    
            , exch_seg_mstr           excsm WITH (NOLOCK)                                                    
      WHERE dpm.dpm_deleted_ind  = 1                                                    
      AND   excsm.excsm_id      = dpm.dpm_excsm_id                                                  
      AND   excsm.excsm_exch_cd = excm.excm_cd                                                  
      AND   DPM.DPM_DPID like @pa_value +'%'                 
      AND   dpm_name like @pa_cd +'%'                  
    AND   dpm_id >=@first_id                   
    and DPM_DPID in (Select ONL_TRXFEREE_DPID from ONLINE_DPTRX_BEN_MSTR where ONL_DELETED_IND=1 and ONL_TRX_BOID=@pa_value)                                             
    and dpm.dpm_dpid  like case when @pa_desc ='NSDL' then 'IN' else '' end +'%' 
      ORDER BY dpm_id                                                
                
      SET ROWCOUNT 0                                                
      --                        
   END                  
                   
   --                
  END                          
                  
  /*SLAB HELP*/                
               
  IF @pa_action ='SLAB'                        
  BEGIN                        
  --                  
     SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
     IF @pa_startRowIndex = 0                                  
     SET @pa_startRowIndex = 1                                                      
     SET ROWCOUNT @pa_startRowIndex                      
                      
     DECLARE @l_id INT                         
                              
     IF @pa_cd <> ''                        
     BEGIN                        
     --                        
       SELECT @l_id = EXCSM_ID                         
       FROM  EXCH_SEG_MSTR                          
       WHERE  excsm_exch_cd = @pa_cd ORDER BY 1                        
                                
       SELECT @first_id = cham_slab_no                         
       FROM   charge_mstr                        
       WHERE  cham_chargebitfor = CONVERT(NUMERIC,@l_id)                        
       AND    cham_slab_name like @pa_desc +'%'                 
       AND    CHAM_DELETED_IND =1                        
       ORDER BY 1                        
                                               
       IF @pa_startRowIndex = 1                           
       BEGIN                        
       --                        
         SELECT @l_count = COUNT(cham_slab_no)                        
         FROM   charge_mstr                        
         WHERE  cham_chargebitfor = CONVERT(NUMERIC,@l_id)                        
         AND    cham_slab_name like @pa_desc +'%'                 
         AND    CHAM_DELETED_IND =1                        
       --                        
       END                         
                              
       SET ROWCOUNT @pa_maximumRows                       
                                
       SELECT DISTINCT cham_slab_no SLABNO                        
               ,cham_slab_name       SLABNAME                      
               ,UPPER(LTRIM(RTRIM(cham_charge_type)))     ChargeType                      
               ,cham_charge_baseon   BaseOn                      
               ,cham_remarks         Remarks                        
,@l_count              totalrecord                        
       FROM   charge_mstr                        
       WHERE  cham_chargebitfor = convert(numeric,@l_id)                        
       AND    cham_deleted_ind =1                        
       AND    cham_slab_name like @pa_desc +'%'                 
       AND    cham_slab_no >=@first_id 
       AND    isnull(CHAM_ACTIVE_YN,'A') = 'A'                        
       ORDER BY 1                        
                                       
        SET  ROWCOUNT 0                          
       --                        
     END                
     ELSE IF @pa_cd = ''                        
     BEGIN                        
     --                        
       SELECT @first_id = cham_slab_no                         
       FROM   charge_mstr       
       WHERE  CHAM_DELETED_IND =1                        
       AND    cham_slab_name like @pa_desc +'%'                 
       ORDER BY 1                        
                                         
       IF @pa_startRowIndex = 1                           
       BEGIN                        
       --                        
         SELECT @l_count = COUNT(cham_slab_no)                        
         FROM   charge_mstr                        
         WHERE  cham_slab_name like @pa_desc +'%'                 
         AND    CHAM_DELETED_IND =1                        
       --                        
       END                         
                        
       SET ROWCOUNT @pa_maximumRows                                
                        
       SELECT DISTINCT cham_slab_no SLABNO                        
             ,cham_slab_name       SLABNAME       
             ,UPPER(LTRIM(RTRIM(cham_charge_type)))     ChargeType                      
             ,cham_charge_baseon   BaseOn                      
             ,cham_remarks         Remarks                       
             ,@l_count             totalrecord                        
       FROM   charge_mstr                        
       WHERE  CHAM_DELETED_IND =1                        
       AND    cham_slab_name like @pa_desc +'%'                 
       AND cham_slab_no >=@first_id  
       AND    isnull(CHAM_ACTIVE_YN,'A') = 'A'                      
       ORDER BY 1                        
                                  
       SET  ROWCOUNT 0                          
     --                        
     END                          
   --                        
   END                   
                    
   /*BANK HELP*/                                             
                                              
   IF @pa_action='BANK'                                          
   BEGIN                                              
   --                        
     SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
     IF @pa_startRowIndex = 0                
     SET @pa_startRowIndex = 1                                                      
     SET ROWCOUNT @pa_startRowIndex                      
                                  
     SELECT @first_id = banm_id FROM BANK_MSTR                                               
     WHERE banm_deleted_ind= 1                                                
     AND banm_name like @pa_cd +'%'                 
     AND banm_branch like @pa_desc +'%'       
     AND banm_micr like @pa_value +'%'  
     AND isnull(Banm_rtgs_cd,'') like @pa_rmks + '%' -- Added By Priya           
     ORDER BY banm_id                                               
                                              
     IF @pa_startRowIndex = 1                           
     BEGIN                     
     --                        
       SELECT @l_count = COUNT(banm_id) FROM BANK_MSTR                                               
       WHERE banm_deleted_ind= 1                                                
       AND banm_name like @pa_cd +'%'                 
       AND banm_branch like @pa_desc +'%'       
       AND banm_micr like @pa_value +'%' 
       AND isnull(Banm_rtgs_cd,'') like @pa_rmks +'%'  -- Added By Priya           
     --                        
     END                        
                  
     SET ROWCOUNT @pa_maximumRows                                                    
                                                     
     SELECT distinct banm.banm_name   banm_name                                                    
           , banm.banm_id                   banm_id                                                    
           , banm.banm_branch               banm_branch                                                    
           , banm.banm_micr                 banm_micr          
     , replace(replace(replace(citrus_usr.fn_addr_value(banm_id,'COR_ADR1'),'|*~|',' '),'.',''),'-','') + '.' BANM_ADR   
             ,Banm_rtgs_cd                  Ifsc_Code  -- Added By Priya 
           , @l_count                       totalrecord                           
     FROM   bank_mstr                    banm WITH (NOLOCK)                                                    
     WHERE  banm.banm_deleted_ind        = 1                                              
     AND banm_name like @pa_cd +'%'                 
     AND banm_branch like @pa_desc +'%'     
     AND banm_micr like @pa_value +'%'
     AND isnull(Banm_rtgs_cd,'') like @pa_rmks +'%' -- Added By Priya                
     AND banm_id >= @first_id                                                
     ORDER BY banm_id                                                   
                                                 
     SET ROWCOUNT 0                                                
   --                  
   END                                              
                                        
 /* ENTITY HELP*/                                                
                 
  IF @pa_action='ENTITY'                    
  BEGIN                                          
  --                  
     SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
     IF @pa_startRowIndex = 0                                  
     SET @pa_startRowIndex = 1                                                      
     SET ROWCOUNT @pa_startRowIndex                      
              
--declare @l_entcode varchar(10)    , @l_crn_no numeric   
--if @pa_rmks<>''  
--begin   
--select @l_entcode = entm_enttm_cd from entity_mstr where entm_id=@pa_rmks  
--select @l_crn_no = dpam_crn_no from dp_acct_mstr where dpam_crn_no=@pa_rmks  
--             if ( isnull(@l_crn_no,'0') <> '0' OR isnull(@l_entcode,'') ='RE' )  
--   begin   
--   set @pa_rmks=@pa_rmks  
--   end   
--   else  
--   begin   
--   set @pa_rmks = ''  
--   end      
--end   
         
     IF @pa_rmks <> ''                                          
     BEGIN                        
     --                        
      SELECT @first_id = entm_id                          
      FROM   entity_mstr                                
             ,entity_type_mstr                         
             ,entity_properties                          
      WHERE entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                            
      AND   entity_mstr.ENTM_ID   =  entity_properties.entp_ent_id                          
      AND   entity_properties.entp_entpm_cd ='INST_FMY'                        
      AND   entity_properties.entp_value =1                        
      AND   entm_enttm_cd like @pa_code +'%'                 
      AND   entm_short_name like @pa_value +'%'                 
      AND   entity_properties.entp_deleted_ind  = 1                         
      AND   entity_mstr.entm_deleted_ind  = 1                         
      AND   entity_type_mstr.enttm_deleted_ind  = 1                         
                
                
      IF @pa_startRowIndex = 1                          
      BEGIN                        
        --                        
        SELECT @l_count = COUNT(entm_id)                          
        FROM  entity_mstr                                
             ,entity_type_mstr                         
             ,entity_properties                          
        WHERE entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                            
        AND   entity_mstr.entm_id   =  entity_properties.entp_ent_id                          
        AND   entity_properties.entp_entpm_cd ='INST_FMY'                        
        AND   entity_properties.entp_value =1                        
        AND   entm_enttm_cd like @pa_code +'%'                 
        AND   entm_short_name like @pa_value +'%'                 
        AND   entity_properties.entp_deleted_ind  = 1                         
        AND   entity_mstr.entm_deleted_ind  = 1                   
		AND   entity_type_mstr.enttm_deleted_ind  = 1                         
        --                        
      END                          
                                 
      SET ROWCOUNT @pa_maximumRows                        
                
      SELECT distinct entm_short_name  Entity_Short_Name                                      
           ,entm_parent_id   entity_parent_id                                            
           ,enttm_parent_cd  entity_type_parent_cd                                             
           ,entm_name1       Entity_Name1                                            
           ,enttm_id         enttm_id                                            
           ,entm_id          entity_id                        
           ,@l_count         totalrecord                        
      FROM  entity_mstr                                
           ,entity_type_mstr                         
           ,entity_properties                          
      WHERE entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                            
      AND   entity_mstr.entm_id   =  entity_properties.entp_ent_id                          
      AND   entity_properties.entp_entpm_cd ='INST_FMY'                        
      AND   entity_properties.entp_value ='1'                        
      AND   entm_enttm_cd like @pa_code +'%'                 
      AND   entm_short_name like @pa_value +'%'                 
      AND   entm_id >= @first_id                          
      AND   entity_properties.entp_deleted_ind  = 1                         
      AND   entity_mstr.entm_deleted_ind  = 1                         
      AND   entity_type_mstr.enttm_deleted_ind  = 1                         
                
      SET ROWCOUNT 0                          
   --                        
   END                        
                              
   ELSE IF  @pa_rmks = ''                           
   BEGIN                        
   --                        
     SET @pa_rmks ='RMKS'                        
                        
     IF @pa_value <> ''                                          
     BEGIN                                             
     --                        
       DECLARE @pa_id int                                          
                                          
       SELECT @pa_id = entm_id                                          
       FROM   entity_mstr,entity_type_mstr                                            
       WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
       AND    entm_enttm_cd like @pa_code +'%'                 
       AND    entm_short_name like @pa_value +'%'                 
                                             
       SELECT @first_id = entm_id                                          
       FROM   entity_mstr                        
                ,entity_type_mstr                                            
       WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
       AND    entm_enttm_cd like @pa_cd +'%'                 
       AND    entm_short_name like @pa_desc +'%'                 
       AND    entm_parent_id=@pa_id                                          
       ORDER BY entm_id                                          
                                
	IF @pa_startRowIndex = 1                           
       BEGIN                        
       --                        
         SELECT @l_count = COUNT(entm_id)                                          
         FROM   entity_mstr                        
                   ,entity_type_mstr                                            
         WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
         AND    entm_enttm_cd like @pa_cd +'%'                 
         AND    entm_short_name like @pa_desc +'%'                 
         AND    entm_parent_id=@pa_id                     
       --                        
       END                                
                       
       SET ROWCOUNT @pa_maximumRows                                           
                                          
       SELECT distinct entm_short_name  Entity_Short_Name                                            
             ,entm_parent_id   entity_parent_id                                            
             ,enttm_parent_cd  entity_type_parent_cd                                             
             ,entm_name1       Entity_Name1                                            
             ,enttm_id         enttm_id                                            
             ,entm_id          entity_id                         
             ,@l_count         totalrecord                        
       FROM   entity_mstr                        
              ,entity_type_mstr                                            
       WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                            
       AND    entm_enttm_cd like @pa_cd +'%'                 
       AND    entm_short_name LIKE @pa_desc +'%'                 
       AND    (ISNULL(entm_id,0)>= @first_id ) --OR  ISNULL(entm_id,0) <= @first_id )                        
       AND    entm_parent_id =@pa_id                                          
       AND    entm_deleted_ind=1                                            
                                                  
       SET ROWCOUNT 0                                          
      --                        
    END                                         
                                                 
    ELSE IF @pa_value =''                                          
    BEGIN                                          
    --                        
      IF EXISTS(SELECT enttm_parent_cd FROM  entity_mstr ,entity_type_mstr WHERE entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd AND entm_enttm_cd like CASE when LTRIM(RTRIM(@pa_cd)) = '' THEN '%' ELSE  @pa_cd +'%' End )                      
      BEGIN                      
      --    
        SELECT @first_id = entm_id                                          
        FROM   entity_mstr                        
               ,entity_type_mstr                                            
        WHERE entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
        AND    entm_enttm_cd like @pa_cd +'%'                
        --AND    entm_name1 LIKE @pa_desc +'%'                          
		AND    entm_short_name LIKE @pa_desc +'%'                          
        ORDER BY entm_id                                          
                      
        IF @pa_startRowIndex = 1                           
        BEGIN                        
        --                        
          SELECT @l_count =COUNT(entm_id)                                          
          FROM   entity_mstr                        
                 ,entity_type_mstr                                            
          WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
          AND    entm_enttm_cd like @pa_cd +'%'                        
        --  AND    entm_name1 LIKE @pa_desc +'%'                                          
			AND    entm_short_name LIKE @pa_desc +'%'    
        --                        
        END                           
                      
        SET ROWCOUNT @pa_maximumRows                                           
                
        SELECT distinct entm_short_name   Entity_Short_Name                                            
              ,entm_parent_id    entity_parent_id                                            
              ,enttm_parent_cd   entity_type_parent_cd                   
              ,entm_name1        Entity_Name1                                            
              ,enttm_id          enttm_id                                            
              ,entm_id           entity_id                          
       ,@l_count          totalrecord                        
        FROM   entity_mstr                        
              ,entity_type_mstr                                            
        WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                            
        AND    entm_enttm_cd like @pa_cd +'%'                 
       -- AND    entm_name1 LIKE @pa_desc +'%'                                           
		AND    entm_short_name LIKE @pa_desc +'%'    
        AND    ISNULL(entm_id,0)>= @first_id 
        AND    entm_deleted_ind=1                       
      --                      
      END                      
      ELSE                      
      BEGIN                      
      --                      
        SELECT @first_id = entm_id                                          
        FROM   entity_mstr                        
               ,entity_type_mstr                                            
        WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
        AND    entm_enttm_cd like @pa_cd +'%'                                            
        AND    enttm_parent_cd like @pa_code +'%'                                            
        ORDER BY entm_id                            
                
        IF @pa_startRowIndex = 1                           
        BEGIN                        
        --                        
           SELECT @l_count =COUNT(entm_id)                                          
           FROM   entity_mstr                        
                  ,entity_type_mstr                                            
           WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                          
			AND    entm_enttm_cd like @pa_cd +'%'                                            
           AND    enttm_parent_cd like @pa_code +'%'                                            
        --                        
        END                           
                
        SET ROWCOUNT @pa_maximumRows                                           
                
        SELECT distinct entm_short_name   Entity_Short_Name                                            
               ,entm_parent_id    entity_parent_id                                            
               ,enttm_parent_cd   entity_type_parent_cd                                   
               ,entm_name1        Entity_Name1                                            
               ,enttm_id          enttm_id                                            
               ,entm_id           entity_id                          
               ,@l_count          totalrecord                        
        FROM   entity_mstr                        
              ,entity_type_mstr                                            
        WHERE  entity_mstr.entm_enttm_cd =entity_type_mstr.enttm_cd                                            
        AND    entm_enttm_cd like @pa_cd +'%'                 
        AND    entm_short_name LIKE @pa_desc +'%'                
        AND    enttm_parent_cd LIKE @pa_code +'%'                
        AND    ISNULL(entm_id,0)>= @first_id 
        AND    entm_deleted_ind=1                  
         --                      
       END                      
      --                         
      END                        
      --                        
     END                         
     --                         
  END     /*end */                                 
                            
 /* CLIENT HELP  */                                    
                                        
 IF @pa_action='CLIENT'                                     
 BEGIN                                      
 --                       
   DECLARE @l_dpm_id  INTEGER                 
                        
--   IF @pa_value='CLIENTAllDP'             
--   BEGIN            
--   --          
--      SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
--      IF @pa_startRowIndex = 0                
--      SET @pa_startRowIndex = 1                                                      
--      SET ROWCOUNT @pa_startRowIndex                     
--                  
--      SELECT @first_id =clim_crn_no             
--      FROM   client_mstr            
--      WHERE clim_deleted_ind = 1            
--      AND clim_name1 like @pa_desc +'%'              
--                  
--      IF @pa_startRowIndex = 1                    
--      BEGIN            
--      --            
--         SELECT @l_count =COUNT(clim_crn_no)            
--         FROM   client_mstr            
--         WHERE clim_deleted_ind = 1            
--         AND clim_name1 like @pa_desc +'%'             
--      --            
--      END            
--                  
--      SET ROWCOUNT @pa_maximumRows                
--                  
--      SELECT clim_crn_no        Client_Id                
--             ,CLIM_NAME1       Client_Name            
--             ,clim_short_name  shortname            
--             , @l_count        totalrecords            
--      From client_mstr            
--      WHERE clim_deleted_ind = 1            
--      AND   clim_crn_no >= @first_id            
--      AND   clim_name1 like @pa_desc +'%'             
--      ORDER BY clim_name1            
--                  
--      SET ROWCOUNT 0            
--                  
--                  
--   --            
--   END        
 
   IF @pa_value='CLIENTAllDP'             
   BEGIN            
   --   
      /*SET @pa_startRowIndex =  (@pa_startRowIndex - 1) * @pa_maximumRows                                                      
      IF @pa_startRowIndex = 0                
      SET @pa_startRowIndex = 1                                                      
      SET ROWCOUNT @pa_startRowIndex                     
                  
--      SELECT @first_id =clim_crn_no             
--      FROM   client_mstr            
--      WHERE clim_deleted_ind = 1            
--      AND clim_name1 like @pa_desc +'%'  
 
		  SELECT @first_id = clim_crn_no               
		  FROM   client_mstr, dp_acct_mstr              
		  WHERE clim_deleted_ind = 1 AND DPAM_DELETED_IND = 1
		  AND  clim_crn_no = DPAM_CRN_NO            
		  AND clim_name1 like @pa_desc +'%'            
	                  
                  
      IF @pa_startRowIndex = 1                    
      BEGIN            
      --            
--         SELECT @l_count =COUNT(clim_crn_no)            
--         FROM   client_mstr            
--         WHERE clim_deleted_ind = 1            
--         AND clim_name1 like @pa_desc +'%'

			SELECT @l_count =COUNT(clim_crn_no)            
			FROM   client_mstr , dp_acct_mstr          
			WHERE clim_deleted_ind = 1 AND DPAM_DELETED_IND = 1
			AND  clim_crn_no = DPAM_CRN_NO           
			AND clim_name1 like @pa_desc +'%'   

			          
      --            
      END            
                  
      SET ROWCOUNT @pa_maximumRows                
                  
--      SELECT clim_crn_no        Client_Id                
--             ,CLIM_NAME1       Client_Name            
--             ,clim_short_name  shortname            
--             , @l_count        totalrecords            
--      From client_mstr            
--      WHERE clim_deleted_ind = 1            
--      AND   clim_crn_no >= @first_id            
--      AND   clim_name1 like @pa_desc +'%'             
--      ORDER BY clim_name1     

		SELECT clim_crn_no        Client_Id                  
		,CLIM_NAME1       Client_Name              
		,DPAM_SBA_NO  shortname              
		, @l_count        totalrecords              
		From client_mstr  , dp_acct_mstr             
		WHERE clim_deleted_ind = 1 AND DPAM_DELETED_IND = 1
		AND  clim_crn_no = DPAM_CRN_NO              
		AND   clim_crn_no >= @first_id              
		AND   clim_name1 like @pa_desc +'%'               
		ORDER BY clim_name1        
                  
      SET ROWCOUNT 0 */
	SET ROWCOUNT 0            
                 
     --SELECT  @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_cd and dpm_deleted_ind =1                       
                        
                   
     DECLARE @TBLCLLIST1  TABLE (TID int IDENTITY PRIMARY KEY,clim_crn_no numeric, clim_name1 varchar(100)  ,dpam_sba_no varchar(16), clim_short_name varchar(100))                
--    if @pa_stat = 'Y'                 
--    BEGIN          
	 --          
	 INSERT INTO @TBLCLLIST1                  
	 SELECT clim_crn_no                   
	 ,DPAM_SBA_NAME                  
	 ,dpam_sba_no 
     ,clim_short_name  
	 From client_mstr  , dp_acct_mstr             
	 WHERE clim_crn_no = DPAM_CRN_NO 
	 AND DPAM_DELETED_IND = 1
	 AND clim_deleted_ind = 1                           
	 AND clim_name1 like @pa_desc +'%'
                                 
       
    --END                                                      
                                                   
    IF @pa_startRowIndex = 1                              
    BEGIN                     
    --                              
      SELECT @l_count = COUNT(TID) FROM @TBLCLLIST1                  
    --                              
    END                  
                    
    SET @FSTRec = (@pa_startRowIndex - 1) * @pa_maximumRows                  
    SET @LSTRec = (@pa_startRowIndex * @pa_maximumRows + 1)                             
                            
    SELECT  --clim_crn_no        Client_Id  
             DPAM_SBA_NO      Client_Id 
			,CLIM_NAME1       Client_Name              
			--,DPAM_SBA_NO  shortname              
			,clim_short_name shortname
			, @l_count        totalrecords                                              
    FROM  @TBLCLLIST1                  
    WHERE TID > @FSTRec   AND TID < @LSTRec             
    ORDER BY  clim_crn_no            
                  
    SET ROWCOUNT 0                 
    SET @FSTRec = 0                
    SET @LSTRec = 0                  
                                 
   --            
   END                
                
   IF @pa_value='CLIENTALL'  ---FOR ALL ACCOUNTS                                
   BEGIN                                
   --            
     SET ROWCOUNT 0            
                 set @l_dpm_id = 0
     SELECT  @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_cd and dpm_deleted_ind =1                       
                        
                     
     DECLARE @TBLCLLIST  TABLE (TID int IDENTITY PRIMARY KEY,dpam_id numeric,dpam_crn_no numeric  ,dpam_sba_no varchar(16) ,dpam_sba_name varchar(100)  ,acct_type varchar(5))                
    if @pa_stat = 'Y'                 
    BEGIN          
 --          
 INSERT INTO @TBLCLLIST                  
 SELECT  dpam_id                   
 ,dpam_crn_no                   
 ,dpam_sba_no                  
 ,dpam_sba_name                  
 ,acct_type                  
 FROM    CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)                  
 WHERE   dpam_sba_name LIKE @pa_desc +'%'                  
 AND     dpam_sba_no   LIKE '%' + @pa_code            
 AND     dpam_stam_cd ='ACTIVE'      
 AND     getdate()  BETWEEN eff_from AND isnull(eff_to,'dec 31 2100')       
 --          
    END             
    ELSE          
    BEGIN          
 --          
 INSERT INTO @TBLCLLIST                  
 SELECT  dpam_id                   
 ,dpam_crn_no                   
 ,dpam_sba_no                  
 ,dpam_sba_name                  
 ,acct_type                  
 FROM    CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)                  
 WHERE   dpam_sba_name LIKE @pa_desc +'%'                  
 AND     dpam_sba_no   LIKE '%' + @pa_code                
 AND     getdate()  BETWEEN eff_from AND isnull(eff_to,'dec 31 2100')               
 --          
    END                                            
                                                   
    IF @pa_startRowIndex = 1                              
    BEGIN                     
    --                              
      SELECT @l_count = COUNT(TID) FROM @TBLCLLIST                  
    --                              
    END                  
                    
    SET @FSTRec = (@pa_startRowIndex - 1) * @pa_maximumRows                  
    SET @LSTRec = (@pa_startRowIndex * @pa_maximumRows + 1)                             
                            
    SELECT dpam_sba_name Client_Name                                        
           ,dpam_sba_no   Acct_no                                                 
           , dpam_crn_no    Client_Id                                
           ,CASE  WHEN isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = '' THEN 'I' ELSE 'P'END  ACCT_TYPE                              
           ,'' CMBPID                          
           ,@l_count   totalrecords                           
    FROM  @TBLCLLIST                  
    WHERE TID > @FSTRec   AND TID < @LSTRec             
    ORDER BY  dpam_sba_name            
                  
    SET ROWCOUNT 0                 
    SET @FSTRec = 0                
    SET @LSTRec = 0                
   --                                
   END                                
              
  IF @pa_value='CLIENTP'        --FOR POOL ACCT                                      
  BEGIN                                 
  --                     
    SET ROWCOUNT 0                       
    SELECT  @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_cd and dpm_deleted_ind =1                   
    DECLARE @TBLCLLISTP  TABLE (TID int IDENTITY PRIMARY KEY,dpam_id numeric,dpam_crn_no numeric  ,dpam_sba_no varchar(16) ,dpam_sba_name varchar(100)  ,acct_type varchar(5))                 
              
    if @pa_stat = 'Y'            
    BEGIN          
 --                
 INSERT INTO @TBLCLLISTP                
 SELECT                  
  dpam_id                  
  ,dpam_crn_no                   
  ,dpam_sba_no                  
  ,dpam_sba_name                  
  ,acct_type                  
 FROM  CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)                  
 WHERE isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''                
 AND   dpam_sba_name LIKE @pa_desc +'%'                  
 AND     dpam_sba_no   LIKE '%' + @pa_code                            
 AND   dpam_stam_cd = 'ACTIVE'     
  AND     getdate()  BETWEEN eff_from AND eff_to            
 --          
    END           
    ELSE          
    BEGIN          
 --          
 INSERT INTO @TBLCLLISTP                
 SELECT                  
  dpam_id                  
  ,dpam_crn_no                   
  ,dpam_sba_no                  
  ,dpam_sba_name                  
  ,acct_type                  
 FROM  CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)                  
 WHERE isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') <> ''                
 AND   dpam_sba_name LIKE @pa_desc +'%'                  
 AND     dpam_sba_no   LIKE '%' + @pa_code                 
  AND     getdate()  BETWEEN eff_from AND eff_to                   
 --          
    END            
                 
    SELECT  @l_count = COUNT(TID) FROM @TBLCLLISTP                
                 
    SET @FSTRec = (@pa_startRowIndex - 1) * @pa_maximumRows                  
    SET @LSTRec = (@pa_startRowIndex * @pa_maximumRows + 1)                  
                 
    SELECT dpam_sba_name             Client_Name                                        
           ,right(dpam_sba_no,8)          Acct_no                                                 
           ,dpam_crn_no                    Client_Id                                
           ,'P'                            ACCT_TYPE                              
           ,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') CMBPID                          
           ,@l_count                totalrecords                 
    FROM   @TBLCLLISTP                
    WHERE TID  > @FSTRec and TID < @LSTRec           
    ORDER BY dpam_sba_name               
                           
    SET ROWCOUNT 0                 
    SET @FSTRec = 0                
    SET @LSTRec = 0                
  --                                      
 END ---FOR POOL ACCT                                 
                                          
 IF @pa_value='CLIENTI'  --FOR INDVIDUAL ACCOUNTS                                
 BEGIN                                
 --                    
   SET ROWCOUNT 0                        
   --SELECT  @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_cd and dpm_deleted_ind =1                   
                   
   DECLARE @TBLCLLISTI  TABLE (TID int IDENTITY PRIMARY KEY,dpam_id numeric,dpam_crn_no numeric  ,dpam_sba_no varchar(16) ,dpam_sba_name varchar(100)  ,acct_type varchar(5))                  
             
       
 --          
 INSERT INTO @TBLCLLISTI                
 --SELECT                  
 --dpam_id                  
 --,dpam_crn_no                   
 --,dpam_sba_no                  
 --,dpam_sba_name                  
 --,'I' acct_type                  
 ----FROM    CITRUS_USR.FN_ACCT_LIST(@l_dpm_id,@pa_rmks,0)                  
 ----WHERE   isnull(citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID'),'') = ''                
 --FROM DP_ACCT_MSTR WHERE 
 -- dpam_sba_name LIKE @pa_desc +'%'                  
 --AND     dpam_sba_no   LIKE '%' + @pa_code                     
 --AND   dpam_stam_cd = 'ACTIVE'      
 ----AND     getdate()  BETWEEN eff_from AND eff_to     
 --and dpam_sba_no in (Select ONL_TRXFEREE_DPID+ONL_TRXFEREE_BOID from ONLINE_DPTRX_BEN_MSTR where ONL_DELETED_IND=1 and ONL_TRX_BOID=@pa_boid)                
 ----          
 Select  dpam_id   =0               
 ,dpam_crn_no =0                  
 ,ONL_TRXFEREE_BOID dpam_sba_no                  
 ,ONL_TRXFEREE_BONAME dpam_sba_name                  
 ,'I' acct_type                  
 from ONLINE_DPTRX_BEN_MSTR where ONL_DELETED_IND=1 and ONL_TRX_BOID=@pa_boid
 and ONL_TRXFEREE_DPID=case when len(@pa_cd)=6 then 'IN'+@pa_cd else @pa_cd end 
               
                   
   SELECT  @l_count = COUNT(TID) FROM @TBLCLLISTI                  
                 
   SET @FSTRec = (@pa_startRowIndex - 1) * @pa_maximumRows                  
   SET @LSTRec = (@pa_startRowIndex * @pa_maximumRows + 1)                  
                 
   SELECT dpam_sba_name       Client_Name                                        
         ,right(dpam_sba_no,16)  Acct_no                                        
         ,dpam_crn_no     Client_Id                                
         ,'P'                            ACCT_TYPE                              
         ,citrus_usr.fn_acct_entp(dpam_id,'CMBP_ID') CMBPID                          
         ,@l_count                totalrecords                 
   FROM   @TBLCLLISTI                
   WHERE TID  > @FSTRec and TID < @LSTRec                
   SET ROWCOUNT 0                  
   SET @FSTRec = 0                
   SET @LSTRec = 0                
 --                                
 END                                    
--                                    
END  ---CLIENT SEARCH TAG ENDS HERE                            
                          
 IF @pa_action ='ACCOUNT'                        
 BEGIN                        
 --                        
    SET @l_inputstring = @pa_value                        
    SET @l_bank = citrus_usr.fn_splitval(@l_inputstring,1)                         
    set @l_client = citrus_usr.fn_splitval(@l_inputstring,2)                         
    set @l_gl = citrus_usr.fn_splitval(@l_inputstring,3)                 
    set @l_dpmid = citrus_usr.fn_splitval(@l_inputstring,4)                         
    set @l_brcd = citrus_usr.fn_splitval(@l_inputstring,5)                         
    SET @l_tblacctbal_id = citrus_usr.fn_splitval(@l_inputstring,6)                       
    SET @l_entityid = citrus_usr.fn_splitval(@l_inputstring,7)                       
                     
    IF @l_bank = 'Y'                        
    BEGIN                        
    --                        
      SET @l_count = 0                   
      SET ROWCOUNT 0                    
                             
      SET @@SSQL = 'from   @tblbankacclist  acct_list left outer join ACCOUNTBAL'+@l_tblacctbal_id+ '  accbal '                       
      SET @@SSQL = @@SSQL + '  on acct_list.dpam_id = ACCBAL.ACCBAL_ACCT_ID and acct_list.acct_type = ACCBAL.ACCBAL_ACCT_TYPE AND ACCBAL.ACCBAL_ACCT_TYPE IN (''B'',''C'')  '                        
      SET @@SSQL = @@SSQL + '  and ACCBAL.ACCBAL_DELETED_IND = 1 '                      
                
      SET @@SSQLFSTID= '  declare @first_id int,@second_id int,@total_rec bigint'                  
     SET @@SSQLFSTID= @@SSQLFSTID + '  DECLARE @tblbankacclist TABLE (TID int IDENTITY PRIMARY KEY,dpam_id numeric,dpam_crn_no numeric,dpam_sba_no varchar(16),dpam_sba_name varchar(100),acct_type varchar(5))'                  
      SET @@SSQLFSTID= @@SSQLFSTID + '  INSERT INTO @tblbankacclist  select dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,acct_type from  CITRUS_USR.FN_gl_ACCT_LIST(' + CONVERT(VARCHAR,@l_dpmid ) + ',' + CONVERT(VARCHAR,@l_entityid) + ',0)'             
      SET @@SSQLFSTID= @@SSQLFSTID + '  where ACCT_TYPE IN ( ''B'',''C'')'                  
      SET @@SSQLFSTID= @@SSQLFSTID + '  AND  dpam_sba_name LIKE ''' + @pa_cd + '%'''                 
      SET @@SSQLFSTID= @@SSQLFSTID + '  AND  dpam_sba_no LIKE ''' + @pa_code + '%'''+ '                   
                
      SET @first_id = (' + convert(varchar,@pa_startRowIndex) + ' - 1) * '+ convert(varchar,@pa_maximumRows)  +'                
      SET @second_id = (' + convert(varchar,@pa_startRowIndex) + ' * ' + convert(varchar,@pa_maximumRows) + ' + 1)                
      SELECT @total_rec = count(TID) from  @tblbankacclist'                
                
      SET @@SSQLREC = 'SELECT acct_list.dpam_id  ACCID  , acct_list.dpam_sba_no  ACCCODE ,acct_list.dpam_sba_name ACCTNAME'                        
      SET @@SSQLREC = @@SSQLREC+ ', CASE WHEN acct_list.acct_type = ''B'' THEN ''BANK''  ELSE ''CASH'' END     ACCTTYPE ,@total_rec totalrecord, ACCBAL.ACCBAL_AMOUNT  AMOUNT '                        
      SET @@SSQLREC = @@SSQLREC+', SHORTNAME = '''',BRANCHID ='''' '                        
      SET @@SSQLREC = @@SSQLREC  + @@SSQL +' where  TID > @first_id and TID < @second_id   ORDER BY acct_list.dpam_sba_name '                              
                        
      EXEC (@@SSQLFSTID + ' ' + @@SSQLREC)                     
                       
    --                        
    END      
    ELSE                        
    BEGIN                        
    --                        
      SET @@l_acct_chk = ''                        
      SET @@l_gl_chk   = ''                   
                             
      IF  @l_client = 'Y'                            
      BEGIN                        
      --                        
         SET @@l_acct_chk = 'P'                        
      --                        
      END                        
      IF  @l_gl = 'Y'                            
      BEGIN                        
      --                        
        SET @@l_gl_chk   = 'G'                        
      --                        
      END              
                  
      IF @pa_rmks <> ''            
      BEGIN            
      --            
        select @l_dpmid = dpm_id from dp_mstr where dpm_dpid = @l_dpmid and dpm_deleted_ind =1                       
      --            
      END            
                    
      SET ROWCOUNT 0                 
      SET @l_count = 0                
                       
      DECLARE @TBLGLACCTLIST  TABLE (TID int identity primary key,dpam_id numeric,dpam_crn_no numeric,dpam_sba_no varchar(16),dpam_sba_name varchar(100),acct_type varchar(5))                    
                     
      INSERT INTO @TBLGLACCTLIST                  
      SELECT dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,acct_type                   
      FROM  CITRUS_USR.FN_gl_ACCT_LIST(@l_dpmid,@l_entityid,0)                  
      WHERE ACCT_TYPE IN (@@l_acct_chk,@@l_gl_chk)                  
      AND   dpam_sba_name LIKE @pa_cd +'%'                  
      AND   dpam_sba_no   LIKE @pa_code +'%'                
     ORDER BY  dpam_sba_name                          
                   
     SET @FSTRec = (@pa_startRowIndex - 1) * @pa_maximumRows                  
     SET @LSTRec = (@pa_startRowIndex * @pa_maximumRows + 1)                  
                    
     IF @pa_startRowIndex  = 1                
     BEGIN                
     --                
       SELECT @l_count = COUNT(TID) FROM @TBLGLACCTLIST                
     --      
     END                
                           
      SELECT dpam_id          ACCID                        
            , dpam_sba_no       ACCCODE                        
            ,dpam_sba_name       ACCTNAME                        
            , CASE WHEN acct_type = 'G' THEN 'GL' ELSE 'PARTY' END     ACCTTYPE                        
            ,'' AMOUNT                        
            ,'' SHORTNAME                        
            ,0  BRANCHID                    
,@l_count totalrecord                      
      FROM @TBLGLACCTLIST                    
      WHERE   TID > @FSTRec AND  TID < @LSTRec                      
      ORDER BY dpam_sba_name                        
                              
    --                        
    END                        
                            
  --                        
  END  /*END ACCT HELP*/                        
--                                       
END

GO
