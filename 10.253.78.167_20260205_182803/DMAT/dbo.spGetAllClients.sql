-- Object: PROCEDURE dbo.spGetAllClients
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create procedure spGetAllClients
as begin
	select * from client_master
end

GO
