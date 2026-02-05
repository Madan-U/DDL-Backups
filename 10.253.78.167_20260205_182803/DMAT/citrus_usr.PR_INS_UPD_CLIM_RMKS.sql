-- Object: PROCEDURE citrus_usr.PR_INS_UPD_CLIM_RMKS
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--create table client_modification_trail(id numeric identity(1,1) 
--, crn_no numeric
--, Remarks varchar(8000)
--, created_dt datetime
--, created_by varchar(100)
--, lst_upd_dt datetime
--, lst_upd_by varchar(100)
--, deleted_ind smallint
--)

CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_CLIM_RMKS]( @pa_id              VARCHAR(20)   
                                     , @pa_tab             VARCHAR(20)   
                                     , @pa_login_name      VARCHAR(20)   
                                     , @pa_values          VARCHAR(200)   
                                     , @rowdelimiter       CHAR(4) = '*|~*'  
                                     , @coldelimiter       CHAR(4) = '|*~|'  
                                     , @pa_errmsg          VARCHAR(8000) OUT    
                                     )  
  AS  
  /*******************************************************************************  
   System         : CLASS  
   Module Name    : PR_INS_UPD_CLIM_RMKS  
   Description    : Script to update the clim_rmks column in Client_Mstr  
   Copyright(c)   : ENC Software Solutions Pvt. Ltd.  
   Version History:  
   Vers.  Author          Date         Reason  
   -----  -------------   ----------   ------------------------------------------------  
   1.0    Tushar Patel    28-MAR-2007  Initial Version.  
  **********************************************************************************/  
    --  
  
    --  
  BEGIN  
    --  
    DECLARE  @@L_ERROR       NUMERIC  
            ,@@T_ERRORSTR    VARCHAR(200)     
       
       
    IF ISNULL(@pa_id,'')<>''  
    BEGIN   
    --  
      IF @pa_tab = 'CLIM'   
      BEGIN  
      --  
 BEGIN TRANSACTION
        UPDATE client_mstr               
        SET    clim_rmks        = @PA_VALUES  
             , clim_lst_upd_by  = @PA_LOGIN_NAME  
             , clim_lst_upd_dt  = GETDATE()  
        WHERE  clim_deleted_ind = 1  
        AND    clim_crn_no      = @PA_ID  
      --    
      END  
      ELSE IF @pa_tab = 'ENTM'  
      BEGIN  
      --  
 BEGIN TRANSACTION
        UPDATE entity_mstr               
        SET    entm_rmks        = @PA_VALUES  
             , entm_lst_upd_by  = @PA_LOGIN_NAME  
             , entm_lst_upd_dt  = GETDATE()  
        WHERE  entm_deleted_ind = 1  
        AND    entm_id          = @pa_id  
      --  
      END  
    --  
    END  
    --  
      SET @@L_ERROR = @@ERROR      
    --      
      IF @@L_ERROR > 0      
      BEGIN      
      --      
        SET @@T_ERRORSTR=CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER      
      --      
        ROLLBACK TRANSACTION      
      --      
      END      
      ELSE      
      BEGIN      
      --    
		if @pa_tab = 'CLIM'   
		insert into client_modification_trail 
		select @PA_ID ,  @PA_VALUES , getdate(),'MIG',getdate(),'MIG',1    

        select top 1 @@L_ERROR = iD from client_modification_trail where crn_no = @PA_ID order by id desc

        SET @@T_ERRORSTR=CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER      

        COMMIT TRANSACTION      
      --      
      END      
    --  
    SET @PA_ERRMSG = @@T_ERRORSTR  
  
  END

GO
