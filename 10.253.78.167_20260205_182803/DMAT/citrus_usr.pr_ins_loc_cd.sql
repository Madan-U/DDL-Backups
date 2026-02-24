-- Object: PROCEDURE citrus_usr.pr_ins_loc_cd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_loc_cd](@pa_enttm_cd VARCHAR(25))
AS
BEGIN
--
  DECLARE @c_entity CURSOR
  DECLARE @entm_id  NUMERIC
         ,@l_entp_entpm_prop_id NUMERIC
         ,@l_loc_cd varchar(25)
         ,@l_entp_id numeric
         ,@l_entpm_prop_id numeric
         ,@l_entpm_cd  varchar(25)

  SET @c_entity = CURSOR FAST_FORWARD FOR   
  SELECT entm_id
  FROM   entity_mstr
  WHERE  entm_deleted_ind = 1
  AND    entm_enttm_cd    = @pa_enttm_cd
  


   
  IF @pa_enttm_cd ='BR'
  BEGIN
  --
    SET @l_loc_cd = '0001'
  --
  END   
  IF @pa_enttm_cd ='SB' or @pa_enttm_cd ='FR'
  BEGIN
  --
    SET @l_loc_cd = '1001'
  --
  END   
   
  OPEN @c_entity
      
  FETCH NEXT FROM  @c_entity
  INTO  @entm_id
      
      
  WHILE @@FETCH_STATUS = 0
  BEGIN
  --
    SELECT @l_entp_id = max(entp_id) + 1 FROM entity_properties WHERE entp_deleted_ind = 1
    
    SELECT @l_entpm_prop_id = entpm_prop_id
          ,@l_entpm_cd      = entpm_cd
    FROM   entity_property_mstr
    WHERE  entpm_cd         = 'LC'
    
    SET @l_loc_cd = @l_loc_cd + 1 
    
    SET @l_loc_cd = case when len(@l_loc_cd) = 1 then '000'+@l_loc_cd 
                         when len(@l_loc_cd) = 2 then '00' +@l_loc_cd                        
                         when len(@l_loc_cd) = 3 then '0'  +@l_loc_cd                        
                         when len(@l_loc_cd) = 4 then @l_loc_cd                        
                         end
 
    INSERT INTO entity_properties(entp_id
                                 ,entp_ent_id  
                                 ,entp_acct_no
                                 ,entp_entpm_prop_id 
                                 ,entp_entpm_cd        
                                 ,entp_value
                                 ,entp_created_by
                                 ,entp_created_dt
                                 ,entp_lst_upd_by
                                 ,entp_lst_upd_dt
                                 ,entp_deleted_ind 
                                 )
                           values(@l_entp_id 
                                 ,@entm_id
                                 ,''
                                 ,@l_entpm_prop_id
                                 ,@l_entpm_cd
                                 ,@l_loc_cd
                                 ,'HO'
                                 ,getdate()
                                 ,''
                                 ,getdate()
                                 ,1
                                  )

    
    
    
    FETCH NEXT FROM  @c_entity
    INTO @entm_id
  --
  END

   CLOSE       @c_entity
   DEALLOCATE  @c_entity
  
  
--
end

--

GO
