-- Object: PROCEDURE dbo.test_auto
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


create proc test_auto
as
begin
 select top 10 * from Region
 select top 10 * from Area
end

GO
