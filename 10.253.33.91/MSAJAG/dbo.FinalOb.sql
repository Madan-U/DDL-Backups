-- Object: PROCEDURE dbo.FinalOb
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.FinalOb    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FinalOb    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FinalOb    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.FinalOb    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.FinalOb    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.FinalOb    Script Date: 11/24/2000 10:45:36 AM ******/
CREATE Proc FinalOb (@Sett_No varchar(7),@Sett_Type Varchar(3)) As
delete from FinOb where sett_no = @Sett_No and sett_Type = @Sett_Type 
/*insert into FinOb select Sett_no,Sett_Type,Getdate(),PQty = ( Select isnull(Sum(Tradeqty),0) From Settlement  where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 1),
PAmt = ( Select isnull(Sum(Tradeqty*marketrate),0) From Settlement where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 1),
SQty = ( Select isnull(Sum(Tradeqty),0) From Settlement  where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 2),
SAmt = ( Select isnull(Sum(Tradeqty*marketrate),0) From Settlement  where s.sett_no = sett_no and S.sett_Type = Sett_Type and sell_buy = 2)
from Settlement s where sett_no = @Sett_No and sett_Type = @Sett_Type and  billno > 0 and tradeqty > 0
group by sett_no,sett_Type*/
insert into FinOb select Sett_no,Sett_type,GetDate(),Isnull(Sum(PQty) ,0),Isnull(Sum(PAmt) ,0),Isnull(Sum(Sqty) ,0),Isnull(Sum(SAmt) ,0) from TempFinalObl
where sett_no = @Sett_No and sett_Type = @Sett_Type 
group by sett_no,sett_Type

GO
