-- Object: PROCEDURE citrus_usr.pr_clidpa_migrate
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--delete from multicltid
--pr_select_mig_tab '','multicltid','20/11/2007','12/12/2007','',''

CREATE    PROCEDURE [citrus_usr].[pr_clidpa_migrate](@pa_id      VARCHAR(8000)  
                                  ,@pa_from_dt VARCHAR(11)  
                                  ,@pa_to_dt   VARCHAR(11)  
                                  ,@pa_err  VARCHAR(250) OUTPUT)  
AS  
BEGIN  
--  
  DECLARE @c_clidpa CURSOR  
  DECLARE @acct_no             VARCHAR(25)  
   
         ,@clidpa_dpm_id       varchar(25)   
         ,@clidpa_clisba_id    NUMERIC   
         ,@clidpa_compm_id     NUMERIC   
         ,@clidpa_dp_id        VARCHAR(25)  
         ,@clidpa_name         VARCHAR(100)   
         ,@clidpa_flg          CHAR(1)   
         ,@clidpa_poa_type     CHAR(4)   
         ,@clidpa_created_by   VARCHAR(25)   
         ,@clidpa_created_dt   DATETIME  
         ,@clidpa_lst_upd_by   VARCHAR(25)  
         ,@clidpa_lst_upd_dt   DATETIME   
         ,@clidpa_deleted_ind  VARCHAR(2)  
         ,@modified            VARCHAR(2)  
         ,@t_errorstr          VARCHAR(250)  
         ,@l_error             NUMERIC 
         ,@clidpa_dp_type      VARCHAR(10)    
    
                         
                              
   SET @c_clidpa = CURSOR FAST_FORWARD FOR     
   SELECT clisba_acct_no  
         ,clidpa_dpm_id  
         ,clidpa_clisba_id  
         ,clidpa_compm_id   
         ,clidpa_dp_id  
         ,clidpa_name  
         ,clidpa_flg --seperated by flag in pr_select_mig_tab procedure case when clidpa_flg & 1 = 1 then 1 else 0 end  
         ,excsm_exch_cd  
         --,clidpa_poa_type  
         ,clidpa_created_dt    
         ,clidpa_lst_upd_by    
         ,clidpa_lst_upd_dt    
           
         ,case when clidpa_created_dt = clidpa_lst_upd_dt then 'N' else 'M' end modified  
   FROM   client_dp_accts  
         ,client_sub_accts  
         ,dp_mstr 
         ,exch_seg_mstr   
   WHERE  clidpa_deleted_ind = 1  
   AND    clisba_id          = clidpa_clisba_id  
   AND    dpm_id             = clidpa_dpm_id   
   AND    excsm_id           = dpm_excsm_id
   AND    clidpa_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
     
     
    
     
   OPEN @c_clidpa  
     
   FETCH NEXT FROM  @c_clidpa  
   INTO @acct_no  
       ,@clidpa_dpm_id     
       ,@clidpa_clisba_id   
       ,@clidpa_compm_id    
       ,@clidpa_dp_id  
       ,@clidpa_name  
       ,@clidpa_flg  
       ,@clidpa_dp_type
       ,@clidpa_created_dt  
       ,@clidpa_lst_upd_by  
       ,@clidpa_lst_upd_dt  
       ,@modified  
         
         
         
     
     
   WHILE @@FETCH_STATUS = 0  
   BEGIN  
   --  

       IF EXISTS(SELECT cltdpno, dpid FROM multicltid_hst WHERE cltdpno = @clidpa_dp_id and dpid  = @clidpa_dpm_id and migrate_yn IN (1,3))
       BEGIN
       --
         SET @modified= 'M'
         print 'asd'          

       --
       END
       ELSE
       BEGIN
       --
         SET @modified= 'N'         
       --
       END
       IF NOT EXISTS(SELECT cltdpno, dpid FROM multicltid WHERE cltdpno = @clidpa_dp_id and dpid  = @clidpa_dpm_id and migrate_yn=0)  
       BEGIN  
       --     
         INSERT INTO multicltid(Party_Code         
                               ,Cltdpno            
                               ,Dpid               
                               ,Introducer         
                               ,Dptype  --????????????????  
                               ,poatype              
                               ,Def                
                               ,clidpa_created_dt  
                               ,clidpa_lst_upd_dt  
                               ,clidpa_changed     
                               ,migrate_yn         
                               )  
                        values(@acct_no  
                              ,@clidpa_dp_id  
                              ,@clidpa_dpm_id  
                              ,@clidpa_name  
                              ,@clidpa_dp_type
                              ,''  
                              ,@clidpa_flg  
                              ,@clidpa_created_dt  
                              ,@clidpa_lst_upd_dt  
                              ,@modified  
                              ,0)  
  
                                 
         SET @l_error   = @@ERROR      
         --      
         IF @l_error > 0      
         BEGIN --#1      
         --      
           SET @t_errorstr = @clidpa_dpm_id + '-' + @clidpa_dp_id +' could not be migrated'  
             
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
  
  
       FETCH NEXT FROM  @c_clidpa  
       INTO @acct_no  
           ,@clidpa_dpm_id     
           ,@clidpa_clisba_id   
           ,@clidpa_compm_id    
           ,@clidpa_dp_id  
           ,@clidpa_name  
           ,@clidpa_flg  
           ,@clidpa_dp_type
           ,@clidpa_created_dt  
           ,@clidpa_lst_upd_by  
           ,@clidpa_lst_upd_dt  
           ,@modified  
       
       
   --  
   END  
     
   CLOSE       @c_clidpa  
   DEALLOCATE  @c_clidpa  
     
   SET @pa_err = @t_errorstr  
     
                          
--  
END

GO
