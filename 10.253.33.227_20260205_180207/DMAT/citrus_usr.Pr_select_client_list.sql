-- Object: PROCEDURE citrus_usr.Pr_select_client_list
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[Pr_select_client_list] 4,'','',1,'BASIS POINT|*~|',''
--select citrus_usr.fn_get_child(1 , 'BASIS POINT|*~|')  
--select * from citrus_usr.fn_acct_list(146337 ,1,0)	
--select dpm_id from dp_mstr where default_dp = 4 and dpm_deleted_ind =1    
CREATE Proc [citrus_usr].[Pr_select_client_list]             
@pa_excsmid int,                  
@pa_fromaccid varchar(16),                  
@pa_toaccid varchar(16),                  
@pa_login_pr_entm_id numeric,                    
@pa_login_entm_cd_chain  varchar(8000),                    
@pa_output varchar(8000) output                    
as                        
begin                        
                        
declare @@dpmid int,                        
@@tmpholding_dt datetime
select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                        
declare @@l_child_entm_id      numeric                    
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
                  
                  
if @pa_fromaccid = ''                  
begin                  
 set @pa_fromaccid = '0'                  
 set @pa_toaccid = '99999999999999999'                  
end                    
if @pa_toaccid = ''                  
begin                  
 set @pa_toaccid = @pa_fromaccid                  
end                  
                      
                     
                      
IF @pa_toaccid =''                        
BEGIN                        
SET @pa_toaccid= @pa_fromaccid             
END                        
           
           
    INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
  
    SELECT * FROM #ACLIST

    TRUNCATE TABLE #ACLIST
	DROP TABLE #ACLIST           
                        
END

GO
