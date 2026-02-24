-- Object: PROCEDURE dbo.CBO_GETFileTypeMaster
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROCEDURE CBO_GETFileTypeMaster @FileTypeID INT AS 
SELECT FileTypeID, FileTypeName, Separator, NoOFFields, TableName  FROM FileTypeMaster WHERE FileTypeID=@FileTypeID

GO
