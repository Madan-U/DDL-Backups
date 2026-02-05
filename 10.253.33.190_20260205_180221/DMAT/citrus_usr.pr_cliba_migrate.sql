-- Object: PROCEDURE citrus_usr.pr_cliba_migrate
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[pr_cliba_migrate](@pa_id      VARCHAR(8000)  
                                ,@pa_from_dt VARCHAR(11)  
                                ,@pa_to_dt   VARCHAR(11)  
                                ,@pa_err  VARCHAR(250) OUTPUT)  
AS  
BEGIN  
--  
  DECLARE @c_cliba CURSOR  
  DECLARE @cliba_banm_id      NUMERIC   
         ,@cliba_clisba_id    NUMERIC   
         ,@cliba_compm_id     NUMERIC   
         ,@cliba_ac_no       VARCHAR(16)     
         ,@cliba_ac_type     VARCHAR(7)   
         ,@cliba_ac_name     VARCHAR(100)   
         ,@cliba_flg         CHAR(1)   
         ,@cliba_created_by   VARCHAR(25)   
         ,@cliba_created_dt   DATETIME  
         ,@cliba_lst_upd_by   VARCHAR(25)  
         ,@cliba_lst_upd_dt   DATETIME   
         ,@cliba_deleted_ind  VARCHAR(2)  
         ,@banm_name          VARCHAR(50)  
         ,@banm_branch        VARCHAR(40)  
         ,@clisba_acct_no     VARCHAR(25)   
         ,@modified           VARCHAR(2)  
         ,@t_errorstr         VARCHAR(250)  
         ,@l_error            NUMERIC           
    
                         
                              
   SET @c_cliba = CURSOR FAST_FORWARD FOR     
   SELECT cliba_banm_id  
         ,cliba_clisba_id  
         ,cliba_compm_id   
         ,cliba_ac_no  
         ,cliba_ac_type  
         ,cliba_ac_name  
         ,case when cliba_flg & 1 = 1 then 1 else 0 end    
         ,cliba_created_dt    
         ,cliba_lst_upd_by    
         ,cliba_lst_upd_dt    
         ,case when cliba_created_dt = cliba_lst_upd_dt then 'N' else 'M' end modified  
         ,banm_name  
         ,banm_branch  
         ,clisba_acct_no  
   FROM   client_bank_accts  
         ,bank_mstr   
         ,client_sub_accts  
   WHERE  cliba_deleted_ind = 1  
   AND    cliba_banm_id     = banm_id  
   AND    cliba_clisba_id   = clisba_id  
   AND    cliba_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
     
     
    
     
   OPEN @c_cliba  
     
   FETCH NEXT FROM  @c_cliba  
   INTO @cliba_banm_id     
       ,@cliba_clisba_id   
       ,@cliba_compm_id    
       ,@cliba_ac_no       
       ,@cliba_ac_type     
       ,@cliba_ac_name     
       ,@cliba_flg         
         
       ,@cliba_created_dt  
       ,@cliba_lst_upd_by  
       ,@cliba_lst_upd_dt  
       ,@modified  
       ,@banm_name  
       ,@banm_branch  
       ,@clisba_acct_no  
         
         
         
     
     
   WHILE @@FETCH_STATUS = 0  
   BEGIN  
   --  
       IF EXISTS(SELECT * FROM multibankid_hst WHERE    Accno = @cliba_ac_no and Chequename  = @cliba_ac_name and migrate_yn IN (1,3))
       BEGIN
       --
        SET @modified = 'M'  
       --
       END
       ELSE
       BEGIN
       --
         SET @modified = 'N'  
       --
       END
       IF NOT EXISTS(SELECT Accno,Chequename FROM multibankid WHERE Accno = @cliba_ac_no and Chequename  = @cliba_ac_name and migrate_yn = 0)  
       BEGIN  
       --     
         INSERT INTO multibankid(Accno             
                                ,Acctype           
                                ,Chequename        
                                ,Defaultbank  
                                ,banm_name  
                                ,banm_branch  
                                ,cltcd  
                                ,cliba_created_dt  
                                ,cliba_lst_upd_dt  
                                ,cliba_changed     
                                ,migrate_yn        
                                )  
                          values(@cliba_ac_no  
                                ,@cliba_ac_type  
                                ,@cliba_ac_name  
                                ,@cliba_flg  
                                ,@banm_name  
                                ,@banm_branch  
                                ,@clisba_acct_no  
                                ,@cliba_created_dt  
                                ,@cliba_lst_upd_dt  
                                ,@modified  
                                ,0)  
                                 
                                 
         SET @l_error   = @@ERROR      
         --      
         IF @l_error > 0      
         BEGIN --#1      
         --      
           SET @t_errorstr = @cliba_ac_no + ' ' + @cliba_ac_name +' could not be migrated'  
             
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
  
  
       FETCH NEXT FROM  @c_cliba  
       INTO @cliba_banm_id     
           ,@cliba_clisba_id   
           ,@cliba_compm_id    
           ,@cliba_ac_no       
           ,@cliba_ac_type     
           ,@cliba_ac_name     
           ,@cliba_flg         
            
           ,@cliba_created_dt  
           ,@cliba_lst_upd_by  
           ,@cliba_lst_upd_dt  
           ,@modified  
           ,@banm_name  
           ,@banm_branch  
           ,@clisba_acct_no  
       
       
       
   --  
   END  
     
   CLOSE       @c_cliba  
   DEALLOCATE  @c_cliba  
     
   SET @pa_err = @t_errorstr  
     
                          
--  
END

GO
