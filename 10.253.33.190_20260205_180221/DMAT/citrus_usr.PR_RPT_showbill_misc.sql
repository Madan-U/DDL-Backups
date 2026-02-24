-- Object: PROCEDURE citrus_usr.PR_RPT_showbill_misc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

-- exec PR_RPT_showbill_misc 'Aug 01 2023', 'Aug 31 2023', 'ho'
CREATE   PROC [citrus_usr].[PR_RPT_showbill_misc](  
@PA_FROM_DT DATETIME, @PA_TO_DT DATETIME     
,@PA_LOGIN_NAME VARCHAR(100)   
)  
AS  
BEGIN 

exec pr_billing_main_cdsl @PA_FROM_DT,@PA_TO_DT,'12033201','Y','Y','S',@PA_LOGIN_NAME

end

GO
