-- Object: PROCEDURE dbo.Usp_Insert_Mismatch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Usp_Insert_Mismatch  
As  
  
Select * into #t from client4 where bankid not in (select bankid from unknown) and   
depository not in ('cdsl','nsdl') and cl_code not like 'Z%' and isnumeric(cl_code) = 0 and cl_code <> ''  
  
Select * into #Det from #t where Not Exists   
(Select Cltcode,Bankid,Accno,Acctype from account.dbo.multibankid b where #t.cl_code=b.cltcode and #t.BankID=b.Bankid  
and #t.Cltdpid=b.Accno )  
----and #t.Depository=b.Acctype)  
  
Insert into account.dbo.multibankid  
Select a.cl_code,Bankid,CltdpId,Depository,isnull(short_name,''),Defdp from #Det a left outer join Client1 b on a.cl_code = b.cl_code

GO
