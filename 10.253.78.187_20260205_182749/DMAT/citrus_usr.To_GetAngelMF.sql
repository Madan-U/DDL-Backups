-- Object: FUNCTION citrus_usr.To_GetAngelMF
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[To_GetAngelMF](@pa_boid varchar(20))
returns  varchar(20)
as
begin 
declare @pa_val varchar(20)
select distinct @pa_val= isnull(client_code,'') from tmp_classMF
--from [dbo].[VW_CLIENT_DETAILS]   where templatecode='MF' and 
where   client_code=@pa_boid
return @pa_val
end

GO
