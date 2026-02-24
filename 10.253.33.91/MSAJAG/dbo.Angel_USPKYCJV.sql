-- Object: PROCEDURE dbo.Angel_USPKYCJV
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_USPKYCJV      
as       
set nocount on      
set transaction isolation level read uncommitted      
declare @str as varchar(500),@stdt as varchar(500)      
set @stdt = convert(varchar,getdate()-1,112)      
--set @str= 'V2_OFFLINE_CLIENTMASTER ''BROKER'',''BROKER'','''+@stdt+''','''+@stdt+''',''I'','''','''',''All'',''All'''      
set @str= 'V2_OFFLINE_CLIENTMASTER_Optimised ''BROKER'',''BROKER'','''+@stdt+''','''+@stdt+''',''I'','''','''',''All'',''All'''      

-- print @str       
      
truncate table Angel_kycJV      
-- exec(@str)      
insert into Angel_kycJV exec(@str)      
set nocount off

GO
