-- Object: PROCEDURE citrus_usr.pr_inw_client_reg
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--alter table inw_client_reg add inwcr_clibank_name varchar(1000)

CREATE proc [citrus_usr].[pr_inw_client_reg]                      
(                      
 @pa_id               VARCHAR(50)                                  
 , @pa_action         VARCHAR(20)                                  
 , @pa_login_name     VARCHAR(20)        
,  @pa_recvd_dt      varchar(11)                        
 , @pa_frmno       varchar(25)                                 
 , @pa_dpmdpid       VARCHAR(20)                 
 , @pa_bankid       VARCHAR(20)                         
 , @pa_charge       VARCHAR(25)                    
 , @pa_name       VARCHAR(25)          
 , @pa_pay_mode       VARCHAR(15)          
 , @pa_cheque_no       VARCHAR(20)     
 , @pa_bankaccno_no       VARCHAR(20)    
 , @pa_received_from_bank  varchar(1000)
 , @pa_inwcr_cheque_dt  datetime
 , @pa_bankbranch varchar(500)
 , @pa_rmks           VARCHAR(8000)                      
 , @pa_chk_yn         INT                         
 , @rowdelimiter      CHAR(4)       = '*|~*'                                  
 , @coldelimiter      CHAR(4)       = '|*~|'                                  
 , @pa_errmsg         VARCHAR(8000) output                           
)                      
as                      
begin                      
--                      
DECLARE @t_errorstr      VARCHAR(8000)                                
      , @l_error           BIGINT                       
     , @l_id              INT                  
     , @l_dpm_id         numeric(12)  
     ,@l_excsm_id        numeric(20)  
     ,@l_compname        varchar(350)  
                      
IF @pa_action = 'INS'                      
begin                      
--                      
select @l_dpm_id = dpm_id from dp_mstr where dpm_dpid = @pa_dpmdpid and dpm_deleted_ind =1        
if exists(select top 1 inwcr_frmno from inw_client_reg where inwcr_frmno = @pa_frmno and inwcr_dmpdpid =@l_dpm_id  and inwcr_deleted_ind = 1)      
begin      
--      
  SELECT @t_errorstr = 'ERROR: Entry For Form No. ' + convert(varchar,@pa_frmno) + ' already exists'         
--      
end      
else      
begin      
--              
 SELECT @l_id = ISNULL(MAX(INWCR_ID),0) + 1 FROM inw_client_reg                      
 begin transaction 

select @l_id                      
 ,@l_dpm_id                      
 ,@pa_frmno                      
 ,convert(numeric(18,2),@pa_charge)                      
 ,@pa_rmks                      
 ,@pa_login_name                      
 ,getdate()                      
 ,@pa_login_name                      
 ,getdate()                      
 ,1                  
,convert(numeric,@pa_bankid)           
,@pa_name          
,@pa_pay_mode          
,@pa_cheque_no        
,convert(datetime,@pa_recvd_dt,103)   
,@pa_bankbranch
,@pa_bankaccno_no, @pa_received_from_bank,@pa_inwcr_cheque_dt 
                     
 insert into inw_client_reg                      
 (                      
 inwcr_id                      
 ,inwcr_dmpdpid                      
 ,inwcr_frmno                      
 ,inwcr_charge_collected                      
 ,inwcr_rmks                      
 ,inwcr_created_by                      
 ,inwcr_created_dt                      
 ,inwcr_lst_upd_by                      
 ,inwcr_lst_upd_dt                      
 ,inwcr_deleted_ind                 
,INWCR_BANK_ID           
,INWCR_NAME          
,INWCR_PAY_MODE           
,INWCR_cheque_no        
,INWCR_RECVD_DT   
,inwcr_bank_branch             
,inwcr_clibank_accno  
,inwcr_clibank_name 
,inwcr_cheque_dt  

 ) values                      
 (                      
 @l_id                      
 ,@l_dpm_id                      
 ,@pa_frmno                      
 ,convert(numeric(18,2),@pa_charge)                      
 ,@pa_rmks                      
 ,@pa_login_name                      
 ,getdate()                      
 ,@pa_login_name                      
 ,getdate()                      
 ,1                  
,convert(numeric,@pa_bankid)           
,@pa_name          
,@pa_pay_mode          
,@pa_cheque_no        
,convert(datetime,@pa_recvd_dt,103)   
,@pa_bankbranch
,@pa_bankaccno_no, @pa_received_from_bank,@pa_inwcr_cheque_dt           
 )                      
 SET @l_error = @@error                                
      IF @l_error <> 0                                
      BEGIN                                
      --                                
        IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)                                
        BEGIN                                
        --                                
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)                                
        --                                
        END                                
        ELSE                                
     BEGIN                                
        --                                
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'                                
        --                                
        END                                
                                
        ROLLBACK TRANSACTION                                 
                                
        RETURN                                
      --                                
      END                                
      ELSE                         
      BEGIN                                
      --             
	 select @l_excsm_id  = dpm_excsm_id from dp_mstr where dpm_dpid = @pa_dpmdpid and dpm_deleted_ind =1  
	  
	 select @l_compname = compm_name1 from company_mstr,exch_seg_mstr  
	 where compm_id = excsm_compm_id  
	 and excsm_id =@l_excsm_id  
	 and compm_deleted_ind = 1  
	 and excsm_deleted_ind =1   
                
        set @t_errorstr = convert(varchar,@l_id) + '|*~|' + @l_compname        
        COMMIT TRANSACTION                                
      --                                
      END      
