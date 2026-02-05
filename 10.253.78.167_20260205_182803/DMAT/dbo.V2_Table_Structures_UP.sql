-- Object: PROCEDURE dbo.V2_Table_Structures_UP
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE Proc [dbo].[V2_Table_Structures_UP] 

as 

Declare 
        @objname nvarchar(776),
        @CMCur Cursor

Truncate Table V2_Table_Structures

Set @CMCur = Cursor For
        select Table_Name = upper(Name) From Sysobjects where xtype = 'U' AND NAME NOT LIKE 'BAK_%' order by 1
Open @CMCur
Fetch Next From @CMCur Into @objname
While @@Fetch_Status = 0 
Begin
	Insert Into V2_Table_Structures EXEC sp_help_table_structure @objname
	Fetch Next From @CMCur Into @objname
End
Close @CMCur
Deallocate @CMCur

GO
