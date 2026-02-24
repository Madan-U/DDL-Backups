-- Object: PROCEDURE citrus_usr.pr_import_property
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--BEGIN tran
--exec [pr_import_property] 'ANNUAL_INCOME'
--select max(entp_id) from entity_properties --9316
--select max(entp_id) from entity_properties_mak --9316
--select 1276+9316--10592
--rollback
--commit
CREATE PROCEDURE [citrus_usr].[pr_import_property](@pa_cd VARCHAR(100))
AS
BEGIN
	
declare @c_client_summary1  cursor
,@c_ben_acct_no1  varchar(20)
,@L_ENTP_VALUE VARCHAR(8000)
,@L_CRN_NO numeric 

set @c_client_summary1  = CURSOR fast_forward FOR              
select ENTM_SHORT_NAME     from gstsheet 

open @c_client_summary1

fetch next from @c_client_summary1 into @c_ben_acct_no1 



WHILE @@fetch_status = 0                                                                                                        
BEGIN --#cursor                                                                                                        
--

SET @L_ENTP_VALUE       = ''

SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR(100),'MAHARASHTRA') 
+ '|*~|*|~*' FROM gstsheet ,ENTITY_PROPERTY_MSTR  
WHERE [entm_short_name]  = @c_ben_acct_no1 AND entpm_CD   = @pa_cd

SET @L_CRN_NO = 0 

SELECT @L_CRN_NO = entm_id FROM entity_mstr WHERE entm_short_name =  @c_ben_acct_no1 

PRINT @L_CRN_NO  
PRINT @L_ENTP_VALUE 
EXEC pr_ins_upd_entp '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,'',0,'*|~*','|*~|',''  


fetch next from @c_client_summary1 into @c_ben_acct_no1 


--
end

close @c_client_summary1  
deallocate  @c_client_summary1  

END

GO
