-- Object: FUNCTION citrus_usr.fn_acct_list_bytushar_bybbo_Bak_06052021
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  Function [citrus_usr].[fn_acct_list_bytushar_bybbo_Bak_06052021](@pa_dpm_id int ,@pa_ent_id int,@pa_child_id int  
,@PA_FROMACCID varchar(16),@PA_TOACCID varchar(16),@pa_bbo varchar(100))       
returns @temp  TABLE (dpam_id INT,dpam_crn_no NUMERiC,dpam_sba_no varchar(16)      
     ,dpam_sba_name varchar(500),eff_from datetime,eff_to datetime,acct_type char(1)      
     ,child_id int,dpam_stam_cd varchar(20))             
as         
begin        
--        
      
     
declare @l_entem_col_name varchar(25)        
       ,@l_string         varchar(8000),@l_col_name       VARCHAR(250),@pa_child_name    varchar(250), @l_child_col_name varchar(25)        
        
--declare @temp table (dpam_id INT,dpam_crn_no NUMERIC,dpam_sba_no varchar(16),dpam_sba_name varchar(100),eff_from datetime,eff_to datetime,acct_type char(1),child_id int)         
if @pa_ent_id   <> 0        
begin        
  SELECT @l_entem_col_name = entem.entem_entr_col_name             
  FROM   login_names               logn            
       , enttm_entr_mapping        entem            
       , entity_type_mstr          enttm            
  WHERE  logn.logn_enttm_id      = enttm.enttm_id      AND    entem.entem_enttm_cd    = enttm.enttm_cd            
  AND    logn.logn_ent_id        = @pa_ent_id      AND    logn.logn_deleted_ind   = 1        AND    entem.entem_deleted_ind = 1            
  AND    enttm.enttm_deleted_ind = 1           
  if @pa_child_id <> 0        
  BEGIn        
    SELECT @l_child_col_name = entem.entem_entr_col_name             
    FROM   entity_mstr               entm        
         , enttm_entr_mapping        entem            
         , entity_type_mstr          enttm            
    WHERE  entm.entm_enttm_cd      = enttm.enttm_cd          AND    entem.entem_enttm_cd    = enttm.enttm_cd            
    AND    entm.entm_id            = @pa_child_id        AND    entm.entm_deleted_ind   = 1            
    AND    entem.entem_deleted_ind = 1          AND    enttm.enttm_deleted_ind = 1           
  END        
         
     insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,dpam_stam_cd )        
  SELECT distinct dpam.dpam_id ,dpam_crn_no,dpam_sba_no,isnull(dpam_sba_name ,dpam_sba_no)       
     , entr.entr_from_dt         
     , isnull(entr.entr_to_dt ,'01/01/2900')      
       , 'P'        
       , case when @pa_child_id  = 0 then 0         
       else case when @l_child_col_name = 'ENTR_HO' then  ENTR_HO        
             when @l_child_col_name = 'ENTR_RE' then  ENTR_RE        
                 when @l_child_col_name = 'ENTR_AR' then  ENTR_AR        
                 when @l_child_col_name = 'ENTR_BR' then  ENTR_BR        
                 when @l_child_col_name = 'ENTR_SB' then  ENTR_SB        
                 when @l_child_col_name = 'ENTR_DL' then  ENTR_DL        
                 when @l_child_col_name = 'ENTR_RM' then  ENTR_RM        
                 when @l_child_col_name = 'ENTR_DUMMY1' then  ENTR_DUMMY1        
                 when @l_child_col_name = 'ENTR_DUMMY2' then  ENTR_DUMMY2        
                 when @l_child_col_name = 'ENTR_DUMMY3' then  ENTR_DUMMY3        
                 when @l_child_col_name = 'ENTR_DUMMY4' then  ENTR_DUMMY4        
                 when @l_child_col_name = 'ENTR_DUMMY5' then  ENTR_DUMMY5        
                 when @l_child_col_name = 'ENTR_DUMMY6' then  ENTR_DUMMY6        
                 when @l_child_col_name = 'ENTR_DUMMY7' then  ENTR_DUMMY7        
                 when @l_child_col_name = 'ENTR_DUMMY8' then  ENTR_DUMMY8        
                 when @l_child_col_name = 'ENTR_DUMMY9' then  ENTR_DUMMY9        
                 when @l_child_col_name = 'ENTR_DUMMY10' then ENTR_DUMMY10         
            end        
       end          
,dpam_stam_cd      
  FROM dp_acct_mstr dpam         
  , entity_relationship entr         
  , excsm_prod_mstr excpm         
  , product_mstr prom  ,account_properties       
  WHERE  entr.entr_sba =  dpam.dpam_sba_no         
  and entr.entr_excpm_id = excpm.excpm_id  and accp_clisba_id = dpam_id   
  and accp_accpm_prop_cd ='bbo_code'   and accp_value = @pa_bbo       
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id         
  and excpm.excpm_prom_id = prom.prom_id         
  and prom.prom_cd  = '01'    and entr.ENTR_DELETED_IND = '1'     
  and (entr.entr_HO  = @pa_ent_id     
  or ENTR_RE  = @pa_ent_id      
  or ENTR_AR  = @pa_ent_id      
  or ENTR_BR  = @pa_ent_id      
  or ENTR_SB  = @pa_ent_id      
  or ENTR_DL  = @pa_ent_id      
  or ENTR_RM  = @pa_ent_id      
  or ENTR_DUMMY1  = @pa_ent_id      
  or ENTR_DUMMY2  = @pa_ent_id      
  or ENTR_DUMMY3  = @pa_ent_id      
  or ENTR_DUMMY4   = @pa_ent_id      
  or ENTR_DUMMY5  = @pa_ent_id      
  or ENTR_DUMMY6  = @pa_ent_id      
  or ENTR_DUMMY7  = @pa_ent_id      
  or ENTR_DUMMY8  = @pa_ent_id      
  or ENTR_DUMMY9  = @pa_ent_id      
  or ENTR_DUMMY10  = @pa_ent_id  )    
 and (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))       
    
end    
    
  
if @pa_ent_id <> 0 and  @pa_child_id <> 0       
 begin       
 --      
   --insert into @l_table select * from @temp where child_id  = @pa_child_id      
  delete from  @temp where isnull(child_id,'0')  <> @pa_child_id      
    
 --      
 end      
  
 return        
         
     
    
end

GO
