-- Object: PROCEDURE citrus_usr.pr_export_fasttrade
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*        
create property : DEFAULT_MARKETWATCH : Y=Yes; N=No        
create property : Owner_risk backoffice id : If owner does not exist then owner is set to backoffice id        
Backoffice id        
Owner backoffice id : If owner does not exist then owner is set to backoffice id        
Login id : typically same as backoffice id        
User type : 1- normal; 2-employee;3-admin        
Password        
First name        
Last name        
Email id        
Create default marketwatch : Y=Yes; N=No        
*/        
--pr_export_fasttrade '','',''        
create PROCEDURE [citrus_usr].[pr_export_fasttrade](@pa_from_dt  VARCHAR(20)        
                                    ,@pa_to_dt   VARCHAR(20)        
                                    ,@pa_err     VARCHAR(100) OUTPUT        
                                    )        
AS        
BEGIN        
--        
  IF @pa_from_dt = '' and @pa_to_dt = ''          
  BEGIN        
  --        
    
    select FT_EXPORT    
    from (    
    SELECT entm_short_name         
--           +','+ case when enttm_desc = 'HEAD OFFICE' then 'HEAD OFFICE' else isnull(citrus_usr.fn_ucc_entp(entm_id,'OWNRSK_FOR_FO',''),'') end         
           +','+  isnull((select entm_short_name  from entity_mstr entm_prt where entm_prt.entm_id = entm_chd.entm_parent_id),'HO') 
           +','+ entm_short_name         
           +','+ entm_short_name         
           +','+ entm_name1        
           +','+ isnull(entm_name3,'')        
           +','+ isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL1'),'')          
           +','+ CASE WHEN isnull(citrus_usr.fn_ucc_entp(entm_id,'DEF_MKTWATCH',''),'') = '1' THEN 'Y' ELSE 'N' END FT_EXPORT        
          ,enttm_rmks order_by     
    FROM   entity_mstr entm_chd        
          ,entity_type_mstr         
    WHERE  entm_enttm_cd     = enttm_cd         
    AND    entm_deleted_ind  = 1        
    AND    enttm_deleted_ind = 1        
    --AND   ((isnull(citrus_usr.fn_ucc_entp(entm_id,'OWNRSK_FOR_FO',''),'') <>  '') or  ENTTM_DESC = 'HEAD OFFICE')         
            
    UNION        
        
    SELECT clia_acct_no        
           +','+ citrus_usr.fn_find_relations_nm_desc(clim_crn_no,isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'OWNRSK_FOR_FO',''),''))        
           +','+ clia_acct_no        
           +','+ clia_acct_no         
           +','+ isnull(clim_name1,'')        
           +','+ isnull(clim_name3,'')        
           +','+ isnull(citrus_usr.fn_conc_value(clim_crn_no,'EMAIL1'),'')          
           +','+ CASE WHEN isnull(citrus_usr.fn_ucc_entp(CLIM_CRN_NO,'DEF_MKTWATCH',''),'') = '1' THEN 'Y' ELSE 'N' END FT_EXPORT        
          ,order_by = 1000    
    FROM   client_mstr        
         , client_accounts        
    WHERE  clia_crn_no = clim_crn_no          
    AND    isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'OWNRSK_FOR_FO',''),'') <> ''     
           
    ) a    
    order by order_by    
  --        
  END        
  ELSE        
  BEGIN        
  --    
    select FT_EXPORT    
    from (        
    SELECT entm_short_name         
--           +','+ case when enttm_desc = 'HEAD OFFICE' then 'HEAD OFFICE' else isnull(citrus_usr.fn_ucc_entp(entm_id,'OWNRSK_FOR_FO',''),'') end         
           +','+  isnull((select entm_short_name  from entity_mstr entm_prt where entm_prt.entm_id = entm_chd.entm_parent_id),'HO') 
           +','+ entm_short_name         
           +','+ entm_short_name         
           +','+ entm_name1        
           +','+ isnull(entm_name3,'')        
           +','+ isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL1'),'')          
           +','+ CASE WHEN isnull(citrus_usr.fn_ucc_entp(entm_id,'DEF_MKTWATCH',''),'') = '1' THEN 'Y' ELSE 'N' END FT_EXPORT        
          ,enttm_rmks order_by    
    FROM   entity_mstr   entm_chd     
          ,entity_type_mstr         
    WHERE  entm_enttm_cd     = enttm_cd         
    AND    entm_deleted_ind  = 1        
    AND    enttm_deleted_ind = 1        
    --AND   ((isnull(citrus_usr.fn_ucc_entp(entm_id,'OWNRSK_FOR_FO',''),'') <>  '') or  ENTTM_DESC = 'HEAD OFFICE')         
    AND    entm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'         
        
    UNION        
        
    SELECT clia_acct_no        
           +','+ citrus_usr.fn_find_relations_nm_desc(clim_crn_no,isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'OWNRSK_FOR_FO',''),''))        
           +','+ clia_acct_no        
           +','+ clia_acct_no         
           +','+ clim_name1        
           +','+ isnull(clim_name3,'')        
           +','+ isnull(citrus_usr.fn_conc_value(clim_crn_no,'EMAIL1'),'')          
           +','+ CASE WHEN isnull(citrus_usr.fn_ucc_entp(CLIM_CRN_NO,'DEF_MKTWATCH',''),'') = '1' THEN 'Y' ELSE 'N' END FT_EXPORT        
          ,order_by = 1000     
    FROM   client_mstr        
         , client_accounts        
    WHERE  clia_crn_no = clim_crn_no          
    AND    clim_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'         
    AND    isnull(citrus_usr.fn_ucc_entp(clim_crn_no,'OWNRSK_FOR_FO',''),'') <> ''        
       
    ) a    
   order by order_by    
        
  --        
  END        
--        
END

GO
