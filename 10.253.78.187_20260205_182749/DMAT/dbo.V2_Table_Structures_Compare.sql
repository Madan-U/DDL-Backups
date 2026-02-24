-- Object: PROCEDURE dbo.V2_Table_Structures_Compare
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE Proc [dbo].[V2_Table_Structures_Compare]
@OldServerName varchar(100) 

As

/*==========================================================================
Exec V2_Table_Structures_Compare
        @OldServerName = 'encsrv1' 
==========================================================================*/


Declare 
        @dbname varchar(100), 
        @sql varchar(8000) 

Set @dbname = db_name()

Set @sql = " Exec V2_Table_Structures_UP "
Exec (@sql)

Set @sql = " Exec " + @OldServerName + "." + @dbname + ".dbo.V2_Table_Structures_UP "
Exec (@sql)

Set @sql = " "

Set @sql = @sql + "        Select "
Set @sql = @sql + "                N_Table_Name = isnull(N.Table_Name,O.Table_Name), "
Set @sql = @sql + "                N_Column_name = N.Column_name, "
Set @sql = @sql + "                N_Type = N.Type, "
Set @sql = @sql + "                N_Computed = N.Computed, "
Set @sql = @sql + "                N_Length = N.Length, "
Set @sql = @sql + "                N_Prec = N.Prec, "
Set @sql = @sql + "                N_Scale = N.Scale, "
Set @sql = @sql + "                N_Nullable  = N.Nullable, "
Set @sql = @sql + "                O_Table_Name = isnull(O.Table_Name,N.Table_Name), "
Set @sql = @sql + "                O_Column_name = O.Column_name, "
Set @sql = @sql + "                O_Type = O.Type, "
Set @sql = @sql + "                O_Computed = O.Computed, "
Set @sql = @sql + "                O_Length = O.Length, "
Set @sql = @sql + "                O_Prec = O.Prec, "
Set @sql = @sql + "                O_Scale = O.Scale, "
Set @sql = @sql + "                O_Nullable  = O.Nullable "
Set @sql = @sql + "        From V2_Table_Structures N full outer join " + @OldServerName + "." + @dbname + ".dbo.V2_Table_Structures O "
Set @sql = @sql + "        on "
Set @sql = @sql + "        ( "
Set @sql = @sql + "                N.Table_Name = O.Table_Name "
Set @sql = @sql + "                AND N.Column_Name = O.Column_Name "
Set @sql = @sql + "        ) "
Set @sql = @sql + "        Where "
Set @sql = @sql + "        ( "
Set @sql = @sql + "                N.Column_Name is null OR "
Set @sql = @sql + "                O.Column_Name is null OR "
Set @sql = @sql + "                N.Type <> O.Type OR "
Set @sql = @sql + "                N.Computed <> O.Computed OR "
Set @sql = @sql + "                N.Length <> O.Length OR "
Set @sql = @sql + "                N.Prec <> O.Prec OR "
Set @sql = @sql + "                N.Scale <> O.Scale OR "
Set @sql = @sql + "                N.Nullable  <> O.Nullable "
Set @sql = @sql + "        ) "
Set @sql = @sql + "        And "
Set @sql = @sql + "        ( "
Set @sql = @sql + "                N.Table_Name In (Select Distinct Table_Name From encsrv1.msajag.dbo.V2_Table_Structures) OR "
Set @sql = @sql + "                O.Table_Name In (Select Distinct Table_Name From V2_Table_Structures) "
Set @sql = @sql + "        ) "
Set @sql = @sql + "        Order by N_Table_Name,O_Table_Name "

Exec (@sql)

GO
