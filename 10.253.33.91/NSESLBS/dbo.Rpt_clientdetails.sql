-- Object: PROCEDURE dbo.Rpt_clientdetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 01/15/2005 1:28:27 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 12/16/2003 2:31:44 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 01/14/2002 20:39:21 ******/
/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 01/04/1980 1:40:41 Am ******/
/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 11/28/2001 12:23:49 Pm ******/
/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 2/17/01 5:19:41 Pm ******/
/****** Object:  Stored Procedure Dbo.rpt_clientdetails    Script Date: 04/27/2001 4:32:34 Pm ******/
/* Report : Allpartyledger
   File : Cumledger.asp
*/
/* Displays Details Of A Client */
/*changed By Mousami On 01/03/2001
  Removed Hardcoding 
 For Sharedatabase 
Changed By Kalpana On 19/09/2002 
Short_name Changed To Longname
*/
 
Create  Procedure Rpt_clientdetails
@clcode Varchar(6)
As
Select C1.res_phone1,off_phone1, C2.tran_cat, Short_name = Long_name, Branch_cd, Sub_broker, Family, Trader, Cl_type
From Client1 C1,client2 C2 
Where C1.cl_code=@clcode And C2.cl_code=@clcode

GO
