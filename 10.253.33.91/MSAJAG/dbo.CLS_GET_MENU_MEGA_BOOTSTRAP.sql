-- Object: PROCEDURE dbo.CLS_GET_MENU_MEGA_BOOTSTRAP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







CREATE PROCEDURE [dbo].[CLS_GET_MENU_MEGA_BOOTSTRAP]
(
	@STRCATEGORY VARCHAR(20),
	@STRAPPNAME VARCHAR(256),
	@USERID VARCHAR(20)
)
/*
select * from tblreports where fldreportname like '%entry module%'
select * from cls_tblreports where childmap = 2871
	exec CLS_GET_MENU_Nik @STRCATEGORY='546',@STRAPPNAME='/(S(N3WDH3HRMMA1HOJ53WDP55MC))/',@TYPE='C',@UserID='55'
	exec CLS_GET_MENU @STRCATEGORY='546',@STRAPPNAME='/(S(M2WZQ3HJP1S3QGOEPZ5IGYC4))/',@TYPE='C',@UserID='55'

	exec CLS_GET_MENU_MEGA_BOOTSTRAP @STRCATEGORY='546',@STRAPPNAME='/CLASSPLUS/(S(ANA02E5HCPHW4KKEGVE20QCD))/',@UserID='55'
	SELECT FLDADMINAUTO FROM TBLPRADNYAUSERS  (NOLOCK) WHERE FLDAUTO = 55
	select * from tblpradnyausers where fldusername = 'broker'
	EXEC CLS_GET_MENU_MEGA_BOOTSTRAP '546','','55'
	select * from tblcatmenu where fldreportcode = '2871' 
	.
	select * from tblreports
	select * from CLS_TBLREPORTS
*/
AS
DECLARE 
	 @FLDMENUNAME VARCHAR(200)
	,@FLDMENUNAME_1 VARCHAR(200)
	,@FLDGRPNAME VARCHAR(200)
	,@FLDGRPNAME_1 VARCHAR(200)
	,@FLDREPORTNAME VARCHAR(200)
	,@FLDPATH VARCHAR(200)
	,@FLDREPORTCODE VARCHAR(200)
	,@FLDREPORTID VARCHAR(200)
	,@MENUSTRING VARCHAR(MAX)
	,@MENUCUR CURSOR
	,@SUBMENU CURSOR
	,@FLDMENUGRP INT
	,@FLDORDER INT
	,@LOOP INT
	,@LOOPSUB INT
	,@FLDADMINAUTO INT
	,@CHILDCODE VARCHAR(50)
	,@SUBMENUSTRING VARCHAR(8000)
	,@SUBMENUFLDPATH VARCHAR(200)
	,@SUBREPORTNAME VARCHAR(200)
	,@LOGOUTMENU VARCHAR(8000)
	
	SELECT @FLDADMINAUTO = FLDADMINAUTO FROM TBLPRADNYAUSERS  (NOLOCK) WHERE FLDAUTO = @USERID
	
	/* start here for sub & Rel menu*/
	CREATE TABLE #TEMP
	(
		FLDMENUNAME VARCHAR(20),
		FLDREPORTTITLE VARCHAR(100),
		FLDGRPNAME VARCHAR(35),
		FLDREPORTNAME VARCHAR(35),
		FLDPATH VARCHAR(550),
		FLDREPORTCODE INT,
		FLDREPORTID VARCHAR(40),
		FLDMENUGRP VARCHAR(3),
		FLDORDER INT,
		CHILDMAP INT,
		SUBMENU VARCHAR(8000),
		RELMENUSTRING VARCHAR(8000),
		RELMENU VARCHAR(8000)
	)
	/* End here sub & Rel menu*/	
	---------------------------THIS RECORDSET ADDED FOR PLAIN TEXT--------------------------

	INSERT INTO #TEMP SELECT * FROM   
	(SELECT FLDMENUNAME
		,FLDREPORTTITLE = FLDREMARK
		,FLDGRPNAME = REPLACE(FLDGRPNAME,'_',' ')
		,FLDREPORTNAME = LEFT(.DBO.CLS_ProperCase(REPLACE(FLDREPORTNAME,'_',' ')),25)
		,FLDPATH
		,FLDREPORTCODE = A.FLDREPORTCODE
		,FLDREPORTID = F.FLDREPORTCODE
		,FLDMENUGRP = A.FLDMENUGRP
		,FLDORDER, F.CHILDMAP, SUBMENU = '', RELMENU= '', RELMENUSTRING = ''	
	FROM TBLREPORTS A(NOLOCK)
		,TBLREPORTGRP B(NOLOCK)
		,TBLCATMENU C(NOLOCK)
		,TBLCATEGORY D(NOLOCK)
		,TBLMENUHEAD E(NOLOCK)
		,CLS_TBLREPORTS F(NOLOCK)
	WHERE A.FLDMENUGRP = B.FLDMENUGRP
		AND A.FLDREPORTGRP = B.FLDREPORTGRP
		AND C.FLDREPORTCODE = A.FLDREPORTCODE
		AND E.FLDMENUCODE = A.FLDMENUGRP
		AND C.FLDADMINAUTO  = @FLDADMINAUTO
		AND D.FLDCATEGORYCODE = @STRCATEGORY
		AND C.FLDCATEGORYCODE LIKE '%,' + CONVERT(VARCHAR, D.FLDCATEGORYCODE) + ',%'
		AND CHARINDEX('ASPX',CAST(UPPER(FLDPATH) AS VARCHAR(500))) > 0
		AND FLDREPORTPATH = A.FLDPATH
	UNION ALL
	SELECT 
		FLDMENUNAME
		,FLDREPORTTITLE = ''
		,FLDGRPNAME = REPLACE(FLDGRPNAME,'_',' ')
		,FLDREPORTNAME = LEFT(.DBO.CLS_ProperCase(REPLACE(FLDREPORTNAME,'_',' ')),25)  ---LEFT(.DBO.CLS_ProperCase(@FLDREPORTNAME), 25) 
		,FLDPATH
		,FLDREPORTCODE = A.FLDREPORTCODE
		,FLDREPORTID =  UPPER('SUBMENU') + UPPER(FLDTARGET) + CONVERT(VARCHAR,A.FLDREPORTCODE)
		,FLDMENUGRP = A.FLDMENUGRP
		,FLDORDER, CHILDMAP = '', SUBMENU = '', RELMENU= '', RELMENUSTRING = ''	
	FROM TBLREPORTS A(NOLOCK)
		,TBLREPORTGRP B(NOLOCK)
		,TBLCATMENU C(NOLOCK)
		,TBLCATEGORY D(NOLOCK)
		,TBLMENUHEAD E(NOLOCK)
	WHERE A.FLDMENUGRP = B.FLDMENUGRP
		AND A.FLDREPORTGRP = B.FLDREPORTGRP
		AND C.FLDREPORTCODE = A.FLDREPORTCODE
		AND E.FLDMENUCODE = A.FLDMENUGRP
		AND D.FLDCATEGORYCODE = @STRCATEGORY
		AND C.FLDCATEGORYCODE LIKE '%,' + CONVERT(VARCHAR, D.FLDCATEGORYCODE) + ',%'
		AND FLDPATH = ''
		AND FLDTARGET='P'
		AND C.FLDADMINAUTO  = @FLDADMINAUTO

	) A
	ORDER BY 
		FLDMENUGRP, FLDGRPNAME, FLDMENUNAME, A.fldorder

   
    UPDATE T SET T.RELMENU = CTS.REL_MENU FROM #TEMP T, CLS_TBLUSERREPORT_SETTING CTS  WHERE CTS.FLDREPORTCODE = T.FLDREPORTID AND CTS.REL_MENU <> ''

	SET @LOGOUTMENU = ''
	SET @LOGOUTMENU = '
		<ul class=''nav navbar-nav navbar-right'' style=''margin: 8px 4px 0px 0px !important''><li>
				<div class="dropdown">
					<button class="btnDrpdown dropdown-toggle" type="button" data-toggle="dropdown" ><i class="fa fa-cog fa-2x"></i></button>
					<ul class="dropdown-menu" style=''background-color:#fff''>
						<li>
							<a href="#" onclick = "javascript:callsettingmenu(''LOGIN/MAIN.ASPX'')">
							<i class="glyphicon glyphicon-home"></i>
							Home </a>
						</li>
						<li>
							<a href="#" onclick = "javascript:callsettingmenu(''SHARE_REPORTS/DASHBOARD/DASHBOARDMAIN.ASPX'',''DASHBOARD'')">
							<i class="glyphicon glyphicon-dashboard"></i>
							Dashboard </a>
						</li>
						<li>
							<a href="#">
							<i class="glyphicon glyphicon-user"></i>
							Account Settings </a>
						</li>
						<li>
							<a href="#" onclick ="javascript:callsettingmenu(''Utility/TaskDetails.aspx'',''Task_Details'')">
							<i class="glyphicon glyphicon-ok"></i>
							Tasks </a>
						</li>
						<!--<li>
							<a href="#" onclick = "javascript:callsettingmenu(''LOGIN/Help.ASPX'')">
							<i class="glyphicon glyphicon-flag"></i>
							Help </a>
						</li>-->
						<li>
							<a href="#" onclick = "javascript:callsettingmenu(''LOGIN/ChangePassword.ASPX'','''')">
							<i class="glyphicon glyphicon-lock"></i>
							Change Password </a>
						</li>
						<li>
							<a href="#" onclick = "javascript:callsettingmenu(''LOGIN/SwitchToArchival.ASPX'','''')">
							<i class="glyphicon glyphicon-lock"></i>
							Switch To Archival Server </a>
						</li>
						<li>
							<div class="profile-userbuttons">
								<button type="button" class="btn btn-danger btn-sm" onclick ="javascript:Logout()">Log Out</button>
							</div>
						</li>
					</ul>
				</div>
			</li></ul>' 
	SET @LOOP = 0
	SET @LOOPSUB = 0
