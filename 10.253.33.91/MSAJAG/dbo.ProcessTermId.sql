-- Object: PROCEDURE dbo.ProcessTermId
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE ProcessTermId (@Sett_no Varchar(10),@Sett_Type varchar(2),@TDate Varchar(11))
AS 
Declare 
 @@Flag cursor,
 @@loop cursor,
 @@ScripCursor Cursor,
 @@Party_code varchar(15), 
 @@Scrip_cd Varchar(20),
 @@Series Varchar(3),
 @@Participantcode Varchar(30),
 @@Turnover Money,
 @@Pqty Bigint,
 @@Sqty Bigint,
 @@Brokerage Money,
 @@ATurnover Money,
 @@APqty Bigint,
 @@ASqty Bigint,
 @@ABrokerage Money,
 @@Details Varchar(300),
 @@ADetails Varchar(300),
 @@ResultStr Varchar(1024)


drop table result 
 
Begin Transaction
set nocount on

Insert into AngelTermIdRecord Select  Sauda_date = Convert(Varchar(11),Sauda_date),Sett_no = Sett_no,Sett_type=Sett_type,User_id,Scrip_cd,Series,party_code = A.party_code,Sell_buy,Volume = Sum(Tradeqty) , Turnover = Sum(Tradeqty * Marketrate),OrigBrokerage = Sum(Brokapplied + NBrokapp),NewBrokerage = 0 , Partipantcode,CalcDate = GetDate()  
from settlement S, Angeltermbrok A
Where
Sett_no = @Sett_no
and
Sett_type = @Sett_type
and
Sauda_date like @TDate +'%'
and
A.Fromdate <= @TDate
And
A.Todate >= @Tdate
and
s.party_code = A.party_code 
And
S.User_Id = A.Terminalnumber
Group by Convert(Varchar(11),Sauda_date),Sett_no,Sett_type,A.party_code,Scrip_cd,Series,Partipantcode,User_id,Sell_buy



Select @@Turnover = Sum(Tradeqty * Marketrate),
@@Pqty = Sum(Case When Sell_buy = 1 Then Tradeqty Else 0 End),
@@Sqty = Sum(Case When Sell_buy = 2 Then Tradeqty Else 0 End),
@@Brokerage = Sum(Brokapplied +Nbrokapp)
From Settlement where
Sett_no = @Sett_no
and
Sett_type = @Sett_type
and
Sauda_date like @Tdate +'%'


Set @@Flag = Cursor for
Select distinct A.party_code,Scrip_cd,Series,Partipantcode from settlement S, Angeltermbrok A
Where
Sett_no = @Sett_no
and
Sett_type = @Sett_type
and
Sauda_date like @Tdate +'%'
and
A.Fromdate <= @Tdate
And
A.Todate >= @Tdate
and
s.party_code = A.party_code
Order by A.Party_code,Scrip_cd,Series,Partipantcode

Open @@Flag
Fetch next from @@Flag into @@Party_code,@@Scrip_cd,@@Series,@@Participantcode

While ( (@@fetch_status = 0)  )
Begin
     Print @@Party_code
     Print @@Scrip_cd
     Print @@Series
     Print @@Participantcode

     Select getdate() 
     Exec TBseRearrangeAfterContflag @Sett_Type,@@Party_code,@@Scrip_cd,@@Series,@TDate,'%',@@Participantcode 
     Exec TBBGSettBrokUpdatenew @@Party_code,@@Scrip_cd,@TDate,@Sett_type,@@Participantcode,'%',@@Series
     Exec TBseRearrangeAfterBillflag @Sett_no,@Sett_type,@@Party_code,@@Scrip_cd,@@Series,'%',@@Participantcode
     Exec Tnewupdbilltaxafterbill @sett_no,@Sett_type,@@Party_code,@@Scrip_cd
     Exec BseRearrangeAfterContflag @Sett_Type,@@Party_code,@@Scrip_cd,@@Series,@TDate,'%',@@Participantcode 
     Exec AtBseRearrangeAfterBillflag @Sett_no,@Sett_type,@@Party_code,@@Scrip_cd,@@Series,'%',@@Participantcode  
     Fetch next from @@Flag into @@Party_code,@@Scrip_cd,@@Series,@@Participantcode    
End

Close @@Flag
Deallocate @@Flag
 
Update settlement set status = 'E' from settlement S , AngelTermbrok A 
Where
Sett_no = @Sett_no
and
Sett_type = @Sett_type
and
Sauda_date like @Tdate +'%'
and
A.Fromdate <= @Tdate
And
A.Todate >= @Tdate
and s.Party_code = A.Party_code

Select @@ATurnover = Sum(Tradeqty * Marketrate),
@@APqty = Sum(Case When Sell_buy = 1 Then Tradeqty Else 0 End),
@@ASqty = Sum(Case When Sell_buy = 2 Then Tradeqty Else 0 End),
@@ABrokerage = Sum(Brokapplied +Nbrokapp)
From Settlement where
Sett_no = @Sett_no
and
Sett_type = @Sett_type
and
Sauda_date like @Tdate +'%'

If (@@Turnover = @@ATurnover) And (@@Pqty = @@APqty) And (@@Sqty = @@ASqty)
Begin
    Commit Transaction
    Select @@Details = ' Turnover =    ' + CAST ( @@Turnover AS VARCHAR(30) ) + '    PQty =    ' + CAST ( @@Pqty AS VARCHAR(15) ) + '    Sqty =     ' + CAST ( @@Sqty AS VARCHAR(15) ) + '    Brokerage =    ' +CAST ( @@Brokerage AS VARCHAR(15) )    
    Select @@ADetails = ' Turnover =    ' + CAST ( @@ATurnover AS VARCHAR(30) ) + '    PQty =    ' + CAST ( @@APqty AS VARCHAR(15) ) + '    Sqty =     ' + CAST ( @@ASqty AS VARCHAR(15) ) + '    Brokerage =    ' +CAST ( @@ABrokerage AS VARCHAR(15) )
    Select status = 'Transaction Completed figuers are '
    Select status = @@Details
    Select status = 'Transaction Completed figuers are <br>'+@@Adetails into result
End
Else
Begin
       RollBack Transaction
       Select status='Transaction Failed ' into result 
End


Update AngelTermIdRecord Set NewBrokerage = ( Select Sum(Brokapplied + NBrokapp)
From Settlement S,AngelTermIdRecord
Where
S.Sett_no = @Sett_no
and
S.Sett_type = @Sett_type
and
AngelTermIdRecord.Sauda_date like @Tdate +'%'
And
AngelTermIdRecord.Sett_no = S.Sett_no 
And
Angeltermidrecord.Sett_type = S.Sett_type
and
s.party_code = AngelTermIdRecord.party_code 
And
S.User_Id = AngelTermIdRecord.User_id
And 
S.Scrip_cd = AngelTermIdRecord.Scrip_cd
And
S.Series = AngelTermIdRecord.Series
And
AngelTermIdRecord.Sauda_date = Convert(Varchar(11),S.Sauda_date)
And
S.Sell_buy = AngelTermIdRecord.Sell_buy
And
S.Partipantcode = AngeltermidRecord.Participantcode
Group by Convert(Varchar(11),AngelTermIdRecord.Sauda_date),AngelTermIdRecord.Sett_no,AngelTermIdRecord.Sett_type,AngelTermIdRecord.party_code,AngelTermIdRecord.Scrip_cd,AngelTermIdRecord.Series,AngelTermIdRecord.Participantcode,AngelTermIdRecord.Sell_buy
)

set nocount off

GO
