-- Object: PROCEDURE citrus_usr.pr_gl_acct_list
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from citrus_usr.fn_gl_acct_list(899,1,0) where  acct_type <> 'P'
CREATE procedure [citrus_usr].[pr_gl_acct_list]  
as  
begin  
--  
  declare @l_string varchar(8000)  
        , @l_string1 varchar(8000)  
        , @l_string2 varchar(8000)  
        , @l_string3 varchar(8000)  
        , @l_string4 varchar(8000)  
        , @l_string5 varchar(8000)  
        , @l_string6 varchar(8000)  
        , @l_string7 varchar(8000)  
        , @l_string8 varchar(8000)  
        , @l_string9 varchar(8000)  
        , @l_string10 varchar(8000)  
        , @l_string11 varchar(8000)  
        , @L_STRING_ADD1 varchar(8000)
 , @L_STRING_ADD2 varchar(8000)
 , @L_STRING_ADD3 varchar(8000)
 , @L_STRING_ADD4 varchar(8000)
 , @L_STRING_ADD5 varchar(8000)
 , @L_STRING_ADD6 varchar(8000)
 , @L_STRING_ADD7 varchar(8000)
 , @L_STRING_ADD8 varchar(8000)
 , @L_STRING_ADD9 varchar(8000)
 , @L_STRING_ADD10 varchar(8000)
 , @L_STRING_ADD11 varchar(8000)
 , @L_STRING_ADD12 varchar(8000)
 , @L_STRING_ADD13 varchar(8000)
 , @L_STRING_ADD14 varchar(8000)
 , @L_STRING_ADD15 varchar(8000)
  
--select * from citrus_usr.fn_acct_list(1,54591) where child_id = 54591    
  
if exists(select name from sysobjects where name = 'fn_gl_acct_list' )  
begin  
drop function fn_gl_acct_list  
end  
  
set @l_string = '   
CREATE Function fn_gl_acct_list(@pa_dpm_id int ,@pa_ent_id int,@pa_child_id int) returns @l_table  TABLE (dpam_id INT,dpam_crn_no numeric,dpam_sba_no varchar(20),dpam_sba_name varchar(100),eff_from datetime,eff_to datetime,acct_type VARchar(2),child_id int,group_id int)         
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
  
     select @br_colname = entem_entr_col_name from enttm_entr_mapping where entem_enttm_cd = ''BR''   
declare @temp table (dpam_id INT,dpam_crn_no numeric,dpam_sba_no varchar(20),dpam_sba_name varchar(100),eff_from datetime,eff_to datetime,acct_type VARchar(2),child_id int,group_id int)     

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
    
  IF @l_entem_col_name = ''ENTR_HO''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,''01/01/2900'')
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_ho  = @pa_ent_id    
  



  insert into @l_baranches(br_id)  
  select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
          when @br_colname = ''ENTR_RE'' then entr_re  
          when @br_colname = ''ENTR_AR'' then entr_ar  
          when @br_colname = ''ENTR_BR'' then entr_br  
          when @br_colname = ''ENTR_SB'' then entr_sb  
          when @br_colname = ''ENTR_DL'' then entr_dl  
          when @br_colname = ''ENTR_RM'' then entr_rm  
          when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
          when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
          when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
          when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
          when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
          when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
          when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
          when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
          when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
          when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_ho  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
 select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
        when @br_colname = ''ENTR_RE'' then entr_ho  
        when @br_colname = ''ENTR_AR'' then entr_ho  
        when @br_colname = ''ENTR_BR'' then entr_ho  
        when @br_colname = ''ENTR_SB'' then entr_ho  
        when @br_colname = ''ENTR_DL'' then entr_ho  
        when @br_colname = ''ENTR_RM'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
        when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_ho =  @pa_child_id     

  
  end    

