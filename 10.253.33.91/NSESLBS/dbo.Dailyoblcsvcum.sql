-- Object: PROCEDURE dbo.Dailyoblcsvcum
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Dailyoblcsvcum (@sett_no Varchar(7),@sett_type Varchar(2),@sdate Varchar(11),@party Varchar(10),@user Varchar(10)) As   
Select Sett_no,sett_type,scrip_cd,series,pqty=sum(pqty),pamt=sum(pamt),sqty=sum(sqty),samt=sum(samt),nqty=sum(pqty - Sqty),namt=sum(pamt-samt),"cum" From Dailyoblcsv  
Where Party_code Like @party+'%' And User_id Like @user+'%' And Sett_no = @sett_no And Sett_type = @sett_type And Sauda_date <= @sdate  
Group By Sett_no,sett_type,scrip_cd,series  
Order By Sett_no,sett_type,scrip_cd,series

GO
