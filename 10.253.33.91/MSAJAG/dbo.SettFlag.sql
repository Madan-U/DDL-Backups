-- Object: PROCEDURE dbo.SettFlag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* 
For Updating settlement flags 
used in After Contract
Create Date 26 Aug 2000 6:15 PM 
Created By Sheetal Apte
*/
CREATE procedure SettFlag  
@tscrip varchar(12), 
@tpartycd varchar(7), 
@tdate varchar(10) 

AS 
  
		Update settlement set settflag = 1  FROM settlement , msajag.dbo.CLIENT2 CLIENT2
		where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
		and CLIENT2.tran_cat = 'DEL'
		and settlement.scrip_cd =@tscrip 
		and convert(varchar,settlement.sauda_date,3)= @TDate
		and settlement.party_code = @tpartycd
		
		Update settlement set settflag = 2  FROM settlement ,  msajag.dbo.CLIENT2 CLIENT2 
		where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
		and CLIENT2.tran_cat = 'TRD'
		and settlement.sell_buy = 1 
		and settlement.scrip_cd =@tscrip 
		and convert(varchar,settlement.sauda_date,3)= @TDate
		and settlement.party_code = @tpartycd
		
		Update settlement set settflag = 3  FROM settlement ,  msajag.dbo.CLIENT2 CLIENT2 
		where  CLIENT2.PARTY_CODE = settlement.PARTY_CODE 
		and CLIENT2.tran_cat = 'TRD'
		and settlement.sell_buy = 2 
		and settlement.scrip_cd =@tscrip 
		and convert(varchar,settlement.sauda_date,3)= @TDate
		and settlement.party_code = @tpartycd

GO
