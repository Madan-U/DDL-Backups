-- Object: PROCEDURE citrus_usr.pr_get_detail_csv
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



create proc [citrus_usr].[pr_get_detail_csv] (@pa_tab varchar(100), @pa_table_name varchar(100))
as
begin 


declare @l_sql varchar(8000)
set @l_sql =''



if @pa_tab ='isinfile'
begin 


truncate table ISIN_MSTR_CONVERTER 

select @l_sql = 'insert into ISIN_MSTR_CONVERTER select * from ' + @pa_table_name 
exec (@l_sql)


end 

if @pa_tab ='ratefile'
begin 


truncate table ISIN_RATE_CONVERTER 

select @l_sql = 'insert into ISIN_RATE_CONVERTER select * from ' + @pa_table_name 
exec (@l_sql)


end 

if @pa_tab ='settlement'
begin 


truncate table cc_clnd_converter 

select @l_sql = 'insert into cc_clnd_converter select * from ' + @pa_table_name 
exec (@l_sql)


end 

if @pa_tab ='ADDRESSCHANGE'
begin 


truncate table cc_clnd_converter 

select @l_sql = 'insert into cc_clnd_converter select * from ' + @pa_table_name 
exec (@l_sql)


end 

if @pa_tab ='BANKDETAILSCHANGE'
begin 


truncate table cc_clnd_converter 

select @l_sql = 'insert into cc_clnd_converter select * from ' + @pa_table_name 
exec (@l_sql)


end 

set @l_sql ='' 
select @l_sql = 'drop table  ' + @pa_table_name 
exec (@l_sql)

end

GO
