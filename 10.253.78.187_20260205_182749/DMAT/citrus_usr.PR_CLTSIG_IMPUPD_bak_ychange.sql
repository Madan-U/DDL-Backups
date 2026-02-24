-- Object: PROCEDURE citrus_usr.PR_CLTSIG_IMPUPD_bak_ychange
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[PR_CLTSIG_IMPUPD_bak_ychange]
(
@PA_ACTION VARCHAR(10)
)
AS
BEGIN
 
Declare @@l_accd_id                  numeric 
IF (@PA_ACTION='NSDL')
BEGIN 
UPDATE D3 SET D3.ACCD_DOC_PATH='../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + '.Tiff' FROM 
DP_ACCT_MSTR D1,TMP_CLTSIGN_NSDL D2,ACCOUNT_DOCUMENTS D3
,ACCOUNT_DOCUMENT_MSTR D4
WHERE ACCDOCM_CD ='SIGN_BO'
AND ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
AND TMPSIGN_SBA_NO=DPAM_SBA_NO AND DPAM_DELETED_IND=1 AND DPAM_STAM_CD='ACTIVE'
and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
END
ELSE
BEGIN 

if exists (select * from tmp_cltsign_nsdl where cli_image is not null)
begin

if exists (select * from tmp_cltsign_nsdl where TMPSIGN_AUTH_NM<>TMPSIGN_SBA_NO)
begin
UPDATE D3 SET D3.ACCD_BINARY_IMAGE=d2.CLI_IMAGE ,D3.ACCD_DOC_PATH='../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + tmpsign_ref_no FROM 
DP_ACCT_MSTR D1,TMP_CLTSIGN_NSDL D2,ACCOUNT_DOCUMENTS D3,ACCOUNT_DOCUMENT_MSTR D4
WHERE --ACCDOCM_CD ='SIGN_BO'
ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
--AND TMPSIGN_AUTH_NM=DPAM_SBA_NO 
and LTRIM(RTRIM(SUBSTRING(TMPSIGN_sba_no,2,16))) = dpam_sba_no
and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
AND DPAM_DELETED_IND=1 AND DPAM_STAM_CD='ACTIVE'
END
if exists (select * from tmp_cltsign_nsdl where TMPSIGN_AUTH_NM=TMPSIGN_SBA_NO)
begin
UPDATE D3 SET D3.ACCD_BINARY_IMAGE=d2.CLI_IMAGE , D3.ACCD_DOC_PATH='../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + tmpsign_ref_no  FROM 
DP_ACCT_MSTR_mak D1,TMP_CLTSIGN_NSDL D2,ACCD_MAK D3,ACCOUNT_DOCUMENT_MSTR D4,API_CLIENT_MASTER_SYNERGY_dp
WHERE --ACCDOCM_CD ='SIGN_BO'
ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
--AND TMPSIGN_AUTH_NM=DPAM_SBA_NO 
and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
and TMPSIGN_sba_no = kIT_NO AND DPAM_ACCT_NO=DP_INTERNAL_REF
AND DPAM_DELETED_IND=0 AND DPAM_STAM_CD='ACTIVE'
end

end 

else

begin
UPDATE D3 SET D3.ACCD_DOC_PATH='../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + tmpsign_ref_no FROM 
DP_ACCT_MSTR D1,TMP_CLTSIGN_NSDL D2,ACCOUNT_DOCUMENTS D3,ACCOUNT_DOCUMENT_MSTR D4
WHERE ACCDOCM_CD ='SIGN_BO'
AND ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
AND TmpSign_Auth_Nm=DPAM_SBA_NO AND DPAM_DELETED_IND=1 AND DPAM_STAM_CD='ACTIVE'
END

end 

IF (@PA_ACTION='NSDL')
BEGIN 
insert into account_documents
(ACCD_CLISBA_ID
,ACCD_ACCT_NO
,ACCD_ACCT_TYPE
,ACCD_ACCDOCM_DOC_ID
,ACCD_VALID_YN
,ACCD_REMARKS
,ACCD_DOC_PATH
,ACCD_CREATED_BY
,ACCD_CREATED_DT
,ACCD_LST_UPD_BY
,ACCD_LST_UPD_DT
,ACCD_DELETED_IND)
select distinct dpam_id
,dpam_acct_no 
,'D'
,accdocm_doc_id
,1
,'BY BULK UPDATE'
,'../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO+ '.Tiff'
,'MIG'
,getdate()
,'MIG'
,getdate()
,1
from dp_acct_mstr , TMP_CLTSIGN_NSDL, ACCOUNT_DOCUMENT_MSTR
where  dpam_sba_no = TMPSIGN_SBA_NO
and  ACCDOCM_CD ='SIGN_BO'
and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
end 
else 
begin


