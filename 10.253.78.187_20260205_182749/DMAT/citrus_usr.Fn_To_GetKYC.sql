-- Object: FUNCTION citrus_usr.Fn_To_GetKYC
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[Fn_To_GetKYC]  
(  
@pa_crn_no int  
,@pa_sba_no varchar(16)  
,@pa_from_dt varchar(100)  
,@pa_to_dt varchar(100)  
,@pa_cd varchar(20)  
)  
returns VARCHAR(50)   
as   
begin  
 DECLARE @l_accp_value   VARCHAR(50)        
  
select @l_accp_value= isnull(ca_newvalue,'') from MOSL_EDP_Client_modification where convert(datetime,ca_authdt,103)   
between   CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00'   
AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+ ' 23:59:59'   
and left(ca_cmcd,16)=@pa_sba_no  
and ca_field=@pa_cd  
  
 RETURN ISNULL(CONVERT(VARCHAR(50), @l_accp_value),'')   
end

GO
