-- Object: PROCEDURE dbo.usp_insert_awsccedata
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc usp_insert_awsccedata
as 
begin
	truncate table TBL_FINAL_AUDIT_DATA_CCE_AWS
	insert into TBL_FINAL_AUDIT_DATA_CCE_AWS
	select * from [196.1.115.197].msajag.dbo.TBL_FINAL_AUDIT_DATA_CCE_AWS with (nolock)
end

GO
