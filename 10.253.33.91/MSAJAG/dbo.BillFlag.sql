-- Object: PROCEDURE dbo.BillFlag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillFlag    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillFlag    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillFlag    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillFlag    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillFlag    Script Date: 12/27/00 8:58:43 PM ******/

/* 
For Updating settlement flags 
used in After Contract
Create Date 28 Aug 2000 1:38 PM 
Created By Animesh Jain
*/
CREATE procedure BillFlag  
@TsettNo varchar(7),
@TSett_type varchar(2),
@tscrip varchar(12), 
@tseries varchar(2), 
@tpartycd varchar(10)
AS 
  
  Update settlement set billflag = 1  FROM settlement , CLIENT2 
  where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
  and CLIENT2.tran_cat = 'DEL'
  and settlement.sett_no =@tsettno 
  and settlement.sett_type = @tsett_type
  and settlement.scrip_cd =@tscrip 
  and settlement.series =@TSeries          
  and settlement.party_code = @tpartycd
  
  Update settlement set billflag = 2  FROM settlement , CLIENT2 
  where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
  and CLIENT2.tran_cat = 'TRD'
  and settlement.sett_no =@tsettno 
  and settlement.sett_type = @tsett_type
  and settlement.sell_buy = 1 
  and settlement.scrip_cd =@tscrip 
  and settlement.series =@TSeries
  and settlement.party_code = @tpartycd
  
  Update settlement set billflag = 3  FROM settlement , CLIENT2 
  where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
  and CLIENT2.tran_cat = 'TRD'
  and settlement.sett_no =@tsettno 
  and settlement.sett_type = @tsett_type
  and settlement.sell_buy = 2 
  and settlement.scrip_cd =@tscrip 
  and settlement.series =@TSeries
  and settlement.party_code = @tpartycd

GO
