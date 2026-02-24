-- Object: PROCEDURE dbo.angel_reco_acc2
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure angel_reco_acc2  
as        
set nocount on        
        
set transaction isolation level read uncommitted        
select accno,longname, last_date,amount=sum(cramt) from angel_client_deposit_recno a (nolock), acmast b (nolock)      
where a.accno=b.cltcode   
and a.vdt <= convert(varchar(11),getdate()-6)+' 23:59:59'         
group by accno,last_date,longname order by amount desc        
        
set nocount off

GO
