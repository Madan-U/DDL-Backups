-- Object: PROCEDURE citrus_usr.pr_mak_roles_actions_bakfeb1815
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_mak_roles_actions_bakfeb1815](@pa_id           VARCHAR(8000)  
                                     ,@pa_action       VARCHAR(20)  
                                     ,@pa_login_name   VARCHAR(20)  
                                     ,@pa_rol_cd       VARCHAR(20)  
                                     ,@pa_rol_desc     VARCHAR(200)  
                                     --,@pa_values       VARCHAR(8000)  
                                     ,@pa_read         VARCHAR(8000)  
                                     ,@pa_write        VARCHAR(8000)  
                                     ,@pa_print        VARCHAR(8000)  
                                     ,@pa_export       VARCHAR(8000)  
                                     ,@pa_chk_yn       NUMERIC  
                                     ,@rowdelimiter    CHAR(4)  
                                     ,@coldelimiter    CHAR(4)  
                                     ,@pa_errmsg       VARCHAR(8000) OUTPUT  
                                     )  
AS                              
 /*    
 *********************************************************************************    
  SYSTEM         : CLASS    
  MODULE NAME    : PR_MAK_ROLES_ACTIONS    
  DESCRIPTION    : THIS PROCEDURE FOR DEFINE ROLES    
  COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.    
  VERSION HISTORY:    
  VERS.  AUTHOR            DATE         REASON    
  -----  -------------     ----------   -------------------------------------------------    
  1.0    TUSHAR            05-FEB-2007  INITIAL  
 -----------------------------------------------------------------------------------*/    
 --    
 BEGIN --MAIN BEGIN    
 --    
   SET NOCOUNT ON    
   --   
   DECLARE @@remainingstring_val  VARCHAR(8000)    
         , @@currstring_val       VARCHAR(8000)    
         , @@foundat_val          INT    
         , @@remainingstring_id   VARCHAR(8000)    
         , @@currstring_id        VARCHAR(8000)    
         , @@foundat_id           INT    
         , @@delimeterlength      INT    
         , @L_errorstr            VARCHAR(8000)    
         , @@l_counter            NUMERIC  
         , @L_rol_id              NUMERIC  
         , @L_act_cd              VARCHAR(20)  
         , @L_act_id              NUMERIC  
         , @L_scr_id              NUMERIC  
         , @@l_excsm_id           NUMERIC  
         , @@l_rola_access1       INT  
         , @L_delimeter           VARCHAR(10)    
         , @Loop_counter          NUMERIC   
         , @Loop_counter_dec      NUMERIC  
         , @@c_bitrm_bit_location INT  
         , @@c_access_cursor      CURSOR    
         , @@c_excsm_id           NUMERIC  
         , @@l_action             VARCHAR(20)  
         , @l1                    NUMERIC   
         , @l2                    NUMERIC  
         , @l3                    NUMERIC  
         , @l4                    NUMERIC  
         , @l_depth               NUMERIC  
         , @l_pr_scr_id           NUMERIC  
         , @l_count               NUMERIC   
            
   DECLARE @t table (l1 NUMERIC, l2 NUMERIC, l3 NUMERIC,l4 NUMERIC,id  NUMERIC, depth INT)   
   DECLARE @depth int  
   SET @l_count = 1  
     
   --  
   INSERT INTO @t  
   SELECT S1.scr_ID, S2.scr_ID, S3.scr_ID, S4.scr_ID, NULL, 1  
   FROM screens AS S1  
   left outer join screens S2 ON S1.scr_id=S2.scr_parent_id  
   left outer join screens S3 ON S2.scr_id=S3.scr_parent_id  
   left outer join screens S4 ON S3.scr_id=S4.scr_parent_id  
   WHERE S1.scr_parent_id IS NULL  
                     
                    
   update @t set depth = depth + 1 where l2 is not null  
   update @t set depth = depth + 1 where l3 is not null  
   update @t set depth = depth + 1 where l4 is not null   
     
   --  
   SET @l_errorstr           = ''    
   SET @l_delimeter          = '%'+ @rowdelimiter + '%'    
   SET @@delimeterlength     = LEN(@rowdelimiter)    
   SET @@remainingstring_id  = @pa_id  
   SET @@l_counter     = 1  
   SET @@l_rola_access1      = 0  
   --SET @@remainingstring_val = @pa_values    
   --  
   CREATE TABLE #t_excsm_bitrm  
   ( bitrm_bit_location NUMERIC  
    ,bitrm_parent_cd    VARCHAR(25)  
    ,excsm_id           NUMERIC  
   )  
   --  
   INSERT INTO #t_excsm_bitrm  
   ( bitrm_bit_location  
    ,bitrm_parent_cd  
    ,excsm_id  
   )  
   SELECT bitrm_bit_location  
         ,bitrm_parent_cd  
         ,excsm_id  
   FROM   bitmap_ref_mstr bitrm  
         ,exch_seg_mstr excsm  
   WHERE  excsm.excsm_desc        = bitrm.bitrm_child_cd  
   AND    bitrm.bitrm_parent_cd     IN ('ACCESS1', 'ACCESS2')  
   AND    bitrm.bitrm_deleted_ind = 1  
   AND    excsm.excsm_deleted_ind = 1  
   --  
   IF @pa_chk_yn = 0  
   --  
   BEGIN  
     IF @pa_action= 'EDT'   
     --  
     BEGIN  
     --  
       update roles_actions  set ROLA_DELETED_IND = 0 
       WHERE  rola_rol_id=@pa_id  
         
       SET @@l_action='INS'  
     --  
     END  
          
     IF @pa_action= 'INS' OR @@l_action='INS'  
     --  
     BEGIN  
       
       SELECT @l_rol_id = rol_id   
       FROM   roles   
       WHERE  rol_cd =  @pa_rol_cd  
         
       IF  ISNULL(@l_rol_id,0)=0  
       --   
       BEGIN  
        --  
          SET @l_rol_id = 0   
        --  
       END --EXIST DATA  
       --  
       IF  @l_rol_id = 0  
       --  
        BEGIN  
        --  
        BEGIN TRANSACTION   
          --  
          SELECT @l_rol_id= ISNULL(MAX(rol_id),0)+1 FROM roles   
           
          INSERT INTO roles  
          (rol_id  
          ,rol_cd  
          ,rol_desc  
          ,rol_created_by  
          ,rol_created_dt  
          ,rol_lst_upd_by  
          ,rol_lst_upd_dt  
          ,rol_deleted_ind  
          )  
          VALUES  
          (@l_rol_id  
          ,@pa_rol_cd  
          ,@pa_rol_desc  
          ,@pa_login_name  
          ,getdate()  
          ,@pa_login_name  
          ,getdate()  
          ,1  
          );  
        --  
        IF @@error>0   
        --  
        BEGIN  
        --  
            ROLLBACK TRANSACTION  
        --  
        END  
        ELSE  
        BEGIN  
        --  
            COMMIT TRANSACTION  
        --  
        END  
        --  
        END --END OF @L_ROL_ID = 0  
          
        WHILE @@remainingstring_id <> ''    
        BEGIN --#1    
        --    
         SET @@foundat_id  = 0    
         SET @@foundat_id  =  patindex('%'+@l_delimeter+'%', @@remainingstring_id)    
         --    
         IF @@foundat_id > 0    
         BEGIN    
         --    
          SET @@currstring_id      = substring(@@remainingstring_id, 0, @@foundat_id)    
          SET @@remainingstring_id = substring(@@remainingstring_id, @@foundat_id+@@delimeterlength, len(@@remainingstring_id)- @@foundat_id+@@delimeterlength)    
         --    
         END    
         ELSE    
         BEGIN    
         --    
          SET @@currstring_id = @@remainingstring_id    
          SET @@remainingstring_id = ''    
         --    
         END    
         --    
         
         
         IF @@currstring_id <> ''    
         BEGIN --#2    
         --  
           WHILE @l_count < 5  
           BEGIN   
           --  
           
           
             IF @l_count  = 1   
             BEGIN  
             --  
               SET @@remainingstring_val = @pa_read  
               PRINT  @PA_READ  
             --  
             END  
             ELSE IF  @l_count  = 2  
             BEGIN  
             --  
               SET @@remainingstring_val = @pa_write  
               PRINT @PA_WRITE  
             --  
             END  
             ELSE IF  @l_count  = 3  
             BEGIN  
             --  
               SET @@remainingstring_val = @pa_print  
               PRINT @PA_PRINT  
             --  
             END  
             ELSE IF  @l_count  = 4  
             BEGIN  
             --  
               SET @@remainingstring_val = @pa_export  
               PRINT @PA_EXPORT   
             --  
             END  
             
             
             WHILE @@remainingstring_val <> ''    
             BEGIN--#3    
               --    
               SET @@foundat_val  = 0    
               SET @@foundat_val  =  patindex('%'+@l_delimeter+'%', @@remainingstring_val)    
               --    
               IF @@foundat_val > 0    
               BEGIN    
                 --    
                 SET @@currstring_val      = substring(@@remainingstring_val, 0, @@foundat_val)    
                 SET @@remainingstring_val = substring(@@remainingstring_val, @@foundat_val+@@delimeterlength, len(@@remainingstring_val)- @@foundat_val+@@delimeterlength)    
                 --    
               END    
               ELSE    
               BEGIN    
                 --    
                 SET @@currstring_val      = @@remainingstring_val    
                 SET @@remainingstring_val = ''    
                 --    
               END    
               --    
               IF @@currstring_val <> ''    
               BEGIN--#4    
               --   
  print @@currstring_val
                 SET  @l_act_cd         =  citrus_usr.fn_splitval(@@currstring_val,1)  
                 SET  @l_scr_id         =  citrus_usr.fn_splitval(@@currstring_val,2)  
                 SET  @loop_counter     =  citrus_usr.ufn_countstring(@@currstring_val,@coldelimiter)-2  
                 SET  @loop_counter_dec = 3  
  
  
  
                 WHILE @loop_counter <> 0  
                 BEGIN  
  
                   --         
                   SET  @@l_excsm_id     =  citrus_usr.fn_splitval(@@currstring_val,@loop_counter_dec)  
                   --  
                   
                    IF ISNULL(@@l_excsm_id,0)<>0  
                    --  
                    BEGIN  
                    -- 
                    
                    
                      /*SELECT @@L_BITRM_BIT_LOCATION = BITRM_BIT_LOCATION  
                      FROM   BITMAP_REF_MSTR BITRM, EXCH_SEG_MSTR EXCSM  
                      WHERE  EXCSM.EXCSM_DESC        = BITRM.BITRM_CHILD_CD  
                      AND    BITRM.BITRM_PARENT_CD  IN ('ACCESS1', 'ACCESS2')  
                      AND    EXCSM_ID = @L_EXCSM_ID   
                      AND    BITRM.BITRM_DELETED_IND = 1  
                      AND    EXCSM.EXCSM_DELETED_IND = 1*/  
                      SET    @@c_access_cursor  = CURSOR FAST_FORWARD FOR    
                      SELECT bitrm_bit_location   
                      FROM   #t_excsm_bitrm WHERE excsm_id = @@l_excsm_id    
                      --  
                      OPEN  @@c_access_cursor    
                      FETCH NEXT FROM @@c_access_cursor INTO @@c_bitrm_bit_location  
                      --  
  
                      IF @@fetch_status = 0    
                      BEGIN  
                      --    
                       SET @@l_rola_access1 = power(2, @@c_bitrm_bit_location -1) | @@l_rola_access1    
                         
                       FETCH NEXT FROM @@c_access_cursor INTO @@c_bitrm_bit_location  
                      --    
                      END  
                      --  
                        CLOSE      @@c_access_cursor    
                        DEALLOCATE @@c_access_cursor    
                      --  
                       
                      --  
                      --  
                    END     
                    
                     SET @loop_counter     = @loop_counter-1  
                        SET @loop_counter_dec = @loop_counter_dec +1   
                     
  
                 END --@LOOP_COUNTER <> 0  
                 --   
  
                 --  
                   /*SELECT @l_act_id = act_id  
                   FROM   actions               act  
                   WHERE  act.act_deleted_ind = 1  
                   AND    act.act_cd          = @l_act_cd  
                   AND    act.act_scr_id      = @l_scr_id*/  
  
  
                   SELECT @l1=l1,@l2=l2,@l3=l3,@l4=l4 ,@l_depth = depth  
                   FROM   @t   
                   WHERE  l1 = @l_scr_id   
                   OR     l2 = @l_scr_id   
                   OR     l3 = @l_scr_id  
                   OR     l4 = @l_scr_id  
  
   
  
  
  
  
                   WHILE @l_depth <> 0  
                   BEGIN                   
                   --  
                   
					 if (  select  count(1) 
                   FROM   @t   
                   WHERE  l1 = @l_scr_id   
                   OR     l2 = @l_scr_id   
                   OR     l3 = @l_scr_id  
                   OR     l4 = @l_scr_id  )  =1
                   begin 
                   
                   
                     SELECT @l_pr_scr_id = CASE @l_depth WHEN 4 THEN  (SELECT @l4)   
                                                         WHEN 3 THEN  (SELECT @l3)   
                                                         WHEN 2 THEN  (SELECT @l2)  
                                                         WHEN 1 THEN  (SELECT @l1) END   
                                                      
                   end 
                   else 
                   begin
                      SELECT @l_pr_scr_id = @l_scr_id
                   end 
                   
                                                         
                                                         
  
                     IF NOT EXISTS(SELECT rola_rol_id FROM roles_actions WHERE rola_act_id = (SELECT ISNULL(act_id,0)  
                                                                                              FROM   actions               act  
                                                                                              WHERE  act.act_deleted_ind = 1  
                                                                                              AND    act.act_cd          = @l_act_cd  
                                                                                              AND    act.act_scr_id      = @l_pr_scr_id)  
                                                                                              AND  rola_rol_id =@l_rol_id)  
                     BEGIN  
                     --  
                       BEGIN TRANSACTION  
  
                       SET  @l_act_id =0   
   
                       SELECT @l_act_id = ISNULL(act_id,0)  
                       FROM   actions               act  
                       WHERE  act.act_deleted_ind = 1  
                       AND    act.act_cd          = @l_act_cd  
                       AND    act.act_scr_id      = @l_pr_scr_id   
                         
  
                       PRINT @l_act_cd  
                       PRINT @l_pr_scr_id  
                       PRINT @l_act_id  
  
                       IF @L_ACT_ID <> 0  
                       BEGIN  
                       --  
                         INSERT INTO roles_actions  
                         ( rola_rol_id  
                         , rola_act_id  
                         , rola_access1  
                         , rola_created_by  
                         , rola_created_dt  
                         , rola_lst_upd_by  
                         , rola_lst_upd_dt  
                         , rola_deleted_ind  
                         )  
                         VALUES  
                         ( @l_rol_id  
                         , @l_act_id  
                         , @@l_rola_access1  
                         , @pa_login_name  
                         , getdate()  
                         , @pa_login_name  
                         , getdate()  
                         , 1  
                         )  
                       --  
                       END  
  
                       IF @@error>0   
                       --  
                       BEGIN  
                       --  
                          ROLLBACK TRANSACTION  
                       --    
                       END  
                       ELSE  
                       BEGIN  
                       --  
                          COMMIT TRANSACTION  
                       --  
                       END  
                     --  
                     END  
                     --  
                       SET @l_depth = @l_depth-1  
                     --  
                   --    
                   END    
                    --  
                    SET @@l_rola_access1 = 0  
  
               END  --#4   
                    --  
            END --#3  
            --  
            SET @l_count = @l_count + 1  
            --  
          END --loop                     
          --  
        END --#2  
      --   
      END --#1  
  
  
       --  
        SET @pa_errmsg = CONVERT(VARCHAR,@L_ROL_ID)+@COLDELIMITER+'Roles actions Successfully Inserted/Edited'+@COLDELIMITER+@ROWDELIMITER  
       --  
     --  
     END --@PA_ACTION='INS'  
     ELSE IF @pa_action='DEL'  
     --  
     BEGIN  
     --  
       UPDATE roles  
       SET    rol_deleted_ind = 0  
       WHERE  rol_id = @pa_id  
         
       UPDATE roles_actions  
       SET    rola_deleted_ind = 0  
       WHERE  rola_rol_id = @pa_id  
     --  
     END  
  
   --  
   END --@PA_CHK_YN=0  
   
   
   if exists(select entro_rol_id from entity_roles , roles ,login_names 
			 where  entro_rol_id = rol_id and replace(rol_cd,'_'+logn_name,'') = @pa_rol_cd  and logn_name = ENTRO_LOGN_NAME  and entro_deleted_ind = 1 and rol_deleted_ind = 1 )
   exec [pr_mak_roles_actions_temp_change] @pa_rol_cd
    
 --    
 END   --MAIN END  
  
  
  


