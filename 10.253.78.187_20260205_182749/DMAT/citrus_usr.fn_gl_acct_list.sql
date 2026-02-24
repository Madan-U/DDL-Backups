-- Object: FUNCTION citrus_usr.fn_gl_acct_list
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_gl_acct_list](@pa_dpm_id int ,@pa_ent_id int,@pa_child_id int) returns @l_table  TABLE (dpam_id INT,dpam_crn_no numeric,dpam_sba_no varchar(100),dpam_sba_name varchar(200),eff_from datetime,eff_to datetime,acct_type char(2),child_id int,group_id int)         
as     
begin    
--    
declare @l_entem_col_name varchar(25)    
       ,@l_string         varchar(8000)     
         
       ,@l_col_name       VARCHAR(250)    
       ,@pa_child_name    varchar(250)    
       , @l_child_col_name varchar(25)    
declare  @br_colname  varchar(50)  
      ,  @log_colname varchar(50)   
      declare @l_baranches table(br_id numeric(10,0))  
      declare @l_baranches_child table(child_br_id numeric(10,0))  
  
     select @br_colname = entem_entr_col_name from enttm_entr_mapping where entem_enttm_cd = 'BR'   
declare @temp table (dpam_id INT,dpam_crn_no numeric,dpam_sba_no varchar(100),dpam_sba_name varchar(200),eff_from datetime,eff_to datetime,acct_type char(2),child_id int,group_id int)     

if @pa_ent_id   <> 0    
begin    
--    
  SELECT @l_entem_col_name = entem.entem_entr_col_name         
  FROM   login_names               logn        
       , enttm_entr_mapping        entem        
       , entity_type_mstr          enttm        
  WHERE  logn.logn_enttm_id      = enttm.enttm_id        
  AND    entem.entem_enttm_cd    = enttm.enttm_cd        
  AND    logn.logn_ent_id        = @pa_ent_id      
  AND    logn.logn_deleted_ind   = 1        
  AND    entem.entem_deleted_ind = 1        
  AND    enttm.enttm_deleted_ind = 1     
    
  if @pa_child_id <> 0    
  BEGIn    
    SELECT @l_child_col_name = entem.entem_entr_col_name         
    FROM   entity_mstr               entm    
         , enttm_entr_mapping        entem        
         , entity_type_mstr          enttm        
    WHERE  entm.entm_enttm_cd      = enttm.enttm_cd        
    AND    entem.entem_enttm_cd    = enttm.enttm_cd        
    AND    entm.entm_id            = @pa_child_id      
    AND    entm.entm_deleted_ind   = 1        
    AND    entem.entem_deleted_ind = 1        
    AND    enttm.enttm_deleted_ind = 1       
 END    
    
  IF @l_entem_col_name = 'ENTR_HO'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,'01/01/2900')
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id    
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_ho  = @pa_ent_id   
  and entr_deleted_ind = 1 
  and dpam_deleted_ind = 1 
  



  insert into @l_baranches(br_id)  
  select  distinct case when @br_colname = 'entr_ho' then entr_ho  
          when @br_colname = 'ENTR_RE' then entr_re  
          when @br_colname = 'ENTR_AR' then entr_ar  
          when @br_colname = 'ENTR_BR' then entr_br  
          when @br_colname = 'ENTR_SB' then entr_sb  
          when @br_colname = 'ENTR_DL' then entr_dl  
          when @br_colname = 'ENTR_RM' then entr_rm  
          when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
          when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
          when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
          when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
          when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
          when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
          when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
          when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
          when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
          when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_ho  =  @pa_ent_id  
		and entr_deleted_ind = 1 



 insert into @l_baranches_child(child_br_id)  
 select  distinct case when @br_colname = 'entr_ho' then entr_ho  
        when @br_colname = 'ENTR_RE' then entr_ho  
        when @br_colname = 'ENTR_AR' then entr_ho  
        when @br_colname = 'ENTR_BR' then entr_ho  
        when @br_colname = 'ENTR_SB' then entr_ho  
        when @br_colname = 'ENTR_DL' then entr_ho  
        when @br_colname = 'ENTR_RM' then entr_ho  
        when @br_colname = 'ENTR_DUMMY1' then entr_ho  
        when @br_colname = 'ENTR_DUMMY2' then entr_ho  
        when @br_colname = 'ENTR_DUMMY3' then entr_ho  
        when @br_colname = 'ENTR_DUMMY4' then entr_ho  
        when @br_colname = 'ENTR_DUMMY5' then entr_ho  
        when @br_colname = 'ENTR_DUMMY6' then entr_ho  
        when @br_colname = 'ENTR_DUMMY7' then entr_ho  
        when @br_colname = 'ENTR_DUMMY8' then entr_ho  
        when @br_colname = 'ENTR_DUMMY9' then entr_ho  
        when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
	where  entr_ho =  @pa_child_id  
	and entr_deleted_ind = 1 
  

  
  end    

  if @l_entem_col_name = 'ENTR_RE'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)     
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,'01/01/2900')    
     , 'P'    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = 'ENTR_HO' then  ENTR_HO    
                 when @l_child_col_name = 'ENTR_RE' then  ENTR_RE    
                 when @l_child_col_name = 'ENTR_AR' then  ENTR_AR                   when @l_child_col_name = 'ENTR_BR' then  ENTR_BR    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id   
  and dpam.dpam_dpm_id   = @pa_dpm_id    
  and prom.prom_cd  = '01'     
  and entr.ENTR_RE  = @pa_ent_id    
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1
  end 
  insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
			where  entr_re  =  @pa_ent_id     
			and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_re =  @pa_child_id       and entr_deleted_ind = 1

