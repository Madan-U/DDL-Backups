-- Object: PROCEDURE citrus_usr.Pr_rpt_offmarket_MIS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

Create procedure [citrus_usr].[Pr_rpt_offmarket_MIS]
@pa_for_dt datetime
as
begin

    Create table #tmpoff(trans_type varchar(3),dpam_id bigint,Ben_acct_type varchar(3),ctr_id varchar(16),trans_dt datetime,Isin_cd char(12),dpm_trans_no varchar(15),Qty numeric(18,3),book_narr_cd varchar(3),trans_cnt bigint)

	insert into #tmpoff
	select NSDHM_TRASTM_CD,nsdhm_dpam_id,nsdhm_Ben_acct_type,
	ctr_id=case when NSDHM_COUNTER_CMBP_ID <> '' then NSDHM_COUNTER_CMBP_ID else isnull(NSDHM_COUNTER_DPM_ID,'') + isnull(NSDHM_COUNTER_BO_ID,'') end,
	NSDHM_TRANSACTION_DT,NSDHM_ISIN,NSDHM_DPM_TRANS_NO,NSDHM_QTY,NSDHM_BOOK_NAAR_CD,1
	from nsdl_holding_dtls 
	where nsdhm_transaction_dt = 'may 28 2008' --@pa_for_dt
	and NSDHM_TRASTM_CD in('904','925')
	and nsdhm_ben_acct_type not in('20','30','40')
	and NSDHM_BOOK_NAAR_CD not in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')        

     update m set trans_type = 0               
     from #tmpoff m                
     where convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #tmpoff m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)             

     delete from #tmpoff where trans_cnt = 1


	 select * from #tmpoff where dpam_id in(select dpam_id from #tmpoff group by dpam_id having count(*) > 1)

	 truncate table #tmpoff	
     drop table #tmpoff



end

GO