/*
--menu entry for "sbu"--
1) click on 'Add New' button, then enter the following into textbox
   screen code  :  SBUMSTR
   screen name  :  SBU MASTER
   screen url   :  SBUMASTER\SBUMASTER.ASPX
   parent menu  :  CONFIGURATION MASTER
   menu type    :  MASTER FORM
   after menu   :  CONFIGURATION MASTER
   map roles    :  check 'select all' check box
   
   then click 'save update' button on the top menu
   
2) click on 'Add New' button, then enter the following into textbox
   screen code  :  SBUMM
   screen name  :  SBU MASTER(MAKER) 
   screen url   :  SBUMASTER\SBUMASTERMAKER.ASPX
   parent menu  :  CONFIGURATION MASTER
   menu type    :  MAKER FORM 
   after menu   :  SBU MASTER
   map roles    :  check 'select all' check box
    
   then click 'save update' button on the top menu
   
3) click on 'Add New' button, then enter the following into textbox
   screen code  :  SBUMC
   screen name  :  SBU MASTER(CHECKER)
   screen url   :  SBUMASTER\SBUMASTERCHECKER.ASPX
   parent menu  :  CONFIGURATION MASTER
   menu type    :  CHECKER FORM
   after menu   :  SBU MASTER(MAKER)
   map roles    :  check 'select all' check box
   
   then click 'save update' button on the top menu   

*/

GO