SET @MENUCUR = CURSOR
FOR
	SELECT 
		FLDMENUNAME
		,FLDGRPNAME = REPLACE(FLDGRPNAME,'_',' ')
		,FLDREPORTNAME = REPLACE(FLDREPORTNAME,'_',' ')
		,FLDPATH
		,FLDREPORTCODE = A.FLDREPORTCODE
		,FLDREPORTID = F.FLDREPORTCODE
		,FLDMENUGRP = A.FLDMENUGRP
		,FLDORDER	
	FROM TBLREPORTS A(NOLOCK)
		,TBLREPORTGRP B(NOLOCK)
		,TBLCATMENU C(NOLOCK)
		,TBLCATEGORY D(NOLOCK)
		,TBLMENUHEAD E(NOLOCK)
		,CLS_TBLREPORTS F(NOLOCK)
	WHERE A.FLDMENUGRP = B.FLDMENUGRP
		AND A.FLDREPORTGRP = B.FLDREPORTGRP
		AND C.FLDREPORTCODE = A.FLDREPORTCODE
		AND E.FLDMENUCODE = A.FLDMENUGRP
		AND D.FLDCATEGORYCODE = @STRCATEGORY
		AND C.FLDCATEGORYCODE LIKE '%,' + CONVERT(VARCHAR, D.FLDCATEGORYCODE) + ',%'
		AND CHARINDEX('ASPX',CAST(UPPER(FLDPATH) AS VARCHAR(500))) > 0
		AND FLDREPORTPATH = A.FLDPATH
		AND C.FLDADMINAUTO  = @FLDADMINAUTO
		AND F.CHILDMAP = 0
		UNION ALL
