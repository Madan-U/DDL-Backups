-- Object: PROCEDURE dbo.First_Trade_last3months
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



Create Proc First_Trade_last3months
as
Select * into #cl_list  from (
Select cl_code ,min(active_Date) Activedate, Max(inactive_from) Inactive_date from client_brok_details c (Nolock)
where cl_code >='A00' and Cl_Code <='zzzzzz'
Group by Cl_code  )a
where a.Activedate >=Convert(varchar(11),Getdate()-90,120) and a.Activedate <=Convert(varchar(11),Getdate(),120) +' 23:59'

Create index #c on #cl_list (cl_code)

Select a.*,isnull(First_Trade_Date,'') First_Trade_Date into #final
from #cl_list a
left outer join 
(Select Cltcode,MIn(Vdt) as First_Trade_Date  from account.dbo.Ledger_all where 
Vdt >=Convert(varchar(11),Getdate()-90,120) and Vdt <=Convert(varchar(11),Getdate(),120) +' 23:59'
and vtyp=15
Group by Cltcode ) b
on A.cl_code=b.CLTCODE


Select * from #final 
order by Cl_code

GO
