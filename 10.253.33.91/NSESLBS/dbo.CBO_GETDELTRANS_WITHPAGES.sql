-- Object: PROCEDURE dbo.CBO_GETDELTRANS_WITHPAGES
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE  Proc CBO_GETDELTRANS_WITHPAGES @SNO int=0, @PAGESIZE int =50, @FWDBACK CHAR(1) ='F'
AS

	DECLARE @SQL VARCHAR(8000)
	DECLARE @WHERE VARCHAR(100)

	IF @SNO=0
		SET @WHERE='1=1'	
	ELSE
		IF @FWDBACK='B'
			SET @WHERE='SNO<'+ STR(@SNO)
		ELSE
			SET @WHERE='SNO>'+ STR(@SNO)
	


	set @SQL='SELECT TOP '+ str(@PAGESIZE) +'  *  FROM DELTRANS' 
		
	set @SQL=@SQL+ ' WHERE '+@WHERE +'AND RefNo = ''110'' and Sett_No = ''2004046'' and Sett_Type = ''N'' and Party_Code = ''0a141'' and Scrip_CD like ''%'' and Series like ''%''  and Drcr = ''D'' And Filler2 = 1'

	IF @FWDBACK='B'
		set @SQL=@SQL+ ' ORDER BY SNO desc, '
	ELSE
		set @SQL=@SQL+ ' ORDER BY SNO'

exec(@SQL)

GO