SELECT 
		FLDMENUNAME
		,FLDGRPNAME = REPLACE(FLDGRPNAME,'_',' ')
		,FLDREPORTNAME = REPLACE(FLDREPORTNAME,'_',' ')
		,FLDPATH
		,FLDREPORTCODE = A.FLDREPORTCODE
		,FLDREPORTID =  UPPER('SUBMENU') +UPPER(FLDTARGET) + CONVERT(VARCHAR,A.FLDREPORTCODE)
		,FLDMENUGRP = A.FLDMENUGRP
		,FLDORDER	
	FROM TBLREPORTS A(NOLOCK)
		,TBLREPORTGRP B(NOLOCK)
		,TBLCATMENU C(NOLOCK)
		,TBLCATEGORY D(NOLOCK)
		,TBLMENUHEAD E(NOLOCK)
	
	WHERE A.FLDMENUGRP = B.FLDMENUGRP
		AND A.FLDREPORTGRP = B.FLDREPORTGRP
		AND C.FLDREPORTCODE = A.FLDREPORTCODE
		AND E.FLDMENUCODE = A.FLDMENUGRP
		AND D.FLDCATEGORYCODE = @STRCATEGORY
		AND C.FLDCATEGORYCODE LIKE '%,' + CONVERT(VARCHAR, D.FLDCATEGORYCODE) + ',%'
		--AND CHARINDEX('ASPX',CAST(UPPER(FLDPATH) AS VARCHAR(500))) > 0
		AND FLDPATH = ''
		AND FLDTARGET='P'
		AND C.FLDADMINAUTO  = @FLDADMINAUTO

	ORDER BY 
		FLDMENUGRP, FLDGRPNAME, FLDMENUNAME, A.fldorder
		
