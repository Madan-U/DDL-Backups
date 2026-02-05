-- Object: VIEW citrus_usr.VW_Dis_Data
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE View [citrus_usr].[VW_Dis_Data]
AS
select a.*,remarks from (
select   dpam_sba_no,dpam_bbo_code,DPTDC_ISIN,DPTDC_qty*-1 as Qty,Comp_Name,DPTDC_REASON_CD,DPTDC_REQUEST_DT
 from dptdc_mak S (Nolock),DP_ACCT_MSTR D (Nolock), VW_ISIN_MASTER V (Nolock) where DPTDC_REQUEST_DT =COnvert(varchar(11),getdate(),120)
 and DPTDC_COUNTER_DP_ID <>'12033200'
 and DPTDC_DPAM_ID =DPAM_ID  and DPTDC_ISIN=isin 
 and DPTDC_COUNTER_CMBP_ID ='')a 
 left outer join 
 Dp_Trans_code D
 on DPTDC_REASON_CD = Dp_trans_Code and DPTDC_REQUEST_DT between   from_date And 	to_date

GO
