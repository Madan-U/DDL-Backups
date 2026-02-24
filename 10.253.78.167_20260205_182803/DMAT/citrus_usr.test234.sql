-- Object: PROCEDURE citrus_usr.test234
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[test234]
(
    @pa_id  VARCHAR(20)                  
	,@pa_action         VARCHAR(100)                  
	,@pa_login_name     VARCHAR(20)                  
	,@pa_cd             VARCHAR(25)                  
	,@pa_desc           VARCHAR(250)                  
	,@pa_rmks           VARCHAR(250)                  
	,@pa_values         VARCHAR(8000)                 
	,@pa_roles          VARCHAR(8000)                
	,@pa_scr_id         NUMERIC                
	,@rowdelimiter      CHAR(10)                  
	,@coldelimiter      CHAR(4)                  
	,@pa_ref_cur        VARCHAR(8000) OUT                  
	) 
as                  
-- exec test234
select  *
          
   from dp_acct_mstr   where dpam_id in(58393,58408,58466)

GO
