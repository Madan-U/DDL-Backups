-- Object: PROCEDURE dbo.GenerateInsUpdateScript
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE GenerateInsUpdateScript
@objname nvarchar(776) = NULL
as
SET NOCOUNT ON
DECLARE @objid int

DECLARE @sysobj_type char(2)

SELECT @objid = id, @sysobj_type = xtype from sysobjects where id = object_id(@objname)

DECLARE @colname sysname



SELECT @colname = name from syscolumns where id = @objid and colstat & 1 = 1


-- DISPLAY COLUMN IF TABLE / VIEW

if @sysobj_type in ('S ','U ','V ','TF','IF')

begin

-- SET UP NUMERIC TYPES: THESE WILL HAVE NON-BLANK PREC/SCALE

DECLARE @numtypes nvarchar(80)

DECLARE @avoidlength nvarchar(80)

SELECT @numtypes = N'decimalreal,money,float,numeric,smallmoney'

SELECT @avoidlength = N'int,smallint,datatime,smalldatetime,text,bit'

-- INFO FOR EACH COLUMN

CREATE TABLE #MyProc

(pkey INT NOT NULL IDENTITY (1, 1),

ID INT ,

MyStatement NVARCHAR(4000))



INSERT INTO #MyProc (ID, MyStatement)

SELECT 1, 'CREATE PROCEDURE InsUpd_' + @objname + ' ' 



INSERT INTO #MyProc (ID, MyStatement)

SELECT 

2, '@' + name + ' ' + 

 type_name(xusertype) + ' ' 

 + case when charindex(type_name(xtype),@avoidlength) > 0

 then ''

 else

 case when charindex(type_name(xtype), @numtypes) <= 0 then '(' + convert(varchar(10), length) + ')' else '(' +

 case when charindex(type_name(xtype), @numtypes) > 0

 then convert(varchar(5),ColumnProperty(id, name, 'precision'))

 else '' end + case when charindex(type_name(xtype), @numtypes) > 0 then ',' else ' ' end + 

 case when charindex(type_name(xtype), @numtypes) > 0

 then convert(varchar(5),OdbcScale(xtype,xscale))

 else '' end + ')' end end + ', '



from syscolumns where id = @objid and number = 0 order by colid



update #MyProc set MyStatement = Replace(MyStatement,', ',' ') where 

pkey = (SELECT max(pkey) from #MyProc)



INSERT INTO #MyProc (ID, MyStatement)

SELECT 3, 'AS 

BEGIN 

IF @' + @colname + ' <= 0 

BEGIN'



INSERT INTO #MyProc (ID, MyStatement)

SELECT 3, 'INSERT INTO dbo.' + @objname + ' ('



INSERT INTO #MyProc (ID, MyStatement)

SELECT 4, '' + name + ','

from syscolumns where id = @objid and number = 0 order by colid



DELETE FROM #MyProc 

WHERE ID = 4 and MyStatement like '%' + @colname + '%'



update #MyProc set MyStatement = Replace(MyStatement,',','') where 

pkey = (SELECT max(pkey) from #MyProc)



INSERT INTO #MyProc (ID, MyStatement)

SELECT 5, ' )'



INSERT INTO #MyProc (ID, MyStatement)

SELECT 6, ' VALUES ('



INSERT INTO #MyProc (ID, MyStatement)

SELECT 7, '@' + name + ','

from syscolumns where id = @objid and number = 0 order by colid



DELETE FROM #MyProc 

WHERE ID = 7 and MyStatement like '%' + @colname + '%'



update #MyProc set MyStatement = Replace(MyStatement,'@DateCreated,','GETDATE(),') where 

ID = 7 AND MyStatement like '%@DateCreated,'



update #MyProc set MyStatement = Replace(MyStatement,'@DateModified,','GETDATE(),') where 

ID = 7 AND MyStatement like '%@DateModified,'



update #MyProc set MyStatement = Replace(MyStatement,',','') where 

pkey = (SELECT max(pkey) from #MyProc)







INSERT INTO #MyProc (ID, MyStatement)

SELECT 8, ' )



SET @' + @colname + ' = @@IDENTITY 



SELECT @' + @colname + ' AS ' + @colname + '



END



ELSE

BEGIN'

INSERT INTO #MyProc (ID, MyStatement)

SELECT 9, ' '



INSERT INTO #MyProc (ID, MyStatement)

SELECT 10, 'UPDATE dbo.' + @objname + ' 

SET ' 



INSERT INTO #MyProc (ID, MyStatement)

SELECT 11, '' + name + ' = @' + name + ','

from syscolumns where id = @objid and number = 0 order by colid



DELETE FROM #MyProc 

WHERE ID = 11 and MyStatement like '%' + @colname + '%'



DELETE FROM #MyProc 

WHERE ID = 11 and MyStatement like '%DateCreated %'



update #MyProc set MyStatement = Replace(MyStatement,'@DateModified,','GETDATE(),') where 

ID = 11 AND MyStatement like '%@DateModified,'



update #MyProc set MyStatement = Replace(MyStatement,',','') where 

pkey = (SELECT max(pkey) from #MyProc)



INSERT INTO #MyProc (ID, MyStatement)

SELECT 12, 'WHERE 

' + @colname + '= @' + @colname + ' 



SELECT @' + @colname + ' AS ' + @colname + '

END

END'



SELECT MyStatement from #MyProc ORDER BY ID 

end

GO
