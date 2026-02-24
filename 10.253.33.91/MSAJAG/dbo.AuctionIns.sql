-- Object: PROCEDURE dbo.AuctionIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AuctionIns    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.AuctionIns    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.AuctionIns    Script Date: 20-Mar-01 11:38:43 PM ******/

CREATE Proc AuctionIns (@Sett_No Varchar(7), @Sett_Type Varchar(2), @ASett_No Varchar(7), @ASett_Type Varchar(2)) as 
Insert Into Auction 
select A.sett_no,A.Sett_Type,0,A.Party_Code,A.Scrip_Cd,A.Series,A.ShortQty,C.Cl_Rate,Sell_Buy,Scrip_Cat,
(Case When Sell_Buy = 1 Then 
					A.ShortQty*C.Cl_Rate + (A.ShortQty*C.Cl_Rate*Scrip_Cat)/100
                                else 
					A.ShortQty*C.Cl_Rate - (A.ShortQty*C.Cl_Rate*Scrip_Cat)/100
				end),
@ASett_No,@ASett_type 
From  Client2 C2, AuctionShort A Left Outer Join Closing C
On ( A.Scrip_Cd = C.Scrip_Cd and A.Series = C.Series And 
SysDate = ( Select Max(SysDate) From Closing 
  	    where Scrip_Cd = C.Scrip_Cd and Series = C.Series and 
	    MARKET = ( Case when Sett_type = 'N' then 'Normal' 
		       Else ( Case when Sett_type = 'L' then 'ALBM' 
	 		      Else ( Case when Sett_type = 'W' then 'ODDLOT' 
				else ( Case when Sett_type = 'M' then 'Rolling' 
				           End )	
	 	  	             End )
			      End )				
		       End ) ) )
where Sett_no = @Sett_No and sett_Type = @Sett_Type
and C2.Party_Code = A.Party_Code

GO
