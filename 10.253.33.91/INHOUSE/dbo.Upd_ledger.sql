-- Object: PROCEDURE dbo.Upd_ledger
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE procedure Upd_ledger
as        
        
set nocount on        
----- Account Master        

truncate table ledger
insert into ledger      
select * from account.dbo.ledger with (nolock) --  00:18 secs        
        
truncate table ledger1
insert into ledger1      
select * from account.dbo.ledger1 with (nolock) --  00:18 secs        

set nocount off

GO
