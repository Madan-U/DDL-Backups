-- Object: PROCEDURE dbo.Billflag
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Billflag    
@tsettno Varchar(7),  
@tsett_type Varchar(2),  
@tscrip Varchar(12),   
@tseries Varchar(2),   
@tpartycd Varchar(10)  
As   
    
  Update Settlement Set Billflag = 1  From Settlement , Client2   
  Where  Client2.party_code = Settlement.party_code   
  And Client2.tran_cat = 'del'  
  And Settlement.sett_no =@tsettno   
  And Settlement.sett_type = @tsett_type  
  And Settlement.scrip_cd =@tscrip   
  And Settlement.series =@tseries            
  And Settlement.party_code = @tpartycd  
    
  Update Settlement Set Billflag = 2  From Settlement , Client2   
  Where  Client2.party_code = Settlement.party_code   
  And Client2.tran_cat = 'trd'  
  And Settlement.sett_no =@tsettno   
  And Settlement.sett_type = @tsett_type  
  And Settlement.sell_buy = 1   
  And Settlement.scrip_cd =@tscrip   
  And Settlement.series =@tseries  
  And Settlement.party_code = @tpartycd  
    
  Update Settlement Set Billflag = 3  From Settlement , Client2   
  Where  Client2.party_code = Settlement.party_code   
  And Client2.tran_cat = 'trd'  
  And Settlement.sett_no =@tsettno   
  And Settlement.sett_type = @tsett_type  
  And Settlement.sell_buy = 2   
  And Settlement.scrip_cd =@tscrip   
  And Settlement.series =@tseries  
  And Settlement.party_code = @tpartycd

GO
