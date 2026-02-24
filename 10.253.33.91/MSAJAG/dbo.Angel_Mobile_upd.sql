-- Object: PROCEDURE dbo.Angel_Mobile_upd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure Angel_Mobile_upd  
as  
/* To updated Mobile Numbers of client being verified by QA team while reseting the password*/  
select party_code,mobile_no  
into #ff  
from intranet.misc.dbo.bo_passwordreset   
where verification_status='Confirmed'  
and verified_on>=convert(varchar(11),getdate())+' 00:00:00'  
and verified_on<=convert(varchar(11),getdate())+' 23:59:59'  
                 
update client_details set mobile_pager=mobile_no ,imp_status=0,status='U',modifidedOn=getdate()    
from #ff b                              
where client_details.party_code=b.party_code

GO
