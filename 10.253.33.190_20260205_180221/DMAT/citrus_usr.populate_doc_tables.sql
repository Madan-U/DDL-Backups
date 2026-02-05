-- Object: PROCEDURE citrus_usr.populate_doc_tables
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[populate_doc_tables]
AS
BEGIN
--


  DECLARE CR_EXCPM_RECORD CURSOR FOR
  SELECT excpm.excpm_id            excpm_id
  FROM   excsm_prod_mstr           excpm
  WHERE  excpm.excpm_deleted_ind = 1
  
  DECLARE CR_CTGRY_RECORD CURSOR FOR
  SELECT  clicm.clicm_id            clicm_id
  FROM    client_ctgry_mstr         clicm
  WHERE   clicm.clicm_deleted_ind = 1
  
  DECLARE CR_ENTTM_RECORD CURSOR FOR
  SELECT enttm.enttm_id            enttm_id
  FROM   entity_type_mstr          enttm
  WHERE  enttm.enttm_cli_yn      = 0
  AND    enttm.enttm_deleted_ind = 1
  
  DECLARE  @l_excpm_id  NUMERIC
         , @l_clicm_id  NUMERIC
         , @l_enttm_id  NUMERIC
         , @L_COUNTER   NUMERIC
         , @L_DOCM_ID   NUMERIC
         , @l_doc_desc  VARCHAR(200)
         , @l_doc_cd    VARCHAR(25)
         , @DOCM_ID     NUMERIC
  
  OPEN CR_EXCPM_RECORD
  FETCH NEXT FROM CR_EXCPM_RECORD INTO @l_excpm_id
  
  WHILE (@@FETCH_STATUS<> -1)
  BEGIN
  --
    OPEN CR_CTGRY_RECORD
    FETCH NEXT FROM CR_CTGRY_RECORD INTO @l_clicm_id
    
    
    WHILE(@@FETCH_STATUS<> -1)
    BEGIN
    --
      OPEN CR_ENTTM_RECORD
      FETCH NEXT FROM CR_ENTTM_RECORD INTO @l_enttm_id
    
      WHILE(@@FETCH_STATUS<> -1)
      BEGIN
      --
        SET @L_COUNTER =  1
        WHILE @L_COUNTER<18
        BEGIN
        --
          IF  @L_COUNTER = 1
          BEGIN
   --
     SET @L_DOCM_ID  = 1
     SET @l_doc_cd   = 'VI'
     SET @l_doc_desc = 'VOTER ID'
   --
   END
   ELSE IF @L_COUNTER = 2
   BEGIN
          --
            SET @L_DOCM_ID  = 2
            SET @l_doc_cd   = 'PP'
            SET @l_doc_desc = 'PASSPORT'
          --
          END
          ELSE IF @L_COUNTER = 3
          BEGIN
   --
     SET @L_DOCM_ID  = 3
     SET @l_doc_cd   = 'DL'
     SET @l_doc_desc = 'DRIVING LICENSE'
   --
   END
   ELSE IF @L_COUNTER = 4 
   BEGIN
   --
     SET @L_DOCM_ID  = 4
     SET @l_doc_cd   = 'PH'
     SET @l_doc_desc = 'PHOTOGRAPH'
   --
   END
   ELSE IF @L_COUNTER = 5
   BEGIN
   --
     SET @L_DOCM_ID  = 5 
     SET @l_doc_cd   = 'PA'
     SET @l_doc_desc = 'PROOF OF DEMAT A/C'
   --
   END
   ELSE IF @L_COUNTER = 6 
   BEGIN
   --
     SET @L_DOCM_ID  = 6
     SET @l_doc_cd   = 'PB'
     SET @l_doc_desc = 'PROOF OF BANK A/C'
   --
   END
   ELSE IF @L_COUNTER = 7
   BEGIN
   --
     SET @L_DOCM_ID  = 7
     SET @l_doc_cd   = 'XP'
     SET @l_doc_desc = 'XEROX COPY OF PAN NO'
   --
          END
   ELSE IF @L_COUNTER = 8
   BEGIN
   --
     SET @L_DOCM_ID  = 8
     SET @l_doc_cd   = 'IP'
     SET @l_doc_desc = 'INCOME PROOF/BALANCE SHEET'
   --
   END
   ELSE IF @L_COUNTER = 9 
   BEGIN
   --
     SET @L_DOCM_ID  = 9
     SET @l_doc_cd   = 'PD'
     SET @l_doc_desc = 'PARTNERSHIP DEED'
   --
   END
   ELSE IF @L_COUNTER = 10
   BEGIN
          --
            SET @L_DOCM_ID  = 10
     SET @l_doc_cd   = 'TD'
     SET @l_doc_desc = 'TRUST DEED'
   --
   END
   ELSE IF @L_COUNTER = 11
   BEGIN
   --
     SET @L_DOCM_ID  = 11
     SET @l_doc_cd   = 'MD'
     SET @l_doc_desc = 'MEMORANDUM'
   --
   END
   ELSE IF @L_COUNTER = 12
   BEGIN
   --
     SET @L_DOCM_ID  = 12
     SET @l_doc_cd   = 'HD'
     SET @l_doc_desc = 'HUF DECLARATION'
   --
   END
   ELSE IF @L_COUNTER = 13
   BEGIN
   --
     SET @L_DOCM_ID  = 13
        SET @l_doc_cd   = 'PS'
     SET @l_doc_desc = 'PARTNERSHIP  DECLARATION'
   --
   END
   ELSE IF @L_COUNTER = 14 
   BEGIN
   --
     SET @L_DOCM_ID  = 14
     SET @l_doc_cd   = 'TS'
     SET @l_doc_desc = 'TRUST DECLARATION'
   --
   END
   ELSE IF @L_COUNTER = 15
   BEGIN
   --
     SET @L_DOCM_ID  = 15
     SET @l_doc_cd   = 'BR'
     SET @l_doc_desc = 'BOARD RESOLUTION'
   --
   END
   ELSE IF @L_COUNTER = 16
   BEGIN
   --
     SET @L_DOCM_ID  = 16
     SET @l_doc_cd   = 'RN'
     SET @l_doc_desc = 'RISK DISCLOSER FOR NSE'
   --
   END
   ELSE IF @L_COUNTER = 17 
   BEGIN
   --
     SET @L_DOCM_ID  = 17
     SET @l_doc_cd   = 'RB'
     SET @l_doc_desc = 'RISK DISCLOSER FOR BSE'
   --
   END
   ELSE IF @L_COUNTER = 18 
   BEGIN
   --
     SET @L_DOCM_ID  = 18
     SET @l_doc_cd   = 'RF'
     SET @l_doc_desc = 'RISK DISCLOSURE FOR F''&''O'
   --
   END
   
   
   IF (@L_DOCM_ID IS NOT NULL) AND (@L_DOC_CD IS NOT NULL) AND (@L_DOC_DESC IS NOT NULL) 
   BEGIN
   --
       SELECT @DOCM_ID=ISNULL(MAX(DOCM_ID),0)+1 FROM DOCUMENT_MSTR
       
       INSERT INTO document_mstr
                   ( docm_id
                   , docm_doc_id
                   , docm_clicm_id
                   , docm_enttm_id
                   , docm_excpm_id 
                   , docm_cd
                   , docm_desc
                   , docm_mdty
                   , docm_created_by
                   , docm_created_dt
                   , docm_lst_upd_by
                   , docm_lst_upd_dt
                   , docm_deleted_ind
                   )
                   VALUES
                   ( @DOCM_ID
                   , @L_DOCM_ID
                   , @l_clicm_id
                   , @l_enttm_id
                   , @l_excpm_id
                   , @l_doc_cd
                   , @l_doc_desc
                   , 0
                   , USER, GETDATE(), USER, GETDATE(), 1
                          )
                          
   --
   END
          SET @L_COUNTER = @L_COUNTER+1
        --
        END
        
        FETCH NEXT FROM CR_ENTTM_RECORD INTO @l_enttm_id 
      --
      END
      
      CLOSE CR_ENTTM_RECORD
      
      FETCH NEXT FROM CR_CTGRY_RECORD INTO @l_clicm_id
    --
    END
    
    CLOSE CR_CTGRY_RECORD
    
    FETCH NEXT FROM CR_EXCPM_RECORD INTO @l_excpm_id
  --
  END
  
  
  CLOSE CR_EXCPM_RECORD
  
  DEALLOCATE CR_ENTTM_RECORD
  DEALLOCATE CR_CTGRY_RECORD
  DEALLOCATE CR_EXCPM_RECORD
  
--
END

GO
