-- Object: PROCEDURE dbo.CBO_ADDEDIT_CLIENTBROKSCHEME
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE   PROCEDURE [dbo].[CBO_ADDEDIT_CLIENTBROKSCHEME]
(
     
                                                            
	@SCHEME_ID    varchar(16)='',
	@PARTY_CODE   varchar(10),
	@Table_No     varchar(5),
	@Scheme_Type  varchar(5),
	@Scrip_Cd     varchar(12),
	@Trade_Type   varchar(3),
	@BrokScheme   varchar(1),
	@To_Date      DATETIME='',
	@STATUSID     VARCHAR(25)='BROKER',
	@STATUSNAME   VARCHAR(25)='BROKER',
	@FLAG         VARCHAR(3)
)

AS
DECLARE 
@strSql   VARCHAR(2000),
@strTEMP  VARCHAR (200),
@strTEMP2 VARCHAR (200),
@strDATE VARCHAR(20) 

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END

SET @strSql ="Select set @strDATE= convert(varchar,getdate(),103)"
EXEC(@strSql) 

	IF @Scheme_Type = "TRD"  
		BEGIN
		IF @BrokScheme = '0'
			BEGIN
			SET @strSql = "Select @strTEMP= Table_No from Broktable where Table_No = "+  @Table_No + " and Trd_Del='T'"
			END
		ELSE
			BEGIN
			SET @strSql = "Select @strTEMP= Table_No from Broktable where Table_No = "+  @Table_No + " and Trd_Del='F'"
			END
		END
	ELSE
		BEGIN
		SET @strSql = "Select @strTEMP= Table_No from Broktable where Table_No = "+  @Table_No + " and Trd_Del='D'"	
		END
		EXEC(@strSql)	




	
		IF  @strTEMP=NULL
		BEGIN
			SET @strSql = "Select @strTEMP2=Scheme_id from ClientBrok_Scheme where party_code='" + @PARTY_CODE +"' and trade_type='" + @Trade_Type +"' and scheme_type='" + @Scheme_Type + "' and "
			SET @strSql = @strSql + "Scrip_cd ='" + @Scrip_cd + "' and  @To_Date > getdate()"
			EXEC(@strSql)
				IF @strTEMP2=NULL	
				BEGIN
					IF @Scheme_Type = "TRD"  
					BEGIN
					SET @strSql = " Update Client2 Set Table_No = '" + @Table_No + "', Brok_Scheme = " + @BrokScheme + " Where Party_Code = '" + @PARTY_CODE + "'" 
					END
					ELSE
					BEGIN
					SET @strSql = " Update Client2 Set Sub_TableNo = '" + @Table_No + "' Where Party_Code = '" + @PARTY_CODE + "'" 						
					END	
					EXEC(@strSql)
					--inserting new entry to clientbrok_scheme table
					SET @strSql = "Insert into ClientBrok_Scheme "
					SET @strSql = @strSql + " (Party_code,Table_No,Scheme_Type,Scrip_Cd,Trade_Type,BrokScheme,From_Date,To_Date)"
					SET @strSql = @strSql + " values "
					SET @strSql = @strSql + " ('" +  @Party_code + "'," + @Table_No + ",'" + @Scheme_Type + "','" + @Scrip_Cd + "','"
					SET @strSql = @strSql + @Trade_Type + "','" + @BrokScheme + "','" + @strDATE + " 00:00:00','Dec 31 2049 23:59:00')"
					EXEC(@strSql)
				END
		END

GO
