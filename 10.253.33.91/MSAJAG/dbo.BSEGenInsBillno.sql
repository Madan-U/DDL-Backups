-- Object: PROCEDURE dbo.BSEGenInsBillno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE BSEGenInsBillno (@Sett_no varchar(7),@sett_Type varchar(3)) AS 
Declare @@Party varchar(12),
        @@BillNo varchar(7),
        @@PartyCont Cursor,    
        @@MaxBillno Int

        Set @@PartyCont = cursor for 
                 Select Distinct Party_Code,Isnull(Billno,0) From ISettlement
                 Where Sett_no = @Sett_no and sett_type = @Sett_type  
                 /* Group by Party_Code  */
                 Order By Party_code 
                 Open @@PartyCont
Fetch next from @@PartyCont into @@Party,@@BillNo

Select @@MaxBillno = Isnull(Max(Convert(Int,BillNo)),0) from ISettlement 
Where  Sett_no = @Sett_no and sett_type = @Sett_type  


/* select @@Billno = 0 */

While @@fetch_status = 0
Begin
         If @@BillNo = 0 
         Select @@MaxBillNo = Convert(int,@@MaxBillNo) + 1   

         Update ISettlement Set billno = @@MaxBillno where Sett_no = @Sett_no and sett_type = @Sett_type 
         and Party_code = @@Party
         Fetch next from @@PartyCont into @@Party,@@Billno
End
Close @@PartyCont
Deallocate @@PartyCont

GO
