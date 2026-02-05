-- Object: PROCEDURE citrus_usr.PR_REMOVE_DUPLICATE_DEF_BANK_bak_13012021
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create  PROC [citrus_usr].[PR_REMOVE_DUPLICATE_DEF_BANK_bak_13012021]
AS
BEGIN 

select dpam_id , dpam_sba_no INTO #TEMPDATA from client_bank_accts ,dp_acct_mstr
where CLIBA_DELETED_IND = 1 AND CLIBA_FLG IN (1,3) and CLIBA_CLISBA_ID = DPAM_ID 
and DPAM_SBA_NO in (select dp_id from [172.31.16.57].crmdb_a.dbo.CITRUS_DP_BANK_ACCTS) 
group by dpam_sba_no ,dpam_id 
HAVING COUNT(1)>1


--SELECT *  FROM  CLIENT_BANK_ACCTS CLIBA , DP_ACCT_MSTR  WHERE CLIBA_CLISBA_ID = DPAM_ID 
--AND CLIBA_CLISBA_ID IN (SELECT dpam_id FROM #TEMPDATA )
--AND CLIBA_FLG =  1 
--AND NOT EXISTS (SELECT * FROM [172.31.16.57].crmdb_a.dbo.CITRUS_DP_BANK_ACCTS 
--WHERE DP_ID = DPAM_SBA_NO AND DEF_FLG= 1 AND BANK_ACC_NO = CLIBA_AC_NO)


UPDATE CLIBA SET CLIBA_FLG = 0 FROM  CLIENT_BANK_ACCTS CLIBA , DP_ACCT_MSTR  WHERE CLIBA_CLISBA_ID = DPAM_ID 
AND CLIBA_CLISBA_ID IN (SELECT dpam_id FROM #TEMPDATA )
AND CLIBA_FLG =  1 
AND NOT EXISTS (SELECT * FROM [172.31.16.57].crmdb_a.dbo.CITRUS_DP_BANK_ACCTS 
WHERE DP_ID = DPAM_SBA_NO AND DEF_FLG= 1 AND BANK_ACC_NO = CLIBA_AC_NO)


--select dpam_id , dpam_sba_no from client_bank_accts ,dp_acct_mstr
--where CLIBA_DELETED_IND = 1 AND CLIBA_FLG IN (1,3) and CLIBA_CLISBA_ID = DPAM_ID 
--and DPAM_SBA_NO in (select dp_id from [172.31.16.57].crmdb_a.dbo.CITRUS_DP_BANK_ACCTS) 
--group by dpam_sba_no ,dpam_id 
--HAVING COUNT(1)>1

--select * from [172.31.16.57].crmdb_a.dbo.CITRUS_DP_BANK_ACCTS WHERE dp_id IN ('1203320001435035','1203320010212606')


END

GO
