-- Object: PROCEDURE dbo.InsDelUpdateCltID
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE   Proc InsDelUpdateCltID (@FromParty Varchar(10), @ToParty Varchar(10)) As    
/*    
Update DelTrans Set DpType = '', DpId = '', CltDpId = '' from DeliveryDp DP, DelTrans With(Index(DelHold))    
where Filler2 = 1 and DrCr = 'D' And Delivered = '0'       
And TrType In (904,905,909) And DP.DpId = DelTrans.BDpId And DP.DpCltNo = DelTrans.BCltDpId And DP.DpType = DelTrans.BDpType       
And DP.Description Not Like '%POOL%' And Filler1 not Like 'Third Party'      
And Party_Code >= @FromParty And Party_Code <= @ToParty    
    
Update DelTrans Set DpType = C.Depository,DpId = C.BankID, CltDpId = C.Cltdpid from Client4 C With(Index(Clt4)) ,   
DeliveryDp DP , DelTrans With(Index(DelHold))     
*/  
  
Update DelTrans Set   
DpType = IsNull(C.Depository,''),  
DpId = IsNull(C.BankID,''),   
CltDpId = IsNull(C.Cltdpid,'')   
From DelTrans D Left Outer Join Client4 C   
On (C.Party_Code = D.Party_Code And DefDp = 1 And Depository in ('NSDL', 'CDSL')),   
DeliveryDp DP    
Where Filler2 = 1 and DrCr = 'D' And Delivered = '0'     
And TrType In (904,905,909) And DP.DpId = D.BDpId And DP.DpCltNo = D.BCltDpId   
And DP.DpType = D.BDpType     
And DP.Description Not Like '%POOL%'  
And Not ( D.DpType = IsNull(C.Depository,'')   
          And D.DpId = IsNull(C.BankID,'')   
          And D.CltDpId = IsNull(C.Cltdpid,'') )  
And Filler1 not Like 'Third Party'      
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty

GO
