-- Object: PROCEDURE citrus_usr.PR_POASIG_IMPUPD_bak_23032015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create PROCEDURE [citrus_usr].[PR_POASIG_IMPUPD_bak_23032015]
(
@PA_ACTION VARCHAR(10)
)
AS
BEGIN

--IF (@PA_ACTION='NSDL')
--BEGIN 
--UPDATE D3 SET D3.ACCD_DOC_PATH='../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + '.Tiff' FROM 
--DP_ACCT_MSTR D1,tmp_poasign_nsdl D2,ACCOUNT_DOCUMENTS D3
--,ACCOUNT_DOCUMENT_MSTR D4
--WHERE ACCDOCM_CD ='SIGN_BO'
--AND ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
--AND TMPSIGN_SBA_NO=DPAM_SBA_NO AND DPAM_DELETED_IND=1 AND DPAM_STAM_CD='ACTIVE'
--END
--ELSE
--BEGIN 

--if exists (select * from tmp_poasign_nsdl where cli_image is not null)
--begin


--UPDATE D3 SET D3.ACCD_BINARY_IMAGE=d2.CLI_IMAGE  FROM 
--DP_ACCT_MSTR D1,tmp_poasign_nsdl D2,ACCOUNT_DOCUMENTS D3,ACCOUNT_DOCUMENT_MSTR D4
--WHERE --ACCDOCM_CD ='SIGN_BO'
--ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
----AND TMPSIGN_AUTH_NM=DPAM_SBA_NO 
--and LTRIM(RTRIM(SUBSTRING(TMPSIGN_sba_no,2,16))) = dpam_sba_no
--AND DPAM_DELETED_IND=1 AND DPAM_STAM_CD='ACTIVE'

--end 

--else

--begin
--UPDATE D3 SET D3.ACCD_DOC_PATH='../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + '.bmp' FROM 
--DP_ACCT_MSTR D1,tmp_poasign_nsdl D2,ACCOUNT_DOCUMENTS D3,ACCOUNT_DOCUMENT_MSTR D4
--WHERE ACCDOCM_CD ='SIGN_BO'
--AND ACCDOCM_DOC_ID=ACCD_ACCDOCM_DOC_ID AND ACCD_CLISBA_ID=DPAM_ID
--AND TmpSign_Auth_Nm=DPAM_SBA_NO AND DPAM_DELETED_IND=1 AND DPAM_STAM_CD='ACTIVE'
--END

--end 

--IF (@PA_ACTION='NSDL')
--BEGIN 
--insert into account_documents
--(ACCD_CLISBA_ID
--,ACCD_ACCT_NO
--,ACCD_ACCT_TYPE
--,ACCD_ACCDOCM_DOC_ID
--,ACCD_VALID_YN
--,ACCD_REMARKS
--,ACCD_DOC_PATH
--,ACCD_CREATED_BY
--,ACCD_CREATED_DT
--,ACCD_LST_UPD_BY
--,ACCD_LST_UPD_DT
--,ACCD_DELETED_IND)
--select distinct dpam_id
--,dpam_acct_no 
--,'D'
--,accdocm_doc_id
--,1
--,'BY BULK UPDATE'
--,'../CCRSDOCUMENTS/' + DPAM_SBA_NO+ '.Tiff'
--,'MIG'
--,getdate()
--,'MIG'
--,getdate()
--,1
--from dp_acct_mstr , tmp_poasign_nsdl, ACCOUNT_DOCUMENT_MSTR
--where  dpam_sba_no = TMPSIGN_SBA_NO
--and  ACCDOCM_CD ='SIGN_BO'
--and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
--end 
--else 
--begin


--if exists (select * from tmp_poasign_nsdl where cli_image is not null)
--	begin 
--print 'jjj'
--    insert into account_documents
--	(ACCD_CLISBA_ID
--	,ACCD_ACCT_NO
--	,ACCD_ACCT_TYPE
--	,ACCD_ACCDOCM_DOC_ID
--	,ACCD_VALID_YN
--	,ACCD_REMARKS
--	,ACCD_DOC_PATH
--	,ACCD_CREATED_BY
--	,ACCD_CREATED_DT
--	,ACCD_LST_UPD_BY
--	,ACCD_LST_UPD_DT
--	,ACCD_DELETED_IND
--    ,ACCD_BINARY_IMAGE)
--	select distinct dpam_id
--	,dpam_acct_no 
--	,'D'
--	,accdocm_doc_id
--	,1
--	,'BY BULK UPDATE'
--	,''
--	,'MIG'
--	,getdate()
--	,'MIG'
--	,getdate()
--	,1
--    ,cli_image
--	from dp_acct_mstr , tmp_poasign_nsdl, ACCOUNT_DOCUMENT_MSTR
--	where  dpam_sba_no = substring(TMPSIGN_sba_no,2,16) -- TMPSIGN_AUTH_NM
--	and  ACCDOCM_CD ='SIGN_BO'
--	and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents 
--    where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )

--	end 
--	else
--	begin
--	insert into account_documents
--	(ACCD_CLISBA_ID
--	,ACCD_ACCT_NO
--	,ACCD_ACCT_TYPE
--	,ACCD_ACCDOCM_DOC_ID
--	,ACCD_VALID_YN
--	,ACCD_REMARKS
--	,ACCD_DOC_PATH
--	,ACCD_CREATED_BY
--	,ACCD_CREATED_DT
--	,ACCD_LST_UPD_BY
--	,ACCD_LST_UPD_DT
--	,ACCD_DELETED_IND)
--	select distinct dpam_id
--	,dpam_acct_no 
--	,'D'
--	,accdocm_doc_id
--	,1
--	,'BY BULK UPDATE'
--	,'../CCRSDOCUMENTS/' + TMPSIGN_SBA_NO + '.bmp'
--	,'MIG'
--	,getdate()
--	,'MIG'
--	,getdate()
--	,1
--	from dp_acct_mstr , tmp_poasign_nsdl, ACCOUNT_DOCUMENT_MSTR
--	where  dpam_sba_no = TMPSIGN_AUTH_NM
--	and  ACCDOCM_CD ='SIGN_BO'
--	and  not exists(select ACCD_ACCDOCM_DOC_ID from account_documents where accd_clisba_id = dpam_id and ACCD_ACCDOCM_DOC_ID = ACCDOCM_DOC_ID )
--end 
--end

if not exists (select * from mosl_bulk_binary_poa,tmp_poasign_nsdl where imagepath=TMPSIGN_SBA_NO) 
begin

select identity(numeric,1,1) id, TMPSIGN_SBA_NO,cli_image into #tmp from tmp_poasign_nsdl where TMPSIGN_SBA_NO not in (select imagepath from mosl_bulk_binary_poa)

insert into mosl_bulk_binary_poa
select id,TMPSIGN_SBA_NO,cli_image from #tmp where TMPSIGN_SBA_NO not in (select imagepath from mosl_bulk_binary_poa)
end
else
begin

update m set imagepathbinary=cli_image from mosl_bulk_binary_poa m ,tmp_poasign_nsdl where imagepath=TMPSIGN_SBA_NO
end

END

GO
