-- Object: FUNCTION citrus_usr.fn_get_rola_access
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[fn_get_rola_access](@PA_ROL_STRING VARCHAR(8000))  
RETURNS NUMERIC  
AS  
BEGIN  
  
  
     
DECLARE @L_COUNT NUMERIC  
, @L_COUNTER NUMERIC  
, @@l_excsm_id NUMERIC  
, @@c_access_cursor CURSOR  
, @@c_bitrm_bit_location INT  
,@@l_rola_access1 INT  
SET @L_COUNTER = 2  
  SET @@c_bitrm_bit_location =0  
  SET @@l_rola_access1 = 0  
SET @L_COUNT = CITRUS_USR.ufn_countstring(@PA_ROL_STRING,'|*~|')  
     
WHILE @L_COUNTER <= @L_COUNT  
BEGIN     
SET  @@l_excsm_id     =  citrus_usr.fn_splitval(@PA_ROL_STRING,@L_COUNTER)    
      
      
SELECT   @@c_bitrm_bit_location=  bitrm_bit_location    
   FROM   bitmap_ref_mstr bitrm    
         ,exch_seg_mstr excsm    
   WHERE  excsm.excsm_desc        = bitrm.bitrm_child_cd    
   AND    bitrm.bitrm_parent_cd     IN ('ACCESS1', 'ACCESS2')    
   AND    bitrm.bitrm_deleted_ind = 1    
   AND    excsm.excsm_deleted_ind = 1   
   AND    EXCSM.EXCSM_ID =     @@l_excsm_id  
  
  
      
SET @@l_rola_access1 = power(2, @@c_bitrm_bit_location -1) | @@l_rola_access1      
   
  
SET @L_COUNTER = @L_COUNTER + 1  
END      
  
RETURN ISNULL(@@l_rola_access1 ,0)  
  
END

GO
