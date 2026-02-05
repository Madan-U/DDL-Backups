-- Object: PROCEDURE citrus_usr.DEFAULT_ACCPM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from account_property_mstr where entpm_cd='VSATOFF' entpm_clicm_id = 18          
--select * from entpm_dtls_mstr where entdm_cd='pan_name'           
--select * from excsm_prod_mstr          
--SELECT * FROM CLIENT_CTGRY_MSTR ccm          
--begin transaction          
--DEFAULT_ENTPM 'select','P',18,54717,3,'GEOGRAPHICAL','','',''     
--DEFAULT_ENTPM 'select','P',0,0,0,'GEOGRAPHICAL','','',''          
--rollback transaction          
--alter table accpm_hst add accpm_default_val varchar(50)          
--alter table account_property_mstr add accpm_default_val varchar(50)          
--alter table accpm_mak add accpm_default_val varchar(50)          
--alter table accdm_hst add accdm_default_val varchar(50)          
--alter table accpm_dtls_mstr add accdm_default_val varchar(50)          
--alter table accdm_mak add accdm_default_val varchar(50)          
create PROCEDURE [citrus_usr].[DEFAULT_ACCPM](@pa_action varchar(25)        
,@pa_level char(1)        
,@L_CLICM_ID NUMERIC        
,@L_ENTTM_ID NUMERIC        
,@l_excpm_id numeric        
,@L_ENTPM_CD VARCHAR(50)        
,@l_entdm_cd varchar(50)        
,@l_default_val varchar(50)        
,@pa_out     varchar(8000) out )          
AS          
BEGIN          
--          
IF @pa_level = 'P'          
begin          
 IF @pa_action = 'SELECT'          
 BEGIN          
   SELECT DISTINCT accpm_prop_cd   mncd        
   ,accpm_prop_desc  mndsc        
   ,accpm_datatype  datatype      
  , ''  cd    
  ,''   dsc     
   ,isnull(accpm_default_val,'') Default_val        
   ,isnull(clicm_id ,0) clicm_id       --CASE WHEN @L_CLICM_ID = 0 THEN 0 ELSE @L_CLICM_ID END      
   ,isnull(clicm_desc,'') clicm_desc          
   ,isnull(enttm_id ,0) enttm_id       --CASE WHEN @L_enttm_ID = 0 THEN 0 ELSE @L_enttm_ID END enttm_id          
   ,isnull(enttm_desc,'') enttm_desc          
   ,isnull(excpm_id,0) excpm_id          
   ,isnull(excsm_exch_cd,'')+' '+isnull(excsm_seg_cd,'')+' '+isnull(prom_desc,'')  excpm_desc        
   FROM account_property_mstr entpm           
   LEFT OUTER JOIN           
   CLIENT_CTGRY_MSTR ccm ON accpm_clicm_id = clicm_id          
   LEFT OUTER JOIN           
   ENTITY_TYPE_MSTR etm ON accpm_enttm_id = enttm_id          
   LEFT OUTER JOIN           
   EXCSM_PROD_MSTR epm ON accpm_excpm_id = excpm_id          
   left outer join     
   exch_seg_mstr on excsm_id = accpm_excpm_id    
   left outer join     
   product_mstr on prom_id = excpm_prom_id    
   WHERE CASE WHEN @l_clicm_id = 0 THEN 0 ELSE accpm_clicm_id END = @l_clicm_id           
   AND CASE WHEN @l_enttm_id = 0 THEN 0 ELSE accpm_enttm_id END = @l_enttm_id           
   AND CASE WHEN @l_excpm_id = 0 THEN 0 ELSE accpm_excpm_id END = @l_excpm_id           
   AND CASE WHEN @l_entpm_cd = '' THEN '' ELSE accpm_prop_cd END = @l_entpm_cd          
   AND accpm_deleted_ind = 1        
  order by   excpm_desc    
            
 END          
 ELSE IF @pa_action ='EDIT'          
 BEGIN          
            
             
  UPDATE entpm           
  SET accpm_default_val = @l_default_val          
  FROM account_property_mstr entpm          
  WHERE  CASE WHEN @l_clicm_id = 0 THEN 0 ELSE accpm_clicm_id END = @l_clicm_id           
     AND CASE WHEN @l_enttm_id = 0 THEN 0 ELSE accpm_enttm_id END = @l_enttm_id           
     AND CASE WHEN @l_excpm_id = 0 THEN 0 ELSE accpm_excpm_id END = @l_excpm_id           
  AND   accpm_prop_cd = @L_ENTPM_CD          
           
            
 END          
