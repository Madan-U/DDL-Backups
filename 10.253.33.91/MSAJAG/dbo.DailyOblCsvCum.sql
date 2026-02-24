-- Object: PROCEDURE dbo.DailyOblCsvCum
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DailyOblCsvCum    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblCsvCum    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblCsvCum    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblCsvCum    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DailyOblCsvCum    Script Date: 12/27/00 8:58:48 PM ******/

Create Proc DailyOblCsvCum (@sett_no varchar(7),@Sett_type Varchar(2),@SDate Varchar(11),@Party Varchar(10),@User Varchar(10)) as 
select sett_no,sett_type,Scrip_cd,series,PQty=Sum(pqty),PAmt=sum(Pamt),SQty=Sum(Sqty),SAmt=Sum(Samt),NQty=Sum(PQty - Sqty),NAmt=Sum(Pamt-Samt),"CUM" from DailyOblCsv
where party_code Like @Party+'%' and user_id like @user+'%' and sett_no = @Sett_no and sett_type = @Sett_Type and Sauda_Date <= @Sdate
group by sett_no,Sett_type,scrip_cd,series
order by sett_no,Sett_type,scrip_cd,series

GO
