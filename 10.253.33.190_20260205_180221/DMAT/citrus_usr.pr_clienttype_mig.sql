-- Object: PROCEDURE citrus_usr.pr_clienttype_mig
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[pr_clienttype_mig](@pa_id         varchar(8000)  
                                  ,@pa_from_dt    varchar(11)   
                                  ,@pa_to_dt      varchar(11)   
                                  ,@pa_err        VARCHAR(250) OUTPUT)  
AS  
BEGIN  
--  
  DECLARE @c_clienttype    CURSOR  
  DECLARE @enttm_id          NUMERIC   
         ,@enttm_cd          VARCHAR(3)    
         ,@enttm_desc        VARCHAR(25)    
         ,@enttm_prefix      VARCHAR(3)         
         ,@enttm_created_by  VARCHAR(10)    
         ,@enttm_created_dt  DATETIME  
         ,@enttm_lst_upd_by  VARCHAR(10)        
         ,@enttm_lst_upd_dt  DATETIME  
         ,@enttm_deleted_ind CHAR(2)    
         ,@modified          char(2)   
         ,@t_errorstr        VARCHAR(250)  
         ,@l_error           NUMERIC    
    
    
    
    
  SET @c_clienttype = CURSOR FAST_FORWARD FOR     
  SELECT enttm_id  
        ,convert(varchar(3),enttm_cd)  
        ,enttm_desc  
        ,convert(varchar(3),enttm_prefix)  
        ,enttm_created_by      
        ,enttm_created_dt      
        ,enttm_lst_upd_by      
        ,enttm_lst_upd_dt      
        ,enttm_deleted_ind    
        ,case when enttm_created_dt  = enttm_lst_upd_dt then 'N' else 'M' end modified  
  FROM   entity_type_mstr  
  WHERE  enttm_deleted_ind = 1    
  AND    enttm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
  AND    convert(varchar,enttm_id) LIKE CASE WHEN LTRIM(RTRIM(@pa_id))   = '' THEN '%' ELSE @pa_id +'%' END  
  AND    enttm_cli_yn & 2   = 2    


  
  OPEN @c_clienttype  
    
    
  FETCH NEXT FROM  @c_clienttype  
  INTO  @enttm_id           
       ,@enttm_cd           
       ,@enttm_desc         
       ,@enttm_prefix  
       ,@enttm_created_by   
       ,@enttm_created_dt   
       ,@enttm_lst_upd_by   
       ,@enttm_lst_upd_dt   
       ,@enttm_deleted_ind  
       ,@modified  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
  --
    IF exists(select * from clienttype_hst where cl_type = @enttm_cd and migrate_yn in (1,3)) 
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
  
    IF NOT EXISTS(SELECT cl_type FROM clienttype WHERE cl_type = @enttm_cd and migrate_yn = 0)  
    BEGIN  
    --      
      INSERT INTO clienttype(enttm_id  
                            ,cl_type  
                            ,description       
                            ,group_code  
                            ,prefix  
                            ,ct_created_dt  
                            ,ct_lst_upd_dt  
                            ,ct_changed  
                            ,migrate_yn)  
                      values(@enttm_id     
                            ,@enttm_cd  
                            ,@enttm_desc  
                            ,''  
                            ,@enttm_prefix  
                            ,@enttm_created_dt  
                            ,@enttm_lst_upd_dt  
                            ,@modified  
                            ,0)  
                          
       SET @l_error   = @@ERROR      
       --      
       IF @l_error > 0      
       BEGIN --#1      
       --      
         SET @t_errorstr = @enttm_cd+' could not be migrated'  
  
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
      
    FETCH NEXT FROM  @c_clienttype  
    INTO  @enttm_id           
         ,@enttm_cd           
         ,@enttm_desc         
         ,@enttm_prefix  
         ,@enttm_created_by   
         ,@enttm_created_dt   
         ,@enttm_lst_upd_by   
         ,@enttm_lst_upd_dt   
         ,@enttm_deleted_ind  
         ,@modified  
  --  
  END  
    
  CLOSE       @c_clienttype  
  DEALLOCATE  @c_clienttype  
    
 
  SET @pa_err = @t_errorstr  
--  
END

GO
