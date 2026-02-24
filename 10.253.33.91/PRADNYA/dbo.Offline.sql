-- Object: PROCEDURE dbo.Offline
-- Server: 10.253.33.91 | DB: PRADNYA
--------------------------------------------------

CREATE Proc Offline 
(
@flag tinyint
)

as

If @flag = 0 
begin
	Truncate Table Multicompany
	Insert into Multicompany
	Select * from MultiCompany_Backup
end
if @flag = 1
begin
	Truncate Table Multicompany
	Insert into Multicompany
	Select * from V2_offline_MultiCompany
end

GO
