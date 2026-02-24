-- Object: PROCEDURE dbo.DelProcAfterBill
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure      
 DelProcAfterBill      
 (      
  @sett_no varchar(7),      
  @sett_Type Varchar(3),      
  @Party_code Varchar(12)='',    
  @Scrip_cd Varchar(12)='',    
  @StatusName VarChar(50)='',    
  @FromWhere VarChar(50)=''       
 )      
     
as      
  
exec delproc @sett_no, @sett_Type

GO
