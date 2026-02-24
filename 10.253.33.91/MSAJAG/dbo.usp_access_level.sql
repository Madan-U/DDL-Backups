-- Object: PROCEDURE dbo.usp_access_level
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE usp_access_level
(@aceess_to as varchar(50))
as
set nocount on
set transaction isolation level read uncommitted

select Access_level_value,Access_level_name from RISK.DBO.access_level (nolock) where access_level_Code >=
(select access_level_Code from RISK.DBO.access_level (nolock) where access_level_value=@aceess_to )
and access_level_active=1 and access_level_code > 0
order by access_level_Code

GO
