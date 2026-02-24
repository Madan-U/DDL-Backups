-- Object: VIEW citrus_usr.SYNERGY_LEDGER_sachin
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




CREATE  view [citrus_usr].[SYNERGY_LEDGER_sachin]    
    
as    
    
select  case when ldg_account_type ='P' then dpam_sba_no else FINA_ACC_CODE end LD_CLIENTCD    
,LDG_VOUCHER_DT  LD_DT    
,convert(numeric(18,4),LDG_AMOUNT  ) LD_AMOUNT    
,LDG_NARRATION  LD_PARTICULAR    
,LDG_INSTRUMENT_NO  LD_CHEQUENO    
,case when LDG_AMOUNT < 0 then 'D' else 'C' end   LD_DEBITFLAG    
,(CASE WHEN LDG_VOUCHER_TYPE =1 THEN 'P'    
       WHEN LDG_VOUCHER_TYPE =2 THEN 'R'    
    WHEN LDG_VOUCHER_TYPE =3 THEN 'J'    
    WHEN LDG_VOUCHER_TYPE =5 THEN 'B' ELSE '' END) LD_DOCUMENTTYPE    
,LDG_VOUCHER_NO  LD_DOCUMENTNO    
,'' LD_ENTRYNO    
,'' LD_COSTCENTER    
,LDG_CREATED_BY  MKRID    
,LDG_LST_UPD_DT  MKRDT    
,YEAR(ldg_voucher_dt) LD_ACCYEAR    
,LEFT(DPAM_SBA_NO,8) LD_DPID    
,'' LD_COMMONDT    
,'' LD_COMMON    
from LEDGER2     WITH(NOLOCK)
left outer join  dp_acct_mstr  WITH(NOLOCK) on  LDG_ACCOUNT_ID  = dpam_id     
left outer join  FIN_ACCOUNT_MSTR  WITH(NOLOCK) on  LDG_ACCOUNT_ID  =   FINA_ACC_ID     
WHERE LDG_DELETED_IND=1  
union all
select  case when ldg_account_type ='P' then dpam_sba_no else FINA_ACC_CODE end LD_CLIENTCD    
,LDG_VOUCHER_DT  LD_DT    
,convert(numeric(18,4),LDG_AMOUNT  ) LD_AMOUNT    
,LDG_NARRATION  LD_PARTICULAR    
,LDG_INSTRUMENT_NO  LD_CHEQUENO    
,case when LDG_AMOUNT < 0 then 'D' else 'C' end   LD_DEBITFLAG    
,(CASE WHEN LDG_VOUCHER_TYPE =1 THEN 'P'    
       WHEN LDG_VOUCHER_TYPE =2 THEN 'R'    
    WHEN LDG_VOUCHER_TYPE =3 THEN 'J'    
    WHEN LDG_VOUCHER_TYPE =5 THEN 'B' ELSE '' END) LD_DOCUMENTTYPE    
,LDG_VOUCHER_NO  LD_DOCUMENTNO    
,'' LD_ENTRYNO    
,'' LD_COSTCENTER    
,LDG_CREATED_BY  MKRID    
,LDG_LST_UPD_DT  MKRDT    
,YEAR(ldg_voucher_dt) LD_ACCYEAR    
,LEFT(DPAM_SBA_NO,8) LD_DPID    
,'' LD_COMMONDT    
,'' LD_COMMON    
from LEDGER3    WITH(NOLOCK)  
left outer join  dp_acct_mstr  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id     
left outer join  FIN_ACCOUNT_MSTR   WITH(NOLOCK)on  LDG_ACCOUNT_ID  =   FINA_ACC_ID     
WHERE LDG_DELETED_IND=1 
union all
select  case when ldg_account_type ='P' then dpam_sba_no else
case when FINA_ACC_CODE like '%SGST' then 'SGST'
when FINA_ACC_CODE like '%IGST' then 'IGST'
when FINA_ACC_CODE like '%CGST' then 'CGST'
when FINA_ACC_CODE like '%UGST' then 'UGST'
else FINA_ACC_CODE end
end LD_CLIENTCD   
,LDG_VOUCHER_DT  LD_DT   
,convert(numeric(18,4),LDG_AMOUNT  ) LD_AMOUNT   
,LDG_NARRATION  LD_PARTICULAR   
,LDG_INSTRUMENT_NO  LD_CHEQUENO   
,case when LDG_AMOUNT < 0 then 'D' else 'C' end   LD_DEBITFLAG   
,(CASE WHEN LDG_VOUCHER_TYPE =1 THEN 'P'   
       WHEN LDG_VOUCHER_TYPE =2 THEN 'R'   
    WHEN LDG_VOUCHER_TYPE =3 THEN 'J'   
    WHEN LDG_VOUCHER_TYPE =5 THEN 'B' ELSE '' END) LD_DOCUMENTTYPE   
