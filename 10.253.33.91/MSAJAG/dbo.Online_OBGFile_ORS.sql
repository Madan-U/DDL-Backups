-- Object: PROCEDURE dbo.Online_OBGFile_ORS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE      Proc [dbo].[Online_OBGFile_ORS] (@Sauda_Date Varchar(11))
As

Select D.Sett_No, D.Sett_Type, D.Party_Code, D.Scrip_Cd, D.Series, RQty = Sum(Qty) , IQty = 0 
Into #Online_StockFileDelNse_ORS1 From DelTrans D, Sett_Mst S, Client1 C1, Client2 C2
Where D.Sett_No = S.Sett_No 
And D.Sett_Type = S.Sett_Type 
And End_Date <= @Sauda_Date + ' 23:59:59'
And Sec_Payin > @Sauda_Date + ' 23:59' 
And C2.Cl_Code = C2.Cl_Code
And C2.Party_Code = D.Party_Code
And Filler2 = 1 And DrCr = 'C'
And TrType <> 906 
And ShareType <> 'AUCTION'
--AND C2.DUMMY10 = 'ONLINE'
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Scrip_Cd, D.Series

Insert Into #Online_StockFileDelNse_ORS1 
Select Sett_No=D.ISett_No, Sett_Type=D.ISett_Type, D.Party_Code, D.Scrip_Cd, D.Series, RQty = 0, IQty = Sum(Qty) 
From DelTrans D, Sett_Mst S, Client1 C1, Client2 C2
Where D.ISett_No = S.Sett_No 
And D.ISett_Type = S.Sett_Type 
And End_Date <= @Sauda_Date + ' 23:59:59'
And Sec_Payin > @Sauda_Date + ' 23:59' 
And C2.Cl_Code = C2.Cl_Code
And C2.Party_Code = D.Party_Code
And Filler2 = 1 And DrCr = 'D'
And TrType in (907, 1000) And Delivered = 'G'
And ShareType <> 'AUCTION'
--AND C2.DUMMY10 = 'ONLINE'
Group By D.ISett_No, D.ISett_Type, D.Party_Code, D.Scrip_Cd, D.Series

Select D.Sett_No, D.Sett_Type, D.Party_Code, D.Scrip_Cd, D.Series, RQty = Sum(Qty) , IQty = 0 
Into #Online_StockFileDelBse_ORS1 From AngelBSECM.bsedb_ab.dbo.DelTrans D, AngelBSECM.bsedb_ab.dbo.Sett_Mst S, AngelBSECM.bsedb_ab.dbo.Client1 C1, AngelBSECM.bsedb_ab.dbo.Client2 C2
Where D.Sett_No = S.Sett_No 
And D.Sett_Type = S.Sett_Type 
And End_Date <= @Sauda_Date + ' 23:59:59'
And Sec_Payin > @Sauda_Date + ' 23:59' 
And C2.Cl_Code = C2.Cl_Code
And C2.Party_Code = D.Party_Code
And Filler2 = 1 And DrCr = 'C'
And TrType <> 906 
And ShareType <> 'AUCTION'
--AND C2.DUMMY10 = 'ONLINE'
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Scrip_Cd, D.Series

Insert Into #Online_StockFileDelBse_ORS1 
Select Sett_No=D.ISett_No, Sett_Type=D.ISett_Type, D.Party_Code, D.Scrip_Cd, D.Series, RQty = 0, IQty = Sum(Qty) 
From AngelBSECM.bsedb_ab.dbo.DelTrans D, AngelBSECM.bsedb_ab.dbo.Sett_Mst S, AngelBSECM.bsedb_ab.dbo.Client1 C1, AngelBSECM.bsedb_ab.dbo.Client2 C2
Where D.ISett_No = S.Sett_No 
And D.ISett_Type = S.Sett_Type 
And End_Date <= @Sauda_Date + ' 23:59:59'
And Sec_Payin > @Sauda_Date + ' 23:59' 
And C2.Cl_Code = C2.Cl_Code
And C2.Party_Code = D.Party_Code
And Filler2 = 1 And DrCr = 'D'
And TrType in (907, 1000) And Delivered = 'G'
And ShareType <> 'AUCTION'
--AND C2.DUMMY10 = 'ONLINE'
Group By D.ISett_No, D.ISett_Type, D.Party_Code, D.Scrip_Cd, D.Series

Select Sett_No, Sett_Type, Party_Code, Scrip_Cd, Series, Qty = Sum(RQty+IQty) 
Into #Online_StockFileDelNse_ORS From #Online_StockFileDelNse_ORS1
Group By Sett_No, Sett_Type, Party_Code, Scrip_Cd, Series

Select Sett_No, Sett_Type, Party_Code, Scrip_Cd, Series, Qty = Sum(RQty+IQty) 
Into #Online_StockFileDelBse_ORS From #Online_StockFileDelBse_ORS1
Group By Sett_No, Sett_Type, Party_Code, Scrip_Cd, Series

/*SELECT BEGINS HERE*/

Select Exchange='NSE',

--Sauda_Date=Replace(Convert(Varchar,Sauda_Date,103),'/',''),
Sauda_Date=Replace(Convert(Varchar,getdate(),103),'/',''),

S.Sett_Type,S.Sett_No,Branch_Cd/*='XXXXXXXXXX'*/,
S.Party_Code,SCRIP_CD=RTrim(S.SCRIP_CD)+Rtrim(S.Series),

TPQty=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),
TSQty=(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
      End),

--PQty=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),
PQty = Sum(Case When sauda_date like @Sauda_Date + '%' Then
						(Case When Sell_Buy = 1 Then TradeQty Else 0 End) Else 0 End),