if exists (select * from tmp_cltsign_nsdl where cli_image is not null)
	begin 
	if exists (select * from tmp_cltsign_nsdl where TMPSIGN_AUTH_NM<>TMPSIGN_SBA_NO)
    begin
    insert into account_documents
	(ACCD_CLISBA_ID
	,ACCD_ACCT_NO
	,ACCD_ACCT_TYPE
	,ACCD_ACCDOCM_DOC_ID
	,ACCD_VALID_YN
	,ACCD_REMARKS
	,ACCD_DOC_PATH
	,ACCD_CREATED_BY
	,ACCD_CREATED_DT
	,ACCD_LST_UPD_BY
	,ACCD_LST_UPD_DT
	,ACCD_DELETED_IND
    ,ACCD_BINARY_IMAGE)
	select distinct dpam_id
	,dpam_acct_no 
	,'D'
	,accdocm_doc_id
	,1
	,'BY BULK UPDATE'
	,'../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + tmpsign_ref_no -- ''
	,'MIG'
	,getdate()
	,'MIG'
	,getdate()
	,1
    ,cli_image
	from dp_acct_mstr , TMP_CLTSIGN_NSDL, ACCOUNT_DOCUMENT_MSTR
	where  dpam_sba_no = substring(TMPSIGN_sba_no,2,16) -- TMPSIGN_AUTH_NM
	and  ACCDOCM_CD ='SIGN_BO'
	and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents 
    where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
    end
    
    if exists (select * from tmp_cltsign_nsdl where TMPSIGN_AUTH_NM=TMPSIGN_SBA_NO) --- numeric check

    begin
				SELECT @@l_accd_id = ISNULL(MAX(accd_id),0) + 1
                FROM   accd_mak      WITH (NOLOCK)
                
                SELECT IDENTITY(INT,1,1) ID,TMPSIGN_sba_no SBA_NO  INTO #TMP from dp_acct_mstr_mak , TMP_CLTSIGN_NSDL, 
                ACCOUNT_DOCUMENT_MSTR,API_CLIENT_MASTER_SYNERGY_dp,CLIENT_CTGRY_MSTR
		where  dpam_acct_no = DP_INTERNAL_REF and Kit_no=TMPSIGN_sba_no -- TMPSIGN_AUTH_NM
		and  ACCDOCM_CD ='SIGN_BO'  and CLICM_cD =DPAM_CLICM_CD  and ACCDOCM_CLICM_ID=clicm_id
		and  not exists(select ACCD_ACCDOCM_DOC_ID from accd_mak 
		where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID and accd_deleted_ind=0 )

	   insert into accd_mak
		( 
          ACCD_ID
		 ,ACCD_CLISBA_ID
		,ACCD_ACCT_NO
		,ACCD_ACCT_TYPE
		,ACCD_ACCDOCM_DOC_ID
		,ACCD_VALID_YN
		,ACCD_REMARKS
		,ACCD_DOC_PATH
		,ACCD_CREATED_BY
		,ACCD_CREATED_DT
		,ACCD_LST_UPD_BY
		,ACCD_LST_UPD_DT
		,ACCD_DELETED_IND
		,ACCD_BINARY_IMAGE)
		select distinct @@l_accd_id +ID
		,dpam_id
		,dpam_acct_no 
		,'D'
		,accdocm_doc_id
		,1
		,'BY BULK UPDATE'
		,'../CCRSDOCUMENTS/' + TMPSIGN_sba_no+ tmpsign_ref_no -- ''
		,'MIG'
		,getdate()
		,'MIG'
		,getdate()
		,0
		,cli_image
		from dp_acct_mstr_mak , TMP_CLTSIGN_NSDL, ACCOUNT_DOCUMENT_MSTR,API_CLIENT_MASTER_SYNERGY_dp,#TMP
		where  dpam_acct_no = DP_INTERNAL_REF and Kit_no=TMPSIGN_sba_no -- TMPSIGN_AUTH_NM
		AND SBA_NO=TMPSIGN_sba_no
		and  ACCDOCM_CD ='SIGN_BO'
		and  not exists(select ACCD_ACCDOCM_DOC_ID from accd_mak 
		where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID and accd_deleted_ind=0 )
    end
	end 
	else
	begin
	insert into account_documents
	(ACCD_CLISBA_ID
	,ACCD_ACCT_NO
	,ACCD_ACCT_TYPE
	,ACCD_ACCDOCM_DOC_ID
	,ACCD_VALID_YN
	,ACCD_REMARKS
	,ACCD_DOC_PATH
	,ACCD_CREATED_BY
	,ACCD_CREATED_DT
	,ACCD_LST_UPD_BY
	,ACCD_LST_UPD_DT
	,ACCD_DELETED_IND)
	select distinct dpam_id
	,dpam_acct_no 
	,'D'
	,accdocm_doc_id
	,1
	,'BY BULK UPDATE'
	,'../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + tmpsign_ref_no
	,'MIG'
	,getdate()
	,'MIG'
	,getdate()
	,1
	from dp_acct_mstr , TMP_CLTSIGN_NSDL, ACCOUNT_DOCUMENT_MSTR
	where  dpam_sba_no = TMPSIGN_AUTH_NM
	and  ACCDOCM_CD ='SIGN_BO'
	and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
end 
end

-- for signature modification 

update A set signame = RIGHT(TMPSIGN_SBA_NO, LEN(TMPSIGN_SBA_NO) - 17) +tmpsign_ref_no 
 from OLD_SIGN_NAME A, TMP_CLTSIGN_NSDL where boid = replace (left (TMPSIGN_SBA_NO,17), 'B', '' )

insert into OLD_SIGN_NAME 
SELECT '', replace (left (TMPSIGN_SBA_NO,17), 'B', '' ), RIGHT(TMPSIGN_SBA_NO, LEN(TMPSIGN_SBA_NO) - 17)+tmpsign_ref_no
 FROM TMP_CLTSIGN_NSDL
 where not exists (select boid  from OLD_SIGN_NAME where boid = replace (left (TMPSIGN_SBA_NO,17), 'B', '' ))

-- for signature modification 
END

GO
