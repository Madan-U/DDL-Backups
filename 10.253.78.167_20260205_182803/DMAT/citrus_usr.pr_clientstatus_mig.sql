-- Object: PROCEDURE citrus_usr.pr_clientstatus_mig
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[pr_clientstatus_mig](@pa_id         varchar(8000)  
                                    ,@pa_from_dt    varchar(11)   
                                    ,@pa_to_dt      varchar(11)   
                                    ,@pa_err        VARCHAR(250) OUTPUT)  
AS  
BEGIN  
--  
  DECLARE @c_clientstatus CURSOR  
  DECLARE @clicm_id          NUMERIC   
         ,@clicm_cd          VARCHAR(25)    
         ,@clicm_desc        VARCHAR(200)    
         ,@clicm_created_by  VARCHAR(10)    
         ,@clicm_created_dt  DATETIME  
         ,@clicm_lst_upd_by  VARCHAR(10)        
         ,@clicm_lst_upd_dt  DATETIME  
         ,@clicm_deleted_ind CHAR(2)    
         ,@modified          char(2)   
         ,@t_errorstr        VARCHAR(250)  
         ,@l_error           NUMERIC    
    
    
    
    
  SET @c_clientstatus = CURSOR FAST_FORWARD FOR     
  SELECT clicm_id  
        ,clicm_cd  
        ,clicm_desc  
        ,clicm_created_by      
        ,clicm_created_dt      
        ,clicm_lst_upd_by      
        ,clicm_lst_upd_dt      
        ,clicm_deleted_ind    
        ,case when clicm_created_dt  = clicm_lst_upd_dt then 'N' else 'M' end modified  
  FROM   client_ctgry_mstr  
  WHERE  clicm_deleted_ind = 1    
  AND    clicm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
  AND    convert(varchar,clicm_id) LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id +'%' END  
  
  OPEN @c_clientstatus  
    
    
  FETCH NEXT FROM  @c_clientstatus  
  INTO  @clicm_id           
       ,@clicm_cd           
       ,@clicm_desc         
       ,@clicm_created_by   
       ,@clicm_created_dt   
       ,@clicm_lst_upd_by   
       ,@clicm_lst_upd_dt   
       ,@clicm_deleted_ind  
       ,@modified  
        
     
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
  --  
    IF exists(select * from clientstatus_hst where cl_status = @clicm_cd and migrate_yn in (1,3)) 
    begin
    --
      set @modified = 'M'
    --
    end
    else
    begin
    --
       set @modified = 'N'
    --
    end
    IF NOT EXISTS(SELECT cl_status FROM clientstatus WHERE cl_status = @clicm_cd and migrate_yn = 0)  
    BEGIN  
    --      
      INSERT INTO clientstatus(cls_id  
                              ,cl_status         
                              ,description       
                              ,cl_created_dt  
                              ,cl_lst_upd_dt  
                              ,cl_changed  
                              ,migrate_yn)  
                        values(@clicm_id     
                              ,@clicm_cd  
                              ,@clicm_desc  
                              ,@clicm_created_dt  
                              ,@clicm_lst_upd_dt  
                              ,@modified  
                              ,0)  
                          
       SET @l_error   = @@ERROR      
       --      
       IF @l_error > 0      
       BEGIN --#1      
       --      
         SET @t_errorstr = @clicm_cd+' could not be migrated'  
  
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
      
    FETCH NEXT FROM  @c_clientstatus  
    INTO  @clicm_id           
         ,@clicm_cd           
         ,@clicm_desc         
         ,@clicm_created_by   
         ,@clicm_created_dt   
         ,@clicm_lst_upd_by   
         ,@clicm_lst_upd_dt   
         ,@clicm_deleted_ind   
         ,@modified  
  --  
  END  
    
  CLOSE       @c_clientstatus  
  DEALLOCATE  @c_clientstatus  
    
    
  SET @pa_err = @t_errorstr  
--  
END

GO
