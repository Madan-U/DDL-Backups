-- Object: PROCEDURE dbo.SpHistBillHeaderAlbm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpHistBillHeaderAlbm    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillHeaderAlbm    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillHeaderAlbm    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillHeaderAlbm    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpHistBillHeaderAlbm    Script Date: 12/27/00 8:59:04 PM ******/

CREATE proc SpHistBillHeaderAlbm (@Sett_No varchar(10), @Sett_Type varchar(2), @Party Varchar(7))  as
select distinct History.party_code,short_name= isnull(client1.short_name,0),History.contractno,sett_no = @sett_no,
sett_type = ( CASE WHEN @SETT_TYPE = 'L' 
         THEN 'N'
         ELSE @SETT_TYPE
                      END ), 
start_date = ( Select Start_Date from sett_mst where sett_no = @sett_No and sett_type = ( CASE WHEN @SETT_TYPE = 'L' 
         THEN 'N'
         ELSE @SETT_TYPE
                      END ))
,end_date= ( Select End_Date from sett_mst where sett_no = @sett_No and sett_type = ( CASE WHEN @SETT_TYPE = 'L' 
         THEN 'N'
         ELSE @SETT_TYPE
                      END )) ,l_address1=isnull(client1.l_address1,0),l_address2=isnull(client1.l_address2,0),l_address3=isnull(client1.l_address3,0),l_city=isnull(client1.l_city,0),l_zip=isnull(client1.l_zip,0) /*added by bhagyashree on 15-9-2000*/
from History, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and History.party_code = client2.party_code
and History.sett_no = sett_mst.sett_no
and History.sett_type = sett_mst.sett_Type
and History.sett_no In ( @Sett_No,( select Min(sett_no) from sett_mst where sett_no > @Sett_No))
and History.sett_type = @Sett_Type
and history.Party_Code = @Party
and client2.printf = 0

GO
