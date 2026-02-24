-- Object: PROCEDURE citrus_usr.PR_RPT_REVENUESHAREGEN_bak22122011
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_RPT_REVENUESHAREGEN 'MAY  1 2010','may 31 2010',3,'CDSL','R',''
create PROCEDURE [citrus_usr].[PR_RPT_REVENUESHAREGEN_bak22122011]
(
 @PA_BILL_STDT DATETIME,
 @PA_BILL_ENDDT DATETIME,
 @PA_DPMID NUMERIC,
 @PA_EXCHANGE_CD VARCHAR(4),
 @PA_TYPE CHAR(1),
 @PA_OUT VARCHAR(1000) OUTPUT
)
AS

BEGIN
DECLARE @PA_GLCODE VARCHAR(20)
,@PA_GLCODEVAL VARCHAR(20)

 
insert into commition_branchwise_dtls(amount ,account_COde )
exec PR_RPT_EMPSUBWSREV_29122010 @PA_DPMID,'BR',@PA_TYPE,@PA_BILL_STDT,@PA_BILL_ENDDT,''


select @PA_GLCODE = BITRM_BIT_LOCATION from BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='REVSHARE_GL_ACCNO_ST'
select @PA_GLCODEVAL = BITRM_VALUES from BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='REVSHARE_GL_ACCNO_ST'
SELECT * FROM commition_branchwise_dtls --WHERE ISNULL(ACCOUNT_ID,'') <> ''  
--BEGIN TRAN

delete from commition_branchwise_dtls where from_dt>=@PA_BILL_STDT and to_dt<=@PA_BILL_ENDDT


UPDATE commition_branchwise_dtls
set from_dt = @PA_BILL_STDT
,to_dt = @PA_BILL_ENDDT
,account_id = finA_ACC_CODE
FROM commition_branchwise_dtls,fin_Account_mstr,ENTITY_MSTR 
WHERE FINA_BRANCH_ID = ENTM_ID 
AND ENTM_SHORT_NAME = account_COde
AND from_dt IS NULL
AND to_dt IS NULL
--
--SELECT 609.960+70.040
DELETE FROM commition_branchwise_dtls WHERE ISNULL(ACCOUNT_ID,'') = ''  
--COMMIT
--SELECT SUM(CHAM_CHARGE_VALUE) FROM CHARGE_MSTR WHERE CHAM_CHARGE_TYPE = 'AMT' 
--DROP TABLE #tdsDATA
SELECT from_dt
,to_dt
,AMOUNT*0.103 TDS_AMOUNT
,@PA_GLCODE account_COde
,@PA_GLCODEVAL account_id INTO #tdsDATA FROM commition_branchwise_dtls
WHERE from_dt= @PA_BILL_STDT AND to_dt= @PA_BILL_ENDDT


--BEGIN TRAN
UPDATE  commition_branchwise_dtls SET AMOUNT = AMOUNT - AMOUNT*0.103 
WHERE from_dt= @PA_BILL_STDT AND to_dt= @PA_BILL_ENDDT 
--COMMIT

INSERT INTO commition_branchwise_dtls
SELECT * FROM #tdsDATA 

SELECT CONVERT(VARCHAR(11),FROM_DT,103) FROM_DT,CONVERT(VARCHAR(11),TO_DT,103) TO_DT,amount,account_COde
,account_id,'Revenue Sharing' Narration FROM commition_branchwise_dtls 
WHERE from_dt= @PA_BILL_STDT AND to_dt= @PA_BILL_ENDDT
ORDER BY ACCOUNT_ID



END

GO