,LDG_VOUCHER_NO  LD_DOCUMENTNO   
,'' LD_ENTRYNO   
,'' LD_COSTCENTER   
,LDG_CREATED_BY  MKRID   
,LDG_LST_UPD_DT  MKRDT   
,YEAR(ldg_voucher_dt) LD_ACCYEAR   
,LEFT(DPAM_SBA_NO,8) LD_DPID   
,'' LD_COMMONDT   
,'' LD_COMMON   
from LEDGER4    WITH(NOLOCK) 
left outer join  dp_acct_mstr  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id    
left outer join  FIN_ACCOUNT_MSTR   WITH(NOLOCK)on  LDG_ACCOUNT_ID  =   FINA_ACC_ID    
WHERE LDG_DELETED_IND=1  
union all
select  case when ldg_account_type ='P' then dpam_sba_no else
case when FINA_ACC_CODE like '%SGST' then 'SGST'
when FINA_ACC_CODE like '%IGST' then 'IGST'
when FINA_ACC_CODE like '%CGST' then 'CGST'
when FINA_ACC_CODE like '%UGST' then 'UGST'
else FINA_ACC_CODE end
end LD_CLIENTCD   
,LDG_VOUCHER_DT  LD_DT   
,convert(numeric(18,4),LDG_AMOUNT  ) LD_AMOUNT   
,LDG_NARRATION  LD_PARTICULAR   
,LDG_INSTRUMENT_NO  LD_CHEQUENO   
,case when LDG_AMOUNT < 0 then 'D' else 'C' end   LD_DEBITFLAG   
,(CASE WHEN LDG_VOUCHER_TYPE =1 THEN 'P'   
       WHEN LDG_VOUCHER_TYPE =2 THEN 'R'   
    WHEN LDG_VOUCHER_TYPE =3 THEN 'J'   
    WHEN LDG_VOUCHER_TYPE =5 THEN 'B' ELSE '' END) LD_DOCUMENTTYPE   
,LDG_VOUCHER_NO  LD_DOCUMENTNO   
,'' LD_ENTRYNO   
,'' LD_COSTCENTER   
,LDG_CREATED_BY  MKRID   
,LDG_LST_UPD_DT  MKRDT   
,YEAR(ldg_voucher_dt) LD_ACCYEAR   
,LEFT(DPAM_SBA_NO,8) LD_DPID   
,'' LD_COMMONDT   
,'' LD_COMMON   
from LEDGER5   WITH(NOLOCK) 
left outer join  dp_acct_mstr  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id    
left outer join  FIN_ACCOUNT_MSTR   WITH(NOLOCK)on  LDG_ACCOUNT_ID  =   FINA_ACC_ID    
WHERE LDG_DELETED_IND=1  
union all
select  case when ldg_account_type ='P' then dpam_sba_no else
case when FINA_ACC_CODE like '%SGST' then 'SGST'
when FINA_ACC_CODE like '%IGST' then 'IGST'
when FINA_ACC_CODE like '%CGST' then 'CGST'
when FINA_ACC_CODE like '%UGST' then 'UGST'
else FINA_ACC_CODE end
end LD_CLIENTCD   
,LDG_VOUCHER_DT  LD_DT   
,convert(numeric(18,4),LDG_AMOUNT  ) LD_AMOUNT   
,LDG_NARRATION  LD_PARTICULAR   
,LDG_INSTRUMENT_NO  LD_CHEQUENO   
,case when LDG_AMOUNT < 0 then 'D' else 'C' end   LD_DEBITFLAG   
,(CASE WHEN LDG_VOUCHER_TYPE =1 THEN 'P'   
       WHEN LDG_VOUCHER_TYPE =2 THEN 'R'   
    WHEN LDG_VOUCHER_TYPE =3 THEN 'J'   
    WHEN LDG_VOUCHER_TYPE =5 THEN 'B' ELSE '' END) LD_DOCUMENTTYPE   
,LDG_VOUCHER_NO  LD_DOCUMENTNO   
,'' LD_ENTRYNO   
,'' LD_COSTCENTER   
,LDG_CREATED_BY  MKRID   
,LDG_LST_UPD_DT  MKRDT   
,YEAR(ldg_voucher_dt) LD_ACCYEAR   
,LEFT(DPAM_SBA_NO,8) LD_DPID   
,'' LD_COMMONDT   
,'' LD_COMMON   
from LEDGER6   WITH(NOLOCK) 
left outer join  dp_acct_mstr  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id    
left outer join  FIN_ACCOUNT_MSTR   WITH(NOLOCK)on  LDG_ACCOUNT_ID  =   FINA_ACC_ID    
WHERE LDG_DELETED_IND=1

GO
