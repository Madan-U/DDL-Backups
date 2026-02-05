-- Object: PROCEDURE citrus_usr.pr_getdpaddress_EmailPhone
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[pr_getdpaddress_EmailPhone] '12345678'
CREATE PROC [citrus_usr].[pr_getdpaddress_EmailPhone]
@pa_dpid varchar(8)
AS
BEGIN

--SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' + REPLACE(REPLACE(citrus_usr.fn_addr_value(dpm_id,'PER_ADR1'),'|*~|','|'),'||','|')  + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'mobile1'),''),'|*~|','|'),'||','|')  + '|' + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'OFF_PH1'),''),'|*~|','|'),'||','|')  + '|' + REPLACE(REPLACE(ISNULL(isnull(citrus_usr.fn_conc_value(dpm_id,'EMAIL'),''),''),'|*~|','|'),'||','|')
--FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1

SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' + REPLACE(REPLACE(citrus_usr.fn_addr_value(dpm_id,'PER_ADR1'),'|*~|','|'),'||','|')  + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'mobile1'),''),'|*~|','|'),'||','|')  + '|' + 'Phone No.' + REPLACE(REPLACE(isnull(citrus_usr.fn_conc_value(dpm_id,'OFF_PH1'),''),'|*~|','|'),'||','|')  + '|' + 'Email :' + REPLACE(REPLACE(ISNULL(isnull(citrus_usr.fn_conc_value(dpm_id,'EMAIL'),''),''),'|*~|','|'),'||','|')
FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1


--SELECT isnull(dpm_name,'') + ' [' +  isnull(@pa_dpid,'') + ']' + '|' + REPLACE(REPLACE(citrus_usr.fn_addr_value(dpm_id,'PER_ADR1'),'|*~|','|'),'||','|')  + REPLACE(REPLACE(citrus_usr.fn_conc_value(dpm_id,'mobile1'),'|*~|','|'),'||','|')  + '|' + REPLACE(REPLACE(citrus_usr.fn_conc_value(dpm_id,'OFF_PH1'),'|*~|','|'),'||','|')  
--FROM dp_mstr WHERE dpm_dpid = @pa_dpid and dpm_deleted_ind =1


END

GO
