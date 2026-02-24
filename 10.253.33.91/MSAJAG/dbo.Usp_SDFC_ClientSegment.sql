-- Object: PROCEDURE dbo.Usp_SDFC_ClientSegment
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--exec Usp_SDFC_ClientSegment 'H44094'
CREATE Proc Usp_SDFC_ClientSegment
@ClientCode varchar (20)
As
BEGIN


select cl_code,Exchange,Segment,InActive_From,Deactive_Remarks from Client_brok_details 
where Cl_Code=@ClientCode

END

GO
