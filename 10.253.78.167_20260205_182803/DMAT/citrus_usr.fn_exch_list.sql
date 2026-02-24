-- Object: FUNCTION citrus_usr.fn_exch_list
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from citrus_usr.fn_exch_list('5|*~|',33)  
  
CREATE function [citrus_usr].[fn_exch_list](@pa_rol_ids varchar(8000),@pa_scr_id varchar(50))  
RETURNS @l_table  TABLE (excsm_id INT)                     
AS  
BEGIN  
--  
  declare @temp table (rol_id numeric)  
    
  declare @l_id numeric  
        , @l_role varchar(25)        
        , @l_role_id numeric  
        , @l_count  numeric  
  select @l_count = citrus_usr.ufn_countstring(@pa_rol_ids,'*|~*')  
  set @l_id = 1  
    
  WHILE  @l_count  >= @l_id  
  BEGIN  
  --  
    set @l_role = citrus_usr.fn_splitval_row(@pa_rol_ids,@l_id)   
    --select @l_role_id = rol_id from roles where rol_cd = ltrim(rtrim(@l_role))  and rol_deleted_ind = 1   
      
    insert into  @temp  
    select  @l_role   
  
    set @l_id = @l_id + 1   
  --  
  END  
    
  insert into  @l_table  
  SELECT DISTINCT  excsm.excsm_id          excsm_id  
  FROM   exch_seg_mstr                    excsm  
     ,   actions                          act  
     ,   roles_actions                    rola  
     ,   screens                          scr  
     ,   roles                            rol  
     ,   company_mstr                     compm  
     ,   bitmap_ref_mstr bitrm  
  WHERE  act.act_id                     = rola.rola_act_id  
  AND    scr.scr_id                     = act.act_scr_id  
  AND    rol.rol_id                     = rola.rola_rol_id  
  AND    rol.rol_id                     in (select rol_id from @temp)  
  AND    compm.compm_id                 = excsm.excsm_compm_id  
  AND    scr.scr_id                     = @pa_scr_id  
  and    excsm_desc                     = bitrm.bitrm_child_cd  
  AND    bitrm.bitrm_parent_cd     IN ('ACCESS1', 'ACCESS2')  
  AND    bitrm.bitrm_deleted_ind = 1  
  AND    excsm.excsm_deleted_ind = 1    
  AND    power(2,bitrm_bit_location-1) & convert(varchar,rola_access1) <> 0-- power(2,bitrm_bit_location-1)   
  AND    rol.rol_deleted_ind            = 1  
  AND    scr.scr_deleted_ind            = 1  
  AND    act.act_deleted_ind            = 1  
  AND    rola.rola_deleted_ind          = 1  
   
  
  return   
  
  
--  
END

GO
