-- Object: PROCEDURE dbo.CBO_GETFILEHEADERFOOTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


Create procedure CBO_GETFILEHEADERFOOTER as 

select HeaderFooterID, FileTypeId, [Description], HeadORFoot, [LineNo], [order] from FileHeaderfooter

GO
