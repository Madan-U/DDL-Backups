-- Object: PROCEDURE citrus_usr.pr_mod_res_upload
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec pr_mod_res_upload 'D:\BULKINSDBFOLDER\CLIENTMODFILEUPLOAD\08DPH1U13481389.00886'  
CREATE proc [citrus_usr].[pr_mod_res_upload](@pa_db_source varchar(8000))  
as  
begin   
  
declare @@SSQL varchar(5000),@url varchar(200), @batchNo varchar(15), @noOfRecordToUpdate varchar(15)
  --create table modification_batch_error(val varchar(1000))  
   truncate table modification_batch_error  
      
  SET @@SSQL = 'BULK INSERT modification_batch_error FROM ''' + @pa_db_source +  ''' WITH      
(      
      
FIELDTERMINATOR=''\n'',      
ROWTERMINATOR = ''\n''        
)'      
      
      
PRINT @@SSQL      
EXEC (@@SSQL)      
  
	select citrus_usr.fn_splitval_by(val,2,'~') boid,
	case when citrus_usr.fn_splitval_by(val,3,'~') <> '' then citrus_usr.fn_splitval_by(val,3,'~')
	else 'Successfully Uploaded' end errormsg 
	from modification_batch_error where (left(val,2)='01'  
	and citrus_usr.fn_splitval_by(val,3,'~')<>'') 
	or (left(val,2)='01' and citrus_usr.fn_splitval_by(val,3,'~')='') 

	 select citrus_usr.fn_splitval_by(val,2,'~') boid into #tempModTable
	 from modification_batch_error
	 where left(val,2)='01' 
	 and citrus_usr.fn_splitval_by(val,3,'~')<>''

	 select @url = RIGHT(@pa_db_source,5)
	 set @batchNo =  substring(@url,PATINDEX('%[^0 ]%',@url + ' '), len(@url))

	 select @noOfRecordToUpdate = count(*) 
	 from modification_batch_error
	 where left(val,2)='01' 
	 and citrus_usr.fn_splitval_by(val,3,'~')=''

	 update bat set BATCHC_RECORDS = @noOfRecordToUpdate,BATCHC_STATUS = 'C' 
	 from BATCHNO_CDSL_MSTR bat
	 where BATCHC_NO = @batchno
	 and BATCHC_TRANS_TYPE = 'ACCOUNT REGISTRATION'

	update clt_mod set clic_mod_batch_no = null 
	from client_list_modified clt_mod,#tempModTable
	where clic_mod_dpam_sba_no = boid 
	and clic_mod_batch_no = @batchno








  
end

GO
