-- Object: PROCEDURE citrus_usr.pr_bank_migrate
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[pr_bank_migrate](@pa_id      VARCHAR(8000)    
                                ,@pa_from_dt VARCHAR(11)    
                                ,@pa_to_dt   VARCHAR(11)    
                                ,@pa_err  VARCHAR(250) OUTPUT)    
AS    
BEGIN    
--    
  DECLARE @c_bank CURSOR    
  DECLARE @bank_name         VARCHAR(50)       
         ,@branch_name       VARCHAR(40)     
         ,@l_adr_1           VARCHAR(50)     
         ,@l_adr_2           VARCHAR(50)     
         ,@l_adr_city        VARCHAR(50)     
         ,@l_adr_state       VARCHAR(50)     
         ,@l_adr_country      VARCHAR(50)     
         ,@l_adr_zip         VARCHAR(50)     
         ,@l_phone1          VARCHAR(50)     
         ,@l_phone2          VARCHAR(50)    
         ,@l_fax             VARCHAR(25)    
         ,@l_email           VARCHAR(50)    
         ,@banm_created_by   VARCHAR(25)     
         ,@banm_created_dt   DATETIME    
         ,@banm_lst_upd_by   VARCHAR(25)    
         ,@banm_lst_upd_dt   DATETIME     
             
         ,@banm_deleted_ind  VARCHAR(2)    
         ,@modified          VARCHAR(2)    
         ,@banm_id           NUMERIC     
         ,@l_adr_value       VARCHAR(1000)    
         ,@l_fax1            VARCHAR(25)     
         ,@t_errorstr        VARCHAR(250)    
         ,@l_error           NUMERIC             
      
                           
                                
   SET @c_bank = CURSOR FAST_FORWARD FOR       
   SELECT banm_id      
         ,banm_name        
         ,banm_branch    
         ,banm_created_by      
         ,banm_created_dt      
         ,banm_lst_upd_by      
         ,banm_lst_upd_dt      
         ,banm_deleted_ind     
         ,case when banm_created_dt = banm_lst_upd_dt then 'N' else 'M' end modified    
   FROM   bank_mstr    
   WHERE  banm_deleted_ind = 1    
   AND    banm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'     
   AND    convert(varchar,banm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_ID))   = '' THEN '%' ELSE @PA_ID +'%' END    
       
      
       
   OPEN @c_bank    
       
   FETCH NEXT FROM  @c_bank    
   INTO @banm_id    
       ,@bank_name       
       ,@branch_name     
       ,@banm_created_by     
       ,@banm_created_dt     
       ,@banm_lst_upd_by     
       ,@banm_lst_upd_dt     
       ,@banm_deleted_ind    
       ,@modified    
       
       
   WHILE @@FETCH_STATUS = 0    
   BEGIN    
   --    
         
            
     SELECT @l_adr_value = citrus_usr.fn_addr_value(@banm_id,'OFF_ADR1')      
                
     SELECT @l_adr_1        = citrus_usr.fn_splitval(@l_adr_value,1)    
           ,@l_adr_2        = citrus_usr.fn_splitval(@l_adr_value,2)    
           ,@l_adr_city     = citrus_usr.fn_splitval(@l_adr_value,4)    
           ,@l_adr_state    = citrus_usr.fn_splitval(@l_adr_value,5)    
           ,@l_adr_country  = citrus_usr.fn_splitval(@l_adr_value,6)    
           ,@l_adr_zip      = citrus_usr.fn_splitval(@l_adr_value,7)    
                       
     SELECT @l_phone1  = citrus_usr.fn_conc_value(@banm_id,'OFF_PH1')    
     SELECT @l_phone2  = citrus_usr.fn_conc_value(@banm_id,'OFF_PH2')    
     SELECT @l_fax1    = citrus_usr.fn_conc_value(@banm_id,'FAX1')    
     SELECT @l_email   = citrus_usr.fn_conc_value(@banm_id,'EMAIL1')    
         
     /*INSERT INTO bank_mstr_mig    
     (bank_name           
     ,branch_name         
     ,address1            
     ,address2            
     ,city                
     ,state               
     ,nation              
     ,zip                 
     ,phone1              
     ,phone2              
     ,fax                 
     ,email               
     ,banm_created_by     
     ,banm_created_dt     
     ,banm_lst_upd_by     
     ,banm_lst_upd_dt     
     ,banm_deleted_ind    
     )    
      VALUES(@bank_name    
            ,@branch_name     
            ,@l_adr_1         
            ,@l_adr_2         
            ,@l_adr_city      
     ,@l_adr_state     
            ,@l_adr_nation    
            ,@l_adr_zip       
            ,@l_phone1    
            ,@l_phone2    
            ,@l_fax1    
            ,@l_email    
            ,@banm_created_by     
            ,@banm_created_dt     
            ,@banm_lst_upd_by     
            ,@banm_lst_upd_dt     
            ,@banm_deleted_ind    
            )*/    
       if exists(select * from pobank_hst where bank_name = @bank_name and branch_name = @branch_name and migrate_yn in (1,3))          
       begin  
       --  
         set @modified = 'M'  
       --  
       end   
       ELSE   
       begin  
       --  
         set @modified = 'N'  
       --  
       end  
         
  
       IF NOT EXISTS(SELECT bank_name,branch_name FROM pobank WHERE bank_name = @bank_name AND branch_name = @branch_name and migrate_yn = 0)    
       BEGIN    
       --  
   
         INSERT INTO pobank(banm_id    
                           ,bank_name    
                           ,branch_name    
                           ,address1    
                           ,address2    
                           ,city    
                           ,state    
                           ,nation    
                           ,zip    
                           ,phone1    
                           ,phone2    
                           ,fax    
                           ,email    
                           ,pob_created_dt    
                           ,pob_lst_upd_dt    
                           ,pob_changed    
                           ,migrate_yn          
                          )    
                          values(@banm_id    
                               , @bank_name           
                               , @branch_name         
                               , left(@l_adr_1,50)            
                               , left(@l_adr_2,50)            
                               , left(@l_adr_city,25)                
                               , left(@l_adr_state,25)               
                               , left(@l_adr_country,25)              
                               , left(@l_adr_zip,15)                 
                               , left(@l_phone1,15)              
                               , left(@l_phone2,15)              
                               , left(@l_fax1,15)                 
                               , left(@l_email,50)    
                               , @banm_created_dt    
                               , @banm_lst_upd_dt    
                               , @modified    
                               , 0)    
                                   
                                   
         SET @l_error   = @@ERROR        
         --        
         IF @l_error > 0        
         BEGIN --#1        
         --        
           SET @t_errorstr = @bank_name+' could not be migrated'    
               
           BREAK    
         --        
         END  --#1               
         ELSE    
         BEGIN    
         --    
           SET @t_errorstr = ''    
         --    
         END    
                                   
       --    
       END            
    
    
       FETCH NEXT FROM  @c_bank    
       INTO @banm_id    
           ,@bank_name       
           ,@branch_name     
           ,@banm_created_by     
           ,@banm_created_dt     
           ,@banm_lst_upd_by     
           ,@banm_lst_upd_dt     
           ,@banm_deleted_ind    
           ,@modified    
         
   --    
   END    
       
   CLOSE       @c_bank    
   DEALLOCATE  @c_bank    
       
   SET @pa_err = @t_errorstr    
       
                            
--    
END    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON

GO
