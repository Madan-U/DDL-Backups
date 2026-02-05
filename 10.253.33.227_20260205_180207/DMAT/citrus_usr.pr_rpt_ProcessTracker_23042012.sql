-- Object: PROCEDURE citrus_usr.pr_rpt_ProcessTracker_23042012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create Proc [citrus_usr].[pr_rpt_ProcessTracker_23042012]
@pa_level int,
@pa_fortask varchar(200),          
@pa_fordate varchar(11),
@pa_status varchar(15),          
@pa_output varchar(8000) output    
as
begin
	IF @pa_level = 1
	BEGIN
		SELECT TASK_NAME,START_DT = CONVERT(VARCHAR,TASK_START_DT,109),END_DT= CONVERT(VARCHAR,TASK_START_DT,109)
		,STATUS,TASK_FILEDATE = CONVERT(VARCHAR,TASK_FILEDATE,109), TASK_USER=LOGN_NAME ,USERMSG 
		FROM FILETASK 
		WHERE 
		TASK_START_DT LIKE @pa_fordate + '%'
		AND STATUS LIKE  @pa_status + '%'
		AND TASK_NAME like @pa_fortask + '%'
		ORDER BY TASK_ID
	END
	ELSE
	BEGIN
		SELECT DISTINCT TASK_NAME FROM FILETASK WHERE TASK_START_DT LIKE @pa_fordate + '%' 
		ORDER BY TASK_NAME
	END
END

GO
