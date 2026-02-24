-- Object: PROCEDURE dbo.AngelDupChq_Interseg
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc AngelDupChq_Interseg
(
	@strFromDate varchar(11),
	@strToDate varchar(11)
)
as
Insert into Intranet.Bsedb_ab.Dbo.AngelDupCheque Select * From ( Select Vdt = L.vdt ,Vtyp = L.Vtyp ,Vno = L.Vno ,LNo = L.Lno , Enteredby,Checkedby,Narration,   
		BnkName = bnkname,BrnName= brnname,DD= dd,Ddno = ddno, RelAmt = Relamt,  
		DrCr = L1.drcr ,L.Acname,branch = BranchCode,Cltcode= L.cltcode  ,Accat,ExchangeSegment = 'NSECM'  
		From Ledger L With(Nolock) , Ledger1 L1 With(Nolock) ,Acmast A   With(Nolock)
		Where  
		L.Vtyp = L1.Vtyp  
		And  
		L.Vno = L1.Vno  
		And  
		L.DrCr = L1.DrCr  
		And  
		L.Lno = L1.Lno  
		And   
		Vdt >= @strFromDate + ' 00:00' 
		And Vdt <= @strToDate + ' 23:59'  
		And L.CltCode = A.CltCode ) A

GO
