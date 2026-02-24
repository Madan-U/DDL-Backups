-- Object: PROCEDURE dbo.Report_InsDelPayOut
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc Report_InsDelPayOut(@StatusId Varchar(15),@StatusName Varchar(25),@FromTrDate Varchar(11),@ToTrDate Varchar(11),@FParty_Cd Varchar(10),@TParty_Cd Varchar(10),@Branch Varchar(10)) As
Select D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name=Long_Name+' (' + Branch_Cd + ') ' + ' (' + sub_Broker + ') ',IsIn=CertNo,Scrip_Cd,Qty=Sum(Qty),
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
From MSajag.DBO.DelTrans_Report D,
MSajag.DBO.Client2_Report C2 , MSajag.DBO.Client1_Report C1, MSajag.DBO.Sett_Mst S,MSajag.DBO.DeliveryDp Dp 
Where TransDate >= @FromTrDate And TransDate <= @ToTrDate + ' 23:59:59' And DrCr = 'D' And Filler2 = 1
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd
And C1.Cl_Code = C2.Cl_Code and C2.Party_code = D.Party_Code And D.Sett_No = S.Sett_No
And D.Sett_Type = S.Sett_Type And Dp.DpId = D.BDpId and Dp.DpCltNo = D.BCltDpID and ( Delivered in ('G','D') or Description not Like '%POOL%')
And C1.Branch_cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End )
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End )
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End )
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End )
And C2.Party_code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End )
Group By D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name+' (' + Branch_Cd + ') ' + ' (' + sub_Broker + ') ',CertNo,Scrip_Cd,CltDpId,DpCltNo,D.DpID,DP.DpID,Isett_No,Isett_Type,
S.Sett_No,TransDate,Delivered,Sec_PayOut, TrType,Reason

GO
