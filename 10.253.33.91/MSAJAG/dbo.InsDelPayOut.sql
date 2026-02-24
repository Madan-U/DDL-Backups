-- Object: PROCEDURE dbo.InsDelPayOut
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc InsDelPayOut(@StatusId Varchar(15),@StatusName Varchar(25),@FromTrDate Varchar(11),@ToTrDate Varchar(11),@FParty_Cd Varchar(10),@TParty_Cd Varchar(10),@Branch Varchar(10)) As
Select D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name,IsIn=CertNo,Scrip_Cd,Qty=Sum(Qty),
CltDpId = (Case When Delivered = '0' 
	        Then DpCltNo 
	        When ISett_No <> '' And TrType <> 908
	        Then ' '
		Else
	        CltDpID 
  	   End),			 	
DpId =    (Case When Delivered = '0' 
	        Then D.DpID 
	        When ISett_No <> '' And TrType <> 908
	        Then ' '
		Else
	        D.DpID 
  	   End),Isett_No,Isett_Type,
TransDate=Left(Convert(Varchar,TransDate,109),11),Exchg='NSE',
Remark=(Case When Delivered = '0' 
	     Then 'SHARES HELD FOR DEBIT' 
	     When ISett_No <> '' 
	     Then 'TRFD FOR PAY-IN OF ' + (Case When ISett_Type = 'D' or ISett_Type = 'C' 
					       Then 'BSE' Else 'NSE' End) + '/' + Right(ISett_No,3)
	     When TransDate > Sec_PayOut
	     Then 'SHARES HELD FOR DEBIT Released' 
	     When Reason Like 'Excess%' Then 'EXCESS RECEIVED TRANSFER'
	Else '' End)
From MSajag.DBO.DelTrans D,
MSajag.DBO.Client2 C2 , MSajag.DBO.Client1 C1, MSajag.DBO.Sett_Mst S,MSajag.DBO.DeliveryDp Dp 
Where TransDate >= @FromTrDate And TransDate <= @ToTrDate + ' 23:59:59' And DrCr = 'D' And Filler2 = 1
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd
And C1.Cl_Code = C2.Cl_Code and C2.Party_code = D.Party_Code And D.Sett_No = S.Sett_No
And D.Sett_Type = S.Sett_Type And Dp.DpId = D.BDpId and Dp.DpCltNo = D.BCltDpID and ( Delivered in ('G','D') or Description not Like '%POOL%')
And C1.Branch_cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End )
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End )
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End )
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End )
And C2.Party_code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End )
Group By D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name,CertNo,Scrip_Cd,CltDpId,DpCltNo,D.DpID,DP.DpID,Isett_No,Isett_Type,
S.Sett_No,TransDate,Delivered,Sec_PayOut, TrType,Reason
Union All
select d.sett_no,d.sett_type,d.Party_Code,c1.Long_Name,IsIn=' ',D.Scrip_cd,Qty=D.Qty-Sum(isnull(De.qty,0)),
CltDpId=' ', DpId = ' ', Isett_No=' ',ISett_Type=' ',TransDate=Left(Convert(Varchar,Sec_PayOut,109),11),Exchg='NSE',
Remark='MARKET PAYOUT SHORTAGE'
from MSajag.Dbo.Sett_Mst s,MSajag.Dbo.Client2 C2,MSajag.Dbo.Client1 C1,MSajag.Dbo.deliveryClt d Left Outer Join MSajag.Dbo.DelTrans de 
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
     and de.series = d.series and de.party_code = d.party_code And DrCr = 'D' and filler2 = 1 )
where d.inout = 'O' and D.qty > 0 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no = S.Sett_no and d.sett_type = S.Sett_Type 
/*And S.Sec_Payout Like Left(Convert(Varchar,GetDate(),109),11) + '%'*/
And S.Sec_Payout >= @FromTrDate And Sec_PayOut <= @ToTrDate + ' 23:59:59' 
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd
And C1.Branch_cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End )
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End )
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End )
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End )
And C2.Party_code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End )
group by d.sett_no,d.sett_type,d.Party_Code,c1.Long_Name,d.scrip_cd,d.series,D.qty,Sec_PayOut
having D.Qty <> Sum(isnull(De.qty,0))
Order By D.Party_Code,Exchg,CertNo,D.Sett_no,D.Sett_Type,Left(Convert(Varchar,TransDate,109),11)

GO
