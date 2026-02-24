-- Object: PROCEDURE dbo.angel_reco_acc
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure angel_reco_acc(@brcode as varchar(10))  
as  
set nocount on  
  
set transaction isolation level read uncommitted  
select * into #brcli from intranet.risk.dbo.finmast where sbtag=@brcode  
  
set transaction isolation level read uncommitted  
select accno,longname, last_date,amount=sum(cramt) from angel_client_deposit_recno a (nolock), acmast b (nolock), #brcli c (nolock)  
where a.accno=b.cltcode and c.party_code=a.cltcode   
group by accno,last_date,longname order by amount desc  
  
set nocount off

GO
