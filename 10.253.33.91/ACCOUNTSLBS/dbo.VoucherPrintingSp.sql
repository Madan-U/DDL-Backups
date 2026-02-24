-- Object: PROCEDURE dbo.VoucherPrintingSp
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--exec VoucherPrintingSp '17','01','01','','','200705020001','200705020001',1,1 
          
--exec VoucherPrintingSp '4','01','01','','','200504020001','200504020001',1,1              
            
/****** Object:  Stored Procedure dbo.VoucherPrintingSp    Script Date: 06/24/2004 8:32:35 PM ******/                
                
/****** Object:  Stored Procedure dbo.VoucherPrintingSp    Script Date: 05/10/2004 5:29:36 PM ******/                
/* comm. narr replaced line narration  by amit requirment in mosl on 18/10/2002*/                
                
CREATE Proc VoucherPrintingSp                 
@Vtyp varchar(2),                
@BookTypeFrom varchar(2),                
@BookTypeTo varchar(2),                
@StartDate Varchar(11),                
@EndDate Varchar(11),                
@VnoFrom Varchar(12),                
@VnoTo Varchar(12),                
@VnoVdtFlag int,                
@Flag int                
as                
                
If @Flag = 0                
Begin                
   if @startdate = ''                 
      begin                
/* Conditions of VNO only */                
   select   CltCode = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                 
                    THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                     ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                 
                       THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                        ELSE L.acname END ),0),                  
     isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
     cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
    from ledger l ,LEDGER1 L1                
    where l1.vtyp = l.vtyp and l1.vno = l.vno and l1.booktype = l.booktype                  
    and l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
  order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno      
      end                
   else                
   if @Vnofrom = ''                 
      begin                
         /* Conditions on Vdt only */                
  select   CltCode = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                  
               THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                    ELSE L.CLTCODE END ),0),                 
    acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                 
                      THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                       ELSE L.acname END ),0),                  
    isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
    bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,                
    narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),''), */                
  cnar = isnull(l.narration,'') ,                
  cltcode2 = cltcode, acname2 = acname            
  from ledger l ,LEDGER1 L1                
   where   l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo and vdt >= @StartDate + ' 00:00:00'                
   and l1.vtyp = l.vtyp and l1.vno = l.vno and l1.booktype = l.booktype                 
    and vdt <=@EndDate + ' 23:59:59'                
    order by l.vdt, l.vtyp, l.booktype, l.vno, l.lno                
                
      end                
   else                
      begin                
         /* Conditions on Vdt and VNo */                
   select   CltCode = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                 
                 THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                     ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                 
                       THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                        ELSE L.acname END ),0),                  
     isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
    from ledger l ,LEDGER1 L1                
    where l1.vtyp = l.vtyp and l1.vno = l.vno and l1.booktype = l.booktype                  
    and l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
/* Foll condition added by Kalpana on 19/09/2002 */                
  and vdt >= (case when @StartDate <> ''  then @StartDate  + ' 00:00:00'                
    else 'Jan  1 1900' + ' 00:00:00'                
    end)                 
  and vdt <= (case when @EndDate <> ''  then @EndDate + ' 23:59:59'                
    else getdate()                
    end)                 
    order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno -- desc                
      end                
end              
                
Else If @Flag = 1                
Begin                
  if @startdate = ''                 
     begin                
  /* Conditions of VNO only */                
  select   CltCode = ISNULL((CASE WHEN  L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                 
                    THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                     ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                 
                        THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                       ELSE L.acname END ),0),                  
   isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
    from ledger l                 
    where  l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo              
   --and l.drcr in (case when @Vtyp='6' then 'C' else case when @Vtyp='7' then 'D' else 'C''D' end end)              
  order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno --desc                
     end                
 else                
 if @Vnofrom = ''                 
     begin                
                /* Conditions on Vdt only */                
                  
   select   CltCode = ISNULL((CASE WHEN  L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                 
                     THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                      ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                 
                        THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                         ELSE L.acname END ),0),                  
     isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     narr = isnull(l.narration,'') ,                
 /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') , */                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
    from ledger l                 
    where   l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo and vdt >= @StartDate + ' 00:00:00'                 
    and vdt <=@EndDate + ' 23:59:59'                
    order by l.vdt, l.vtyp, l.booktype, l.vno                
     End                
   Else                 
          /* Conditions on Vdt and VNo */                
      Begin                 
    select   CltCode = ISNULL((CASE WHEN  L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                 
                    THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                     ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                 
                        THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                       ELSE L.acname END ),0),                  
   isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
     from ledger l                 
    where  l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
/* Foll condition added by Kalpana on 19/09/2002 */                
  and vdt >= (case when @StartDate <> ''  then @StartDate  + ' 00:00:00'                
    else 'Jan  1 1900' + ' 00:00:00'       
    end)                 
  and vdt <= (case when @EndDate <> ''  then @EndDate + ' 23:59:59'                
    else getdate()                
    end)                 
    order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno --desc                
      End                  
End                
              
