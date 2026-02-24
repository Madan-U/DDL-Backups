-- Object: PROCEDURE citrus_usr.Pr_rpt_POAMod_batch
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--exec Pr_rpt_POAMod_batch 'Jan 20 2022' , 'Jan 20 2022', 'HO'
 create  proc [citrus_usr].[Pr_rpt_POAMod_batch]
(@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)          
AS          
BEGIN  


SELECT ''''+CLIC_MOD_DPAM_SBA_NO BOID  , CLIC_MOD_ACTION [MODIFICATION ACTION], CONVERT (VARCHAR (11), clic_mod_created_dt,103) [MDOFICATION DATE] ,
  MAX(CLIC_MOD_BATCH_NO)  [BATCH NO]  FROM CLIENT_LIST_MODIFIED
 WHERE CLIC_MOD_ACTION like  'POA%'
--and GETDATE () between  clic_mod_created_dt and clic_mod_created_dt-7
and clic_mod_created_dt >  GETDATE () -7 
GROUP BY CLIC_MOD_DPAM_SBA_NO, CLIC_MOD_ACTION, clic_mod_created_dt
ORDER BY 3 DESC 
end

GO
