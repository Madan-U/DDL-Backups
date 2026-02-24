-- Object: PROCEDURE dbo.Online_StockFile
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Online_StockFile    Script Date: 04/13/2004 2:28:35 PM ******/

CREATE Proc Online_StockFile (@Sauda_Date Varchar(11))    
As
    select D.Party_Code,SCRIP_CD=RTrim(SCRIP_CD)+Rtrim(Series),Qty=Sum(Qty) from DelTrans D, DeliveryDp Dp, Client1 C1, Client2 C2 
    Where D.BCltDpId = Dp.DpCltNo 
    And D.BDpID = Dp.DpId 
    And Dp.Description Not Like '%POOL%' 
    And DrCr = 'D' 
    And Filler2 = 1 
    And Delivered = '0' 
    And TrType in (904,909) 
    And ShareType = 'DEMAT' 
    And C1.Cl_Code = C2.Cl_Code 
    And C2.Party_Code = D.Party_Code 
    And C2.Dummy10 = 'ONLINE' 
    Group By D.Party_Code,Scrip_Cd,Series 
    Union All 
    select D.Party_Code,Scrip_Cd,Qty=Sum(Qty) from BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp Dp, Client1 C1, Client2 C2 
    Where D.BCltDpId = Dp.DpCltNo 
    And D.BDpID = Dp.DpId 
    And Dp.Description Not Like '%POOL%' 
    And DrCr = 'D' 
    And Filler2 = 1 
    And Delivered = '0' 
    And TrType in (904,909)
    And ShareType = 'DEMAT' 
    And C1.Cl_Code = C2.Cl_Code 
    And C2.Party_Code = D.Party_Code 
    And C2.Dummy10 = 'ONLINE' 
    Group By D.Party_Code,Scrip_Cd 
    Union All 
    Select D.Party_Code, SCRIP_CD=RTrim(SCRIP_CD)+Rtrim(Series), Qty From CollateralDetails D, Client1 C1, Client2 C2 
    Where Segment = 'CAPITAL' And IsIn Like 'IN%' And EffDate Like @Sauda_Date+ '%'
    And C1.Cl_Code = C2.Cl_Code 
    And C2.Party_Code = D.Party_Code 
    And C2.Dummy10 = 'ONLINE' 
    Order By D.Party_Code,Scrip_Cd

GO
