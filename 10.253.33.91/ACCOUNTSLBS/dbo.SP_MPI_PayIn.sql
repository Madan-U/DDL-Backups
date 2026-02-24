-- Object: PROCEDURE dbo.SP_MPI_PayIn
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



CREATE procedure SP_MPI_PayIn   
@branchcode varchar(10),  
@partycode varchar(10),  
@bankcode varchar(10),  
@bankac varchar(16),  
@longname varchar(100)  
as  
if(@branchcode=@partycode)   
 BEGIN  
    insert into ACCOUNT.DBO.MPI_PayIn values (@branchcode,@partycode,@bankcode,@bankac,'HDFC BANK','S','CA',@longname,'53','10001')  
    insert into ACCOUNTBSE.DBO.MPI_PayIn values (@branchcode,@partycode,@bankcode,@bankac,'HDFC BANK','S','CA',@longname,'51','10001')  
 END  
ELSE  
  BEGIN  
     insert into ACCOUNT.DBO.MPI_PayIn values (@branchcode,@partycode,@bankcode,@bankac,'HDFC BANK','E','CA',@longname,'53','10001')  
     insert into ACCOUNTBSE.DBO.MPI_PayIn values (@branchcode,@partycode,@bankcode,@bankac,'HDFC BANK','E','CA',@longname,'51','10001')   
  END

GO
