-- Object: PROCEDURE citrus_usr.pr_auto_ucc
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--SELECT * FROM ENTITY_PROPERTIES ORDER BY  1 DESC    
--SELECT * FROM ENTITY_MSTR ORDER BY 1 DESC    
CREATE   PROCEDURE [citrus_usr].[pr_auto_ucc](@pa_ent_id         NUMERIC         
       ,@pa_sbu_id         NUMERIC       
       ,@pa_inst_yn        varchar(20)        
       ,@pa_ref_cur        VARCHAR(1000) OUTPUT        
                             )        
AS        
BEGIN        
--        
  DECLARE @l_enttm_cd     VARCHAR(25)         
         ,@l_ucc_no       VARCHAR(20)        
         ,@l_max_lc       VARCHAR(20)        
         ,@l_sqn_party_cd VARCHAR(10)     
         ,@l_sbum_end_no  VARCHAR(20)    
         ,@l_sbum_cur_no  VARCHAR(20)     
          
  --SELECT @l_enttm_cd = entm_enttm_cd FROM entity_mstr WHERE entm_id = @pa_ent_id AND entm_deleted_ind = 1        
    
  SELECT @l_sbum_end_no = sbum_end_no from sbu_mstr  where sbum_id = @pa_sbu_id  AND sbum_deleted_ind = 1    
    
       
      
  SELECT @l_max_lc = convert(char(3),RIGHT(entp_value,3))     
  FROM   entity_mstr     
       , entity_properties     
  WHERE entp_deleted_ind = 0    
  AND   entm_deleted_ind = 1    
  AND   entm_id          = entp_ent_id    
  AND   entp_entpm_cd    = 'LC'    
  AND   entm_id          = @pa_ent_id     
      
      
  SELECT @l_sbum_cur_no = entp_value    
  FROM   entity_mstr     
       , entity_properties     
  WHERE entp_deleted_ind = 0    
  AND   entm_deleted_ind = 1    
  AND   entm_id          = entp_ent_id    
  AND   entp_entpm_cd    = convert(varchar,@pa_sbu_id) + '_CUR_VAL'    
  AND   entm_id          = @pa_ent_id     
      
      
      
  if ISNULL(@l_max_lc,'') <> ''    
  BEGIN    
  --    
    
      
    
                                            
    SET @l_ucc_no = CASE LEN(@l_max_lc) WHEN 1 THEN '00' + @l_max_lc    
          WHEN 2 THEN '0'  + @l_max_lc    
          ELSE @L_MAX_LC  END    
          + CASE LEN(@l_sbum_cur_no)       
          WHEN 1 THEN  '0000'+ @l_sbum_cur_no    
          WHEN 2 THEN  '000' + @l_sbum_cur_no    
          WHEN 3 THEN  '00'  + @l_sbum_cur_no    
          WHEN 4 THEN  '0'   + @l_sbum_cur_no    
          ELSE @l_sbum_cur_no    
          END     
                                           
    
    IF CONVERT(NUMERIC,@l_sbum_cur_no)  >  CONVERT(NUMERIC,@l_sbum_end_no)    
    BEGIN    
    --    
      SET @pa_ref_cur = 'CLIENT CODE AVAILABLE FOR THIS SBU HAS BEEN EXHAUSTED'         
    --    
    END    
    ELSE    
    BEGIN    
    --    
      UPDATE entity_properties     
      SET  entp_value = CASE LEN(CONVERT(NUMERIC,@l_sbum_cur_no) + 1)  WHEN 1 THEN  '0000'+ CONVERT(VARCHAR,CONVERT(NUMERIC,@l_sbum_cur_no + 1))    
                                                                     WHEN 2 THEN  '000' + CONVERT(VARCHAR,CONVERT(NUMERIC,@l_sbum_cur_no + 1))    
                                                                     WHEN 3 THEN  '00'  + CONVERT(VARCHAR,CONVERT(NUMERIC,@l_sbum_cur_no + 1))    
                                                                     WHEN 4 THEN  '0'   + CONVERT(VARCHAR,CONVERT(NUMERIC,@l_sbum_cur_no + 1))    
                                                                     ELSE CONVERT(VARCHAR,CONVERT(NUMERIC,@l_sbum_cur_no + 1))    
                                                                     END     
    
     FROM entity_mstr     
        , entity_properties     
     WHERE entp_deleted_ind = 0    
     AND   entm_deleted_ind = 1    
     AND   entm_id          = entp_ent_id    
     AND   entp_entpm_cd    = convert(varchar,@pa_sbu_id) + '_CUR_VAL'    
     AND   entm_id          = @pa_ent_id     
         
         
      SET @pa_ref_cur = @l_ucc_no       
       
           
    --    
    END     
  --    
  END    
    
--        
END

GO
