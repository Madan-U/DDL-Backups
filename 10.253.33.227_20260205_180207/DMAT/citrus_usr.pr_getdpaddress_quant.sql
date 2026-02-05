-- Object: PROCEDURE citrus_usr.pr_getdpaddress_quant
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create PROC [citrus_usr].[pr_getdpaddress_quant]
@pa_dpid varchar(8)
AS
BEGIN

	SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' 
    + REPLACE(REPLACE(citrus_usr.[fn_addr_value_complvl](dpm_id,'PER_ADR1'),'|*~|','|'),'||','|')
+  'Phone No.  022-40880100 , Fax No.  022-40880250' + '|' +' E-mail : dphelp@quantcapital.co.in' + '|' 
+'|' 
	FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1

END

GO
