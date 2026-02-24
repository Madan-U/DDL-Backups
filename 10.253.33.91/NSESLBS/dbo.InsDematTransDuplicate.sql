-- Object: PROCEDURE dbo.InsDematTransDuplicate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Proc InsDematTransDuplicate
as
truncate table Speed_Temp        
        
set transaction isolation level read uncommitted        
insert into Speed_Temp     
Select T.*           
from DelTrans D with(index(delhold)),           
DematTransSpeed T with(index(trn_speed))          
Where T.Sett_No = D.Sett_No          
And D.CertNo = T.IsIn          
And D.Filler2 = 1 And D.DrCr = 'C'           
And D.BDpType = T.BDpType          
And D.BDpId = T.BDpId          
And D.BCltDpId = T.BCltAccNo          
And D.Fromno = T.TransNo

GO
