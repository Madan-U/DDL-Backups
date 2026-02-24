-- Object: PROCEDURE citrus_usr.pr_mod_res_upload_bak_16042015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--create table modification_batch_error(val varchar(1000))
--exec pr_mod_res_upload 'd:\BulkInsDbfolder\08DPH1U13481389.00886'
create proc [citrus_usr].[pr_mod_res_upload_bak_16042015](@pa_db_source varchar(8000))
as
begin 

declare @@SSQL varchar(5000)    
  --create table modification_batch_error(val varchar(1000))
   truncate table modification_batch_error
    
  SET @@SSQL = 'BULK INSERT modification_batch_error FROM ''' + @pa_db_source +  ''' WITH    
(    
    
FIELDTERMINATOR=''\n'',    
ROWTERMINATOR = ''\n''      
)'    
    
    
PRINT @@SSQL    
EXEC (@@SSQL)    

select citrus_usr.fn_splitval_by(val,2,'~') boid,citrus_usr.fn_splitval_by(val,3,'~') errormsg from modification_batch_error where left(val,2)='01'
and citrus_usr.fn_splitval_by(val,3,'~')<>''

end

GO
