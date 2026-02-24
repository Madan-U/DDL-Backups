-- Object: PROCEDURE citrus_usr.pr_getdpaddress_forpdf
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create  procedure  [citrus_usr].[pr_getdpaddress_forpdf]  
@pa_dpid varchar(8)  
AS  
BEGIN  
  
-- SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' + REPLACE(REPLACE(citrus_usr.fn_addr_value(dpm_id,'PER_ADR1'),'|*~|','|'),'||','|') +  'Phone No.  022-40880100 , Fax No.  022-40880250' + '|' +' E-mail : dphelp@quantcapital.co.in' + '|' 
--+'|'   
-- FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1  
--SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' + REPLACE(REPLACE(citrus_usr.fn_addr_value(dpm_id,'PER_ADR1'),'|*~|','|'),'||','|')  + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'mobile1'),''),'|*~|','|'),'||','|')  + '|' + 'Phone No.' + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'OFF_PH1'),''),'|*~|','|'),'||','|')  + '|' + 'Fax:' + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'FAX1'),''),'|*~|','|'),'||','|')  + '|' + 'Email :' + REPLACE(REPLACE(ISNULL(isnull(citrus_usr.fn_conc_value(dpm_id,'EMAIL'),''),''),'|*~|','|'),'||','|')
--FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1

SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' + REPLACE(REPLACE(citrus_usr.fn_addr_value(dpm_id,'PER_ADR1'),'|*~|',' '),'||','  ')  + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'mobile1'),''),'|*~|','|'),'||','|')  + ' Phone No.' + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'OFF_PH1'),''),'|*~|','|'),'||','|') + ' Fax:' + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'FAX1'),''),'|*~|','|'),'||','|')  + ' Email :' + REPLACE(REPLACE(ISNULL(isnull(citrus_usr.fn_conc_value(dpm_id,'EMAIL'),''),''),'|*~|','|'),'||','|')
FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1

  
END

GO
