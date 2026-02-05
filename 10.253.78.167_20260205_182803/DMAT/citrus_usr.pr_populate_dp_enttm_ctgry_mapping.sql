-- Object: PROCEDURE citrus_usr.pr_populate_dp_enttm_ctgry_mapping
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_populate_dp_enttm_ctgry_mapping
--sp_help entity_type_mstr
--truncate table entity_type_mstr
--truncate table client_ctgry_mstr
--truncate table enttm_clicm_mapping
--drop table entity_type_mstr
--drop table client_ctgry_mstr
--drop table enttm_clicm_mapping
create PROCEDURE [citrus_usr].[pr_populate_dp_enttm_ctgry_mapping](@pa_exch  varchar(20))
AS
BEGIN
--
  DECLARE @l_bit_location     int
        , @l_final_bit        int
        , @l_clicm_id         numeric
        , @l_enttm_id         numeric
        , @l_subcm_id         numeric 
        , @c_cursor1         cursor
        , @l_entcm_enttm_id  numeric
        --, @c_bit             cursor
  --      
  --IF @pa_exch = 'NSDL'
  --BEGIN--NSDL
  --
    --ENTITY_TYPE_MSTR--
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO  entity_type_mstr VALUES(@l_enttm_id, 'NON_HOUSE', 'NNH', 'NON HOUSE', 1, NULL, 0, USER, getdate(), user, getdate(), 1, 0 , '', '', '')
    --
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO  entity_type_mstr VALUES(@l_enttm_id,'HOUSE','HOU','HOUSE', 1, NULL, 0, USER, getdate(), user, getdate(), 1 , 0 , '', '', '')
    --  
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO  entity_type_mstr VALUES(@l_enttm_id,'CLR_MEMBER','CRM','CLEARING MEMBER', 1, NULL, 0, USER, getdate(), user, getdate(), 1 , 0 , '', '', '')
    
    --**CTGRY FOR BOTH CDSL/NSDL**
    /*
    SELECT  @l_bit_location     = bitrm_bit_location   
    FROM    bitmap_ref_mstr   
    WHERE   bitrm_parent_cd     = 'BUS_DEPOSITORY'
    AND     bitrm_child_cd   LIKE '%NSDL%'
    AND     bitrm_child_cd   LIKE '%CDSL%'
    AND     bitrm_deleted_ind   = 1  
    --
    
    SET @l_bit_location = 0
    --
    SET @c_bit = CURSOR fast_forward FOR 
    SELECT  bitrm_bit_location   
    FROM    bitmap_ref_mstr   
    WHERE   bitrm_parent_cd     = 'BUS_DEPOSITORY'
    AND     bitrm_child_cd   LIKE '%NSDL%'
    AND     bitrm_child_cd   LIKE '%CDSL%'
    AND     bitrm_deleted_ind   = 1  
    -- 
    OPEN @c_bit
    --
    FETCH NEXT FROM @c_bit INTO @l_bit_location
    -- 
    WHILE @@fetch_status      = 0
    BEGIN --#cursor
    --
      SET @l_final_bit =  POWER(2, @l_bit_location-1) | @l_bit_location 
      --
      FETCH NEXT FROM @c_bit INTO @l_bit_location
    -- 
    END
    --
    CLOSE @c_bit
    DEALLOCATE @c_bit
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO client_ctgry_mstr VALUES(@l_clicm_id,'FII','FII','FII',USER, getdate(), user, getdate(),1, @l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO client_ctgry_mstr VALUES(@l_clicm_id,'NRI','NRI','NRI',USER, getdate(), user, getdate(),1, @l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'MUTUAL_FUND','MUTUAL FUND','MUTUAL FUND',USER, getdate(), user, getdate(),1, @l_final_bit)
    */
    SET @l_bit_location         = 0 
    --
    SELECT  @l_bit_location     = bitrm_bit_location   
    FROM    bitmap_ref_mstr   
    WHERE   bitrm_parent_cd     = 'BUS_DEPOSITORY'
    AND     bitrm_child_cd   LIKE '%NSDL%'
    AND     bitrm_deleted_ind   = 1  
    --
    SET @l_final_bit =  POWER(2, @l_bit_location-1) | 0
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'FI','FI','FI',USER, getdate(), user, getdate(),1, @l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'BODY_CORP','BODY CORPORATE ','BODY CORPORATE',USER, getdate(), user, getdate(),1,@l_final_bit)

    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'TRUST_BANK','TRUST AND BANK','TRUST AND BANK',USER, getdate(), user, getdate(),1,@l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'RESIDENT','RESIDENT','RESIDENT',USER, getdate(), user, getdate(),1,@l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'FOREIGN_NAT','FOREIGN NATIONAL','FOREIGN NATIONAL',USER, getdate(), user, getdate(),1,@l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO client_ctgry_mstr VALUES(@l_clicm_id,'FII','FII','FII',USER, getdate(), user, getdate(),1, @l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO client_ctgry_mstr VALUES(@l_clicm_id,'NRI','NRI','NRI',USER, getdate(), user, getdate(),1, @l_final_bit)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id,'MUTUAL_FUND','MUTUAL FUND','MUTUAL FUND',USER, getdate(), user, getdate(),1, @l_final_bit)

    --ENTTM_CLICM_MAPPING--  
    SELECT @l_enttm_id       = enttm_id 
    FROM   entity_type_mstr 
    WHERE  enttm_cd          = 'NON_HOUSE' 
    AND    enttm_deleted_ind = 1
    --
    SET @c_cursor1 = CURSOR fast_forward FOR SELECT clicm_id 
    FROM  client_ctgry_mstr WITH (NOLOCK)
    WHERE clicm_cd IN ('FI','FII','BODY_CORP', 'MUTUAL_FUND', 'TRUST_BANK', 'RESIDENT', 'NRI','FOREIGN_NAT') 
    AND   clicm_deleted_ind = 1 
    ORDER BY clicm_id
    -- 
    OPEN @c_cursor1
    --
    FETCH NEXT FROM @c_cursor1 INTO @l_clicm_id
    -- 
    WHILE @@fetch_status      = 0
    BEGIN --#cursor
    --
      SELECT @l_entcm_enttm_id = isnull(max(ENTCM_ENTTM_ID),0) + 1 
      FROM   enttm_clicm_mapping WITH (NOLOCK)
      --
      INSERT INTO  enttm_clicm_mapping VALUES(@l_entcm_enttm_id, @l_clicm_id, user, getdate(), user, getdate(),1) 
      --
      FETCH NEXT FROM @c_cursor1 INTO @l_clicm_id
    -- 
    END--#cursor
    --
    CLOSE @c_cursor1
    DEALLOCATE @c_cursor1
    --

    SELECT @l_enttm_id       = enttm_id 
    FROM   entity_type_mstr 
    WHERE  enttm_cd          = 'HOUSE' 
    AND    enttm_deleted_ind = 1
    --
    SET @c_cursor1 = CURSOR fast_forward FOR SELECT clicm_id 
    FROM  client_ctgry_mstr WITH (NOLOCK)
    WHERE clicm_cd IN ('FI', 'FII', 'BODY_CORP','MUTUAL_FUND', 'TRUST_BANK') 
    AND   clicm_deleted_ind = 1 
    ORDER BY clicm_id
    -- 
    OPEN @c_cursor1
    --
    FETCH NEXT FROM @c_cursor1 INTO @l_clicm_id
    -- 
    WHILE @@fetch_status      = 0
    BEGIN --#cursor
    --
      SELECT @l_entcm_enttm_id = isnull(max(ENTCM_ENTTM_ID),0) + 1 
      FROM   enttm_clicm_mapping
      --
      INSERT INTO  enttm_clicm_mapping VALUES(@l_entcm_enttm_id, @l_clicm_id, user, getdate(), user, getdate(),1) 
      --
      FETCH NEXT FROM @c_cursor1 INTO @l_clicm_id
    -- 
    END--#cursor
    --
    CLOSE @c_cursor1
    DEALLOCATE @c_cursor1
  --  
  --END--nsdl
  --
  --IF @pa_exch = 'CDSL'
  --BEGIN--cdsl
  --
    --
    SELECT  @l_bit_location   = bitrm_bit_location   
    FROM    bitmap_ref_mstr   
    WHERE   bitrm_parent_cd   = 'BUS_DEPOSITORY'
    AND     bitrm_child_cd    LIKE '%CDSL%'
    AND     bitrm_deleted_ind = 1  
    --
    SET @l_final_bit =  POWER(2, @l_bit_location-1) | 0
    
    --ENTITY_TYPE_MSTR - 'REGULAR_BO'    
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO ENTITY_TYPE_MSTR VALUES(@l_enttm_id,'REGULAR_BO','RBO','REGULAR_BO',1,NULL,0,USER,GETDATE(),USER,GETDATE(),1,0,'','','')
        
    --CLIENT_CTGRY_MSTR
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO client_ctgry_mstr VALUES(@l_clicm_id, 'IND', 'INDIVIDUAL' ,'INDIVIDUAL',USER, GETDATE(), USER, GETDATE(),1, @l_bit_location)
            
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id, @l_clicm_id, 'ID', 'INDIVIDUAL-DIRECTOR','INDIVIDUAL-DIRECTOR',USER, GETDATE(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id, @l_clicm_id, 'IDR', 'INDIVIDUAL-DIRECTOR RELATIVE', 'INDIVIDUAL-DIRECTOR RELATIVE',USER, GETDATE(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'IR','INDIVIDUAL-RESIDENT','INDIVIDUAL-RESIDENT',USER, GETDATE(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'IHA','INDIVIDUAL-HUFS/AOPS','INDIVIDUAL-HUFS/AOPS',USER, GETDATE(), GETDATE(),USER, 1)
      
    --CLIENT_CTGRY_MSTR
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)  
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CORP', 'CORPORATE' ,'CORPORATE',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBD','CORPORATE BODY-DOMESTIC','CORPORATE BODY-DOMESTIC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBOCB','CORPORATE BODY-OCB','CORPORATE BODY-OCB',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBGC','CORPORATE BODY-GOVT COMPANY','CORPORATE BODY-GOVT COMPANY',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBCG','CORPORATE BODY-CENTRAL GOVT','CORPORATE BODY-CENTRAL GOVT',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBSG','CORPORATE BODY-STATE GOVT','CORPORATE BODY-STATE GOVT',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBCOB','CORPORATE BODY-CO-OPERATIVE BANK','CORPORATE BODY-CO-OPERATIVE BANK',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBN','CORPORATE BODY-NBFC','CORPORATE BODY-NBFC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBNN','CORPORATE BODY-NON NBFC','CORPORATE BODY-NON NBFC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBB','CORPORATE BODY-BROKER','CORPORATE BODY-BROKER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBGC','CORPORATE BODY-GROUP COMPANY','CORPORATE BODY-GROUP COMPANY',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBFB','CORPORATE BODY-FOREIGN BODIES','CORPORATE BODY-FOREIGN BODIES',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBOTHER','CORPORATE BODY-OTHERS','CORPORATE BODY-OTHERS',user, getdate(), GETDATE(),USER, 1)
    
    --CLIENT_CTGRY_MSTR
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'IFM', 'INDIAN FINANCE INSTITUTE' ,'INDIAN FINANCE INSTITUTE',user, getdate(), user, getdate(), 1, @l_bit_location)
         
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FGSF','FI-GOVERNMENT SPONSERED FI','FI-GOVERNMENT SPONSERED FI',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FS','FI-SFC','FI-SFC',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FIO','FI-OTHERS','FI-OTHERS',user, getdate(), GETDATE(), USER, 1)
    --
    --SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    --INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FMB','FII-MAURITIUS BASED','FII-MAURITIUS BASED',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    --SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    --INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FIIO','FII-OTHERS','FII-OTHERS',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --CLIENT_CTGRY_MSTR
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'BANK', 'BANK' ,'BANK',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'BF','BANK-FOREIGN','BANK-FOREIGN',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'BCO','BANK-CO-OPERATIVE','BANK-CO-OPERATIVE',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'BN','BANK-NATIONALIZED','BANK-NATIONALIZED',user, getdate(),GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'BO','BANK-OTHERS','BANK-OTHERS',user, getdate(), GETDATE(),USER, 1)
    
    --CLIENT_CTGRY_MSTR
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'IC', 'INDIVIDUAL - COMMODITY' ,'INDIVIDUAL - COMMODITY',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBD','CORPORATE BODY-DOMESTIC','CORPORATE BODY-DOMESTIC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBOCB','CORPORATE BODY-OCB','CORPORATE BODY-OCB',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBGCOMP','CORPORATE BODY-GOVT. COMPANY','CORPORATE BODY-GOVT. COMPANY',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBCGOVT','CORPORATE BODY-CENTRAL GOVT','CORPORATE BODY-CENTRAL GOVT',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBSGOVT','CORPORATE BODY-STATE GOVT','CORPORATE BODY-STATE GOVT',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBCOBAN','CORPORATE BODY-CO-OPERATIVE BANK','CORPORATE BODY-CO-OPERATIVE BANK',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBNBFC','CORPORATE BODY-NBFC','CORPORATE BODY-NBFC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBNNBFC','CORPORATE BODY-NON NBFC','CORPORATE BODY-NON NBFC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBBROK','CORPORATE BODY-BROKER','CORPORATE BODY-BROKER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBGCOMP','CORPORATE BODY-GROUP COMPANY','CORPORATE BODY-GROUP COMPANY',user, getdate(),GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBFBODI','CORPORATE BODY-FOREIGN BODIES','CORPORATE BODY-FOREIGN BODIES',user, getdate(),GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CBOTHE','CORPORATE BODY-OTHERS','CORPORATE BODY-OTHERS',user, getdate(), GETDATE(),USER, 1)
   
    --client_ctgry_mstr
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --     
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'HUF', 'HUF' ,'HUF',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'INDHUFAOP','INDIVIDUAL-HUFS/AOPS','INDIVIDUAL-HUFS/AOPS',user, getdate(), GETDATE(),USER, 1)

    --client_ctgry_mstr
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --     
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'TRUST', 'TRUST' ,'TRUST',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'TRUST','TRUST','TRUST',user, getdate(), GETDATE(),USER, 1)
    
    --client_ctgry_mstr
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --     
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'FN', 'FOREIGN NATIONAL' ,'FOREIGN NATIONAL',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FN','FOREIGN NATIONAL','FOREIGN NATIONAL',user, getdate(), GETDATE(),USER, 1)
    
    --client_ctgry_mstr
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --     
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CORCOM', 'CORPORATE-COMMODITY' ,'CORPORATE-COMMODITY',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --SUB_CTGRY_MSTR
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBD','CORPORATE BODY-DOMESTIC','CORPORATE BODY-DOMESTIC',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBOCB','CORPORATE BODY-OCB','CORPORATE BODY-OCB',user, getdate(), GETDATE(),USER,1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBGOV','CORPORATE BODY-GOVT. COMPANY','CORPORATE BODY-GOVT. COMPANY',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBCCOV','CORPORATE BODY-CENTRAL GOVT','CORPORATE BODY-CENTRAL GOVT',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBCOGOV','CORPORATE BODY-STATE GOVT','CORPORATE BODY-STATE GOVT',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBCOBAN','CORPORATE BODY-CO-OPERATIVE BANK','CORPORATE BODY-CO-OPERATIVE BANK',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_BNBFC','CORPORATE BODY-NBFC','CORPORATE BODY-NBFC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_BNNBFC','CORPORATE BODY-NON NBFC','CORPORATE BODY-NON NBFC',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBBRO','CORPORATE BODY-BROKER','CORPORATE BODY-BROKER',user, getdate(),GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_BGCOM','CORPORATE BODY-GROUP COMPANY','CORPORATE BODY-GROUP COMPANY',user, getdate(),GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBFBOD','CORPORATE BODY-FOREIGN BODIES','CORPORATE BODY-FOREIGN BODIES',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CC_CBOTH','CORPORATE BODY-OTHERS','CORPORATE BODY-OTHERS',user, getdate(), GETDATE(),USER, 1)
    --
    DECLARE @l_clicm_bit          int
           
    --
    SET @l_bit_location         = null
    --
    SELECT  @l_bit_location     = bitrm_bit_location   
    FROM    bitmap_ref_mstr   
    WHERE   bitrm_parent_cd     = 'BUS_DEPOSITORY'
    AND     bitrm_child_cd   LIKE '%CDSL%'
    AND     bitrm_deleted_ind   = 1  
    
    --FII--
    SELECT @l_clicm_bit = clicm_bit, @l_clicm_id = clicm_id FROM client_ctgry_mstr WHERE clicm_cd = 'FII' AND clicm_deleted_ind = 1
    --
    SET @l_final_bit =  POWER(2, @l_clicm_bit-1) | @l_bit_location
    --
    UPDATE client_ctgry_mstr set clicm_bit = @l_final_bit WHERE clicm_cd = 'FII' AND clicm_id = @l_clicm_id AND clicm_deleted_ind = 1
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FMB','FII-MAURITIUS BASED','FII-MAURITIUS BASED',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'FIIO','FII-OTHERS','FII-OTHERS',user, getdate(), GETDATE(),USER, 1)
    
    --NRI--
    SET @l_clicm_bit = null
    --
    SET @l_final_bit = null
    --
    SELECT @l_clicm_bit = clicm_bit, @l_clicm_id = clicm_id FROM client_ctgry_mstr WHERE clicm_cd = 'NRI' AND clicm_deleted_ind = 1
    --
    SET @l_final_bit =  POWER(2, @l_clicm_bit-1) | @l_bit_location
    --
    UPDATE client_ctgry_mstr SET clicm_bit = @l_final_bit WHERE clicm_cd = 'NRI' AND clicm_id = @l_clicm_id AND clicm_deleted_ind = 1
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id, 'NRIREP', 'NRI_REPATRIABLE', 'NRI_REPATRIABLE',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'NRINREP','NRI-NON_REPATRIABLE','NRI-NON_REPATRIABLE',user, getdate(), GETDATE(),USER, 1)
    
    --Mutual_fund
    SET @l_clicm_bit = null
    --
    SET @l_final_bit = null
    --
    SELECT @l_clicm_bit = clicm_bit, @l_clicm_id = clicm_id FROM client_ctgry_mstr WHERE clicm_cd = 'MUTUAL_FUND' AND clicm_deleted_ind = 1
    --
    SET @l_final_bit =  POWER(2, @l_clicm_bit-1) | @l_bit_location
    --
    UPDATE client_ctgry_mstr SET clicm_bit = @l_final_bit WHERE clicm_cd = 'MUTUAL_FUND' AND clicm_id = @l_clicm_id AND clicm_deleted_ind = 1
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'NRIREP','NRI_REPATRIABLE','NRI_REPATRIABLE',user, getdate(), getdate(), user, 1)
    
    --entity_type_mstr
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'
    --
    INSERT INTO ENTITY_TYPE_MSTR VALUES(@l_enttm_id,'CM_POOL','CMP','CM_POOL',1,NULL,0,USER,GETDATE(),USER,GETDATE(),1,0,'','','')
    
    --client_ctgry_mstr
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CPOI', 'CM POOL (INDIVIDUAL)' ,'CM POOL (INDIVIDUAL)',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --client_sub_ctgry_mstr
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id, @l_clicm_id, 'CL_MEM', 'CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    
    --client_ctgry_mstr
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CPOC', 'CM POOL (CORPORATE)' ,'CM POOL (CORPORATE)',user, getdate(), user, getdate(), 1, @l_bit_location)
    
    --client_sub_ctgry_mstr
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    
    --client_ctgry_mstr
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CISAB', 'CM INESTOR SECURITIES A/C BSE' ,'CM INESTOR SECURITIES A/C BSE',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CISAN', 'CM INESTOR SECURITIES A/C NSE' ,'CM INESTOR SECURITIES A/C NSE',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CISAA', 'CM INESTOR SECURITIES A/C ASE' ,'CM INESTOR SECURITIES A/C ASE',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CISAC', 'CM INESTOR SECURITIES A/C CSE' ,'CM INESTOR SECURITIES A/C CSE',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CISAD', 'CM INESTOR SECURITIES A/C DSE' ,'CM INESTOR SECURITIES A/C DSE',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CISAO', 'CM INESTOR SECURITIES A/C OTCEI' ,'CM INESTOR SECURITIES A/C OTCEI',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    
    --Entity_type_mstr
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO ENTITY_TYPE_MSTR VALUES(@l_enttm_id,'CL_MEM_ACC','CLA','CLEARING_MEMBER_ACC',1,NULL,0,USER,GETDATE(),USER,GETDATE(),1,0,'','','')
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --     
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'NCM', 'NSCCL CLEARING MEMBER' ,'NSCCL CLEARING MEMBER',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    ---    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'ACA', 'AHMEDABAD CM A/C' ,'AHMEDABAD CM A/C',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id, @l_clicm_id, 'CL_MEM', 'CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(),USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CCA', 'CSE CM A/C' ,'CSE CM A/C',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'DCA', 'DSE CM A/c' ,'DSE CM A/C',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id, @l_clicm_id, 'CL_MEM', 'CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'OCA', 'OTCEI CM A/c' ,'OTCEI CM A/c',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO ENTITY_TYPE_MSTR VALUES(@l_enttm_id,'CM_PRIN','CMP','CM_PRINCIPAL',1,NULL,0,USER,GETDATE(),USER,GETDATE(),1,0,'','','')
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    ---     
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CPI', 'CM PRINCIPAL (INDIVIDUAL)' ,'CM PRINCIPAL (INDIVIDUAL)',user, getdate(), user, getdate(), 1, @l_bit_location)
    ---
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CPC', 'CM PRINCIPAL (CORPORATE)' ,'CM PRINCIPAL (CORPORATE)',user, getdate(), user, getdate(), 1, @l_bit_location)    
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO ENTITY_TYPE_MSTR VALUES(@l_enttm_id,'CM_ESCROW','CMS','CM_ESCROW',1,NULL,0,USER,GETDATE(),USER,GETDATE(),1,0,'','','')
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'SLA', 'SETTLEMENT LIEN ACCOUNT (CM ESCROW)' ,'SETTLEMENT LIEN ACCOUNT (CM ESCROW)',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    
    --ENTITY_TYPE_MSTR - 'CM VB' 
    SELECT @l_enttm_id        =  bitrm_bit_location+1  
    FROM   bitmap_ref_mstr       WITH(NOLOCK)  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --  
    UPDATE bitmap_ref_mstr       WITH(ROWLOCK)  
    SET    bitrm_bit_location =  bitrm_bit_location+1  
    WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
    AND    bitrm_child_cd     = 'ENTITY_ID'  
    --
    INSERT INTO ENTITY_TYPE_MSTR VALUES(@l_enttm_id,'CM_VB','CMV','CM VB',1,NULL,0,USER,GETDATE(),USER,GETDATE(),1,0,'','','')
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --        
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'CVBP', 'CM VYAJ BADLA POOL' ,'CM VYAJ BADLA POOL',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
    --
    SELECT @l_clicm_id = isnull(max(clicm_id),0)+1 FROM client_ctgry_mstr WITH (NOLOCK)
    --    
    INSERT INTO  client_ctgry_mstr VALUES(@l_clicm_id, 'NAA', 'NSCCL ALBM A/C' ,'NSCCL ALBM A/C',user, getdate(), user, getdate(), 1, @l_bit_location)
    --
    SELECT @l_subcm_id = isnull(max(subcm_id),0)+1 FROM sub_ctgry_mstr WITH (NOLOCK)
    --
    INSERT INTO SUB_CTGRY_MSTR VALUES(@l_subcm_id,@l_clicm_id,'CL_MEM','CLEARING MEMBER','CLEARING MEMBER',user, getdate(), GETDATE(), USER, 1)
  --
  --END--cdsl
--
END

GO
