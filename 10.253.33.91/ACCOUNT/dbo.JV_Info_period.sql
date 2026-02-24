-- Object: PROCEDURE dbo.JV_Info_period
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE  Proc JV_Info_period (@fromdate datetime,@todate datetime,@cl_Code Varchar(11))  
as  
  
If ( @fromdate ='' or @todate='')  
 Begin   
  
 Select Remark='Data Range Not Proper'  
 Return  
  
 End   
  
  
  
IF @cl_Code ='' 
   Begin   
   
   Select Remark='provie the Party Code'  
  
   End   
Else  
   Begin   
  
   Select * from ledger_all With(Nolock)  
   where vdt >=@fromdate and vdt <= @todate +' 23:59'  
   and vtyp=8    and cltcode =@cl_Code
   order by vdt ,Vno desc  
  
   End

GO
