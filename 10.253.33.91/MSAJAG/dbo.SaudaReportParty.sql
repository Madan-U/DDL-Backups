-- Object: PROCEDURE dbo.SaudaReportParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SaudaReportParty    Script Date: 5/30/01 2:04:18 PM ******/
Create Proc SaudaReportParty(@Sett_No varchar(7),@Sett_type Varchar(2),
@FDate Varchar(11),@TDate Varchar(11),
@FCode Varchar(10),@TCode Varchar(10),@FPCode Varchar(10),@TPCode Varchar(10),
@FScrip Varchar(12),@TScrip Varchar(12),@Flag int) As 
if @Flag = 1 
Begin
	select sett_no,sett_type,s.party_code,Short_Name,scrip_cd,series,Pqty=Sum(Pqty),Pamt=Sum(Pamt),
	Sqty=Sum(Sqty),samt=Sum(Samt),Nqty=Sum(Pqty)-Sum(Sqty),NAmt=Sum(PAMT)-Sum(SAmt),
	ClRate = IsNull((Select Max(Cl_Rate) From Closing where Scrip_Cd = S.Scrip_Cd and 
	Series = s.series and sysdate = ( select Max(SysDate) from Closing where Scrip_Cd = S.Scrip_Cd and 
	Series = s.series and sysdate <= @FDate + ' 23:59:59' and Market not like 'ALBM%') and Market not like 'ALBM%'),0)
	from SaudaSumReport s,Client1 C1,Client2 c2 where sett_no = @sett_no and sett_type = @sett_type 
	and C1.Family <= @FCode and C1.Family >= @TCode and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
	and S.party_code <= ltrim(@FPCode) and s.party_code >= ltrim(@TPCode) 
	and Scrip_Cd <= @Fscrip and Scrip_cd >= @TScrip
	and SDate <= @FDate and Sdate >= @TDate
	Group by sett_no,sett_type,s.party_code,Short_Name,scrip_cd,series
	order by s.party_code,Scrip_Cd
End
else
Begin
	select sett_no,sett_type,s.party_code,Short_Name,scrip_cd,series,Pqty=Sum(Pqty),Pamt=Sum(Pamt),
	Sqty=Sum(Sqty),samt=Sum(Samt),Nqty=Sum(Pqty)-Sum(Sqty),NAmt=Sum(PAMT)-Sum(SAmt),
	ClRate = IsNull((Select Max(Cl_Rate) From Closing where Scrip_Cd = S.Scrip_Cd and 
	Series = s.series and sysdate = ( select Max(SysDate) from Closing where Scrip_Cd = S.Scrip_Cd and 
	Series = s.series and sysdate <= @FDate + ' 23:59:59' and Market not like 'ALBM%') and Market not like 'ALBM%'),0)
	from SaudaSumReport s,Client1 C1,Client2 c2 where sett_no = @sett_no and sett_type = @sett_type 
	and C1.Family <= @FCode and C1.Family >= @TCode and c1.cl_code = c2.cl_code and c2.party_code = s.party_code
	and S.party_code <= ltrim(@FPCode) and s.party_code >= ltrim(@TPCode) 
	and Scrip_Cd <= @Fscrip and Scrip_cd >= @TScrip
	and SDate <= @FDate and Sdate >= @TDate
	Group by sett_no,sett_type,s.party_code,Short_Name,scrip_cd,series
	order by scrip_cd,S.Party_Code
End

GO
