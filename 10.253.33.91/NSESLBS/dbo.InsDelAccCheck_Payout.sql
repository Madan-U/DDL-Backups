-- Object: PROCEDURE dbo.InsDelAccCheck_Payout
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDelAccCheck_Payout (@CltCode Varchar(10))
As
Select A.Cltcode, Amount = Sum(A.Credit)-Sum(A.Debit), 0 From (  
Select Cltcode, Debit = (Case When L.Drcr = 'D' Then Sum(Vamt) Else 0 End),   
Credit = (Case When L.Drcr = 'C' Then Sum(Vamt) Else 0 End) From Account.DBO.Ledger L, Account.DBO.Parameter
Where Vdt >= Sdtcur And Curyear = 1   
And Vdt <= LdtCur AND EDT <= LEFT(GETDATE(),11) + ' 23:59'
And CltCode = @CltCode
Group By Cltcode, L.Drcr
Union All
Select Cltcode, Debit = (Case When L.Drcr = 'C' Then Sum(Vamt) Else 0 End),   
Credit = (Case When L.Drcr = 'D' Then Sum(Vamt) Else 0 End) From Account.DBO.Ledger L, Account.DBO.Parameter
Where Vdt < Sdtcur And Curyear = 1   
And EDT > Sdtcur AND EDT <= LDTCUR
And CltCode = @CltCode AND EDT <= LEFT(GETDATE(),11) + ' 23:59'
Group By Cltcode, L.Drcr
Union All
Select Cltcode, Debit = (Case When L.Drcr = 'D' Then Sum(Vamt) Else 0 End),   
Credit = (Case When L.Drcr = 'C' Then Sum(Vamt) Else 0 End) From AccountBSE.DBO.Ledger L, AccountBSE.DBO.Parameter
Where Vdt >= Sdtcur And Curyear = 1   
And Vdt <= LdtCur
And CltCode = @CltCode AND EDT <= LEFT(GETDATE(),11) + ' 23:59'
Group By Cltcode, L.Drcr
Union All
Select Cltcode, Debit = (Case When L.Drcr = 'C' Then Sum(Vamt) Else 0 End),   
Credit = (Case When L.Drcr = 'D' Then Sum(Vamt) Else 0 End) From AccountBSE.DBO.Ledger L, AccountBSE.DBO.Parameter
Where Vdt < Sdtcur And Curyear = 1   
And EDT > Sdtcur AND EDT <= LDTCUR
And CltCode = @CltCode AND EDT <= LEFT(GETDATE(),11) + ' 23:59'
Group By Cltcode, L.Drcr ) A   
Group By A.Cltcode

GO