if @l_entem_col_name = 'ENTR_AR'    
		
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id  
  and dpam.dpam_dpm_id   = @pa_dpm_id     
  and prom.prom_cd  = '01'     
  and entr.ENTR_AR  = @pa_ent_id    
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1
  end  

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_ar  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_ar =  @pa_child_id    
		and entr_deleted_ind = 1


   if @l_entem_col_name = 'ENTR_BR'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and prom.prom_cd  = '01'     
  and entr.ENTR_BR  = @pa_ent_id 
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1   

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_br  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_br =  @pa_child_id  
		and entr_deleted_ind = 1

  end      if @l_entem_col_name = 'ENTR_SB'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)       
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.ENTR_SB  = @pa_ent_id  
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1  

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_sb  =  @pa_ent_id     
		and entr_deleted_ind = 1
	


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_sb =  @pa_child_id    
		and entr_deleted_ind = 1

  end  

    IF @l_entem_col_name = 'ENTR_DL'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)      
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')     
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id   
  and dpam.dpam_dpm_id   = @pa_dpm_id    
  and prom.prom_cd  = '01'     
  and entr.ENTR_DL  = @pa_ent_id  
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1  


insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dl  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dl =  @pa_child_id     
		and entr_deleted_ind = 1

  end  


  IF @l_entem_col_name = 'ENTR_RM'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)       
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id   
  and dpam.dpam_dpm_id   = @pa_dpm_id    
  and prom.prom_cd  = '01'     
  and entr.entr_rm  = @pa_ent_id    
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_rm  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_rm =  @pa_child_id  
		and entr_deleted_ind = 1

  end      IF @l_entem_col_name = 'ENTR_DUMMY1'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)      
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id    
  and dpam.dpam_dpm_id   = @pa_dpm_id   
  and prom.prom_cd  = '01'     
  and entr.entr_dummy1  = @pa_ent_id  
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1
  
insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy1  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy1 =  @pa_child_id  
		and entr_deleted_ind = 1

  end        IF @l_entem_col_name = 'ENTR_DUMMY2'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
 , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy2  = @pa_ent_id 
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1   

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy2  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy2 =  @pa_child_id 
		and entr_deleted_ind = 1


  end 


      IF @l_entem_col_name = 'ENTR_DUMMY3'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy3  = @pa_ent_id
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1  

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy3  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy3 =  @pa_child_id  
		and entr_deleted_ind = 1
  
  end      IF @l_entem_col_name = 'ENTR_DUMMY4'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
   , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy4  = @pa_ent_id 
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1   
  end  

 insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy4  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy4 =  @pa_child_id 
		and entr_deleted_ind = 1

       IF @l_entem_col_name = 'ENTR_DUMMY5'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)       
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy5  = @pa_ent_id   
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1 


insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy5  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy5 =  @pa_child_id 
		and entr_deleted_ind = 1
  end  

    
 IF @l_entem_col_name = 'ENTR_DUMMY6'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)     
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy6  = @pa_ent_id    
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy6  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  

              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy6 =  @pa_child_id  
		and entr_deleted_ind = 1

  end      IF @l_entem_col_name = 'ENTR_DUMMY7'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy7  = @pa_ent_id  
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1  

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy7  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy7 =  @pa_child_id 
		and entr_deleted_ind = 1


  end   

       IF @l_entem_col_name = 'ENTR_DUMMY8'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
   , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy8  = @pa_ent_id    
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1


insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy8  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy8 =  @pa_child_id     
		and entr_deleted_ind = 1

  end  

 
  IF @l_entem_col_name = 'ENTR_DUMMY9'    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
   , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy9  = @pa_ent_id   
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy9  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy9 =  @pa_child_id      
		and entr_deleted_ind = 1

  end      IF @l_entem_col_name = 'ENTR_DUMMY10'    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
       , entr.entr_from_dt     
       , isnull(entr.entr_to_dt,'01/01/2900')    
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
  FROM dp_acct_mstr dpam     
  , entity_relationship entr     
  , excsm_prod_mstr excpm     
  , product_mstr prom     
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and entr.entr_excpm_id = excpm.excpm_id      
  and dpam.dpam_excsm_id = excpm.excpm_excsm_id     
  and excpm.excpm_prom_id = prom.prom_id     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and prom.prom_cd  = '01'     
  and entr.entr_dummy10  = @pa_ent_id  
  and entr_deleted_ind = 1
  and dpam_deleted_ind = 1      

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_re  
              when @br_colname = 'ENTR_AR' then entr_ar  
              when @br_colname = 'ENTR_BR' then entr_br  
              when @br_colname = 'ENTR_SB' then entr_sb  
              when @br_colname = 'ENTR_DL' then entr_dl  
              when @br_colname = 'ENTR_RM' then entr_rm  
              when @br_colname = 'ENTR_DUMMY1' then ENTR_DUMMY1  
              when @br_colname = 'ENTR_DUMMY2' then ENTR_DUMMY2  
              when @br_colname = 'ENTR_DUMMY3' then ENTR_DUMMY3  
              when @br_colname = 'ENTR_DUMMY4' then ENTR_DUMMY4  
              when @br_colname = 'ENTR_DUMMY5' then ENTR_DUMMY5  
              when @br_colname = 'ENTR_DUMMY6' then ENTR_DUMMY6  
              when @br_colname = 'ENTR_DUMMY7' then ENTR_DUMMY7  
              when @br_colname = 'ENTR_DUMMY8' then ENTR_DUMMY8  
              when @br_colname = 'ENTR_DUMMY9' then ENTR_DUMMY9  
              when @br_colname = 'ENTR_DUMMY10' then ENTR_DUMMY10 end branch_id from entity_relationship  
		where  entr_dummy10  =  @pa_ent_id     
		and entr_deleted_ind = 1


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = 'entr_ho' then entr_ho  
              when @br_colname = 'ENTR_RE' then entr_ho  
              when @br_colname = 'ENTR_AR' then entr_ho  
              when @br_colname = 'ENTR_BR' then entr_ho  
              when @br_colname = 'ENTR_SB' then entr_ho  
              when @br_colname = 'ENTR_DL' then entr_ho  
              when @br_colname = 'ENTR_RM' then entr_ho  
              when @br_colname = 'ENTR_DUMMY1' then entr_ho  
              when @br_colname = 'ENTR_DUMMY2' then entr_ho  
              when @br_colname = 'ENTR_DUMMY3' then entr_ho  
              when @br_colname = 'ENTR_DUMMY4' then entr_ho  
              when @br_colname = 'ENTR_DUMMY5' then entr_ho  
              when @br_colname = 'ENTR_DUMMY6' then entr_ho  
              when @br_colname = 'ENTR_DUMMY7' then entr_ho  
              when @br_colname = 'ENTR_DUMMY8' then entr_ho  
              when @br_colname = 'ENTR_DUMMY9' then entr_ho  
              when @br_colname = 'ENTR_DUMMY10' then entr_ho end branch_id from entity_relationship  
		where  entr_dummy10 =  @pa_child_id     
		and entr_deleted_ind = 1
                      
  end    
    
    
    
       
     
    
 end   IF NOT EXISTS(select entm.entm_id,b.enttm_cd from entity_type_mstr a, entity_type_mstr b, entity_mstr entm  
where  a.enttm_cd= b.enttm_parent_cd   
and    a.enttm_cd = 'BR'  
and    entm.entm_enttm_cd = b.enttm_cd  
and    entm.entm_id = @pa_child_id)  
begin  
    if @pa_child_id = 0  
    BEGIN  
    --  
      select @log_colname = entem_entr_col_name from enttm_entr_mapping where entem_enttm_cd in (select entm_enttm_cd from entity_mstr where entm_id  = @pa_ent_id)   
    --  
    END  
    ELSE  
    BEGIN  
    --  
      select @log_colname = entem_entr_col_name from enttm_entr_mapping where entem_enttm_cd in (select entm_enttm_cd from entity_mstr where entm_id  = @pa_child_id)   
  
       delete from @l_baranches where br_id not in (select child_br_id from @l_baranches_child)  
  
    --  
    END  
    insert into @l_baranches select '0'
  IF @log_colname = 'ENTR_HO'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
    
  END   
