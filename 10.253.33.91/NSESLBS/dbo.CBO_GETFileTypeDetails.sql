-- Object: PROCEDURE dbo.CBO_GETFileTypeDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROCEDURE [dbo].[CBO_GETFileTypeDetails] @FileTypeID INT AS 
SELECT * FROM FileTypeDetails WHERE FileTypeId=@FileTypeID

GO
