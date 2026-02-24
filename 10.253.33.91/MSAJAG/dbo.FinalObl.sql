-- Object: PROCEDURE dbo.FinalObl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.FinalObl    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FinalObl    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FinalObl    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.FinalObl    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.FinalObl    Script Date: 12/27/00 8:58:49 PM ******/

CREATE Proc FinalObl (@sett_no varchar(7),@Sett_type Varchar(2),@Party Varchar(10),@User Varchar(10)) as 
select sett_no,Sett_type,Scrip_cd,series,PQty=Sum(pqty),PAmt=sum(Pamt),SQty=Sum(Sqty),SAmt=Sum(Samt),
NQty=Sum(PQty - Sqty),NAmt=Sum(Pamt-Samt) from FinalOblCsv
where party_code Like @Party+'%' and user_id like @user+'%' and sett_no = @Sett_no and sett_type = @Sett_Type
group by sett_no,Sett_type,scrip_cd,series

GO