'


        
 set @L_STRING_ADD1 = '  if @l_entem_col_name = ''ENTR_RE''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)     
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR                   when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.ENTR_RE  = @pa_ent_id    
  end 
  insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_re  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_re =  @pa_child_id      '
    
  SET @L_STRING_ADD2  = ' if @l_entem_col_name = ''ENTR_AR''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.ENTR_AR  = @pa_ent_id    
  end  

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_ar  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_ar =  @pa_child_id    


 '  
    
  
  set @l_string1 = '  if @l_entem_col_name = ''ENTR_BR''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.ENTR_BR  = @pa_ent_id    

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_br  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_br =  @pa_child_id  

  end    '
    
set @l_string_add7 = '  if @l_entem_col_name = ''ENTR_SB''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)       
     , entr.entr_from_dt     
     , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.ENTR_SB  = @pa_ent_id    

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_sb  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_sb =  @pa_child_id    

  end  

   '
    
  set  @l_string_add3 = ' IF @l_entem_col_name = ''ENTR_DL''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)      
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')     
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.ENTR_DL  = @pa_ent_id    


insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dl  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dl =  @pa_child_id     

  end  


'  
    
  
 set @l_string2 = '  IF @l_entem_col_name = ''ENTR_RM''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)       
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_rm  = @pa_ent_id    

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_rm  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_rm =  @pa_child_id  

  end    '
    
set @l_string_add8 = '  IF @l_entem_col_name = ''ENTR_DUMMY1''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)      
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy1  = @pa_ent_id    
insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy1  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy1 =  @pa_child_id  
  end       '
    
  set @l_string_add4  = ' IF @l_entem_col_name = ''ENTR_DUMMY2''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
 , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy2  = @pa_ent_id    
insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy2  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy2 =  @pa_child_id 


  end 


     '  
   
    
  set @l_string3 = ' IF @l_entem_col_name = ''ENTR_DUMMY3''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy3  = @pa_ent_id  

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy3  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy3 =  @pa_child_id  
  
  end    '
    
set @l_string_add11 = '  IF @l_entem_col_name = ''ENTR_DUMMY4''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
   , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy4  = @pa_ent_id    
  end  

 insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy4  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy4 =  @pa_child_id 

     '
    
set @l_string_add5 =  '  IF @l_entem_col_name = ''ENTR_DUMMY5''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)       
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy5  = @pa_ent_id    


insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy5  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy5 =  @pa_child_id 
  end  

    
'  
    
set @l_string4 = ' IF @l_entem_col_name = ''ENTR_DUMMY6''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)     
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy6  = @pa_ent_id    

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy6  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  

              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy6 =  @pa_child_id  
  end    '
      
set @l_string_add9 = '  IF @l_entem_col_name = ''ENTR_DUMMY7''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
    , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy7  = @pa_ent_id    

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy7  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy7 =  @pa_child_id 


  end   

     '
    
set @l_string_add6 = '  IF @l_entem_col_name = ''ENTR_DUMMY8''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
   , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
, case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy8  = @pa_ent_id    


insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy8  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy8 =  @pa_child_id     

  end  

 
 '  
    
  set @l_string5= ' IF @l_entem_col_name = ''ENTR_DUMMY9''    
  begin    
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
     , entr.entr_from_dt     
   , isnull(entr.entr_to_dt,''01/01/2900'')    
     , ''P''    
     , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy9  = @pa_ent_id   

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy9  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy9 =  @pa_child_id      
  end    '
    
