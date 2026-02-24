-- Object: PROCEDURE citrus_usr.pr_dump_client_BAK_11082015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_dump_client_BAK_11082015](@pa_id varchar(1))    
as    
begin     
insert into  TBL_CLIENT_MASTER    
select  * from  TBL_CLIENT_MASTER_fordump    
    
insert into Synergy_Client_Master    
select * from  Synergy_Client_Master_fordump    
    
end

GO
