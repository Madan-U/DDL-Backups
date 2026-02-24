-- Object: PROCEDURE dbo.collateral_lse
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure collateral_lse

@exchange varchar(5),
@Segment varchar(10),
@fromparty varchar(10),
@toparty varchar(10),
@date varchar(12) 

as


IF  (LEN(@ToParty)=0)  
SET @ToParty = 'zzzzzzzzzz'



SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
Select 
	Party_Code as Party,
	Exchange,
	Segment,
	upper(Coll_Type) as CollaterlType,
	Scrip_Cd as Scrip,
	Isin,
	Cl_Rate as ClosingRate,
	Qty as TotalQty,
	Amount as AmountBeforeHc ,
	Haircut,
	FinalAmount as AmountAfterHc
FROM 
	msajag.dbo.CollateralDetails (nolock)
Where 
	exchange LIKE (Case When @exchange = 'ALL' Then '%' Else @exchange End)
        AND Segment LIKE  (Case When @Segment = 'ALL' Then ('%') Else @Segment End)
        And 
	Party_code Between @fromparty and @toparty and 
	Effdate like @date + '%' and 
	Amount > 0
Order By 
	Party_Code,Coll_Type

GO
