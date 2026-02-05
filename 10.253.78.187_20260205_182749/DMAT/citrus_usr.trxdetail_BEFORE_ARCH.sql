-- Object: VIEW citrus_usr.trxdetail_BEFORE_ARCH
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE view [citrus_usr].[trxdetail_BEFORE_ARCH]      

as  

select CDSHM_TRAS_DT  td_curdate       
,cdshm_ben_acct_no td_ac_code       
,cdshm_isin td_isin_code       
,abs(cdshm_qty) td_qty       
,'' td_clear_corpn       
,case when len(CDSHM_COUNTER_DPID)  > 8 and CDSHM_COUNTER_DPID like 'IN%' then left(CDSHM_COUNTER_DPID,8) else CDSHM_COUNTER_DPID end td_counterdp       
,case when len(CDSHM_COUNTER_DPID)  > 8 and CDSHM_COUNTER_DPID like 'IN%' then right(CDSHM_COUNTER_DPID,8) else  CDSHM_COUNTER_boID  end td_beneficiery       
,CDSHM_TRANS_NO td_reference       
,case when CDSHM_CDAS_TRAS_TYPE ='5' then 'Inter Depository'     
when CDSHM_CDAS_TRAS_TYPE ='2' then cdshm_tratm_type_desc     
when CDSHM_CDAS_TRAS_TYPE ='18' and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~')='0' then 'TRANSMISSION'     
when CDSHM_CDAS_TRAS_TYPE ='18' and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~')='1' then 'TRANSFER'    
when CDSHM_CDAS_TRAS_TYPE ='21' and cdshm_isin like 'INE%'then citrus_usr.fn_getca_desc( citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,36,'~'),cdshm_tratm_type_desc)    
when CDSHM_CDAS_TRAS_TYPE ='21' and cdshm_isin like 'INF%'then 'CA-Mutual'    
when CDSHM_CDAS_TRAS_TYPE ='21' then citrus_usr.fn_getca_desc( citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,36,'~'),cdshm_tratm_type_desc)    
when CDSHM_CDAS_TRAS_TYPE ='6'  and CDSHM_CDAS_SUB_TRAS_TYPE ='605' then 'Demat Confirmation'     
when CDSHM_CDAS_TRAS_TYPE ='11'  and CDSHM_CDAS_SUB_TRAS_TYPE ='1103' then 'Confiscate'     
when CDSHM_CDAS_TRAS_TYPE ='20'  and CDSHM_CDAS_SUB_TRAS_TYPE ='2001' then 'INITIAL PUBLIC OFFERING'     
when CDSHM_CDAS_TRAS_TYPE ='22'  and CDSHM_CDAS_SUB_TRAS_TYPE ='2201' then citrus_usr.fn_getca_desc( citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,36,'~'),cdshm_tratm_type_desc)    
 else cdshm_tratm_type_desc end td_description       
,'' td_category       
,case when cdshm_cdas_sub_tras_type in ('101','101','102','103','105','107','109','110','111',      
'301','302','303','304','305','306','307','308','309','310',      
'401','402','403','408','409','411','511'      
,'512','520','521','523','525','528','529','533','536','537',      
'1401','1402'      
,'1503','1504','1505','1506'      
,'1603','1604','1605','1606'      
,'1701','1702'      
,'1801','1802','3001','3207','2202','2203','2204','2205','2201','2001','605') then '11'      
when cdshm_cdas_sub_tras_type in ('601','602','603','604','607','608','609','610') then '12'      
when cdshm_cdas_sub_tras_type in ('606','2002','2101','2102','2103','2104','2301','2302','2303') then '51'       
when cdshm_cdas_sub_tras_type in ('701','702','703','704','705','706','707','709') then '13'      
when cdshm_cdas_sub_tras_type in ('801','802','804','805','806','807','809','810','811','812','813','814'      
,'1101','1102','1103','1104','1105','1106','901','902','903','904','905','906','907','908','909') then '14'      
when cdshm_cdas_sub_tras_type in ('1201','1203','1204','1205','1206','1207','1208','1209') then '50'       
else cdshm_cdas_sub_tras_type      
end       
 td_ac_type       
,'' td_narration       
,'' td_booking_type       
,CDSHM_SETT_TYPE td_market_type       
,CDSHM_SETT_NO td_settlement       
,'' td_blocked       
,'' td_blockedcd       
,'' td_rdate       
,CONVERT(VARCHAR(8), CDSHM_TRAS_DT, 112) td_trxdate       
,CONVERT(VARCHAR(8), CDSHM_TRAS_DT, 108) td_trxtime       
,case when cdshm_qty >= 0 then 'C' else 'D' end  td_debit_credit       
,CDSHM_TRANS_NO td_trxno       
,'' td_charge_code       
--,isnull(citrus_usr.fn_get_rate(cdshm_isin,cdshm_tras_dt),'0') td_rate       
,(select top 1 CLOPM_CDSL_RT   td_rate
 from closing_price_mstr_cdsl where CLOPM_ISIN_CD = CDSHM_ISIN AND clopm_dt <= CDSHM_TRAS_DT order by clopm_dt desc)   td_rate       
,'' td_amount       
,CDSHM_INT_REF_NO td_internal_refno       
,CDSHM_COUNTER_CMBPID td_countercmbpid       
,'' td_totcert       
,'' td_chargeflag       
,'' mkrid       
,'' mkrdt       
,'' td_rejcode       
,'' td_billcode       
,'' td_cdslcharge       
,'' td_pdcd       
,'' td_pdcode       
,CDSHM_TRATM_DESC td_remarks       
,'' td_actualcdslcharge      
,CDSHM_CDAS_SUB_TRAS_TYPE    
,CDSHM_internal_trastm td_trxtype    
from cdsl_holding_dtls      
where  cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205') --'2252'  --,'4456'  '2280', -add 2205      

   /*    select * from cdsl_holding_dtls

11 - Free Balance    

12 - Pending Demat    

13 - Pending Remat    

14 - Pledge    

50 - Frozen Balance    

51 - Lock in Balance    

*/

GO
