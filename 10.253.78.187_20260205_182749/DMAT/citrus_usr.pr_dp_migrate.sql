-- Object: PROCEDURE citrus_usr.pr_dp_migrate
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[pr_dp_migrate](@pa_id         varchar(8000)  
                              ,@pa_from_dt    varchar(11)   
                              ,@pa_to_dt      varchar(11)  
                              ,@pa_err        VARCHAR(250) OUTPUT)  
AS  
BEGIN  
--  
  DECLARE @c_dp CURSOR  
  DECLARE @dpm_id           NUMERIC    
         ,@dpm_dpid         VARCHAR(50)  
         ,@dpm_name         VARCHAR(50)  
         ,@dpm_rmks         VARCHAR(1000)  
         ,@dpm_type         VARCHAR(5)  
         ,@dpm_created_by   VARCHAR(25)   
         ,@dpm_created_dt   DATETIME  
         ,@dpm_lst_upd_by   VARCHAR(25)  
         ,@dpm_lst_upd_dt   DATETIME   
         ,@dpm_deleted_ind  VARCHAR(2)  
         ,@modified         VARCHAR(2)  
         ,@l_adr_1          VARCHAR(50)   
         ,@l_adr_2          VARCHAR(50)   
         ,@l_adr_city       VARCHAR(50)   
         ,@l_adr_zip        VARCHAR(50)   
         ,@l_adr_state      VARCHAR(50)   
         ,@l_adr_country    VARCHAR(50)   
         ,@l_phone1         VARCHAR(50)   
         ,@l_phone2         VARCHAR(50)  
         ,@l_phone3         VARCHAR(50)   
         ,@l_phone4         VARCHAR(50)  
         ,@l_fax1           VARCHAR(25)  
         ,@l_fax2           VARCHAR(25)  
         ,@l_email          VARCHAR(50)  
         ,@l_adr_value      VARCHAR(1000)     
           
         ,@t_errorstr        VARCHAR(250)  
         ,@l_error           NUMERIC           
    
                          
                              
   SET @c_dp = CURSOR FAST_FORWARD FOR     
   SELECT dpm_id   
         ,dpm_dpid        
         ,dpm_name      
         ,dpm_rmks  
         --,dpm_type  
         ,dpm_created_by    
         ,dpm_created_dt    
         ,dpm_lst_upd_by    
         ,dpm_lst_upd_dt    
         ,dpm_deleted_ind   
         ,case when dpm_created_dt = dpm_lst_upd_dt then 'N' else 'M' end modified  
   FROM   dp_mstr  
   WHERE  dpm_deleted_ind = 1  
   AND    dpm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
   AND    CONVERT(VARCHAR,dpm_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_ID))   = '' THEN '%' ELSE @PA_ID +'%' END  
     
     
   OPEN @c_dp  
     
   FETCH NEXT FROM  @c_dp  
   INTO  @dpm_id   
        ,@dpm_dpid        
        ,@dpm_name      
        ,@dpm_rmks  
        --,@dpm_type  
        ,@dpm_created_by    
        ,@dpm_created_dt    
        ,@dpm_lst_upd_by    
        ,@dpm_lst_upd_dt    
        ,@dpm_deleted_ind   
        ,@modified  
     
   WHILE @@FETCH_STATUS = 0  
   BEGIN  
   --  
       
     SELECT @l_adr_value = citrus_usr.fn_addr_value(@dpm_id,'OFF_ADR1')    
              
     SELECT @l_adr_1        = citrus_usr.fn_splitval(@l_adr_value,1)  
           ,@l_adr_2        = citrus_usr.fn_splitval(@l_adr_value,2)  
           ,@l_adr_city     = citrus_usr.fn_splitval(@l_adr_value,4)  
           ,@l_adr_state    = citrus_usr.fn_splitval(@l_adr_value,5)  
           ,@l_adr_country  = citrus_usr.fn_splitval(@l_adr_value,6)  
           ,@l_adr_zip      = citrus_usr.fn_splitval(@l_adr_value,7)  
       
       
     SELECT @l_phone1  = citrus_usr.fn_conc_value(@dpm_id,'OFF_PH1')  
     SELECT @l_phone2  = citrus_usr.fn_conc_value(@dpm_id,'OFF_PH2')  
     SELECT @l_phone3  = citrus_usr.fn_conc_value(@dpm_id,'OFF_PH3')  
     SELECT @l_phone4  = citrus_usr.fn_conc_value(@dpm_id,'OFF_PH4')  
       
     SELECT @l_fax1    = citrus_usr.fn_conc_value(@dpm_id,'FAX1')  
     SELECT @l_fax2    = citrus_usr.fn_conc_value(@dpm_id,'FAX2')  
     SELECT @l_email   = citrus_usr.fn_conc_value(@dpm_id,'EMAIL1')      
       
     /*INSERT INTO dp_mstr_mig(dpm_dpid          
     ,dpm_name          
     ,dpm_rmks          
     ,adr_1             
     ,adr_2             
     ,adr_city          
     ,adr_zip           
     ,phone1            
     ,phone2            
     ,phone3            
     ,phone4            
     ,fax1              
     ,fax2              
     ,email             
     ,dpm_type          
     ,dpm_created_by    
     ,dpm_created_dt    
     ,dpm_lst_upd_by    
     ,dpm_lst_upd_dt    
     ,dpm_deleted_ind   
     )  
      VALUES(@dpm_dpid        
            ,@dpm_name      
            ,@dpm_rmks  
            ,@l_adr_1      
            ,@l_adr_2                  
            ,@l_adr_city  
            ,@l_adr_zip   
            ,@l_phone1  
            ,@l_phone2  
            ,@l_phone3  
            ,@l_phone4  
            ,@l_fax1  
            ,@l_fax2  
            ,@l_email  
            ,@dpm_type  
            ,@dpm_created_by   
            ,@dpm_created_dt   
            ,@dpm_lst_upd_by   
            ,@dpm_lst_upd_dt   
            ,@dpm_deleted_ind  
            )*/  
      if exists(select * from bank where bankid = @dpm_dpid and migrate_yn in (1,3))
      begin
      --
        set @modified ='M'
      --
      end
      else
      begin
      --
        set @modified ='N'
      --
      end       
      IF NOT EXISTS(SELECT bankid FROM bank WHERE bankid = @dpm_dpid and migrate_yn=0)  
      BEGIN  
      --  
      INSERT INTO bank(dpm_id  
                      ,bankid  
                      ,bankname  
                      ,address1  
                      ,address2  
                      ,city  
                      ,pincode  
                      ,phone1  
                      ,phone2  
                      ,phone3  
                      ,phone4  
                      ,fax1  
                      ,fax2  
                      ,email  
                      --,banktype  
                      ,dpm_created_dt  
                      ,dpm_lst_upd_dt  
                      ,dpm_changed  
                      ,migrate_yn        
                      )  
                      VALUES(@dpm_id  
                            ,@dpm_dpid          
                            ,@dpm_name          
                            ,@l_adr_1             
                            ,@l_adr_2             
                            ,@l_adr_city          
                            ,@l_adr_zip           
                            ,@l_phone1            
                            ,@l_phone2            
                            ,@l_phone3            
                            ,@l_phone4            
                            ,@l_fax1              
                            ,@l_fax2              
                            ,@l_email             
                            --,@dpm_type  
                            ,@dpm_created_dt  
                            ,@dpm_lst_upd_dt  
                            ,@modified  
                            ,0)  
                              
         SET @l_error   = @@ERROR      
         --      
         IF @l_error > 0      
         BEGIN --#1      
         --      
           SET @t_errorstr = @dpm_name+' could not be migrated'  
  
           BREAK  
         --      
         END  --#1             
         ELSE  
         BEGIN  
         --  
           SET @t_errorstr = ''  
         --  
         END  
                              
                                      
       END             
  
       FETCH NEXT FROM  @c_dp  
       INTO  @dpm_id   
            ,@dpm_dpid        
            ,@dpm_name      
            ,@dpm_rmks  
            --,@dpm_type  
            ,@dpm_created_by    
            ,@dpm_created_dt    
            ,@dpm_lst_upd_by    
            ,@dpm_lst_upd_dt    
            ,@dpm_deleted_ind   
            ,@modified  
   --  
   END  
     
   CLOSE       @c_dp  
   DEALLOCATE  @c_dp  
       
       
       
   SET @pa_err = @t_errorstr    
     
--  
END

GO
