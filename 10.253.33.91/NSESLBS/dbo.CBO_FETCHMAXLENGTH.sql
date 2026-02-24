-- Object: PROCEDURE dbo.CBO_FETCHMAXLENGTH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_FETCHMAXLENGTH 
@TableName varchar(200)

AS


select name,prec from syscolumns where id in(select id from sysobjects where xtype='u'  and name =@TableName)

GO
