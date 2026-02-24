-- Object: PROCEDURE dbo.AccValanHist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 09/07/2001 11:08:41 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 7/1/01 2:26:14 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 06/26/2001 8:47:27 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 3/17/01 9:55:42 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 3/21/01 12:49:58 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 20-Mar-01 11:38:41 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 2/5/01 12:06:05 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 12/27/00 8:59:05 PM ******/


/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 1/6/2001 3:59:12 PM ******/

/****** Object:  Stored Procedure dbo.AccValanHist    Script Date: 1/3/2001 6:22:24 PM ******/
CREATE proc AccValanHist (@sett_no varchar(7),@sett_type varchar(2)) as
EXEC ACCALBMNEWMARGIN @sett_no,@sett_type 
EXEC ACCALBMOLDMARGIN @sett_no,@sett_type 
select * from temphistsum where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from oppalbm where sett_no = @sett_no  and sett_type = @sett_type
union all
select * from PlusOneAlbm where sett_no =  ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = @sett_Type ) and sett_type = @sett_type
UNION ALL
SELECT P.party_code,SELL_BUY=2,pamt=0,samt=Isnull(SUM(FIXMARGIN+ADDMAR),0),sett_no,sett_type,BILLNO=0,Branch_Cd FROM PARTYOLDMARGIN P, Client1 c1, Client2 c2
where sett_no = @sett_no  and sett_type = @sett_type and C1.Cl_Code = C2.Cl_Code and P.Party_Code = C2.Party_Code
GROUP BY P.PARTY_CODE,SETT_NO,SETT_TYPE,Branch_Cd
UNION ALL
SELECT P.party_code,SELL_BUY=1,pamt=Isnull(SUM(FIXMARGIN+ADDMAR),0),samt=0,sett_no,sett_type,BILLNO=0,Branch_Cd FROM PARTYNEWMARGIN P, Client1 c1, Client2 c2
where sett_no = @sett_no  and sett_type = @sett_type and C1.Cl_Code = C2.Cl_Code and P.Party_Code = C2.Party_Code
GROUP BY P.PARTY_CODE,SETT_NO,SETT_TYPE,Branch_Cd
ORDER BY PARTY_CODE

GO
