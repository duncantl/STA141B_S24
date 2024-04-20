if(FALSE) {

    Sys.setlocale(locale = "de_DE")
    eg = "16-Oct-1996"
    a = cvtDate(eg)
    format(a, "%d-%b-%Y")

    cvtDate("5/Okt/2024", "%d/%b/%Y") # NA
    cvtDate("5/Okt/2024", "%d/%b/%Y", "de_DE") # correct
    Sys.getlocale()

    cvtDate("janvier/9/2024", "%B/%d/%Y") # NA
    cvtDate("janvier/9/2024", "%B/%d/%Y", "fr_CA")    
}

cvtDate =
function(str, fmt = "%d-%b-%Y", locale = "en_US")
{
    if(length(locale) > 0 && !is.na(locale)) {
        prev = Sys.getlocale("LC_TIME")
        on.exit(Sys.setlocale("LC_TIME", locale = prev))
        Sys.setlocale("LC_TIME", locale = locale)
    }

    as.Date(str, fmt)
}