--      
end                       
--                      
end                      
IF @pa_action = 'EDT'                      
begin                      
--            
 select @l_dpm_id = dpm_id from dp_mstr where dpm_dpid = @pa_dpmdpid and dpm_deleted_ind =1              
 BEGIN TRANSACTION                        
                      
 update inw_client_reg                      
 set inwcr_dmpdpid = @l_dpm_id                
,INWCR_BANK_ID = convert(numeric,@pa_bankid)                      
 ,inwcr_frmno =@pa_frmno                       
 ,inwcr_charge_collected = convert(numeric(18,2),@pa_charge)           
,INWCR_NAME  = @pa_name          
,INWCR_PAY_MODE = @pa_pay_mode           
,INWCR_cheque_no =  @pa_cheque_no         
,INWCR_RECVD_DT =convert(datetime,@pa_recvd_dt,103)  
,inwcr_clibank_accno = @pa_bankaccno_no
 , inwcr_clibank_name = @pa_received_from_bank                  
 ,inwcr_rmks = @pa_rmks                      
 ,inwcr_lst_upd_by = @pa_login_name                      
 ,inwcr_lst_upd_dt = getdate()   
,inwcr_cheque_dt=@pa_inwcr_cheque_dt   
,inwcr_bank_branch =  @pa_bankbranch                
 where inwcr_id = convert(int,@pa_id)                      
 and inwcr_deleted_ind = 1                      
                      
 SET @l_error = @@error                                
      IF @l_error <> 0                                
      BEGIN                                
      --                            
        IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)                                
        BEGIN                                
        --                                
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)                                
        --                                
        END                                
        ELSE                                
        BEGIN                                
        --                                
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'                                
        --                                
        END                                
                                
        ROLLBACK TRANSACTION                                 
                                
        RETURN                                
      --                                
      END                                
      ELSE                                
      BEGIN                                
      --                            
        select @l_excsm_id  = dpm_excsm_id from dp_mstr where dpm_dpid = @pa_dpmdpid and dpm_deleted_ind =1  
  
        select @l_compname = compm_name1 from company_mstr,exch_seg_mstr  
	 where compm_id = excsm_compm_id  
	 and excsm_id =@l_excsm_id  
	 and compm_deleted_ind = 1  
	 and excsm_deleted_ind =1   
                
        set @t_errorstr = convert(varchar,@pa_id) + '|*~|' + @l_compname   
                                
        COMMIT TRANSACTION                                
 --                                
      END       
--                      
end                      
                      
IF @PA_ACTION = 'DEL'                       
begin                      
--                      
    begin transaction                       
   update inw_client_reg                      
  set inwcr_deleted_ind = 0                      
  ,inwcr_lst_upd_by = @pa_login_name                      
  ,inwcr_lst_upd_dt = getdate()                      
  where inwcr_id = convert(int,@pa_id)                      
  and inwcr_deleted_ind = 1                      
                      
  SET @l_error = @@error                                
      IF @l_error <> 0                                
      BEGIN                                
      --                                
        IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)                                
  BEGIN                                
        --                                
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)                                
        --                     
        END                                
        ELSE                                
        BEGIN                                
        --                                
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'                                
        --                                
        END                                
                                
        ROLLBACK TRANSACTION                                 
                                
        RETURN                                
      --                                
      END                                
      ELSE                                
      BEGIN                                
      --                            
        set @t_errorstr = ' '                         
        COMMIT TRANSACTION                                
      --                                
      END                       
--                     
end       
  
SET @pa_errmsg =  @t_errorstr                    
--                      
end

GO
