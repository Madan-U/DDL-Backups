-- Object: PROCEDURE citrus_usr.pr_file_validation
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create    proc [citrus_usr].[pr_file_validation] 
(@pa_tab varchar (10)
,@pa_sub_tab varchar (100)
 ,@pa_task_id varchar (100)
 ,@pa_mode          VARCHAR(10)                                    
            ,@pa_db_source     VARCHAR(250)    
            ,@pa_errmsg        VARCHAR(8000) output  )

as 
begin 
/*
declare @l_err varchar (100)
set @l_err = ''
exec  pr_file_validation  @pa_tab =  'dpb9' ,@pa_sub_tab = 'Duplicate' , @pa_task_id = ''  ,@pa_mode =@pa_mode ,@pa_db_source = @pa_db_source,@pa_errmsg        = @l_err

if @l_err = 'return'
begin
				return
end

set 	@l_err = ''
*/

	if @pa_tab = 'DPB9' and @pa_sub_tab = 'Duplicate'
	begin 
	IF EXISTS (SELECT count(1) FROM FILETASK WHERE TASK_NAME	LIKE '%CLIENT MASTER IMPORT-DPB9DPS8-CDSL%' 
	AND STATUS ='RUNNING' group by substring (TASK_NAME,1,len(task_name)-9) having count(1)>1 )
			BEGIN 
			UPDATE FILETASK
					SET    USERMSG = 'ERROR : DPB9 FILE RUNNING, PLEASE WAIT FOR COMPLETION.',
							STATUS = 'FAILED'
					WHERE  TASK_ID in(select max(task_id) from filetask WHERE TASK_NAME	LIKE '%CLIENT MASTER IMPORT-DPB9DPS8-CDSL%' AND STATUS ='RUNNING' )
					set @pa_errmsg = 'RETURN'
				
			END 
	end

	if @pa_tab = 'DPB9' and @pa_sub_tab = 'File'
	begin 
	IF NOT EXISTS (SELECT CITRUS_USR.FN_SPLITVAL_BY(VALUE,2,'~') FROM dps8_source WHERE LEFT(VALUE,1) = 'H' 
	AND  RIGHT(CITRUS_USR.FN_SPLITVAL_BY(@pa_db_source,CITRUS_USR.ufn_CountString(@pa_db_source,'\'),'\'),8)='120'+CITRUS_USR.FN_SPLITVAL_BY(VALUE,2,'~') )
		BEGIN 
		UPDATE FILETASK
				SET    USERMSG = 'ERROR : SELECTED DP ID IS NOT MATCHING WITH IMPORTING FILE',
						STATUS = 'FAILED'
				WHERE  TASK_ID in(select max(task_id) from filetask WHERE TASK_NAME	LIKE '%CLIENT MASTER IMPORT-DPB9DPS8-CDSL%' AND STATUS ='RUNNING' )
				set @pa_errmsg = 'RETURN'
				
		END 
	end

	if @pa_tab = 'DPM5' and @pa_sub_tab = 'File'
	begin 
	IF  LEFT(citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\'),6)  <> '11DPM3'
		BEGIN 
		UPDATE FILETASK
				SET    USERMSG = 'ERROR : SELECTED FILE IS NOT DPM3 FILE',
						STATUS = 'FAILED'
				--WHERE  TASK_ID in(select max(task_id) from filetask WHERE TASK_NAME	LIKE '%CLIENT MASTER IMPORT-DPB9DPS8-CDSL%' AND STATUS ='RUNNING' )
				WHERE  TASK_ID  = @pa_task_id 
				set @pa_errmsg = 'RETURN'
		END 
	end

	if @pa_tab = 'DPM5' and @pa_sub_tab = 'Duplicate'
	begin 
	IF EXISTS (SELECT count(1) FROM FILETASK WHERE TASK_NAME	LIKE '%DPM DPM5-CDSL FILE - CDSL%' 
	AND STATUS ='RUNNING' group by substring (TASK_NAME,1,len(task_name)-9) having count(1)>1 )
			BEGIN 
			
			UPDATE FILETASK
					SET    USERMSG = 'ERROR : DPM3 FILE IS ALREADY RUNNING, PLEASE WAIT FOR COMPLETION.',
							STATUS = 'FAILED'
					WHERE  TASK_ID in(select max(task_id) from filetask WHERE TASK_NAME	LIKE '%DPM DPM5-CDSL FILE - CDSL%' AND STATUS ='RUNNING' )
					set @pa_errmsg = 'RETURN'
					
				
			END 
	end

end

GO
