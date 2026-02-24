-- Object: PROCEDURE citrus_usr.Pr_rpt_bill_profile_filter_Shilpa_angel_mailer_dump
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create Proc [citrus_usr].[Pr_rpt_bill_profile_filter_Shilpa_angel_mailer_dump]              
@pa_dptype varchar(4),                      
@pa_excsmid int,                      
@pa_fromdate datetime,                      
@pa_todate datetime,                      
@pa_bulk_printflag char(1), --Y/N
@pa_stopbillclients_flag char(1), --Y/N 
@pa_fromaccid varchar(16),                      
@pa_toaccid varchar(16),  
@pa_group_cd varchar(10),     
@pa_transclientsonly char(1),
@pa_Hldg_Yn char(1),
@pa_profile varchar(100),
@pa_login_pr_entm_id numeric,                        
@pa_login_entm_cd_chain  varchar(8000),                        
@pa_output varchar(8000) output
AS                      
BEGIN   

select * from dump_data_4_bill
order by dpam_acctno,dpam_sba_name,case when order_by='2' then '0' else order_by end ,Isin_name,convert(datetime,trans_date),dpm_trans_no

END

GO
