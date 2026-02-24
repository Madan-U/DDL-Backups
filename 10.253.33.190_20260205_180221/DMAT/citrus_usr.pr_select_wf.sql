-- Object: PROCEDURE citrus_usr.pr_select_wf
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_SELECT_WF '','WFTRACKER','SS','','','1','20/03/2007','02/04/2007','*|~*','|*~|',''



CREATE PROCEDURE  [citrus_usr].[pr_select_wf](@pa_id             VARCHAR(20)
                             ,@pa_action         VARCHAR(20)
                             ,@pa_login_name     VARCHAR(20)
                             ,@pa_cd             VARCHAR(25)
                             ,@pa_desc           VARCHAR(250)
                             ,@pa_values         VARCHAR(8000)
                             ,@pa_from_dt        VARCHAR(11)
                             ,@pa_to_dt          VARCHAR(11)
                             ,@rowdelimiter      CHAR(4) = '*|~*'
                             ,@coldelimiter      CHAR(4) = '|*~|'
                             ,@pa_ref_cur        VARCHAR(8000) OUT
                             )
AS
BEGIN
--
   DECLARE @l_from_dt            VARCHAR(50)
          ,@l_to_dt              VARCHAR(50)
   DECLARE @tblrol               TABLE (rol_id NUMERIC)
   DECLARE @@remainingstring_id  VARCHAR(200)
          ,@@foundat             INTEGER
          ,@@currstring_id       VARCHAR(20)
          ,@@delimeterlength_id  INTEGER
          ,@delimeter_id         char(4)
          ,@l_rol_id             VARCHAR(200)
          
          
  IF @pa_action = 'WFTRACKER'
  BEGIN
  --
          
    SET   @@remainingstring_id  = @PA_VALUES
    SET   @delimeter_id         ='%'+ @rowdelimiter + '%'
    SET   @@delimeterlength_id  = LEN(@rowdelimiter)
    --
    SET @l_from_dt = CONVERT(DATETIME,@pa_from_dt,103)  -- + ' 00:00:00.000'
    SET @l_to_dt   = CONVERT(DATETIME,@pa_to_dt,103)    -- + ' 23:59:59.000'
    --
    WHILE @@remainingstring_id <> ''
    BEGIN
    --
      SET @@foundat = 0
      SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)
      --
      IF  @@foundat > 0
      BEGIN
      --
        SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)
        SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)
      --
      END
      ELSE
      BEGIN
      --
        SET @@currstring_id      = @@remainingstring_id
        SET @@remainingstring_id = ''
      --
      END
      --
      IF @@currstring_id <> ''
      BEGIN
      --
        INSERT INTO @tblrol values (CONVERT(NUMERIC,@@currstring_id))
      --
      END
      --
    END       
    
    
    

     IF @PA_CD = 'A'  
     BEGIN  
     --
         DECLARE  @tb_wfid  TABLE(wfd_id NUMERIC)        
         
         INSERT INTO  @tb_wfid (wfd_id)      
         SELECT DISTINCT wfd.wfd_id    wfd_id      
         FROM  wf_dtls                 wfd  
              ,wf_action_tree          wfat  
              ,rol_wfa_mapping         rowm  
         WHERE wfd.wfd_rowm_id       = wfat.wfat_parent_id 
         AND   wfat.wfat_child_id    = rowm.rowm_id  
         AND   rowm.rowm_rol_id      IN(SELECT rol_id FROM @tblrol) 
         AND   wfd.wfd_status        ='A'
         AND   wfd.wfd_deleted_ind   =1
         AND   wfat.wfat_deleted_ind =1 
         AND   rowm.rowm_deleted_ind =1
      
         SELECT DISTINCT wfa.wfa_desc    wfa_desc      
               ,wfd.wfd_request_id       wfd_request_id      
               ,wfd.wfd_remarks          wfd_remarks      
               ,wfd.wfd_udn_no           wfd_udn_no      
               ,wfd.wfd_acct_no          wfd_acct_no      
               ,wfd.wfd_crn_no           wfd_crn_no      
               ,wfd.wfd_name             wfd_name      
               ,wfpm.wfpm_desc           wfpm_desc      
               ,wfpm.wfpm_cd             wfpm_cd
               --,WFPM.WFPM_ID             WFPM_ID       
               --,WFD.WFD_STATUS           WFD_STATUS      
               ,rowm.rowm_id             rowm_id      
               ,CONVERT(VARCHAR,wfd.wfd_lst_upd_dt,103) wfd_lst_upd_dt
               ,wfd.wfd_lst_upd_dt       order_date
               ,wfd.wfd_id               wfd_id
               ,wfd.wfd_lst_upd_by       wfd_lst_upd_by
         FROM   wf_dtls                  wfd      
               ,rol_wfa_mapping          rowm         
               ,wf_actions               wfa      
               ,wf_process_mstr          wfpm      
         WHERE  wfd.wfd_rowm_id        = rowm.rowm_id      
         AND    rowm_wfa_id            = wfa.wfa_id      
         AND    wfa.wfa_wfpm_id        = wfpm.wfpm_id      
         AND    wfd.wfd_id IN (SELECT WFD_ID FROM @TB_WFID)  
         AND    wfd.wfd_deleted_ind   =1
         AND    wfpm.wfpm_deleted_ind =1 
         AND    rowm.rowm_deleted_ind =1
         AND    wfa.wfa_deleted_ind   =1 
         ORDER  BY order_date DESC
                  ,wfpm_desc  ASC
                  ,wfd_request_id DESC
    
    END 
    ELSE
    BEGIN
    --
      SELECT DISTINCT wfa.wfa_desc    wfa_desc
            ,wfd.wfd_request_id       wfd_request_id
            ,wfd.wfd_remarks          wfd_remarks
            ,wfd.wfd_udn_no           wfd_udn_no
            ,wfd.wfd_acct_no          wfd_acct_no
            ,wfd.wfd_crn_no           wfd_crn_no
            ,wfd.wfd_name             wfd_name
            ,wfpm.wfpm_desc           wfpm_desc
            ,wfpm.wfpm_id             wfpm_id 
            ,wfd.wfd_status           wfd_status
            ,rowm.rowm_id             rowm_id
            ,CONVERT(VARCHAR,wfd.wfd_lst_upd_dt,103) wfd_lst_upd_dt
            ,wfd.wfd_lst_upd_dt       order_date
            ,wfd.wfd_id               wfd_id
            ,wfpm.wfpm_cd             wfpm_cd
            ,wfd.wfd_lst_upd_by       wfd_lst_upd_by
      FROM   wf_dtls                 wfd
            ,rol_wfa_mapping         rowm   
            ,wf_actions              wfa
            ,wf_process_mstr         wfpm
      WHERE  wfd.wfd_rowm_id       = rowm.rowm_id
      AND    rowm_wfa_id           = wfa.wfa_id
      AND    wfa.wfa_wfpm_id       = wfpm.wfpm_id
      AND    rowm.rowm_rol_id      IN(SELECT rol_id FROM @tblrol) 
      AND    wfpm.wfpm_id          LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id END
      --AND    WFD.WFD_STATUS   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END 
      AND    rowm.rowm_id          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc END
      AND    wfd.wfd_lst_upd_dt   >=  CASE WHEN LTRIM(RTRIM(@pa_from_dt)) <> '' THEN CONVERT(DATETIME,@l_from_dt) ELSE '01/01/1900' END --CONVERT(DATETIME,@PA_FROM_DT) 
      AND    wfd.wfd_lst_upd_dt   <=  CASE WHEN LTRIM(RTRIM(@pa_to_dt))   <> '' THEN CONVERT(DATETIME,@l_to_dt)   ELSE '01/01/3000' END --CONVERT(DATETIME,@PA_TO_DT)
      AND    wfd.wfd_deleted_ind   =1
      AND    wfpm.wfpm_deleted_ind =1 
      AND    rowm.rowm_deleted_ind =1
      AND    wfa.wfa_deleted_ind   =1 
      ORDER  BY order_date DESC
               ,wfd_request_id DESC
               ,wfpm_desc  ASC
      
    
                
  --    
  END 
  
  --
  END
  ELSE IF @pa_action = 'WFNEXTACTION'
  BEGIN
  --
     SET   @@remainingstring_id  = @PA_VALUES
     SET   @delimeter_id         ='%'+ @rowdelimiter + '%'
     SET   @@delimeterlength_id  = LEN(@rowdelimiter)
     --
     SET @l_from_dt = CONVERT(DATETIME,@pa_from_dt,103)  -- + ' 00:00:00.000'
     SET @l_to_dt   = CONVERT(DATETIME,@pa_to_dt,103)    -- + ' 23:59:59.000'
     --
     WHILE @@remainingstring_id <> ''
     BEGIN
     --
       SET @@foundat = 0
       SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)
       --
       IF  @@foundat > 0
       BEGIN
       --
         SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)
         SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)
       --
       END
       ELSE
       BEGIN
       --
         SET @@currstring_id      = @@remainingstring_id
         SET @@remainingstring_id = ''
       --
       END
       --
       IF @@currstring_id <> ''
       BEGIN
       --
         INSERT INTO @tblrol values (CONVERT(NUMERIC,@@currstring_id))
       --
       END
       --
     END        
   
     DECLARE  @tb_wftracker  TABLE(wfd_rowm_id NUMERIC)          
     INSERT INTO  @tb_wftracker (wfd_rowm_id)        
     SELECT DISTINCT wfd.wfd_rowm_id    wfd_rowm_id        
     FROM  wf_dtls                      wfd    
          ,wf_action_tree               wfat    
          ,rol_wfa_mapping              rowm    
     WHERE wfd.wfd_rowm_id            = wfat.wfat_parent_id   
     AND   wfat.wfat_child_id         = rowm.rowm_id    
     AND   wfd.wfd_status             = 'A'     
     AND   wfd.wfd_deleted_ind        =1  
     AND   wfat.wfat_deleted_ind      =1   
     AND   rowm.rowm_deleted_ind      =1  

     SELECT wfat_parent_id   rowm_id
           ,wfa.wfa_desc     next_desc 
           ,wfat_child_id    next_rowm_id
     FROM   wf_action_tree      wfat
          , wf_actions          wfa
          , rol_wfa_mapping     rowm
     WHERE  wfat.wfat_child_id = rowm.rowm_id
     AND    rowm.rowm_wfa_id   = wfa.wfa_id
     AND    rowm.rowm_rol_id  IN(SELECT rol_id FROM @tblrol)
     AND    EXISTS (select A.wfd_rowm_id from @tb_wftracker A WHERE A.wfd_rowm_id = wfat.wfat_parent_id )  
     AND    wfa.wfa_deleted_ind   =1
     AND    wfat.wfat_deleted_ind =1 
     AND    rowm.rowm_deleted_ind =1


  
  --    
  END    
  ELSE IF @pa_action = 'WFPM_SEARCH' 
  BEGIN
  --
    SELECT DISTINCT wfpm.wfpm_id wfpm_id
          ,wfpm.wfpm_cd          wfpm_cd
          ,wfpm.wfpm_desc        wfpm_desc
    FROM   wf_process_mstr       wfpm with(nolock)
    WHERE  wfpm.wfpm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'WFPM_SEL' 
  BEGIN
  --
    SELECT wfpm.wfpm_id               wfpm_id
         , wfpm.wfpm_cd               wfpm_cd
         , wfpm.wfpm_desc             wfpm_desc
         , wfpm.wfpm_rmks             wfpm_rmks
         , ''                         errmsg
    FROM   wf_process_mstr            wfpm   with(nolock)
    WHERE  wfpm.wfpm_deleted_ind    = 1
    AND    wfpm.wfpm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END
    AND    wfpm.wfpm_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC END
  --
  END
  ELSE IF @PA_ACTION = 'WFA_SEARCH' 
  BEGIN
  --
    SELECT DISTINCT wfa.wfa_act_cd    wfa_act_cd
    FROM   WF_ACTIONS                wfa with(nolock)
    WHERE  wfa.wfa_deleted_ind    = 1
  --
  END
  ELSE IF @PA_ACTION = 'WFA_SEL' 
  BEGIN
  --
    SELECT wfa.wfa_id               wfa_id
         , wfa.wfa_wfpm_id          wfa_wfpm_id 
         , wfa.wfa_act_cd           wfa_act_cd
         , ISNULL(wfa.wfa_start,0)  wfa_start
         , wfpm.wfpm_cd + '-' + wfa.wfa_desc             value
         , wfa.wfa_desc             wfa_desc 
         , wfa.wfa_rmks             wfa_rmks
         , ''                       errmsg
         
    FROM   wf_actions               wfa   with(nolock)
          ,wf_process_mstr          wfpm
    WHERE  wfa.wfa_deleted_ind    = 1
    AND    wfpm.wfpm_id           = wfa.wfa_wfpm_id
    AND    wfa.wfa_act_cd      LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END
    AND    wfa.wfa_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC END
    
  --
  END
  ELSE IF @PA_ACTION = 'ROLES_SEL'
  BEGIN
  --
    SELECT   rol.rol_id        rol_id
            ,rol.rol_desc      rol_desc 
    FROM     roles             rol
    WHERE    rol_deleted_ind = 1 
    ORDER BY rol_desc

  --
  END 
  ELSE IF @PA_ACTION = 'ACTION_MAP'
  BEGIN
  --
    SELECT rowm.rowm_id       rowm_id
          ,wfa.wfa_desc       wfa_desc 
    FROM   wf_actions         wfa
         , rol_wfa_mapping    rowm
    WHERE  wfa.wfa_id       = rowm.rowm_wfa_id
    AND    rowm_rol_id   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END  
    AND    wfa_wfpm_id   LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC END
    AND    wfa_deleted_ind= 1 
    AND    rowm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION='ACTION_TREE_MAP'
  BEGIN
  --
    SELECT rowm.rowm_id            action_id
          ,wfa.wfa_desc            action_desc
          ,rol.rol_desc            rol_desc
          ,rol.rol_id              rol_id
    FROM   rol_wfa_mapping         rowm
          ,wf_action_tree          wfat
          ,wf_actions              wfa
          ,roles                   rol
    WHERE rowm.rowm_wfa_id       = wfa.wfa_id
    AND   wfat.wfat_child_id     = rowm.rowm_id
    AND   rol.rol_id             = rowm.rowm_rol_id
    AND   wfat.wfat_parent_id LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END  
    AND   wfat.wfat_deleted_ind  = 1
    AND   rowm.rowm_deleted_ind  = 1
    AND   wfa.wfa_deleted_ind  = 1
    AND   rol.rol_deleted_ind  = 1
  --
  END
  ELSE IF @PA_ACTION = 'NEW_ACTION_MAP'
  BEGIN
    --
      SELECT rowm.rowm_id           rowm_id
            ,wfa.wfa_desc           wfa_desc  
      FROM   wf_actions             wfa
            ,rol_wfa_mapping        rowm
      WHERE  wfa.wfa_id           = rowm.rowm_wfa_id
      AND    rowm.rowm_rol_id    IN (SELECT @PA_VALUES)
      AND    wfa.wfa_wfpm_id   LIKE  CASE WHEN LTRIM(RTRIM(@PA_CD)) = '' THEN '%' ELSE @PA_CD END   
      AND    wfa.wfa_deleted_ind  = 1 
      AND    rowm.rowm_deleted_ind= 1

    --
  END
  ELSE IF @PA_ACTION='WFC_CLIENT'
  BEGIN
  --
    SELECT DISTINCT 'CLIENT'       type
          ,clim.clim_crn_no        code
          ,ISNULL(clim.clim_name1+ '-' +clim.clim_name2+'-'+clim.clim_name3+'-'+clim.clim_short_name,'') AS name  
    FROM   client_mstr             clim
    WHERE  clim.clim_deleted_ind = 1 
  --
  END
  ELSE IF @PA_ACTION='WFC_ENTITY'
  BEGIN
  --
    SELECT DISTINCT entm.entm_enttm_cd type
          ,entm.entm_id                code
          ,ISNULL(entm.entm_name1+'-'+entm.entm_short_name,'') name 
    FROM   entity_mstr                 entm
    WHERE  entm.entm_deleted_ind     = 1 
  --
  END
  ELSE IF @PA_ACTION='WFC_CLI_ENT'
  BEGIN
  --
    SELECT DISTINCT 'CLIENT'      type
          ,clim.clim_crn_no       code
         ,ISNULL(clim.clim_name1+ '-' +clim.clim_name2+'-'+clim.clim_name3+'-'+clim.clim_short_name,'') name  
    FROM  client_mstr             clim
    WHERE clim.clim_deleted_ind = 1 
    UNION
    SELECT DISTINCT entm.entm_enttm_cd type
          ,entm.entm_id                code
          ,ISNULL(entm.entm_name1+'-'+entm.entm_short_name,'') name 
    FROM  entity_mstr                  entm
    WHERE entm.entm_deleted_ind=1 
    
  --
  END
  ELSE IF @pa_action = 'ACTION_MAP_NEXT'
  BEGIN
  --
  
  
        
    SET   @@remainingstring_id  = @PA_VALUES
    SET   @delimeter_id         ='%'+ @rowdelimiter + '%'
    SET   @@delimeterlength_id  = LEN(@rowdelimiter)
    WHILE @@remainingstring_id <> ''
    BEGIN
    --
      SET @@foundat = 0
      SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)
      --
      IF  @@foundat > 0
      BEGIN
      --
        SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)
        SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)
      --
      END
      ELSE
      BEGIN
      --
        SET @@currstring_id      = @@remainingstring_id
        SET @@remainingstring_id = ''
      --
      END
      --
      IF @@currstring_id <> ''
      BEGIN
      --
        INSERT INTO @tblrol values (CONVERT(NUMERIC,@@currstring_id))
      --
      END
      --
    END
    IF ISNULL(@pa_desc,'0')='0'
    BEGIN
    --
      SELECT rowm.rowm_id            rowm_id
            ,wfa.wfa_desc            wfa_desc 
      FROM   wf_actions              wfa 
            ,rol_wfa_mapping         rowm
      WHERE  wfa.wfa_id            = rowm.rowm_wfa_id
      AND    rowm.rowm_rol_id                 IN    (SELECT rol_id FROM @tblrol)
      --AND    convert(varchar,wfa.wfa_wfpm_id) LIKE  CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END  
      AND    wfa.wfa_wfpm_id       =  CONVERT(NUMERIC,@PA_CD)
      --AND    wfa.wfa_start         = 1
      AND    wfa.wfa_deleted_ind   = 1 
      AND    rowm.rowm_deleted_ind = 1
      
     
    --
    END
    ELSE
    BEGIN
    --
      SELECT rowm.rowm_id            rowm_id
            ,wfa.wfa_desc            wfa_desc 
      FROM   wf_actions              wfa 
            ,rol_wfa_mapping         rowm
      WHERE  wfa.wfa_id            = rowm.rowm_wfa_id
      AND    rowm.rowm_rol_id                 IN    (SELECT rol_id FROM @tblrol)
      --AND    convert(varchar,wfa.wfa_wfpm_id) LIKE  CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END  
      AND    wfa.wfa_wfpm_id       =  CONVERT(NUMERIC,@PA_CD)
      AND    wfa.wfa_start         = 1
      AND    wfa.wfa_deleted_ind   = 1 
      AND    rowm.rowm_deleted_ind = 1
    --
    END
    
  --
  END
  ELSE IF @PA_ACTION ='WF_HISTORY'
  BEGIN
  --
    SELECT DISTINCT WFA.WFA_DESC     WFA_DESC
          ,wfd.wfd_request_id        wfd_request_id
          ,wfd.wfd_remarks           wfd_remarks
          ,wfd.wfd_udn_no            wfd_udn_no
          ,wfd.wfd_acct_no           wfd_acct_no
          ,wfd.wfd_crn_no            wfd_crn_no
          ,wfd.wfd_name              wfd_name
          ,wfpm.wfpm_desc            wfpm_desc
          ,wfpm.wfpm_id              wfpm_id 
          ,wfd.wfd_status            wfd_status
          ,rowm.rowm_id              rowm_id
          ,CONVERT(VARCHAR,wfd.wfd_lst_upd_dt,103) wfd_lst_upd_dt
          ,wfd.wfd_lst_upd_dt        order_date
          ,wfd.wfd_lst_upd_by        wfd_lst_upd_by
    FROM   wf_dtls                   wfd
          ,rol_wfa_mapping           rowm   
          ,wf_actions                wfa
          ,wf_process_mstr           wfpm
    WHERE  wfd.wfd_rowm_id         = rowm.rowm_id
    AND    rowm_wfa_id             = wfa.wfa_id
    AND    wfa.wfa_wfpm_id         = wfpm.wfpm_id
    AND    wfd.wfd_request_id   LIKE  CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd END  
    ORDER  BY order_date DESC
          ,wfd_request_id DESC
           
    
  --
  END
  ELSE IF @pa_action ='ROWM_SEL'
  BEGIN
    --
      SELECT DISTINCT rowm.rowm_id rowm_id
             ,rowm.rowm_rol_id     rowm_rol_id
             ,rowm.rowm_wfa_id     rowm_wfa_id
             ,''                   errmsg 
      FROM   rol_wfa_mapping       rowm
      WHERE  rowm.rowm_deleted_ind =1 
      AND    rowm.rowm_rol_id   LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd END  
      AND    rowm.rowm_wfa_id   LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc END
      
    --
  END
--
END

GO
