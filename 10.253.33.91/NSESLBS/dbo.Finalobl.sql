-- Object: PROCEDURE dbo.Finalobl
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Finalobl (@sett_no Varchar(7),@sett_type Varchar(2),@party Varchar(10),@user Varchar(10)) As   
Select Sett_no,sett_type,scrip_cd,series,pqty=sum(pqty),pamt=sum(pamt),sqty=sum(sqty),samt=sum(samt),  
Nqty=sum(pqty - Sqty),namt=sum(pamt-samt) From Finaloblcsv  
Where Party_code Like @party+'%' And User_id Like @user+'%' And Sett_no = @sett_no And Sett_type = @sett_type  
Group By Sett_no,sett_type,scrip_cd,series

GO
