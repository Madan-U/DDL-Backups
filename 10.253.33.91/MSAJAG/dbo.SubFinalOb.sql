-- Object: PROCEDURE dbo.SubFinalOb
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SubFinalOb    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOb    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOb    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOb    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOb    Script Date: 12/27/00 8:59:16 PM ******/

/****** Object:  Stored Procedure dbo.SubFinalOb    Script Date: 11/24/2000 4:05:15 PM ******/
CREATE Proc SubFinalOb (@Sett_No varchar(7),@Sett_Type Varchar(3),@Party Varchar(10),@UserId varchar(8)) As
delete from FinOb where sett_no = @Sett_No and sett_Type = @Sett_Type 
/*insert into FinOb select Sett_no,Sett_Type,Getdate(),PQty = ( Select isnull(Sum(Tradeqty),0) From Settlement  where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 1),
PAmt = ( Select isnull(Sum(Tradeqty*marketrate),0) From Settlement where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 1),
SQty = ( Select isnull(Sum(Tradeqty),0) From Settlement  where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 2),
SAmt = ( Select isnull(Sum(Tradeqty*marketrate),0) From Settlement  where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 2)
from Settlement s where sett_no = @Sett_No and sett_Type = @Sett_Type and  billno > 0 and tradeqty > 0
group by sett_no,sett_Type*/
insert into FinOb select Sett_no,Sett_type,GetDate(),Isnull(Sum(PQty) ,0),Isnull(Sum(PAmt) ,0),Isnull(Sum(Sqty) ,0),Isnull(Sum(SAmt) ,0) from SubTempFinalObl
where sett_no = @Sett_No and sett_Type = @Sett_Type and party_code like @Party + '%' and User_Id like @userid + '%'
group by sett_no,sett_Type

GO
