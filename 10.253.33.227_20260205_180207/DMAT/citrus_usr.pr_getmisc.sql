-- Object: PROCEDURE citrus_usr.pr_getmisc
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE proc [citrus_usr].[pr_getmisc](@pa_login_name varchar(100))  
as   
declare @pa_ENTTM_CD varchar(50)  
SELECT @pa_ENTTM_CD =ENTTM_CD FROM LOGIN_NAMES,ENTITY_TYPE_MSTR WHERE ENTTM_CD IN ('BA','BR') AND LOGN_ENTTM_ID =ENTTM_ID AND LOGN_NAME=@pa_login_name  
if (@pa_ENTTM_CD='BR' or @pa_ENTTM_CD='BA')  
begin  
select distinct ProcName,RptName from MiscRptTbl where isnull(br_flag,0) in (1) -- HO level  
end  
else  
begin  
select distinct ProcName,RptName from MiscRptTbl where isnull(br_flag,0) in (0,1) -- Br Level  
end

GO