set @l_string_add10 = '  IF @l_entem_col_name = ''ENTR_DUMMY10''    
  begin    
 insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id )    
 SELECT dpam.dpam_id,dpam_crn_no ,dpam_sba_no,isnull(dpam_sba_name,dpam_sba_no)    
       , entr.entr_from_dt     
       , isnull(entr.entr_to_dt,''01/01/2900'')    
       , ''P''    
       , case when @pa_child_id  = 0 then 0     
       else case when @l_child_col_name = ''ENTR_HO'' then  ENTR_HO    
                 when @l_child_col_name = ''ENTR_RE'' then  ENTR_RE    
                 when @l_child_col_name = ''ENTR_AR'' then  ENTR_AR    
                 when @l_child_col_name = ''ENTR_BR'' then  ENTR_BR    
                 when @l_child_col_name = ''ENTR_SB'' then  ENTR_SB    
                 when @l_child_col_name = ''ENTR_DL'' then  ENTR_DL    
                 when @l_child_col_name = ''ENTR_RM'' then  ENTR_RM    
                 when @l_child_col_name = ''ENTR_DUMMY1'' then  ENTR_DUMMY1    
                 when @l_child_col_name = ''ENTR_DUMMY2'' then  ENTR_DUMMY2    
                 when @l_child_col_name = ''ENTR_DUMMY3'' then  ENTR_DUMMY3    
                 when @l_child_col_name = ''ENTR_DUMMY4'' then  ENTR_DUMMY4    
                 when @l_child_col_name = ''ENTR_DUMMY5'' then  ENTR_DUMMY5    
                 when @l_child_col_name = ''ENTR_DUMMY6'' then  ENTR_DUMMY6    
                 when @l_child_col_name = ''ENTR_DUMMY7'' then  ENTR_DUMMY7    
                 when @l_child_col_name = ''ENTR_DUMMY8'' then  ENTR_DUMMY8    
                 when @l_child_col_name = ''ENTR_DUMMY9'' then  ENTR_DUMMY9    
                 when @l_child_col_name = ''ENTR_DUMMY10'' then ENTR_DUMMY10     
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
  and prom.prom_cd  = ''01''     
  and entr.entr_dummy10  = @pa_ent_id        

insert into @l_baranches(br_id)  
      select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_re  
              when @br_colname = ''ENTR_AR'' then entr_ar  
              when @br_colname = ''ENTR_BR'' then entr_br  
              when @br_colname = ''ENTR_SB'' then entr_sb  
              when @br_colname = ''ENTR_DL'' then entr_dl  
              when @br_colname = ''ENTR_RM'' then entr_rm  
              when @br_colname = ''ENTR_DUMMY1'' then ENTR_DUMMY1  
              when @br_colname = ''ENTR_DUMMY2'' then ENTR_DUMMY2  
              when @br_colname = ''ENTR_DUMMY3'' then ENTR_DUMMY3  
              when @br_colname = ''ENTR_DUMMY4'' then ENTR_DUMMY4  
              when @br_colname = ''ENTR_DUMMY5'' then ENTR_DUMMY5  
              when @br_colname = ''ENTR_DUMMY6'' then ENTR_DUMMY6  
              when @br_colname = ''ENTR_DUMMY7'' then ENTR_DUMMY7  
              when @br_colname = ''ENTR_DUMMY8'' then ENTR_DUMMY8  
              when @br_colname = ''ENTR_DUMMY9'' then ENTR_DUMMY9  
              when @br_colname = ''ENTR_DUMMY10'' then ENTR_DUMMY10 end branch_id from entity_relationship  where  entr_dummy10  =  @pa_ent_id     


 insert into @l_baranches_child(child_br_id)  
       select  distinct case when @br_colname = ''entr_ho'' then entr_ho  
              when @br_colname = ''ENTR_RE'' then entr_ho  
              when @br_colname = ''ENTR_AR'' then entr_ho  
              when @br_colname = ''ENTR_BR'' then entr_ho  
              when @br_colname = ''ENTR_SB'' then entr_ho  
              when @br_colname = ''ENTR_DL'' then entr_ho  
              when @br_colname = ''ENTR_RM'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY1'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY2'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY3'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY4'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY5'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY6'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY7'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY8'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY9'' then entr_ho  
              when @br_colname = ''ENTR_DUMMY10'' then entr_ho end branch_id from entity_relationship  where  entr_dummy10 =  @pa_child_id     
                      
  end    
    
    
    
       
     
    
 end  '  
  
   
 set @l_string6 = ' IF NOT EXISTS(select entm.entm_id,b.enttm_cd from entity_type_mstr a, entity_type_mstr b, entity_mstr entm  
