-- Object: PROCEDURE dbo.BranchBSEGenBillno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE BranchBSEGenBillno (@Sett_no varchar(7),@sett_Type varchar(3),@statusid varchar(12),@statusname varchar(12)) as 
Declare @@Party varchar(12),
        @@BillNo varchar(7),
        @@PartyCont Cursor,    
        @@MaxBillno Int

	 If @StatusId = 'Branch'
	 Begin	
	        Set @@PartyCont = cursor for 
                 Select Distinct Settlement.Party_Code,Isnull(Billno,0) From Settlement, Client2 ,Branches
                 Where Sett_no = @Sett_no and sett_type = @Sett_type  
	 	 and client2.party_code = Settlement.party_code 
                 and Settlement.user_id = branches.terminal_id		
                 And Branches.Branch_cd = @StatusName
                 /* Group by Party_Code  */
                 Order By Settlement.Party_code 
	End
	Else
	Begin
	        Set @@PartyCont = cursor for 
	         Select Distinct Party_Code,Isnull(Billno,0) From Settlement
                 Where Sett_no = @Sett_no and sett_type = @Sett_type  
                 /* Group by Party_Code  */
                 Order By Party_code 
	End 
                 Open @@PartyCont
Fetch next from @@PartyCont into @@Party,@@BillNo

Select @@MaxBillno = Isnull(Max(Convert(int,Billno)),0) from Settlement 
Where  Sett_no = @Sett_no and sett_type = @Sett_type  

/* select @@Billno = 0 */

While @@fetch_status = 0
Begin
         If @@BillNo = 0 
         Select @@MaxBillNo = Convert(int,@@MaxBillNo) + 1   

         Update Settlement Set billno = @@MaxBillno where Sett_no = @Sett_no and sett_type = @Sett_type 
         and Party_code = @@Party
         Fetch next from @@PartyCont into @@Party,@@Billno
End
Close @@PartyCont
Deallocate @@PartyCont

GO