SQty =  Sum(Case When sauda_date like @Sauda_Date + '%' Then
				(Case When IsNull(D.Qty,0) > (Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           	Then 0 
			   Else (Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
		      End) Else 0 End),
/*SQty=(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
      End),*/

TPAmt=Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),
TSAmt=(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
	   Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
     Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Else 0 
	End)*(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
                   Then 0 
	           Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
              End),

--PAmt=Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),
PAmt = Sum(Case When sauda_date like @Sauda_Date + '%' Then
							(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End) Else 0 End),
SAmt = Sum(Case When sauda_date like @Sauda_Date + '%' Then
				(Case When (Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
				Then (Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
				(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
				Else 0 
				End)*(Case When IsNull(D.Qty,0) > (Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
				Then 0 
				Else (Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
				End) Else 0 End),
/*SAmt=(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
	   Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
                Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Else 0 
	End)*(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
                   Then 0 
	           Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
              End),*/

TPRate=(Case When Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0 
	     Then Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/
                  Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) 
             Else 0 
	End),

TSRate=(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
	     Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
                  Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
             Else 0 
	End)

/*, Month=Month(Sec_PayIn), Year=Year(Sec_PayIn)*/

From Sett_Mst M, CLIENT1 C1, CLIENT2 C2, 

Settlement S Left Outer Join #Online_StockFileDelNse_ORS D 
On ( S.Sett_No = D.Sett_No 
And S.Sett_Type = D.Sett_Type 
And S.Scrip_Cd = D.Scrip_Cd 
And S.Series = D.Series )
Where M.Sett_No = S.Sett_No 
And M.Sett_Type = S.Sett_Type 
And C1.Cl_Code = C2.Cl_Code
And C2.Party_Code = S.Party_Code
And End_Date <= @Sauda_Date + ' 23:59:59'
And Sec_Payin > @Sauda_Date + ' 23:59' 
And M.Sett_Type = 'N'
--AND C2.DUMMY10 = 'ONLINE'

Group By
	/*Replace(Convert(Varchar,Sauda_Date,103),'/',''),*/
	S.Sett_No,S.Sett_Type, branch_cd, S.Party_Code,S.Scrip_Cd,S.Series,D.Qty/*,
	Month(Sec_PayIn), Year(Sec_PayIn)*/

Having Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0 
    Or (Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
      End) > 0


Union All


Select Exchange='BSE',

--Sauda_Date=Replace(Convert(Varchar,Sauda_Date,103),'/',''),
Sauda_Date=Replace(Convert(Varchar,getdate(),103),'/',''),

S.Sett_Type,S.Sett_No,Branch_Cd/*='XXXXXXXXXX'*/,
S.Party_Code,S.Scrip_Cd,

TPQty=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),

TSQty=(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
      End),

--PQty=Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),
PQty = Sum(Case When sauda_date like @Sauda_Date + '%' Then
						(Case When Sell_Buy = 1 Then TradeQty Else 0 End) Else 0 End),

SQty = Sum(Case When sauda_date like @Sauda_Date + '%' Then
				(Case When IsNull(D.Qty,0) > (Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
				Then 0 
				Else (Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
				End) Else 0 End),
/*SQty=(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
      End),*/

TPAmt=Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),

TSAmt=(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
	   Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
                Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Else 0 
	End)*(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
                   Then 0 
	           Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
              End),

--PAmt=Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End),
PAmt = Sum(Case When sauda_date like @Sauda_Date + '%' Then
				(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End) Else 0 End),

SAmt = Sum(Case When sauda_date like @Sauda_Date + '%' Then
						(Case When (Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
						Then (Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
						(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
						Else 0 
						End)*(Case When IsNull(D.Qty,0) > (Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
						Then 0 
						Else (Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
						End) Else 0 End),

/*SAmt=(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
	   Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
                Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Else 0 
	End)*(Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
                   Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
              End),*/

TPRate=(Case When Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0 
	     Then Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)/
                  Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) 
             Else 0 
	End),

TSRate=(Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 
	     Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)/
                  Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
             Else 0 
	End)/*, Month=Month(Sec_PayIn), Year=Year(Sec_PayIn)*/

From AngelBSECM.bsedb_ab.dbo.Sett_Mst M, AngelBSECM.bsedb_ab.dbo.CLIENT1 C1, AngelBSECM.bsedb_ab.dbo.CLIENT2 C2, 

AngelBSECM.bsedb_ab.dbo.Settlement S Left Outer Join #Online_StockFileDelBse_ORS D 
On ( S.Sett_No = D.Sett_No 
And S.Sett_Type = D.Sett_Type 
And S.Scrip_Cd = D.Scrip_Cd 
And S.Series = D.Series )
Where M.Sett_No = S.Sett_No 
And M.Sett_Type = S.Sett_Type 
And C1.Cl_Code = C2.Cl_Code
And C2.Party_Code = S.Party_Code
And End_Date <= @Sauda_Date + ' 23:59'
And Sec_Payin > @Sauda_Date + ' 23:59' 
And M.Sett_Type = 'D'
--AND C2.DUMMY10 = 'ONLINE'

Group By
	/*Replace(Convert(Varchar,Sauda_Date,103),'/',''),*/
	S.Sett_No,S.Sett_Type, branch_cd, S.Party_Code,S.Scrip_Cd,D.Qty/*,
	Month(Sec_PayIn), Year(Sec_PayIn)*/

Having Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0 
    Or (Case When IsNull(D.Qty,0) > Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) 
           Then 0 
	   Else Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) - IsNull(D.Qty,0) 
      End) > 0
Order By S.Party_Code,S.Scrip_Cd,S.Sett_Type,S.Sett_No

GO
