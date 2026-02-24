-- Object: PROCEDURE citrus_usr.pr_Upd_Dp57_desc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_Upd_Dp57_desc] 
as
begin 

update cdshm set CDSHM_TRATM_DESC = case when citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,2,'~') in ('22','21') 
and  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,7,'~')  in ('2103','2201','2202','2203','2204') 
and citrus_usr.fn_getca_desc( citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,36,'~'),'')     <> '' then 
citrus_usr.fn_getca_desc( citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,36,'~'),'')
+  ' '+ isnull (citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,15,'~'),'') +' '
+ case when  CDSHM_TRATM_CD ='2246' then ' Cr Current Balance '  
when  CDSHM_TRATM_CD ='2277' then '  Db Current Balance  '   else '' end     
else CITRUS_USR.fn_dp57_stuff('desc',citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,2,'~'),'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,7,'~'),'','') 
end 
 from cdsl_holding_dtls cdshm with(nolock) 
where CDSHM_CDAS_TRAS_TYPE in ('21','22') --order by cdshm_tras_dt desc
--and cdshm_tras_dt =(select max(cdshm_tras_dt) from cdsl_holding_dtls with(nolock))
and cdshm_tras_dt =(
select top 1 CONVERT(DATETIME, LEFT(column_4,2)+'/'+SUBSTRING(column_4,3,2)+'/20'+RIGHT(column_4,2),103)
		FROM tmp_dp57_o (Nolock) WHERE column_1='H')

end

GO
