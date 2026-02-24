-- Object: PROCEDURE dbo.CLS_ADMIN_MENU
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[CLS_ADMIN_MENU]

 @UCAT [varchar](100)        

AS   

/*

CLS_ADMIN_MENU ''

*/

DECLARE @@SQL VARCHAR(7000)

DECLARE @NewLineChar AS CHAR(2) 



SET @NewLineChar = CHAR(13) + CHAR(10)



SET @@SQL = ""

SET @@SQL = @@SQL + ""

SET @@SQL = @@SQL + "<ul id=""mega"">" + @NewLineChar

SET @@SQL = @@SQL + "    <li><a href=""#"">Admin Management</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>Admin Module</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('0');"">Add New Admin</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "   <li><a href=""#"">User Management</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>User Module</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('1');"">Add New User</a> </p>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('2');"">Edit User</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "   <li><a href=""#"">Authorization</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>Maker Checker Module</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('3');"">User Authorization</a> </p>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('4');"">User Reactivation</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "    <li><a href=""#"">Report Management</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>Report</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('5');"">Add/Edit/Remove Report</a></p>" + @NewLineChar

--SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('6');"">Edit Report</a></p>" + @NewLineChar

--SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('7');"">Remove Report</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "    <li><a href=""#"">Group Management</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>Group</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('8');"">Add/Edit/Remove Group</a></p>" + @NewLineChar

--SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('9');"">Edit Group</a></p>" + @NewLineChar

--SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('8');"">Remove Group</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "    <li><a href=""#"">Category Management</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>Category</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('10');"">Add/Edit/Remove Category</a></p>" + @NewLineChar

--SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('11');"">Edit Category</a></p>" + @NewLineChar

--SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('12');"">Remove Category</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "    <li><a href=""#"">Utilities</a>" + @NewLineChar

SET @@SQL = @@SQL + "        <div>" + @NewLineChar

SET @@SQL = @@SQL + "        <h2>Utilities</h2>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('13');"">Change Password</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('14');"">Change User Password</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('15');"">User Log</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        <p><a href=""#"" onclick=""javascript:ClickME('16');"">Report Log</a></p>" + @NewLineChar

SET @@SQL = @@SQL + "        </div>" + @NewLineChar

SET @@SQL = @@SQL + "    </li>" + @NewLineChar

SET @@SQL = @@SQL + "        </ul>" + @NewLineChar



SELECT  MENUSTRING = @@SQL

GO
