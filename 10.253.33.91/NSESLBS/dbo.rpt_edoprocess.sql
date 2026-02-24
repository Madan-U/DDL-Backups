-- Object: PROCEDURE dbo.rpt_edoprocess
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proceDURE [dbo].[rpt_edoprocess]
	@fromdate as varchar(11),
	@todate as varchar(11),
	@RptType Varchar(10)
	AS
SET @fromdate = CONVERT(varchar,@fromdate,109)             
SET @todate   = CONVERT(varchar,@todate,109)   
  
set transaction isolation level read uncommitted

If (@RptType = 'Summary')
Begin
	select
		Business_Date ,
		Sett_Type ,
		Sett_No,
		Import_Trade,
		Billing,
		VBB ,
		STT ,
		Valan,
		Contract,
		Posting,
		Open_Close,
		ProcessDate 
	
	from
		V2_Business_Process(NOLOCK)
	WHERE
	 ProcessDate >= @fromdate   
   	 And   ProcessDate <= @todate + ' 23:59:59'     
 END
Else

If (@RptType = 'Detail')
Begin
	select
		SNO,
		Exchange ,
		Segment,
		BusinessDate,
		Sett_No,
		Sett_Type,
		ProcessName,
		FileName,
		Start_End_Flag,
		ProcessDate,
		ProcessBy,
		MachineIP
	from
		V2_Process_Status_Log(NOLOCK)
	WHERE
	 ProcessDate >= @fromdate   
   	 And   ProcessDate <= @todate + ' 23:59:59'  

 End

GO
