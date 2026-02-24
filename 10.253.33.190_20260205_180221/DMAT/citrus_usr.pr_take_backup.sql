-- Object: PROCEDURE citrus_usr.pr_take_backup
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create   procedure pr_take_backup
(@pa_table varchar (50),@pa_column_name varchar (50), @pa_slipno varchar (1000)
)
as 
--exec pr_take_backup 'dptd_mak','dptd_slip_no' ,'NP1000012312,AT1000035942,AT1000033393,AT1000036526'

begin 

set @pa_slipno = ''''+replace(@pa_slipno,',',''',''')+''''

declare @l_temp varchar (1000)
set @l_temp = 'select * into ['+ @pa_table+'_bak'+replace(convert(varchar(20),getdate(),109),'/','')
+'] from ' + @pa_table + ' where '+@pa_column_name+' in (' + @pa_slipno+')'
print @l_temp
exec(@l_temp)
end

GO
