-- Object: PROCEDURE dbo.STT_SETT_ROUNDING
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.Stt_Rounding_Further    Script Date: 11/11/2004 4:17:48 PM ******/  
CREATE Proc STT_SETT_ROUNDING
(
	@Sett_Type Varchar(2), 
	@Sauda_Date Varchar(11), 
	@FromParty Varchar(10), 
	@ToParty Varchar(10)
)  

As  
  
Declare 
	@SttCur Cursor,  
	@Diff Numeric(18,4),  
	@Party_Code Varchar(10),  
	@ContractNo Varchar(7)  
  
Declare 
	@SettCur Cursor,  
	@Order_no Varchar(16),  
	@Trade_No Varchar(14),  
	@Scrip_Cd Varchar(12),  
	@Ins_Chrg Numeric(18,4)  
  


Select 
	sett_type, 
	Party_Code, 
	ContractNo, 
	Total = Sum(Ins_chrg), 
	Actual = Round(Sum(Ins_Chrg),0)   
Into 
	#Sett 
from 
	STT_SETT_TABLE
where 
	Party_Code Not In ( Select NewParty_Code From PartyMapping )  
Group By 
	sett_type, 
	Party_Code, 
	ContractNo  
Having 
	Sum(Ins_chrg) <> Round(Sum(Ins_Chrg),0)  
  

Set @SttCur = Cursor For  
Select 
	Party_Code, 
	ContractNo, 
	Diff = Total - Actual 
from 
	#Sett  
Order By 
	Party_Code, ContractNo  

Open @SttCur  
Fetch Next From @SttCur Into @Party_Code, @ContractNo, @Diff  

While @@Fetch_Status = 0 --1  
Begin  
	 Set @SettCur = Cursor for  
	
		Select 
			Scrip_Cd, 
			Order_No, 
			Trade_No, 
			Ins_Chrg 
		From 
			STT_SETT_TABLE
		Where 
			Party_Code = @Party_Code 
			And ContractNo = @ContractNo  
			And Ins_Chrg > 0   
		Order By 
			Ins_Chrg Desc  
	
	 Open @SettCur  
	 Fetch Next From @SettCur Into @Scrip_Cd, @Order_No, @Trade_No, @Ins_Chrg  

		While @@Fetch_Status = 0 And @Diff <> 0 --2  
		Begin  
			If @Diff < 0   
			Begin  
				Update STT_SETT_TABLE 
				Set 
					Ins_Chrg = Ins_chrg + Abs(@Diff)  
				Where 
					Party_Code = @Party_Code 
					And ContractNo = @ContractNo  
					And Ins_Chrg > 0 
					And Scrip_Cd = @Scrip_CD 
					and Order_No = @Order_No   
					And Trade_No = @Trade_No  
				Select @Diff = 0   
			End  
			Else  
			Begin  
				If @Diff >= @Ins_Chrg   
				Begin  
					Update STT_SETT_TABLE 
					Set 
						Ins_Chrg = 0  
					Where 
						Party_Code = @Party_Code 
						And ContractNo = @ContractNo  
						And Ins_Chrg > 0 
						And Scrip_Cd = @Scrip_CD 
						and Order_No = @Order_No   
						And Trade_No = @Trade_No  
					Select @Diff = @Diff - @Ins_Chrg   
				End   
				Else  
				Begin  
					Update STT_SETT_TABLE 
					Set 
						Ins_Chrg = @Ins_Chrg - @Diff  
					Where 
						Party_Code = @Party_Code 
						And ContractNo = @ContractNo  
						And Ins_Chrg > 0 
						And Scrip_Cd = @Scrip_CD 
						and Order_No = @Order_No   
						And Trade_No = @Trade_No  
					Select @Diff = 0  
				End      
			End   
	Fetch Next From @SettCur Into @Scrip_Cd, @Order_No, @Trade_No, @Ins_Chrg   
	End  
	Close @SettCur  
	Deallocate @SettCur  

Fetch Next from @SttCur Into @Party_Code, @ContractNo, @Diff  
End  
Close @SttCur  
Deallocate @SttCur

GO
