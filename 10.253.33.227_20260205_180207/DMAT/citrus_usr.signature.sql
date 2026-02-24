-- Object: VIEW citrus_usr.signature
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[signature]  
as  
select dpam_sba_no sg_ac_code  
,accd_binary_image sg_sign,case when accd_accdocm_doc_id = '12' then 'B'when accd_accdocm_doc_id = '13' then 'P' else '' end  sg_bpflag  
 from ACCOUNT_DOCUMENTS,dp_acct_mstr (NoLock)
where DPAM_ID=ACCD_CLISBA_ID and ACCD_DELETED_IND=1 and DPAM_DELETED_IND=1

GO
