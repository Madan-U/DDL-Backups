-- Object: PROCEDURE dbo.spUpdateClient
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create procedure spUpdateClient
(
	@pa_id numeric,
	@pa_name varchar(100),
	@pa_dob datetime
)
as begin
	update client_master set
	name = @pa_name,
	dob = @pa_dob
	where id = @pa_id
end

GO
