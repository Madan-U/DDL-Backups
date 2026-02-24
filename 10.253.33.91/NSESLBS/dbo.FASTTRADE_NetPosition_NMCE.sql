-- Object: PROCEDURE dbo.FASTTRADE_NetPosition_NMCE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


Create Proc FASTTRADE_NetPosition_NMCE (@TradeDate Varchar(11)) 
As
Select 
	
	TMCode				= BFoOwner.MemberCode,
	GroupId 			= '1',
	ClientType			= 'N',
	ClientCd			= Party_Code,
	SeriesCd			= F.Series_Code,
	SeriesId			= F.Series_Id,
	NetQty				= Sum(PQty-SQty),
	Amount				= Sum(PRate*PQty - SRate*SQty)*S.Multiplier

From
	NMCE.dbo.BFoBillValan F (nolock), NMCE.dbo.BFoOwner BFoOwner, NMCE.dbo.BFOScrip2 S
Where
	Sauda_Date like @TradeDate + '%'
	And F.Product_Type = S.Product_Type
	And F.Product_Code = S.Product_Code
	And F.Series_Code = S.Series_Code
	And F.Series_id = S.Series_id
Group By
	BFoOwner.MemberCode,
	Party_Code,
	F.Series_Code,
	F.Series_Id,
	S.Multiplier

Having
	Sum(PQty-SQty) <> 0
Order By
	Party_Code,
	F.Series_Code,
	F.Series_Id

GO