where  a.enttm_cd= b.enttm_parent_cd   
and    a.enttm_cd = ''BR''  
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
    
  IF @log_colname = ''ENTR_HO''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
    
  END   
IF @log_colname = ''ENTR_RE''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END   
 IF @log_colname = ''ENTR_AR''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END '  
  
 set @l_string7 = '  
 IF @log_colname = ''ENTR_BR''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END   
  IF @log_colname = ''ENTR_SB''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id 
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END   
 IF @log_colname = ''ENTR_DL''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END   
 IF @log_colname = ''ENTR_RM''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END '  
  
 set @l_string8 = ' IF @log_colname = ''ENTR_DUMMY1''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END   
  IF @log_colname = ''ENTR_DUMMY2''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END  IF @log_colname = ''ENTR_DUMMY3''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END    
  IF @log_colname = ''ENTR_DUMMY4''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END '  
 set @l_string9 = '   
 IF @log_colname = ''ENTR_DUMMY5''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END    
IF @log_colname = ''ENTR_DUMMY6''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END    
IF @log_colname = ''ENTR_DUMMY7''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END  '  
  
 set @l_string10 = ' IF @log_colname = ''ENTR_DUMMY8''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END    
IF @log_colname = ''ENTR_DUMMY9''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END    
IF @log_colname = ''ENTR_DUMMY10''    
  begin    
    insert into @temp(dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,group_id)    
    select fina_Acc_id  
          ,fina_Acc_code  
          ,fina_Acc_name  
          ,''01/01/1900''  
          ,''01/01/2900''  
          ,fina_acc_type  
          , 0  
          ,fina_group_id
    FROM  fin_account_mstr  
    WHERE isnull(fina_dpm_id,@pa_dpm_id) = @pa_dpm_id
    AND   fina_branch_id in (select br_id from @l_baranches)  
  END   
  
  
END  
  
'   
  
 set @l_string11 = ' if @pa_ent_id <> 0 and  @pa_child_id <> 0     
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
     
end  '  
  
  
  
  
--print @l_string+'111111111111111'  
--print @l_string1+'222222222222'  
--print @l_string2+'3333333333333333'  
--print @l_string3+'444444444444444444'  
--print @l_string4+'44444444444444'  
--print @l_string5+'66666666666666'  
   
print @l_string  
print @l_string_add1  
print @l_string_add2  
print @l_string1  
print @l_string_add7  
print @l_string_add3  
print @l_string2  
print @l_string_add8  
print @l_string_add4  
print @l_string3  
print @l_string_add11  
print @l_string_add5  
print @l_string4  
print @l_string_add9
print @l_string_add6  
print @l_string5  
print @l_string_add10
print @l_string6  
print @l_string7  
print @l_string8  
print @l_string9  
print @l_string10  
print @l_string11  


exec (
 @l_string  
+ @l_string_add1  
+ @l_string_add2  
+ @l_string1  
+ @l_string_add7  
+ @l_string_add3  
+ @l_string2  
+ @l_string_add8  
+ @l_string_add4  
+ @l_string3  
+ @l_string_add11  
+ @l_string_add5  
+ @l_string4  
+ @l_string_add9
+ @l_string_add6  
+ @l_string5  
+ @l_string_add10
+ @l_string6  
+ @l_string7  
+ @l_string8  
+ @l_string9  
+ @l_string10  
+ @l_string11  
)
  
--exec (@l_string+@l_string1+@l_string2+@l_string3+@l_string4+@l_string5+@l_string6+@l_string7+@l_string8+@l_string9+@l_string10+@l_string11)  
  
end

GO
