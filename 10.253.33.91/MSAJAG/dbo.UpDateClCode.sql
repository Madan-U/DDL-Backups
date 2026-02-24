-- Object: PROCEDURE dbo.UpDateClCode
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.UpDateClCode    Script Date: 3/17/01 9:56:13 PM ******/

/****** Object:  Stored Procedure dbo.UpDateClCode    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.UpDateClCode    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.UpDateClCode    Script Date: 03/20/2001 4:49:09 PM ******/
CREATE Proc UpDateClCode As
Declare @@ClCode Varchar(6),
	@@ClName Varchar(54),
	@@Party_Code Varchar(10),
	@@Char Char(1),
	@@ClCount Varchar(5),
	@@ClCursor Cursor
set @@ClCursor = cursor for
Select Code,Name From AllCl Order By Name
Open @@ClCursor
Fetch Next from @@ClCursor into @@Party_Code,@@ClName
While @@Fetch_Status = 0 
Begin 
	Select @@Char = Left(@@ClName,1)
	Select @@ClCount = 1
	while @@Char = Left(@@ClName,1) and @@Fetch_Status = 0 
	Begin
		Select @@ClCode = ( case when @@ClCount < 10 Then @@Char + '0000' + @@ClCount
				    Else ( case when @@ClCount < 100 Then @@Char + '000' + @@ClCount
					   Else ( case when @@ClCount < 1000 Then @@Char + '00' + @@ClCount
						  Else ( case when @@ClCount < 10000 Then @@Char + '0' + @@ClCount
							 Else ( case when @@ClCount < 100000 Then @@Char + @@ClCount
								End )
							 End )	
						  End )
					   End )
				    End )
		Update AllCl Set Cl_Code = @@ClCode where Code = @@Party_Code and Name = @@ClName
		Select @@ClCount = Convert(Int,@@ClCount) + 1 
		Fetch Next from @@ClCursor into @@Party_Code,@@ClName
	End
End

GO
