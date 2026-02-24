-- Object: PROCEDURE dbo.CBO_GET_LENGTH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE       PROCEDURE [dbo].[CBO_GET_LENGTH]
(
	@NAME VARCHAR(50) = '',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	
	select name,prec from syscolumns where id in(select id from sysobjects where xtype='u'  and name ='" + @NAME + "')


--select name,prec from syscolumns where id in(select id from sysobjects where xtype='u'  and name ='State_Master'

--select name,prec from syscolumns where id in(select id from sysobjects where xtype='u'  and name ='State_Master')

GO
