-- Object: PROCEDURE citrus_usr.pr_take_backup_prebill
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE    procedure [citrus_usr].[pr_take_backup_prebill]
(@pa_table varchar (50) 
)
as 
 

begin 
 
declare @l_temp varchar (1000)
set @l_temp = 'select * into ['+ @pa_table+'_bak'
+'] from ' + @pa_table
print @l_temp
exec(@l_temp)
end

GO
