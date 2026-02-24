-- Object: PROCEDURE dbo.BillAllTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE Procedure [dbo].[BillAllTrade] (@Sett_No Varchar(7),@Sett_Type Varchar(2)) as   
Begin  
if ( Select Count(*) From Owner Where Mainbroker > 0 ) > 0  
begin  
 Exec BSERearrangeSubBillflag @Sett_no,@Sett_Type  
 Exec BSEGENSubBillNo @Sett_no,@Sett_Type  
end  
Exec BSERearrangeBillFlagnew @Sett_no,@Sett_Type /*added by bhagyashree on 9-6-2001*/  
Exec BSEGENInsBillNo @Sett_no,@Sett_Type  
Exec BSEGenBillNo @Sett_no,@Sett_Type  
	IF(@Sett_Type in ('A','X'))
	 BEgin 
		EXEC proc_Auction_Turnovertax_process @Sett_no,@Sett_Type -- /*ADDED BY VK DT 22-JUL-2025 SRE - SRE-38720*/  
	End
End

GO
