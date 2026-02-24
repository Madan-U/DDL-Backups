-- Object: PROCEDURE dbo.HistFlag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.HistFlag    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.HistFlag    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.HistFlag    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.HistFlag    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.HistFlag    Script Date: 12/27/00 8:58:51 PM ******/

/* 
For Updating settlement flags 
used in After History
Create Date 04 Sept 2000 11:56 AM
Created By Sheetal Apte
*/
CREATE procedure HistFlag  
@TsettNo varchar(7),
@TSett_type varchar(2),
@tscrip varchar(12), 
@tseries varchar(2), 
@tpartycd varchar(10)
AS 
  
  Update history set billflag = 1  FROM history , CLIENT2 
  where  CLIENT2.PARTY_CODE = history.PARTY_CODE 
  and CLIENT2.tran_cat = 'DEL'
  and history.sett_no =@tsettno 
  and history.sett_type = @tsett_type
  and history.scrip_cd =@tscrip 
  and history.series =@TSeries          
  and history.party_code = @tpartycd
  
  Update history set billflag = 2  FROM history , CLIENT2 
  where  CLIENT2.PARTY_CODE = history.PARTY_CODE 
  and CLIENT2.tran_cat = 'TRD'
  and history.sett_no =@tsettno 
  and history.sett_type = @tsett_type
  and history.sell_buy = 1 
  and history.scrip_cd =@tscrip 
  and history.series =@TSeries
  and history.party_code = @tpartycd
  
  Update history set billflag = 3  FROM history , CLIENT2 
  where  CLIENT2.PARTY_CODE = history.PARTY_CODE 
  and CLIENT2.tran_cat = 'TRD'
  and history.sett_no =@tsettno 
  and history.sett_type = @tsett_type
  and history.sell_buy = 2 
  and history.scrip_cd =@tscrip 
  and history.series =@TSeries
  and history.party_code = @tpartycd

GO
