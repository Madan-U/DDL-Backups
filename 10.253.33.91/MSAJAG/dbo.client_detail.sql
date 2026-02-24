-- Object: PROCEDURE dbo.client_detail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc client_detail (

@cl_code varchar (10)
)as begin


select * from Client_Details where cl_code in (@cl_code)
order by cl_code 

end

GO
