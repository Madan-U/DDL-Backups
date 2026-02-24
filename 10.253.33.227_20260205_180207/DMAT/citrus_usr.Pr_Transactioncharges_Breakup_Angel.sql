-- Object: PROCEDURE citrus_usr.Pr_Transactioncharges_Breakup_Angel
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

  
  
--declare @p4 varchar(1)  
--set @p4=NULL  
--exec Pr_Transactioncharges_Breakup @padpmid=3,@pafromdate='OCT 24 2024',@patodate='OCT 24 2024',@pa_output=@p4 output  
--select @p4  
  
  
CREATE PROCEDURE [citrus_usr].[Pr_Transactioncharges_Breakup_Angel](  
 @padpmid  VARCHAR(800),  
 @pafromdate datetime,  
 @patodate  datetime  
 --@pa_output varchar(8000) output    
)   
   
AS  
BEGIN  
   
--select  '23/07/2024' as Date,'1203320300001830' BOID,'D60197749' BBO,'INE280A01028' ISIN,   
--'1' Qty,'1100001100017670' Countr,'EP-DR' Type,'Irreversible Delivery Out Instruction / Early Pay-in' as Desc1,  
--'20'Amt,'3.5'CDSL,'3.6'GST,'23.6'TOTAL,'M' Sex, 'Ordinary Shares / Equity' ISINTyope  
  
select * into #trx from cdsl_holding_dtls (NOlock) where CDSHM_TRAS_DT between @pafromdate and @patodate    
  
select distinct TxnsType , HAR_Type into #tmp_trxtype from trxn_type_new   
  
CREATE INDEX DPID ON #trx(CDSHM_BEN_ACCT_NO)  
CREATE INDEX #ISIN ON #trx(cdshm_isin)  
   
   
select convert(numeric(18,2) ,3.5)  cdsl_amt , '1' trxtype ,* into #trx_details from #trx where CDSHM_TRAS_DT between @pafromdate and @patodate   
and CDSHM_TRATM_CD in ('2277')--3.5  
and  (CDSHM_CDAS_SUB_TRAS_TYPE  in ('521','305','409','109','107','1503','105','707','3304')  
or isnull(cdshm_charge ,0)<>0)  
  
  
insert into #trx_details  
select convert(numeric(18,2) ,12 )  cdsl_amt , '2' trxtype ,  * from #trx where CDSHM_TRAS_DT between @pafromdate and @patodate   
and CDSHM_CDAS_SUB_TRAS_TYPE in ('1002','905','802') and cdshm_counter_boid <>'1203320186015090' --15  
  
insert into #trx_details  
select convert(numeric(18,2) ,5 )  cdsl_amt , '2' trxtype ,  * from #trx where CDSHM_TRAS_DT between @pafromdate and @patodate   
and CDSHM_CDAS_SUB_TRAS_TYPE in ('1002','905','802') and cdshm_counter_boid ='1203320186015090' --15  
  
insert into #trx_details  
select convert(numeric(18,2) ,5)  cdsl_amt , '3' , * from #trx where CDSHM_TRAS_DT between @pafromdate and @patodate   
and CDSHM_CDAS_SUB_TRAS_TYPE in ('829','1012','1102')--5  
  
insert into #trx_details  
select convert(numeric(18,2) ,1)  cdsl_amt , '4' ,  * from #trx where CDSHM_TRAS_DT between @pafromdate and @patodate   
and CDSHM_CDAS_SUB_TRAS_TYPE in ('838')--1  
  
  
  
 select CDSHM_TRAS_DT  [Trxn_date],cdshm_ben_acct_no  [dpam_sba_no], dpam_bbo_code [tradingid],cdshm_isin [ISIN], abs(cdshm_qty) [QTY]  
 ,cdshm_counter_boid [Target_Beneficiary]  
 ,cdshm_internal_trastm   [TRXN_Type]  
 ,Meaning [TRXN_Desc]  
 ,isnull(cdshm_charge ,0) * -1 [TRXN_Charge]  
 ,case when SexCd ='F'  and left(cdshm_isin, 3)  not in ('INF','IN0')   then cdsl_amt - case when trxtype in (2,3) then  0 else 0.25 end   
  when SexCd ='F' and left(cdshm_isin, 3)  in ('INF','IN0') then cdsl_amt -case when trxtype in (2,3) then  0 else 0.25 end  - case when trxtype in (2,3) then  0 else 0.25 end    
  when SexCd <> 'F' and left(cdshm_isin, 3)  in ('INF','IN0') then cdsl_amt -case when trxtype in (2,3) then  0 else 0.25  end   
  else cdsl_amt  end  [CDSL_Charge]   
 ,(isnull(cdshm_charge ,0) * -1  ) * 0.18 [GST]  
 ,(isnull(cdshm_charge ,0) * -1  ) * 1.18  [Total_Chrg]  
 ,SexCd  [Gender]  
 ,ISIN_SECURITY_TYPE_DESCRIPTION Isin_type ,ISIN_COMP_NAME As Company_Name
  from #trx_details left outer join isin_mstr  on isin_cd = cdshm_isin   
  left outer join  #tmp_trxtype on CDSHM_CDAS_TRAS_TYPE =  TxnsType   
  left outer join standard_value_list on ISO_Tags ='TxnTyp' and  Standard_Value   =  HAR_Type  , dp_acct_mstr , dps8_pc1   
 where dpam_sba_no = CDSHM_BEN_ACCT_NO   
 and boid = dpam_sba_no   
 order by 1,2  
   
 drop table #trx_details  
 drop table #tmp_trxtype   
 drop table #trx  
  
END

GO
