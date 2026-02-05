-- Object: FUNCTION citrus_usr.TO_GET_ENTTM_CD
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[TO_GET_ENTTM_CD](@P_COL_NAME        VARCHAR(50)      
                                ,@P_ENTM_ID         NUMERIC     
                                )      
RETURNS VARCHAR(25)      
AS      
BEGIN      
--      
  DECLARE @@l_enttm_cd VARCHAR(25)    
       
  IF  @P_COL_NAME = 'ENTR_HO'    
  BEGIN     
  --     
    select @@l_enttm_cd   =  enttm_cd from 
    (SELECT enttm_cd     
    FROM   entity_type_mstr     enttm    
         , entity_mstr          entm    
         , entity_relationship  entr    
    WHERE  entr.entr_ho       = entm.entm_id     
    AND    entm.entm_enttm_cd = enttm.enttm_cd    
    AND    entr.entr_ho       = @P_ENTM_ID      
    union
    SELECT  enttm_cd     
    FROM   entity_type_mstr     enttm    
         , entity_mstr          entm    
         , entity_relationship_mak  entr    
    WHERE  entr.entr_ho       = entm.entm_id     
    AND    entm.entm_enttm_cd = enttm.enttm_cd    
    AND    entr.entr_ho       = @P_ENTM_ID       
    AND    entr.entr_deleted_ind   in (0,8)) t
  --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_RE'    
  BEGIN    
  --    
    select @@l_enttm_cd   =  enttm_cd from 
    (SELECT DISTINCT enttm_cd     
    FROM   entity_type_mstr     enttm    
         , entity_mstr          entm    
         , entity_relationship  entr    
    WHERE  entr.entr_re       = entm.entm_id     
    AND    entm.entm_enttm_cd = enttm.enttm_cd    
    AND    entr.entr_re       = @P_ENTM_ID      
    union
    SELECT DISTINCT  enttm_cd     
    FROM   entity_type_mstr     enttm    
         , entity_mstr          entm    
         , entity_relationship_mak  entr    
    WHERE  entr.entr_re       = entm.entm_id     
    AND    entm.entm_enttm_cd = enttm.enttm_cd    
    AND    entr.entr_re       = @P_ENTM_ID      
    AND    entr.entr_deleted_ind   in (0,8)) t
  --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_AR'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (
      SELECT DISTINCT    enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship  entr    
      WHERE  entr.entr_ar       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_ar       = @P_ENTM_ID    
      union
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship_mak  entr    
      WHERE  entr.entr_ar       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_ar       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_BR'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship  entr    
      WHERE  entr.entr_br       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_br       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship_mak  entr    
      WHERE  entr.entr_br       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_br       = @P_ENTM_ID       )  t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_SB'    
    BEGIN    
    --    
     select @@l_enttm_cd   =  enttm_cd from 
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship  entr    
      WHERE  entr.entr_sb       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_sb       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship_mak  entr    
      WHERE  entr.entr_sb       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_sb       = @P_ENTM_ID       
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DL'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship  entr    
      WHERE  entr.entr_dl       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_dl       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship_mak  entr    
      WHERE  entr.entr_dl       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_dl       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_RM'    
    BEGIN    
    --
      select @@l_enttm_cd   =  enttm_cd from 
      (      
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship  entr    
      WHERE  entr.entr_rm       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_rm       = @P_ENTM_ID      
      UNION
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr     enttm    
           , entity_mstr          entm    
           , entity_relationship_MAK  entr    
      WHERE  entr.entr_rm       = entm.entm_id     
      AND    entm.entm_enttm_cd = enttm.enttm_cd    
      AND    entr.entr_rm       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)) t 
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY1'    
    BEGIN    
    --
      select @@l_enttm_cd   =  enttm_cd from     
     (
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy1           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy1       = @P_ENTM_ID      
      union
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy1           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy1       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)
     ) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY2'    
    BEGIN    
    --
      select @@l_enttm_cd   =  enttm_cd from     
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy2           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy2       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy2           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy2       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY3'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from  
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship  entr    
      WHERE  entr.entr_dummy3           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy3       = @P_ENTM_ID      
      union
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak  entr    
      WHERE  entr.entr_dummy3           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy3       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY4'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy4           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy4       = @P_ENTM_ID      
      union
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy4           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy4       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)
      ) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY5'    
    BEGIN    
    --   
      select @@l_enttm_cd   =  enttm_cd from   
      (SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy5           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy5       = @P_ENTM_ID      
      union
      SELECT DISTINCT  enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy5           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy5       = @P_ENTM_ID       
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY6'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy6           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy6       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy6           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy6       = @P_ENTM_ID       
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY7'    
    BEGIN    
    --
      select @@l_enttm_cd   =  enttm_cd from     
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr        enttm    
           , entity_mstr             entm    
           , entity_relationship     entr    
      WHERE  entr.entr_dummy7           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy7       = @P_ENTM_ID      
      union 
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr        enttm    
           , entity_mstr             entm    
           , entity_relationship_mak     entr    
      WHERE  entr.entr_dummy7           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy7       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8) ) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY8'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy8           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy8       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy8           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy8       = @P_ENTM_ID       
      AND    entr.entr_deleted_ind   in (0,8)
      ) t  
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY9'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship      entr    
      WHERE  entr.entr_dummy9           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy9       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr         enttm    
           , entity_mstr              entm    
           , entity_relationship_mak      entr    
      WHERE  entr.entr_dummy9           = entm.entm_id     
      AND    entm.entm_enttm_cd     = enttm.enttm_cd    
      AND    entr.entr_dummy9       = @P_ENTM_ID      
      AND    entr.entr_deleted_ind   in (0,8)) t
    --    
  END    
  ELSE IF   @P_COL_NAME = 'ENTR_DUMMY10'    
    BEGIN    
    --    
      select @@l_enttm_cd   =  enttm_cd from 
      (SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr          enttm    
           , entity_mstr               entm    
           , entity_relationship       entr    
      WHERE  entr.entr_dummy10            = entm.entm_id     
      AND    entm.entm_enttm_cd      = enttm.enttm_cd    
      AND    entr.entr_dummy10       = @P_ENTM_ID      
      union
      SELECT DISTINCT enttm_cd     
      FROM   entity_type_mstr          enttm    
           , entity_mstr               entm    
           , entity_relationship_mak       entr    
      WHERE  entr.entr_dummy10            = entm.entm_id     
      AND    entm.entm_enttm_cd      = enttm.enttm_cd    
      AND    entr.entr_dummy10       = @P_ENTM_ID       
      AND    entr.entr_deleted_ind   in (0,8)) t 
    --    
  END    
      
  RETURN @@l_enttm_cd    
--      
END

GO
