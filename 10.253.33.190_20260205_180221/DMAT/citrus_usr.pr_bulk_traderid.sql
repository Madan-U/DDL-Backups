-- Object: PROCEDURE citrus_usr.pr_bulk_traderid
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_bulk_traderid](@pa_path varchar(8000))
as
begin



	declare @l_prop_cd varchar(100)
	,@l_prop_id  numeric


	select @l_prop_cd = entpm_cd , @l_prop_id = entpm_prop_id 
	from entity_property_mstr where entpm_Cd = 'BBO_CODE'

    select identity(bigint,1,1) id1 , * into #temp_data1 from [bbocode-data1]

    declare @l_max_id numeric
, @l_max_id_mak numeric
    
    select @l_max_id = max(entp_id) + 1 from entity_properties 
    select @l_max_id_mak = max(entp_id) + 1 from entity_properties_mak

    if @l_max_id_mak > @l_max_id 
    begin
      set @l_max_id  = @l_max_id_mak
    end 
 
    insert into entity_properties 
    select @l_max_id + id1 , dpam_crn_no , '' ,  @l_prop_id , @l_prop_cd , bbocode , 'MIG', getdate(),'MIG',getdate(),1 
    from   #temp_data1 , dp_acct_mstr 
    where  id = dpam_sba_no 
    and    not exists (select entp_id , entp_entpm_cd   from entity_properties where entp_ent_id = dpam_crn_no and dpam_deleted_ind =1 and entp_deleted_ind = 1 and entp_entpm_cd ='BBO_CODE')


--    update account_properties 
--    set  accp_value = broker_id
--    from account_properties account_properties , #temp_data1 , dp_acct_mstr 
--    where  account_id = dpam_sba_no 
--    and   dpam_id = accp_clisba_id 
--    and   accp_accpm_prop_cd = 'BROKER_ID'
    


end

GO
