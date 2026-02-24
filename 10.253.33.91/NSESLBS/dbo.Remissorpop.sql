-- Object: PROCEDURE dbo.Remissorpop
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Remissorpop (@fromdate Varchar(11), @todate Varchar(11))    
As    
Declare     
@@sett_no Varchar(7),    
@@sett_type Varchar(2),    
@@settcur Cursor     
Set @@settcur = Cursor For    
 Select Distinct Sett_no,sett_type From Settlement     
 Where Sauda_date >= @fromdate And Sauda_date <= @todate + ' 23:59:59'    
Order By Sett_no,sett_type    
Open @@settcur     
Fetch Next From @@settcur Into @@sett_no,@@sett_type    
While @@fetch_status = 0     
Begin    
 Exec Remmissor_sharing @@sett_no,@@sett_type    
 Fetch Next From @@settcur Into @@sett_no,@@sett_type    
End    
Close @@settcur    
Deallocate @@settcur

GO
