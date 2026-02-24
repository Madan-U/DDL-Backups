-- Object: PROCEDURE dbo.Rpt_NseDelHoldSum
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelHoldSum (  
@StatusId Varchar(15),@StatusName Varchar(25),@HoldDate varchar(11),@BDpID Varchar(8),@BCltDpID Varchar(16))  
AS  
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelTrans D,
Client1 C1,Client2 C2
where BDpId = @BDpId and BCltDpId = @BCltDpId   
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
And Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType In(904,905,909)
And ShareType <> 'AUCTION'
And @StatusName = 
	  (case 
	        when @StatusId = 'BRANCH' then c1.branch_cd
	        when @StatusId = 'SUBBROKER' then c1.sub_broker
	        when @StatusId = 'Trader' then c1.Trader
	        when @StatusId = 'Family' then c1.Family
	        when @StatusId = 'Area' then c1.Area
	        when @StatusId = 'Region' then c1.Region
	        when @StatusId = 'Client' then c2.party_code
	  else 
	        'BROKER'
	  End)   
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0   
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type

GO
