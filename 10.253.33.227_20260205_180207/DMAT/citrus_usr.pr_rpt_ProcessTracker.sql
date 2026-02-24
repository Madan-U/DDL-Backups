-- Object: PROCEDURE citrus_usr.pr_rpt_ProcessTracker
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[pr_rpt_ProcessTracker]
@pa_level int,
@pa_fortask varchar(200),          
@pa_fordate varchar(11),
@pa_todate varchar(11),
@pa_status varchar(15),          
@pa_output varchar(8000) output    
as
begin
CREATE TABLE #TMP_TASK (TASK_NAME VARCHAR(200))
TRUNCATE TABLE #TMP_TASK

	IF @pa_level = 1
	BEGIN
		SELECT TASK_NAME+':'+isnull(uploadfilename,'') TASK_NAME,START_DT = CONVERT(VARCHAR,TASK_START_DT,109),END_DT= CONVERT(VARCHAR,TASK_START_DT,109)
		,STATUS,TASK_FILEDATE = CONVERT(VARCHAR,TASK_FILEDATE,109), TASK_USER=LOGN_NAME ,USERMSG 
		FROM FILETASK 
		WHERE 
		--TASK_START_DT LIKE @pa_fordate + '%'
		TASK_START_DT BETWEEN  @pa_fordate  AND  @pa_todate +' 23:59:59'
		AND STATUS LIKE  @pa_status + '%'
		AND TASK_NAME like @pa_fortask + '%'
		--ORDER BY TASK_ID
		ORDER BY TASK_NAME

	END
	ELSE
	BEGIN		
		INSERT INTO #TMP_TASK SELECT ''
		INSERT INTO #TMP_TASK 
		SELECT DISTINCT TASK_NAME FROM FILETASK WHERE TASK_START_DT LIKE @pa_fordate + '%' 
		
		SELECT TASK_NAME FROM #TMP_TASK ORDER BY TASK_NAME 		
	END
END

GO
