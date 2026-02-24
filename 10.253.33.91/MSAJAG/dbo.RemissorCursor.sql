-- Object: PROCEDURE dbo.RemissorCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.RemissorCursor    Script Date: 05/20/2002 2:25:52 PM ******/
Create Proc RemissorCursor (@FromSett_No Varchar(7),@ToSett_No Varchar(7),@Sett_Type Varchar(2)) As
Declare @@Sett_No Varchar(7),
@@SettCur as Cursor

Set @@SettCur = Cursor for
	Select Distinct Sett_No from Sett_Mst Where Sett_Type = @Sett_Type 
	and Sett_No >= @FromSett_No and Sett_No <= @ToSett_No
	Order By Sett_No
Open @@SettCur 
Fetch next from @@SettCur into @@Sett_No
While @@Fetch_Status = 0 
Begin
	Exec RemissorAccValan @@Sett_No,@Sett_Type
	Fetch next from @@SettCur into @@Sett_No
End	
Close @@SettCur
DeAllocate @@SettCur

GO