IF @log_colname = 'ENTR_RE'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END   
 IF @log_colname = 'ENTR_AR'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END   
 IF @log_colname = 'ENTR_BR'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END   
  IF @log_colname = 'ENTR_SB'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id 
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END   
 IF @log_colname = 'ENTR_DL'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END   
 IF @log_colname = 'ENTR_RM'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)
	and fina_deleted_ind = 1  
  END  IF @log_colname = 'ENTR_DUMMY1'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END   
  IF @log_colname = 'ENTR_DUMMY2'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END  IF @log_colname = 'ENTR_DUMMY3'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END    
  IF @log_colname = 'ENTR_DUMMY4'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END    
 IF @log_colname = 'ENTR_DUMMY5'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END    
IF @log_colname = 'ENTR_DUMMY6'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END    
IF @log_colname = 'ENTR_DUMMY7'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END   IF @log_colname = 'ENTR_DUMMY8'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END    
IF @log_colname = 'ENTR_DUMMY9'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
	and fina_deleted_ind = 1
  END    
IF @log_colname = 'ENTR_DUMMY10'    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,'01/01/1900'  
          ,'01/01/2900'  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches) 
	and fina_deleted_ind = 1 
  END   
  
  
END  
  
 if @pa_ent_id <> 0 and  @pa_child_id <> 0     
 begin     
 --    
   insert into @l_table select * from @temp where child_id  = @pa_child_id    
 --    
 end    
 else     
 begin    
 --    
   insert into @l_table select * from @temp     
 --    
 end  return    
     
end

GO
