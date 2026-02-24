-- Object: PROCEDURE dbo.SpSettBillHeaderP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpSettBillHeaderP    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeaderP    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeaderP    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeaderP    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeaderP    Script Date: 12/27/00 8:59:04 PM ******/

CREATE Proc SpSettBillHeaderP ( @Sett_no Varchar(7),@PartyCode varchar(10)) As
select distinct tempsettalbmsum.party_code,short_name= isnull(client1.short_name,0),sett_no=@sett_no,
sett_type =  'W', 
start_date = ( Select Start_Date from sett_mst where sett_no = @sett_No and sett_type =  'P' )
,end_date= ( Select End_Date from sett_mst where sett_no = @sett_No and sett_type =  'P' ) ,
l_address1=isnull(client1.l_address1,0),l_address2=isnull(client1.l_address2,0),l_address3=isnull(client1.l_address3,0),l_city=isnull(client1.l_city,0) ,l_zip = isnull(client1.l_zip,0)/*l_zip = added by bhagyashree*/
from tempsettalbmsum, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and tempsettalbmsum.party_code = client2.party_code
and tempsettalbmsum.sett_no = sett_mst.sett_no
and tempsettalbmsum.sett_type = sett_mst.sett_Type
and tempsettalbmsum.sett_no in  ( ( select min(sett_no) from sett_mst where sett_no > @sett_no and sett_type = 'W' ),@sett_no)
and tempsettalbmsum.sett_type = 'P'
and tempsettalbmsum.party_code = @PartyCode
and client2.printf = 0

GO
