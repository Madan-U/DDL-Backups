-- Object: PROCEDURE dbo.Contractalltrade
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  Procedure Contractalltrade As   
Begin  
 Set Transaction Isolation Level Read Uncommitted  
  
Insert Into Contlogin  
Select 'sa',branch_id,party_code,scrip_cd,series,tradeqty,  
Sell_buy,sauda_date,'no',getdate(),'0',trade_no  
From Trade Where Branch_id <> Party_code  
And Party_code Not In ( Select Party_code From Termparty   
Where User_id = Userid And Termparty.party_code = Trade.party_code )  
  
Exec Bbgdirectgencontract  
  
End

GO
