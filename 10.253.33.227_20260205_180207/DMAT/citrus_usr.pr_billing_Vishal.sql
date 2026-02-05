-- Object: PROCEDURE citrus_usr.pr_billing_Vishal
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_billing_Vishal 'jan 01 2024' , 'Jan 31 2024'
CREATE     procedure [citrus_usr].[pr_billing_Vishal]
(@pa_billing_from_dt datetime,@pa_billing_to_dt datetime)
as
begin

Declare @pa_errmsg varchar (8000)

Declare @pa_dpmdpid varchar (8000)
set @pa_dpmdpid ='' 
select @pa_dpmdpid = dpm_dpid from DP_mstr where default_dp = dpm_excsm_id and DPM_DELETED_IND = 1 

		IF exists (select * from BILL_CYCLE  where BILLC_POSTED_FLG = 'N' 
	and BILLC_FROM_DT = @pa_billing_from_dt 
	and 	BILLC_TO_DT =@pa_billing_to_dt 
		)    and isnull(@pa_dpmdpid ,'') <> '' 
		BEGIN  
       print 'exec' 

			insert into billlog
			select 'Missing ISIN Started', GETDATE () 
			declare @p18 varchar(1)
			set @p18=Null
			exec pr_dp_select_mstr_2 @pa_id='',@pa_action='BILL_PERIOD_MISSED_ISIN',@pa_login_name='HO',@pa_search_c1='3',@pa_search_c2='CDSL'
			,@pa_search_c3=@pa_billing_to_dt,@pa_search_c4='',@pa_search_c5='',@pa_search_c6='',@pa_search_c7='',@pa_search_c8=''
			,@pa_search_c9='',@pa_search_c10='',@pa_roles='',@pa_scr_id=0,@rowdelimiter='',@coldelimiter='',@pa_ref_cur=@p18 output
			select @p18
			insert into billlog
			select 'Missing ISIN End', GETDATE () 
			
			insert into billlog
			select 'Closing price index Started', GETDATE () 
			ALTER INDEX ix_4 ON closing_price_mstr_cdsl REBUILD;
			ALTER INDEX PK_closing_price_mstr_cdsl ON closing_price_mstr_cdsl REBUILD;
			insert into billlog
			select 'Closing price index End', GETDATE () 
			
			insert into billlog
			select 'Back up Started', GETDATE () 
			truncate table client_charges_cdsl_bak_vishal
			insert into client_charges_cdsl_bak_vishal 
			select *  from client_charges_cdsl 
			insert into billlog
			select 'Back up Started', GETDATE () 

			insert into billlog
			select 'Billing Started', GETDATE () 
			exec pr_billing_main_cdsl @pa_billing_from_dt ,@pa_billing_to_dt ,@pa_dpmdpid,'Yes','NO','B','HO'
		   insert into billlog
			select 'Billing End', GETDATE () 

		END  
		else 
		begin 

			SET @pa_errmsg =  'Posting of bills has been completed for the chosen billing period / Please Input proper Date'
			select @pa_errmsg       
			RETURN       

		end 


end

GO
