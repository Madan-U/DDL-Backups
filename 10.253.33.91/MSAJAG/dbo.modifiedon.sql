-- Object: PROCEDURE dbo.modifiedon
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc  modifiedon   
(  
@TODATE varchar (20)  
  
)  
as  
begin  
select  
[Cl_Code]=a.cl_code,  
[Modifiedon]=A.Modifiedon,  
[Exchange]=A.Exchange,  
[Deactive_value]=A.Deactive_value,  
[mobile_pager]=B.mobile_pager  
  
  
FROM CLIENT_BROK_DETAILS A JOIN Client_Details B  
ON  A.Cl_Code=B.cl_code AND A.Modifiedon >=@TODATE  AND  A.Modifiedon <=@TODATE + ' 23:59:59'   
AND A.Exchange IN (  
'MCX',  
'NCX'  
  
)AND Deactive_value='R'  
  
END

GO
