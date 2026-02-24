-- Object: VIEW citrus_usr.Vw_Dp_form_no
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE view [citrus_usr].[Vw_Dp_form_no]
as

select dpam_acct_no,DPAM_BBO_CODE from dp_acct_mstr where DPAM_STAM_CD='Active' and DPAM_DELETED_IND=1 
union
select dpam_acct_no,'' DPAM_BBO_CODE from dp_acct_mstr_mak where DPAM_DELETED_IND in (0,9)

GO
