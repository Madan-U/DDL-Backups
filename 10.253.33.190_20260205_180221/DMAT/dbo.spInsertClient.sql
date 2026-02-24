-- Object: PROCEDURE dbo.spInsertClient
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure spInsertClient
(
	@pa_name varchar(100),
	@pa_dob datetime
)
as begin 
	declare @id numeric
	select @id = max(id) from client_master
	insert into client_master (id,name,dob) values((@id + 1),@pa_name,@pa_dob)
end

GO
