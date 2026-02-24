-- Object: PROCEDURE dbo.GenSubContract
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GenSubContract    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.GenSubContract    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.GenSubContract    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.GenSubContract    Script Date: 2/5/01 12:06:13 PM ******/

/****** Object:  Stored Procedure dbo.GenSubContract    Script Date: 12/27/00 8:59:07 PM ******/

CREATE PROCEDURE GenSubContract AS 
declare 
                @@Sett_Type varchar(2),  
                @@ContNo varchar(7),
                @@PartiPantCode varchar(15),
            @@Sauda_Date Varchar(11),
                @@PartyCont Cursor    
set @@PartyCont = cursor for
 select Distinct Left(Convert(Varchar,Sauda_date,109),11) from  trade 
open @@PartyCont
fetch next  from @@PartyCont into @@sauda_date
close @@PartyCont
set @@PartyCont = cursor for
 select isnull(max(Convert(int,contractno)),0) from TrdBackUp  where sauda_Date like @@Sauda_date +'%'
open @@PartyCont
fetch next  from @@PartyCont into @@ContNo
close @@PartyCont
set @@PartyCont = cursor for 
                 select Sett_Type,PartiPantCode from TrdBackUp
   where Sauda_date like @@Sauda_date + '%'
                 group by Sett_Type,PartiPantCode
                 open @@PartyCont
fetch next  from @@PartyCont into  @@Sett_type,@@PartiPantCode
while @@fetch_status = 0
begin
 select @@ContNo = Convert(int,@@ContNo) + 1
   Select @@ContNo = 
  ( case when @@ContNo < 10 Then   
   "0000" + Convert(varchar,@@ContNo)
                  else ( Case  when @@ContNo < 100  Then
           "000" + Convert(varchar,@@ContNo)
           else ( Case  when @@ContNo < 1000  Then
           "00" + Convert(varchar,@@ContNo)
                                else ( Case  when @@ContNo < 10000  Then
                  "0" + Convert(varchar,@@ContNo)
                                       else ( Case  when @@ContNo < 100000  Then
                         Convert(varchar,@@ContNo)
                                             end ) 
                  end )
                               end ) 
                        end )
    end )
 update trdbackup set contractno = @@contno where sett_type = @@sett_type and partipantcode = @@partipantcode
        and Sauda_date like @@Sauda_date + '%'
 fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode
end
close @@PartyCont
deallocate @@PartyCont
update TrdBackUp set sett_no =  settled_in
from TrdBackUp s, nodel n where s.scrip_cd = n.scrip_cd
and s.series = n.series  and
s.sauda_date >= n.start_date AND s.sauda_date <= n.end_date

GO