OPEN @MENUCUR

SET @MENUSTRING = '
		<div class=''nav-container menuMega''>
          <div class=''header-bottom-row''>
            <div class=''no-padding''>
              <nav class=''navbar navbar-inverse navbar-static-top'' >
                <div>
                  <div class=''navbar-header''>
                    <button type=''button'' class=''navbar-toggle collapsed'' data-toggle=''collapse'' data-target=''#bs-example-navbar-collapse-1'' aria-expanded=''false''>
                      <span class=''sr-only''>Toggle navigation</span>
                      <span class=''icon-bar''></span>
                      <span class=''icon-bar''></span>
                      <span class=''icon-bar''></span>
                    </button>
                  </div>
                  <div class=''collapse navbar-collapse bgcolor'' id=''bs-example-navbar-collapse-1''>
                  <ul class=''nav navbar-nav'' id=''mega''>
					<li><a id=''hideHeader'' onclick="Show_Hide_Header();"><span class=''glyphicon glyphicon-arrow-up myshape''></span></a></li>'

SET @FLDGRPNAME_1 = ''
SET @FLDMENUNAME_1 = ''

FETCH NEXT
FROM @MENUCUR
INTO @FLDMENUNAME
	,@FLDGRPNAME
	,@FLDREPORTNAME
	,@FLDPATH
	,@FLDREPORTCODE
	,@FLDREPORTID
	,@FLDMENUGRP
	,@FLDORDER

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @FLDMENUNAME_1 <> @FLDMENUNAME
	BEGIN
		IF @FLDMENUNAME_1 <> ''
		BEGIN
			SET @MENUSTRING = @MENUSTRING + '</div></div></div></li></ul></div></li>'
			
		END
		
		IF @LOOP <= 3
			SET @MENUSTRING = @MENUSTRING + '<li class=''active dropdown tabbed-mega''><a href=''#'' class=''dropdown-toggle'' data-toggle=''dropdown'' role=''button'' aria-haspopup=''true'' aria-expanded=''false''>' + lower('&nbsp;&nbsp;') + @FLDMENUNAME + lower('&nbsp;&nbsp;') + '<span class=''caret''></span></a>
											<div class=''dropdown-menu tabbed-menu tabbed-mega-menu tabbed-height-375'' >
												<ul class=''menu-overflow''>
													<li class=''active''>'
		ELSE
			SET @MENUSTRING = @MENUSTRING + '<li class=''active dropdown tabbed-mega''><a href=''#'' class=''dropdown-toggle'' data-toggle=''dropdown'' role=''button'' aria-haspopup=''true'' aria-expanded=''false''>' + lower('&nbsp;&nbsp;') + @FLDMENUNAME + lower('&nbsp;&nbsp;') + '<span class=''caret''></span></a>
											<div id=''leftmenu'' class=''dropdown-menu tabbed-menu tabbed-mega-menu tabbed-height-375 left-menu''>
												<ul class=''menu-overflow''>
													<li class=''active''>'

		SET @FLDMENUNAME_1 = @FLDMENUNAME
		SET @FLDGRPNAME_1 = ''
		SET @LOOPSUB = 0
		SET @LOOP = @LOOP + 1
	END

	IF @FLDGRPNAME_1 <> @FLDGRPNAME
	BEGIN
		IF @FLDGRPNAME_1 <> ''
		BEGIN
			SET @MENUSTRING = @MENUSTRING + '</DIV></DIV></DIV></LI><LI>'
		END
		IF @LOOPSUB = 0 
		 BEGIN
			SET @MENUSTRING = @MENUSTRING + '<a href=''#'' class=''attach_box active-tab active-tab-css''>' + Upper(@FLDGRPNAME) + '</a>
												<div class=''tabbed-menu-content container active-tab-content'' class=''sec_box'' >
													<div class=''row''>
			
														<div class=''col-lg-12 col-md-12 col-sm-12 col-xs-12 submenu_height''>'
		 END
		ELSE
		 BEGIN
				SET @MENUSTRING = @MENUSTRING + '<a href=''#'' class=''attach_box attach_box_new''>' + upper(@FLDGRPNAME) + '</a>
												<div class=''tabbed-menu-content container'' class=''sec_box'' >
													<div class=''row''>
														<div class=''col-lg-12 col-md-12 col-sm-12 col-xs-12 submenu_height''>'
		 END	
		
		SET @LOOPSUB = @LOOPSUB + 1
		SET @FLDGRPNAME_1 = @FLDGRPNAME
	END
	
	/*---------------------	*/
		IF ((LEN(@FLDREPORTNAME) > 20) AND  CHARINDEX('REPORT',UPPER(@FLDREPORTNAME)) > 0)
		BEGIN 
				SET @FLDREPORTNAME = REPLACE(UPPER(@FLDREPORTNAME),'REPORT','')
		END 
	/*----------------------*/

	IF @FLDPATH = '' 
	 BEGIN
			SET @SUBMENUSTRING = '<ul class=''nav nav-tabs list'' id=''mytab'' >'

			SET @SUBMENU = CURSOR
			FOR
			SELECT FLDREPORTID, FLDPATH,FLDREPORTNAME FROM #TEMP WHERE CHILDMAP = @FLDREPORTCODE
			OPEN @SUBMENU
				FETCH NEXT FROM @SUBMENU INTO @CHILDCODE, @SUBMENUFLDPATH, @SUBREPORTNAME
					WHILE @@FETCH_STATUS = 0
					 BEGIN
						SET @SUBMENUSTRING = @SUBMENUSTRING + '<li><a href=''#'' class=''submenu-textcolor firstsubmenu'' onclick = "javascript:callsubMenuDB(''' + @STRAPPNAME + @SUBMENUFLDPATH + ''',''' + CONVERT(VARCHAR, @CHILDCODE) + ''')" > <i class=''glyphicon glyphicon-hand-right''></i>&nbsp;' + LEFT(.DBO.CLS_PROPERCASE(@SUBREPORTNAME), 25) + '</a></li>'

				FETCH NEXT FROM @SUBMENU INTO @CHILDCODE, @SUBMENUFLDPATH, @SUBREPORTNAME
			END
			CLOSE @SUBMENU
			DEALLOCATE @SUBMENU
			SET @SUBMENUSTRING = @SUBMENUSTRING + '</ul>'
			UPDATE #TEMP SET SUBMENU = @SUBMENUSTRING WHERE CHILDMAP = @FLDREPORTCODE 
			SET @SUBMENUSTRING = ''			
	END 

	SET @MENUSTRING = @MENUSTRING + '<h3><a class=''font_color'' href=''#'' onclick = "javascript:callreportmenu(''' + @STRAPPNAME + @FLDPATH + ''',''' + @FLDREPORTID + ''')"> <span class=''fa fa-angle-double-right''></span>' + LEFT(.DBO.CLS_ProperCase(@FLDREPORTNAME), 25) + '</a></h3>'
	FETCH NEXT
	FROM @MENUCUR
	INTO @FLDMENUNAME
		,@FLDGRPNAME
		,@FLDREPORTNAME
		,@FLDPATH
		,@FLDREPORTCODE
		,@FLDREPORTID
		,@FLDMENUGRP
		,@FLDORDER
END

CLOSE @MENUCUR

DEALLOCATE @MENUCUR


SET @MENUSTRING = @MENUSTRING + '</div></div></div></li></ul></li></ul> ' + @LOGOUTMENU + ' </div>
                </div>
              </nav>
            </div>
          </div>          
        </div>
    </div>'



DECLARE @RELMENU_ID VARCHAR(100) ,@RELMENU_NAME VARCHAR(200),@RELMENU_PATH VARCHAR(2000), @LOOPID INT, @REL_REPORTNAME VARCHAR(150), @REL_DATA VARCHAR(200),@RELMENUSTR VARCHAR(MAX), @REPORTID VARCHAR(150);    

DECLARE EMP_CURSOR CURSOR FOR     
SELECT RELMENU, FLDREPORTID, FLDPATH  FROM #TEMP WHERE ISNULL(RELMENU,'') <> '' ORDER BY RELMENU;

OPEN EMP_CURSOR FETCH NEXT FROM EMP_CURSOR
INTO @RELMENU_NAME, @RELMENU_ID, @RELMENU_PATH



WHILE @@FETCH_STATUS = 0    
BEGIN 
	SET @REPORTID = @RELMENU_ID
	SET @LOOPID = 1

	SET @RELMENUSTR = ''
	SET @RELMENUSTR = @RELMENUSTR + '<ul class="rel-ul">'
	SET @RELMENUSTR = @RELMENUSTR +    '<li>'
	SET @RELMENUSTR = @RELMENUSTR +          '<label>Relevant Menu </label>'
	SET @RELMENUSTR = @RELMENUSTR +    '</li>'
	SET @RELMENUSTR = @RELMENUSTR + '</ul>'
	SET @RELMENUSTR = @RELMENUSTR + '<div class="related-menu" id="rel_menu"><ul> '

	WHILE 1 = 1
	 BEGIN
		SET @REL_DATA = .DBO.PIECE(rtrim(ltrim(@RELMENU_NAME)), '|', @LOOPID)
			 print @REL_DATA + '<---->' + convert(varchar,@LOOPID)
		IF @REL_DATA = '' OR @REL_DATA IS NULL
			BEGIN
				BREAK;
			END 
			--SELECT fldpath,  fldreportid,  fldreporttitle from #temp where fldreportid = @REL_DATA
			SELECT @relmenu_path = fldpath, @relmenu_id = fldreportid, @REL_REPORTNAME = fldreporttitle from #temp where fldreportid = @REL_DATA
			SET @RELMENUSTR = @RELMENUSTR + '<li><a href="#" onclick = "javascript:callreportmenu(''' + @STRAPPNAME + @relmenu_path + ''',''' + @relmenu_id + ''')"><span class="relmenuspan">' + @REL_REPORTNAME  + '</span></a></li>' 
			SET @LOOPID = @LOOPID + 1
			--print @relmenu_id
	 END
	 SET @RELMENUSTR =  @RELMENUSTR + '</ul></div>'
	
	 IF @RELMENUSTR <> ''
		UPDATE #TEMP SET RELMENUSTRING = @RELMENUSTR WHERE FLDREPORTID = @REPORTID
	
 FETCH NEXT FROM EMP_CURSOR     
 INTO @RELMENU_NAME, @RELMENU_ID, @RELMENU_PATH
END    
CLOSE EMP_CURSOR;    
DEALLOCATE EMP_CURSOR; 


IF( (SELECT MENU_SENITISE FROM CLS_GLOBAL_SETTING) = 0 )
	SELECT MENUSTRING = @MENUSTRING 
ELSE
	--SELECT MENUSTRING = @MENUSTRING 
	SELECT MENUSTRING =  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@MENUSTRING,'/','cpl_BS'),'\','cpl_FS'),'''','cpl_colun'),'&nbsp;','cpl_NBSP'),'"','&quot;'),'<','cpl_lt'),'>','cpl_gt')

SELECT FLDMENUNAME,FLDREPORTTITLE,FLDGRPNAME,FLDREPORTNAME,FLDPATH,FLDREPORTCODE,FLDREPORTID,FLDMENUGRP,FLDORDER,CHILDMAP = ISNULL(CHILDMAP,0),SUBMENU = ISNULL(SUBMENU, ''), RELMENU = ISNULL(RELMENU,''), RELMENUSTRING = ISNULL(RELMENUSTRING,'') FROM #TEMP 
/*---------------------------------------------- END OF THE PROC ----------------------------*/

GO
