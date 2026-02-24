-- Object: PROCEDURE dbo.Angel_GetBAnkReceiptDetails
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure Angel_GetBAnkReceiptDetails(@tdate as varchar(10))  
as  
set nocount on  
set transaction isolation level read uncommitted  
select * into #file1 from ledger (nolock) where vdt >=@tdate+' 00:00:00' and vdt <=@tdate+' 23:59:59' and vtyp=2 and drcr='C'  
  
select b.branch_cd,a.*,RecoStatus=(case when reldt='Jan  1 1900 00:00:00' then 'Pending' else 'Reconsiled' end) from   
(select a.ddno,vdt,reldt=replace(convert(varchar(10),reldt,101),'01/01/1900',''),vamt,cltcode,acname from ledger1 a (nolock) , #file1 b where a.vno=b.vno and a.lno=b.lno) a,  
(select branch_Cd,party_code from anand1.msajag.dbo.client_Details ) b where a.cltcode=b.party_Code  
set nocount off

GO
