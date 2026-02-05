-- Object: PROCEDURE citrus_usr.Bak_PR_RPT_REVENUESHAREGEN_05012012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[PR_RPT_REVENUESHAREGEN] 'apr  1 2010','apr 30 2010',3,'CDSL','R',''
CREATE PROCEDURE [citrus_usr].[Bak_PR_RPT_REVENUESHAREGEN_05012012]
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

/**********************old logic*************************/
/*
insert into commition_branchwise_dtls(amount ,account_COde )
exec PR_RPT_EMPSUBWSREV @PA_DPMID,'BR',@PA_TYPE,@PA_BILL_STDT,@PA_BILL_ENDDT,''
*/

delete from client_Commission_summary 
where branch_id in (select br_code from ownbranchlist)


create table #client_Commission_summary 
(amc_date datetime
,carry_date datetime
,n_r char(1)
,dpam_sba_no varchar(20)
,dpam_sba_name varchar(100)
,brom_cd varchar(100)
,amc_charge numeric(18,3)
,Commission_paid numeric(18,3)
,branch_id varchar(100)
,Outstanding numeric(18,3)
,created_by varchar(100)
,created_dt datetime
,lst_upd_by varchar(100)
,lst_upd_dt datetime
,deleted_ind smallint
)

declare @ssql varchar(8000),
@finid int
select @PA_GLCODE = BITRM_BIT_LOCATION from BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='REVSHARE_GL_ACCNO_ST'
select @PA_GLCODEVAL = BITRM_VALUES from BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='REVSHARE_GL_ACCNO_ST'


insert into #client_Commission_summary(branch_id,dpam_sba_no,dpam_sba_name,amc_charge,Commission_paid,amc_date,brom_cd)
exec [PR_RPT_EMPSUBWSREV_SUMMARY_For_NEW_LOGIC] @PA_DPMID,'BR',@PA_TYPE,@PA_BILL_STDT,@PA_BILL_ENDDT,'',''



update #client_Commission_summary set n_r = @PA_TYPE

delete from client_Commission_summary 
where branch_id in (select br_code from ownbranchlist)

  


delete from #client_Commission_summary 
where branch_id in (select br_code from ownbranchlist)


insert into client_Commission_summary
select * from #client_Commission_summary a
where not exists(select dpam_sba_no , n_r 
				 from client_Commission_summary b 
				 where a.dpam_sba_no = b.dpam_sba_no and a.n_r = b.n_r
				 AND A.Commission_paid  = B.Commission_paid
				 )

select @finid = fin_id from financial_yr_mstr where @PA_BILL_STDT  between  FIN_START_DT and FIN_END_DT and fin_deleted_ind = 1

set @ssql=
'UPDATE a
SET Outstanding = isnull((SELECT SUM(LDG_AMOUNT) 
				   FROM LEDGER'+ convert(varchar,@finid ) + ' , DP_ACCT_MSTR dpam
				   WHERE ldg_account_type = ''P'' 
				   and ldg_account_id = dpam_id 
				   and ldg_deleted_ind= 1 and ldg_voucher_dt <= ''' + convert(varchar(11),@PA_BILL_ENDDT,109)
				  + ''' and dpam.dpam_sba_no  = a.dpam_sba_no),''0'') 
from client_Commission_summary  a
where carry_date is null
and 0 < (select count(1)  FROM LEDGER'+ convert(varchar,@finid ) + ' , DP_ACCT_MSTR dpam
				   WHERE ldg_account_type = ''P'' 
				   and ldg_account_id = dpam_id 
				   and ldg_deleted_ind= 1 and ldg_voucher_dt <= ''' + convert(varchar(11),@PA_BILL_ENDDT,109)
				  + ''' and dpam.dpam_sba_no  = a.dpam_sba_no)'
print @ssql
exec(@ssql)

--select * from #client_Commission_summary where dpam_sba_no like '%48876'
--return


--update client_Commission_summary set Commission_paid = 0 where Outstanding < 0 and carry_date is null
update client_Commission_summary set carry_date = @PA_BILL_STDT where Outstanding >= 0 and carry_date is null



-- CONVERT(VARCHAR(11),FROM_DT,103) FROM_DT,CONVERT(VARCHAR(11),TO_DT,103) TO_DT,amount,account_id account_COde
--,account_id,'Revenue Sharing' Narration
select CONVERT(VARCHAR(11),@PA_BILL_STDT,103) FROM_DT,CONVERT(VARCHAR(11),@PA_BILL_ENDDT,103) TO_DT
,sum(Commission_paid)  --- Commission_paid*0.100 
as amount,finA_ACC_CODE account_code,finA_ACC_CODE account_id
,'Revenue Sharing' Narration  from client_Commission_summary ,fin_Account_mstr,ENTITY_MSTR 
WHERE FINA_BRANCH_ID = ENTM_ID 
AND ENTM_SHORT_NAME = branch_id
and carry_date between @PA_BILL_STDT and @PA_BILL_ENDDT and  Commission_paid  <> 0 
and n_r  = @PA_TYPE AND FINA_DELETED_IND=1
group by finA_ACC_CODE
union all
SELECT CONVERT(VARCHAR(11),@PA_BILL_STDT,103) from_dt
,CONVERT(VARCHAR(11),@PA_BILL_ENDDT,103) to_dt
,sum(Commission_paid*0.100) amount --TDS_AMOUNT
,@PA_GLCODE account_COde
,@PA_GLCODE account_id
,'Revenue Sharing TDS' Narration
FROM client_Commission_summary,fin_Account_mstr,ENTITY_MSTR 
where FINA_BRANCH_ID = ENTM_ID 
AND ENTM_SHORT_NAME = branch_id
and  carry_date between @PA_BILL_STDT and @PA_BILL_ENDDT and  Commission_paid  <> 0 
and n_r= @PA_TYPE AND FINA_DELETED_IND=1
group by finA_ACC_CODE
order by account_id






/*

select @PA_GLCODE = BITRM_BIT_LOCATION from BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='REVSHARE_GL_ACCNO_ST'
select @PA_GLCODEVAL = BITRM_VALUES from BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='REVSHARE_GL_ACCNO_ST'
--SELECT * FROM commition_branchwise_dtls WHERE ISNULL(ACCOUNT_ID,'') <> ''  
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
,@PA_GLCODE account_id INTO #tdsDATA 
FROM commition_branchwise_dtls
WHERE from_dt= @PA_BILL_STDT AND to_dt= @PA_BILL_ENDDT

--BEGIN TRAN
UPDATE  commition_branchwise_dtls SET AMOUNT = AMOUNT - AMOUNT*0.103 
WHERE from_dt= @PA_BILL_STDT AND to_dt= @PA_BILL_ENDDT 
--COMMIT

INSERT INTO commition_branchwise_dtls
SELECT * FROM #tdsDATA 

SELECT CONVERT(VARCHAR(11),FROM_DT,103) FROM_DT,CONVERT(VARCHAR(11),TO_DT,103) TO_DT,amount,account_id account_COde
,account_id,'Revenue Sharing' Narration FROM commition_branchwise_dtls --, fin_account_mstr 
WHERE from_dt= @PA_BILL_STDT AND to_dt= @PA_BILL_ENDDT --and account_id = FINA_ACC_CODE
ORDER BY ACCOUNT_ID
*/


END

GO
