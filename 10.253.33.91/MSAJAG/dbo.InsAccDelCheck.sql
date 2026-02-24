-- Object: PROCEDURE dbo.InsAccDelCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.InsAccDelCheck    Script Date: 05/08/2002 12:35:03 PM ******/


/****** Object:  Stored Procedure dbo.InsAccDelCheck    Script Date: 02/19/2002 8:49:48 AM ******/
CREATE Proc InsAccDelCheck (@Tdate Varchar(11),@CltCode Varchar(10)) As
select CltCode,Debit=(Case When L.DrCr = 'D' Then Sum(Vamt) Else 0 end),
Credit=(Case When L.DrCr = 'C' Then Sum(Vamt) Else 0 end) from Account.Dbo.Ledger L, Account.dbo.Parameter P
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'
And CltCode = @CltCode And Edt >= SdtCur And CurYear = 1 
Group by CltCode,L.DrCr

GO
