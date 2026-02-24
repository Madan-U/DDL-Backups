-- Object: PROCEDURE citrus_usr.Pr_Rpt_Ledger_mailer_dump
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create Proc [citrus_usr].[Pr_Rpt_Ledger_mailer_dump]        
@pa_dpmid int,        
@pa_finyearid int,        
@pa_fromdate datetime,        
@pa_todate datetime,        
@pa_ledgertype varchar(2),        
@pa_fromaccid varchar(16),        
@pa_toaccid varchar(16),        
@pa_withrunbal char(1),        
@pa_login_pr_entm_id numeric,          
@pa_login_entm_cd_chain  varchar(8000),          
@pa_output varchar(8000) output  As        
begin        
set nocount on    

select * from dump_data_4_ledger 
where account_CD = @pa_fromaccid
order by account_name,account_cD,13,voucher_type,Voucher_no

end

GO
