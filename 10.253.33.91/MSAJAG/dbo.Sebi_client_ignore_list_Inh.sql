-- Object: PROCEDURE dbo.Sebi_client_ignore_list_Inh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Sebi_client_ignore_list_Inh (@fromDate datetime)  
as  
  
Declare @todate datetime  
Set @todate =@fromDate-23  
  
Select Cl_code  into #clientlist from   
(Select cl_code,min(active_Date) Active_date from client_brok_details(Nolock)  
Group by cl_code  )a  
where Active_date >=@todate  
   
 Insert into #clientlist  
 Select Distinct cltcode from   
 account.dbo.ledger_all(Nolock) where vdt >=@todate  
 and VTYP in ('15','79')  
  
 Select * from #clientlist (Nolock)

GO
