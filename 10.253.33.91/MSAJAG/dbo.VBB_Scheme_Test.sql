-- Object: PROCEDURE dbo.VBB_Scheme_Test
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE Procedure [dbo].[VBB_Scheme_Test]  
As  
  
--Truncate temp tables  
  
Truncate table tbl_Scheme_Mapping_NSECURFO_tmp  
Truncate table tbl_Scheme_Mapping_MCDX_tmp  
  
Insert into tbl_Scheme_Mapping_NSECURFO_tmp SELECT *  FROM OPENQUERY([AngelFO] , 'Select Distinct SP_Party_Code ,SP_Date_From,SP_Computation_Level,SP_DATE_TO,SP_Scheme_Id from NSECURFO.DBO.Scheme_Mapping with (nolock) where  SP_Computation_Level = ''o'' and SP_DATE_TO >= GETDATE()')  
  
Insert into tbl_Scheme_Mapping_MCDX_tmp SELECT *  FROM OPENQUERY([AngelCommodity] , 'Select Distinct SP_Party_Code ,SP_Date_From,SP_Computation_Level,SP_DATE_TO,SP_Scheme_Id from MCDX.DBO.Scheme_Mapping with (nolock) where  SP_Computation_Level = ''o'' and
 SP_DATE_TO >= GETDATE()')

GO