end           
ELSE IF @pa_level='C'          
BEGIN          
 IF @pa_action = 'SELECT'          
 BEGIN          
   SELECT DISTINCT accdm_cd  cd        
   ,accdm_desc  dsc        
   ,accdm_datatype  datatype     
   , accpm_prop_cd   mncd         
   , accpm_prop_desc  mndsc       
   ,isnull(accdm_default_val,'') Default_val        
   ,isnull(clicm_id ,0) clicm_id       --CASE WHEN @L_CLICM_ID = 0 THEN 0 ELSE @L_CLICM_ID END      
   ,isnull(clicm_desc,'') clicm_desc          
   ,isnull(enttm_id ,0) enttm_id       --CASE WHEN @L_enttm_ID = 0 THEN 0 ELSE @L_enttm_ID END enttm_id          
   ,isnull(enttm_desc,'') enttm_desc          
   ,isnull(excpm_id,0) excpm_id    
   ,isnull(excsm_exch_cd,'')+' '+isnull(excsm_seg_cd,'')+' '+isnull(prom_desc,'')  excpm_desc    
   FROM account_property_mstr entpm          
   LEFT OUTER JOIN           
   CLIENT_CTGRY_MSTR ccm ON accpm_clicm_id = clicm_id          
   LEFT OUTER JOIN           
   ENTITY_TYPE_MSTR etm ON accpm_enttm_id = enttm_id          
   LEFT OUTER JOIN           
   EXCSM_PROD_MSTR epm ON accpm_excpm_id = excpm_id       
   left outer join     
   exch_seg_mstr on excsm_id = excpm_excsm_id    
   left outer join     
   product_mstr on prom_id = excpm_prom_id       
   ,    accpm_dtls_mstr edm          
   WHERE accdm_accpm_prop_id = accpm_prop_id           
   AND CASE WHEN @l_clicm_id = 0 THEN 0 ELSE accpm_clicm_id END = @l_clicm_id           
   AND CASE WHEN @l_enttm_id = 0 THEN 0 ELSE accpm_enttm_id END = @l_enttm_id           
   AND CASE WHEN @l_excpm_id = 0 THEN 0 ELSE accpm_excpm_id END = @l_excpm_id           
   AND accpm_prop_cd = @L_entpm_cd          
   AND CASE WHEN @l_entdm_cd = '' THEN '' ELSE accdm_cd END = @L_entdm_cd          
   AND accpm_deleted_ind = 1          
   AND accdm_deleted_ind = 1      
   order by   excpm_desc        
            
 END          
 ELSE IF @pa_action ='EDIT'          
 BEGIN          
            
            
  UPDATE entdm           
  SET accdm_default_val = @l_default_val          
  FROM account_property_mstr entpm          
  , accpm_dtls_mstr entdm          
  WHERE accpm_prop_id = accdm_accpm_prop_id           
  AND CASE WHEN @l_clicm_id = 0 THEN 0 ELSE accpm_clicm_id END = @l_clicm_id           
     AND CASE WHEN @l_enttm_id = 0 THEN 0 ELSE accpm_enttm_id END = @l_enttm_id           
     AND CASE WHEN @l_excpm_id = 0 THEN 0 ELSE accpm_excpm_id END = @l_excpm_id           
  AND   accpm_prop_cd = @L_ENTPM_CD          
  AND   accdm_cd = @l_entdm_cd          
             
            
 END          
END          
          
--SELECT * FROM ENTPM_DTLS_MSTR entdm      
--select * from entity_type_mstr        
--          
END

GO
