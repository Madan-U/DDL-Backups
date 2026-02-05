-- Object: PROCEDURE citrus_usr.pr_autobrokimport
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from brokerage_mstr      
--pr_autobrokimport 'CLASS'      
CREATE PROCEDURE [citrus_usr].[pr_autobrokimport](@pa_productname VARCHAR(20))        
                                          
AS        
BEGIN        
--        
        
  --  
  IF @pa_productname = 'CLASS'        
  BEGIN        
  --        
    SELECT profile_id        
         , profile_name       
         , excsm_exch_cd      
         ,excsm_seg_cd        
         , excpm.excpm_id as BROM_EXCPM_ID        
    INTO   #brok           
    FROM  v2_client_profile('','')  CP        
        , exch_seg_mstr             excsm        
        , excsm_prod_mstr           excpm        
    WHERE CASE WHEN cp.exchange = 'NCX' THEN 'NCDEX' ELSE cp.exchange END= excsm.excsm_exch_cd        
    AND cp.segment              = case when excsm.excsm_seg_cd = 'CASH' THEN 'CAPITAL' ELSE 'FUTURES' END      
    AND excsm.excsm_id          = excpm.excpm_excsm_id        
    AND excsm.excsm_deleted_ind = 1        
    AND excpm.excpm_deleted_ind = 1        
          
  
    BEGIN TRANSACTION        
    DELETE FROM brokerage_mstr WHERE brom_excpm_id IN(SELECT BROM_EXCPM_ID from #brok)        
          
    INSERT INTO brokerage_mstr(brom_id,brom_desc,brom_excpm_id,brom_created_by,brom_created_dt,brom_lst_upd_by,brom_lst_upd_dt,brom_deleted_ind)         
    SELECT profile_id        
          ,profile_name        
          ,brom_excpm_id         
          ,'CITRUS_USR'        
          ,getdate()        
          ,'CITRUS_USR'        
          ,getdate()        
          ,1        
    FROM   #brok       
    COMMIT TRANSACTION    
  --        
  END          
        
  --       
         
END

GO
