-- Object: PROCEDURE dbo.NSEBSEValan_Cursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc NSEBSEValan_Cursor as 
Declare @Sauda_Date Varchar(11),
@CMCur Cursor
Set @CMCur = Cursor For
select distinct Left(Convert(Varchar, Sauda_Date, 109),11) From CMBillValan
Union
select distinct Left(Convert(Varchar, Sauda_Date, 109),11) From BSEDB.DBO.CMBillValan
Open @CMCur
Fetch Next From @CMCur Into @Sauda_Date
While @@Fetch_Status = 0 
Begin
	Exec Proc_NSEBSE_Combine_Report_Update @Sauda_Date
	Fetch Next From @CMCur Into @Sauda_Date
End
Close @CMCur
Deallocate @CMCur

GO
