-- Object: PROCEDURE dbo.InsProcAfterBill
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure    
 [dbo].[InsProcAfterBill]    
 (    
  @settno  varchar (7) ,    
  @sett_type char(3),    
  @Party_code Varchar(10)='',    
  @Scrip_cd Varchar(12)='',    
  @StatusName VarChar(50)='',    
  @FromWhere VarChar(50)=''    
 )    
    
as    
    
EXEC INSPROC @SETTNO, @SETT_TYPE

GO
