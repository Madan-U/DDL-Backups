-- Object: PROCEDURE dbo.PROC_SHORT_MARGIN_UPLOAD
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[PROC_SHORT_MARGIN_UPLOAD] (@FilePath Varchar(100),@PROCID VARCHAR(50)='') AS            

TRUNCATE TABLE TBL_SHORT_ALLOC_TMP
EXEC Proc_Bulk_Ins_NEW 'TBL_SHORT_ALLOC_TMP', @FilePath, ','

GO
