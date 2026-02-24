-- Object: PROCEDURE dbo.spDeleteClient
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create procedure spDeleteClient
(
	@pa_id numeric
)
as begin
	delete from client_master where id = @pa_id
end

GO
