-- Object: PROCEDURE citrus_usr.pr_dump_client_100720105
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_dump_client_100720105](@pa_id varchar(1))    
as    

declare @holddate varchar(11)

set @holddate= ( select TOP 1 HLD_HOLD_DATE FROM HOLDINGDATA WITH(NOLOCK))

 

begin     
TRUNCATE TABLE TBL_CLIENT_MASTER

insert into  TBL_CLIENT_MASTER    
select  * from  TBL_CLIENT_MASTER_fordump    
 

TRUNCATE TABLE Synergy_Client_Master

insert into Synergy_Client_Master    
select * from  Synergy_Client_Master_fordump    


Delete from dbo.synergy_holding where HLD_HOLD_DATE = @holddate

INSERT INTO dbo.synergy_holding  
SELECT * FROM HOLDINGDATA

end

GO
