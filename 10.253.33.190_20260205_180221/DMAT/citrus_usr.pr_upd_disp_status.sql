-- Object: PROCEDURE citrus_usr.pr_upd_disp_status
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--[pr_upd_disp_status] 	'CDSL',3,'61280','BILL_CDSL','2','courier','A','VISHAL','',''
CREATE PROC [citrus_usr].[pr_upd_disp_status]    
@pa_dptype  varchar(4),    
@pa_excsmid int,    
@pa_dpam_id varchar(16),
@pa_rpt_name varchar(1000),
@pa_conf    char(1),
@pa_dispatch_mode varchar(250),
@pa_edt     varchar(1),
@pa_login_name varchar(25),
@pa_pod_no varchar(100),
@pa_output  varchar(8000) output     
as    
begin    
 declare @@dpmid int    
 DECLARE @l_count numeric  
 , @l_rpt_name VARCHAR(200)
 , @l_id numeric
 
 
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1    
    
 
 IF @pa_edt = 'E'
 BEGIN
			IF @pa_dptype ='CDSL'    
			BEGIN    
			--
 				update dispatch_report_cdsl 
					set    Cof_recv    = @pa_conf 
											,dispatch_mode = @pa_dispatch_mode 
					where  dpam_id     = @pa_dpam_id 
					and    Report_name = @pa_rpt_name 
					and    Cof_recv    = 0
					and    deleted_ind = 1
			--
			END    
			IF @pa_dptype ='NSDL'    
			BEGIN    
			--
 					update dispatch_report_nsdl
						set    Cof_recv    = @pa_conf
												,dispatch_mode = @pa_dispatch_mode 
						where    dpam_id     = @pa_dpam_id 
						and    Report_name = @pa_rpt_name 
						and    Cof_recv    = 0
						and   deleted_ind = 1
			--  
			END  
	--
	END
	ELSE
	BEGIN
	--
   	IF @pa_dptype ='CDSL'    
				BEGIN    
				--
				
				IF NOT EXISTS(SELECT Report_name,dpam_id FROM dispatch_report_cdsl WHERE Report_name = @pa_rpt_name AND dpam_id = @pa_dpam_id AND Cof_recv = 1)
				BEGIN
				    SELECT @l_count = COUNT(*) , @l_rpt_name = Report_name , @l_id = dpam_id FROM dispatch_report_cdsl WHERE Report_name = @pa_rpt_name AND dpam_id = @pa_dpam_id AND Cof_recv = 2 GROUP BY Report_name ,dpam_id HAVING COUNT(*) > 1
				    
					IF EXISTS(SELECT REPORT_TYPE , DPAM_ID FROM DISPATCH_REJ_COUNT_CDSL WHERE REPORT_TYPE =@pa_rpt_name AND DPAM_ID =@pa_dpam_id )
					BEGIN
					   UPDATE DISPATCH_REJ_COUNT_CDSL SET LAST_REJECTED_COUNT = @l_count WHERE REPORT_TYPE =@pa_rpt_name AND DPAM_ID =@pa_dpam_id 
					END
					ELSE 
					BEGIN
					  INSERT INTO DISPATCH_REJ_COUNT_CDSL SELECT @pa_rpt_name , @pa_dpam_id  , @l_count
					END
					
					
					
				END
				
						insert into  dispatch_report_cdsl 
						(dpam_id
						,Report_name
						,Dispatch_dt
						,Cof_recv
						,Created_dt
						,created_by
						,lst_upd_dt
						,lst_upd_by
						,deleted_ind
						,dispatch_mode,disp_pod_no)
						select @pa_dpam_id
						,@pa_rpt_name
						,getdate()
						,0
						,getdate()
						,@pa_login_name
						,getdate()
						,@pa_login_name
						,1
						,@pa_dispatch_mode ,@pa_pod_no
						
						
						
						
				--
				END    
				IF @pa_dptype ='NSDL'    
				BEGIN    
				--
				
				IF NOT EXISTS(SELECT Report_name,dpam_id FROM dispatch_report_nsdl WHERE Report_name = @pa_rpt_name AND dpam_id = @pa_dpam_id AND Cof_recv = 1)
				BEGIN
				    SELECT @l_count = COUNT(*) , @l_rpt_name = Report_name , @l_id = dpam_id FROM dispatch_report_nsdl WHERE Report_name = @pa_rpt_name AND dpam_id = @pa_dpam_id AND Cof_recv = 2 GROUP BY Report_name ,dpam_id HAVING COUNT(*) > 1
				    
					IF EXISTS(SELECT REPORT_TYPE , DPAM_ID FROM DISPATCH_REJ_COUNT_nsdl WHERE REPORT_TYPE =@pa_rpt_name AND DPAM_ID =@pa_dpam_id )
					BEGIN
					   UPDATE DISPATCH_REJ_COUNT_nsdl SET LAST_REJECTED_COUNT = @l_count WHERE REPORT_TYPE =@pa_rpt_name AND DPAM_ID =@pa_dpam_id 
					END
					ELSE 
					BEGIN
					  INSERT INTO DISPATCH_REJ_COUNT_nsdl SELECT @pa_rpt_name , @pa_dpam_id  , @l_count
					END
					
					
					
				END
				
							insert into dispatch_report_nsdl
							(dpam_id
							,Report_name
							,Dispatch_dt
							,Cof_recv
							,Created_dt
							,created_by
							,lst_upd_dt
							,lst_upd_by
							,deleted_ind
							,dispatch_mode,disp_pod_no)
							select @pa_dpam_id
							,@pa_rpt_name
							,getdate()
							,0
							,getdate()
							,@pa_login_name
							,getdate()
							,@pa_login_name
							,1
						,@pa_dispatch_mode ,@pa_pod_no
				--  
				END   
	--
	END
    
    
    
end

GO