Else If @flag = 2                
Begin                
 if @startdate = ''                 
  Begin                
  /* Conditions of VNO only */                
  select   CltCode = ISNULL((CASE WHEN a.accat = 14  THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
          ELSE L.CLTCODE END ),0),                
     acname = ISNULL((CASE WHEN a.accat = 14   THEN (SELECT acmast.acname FROM MARGINLEDGER m ,acmast WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND m.BOOKTYPE = L.BOOKTYPE and m.party_code = acmast.cltcode)                 
          ELSE L.acname END ),0),                
     l.vamt,l.drcr,l.vtyp,l.vno,l.lno,l.booktype,vdt = convert(varchar,l.vdt,103),edt = convert(varchar,l.edt,103),                
     narr = isnull(l.narration,'') ,                
     /* cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
                        cnar = isnull(l.narration,'') ,                
   cltcode2 = l.cltcode, acname2 = l.acname                
   from ledger l, acmast a                
    where l.cltcode = a.cltcode and l.vtyp = 24  and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
    order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno --desc                
  End                 
    else                
 if @Vnofrom = ''                 
     begin                
                /* Conditions on Vdt only */                  
    select   CltCode = ISNULL((CASE WHEN a.accat = 14 THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                    ELSE L.CLTCODE END ),0),                
     acname = ISNULL((CASE WHEN a.accat = 14  THEN (SELECT acmast.acname FROM MARGINLEDGER m ,acmast WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND m.BOOKTYPE = L.BOOKTYPE and m.party_code = acmast.cltcode)                 
           ELSE L.acname END ),0),                
    l.vamt,l.drcr,l.vtyp,l.vno,l.lno,l.booktype,vdt = convert(varchar,l.vdt,103),edt = convert(varchar,l.edt,103),                
    narr = isnull(l.narration,'') ,                
    /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
  cnar = isnull(l.narration,'') ,                
  cltcode2 = l.cltcode, acname2 = l.acname                
  from ledger l, acmast a                
    where l.cltcode = a.cltcode and l.vtyp = 24  and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo and vdt >= @StartDate + ' 00:00:00'                 
    and vdt <=@EndDate + ' 23:59:59'                
    order by l.vdt, l.vtyp, l.booktype, l.vno, l.lno                
                
                    
  End                 
  Else                 
          /* Conditions on Vdt and VNo */                
  Begin                
    select   CltCode = ISNULL((CASE WHEN a.accat = 14  THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
          ELSE L.CLTCODE END ),0),                
     acname = ISNULL((CASE WHEN a.accat = 14   THEN (SELECT acmast.acname FROM MARGINLEDGER m ,acmast WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND m.BOOKTYPE = L.BOOKTYPE and m.party_code = acmast.cltcode)                 
          ELSE L.acname END ),0),                
     l.vamt,l.drcr,l.vtyp,l.vno,l.lno,l.booktype,vdt = convert(varchar,l.vdt,103),edt = convert(varchar,l.edt,103),                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = l.cltcode, acname2 = l.acname           
   from ledger l, acmast a                
    where l.cltcode = a.cltcode and l.vtyp = 24  and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
/* Foll condition added by Kalpana on 19/09/2002 */                
  and vdt >= (case when @StartDate <> ''  then @StartDate  + ' 00:00:00'                
    else 'Jan  1 1900' + ' 00:00:00'                
    end)                
  and vdt <= (case when @EndDate <> ''  then @EndDate + ' 23:59:59'                
    else getdate()                
    end)                 
    order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno                
  End                 
                
End                
else if @flag = 3                
Begin                
   if @startdate = ''                 
      begin                
/* Conditions of VNO only */                
   select   CltCode = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                
                    THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                     ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                 
                       THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                        ELSE L.acname END ),0),                  
     isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
    from ledger l ,LEDGER1 L1                
    where l1.vtyp = l.vtyp and l1.vno = l.vno and l1.booktype = l.booktype and l.lno = l1.lno                
    and l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
  order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno --desc                
      end                
   else                
   if @Vnofrom = ''                 
      begin                
         /* Conditions on Vdt only */                
  select   CltCode = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                  
               THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                    ELSE L.CLTCODE END ),0),                 
    acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                 
                      THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                       ELSE L.acname END ),0),                  
    isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
    bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,                
    narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),''), */                
  cnar = isnull(l.narration,'') ,                
  cltcode2 = cltcode, acname2 = acname                
    from ledger l ,LEDGER1 L1               
   where   l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo and vdt >= @StartDate + ' 00:00:00'                
   and l1.vtyp = l.vtyp and l1.vno = l.vno and l1.booktype = l.booktype  and l.lno = l1.lno                
    and vdt <=@EndDate + ' 23:59:59'                
    order by l.vdt, l.vtyp, l.booktype, l.vno, l.lno                
                
      end                
   else                
      begin                
         /* Conditions on Vdt and VNo */                
   select   CltCode = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                 
                 THEN (SELECT PARTY_CODE FROM MARGINLEDGER m WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                 
                     ELSE L.CLTCODE END ),0),                 
     acname= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                 
                       THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND m.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                 
                        ELSE L.acname END ),0),                  
 isnull(l.Vamt,0) Vamt, l.drcr, l.vtyp,l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,                
     bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,                
     narr = isnull(l.narration,'') ,                
     /*cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0 and l3.booktype = l.booktype),'') ,*/                
   cnar = isnull(l.narration,'') ,                
   cltcode2 = cltcode, acname2 = acname                
  from ledger l ,LEDGER1 L1                
    where l1.vtyp = l.vtyp and l1.vno = l.vno and l1.booktype = l.booktype   and l.lno = l1.lno                
    and l.vtyp = @Vtyp and l.booktype >= @BookTypeFrom and l.booktype <= @BookTypeTo                 
    and l.vno >= @VnoFrom  and l.vno <= @VnoTo                 
/* Foll condition added by Kalpana on 19/09/2002 */                
  and vdt >= (case when @StartDate <> ''  then @StartDate  + ' 00:00:00'                
    else 'Jan  1 1900' + ' 00:00:00'                
    end)                 
  and vdt <= (case when @EndDate <> ''  then @EndDate + ' 23:59:59'                
    else getdate()                
    end)                 
    order by l.vdt, l.vtyp, l.booktype, l.vno, /*l.drcr desc, */l.lno --desc                
      end               
end

GO
